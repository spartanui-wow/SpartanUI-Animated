local SUI = LibStub('AceAddon-3.0'):GetAddon('SpartanUI') ---@type SUI
local L = LibStub('AceLocale-3.0'):GetLocale('SpartanUI-Animated', true)
local Smooth = LibStub('LibSmoothStatusBar-1.0')
---@class SUI.Module.Animation : SUI.Module
local addon = SUI:NewModule('AnimatedBars')
addon.DisplayName = L['Animated Bars']
addon.description = 'Animated Bars'

local t_power = {}
local UnitExists = UnitExists
local UnitPowerType = UnitPowerType
local powerTable = {}
for i = 0, 18 do
	powerTable[i] = {}
end
local s_table = {}
local s_table_party_target = {}
local DBDefaults = {
	enable = true,
	animationIntervalStop = 0.09,
	health = 'interface\\addons\\SpartanUI-Animated\\Animations\\Health\\HealthBar',
	mana = 'interface\\addons\\SpartanUI-Animated\\Animations\\Mana\\Manabar',
	cast = 'interface\\addons\\SpartanUI-Animated\\Animations\\Cast\\CastBar',
	focus = 'interface\\addons\\SpartanUI-Animated\\Animations\\Energy\\EnergyBar',
	runicpower = 'interface\\addons\\SpartanUI-Animated\\Animations\\Mana\\Manabar',
	energy = 'interface\\addons\\SpartanUI-Animated\\Animations\\Energy\\EnergyBar',
	rage = 'interface\\addons\\SpartanUI-Animated\\Animations\\Rage\\RageBar',
	malestorm = 'interface\\addons\\SpartanUI-Animated\\Animations\\Mana\\Manabar',
	insanity = 'interface\\addons\\SpartanUI-Animated\\Animations\\Mana\\Manabar',
	astralpower = 'interface\\addons\\SpartanUI-Animated\\Animations\\Mana\\Manabar',
	fury = 'interface\\addons\\SpartanUI-Animated\\Animations\\Mana\\Manabar',
	pain = 'interface\\addons\\SpartanUI-Animated\\Animations\\Mana\\Manabar',
}
local textures = {
	['interface\\addons\\SpartanUI-Animated\\Animations\\Health\\HealthBar'] = HEALTH,
	['interface\\addons\\SpartanUI-Animated\\Animations\\Cast\\CastBar'] = L['Castbar'],
	['interface\\addons\\SpartanUI-Animated\\Animations\\Mana\\Manabar'] = MANA,
	['interface\\addons\\SpartanUI-Animated\\Animations\\Rage\\RageBar'] = RAGE,
	['interface\\addons\\SpartanUI-Animated\\Animations\\Energy\\EnergyBar'] = ENERGY,
	['interface\\addons\\SpartanUI-Animated\\Animations\\DeusEx\\DeusEx'] = L['DeusEx'],
}

function addon:ResetSettings()
	addon.DB = DBDefaults
end

function addon:OnInitialize()
	addon.Database = SUI.SpartanUIDB:RegisterNamespace('AnimatedBars', { profile = DBDefaults })
	addon.DB = addon.Database.profile

	addon:CreateMemFrame(textures)
end

function addon:OnEnable()
	local f = CreateFrame('Frame', 'Bar Animation', WorldFrame)
	f:SetFrameStrata('BACKGROUND')
	f:RegisterEvent('PLAYER_ENTERING_WORLD')
	f:RegisterEvent('GROUP_ROSTER_UPDATE')

	if addon.DB.enable then
		if SUI_UF_player then
			SUI_UF_player.Castbar:SetStatusBarColor(1, 1, 1, 1)
		end
		f:SetScript('OnEvent', function(this, event, ...)
			addon[event](addon, ...)
		end)
		addon.Ticker = C_Timer.NewTicker(math.max(addon.DB.animationIntervalStop, 0.01), addon.NewUpdater)
		f:SetScript('OnShow', function()
			addon.Ticker:Cancel()
			addon.Ticker = C_Timer.NewTicker(math.max(addon.DB.animationIntervalStop, 0.01), addon.NewUpdater)
		end)
		f:SetScript('OnHide', function()
			addon.Ticker:Cancel()
		end)
	else
		addon:PLAYER_ENTERING_WORLD()
	end

	addon:Options()
end

function addon:Options()
	---@type AceConfig.OptionsTable
	local Options = {
		name = 'Bar Animation',
		type = 'group',
		order = 990,
		args = {
			enable = {
				name = L['Enable Texture Animation'],
				type = 'toggle',
				order = 1,
				width = 'full',
				get = function(info)
					return addon.DB.enable
				end,
				set = function(info, val)
					addon.DB.enable = val
				end,
			},
			enableinfo = { name = L['ReloadUI Required'], type = 'description', order = 2 },
			health = {
				name = L['Healthbar Texture'],
				type = 'select',
				order = 5,
				style = 'dropdown',
				values = textures,
				get = function(info)
					return addon.DB.health
				end,
				set = function(info, val)
					addon.DB.health = val
					addon:SetAnimationTexture(14, val)
				end,
			},
			cast = {
				name = L['Casting'],
				type = 'select',
				order = 6,
				style = 'dropdown',
				values = textures,
				get = function(info)
					return addon.DB.cast
				end,
				set = function(info, val)
					addon.DB.cast = val
					addon:SetAnimationTexture(15, val)
				end,
			},
			mana = {
				name = L['Mana'],
				type = 'select',
				order = 7,
				style = 'dropdown',
				values = textures,
				get = function(info)
					return addon.DB.mana
				end,
				set = function(info, val)
					addon.DB.mana = val
					addon:SetAnimationTexture(0, val)
				end,
			},
			rage = {
				name = L['Rage'],
				type = 'select',
				order = 8,
				style = 'dropdown',
				values = textures,
				get = function(info)
					return addon.DB.rage
				end,
				set = function(info, val)
					addon.DB.rage = val
					addon:SetAnimationTexture(1, val)
				end,
			},
			energy = {
				name = L['Energy'],
				type = 'select',
				order = 9,
				style = 'dropdown',
				values = textures,
				get = function(info)
					return addon.DB.energy
				end,
				set = function(info, val)
					addon.DB.energy = val
					addon:SetAnimationTexture(3, val)
				end,
			},
			focus = {
				name = L['Focus'],
				type = 'select',
				order = 10,
				style = 'dropdown',
				values = textures,
				get = function(info)
					return addon.DB.focus
				end,
				set = function(info, val)
					addon.DB.focus = val
					addon:SetAnimationTexture(4, val)
				end,
			},
			runicpower = {
				name = L['RunicPower'],
				type = 'select',
				order = 11,
				style = 'dropdown',
				values = textures,
				get = function(info)
					return addon.DB.runicpower
				end,
				set = function(info, val)
					addon.DB.runicpower = val
					addon:SetAnimationTexture(6, val)
					addon:SetAnimationTexture(5, val)
				end,
			},
			astralpower = {
				name = L['AstralPower'],
				type = 'select',
				order = 12,
				style = 'dropdown',
				values = textures,
				get = function(info)
					return addon.DB.astralpower
				end,
				set = function(info, val)
					addon.DB.astralpower = val
					addon:SetAnimationTexture(8, val)
				end,
			},
			malestorm = {
				name = L['Maelstrom'],
				type = 'select',
				order = 13,
				style = 'dropdown',
				values = textures,
				get = function(info)
					return addon.DB.malestorm
				end,
				set = function(info, val)
					addon.DB.malestorm = val
					addon:SetAnimationTexture(11, val)
				end,
			},
			insanity = {
				name = L['Insanity'],
				type = 'select',
				order = 14,
				style = 'dropdown',
				values = textures,
				get = function(info)
					return addon.DB.insanity
				end,
				set = function(info, val)
					addon.DB.insanity = val
					addon:SetAnimationTexture(13, val)
				end,
			},
			fury = {
				name = L['Fury'],
				type = 'select',
				order = 15,
				style = 'dropdown',
				values = textures,
				get = function(info)
					return addon.DB.fury
				end,
				set = function(info, val)
					addon.DB.fury = val
					addon:SetAnimationTexture(17, val)
				end,
			},
			pain = {
				name = L['Fury'],
				type = 'select',
				order = 15,
				style = 'dropdown',
				values = textures,
				get = function(info)
					return addon.DB.pain
				end,
				set = function(info, val)
					addon.DB.pain = val
					addon:SetAnimationTexture(18, val)
				end,
			},
			animationIntervalStop = {
				name = L['Animation Speed'],
				type = 'range',
				order = 22,
				width = 'double',
				min = 1,
				max = 23,
				step = 1,
				get = function(info)
					return abs(1 / tonumber(addon.DB.animationIntervalStop)) or abs(1 / 0.09)
				end,
				set = function(info, val)
					addon.DB.animationIntervalStop = abs(1 / tonumber(val))
					addon.Ticker:Cancel()
					addon.Ticker = C_Timer.NewTicker(math.max(addon.DB.animationIntervalStop, 0.01), addon.NewUpdater)
				end,
			},
			resetframes = {
				name = L['Reset to default'],
				type = 'execute',
				order = 23,
				desc = L['Resets/Refresh Active UnitFrames'],
				width = 'double',
				disabled = function()
					return not SUI.Options:hasChanges(addon.DB, DBDefaults)
				end,
				func = function()
					addon:ResetSettings()
				end,
			},
		},
	}

	---@diagnostic disable-next-line: undefined-field
	SUI.Options:AddOptions(Options, 'Chatbox')
end

function addon:PLAYER_ENTERING_WORLD()
	t_power[0] = addon.DB.mana --"mana",
	t_power[1] = addon.DB.rage --"rage",
	t_power[2] = addon.DB.focus --"focus",
	t_power[3] = addon.DB.energy --"energy",
	t_power[6] = addon.DB.runicpower --"runic power"
	t_power[14] = addon.DB.health -- health unsused
	t_power[15] = addon.DB.cast --castbar unused
	t_power[8] = addon.DB.astralpower
	t_power[11] = addon.DB.malestorm
	t_power[13] = addon.DB.insanity
	t_power[17] = addon.DB.fury
	t_power[18] = addon.DB.pain

	for powerType, texture in pairs(t_power) do
		addon:SetAnimationTexture(powerType, texture)
	end
	for i = 0, 18 do
		if not powerTable[i]['textured'] then
			addon:SetAnimationTexture(i, t_power[0])
		end
	end
	if addon.DB.enable then
		addon:Refresh()
		for k, v in pairs(s_table) do
			Smooth:SmoothBar(v.Power)
			Smooth:SmoothBar(v.Health)
			if v.CastBar then
				Smooth:SmoothBar(v.CastBar)
			end
		end
	end
end

function addon:GROUP_ROSTER_UPDATE()
	C_Timer.After(1, addon.Refresh)
end

function addon:SetAnimationTexture(powerType, texture)
	powerTable[powerType]['textured'] = true
	for i = 1, 40 do
		powerTable[powerType][i] = texture .. tostring(i)
	end
end

function addon:CreateMemFrame(...)
	-- This frame and statusbar is only so that WoW will keep the textures in memory and not read them from disk.
	if not ... then
		return
	end
	local textures = {}
	for k, _ in pairs(...) do
		table.insert(textures, k)
	end
	local f = CreateFrame('Frame', 'AnimationMemory', WorldFrame)
	f:SetFrameStrata('BACKGROUND')
	f:SetSize(128, 16)
	for k, v in pairs(textures) do
		for i = 1, 40 do
			local t = CreateFrame('StatusBar', nil, f)
			t:SetSize(150, 16)
			t:SetStatusBarTexture(v .. tostring(i))
			t:SetPoint('TOPLEFT', f, (k * 150) - 150, (i * 16) - 16)
			f[k .. i] = t
		end
	end
	f:SetPoint('BOTTOMLEFT', 0, 0)
	f:Hide()
end

function addon:Refresh()
	local PlayerName = UnitName('player')

	s_table = {
		[PlayerName] = SUI_UF_player, --work around sins we can't have "player" appear twice in a table.
		['target'] = SUI_UF_target,
		['pet'] = SUI_UF_pet,
		['focus'] = SUI_UF_focus,
		['focustarget'] = SUI_UF_focustarget,
		['targettarget'] = SUI_UF_targettarget,
		['player'] = SUI_UF_party_HeaderUnitButton1,
		['party1'] = SUI_UF_party_HeaderUnitButton2,
		['party2'] = SUI_UF_party_HeaderUnitButton3,
		['party3'] = SUI_UF_party_HeaderUnitButton4,
		['party4'] = SUI_UF_party_HeaderUnitButton5,
		['boss1'] = SUI_UF_boss1,
		['boss2'] = SUI_UF_boss2,
		['boss3'] = SUI_UF_boss3,
		['boss4'] = SUI_UF_boss4,
		['boss5'] = SUI_UF_boss5,
	}
	s_table_party_target = {
		['target'] = SUI_UF_party_HeaderUnitButton1Target,
		['pet'] = SUI_UF_party_HeaderUnitButton1Pet,
		['party1target'] = SUI_UF_party_HeaderUnitButton2Target,
		['partypet1'] = SUI_UF_party_HeaderUnitButton2Pet,
		['party2target'] = SUI_UF_party_HeaderUnitButton3Target,
		['partypet2'] = SUI_UF_party_HeaderUnitButton3Pet,
		['party3target'] = SUI_UF_party_HeaderUnitButton4Target,
		['partypet3'] = SUI_UF_party_HeaderUnitButton4Pet,
		['party4target'] = SUI_UF_party_HeaderUnitButton5Target,
		['partypet4'] = SUI_UF_party_HeaderUnitButton5Pet,
	}
	if InCombatLockdown() then --Possible fix for incombat partyframe creation.
		C_Timer.After(10, addon.Refresh)
	end
	return true
end

local AnimationUpdate = function(self, powerType)
	local frameCount = (self.frameCount or 0) % 40 + 1
	self.frameCount = frameCount
	self:SetStatusBarTexture(powerTable[powerType][frameCount])
end

function addon:NewUpdater()
	for unit, frame in pairs(s_table) do
		if UnitExists(unit) and frame:IsVisible() then
			local powerType = (UnitPowerType(unit) or 0)
			AnimationUpdate(frame.Health, 14)
			AnimationUpdate(frame.Power, powerType)
			if frame.Castbar and (frame.Castbar.casting or frame.Castbar.channeling) then
				AnimationUpdate(frame.Castbar, 15)
			end
		end
	end
	for unit, frame in pairs(s_table_party_target) do
		if UnitExists(unit) and frame:IsVisible() then
			AnimationUpdate(frame.Health, 14)
		end
	end
end

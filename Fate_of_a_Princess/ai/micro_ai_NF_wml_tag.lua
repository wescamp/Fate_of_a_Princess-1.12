local H = wesnoth.require "lua/helper.lua"
local W = H.set_wml_action_metatable {}
local MAIH = wesnoth.require("~add-ons/Northern_Forces/ai/micro_ai_helper_NF.lua")

function wesnoth.wml_actions.micro_ai_NF(cfg)
    -- Set up the [micro_ai] tag functionality for each Micro AI
    cfg = cfg.__parsed

    -- Check that the required common keys are all present and set correctly
    if (not cfg.ai_type) then H.wml_error("[micro_ai] is missing required ai_type= key") end
    if (not cfg.side) then H.wml_error("[micro_ai] is missing required side= key") end
    if (not cfg.action) then H.wml_error("[micro_ai] is missing required action= key") end

    if (cfg.action ~= 'add') and (cfg.action ~= 'delete') and (cfg.action ~= 'change') then
        H.wml_error("[micro_ai] unknown value for action=. Allowed values: add, delete or change")
    end

    -- Set up the configuration tables for the different Micro AIs
    local required_keys, optional_keys, CA_parms = {}, {}, {}
    local CA_path = '~add-ons/Northern_Forces/ai/'

    --------- Messenger Escort Micro AI ------------------------------------
    if (cfg.ai_type == 'messenger_escort') then
        required_keys = { "id", "waypoint_x", "waypoint_y" }
        optional_keys = { "enemy_death_chance", "filter_second", "messenger_death_chance" }
        local score = cfg.ca_score or 300000
        CA_parms = {
            { ca_id = 'mai_messenger_attack', location = CA_path .. 'ca_messenger_attack.lua', score = score },
            { ca_id = 'mai_messenger_move', location = CA_path .. 'ca_messenger_move.lua', score = score - 1 },
            { ca_id = 'mai_messenger_escort_move', location = CA_path .. 'ca_messenger_escort_move.lua', score = score - 2 }
        }

    else
        H.wml_error("unknown value for ai_type= in [micro_ai]")
    end

    MAIH.micro_ai_setup(cfg, CA_parms, required_keys, optional_keys)
end

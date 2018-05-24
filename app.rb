require 'sinatra'
require 'sinatra/reloader' if development?
require 'dotenv/load'

# --------------------------------------------------------------------
# Hardware
# --------------------------------------------------------------------
def rm_mini(cmd)
  # system "/home/pi/apps/BlackBeanControl/BlackBeanControl.py -c #{cmd}"
end

def webhook_ifttt(event)
  system "curl https://maker.ifttt.com/trigger/#{event}/with/key/#{ENV['IFTTT_WEBHOOK_TOKEN']}"
end

# --------------------------------------------------------------------
# Home Appliances
# --------------------------------------------------------------------
# Living
def living_light_off
  webhook_ifttt('living-light-off')
end

def living_aircon_off
  webhook_ifttt('living-aircon-off')
end

def run_roomba
  webhook_ifttt('run-roomba')
end

# Bedroom
def bedroom_light_off
  webhook_ifttt('bedroom-light-off')
end

# Office
def office_aircon_off
  rm_mini('aircon-off')
end

def office_light_off
  rm_mini('light-off')
end

# --------------------------------------------------------------------
# Actions
# --------------------------------------------------------------------
def leave_office
  office_aircon_off
  office_light_off
end

def leave_living
  living_aircon_off
  living_light_off
  bedroom_light_off
end

# --------------------------------------------------------------------
# API
# --------------------------------------------------------------------
get '/health_check' do
  { status: 'OK' }.to_json
end

get '/rm-mini/:cmd' do
  { status: rm_mini(params[:cmd]) }.to_json
end

get '/oyasumi' do
  leave_living
  leave_office
  { status: 'SENT' }.to_json
end

get '/ittekimasu' do
  leave_office
  leave_living
  run_roomba
  { status: 'SENT' }.to_json
end

get '/otsukaresamadesu' do
  leave_office
  { status: 'SENT' }.to_json
end

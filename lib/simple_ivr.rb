class SimpleIvr < Adhearsion::CallController
  PROMPTS = {
    1 => "base256/classroom.wav",
    2 => "base256/Jupiter.wav",
    3 => "base256/flagpole.wav",
    4 => "base256/atmosphere.wav",
    5 => "base256/stagehand.wav",
    6 => "base256/preshrunk.wav",
    7 => "base256/pioneer.wav",
    8 => "base256/blowtorch.wav",
    9 => "base256/Istanbul.wav",
    0 => "base256/soybean.wav"
  }

  def run
    play path_for "misc/call_secured.wav"
    loop do
      index = ask path_for("ivr/ivr-enter_ext_pound.wav"), :limit => 1, :timeout => 5
      break unless index.status == :limited
      play path_for PROMPTS[index.response.to_i]
    end

    play path_for "voicemail/vm-goodbye.wav"
  end

  def path_for(prompt)
    file_root = "/opt/freeswitch/sounds/en/us/callie"
    dir, file = prompt.split '/'
    case Adhearsion.config.punchblock['platform']
    when :xmpp
      "file://#{file_root}/#{dir}/8000/#{file}"
    when :asterisk
      "#{file_root}/#{dir}/8000/#{file.sub(/\.wav$/, '')}"
    when :freeswitch
      prompt
    end
  end
end

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757636AbZLEA5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757636AbZLEA5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 19:57:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932525AbZLEA5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 19:57:20 -0500
Received: from straum.hexapodia.org ([64.81.70.185]:48861 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757492AbZLEA5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 19:57:19 -0500
Date: Fri, 4 Dec 2009 16:57:20 -0800
From: Andy Isaacson <adi@hexapodia.org>
To: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: 2.6.32: WARNING: at net/wireless/core.c:614 wdev_cleanup_work+0xd9/0x100 [cfg80211]()
Message-ID: <20091205005720.GB24944@hexapodia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Got this on a Dell e4300 (Core 2 Duo, Inte Pro/Wireless 5300 AGN)
running 2.6.32 final, while doing a suspend-on-lid-close soon after
bootup:

[   65.455842] ------------[ cut here ]------------
[   65.460477] WARNING: at net/wireless/core.c:614 wdev_cleanup_work+0xd9/0x100 [cfg80211]()
[   65.468656] Hardware name: Latitude E4300                  
<9>[   65.474225] Modules linked in: binfmt_misc rfcomm sco bnep l2cap crc16 snd_hda_codec_intelhdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy arc4 ecb snd_seq_oss snd_seq_midi iwlagn snd_rawmidi iwlcore snd_seq_midi_event snd_seq snd_timer snd_seq_device btusb snd led_class soundcore wmi mac80211 bluetooth ricoh_mmc snd_page_alloc psmouse evdev serio_raw dcdbas cfg80211 usbhid hid i915 drm_kms_helper drm i2c_algo_bit pata_acpi i2c_core intel_agp uhci_hcd[   65.520656] ---[ end trace ea0633faa6e3e0ca ]---
[   65.649368] PM: Syncing filesystems ... done.
[   65.685833] PM: Preparing system for mem sleep
[   65.947589] [drm] LVDS-8: set mode 1280x800 c
<9>[   66.011918] Freezing user space processes ... (elapsed 0.00 seconds) <9>[   66.020637] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.[   66.028100] PM: Entering mem sleep

I haven't seen this error before, so it may be a regression from .31,
but then I have only had serial console set up for a few weeks.

More serial console below, full dmesg (after a reboot) at
http://web.hexapodia.org/~adi/tmp/e4300-dmesg-2.6.32.txt

 * Setting preliminary keymap...                                                 * Speech-dispatcher configured for user sessionsps       
 * Starting Common Unix Printing System: cupsd                                   * PulseAudio configured for per-user sessions
 * Enabling additional executable binary formats binfmt-support                    ...done. battery state...       
[   31.963202] [drm] TV-25: set mode NTSC 480i 0
[   32.107680] [drm] TV-25: set mode NTSC 480i 0
[   32.402764] [drm] TV-25: set mode NTSC 480i 0
[   32.547450] [drm] TV-25: set mode NTSC 480i 0
[   32.842692] [drm] TV-25: set mode NTSC 480i 0
[   32.987478] [drm] TV-25: set mode NTSC 480i 0
[   35.658716] [drm] TV-25: set mode NTSC 480i 0
[   35.803263] [drm] TV-25: set mode NTSC 480i 0
[   42.186787] wlan0: deauthenticating from 00:0b:0e:46:5c:00 by local choice (reason=3)
[   42.194885] wlan0: direct probe to AP 00:0b:0e:46:5c:00 (try 1)
[   42.204706] wlan0: direct probe responded
[   42.208721] wlan0: authenticate with AP 00:0b:0e:46:5c:00 (try 1)
[   42.217544] wlan0: authenticated
[   42.220790] wlan0: associate with AP 00:0b:0e:46:5c:00 (try 1)
[   42.229554] wlan0: RX AssocResp from 00:0b:0e:46:5c:00 (capab=0x421 status=0 aid=6)
[   42.237207] wlan0: associated
[   42.252175] cfg80211: Calling CRDA for country: US
[   42.258795] cfg80211: Current regulatory domain updated by AP to: US
[   42.265161]  (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   42.272401]  (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
[   63.151613] [drm] TV-25: set mode NTSC 480i 0
[   63.606768] [drm] TV-25: set mode NTSC 480i 0
[   63.919543] [drm] TV-25: set mode NTSC 480i 0
[   64.103978] [drm] TV-25: set mode NTSC 480i 0
[   65.381220] wlan0: deauthenticating from 00:0b:0e:46:5c:00 by local choice (reason=3)
[   65.390034] wlan0: direct probe to AP 00:0b:0e:46:5c:00 (try 1)
[   65.396020] wlan0: deauthenticating from 00:0b:0e:46:5c:00 by local choice (reason=3)
[   65.455842] ------------[ cut here ]------------
[   65.460477] WARNING: at net/wireless/core.c:614 wdev_cleanup_work+0xd9/0x100 [cfg80211]()
[   65.468656] Hardware name: Latitude E4300                  
<9>[   65.474225] Modules linked in: binfmt_misc rfcomm sco bnep l2cap crc16 snd_hda_codec_intelhdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy arc4 ecb snd_seq_oss snd_seq_midi iwlagn snd_rawmidi iwlcore snd_seq_midi_event snd_seq snd_timer snd_seq_device btusb snd led_class soundcore wmi mac80211 bluetooth ricoh_mmc snd_page_alloc psmouse evdev serio_raw dcdbas cfg80211 usbhid hid i915 drm_kms_helper drm i2c_algo_bit pata_acpi i2c_core intel_agp uhci_hcd[   65.520656] ---[ end trace ea0633faa6e3e0ca ]---
[   65.649368] PM: Syncing filesystems ... done.
[   65.685833] PM: Preparing system for mem sleep
[   65.947589] [drm] LVDS-8: set mode 1280x800 c
<9>[   66.011918] Freezing user space processes ... (elapsed 0.00 seconds) <9>[   66.020637] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.[   66.028100] PM: Entering mem sleep

-andy

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab0BOMqq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 07:46:46 -0500
Received: from smtp-out5.blueyonder.co.uk ([195.188.213.8]:40773 "EHLO
	smtp-out5.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751585Ab0BOMqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 07:46:42 -0500
Message-ID: <4B79422B.7080701@blueyonder.co.uk>
Date: Mon, 15 Feb 2010 12:46:35 +0000
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.9.1.7) Gecko/20100111 SUSE/3.0.1-1.3 Thunderbird/3.0.1 ThunderBrowse/3.2.7
MIME-Version: 1.0
To: yTakashi Iwai <tiwai@suse.de>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bug #15144] HDA Intel Audio hang on boot
References: <vZZJKzCUn4G.A.CPB.F7hZLB@chimera>	<d3IDKWHT5gE.A.MEC.a7hZLB@chimera>	<4B6635F1.8060909@blueyonder.co.uk>	<s5h3a1lh2wr.wl%tiwai@suse.de>	<4B785D0D.3070804@blueyonder.co.uk> <s5haavb9dli.wl%tiwai@suse.de>
In-Reply-To: <s5haavb9dli.wl%tiwai@suse.de>
Content-Type: multipart/mixed;
 boundary="------------080605080704010807060603"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080605080704010807060603
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 15/02/10 07:12, yTakashi Iwai wrote:
> At Sun, 14 Feb 2010 20:29:01 +0000,
> Sid Boyce wrote:
>>
>> On 01/02/10 06:43, Takashi Iwai wrote:
>>> At Mon, 01 Feb 2010 02:01:21 +0000,
>>> Sid Boyce wrote:
>>>>
>>>> On 01/02/10 00:22, Rafael J. Wysocki wrote:
>>>>> This message has been generated automatically as a part of a report
>>>>> of recent regressions.
>>>>>
>>>>> The following bug entry is on the current list of known regressions
>>>>> from 2.6.32.  Please verify if it still should be listed and let me know
>>>>> (either way).
>>>>>
>>>>>
>>>>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15144
>>>>> Subject		: HDA Intel Audio hang on boot
>>>>> Submitter	: Sid Boyce <sboyce@blueyonder.co.uk>
>>>>> Date		: 2010-01-15 1:24 (17 days old)
>>>>> References	: http://marc.info/?l=linux-kernel&m=126351866722507&w=4
>>>>>
>>>>>
>>>>>
>>>>
>>>> Still not fixed in 2.6.33-rc6. Takashi wrote that the fix was scheduled
>>>> for 2.6.33-rc6, but it did not appear.
>>>
>>> It just slipped from rc6 due to my busy load.
>>> The pull request was sent yesterday.
>>>
>>>
>>> Takashi
>>>
>>
>> Up to 2.6.33-rc8 still needs the work around in
>> /etc/modprobe.d/50-sound.conf, so the kernel blacklist fix does not work.
> 
> Check the kernel message.  Don't you have a message like "hda_intel:
> msi for device 1043:829c set to 0"?  Otherwise give alsa-info.sh
> again.
> 
No mention of it - 2.6.33-rc8.
tindog:~ # dmesg|grep 1043
tindog:~ # grep 1043 /var/log/boot.msg
tindog:~ # grep 1043 /var/log/messages
tindog:~ #
The patch seems to be addressing the wrong  device, alsa-info.sh shows
it as
        Subsystem: 1043:81f6
Subsystem Id: 0x104381f6
  Components    : 'HDA:11d4198b,104381f6,00100300'

tindog:/usr/src/linux-2.6.33-rc8 # grep 1043 ./sound/pci/hda/hda_intel.c
        SND_PCI_QUIRK(0x1043, 0x813d, "ASUS P5AD2", POS_FIX_LPIB),
        SND_PCI_QUIRK(0x1043, 0x1262, "ASUS W5Fm", 0x103),
        SND_PCI_QUIRK(0x1043, 0x81f2, "ASUS", 0), /* Athlon64 X2 + nvidia */
        SND_PCI_QUIRK(0x1043, 0x829c, "ASUS", 0), /* nvidia */

I shall change the 0x81f2 to 0x81f6 and test.

> But, essentially this is a problem of your mobo and Linux MSI
> handling, not exactly a driver issue, IMO...
> 
I think you are correct, could be the motherboard or BIOS. I have tried
a number of BIOS versions with the same result. I am about to change to
a Asus Crosshair III motherboard in a few days when the memory arrives.
It also wouldn't boot if I have kgdb enabled in .config, I get a stream
of Traces with "Tainted".

> I guess the problem will go away if you remove your another sound card
> on the PCI slot.  Or maybe it'd work even by moving to another
> slot...
> 
It's the on-board sound. Before the work around I had to disable it in
the BIOS and use the USB sound card.
> 
> Takashi
> 
Regards
Sid.

-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

--------------080605080704010807060603
Content-Type: text/plain;
 name="alsa-info-tindog.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="alsa-info-tindog.txt"

upload=true&script=true&cardinfo=
!!################################
!!ALSA Information Script v 0.4.58
!!################################

!!Script ran on: Mon Feb 15 12:13:10 UTC 2010


!!Linux Distribution
!!------------------

Welcome to openSUSE 11.3 "Teal" Milestone 1 - Kernel \r (\l). openSUSE 11.3 Milestone 1 (x86_64) LSB_VERSION="core-2.0-noarch:core-3.2-noarch:core-4.0-noarch:core-2.0-x86_64:core-3.2-x86_64:core-4.0-x86_64"


!!DMI Information
!!---------------

Manufacturer:      System manufacturer
Product Name:      System Product Name


!!Kernel Information
!!------------------

Kernel release:    2.6.33-rc8-smp
Operating System:  GNU/Linux
Architecture:      x86_64
Processor:         x86_64
SMP Enabled:       Yes


!!ALSA Version
!!------------

Driver version:     1.0.21
Library version:    1.0.22
Utilities version:  1.0.22


!!Loaded ALSA modules
!!-------------------

snd_usb_audio
snd_usb_audio
snd_hda_intel


!!Sound Servers on this system
!!----------------------------

Pulseaudio:
      Installed - Yes (/usr/bin/pulseaudio)
      Running - Yes

ESound Daemon:
      Installed - Yes (/usr/bin/esd)
      Running - No

aRts:
      Installed - Yes (/opt/kde3/bin/artsd)
      Running - No

Jack:
      Installed - Yes (/usr/local/bin/jackd)
      Running - No


!!Soundcards recognised by ALSA
!!-----------------------------

 0 [Q9000          ]: USB-Audio - QuickCam Pro 9000
                      Logitech, Inc. QuickCam Pro 9000 at usb-0000:00:0a.1-4, high speed
 1 [Aureon51MkII   ]: USB-Audio - Aureon5.1MkII
                      TerraTec Aureon5.1MkII at usb-0000:00:0a.0-3, full speed
 2 [NVidia         ]: HDA-Intel - HDA NVidia
                      HDA NVidia at 0xfe020000 irq 20


!!PCI Soundcards installed in the system
!!--------------------------------------

00:0e.1 Audio device: nVidia Corporation MCP55 High Definition Audio (rev a2)


!!Advanced information - PCI Vendor/Device/Susbsystem ID's
!!--------------------------------------------------------

00:0e.1 0403: 10de:0371 (rev a2)
	Subsystem: 1043:81f6
--
01:00.0 0300: 10de:0402 (rev a1) (prog-if 00 [VGA controller])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-


!!Modprobe options (Sound related)
!!--------------------------------

snd-hda-intel: enable_msi=0


!!Loaded sound module options
!!--------------------------

!!Module: snd_usb_audio
	async_unlink : Y
	device_setup : 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	enable : Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y
	id : (null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null)
	ignore_ctl_error : N
	index : -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	nrpacks : 8
	pid : -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	vid : -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1

!!Module: snd_usb_audio
	async_unlink : Y
	device_setup : 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	enable : Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y
	id : (null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null)
	ignore_ctl_error : N
	index : -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	nrpacks : 8
	pid : -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	vid : -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1

!!Module: snd_hda_intel
	bdl_pos_adj : 32,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	enable : Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y
	enable_msi : 0
	id : (null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null)
	index : -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	model : (null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null)
	patch : (null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null)
	position_fix : 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	power_save : 0
	power_save_controller : Y
	probe_mask : -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	probe_only : N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N
	single_cmd : N


!!HDA-Intel Codec information
!!---------------------------
--startcollapse--

Codec: Analog Devices AD1988B
Address: 0
Function Id: 0x1
Vendor Id: 0x11d4198b
Subsystem Id: 0x104381f6
Revision Id: 0x100300
No Modem Function Group found
Default PCM:
    rates [0x7ff]: 8000 11025 16000 22050 32000 44100 48000 88200 96000 176400 192000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
Default Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
Default Amp-Out caps: ofs=0x27, nsteps=0x27, stepsize=0x05, mute=0
GPIO: io=2, o=0, i=0, unsolicited=1, wake=0
  IO[0]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
  IO[1]: enable=0, dir=0, wake=0, sticky=0, data=1, unsol=0
Node 0x02 [Audio Output] wcaps 0x30311: Stereo Digital
  Control: name="IEC958 Playback Con Mask", index=0, device=0
  Control: name="IEC958 Playback Pro Mask", index=0, device=0
  Control: name="IEC958 Playback Default", index=0, device=0
  Control: name="IEC958 Playback Switch", index=0, device=0
  Control: name="IEC958 Default PCM Playback Switch", index=0, device=0
  Device: name="AD198x Digital", type="SPDIF", device=1
  Converter: stream=0, channel=0
  Digital: Enabled
  Digital category: 0x0
  PCM:
    rates [0x7e0]: 44100 48000 88200 96000 176400 192000
    bits [0xe]: 16 20 24
    formats [0x5]: PCM AC3
  Delay: 3 samples
  Connection: 1
     0x1d
Node 0x03 [Audio Output] wcaps 0x405: Stereo Amp-Out
  Amp-Out caps: ofs=0x27, nsteps=0x27, stepsize=0x05, mute=0
  Amp-Out vals:  [0x27 0x27]
  Converter: stream=0, channel=0
  Power states:  D0 D3
  Power: setting=D0, actual=D0
Node 0x04 [Audio Output] wcaps 0x405: Stereo Amp-Out
  Control: name="Front Playback Volume", index=0, device=0
  Device: name="AD198x Analog", type="Audio", device=0
  Amp-Out caps: ofs=0x27, nsteps=0x27, stepsize=0x05, mute=0
  Amp-Out vals:  [0x27 0x27]
  Converter: stream=5, channel=0
  Power states:  D0 D3
  Power: setting=D0, actual=D0
Node 0x05 [Audio Output] wcaps 0x405: Stereo Amp-Out
  Control: name="Center Playback Volume", index=0, device=0
  Control: name="LFE Playback Volume", index=0, device=0
  Amp-Out caps: ofs=0x27, nsteps=0x27, stepsize=0x05, mute=0
  Amp-Out vals:  [0x27 0x27]
  Converter: stream=5, channel=0
  Power states:  D0 D3
  Power: setting=D0, actual=D0
Node 0x06 [Audio Output] wcaps 0x405: Stereo Amp-Out
  Control: name="Surround Playback Volume", index=0, device=0
  Amp-Out caps: ofs=0x27, nsteps=0x27, stepsize=0x05, mute=0
  Amp-Out vals:  [0x27 0x27]
  Converter: stream=5, channel=0
  Power states:  D0 D3
  Power: setting=D0, actual=D0
Node 0x07 [Audio Input] wcaps 0x130391: Stereo Digital
  Control: name="IEC958 Capture Switch", index=0, device=0
  Control: name="IEC958 Capture Default", index=0, device=0
  Device: name="AD198x Digital", type="SPDIF", device=1
  Converter: stream=0, channel=0
  SDI-Select: 0
  Digital:
  Digital category: 0x0
  PCM:
    rates [0x7e0]: 44100 48000 88200 96000 176400 192000
    bits [0xe]: 16 20 24
    formats [0x5]: PCM AC3
  Unsolicited: tag=00, enabled=0
  Delay: 3 samples
  Connection: 1
     0x1c
Node 0x08 [Audio Input] wcaps 0x100501: Stereo
  Device: name="AD198x Analog", type="Audio", device=0
  Converter: stream=1, channel=0
  SDI-Select: 0
  Power states:  D0 D3
  Power: setting=D0, actual=D0
  Connection: 1
     0x0c
Node 0x09 [Audio Input] wcaps 0x100501: Stereo
  Converter: stream=0, channel=0
  SDI-Select: 0
  Power states:  D0 D3
  Power: setting=D0, actual=D0
  Connection: 1
     0x0d
Node 0x0a [Audio Output] wcaps 0x405: Stereo Amp-Out
  Control: name="Side Playback Volume", index=0, device=0
  Amp-Out caps: ofs=0x27, nsteps=0x27, stepsize=0x05, mute=0
  Amp-Out vals:  [0x27 0x27]
  Converter: stream=5, channel=0
  Power states:  D0 D3
  Power: setting=D0, actual=D0
Node 0x0b [Audio Selector] wcaps 0x300301: Stereo Digital
  Connection: 3
     0x08* 0x09 0x0f
Node 0x0c [Audio Selector] wcaps 0x30010d: Stereo Amp-Out
  Control: name="Capture Volume", index=0, device=0
  Control: name="Capture Switch", index=0, device=0
  Amp-Out caps: ofs=0x27, nsteps=0x36, stepsize=0x05, mute=1
  Amp-Out vals:  [0x35 0x35]
  Connection: 10
     0x38 0x39* 0x3a 0x3b 0x3c 0x18 0x24 0x25 0x3d 0x20
Node 0x0d [Audio Selector] wcaps 0x30010d: Stereo Amp-Out
  Control: name="Capture Volume", index=1, device=0
  Control: name="Capture Switch", index=1, device=0
  Amp-Out caps: ofs=0x27, nsteps=0x36, stepsize=0x05, mute=1
  Amp-Out vals:  [0xaa 0xaa]
  Connection: 10
     0x38 0x39* 0x3a 0x3b 0x3c 0x18 0x24 0x25 0x3d 0x20
Node 0x0e [Audio Selector] wcaps 0x30010d: Stereo Amp-Out
  Control: name="Capture Volume", index=2, device=0
  Control: name="Capture Switch", index=2, device=0
  Amp-Out caps: ofs=0x27, nsteps=0x36, stepsize=0x05, mute=1
  Amp-Out vals:  [0xab 0xab]
  Connection: 10
     0x38 0x39* 0x3a 0x3b 0x3c 0x18 0x24 0x25 0x3d 0x20
Node 0x0f [Audio Input] wcaps 0x100501: Stereo
  Converter: stream=0, channel=0
  SDI-Select: 0
  Power states:  D0 D3
  Power: setting=D0, actual=D0
  Connection: 1
     0x0e
Node 0x10 [Beep Generator Widget] wcaps 0x70000c: Mono Amp-Out
  Amp-Out caps: ofs=0x0f, nsteps=0x0f, stepsize=0x0b, mute=1
  Amp-Out vals:  [0x00]
Node 0x11 [Pin Complex] wcaps 0x40018d: Stereo Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x00 0x00]
  Pincap 0x0000373f: IN OUT HP Detect Trigger ImpSense
    Vref caps: HIZ 50 GRD 80 100
  Pin Default 0x02214130: [Jack] HP Out at Ext Front
    Conn = 1/8, Color = Green
    DefAssociation = 0x3, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0xc0: OUT HP VREF_HIZ
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x22
Node 0x12 [Pin Complex] wcaps 0x40018d: Stereo Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x00 0x00]
  Pincap 0x0000373f: IN OUT HP Detect Trigger ImpSense
    Vref caps: HIZ 50 GRD 80 100
  Pin Default 0x01014010: [Jack] Line Out at Ext Rear
    Conn = 1/8, Color = Green
    DefAssociation = 0x1, Sequence = 0x0
  Pin-ctls: 0x40: OUT VREF_HIZ
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x29
Node 0x13 [Pin Complex] wcaps 0x40010c: Mono Amp-Out
  Amp-Out caps: ofs=0x1f, nsteps=0x1f, stepsize=0x05, mute=1
  Amp-Out vals:  [0x00]
  Pincap 0x00000010: OUT
  Pin Default 0x511711f0: [N/A] Speaker at Int Rear
    Conn = Analog, Color = Black
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x40: OUT
  Connection: 1
     0x2d
Node 0x14 [Pin Complex] wcaps 0x40018d: Stereo Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x80 0x80]
  Pincap 0x0000373f: IN OUT HP Detect Trigger ImpSense
    Vref caps: HIZ 50 GRD 80 100
  Pin Default 0x02a1912e: [Jack] Mic at Ext Front
    Conn = 1/8, Color = Pink
    DefAssociation = 0x2, Sequence = 0xe
    Misc = NO_PRESENCE
  Pin-ctls: 0x24: IN VREF_80
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x2b
Node 0x15 [Pin Complex] wcaps 0x40018d: Stereo Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x80 0x80]
  Pincap 0x00003737: IN OUT Detect Trigger ImpSense
    Vref caps: HIZ 50 GRD 80 100
  Pin Default 0x01813021: [Jack] Line In at Ext Rear
    Conn = 1/8, Color = Blue
    DefAssociation = 0x2, Sequence = 0x1
  Pin-ctls: 0x20: IN VREF_HIZ
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x2c
Node 0x16 [Pin Complex] wcaps 0x40018d: Stereo Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x00 0x00]
  Pincap 0x00003737: IN OUT Detect Trigger ImpSense
    Vref caps: HIZ 50 GRD 80 100
  Pin Default 0x01011012: [Jack] Line Out at Ext Rear
    Conn = 1/8, Color = Black
    DefAssociation = 0x1, Sequence = 0x2
  Pin-ctls: 0x40: OUT VREF_HIZ
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x2a
Node 0x17 [Pin Complex] wcaps 0x40098d: Stereo Amp-Out R/L
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x80 0x80]
  Pincap 0x00003737: IN OUT Detect Trigger ImpSense
    Vref caps: HIZ 50 GRD 80 100
  Pin Default 0x01a19020: [Jack] Mic at Ext Rear
    Conn = 1/8, Color = Pink
    DefAssociation = 0x2, Sequence = 0x0
  Pin-ctls: 0x24: IN VREF_80
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x26
Node 0x18 [Pin Complex] wcaps 0x400001: Stereo
  Pincap 0x00000020: IN
  Pin Default 0x99331122: [Fixed] CD at Int ATAPI
    Conn = ATAPI, Color = Black
    DefAssociation = 0x2, Sequence = 0x2
    Misc = NO_PRESENCE
  Pin-ctls: 0x20: IN
Node 0x19 [Power Widget] wcaps 0x500500: Mono
  Power states:  D0 D3
  Power: setting=D0, actual=D0
  Connection: 2
     0x20 0x21
Node 0x1a [Pin Complex] wcaps 0x400000: Mono
  Pincap 0x00000020: IN
  Pin Default 0x91f711f0: [Fixed] Other at Int Rear
    Conn = Analog, Color = Black
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x20: IN
Node 0x1b [Pin Complex] wcaps 0x40030d: Stereo Digital Amp-Out
  Control: name="IEC958 Playback Volume", index=0, device=0
  Amp-Out caps: ofs=0x27, nsteps=0x27, stepsize=0x05, mute=1
  Amp-Out vals:  [0x00 0x00]
  Pincap 0x00000010: OUT
  Pin Default 0x0145f1f0: [Jack] SPDIF Out at Ext Rear
    Conn = Optical, Color = Other
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x40: OUT
  Connection: 1
     0x02
Node 0x1c [Pin Complex] wcaps 0x40020b: Stereo Digital Amp-In
  Control: name="IEC958 Capture Volume", index=0, device=0
  Amp-In caps: ofs=0x17, nsteps=0x1f, stepsize=0x05, mute=1
  Amp-In vals:  [0x97 0x97]
  Pincap 0x00000020: IN
  Pin Default 0x41c5f1f0: [N/A] SPDIF In at Ext Rear
    Conn = Optical, Color = Other
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x20: IN
Node 0x1d [Audio Mixer] wcaps 0x200303: Stereo Digital Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00 0x00] [0x80 0x80]
  Connection: 2
     0x01 0x0b
Node 0x1e [Audio Mixer] wcaps 0x200103: Stereo Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00 0x00] [0x00 0x00]
  Connection: 2
     0x36 0x21
Node 0x1f [Volume Knob Widget] wcaps 0x600080: Mono
  Volume-Knob: delta=1, steps=63, direct=0, val=0
  Unsolicited: tag=00, enabled=0
  Connection: 0
Node 0x20 [Audio Mixer] wcaps 0x20010b: Stereo Amp-In
  Control: name="CD Playback Volume", index=0, device=0
  Control: name="CD Playback Switch", index=0, device=0
  Control: name="Front Mic Playback Volume", index=0, device=0
  Control: name="Front Mic Playback Switch", index=0, device=0
  Control: name="Line Playback Volume", index=0, device=0
  Control: name="Line Playback Switch", index=0, device=0
  Control: name="Mic Playback Volume", index=0, device=0
  Control: name="Mic Playback Switch", index=0, device=0
  Amp-In caps: ofs=0x17, nsteps=0x1f, stepsize=0x05, mute=1
  Amp-In vals:  [0x19 0x19] [0x1f 0x1f] [0x80 0x80] [0x80 0x80] [0x1d 0x1d] [0x80 0x80] [0x1e 0x1e] [0x80 0x80]
  Connection: 8
     0x39 0x33 0x38 0x3d 0x34 0x3b 0x18 0x1a
Node 0x21 [Audio Selector] wcaps 0x30010d: Stereo Amp-Out
  Control: name="Analog Mix Playback Volume", index=0, device=0
  Control: name="Analog Mix Playback Switch", index=0, device=0
  Amp-Out caps: ofs=0x1f, nsteps=0x1f, stepsize=0x05, mute=1
  Amp-Out vals:  [0x19 0x19]
  Connection: 1
     0x20
Node 0x22 [Audio Mixer] wcaps 0x200103: Stereo Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00 0x00] [0x00 0x00]
  Connection: 2
     0x37 0x21
Node 0x23 [Vendor Defined Widget] wcaps 0xf00100: Mono
  Connection: 18
     0x11* 0x12 0x13 0x14 0x15 0x16 0x17 0x18 0x24 0x25 0x38 0x39 0x3a 0x3b 0x3c 0x3d 0x20 0x21
Node 0x24 [Pin Complex] wcaps 0x40098d: Stereo Amp-Out R/L
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x00 0x00]
  Pincap 0x00000037: IN OUT Detect Trigger ImpSense
  Pin Default 0x01016011: [Jack] Line Out at Ext Rear
    Conn = 1/8, Color = Orange
    DefAssociation = 0x1, Sequence = 0x1
  Pin-ctls: 0x40: OUT
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x27
Node 0x25 [Pin Complex] wcaps 0x40018d: Stereo Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x00 0x00]
  Pincap 0x00000037: IN OUT Detect Trigger ImpSense
  Pin Default 0x01012014: [Jack] Line Out at Ext Rear
    Conn = 1/8, Color = Grey
    DefAssociation = 0x1, Sequence = 0x4
  Pin-ctls: 0x40: OUT
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x28
Node 0x26 [Audio Mixer] wcaps 0x200103: Stereo Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x80 0x80] [0x80 0x80]
  Connection: 2
     0x32 0x21
Node 0x27 [Audio Mixer] wcaps 0x200103: Stereo Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00 0x00] [0x00 0x00]
  Connection: 2
     0x05 0x21
Node 0x28 [Audio Mixer] wcaps 0x200103: Stereo Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00 0x00] [0x00 0x00]
  Connection: 2
     0x0a 0x21
Node 0x29 [Audio Mixer] wcaps 0x200103: Stereo Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00 0x00] [0x00 0x00]
  Connection: 2
     0x04 0x21
Node 0x2a [Audio Mixer] wcaps 0x200103: Stereo Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00 0x00] [0x00 0x00]
  Connection: 2
     0x06 0x21
Node 0x2b [Audio Mixer] wcaps 0x200103: Stereo Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x80 0x80] [0x80 0x80]
  Connection: 2
     0x30 0x21
Node 0x2c [Audio Mixer] wcaps 0x200103: Stereo Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x80 0x80] [0x80 0x80]
  Connection: 2
     0x31 0x21
Node 0x2d [Audio Mixer] wcaps 0x200100: Mono
  Connection: 1
     0x1e
Node 0x2e [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x2f [Vendor Defined Widget] wcaps 0xf00100: Mono
  Connection: 6
     0x11* 0x12 0x14 0x15 0x16 0x17
Node 0x30 [Audio Selector] wcaps 0x300101: Stereo
  Connection: 3
     0x03* 0x04 0x06
Node 0x31 [Audio Selector] wcaps 0x300101: Stereo
  Connection: 2
     0x04* 0x0a
Node 0x32 [Audio Selector] wcaps 0x300101: Stereo
  Connection: 2
     0x05* 0x04
Node 0x33 [Audio Selector] wcaps 0x300101: Stereo
  Connection: 3
     0x3a* 0x25 0x24
Node 0x34 [Audio Selector] wcaps 0x300101: Stereo
  Connection: 3
     0x3c* 0x25 0x24
Node 0x35 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x36 [Audio Selector] wcaps 0x300101: Stereo
  Connection: 3
     0x03 0x04* 0x06
Node 0x37 [Audio Selector] wcaps 0x300101: Stereo
  Connection: 3
     0x03 0x04* 0x06
Node 0x38 [Audio Selector] wcaps 0x30010d: Stereo Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-Out vals:  [0x00 0x00]
  Connection: 1
     0x11
Node 0x39 [Audio Selector] wcaps 0x30010d: Stereo Amp-Out
  Control: name="Front Mic Boost", index=0, device=0
  Amp-Out caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-Out vals:  [0x00 0x00]
  Connection: 1
     0x14
Node 0x3a [Audio Selector] wcaps 0x30010d: Stereo Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-Out vals:  [0x00 0x00]
  Connection: 1
     0x15
Node 0x3b [Audio Selector] wcaps 0x30010d: Stereo Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-Out vals:  [0x00 0x00]
  Connection: 1
     0x16
Node 0x3c [Audio Selector] wcaps 0x30010d: Stereo Amp-Out
  Control: name="Mic Boost", index=0, device=0
  Amp-Out caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-Out vals:  [0x03 0x03]
  Connection: 1
     0x17
Node 0x3d [Audio Selector] wcaps 0x30010d: Stereo Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-Out vals:  [0x00 0x00]
  Connection: 1
     0x12
--endcollapse--


!!ALSA Device nodes
!!-----------------

crw-rw-rw-+ 1 root audio 116,  4 Feb 14 19:58 /dev/snd/controlC0
crw-rw-rw-+ 1 root audio 116,  7 Feb 14 19:58 /dev/snd/controlC1
crw-rw-rw-+ 1 root audio 116, 13 Feb 14 19:58 /dev/snd/controlC2
crw-rw-rw-+ 1 root audio 116, 12 Feb 14 19:58 /dev/snd/hwC2D0
crw-rw-rw-+ 1 root audio 116,  3 Feb 14 20:01 /dev/snd/pcmC0D0c
crw-rw-rw-+ 1 root audio 116,  6 Feb 14 20:01 /dev/snd/pcmC1D0c
crw-rw-rw-+ 1 root audio 116,  5 Feb 14 20:01 /dev/snd/pcmC1D0p
crw-rw-rw-+ 1 root audio 116, 11 Feb 14 20:01 /dev/snd/pcmC2D0c
crw-rw-rw-+ 1 root audio 116, 10 Feb 14 20:01 /dev/snd/pcmC2D0p
crw-rw-rw-+ 1 root audio 116,  9 Feb 14 20:01 /dev/snd/pcmC2D1c
crw-rw-rw-+ 1 root audio 116,  8 Feb 14 20:01 /dev/snd/pcmC2D1p
crw-rw-rw-+ 1 root audio 116, 14 Feb 14 19:59 /dev/snd/seq
crw-rw-rw-+ 1 root audio 116,  2 Feb 14 19:58 /dev/snd/timer

/dev/snd/by-id:
total 0
drwxr-xr-x 2 root root  80 Feb 14 19:58 .
drwxr-xr-x 4 root root 340 Feb 14 19:59 ..
lrwxrwxrwx 1 root root  12 Feb 14 19:58 usb-046d_0990_7BBC20E7-02 -> ../controlC0
lrwxrwxrwx 1 root root  12 Feb 14 19:58 usb-0ccd_USB_Audio-00 -> ../controlC1

/dev/snd/by-path:
total 0
drwxr-xr-x 2 root root 100 Feb 14 19:58 .
drwxr-xr-x 4 root root 340 Feb 14 19:59 ..
lrwxrwxrwx 1 root root  12 Feb 14 19:58 pci-0000:00:0a.0-usb-0:3:1.0 -> ../controlC1
lrwxrwxrwx 1 root root  12 Feb 14 19:58 pci-0000:00:0a.1-usb-0:4:1.2 -> ../controlC0
lrwxrwxrwx 1 root root  12 Feb 14 19:58 pci-0000:00:0e.1 -> ../controlC2


!!ALSA configuration files
!!------------------------

!!User specific config file (~/.asoundrc)

defaults.pcm.rate_converter "samplerate"


!!System wide config file (/etc/asound.conf)

# PulseAudio plugin configuration

# Let's create a virtual device "pulse" for mixer and PCM

pcm.pulse {
    type pulse
}

ctl.pulse {
    type pulse
}

# Let's make it the default!

pcm.!default {
    type pulse
}

ctl.!default {
    type pulse
}


!!Aplay/Arecord output
!!------------

APLAY

**** List of PLAYBACK Hardware Devices ****
card 1: Aureon51MkII [Aureon5.1MkII], device 0: USB Audio [USB Audio]
  Subdevices: 0/1
  Subdevice #0: subdevice #0
card 2: NVidia [HDA NVidia], device 0: AD198x Analog [AD198x Analog]
  Subdevices: 0/1
  Subdevice #0: subdevice #0
card 2: NVidia [HDA NVidia], device 1: AD198x Digital [AD198x Digital]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

ARECORD

**** List of CAPTURE Hardware Devices ****
card 0: Q9000 [QuickCam Pro 9000], device 0: USB Audio [USB Audio]
  Subdevices: 0/1
  Subdevice #0: subdevice #0
card 1: Aureon51MkII [Aureon5.1MkII], device 0: USB Audio [USB Audio]
  Subdevices: 0/1
  Subdevice #0: subdevice #0
card 2: NVidia [HDA NVidia], device 0: AD198x Analog [AD198x Analog]
  Subdevices: 2/3
  Subdevice #0: subdevice #0
  Subdevice #1: subdevice #1
  Subdevice #2: subdevice #2
card 2: NVidia [HDA NVidia], device 1: AD198x Digital [AD198x Digital]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

!!Amixer output
!!-------------

!!-------Mixer controls for card 0 [Q9000]

Card hw:0 'Q9000'/'Logitech, Inc. QuickCam Pro 9000 at usb-0000:00:0a.1-4, high speed'
  Mixer name	: 'USB Mixer'
  Components	: 'USB046d:0990'
  Controls      : 2
  Simple ctrls  : 1
Simple mixer control 'Mic',0
  Capabilities: cvolume cvolume-joined cswitch cswitch-joined penum
  Capture channels: Mono
  Limits: Capture 0 - 3072
  Mono: Capture 141 [5%] [18.55dB] [on]

!!-------Mixer controls for card 1 [Aureon51MkII]

Card hw:1 'Aureon51MkII'/'TerraTec Aureon5.1MkII at usb-0000:00:0a.0-3, full speed'
  Mixer name	: 'USB Mixer'
  Components	: 'USB0ccd:0028'
  Controls      : 13
  Simple ctrls  : 5
Simple mixer control 'Master',0
  Capabilities: pvolume pvolume-joined pswitch pswitch-joined penum
  Playback channels: Mono
  Limits: Playback 0 - 255
  Mono: Playback 241 [95%] [-2.69dB] [on]
Simple mixer control 'Line',0
  Capabilities: pvolume cvolume pswitch pswitch-joined cswitch cswitch-joined cswitch-exclusive penum
  Capture exclusive group: 0
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: Playback 0 - 255 Capture 0 - 128
  Front Left: Playback 191 [75%] [35.81dB] [off] Capture 0 [0%] [0.00dB] [off]
  Front Right: Playback 191 [75%] [35.81dB] [off] Capture 0 [0%] [0.00dB] [off]
Simple mixer control 'Mic',0
  Capabilities: pvolume pvolume-joined cvolume cvolume-joined pswitch pswitch-joined cswitch cswitch-joined cswitch-exclusive penum
  Capture exclusive group: 0
  Playback channels: Mono
  Capture channels: Mono
  Limits: Playback 0 - 255 Capture 0 - 128
  Mono: Playback 42 [16%] [7.87dB] [on] Capture 12 [9%] [2.23dB] [off]
Simple mixer control 'Mic Capture',0
  Capabilities: pswitch pswitch-joined penum
  Playback channels: Mono
  Mono: Playback [off]
Simple mixer control 'IEC958 In',0
  Capabilities: cswitch cswitch-joined cswitch-exclusive penum
  Capture exclusive group: 0
  Capture channels: Mono
  Mono: Capture [off]

!!-------Mixer controls for card 2 [NVidia]

Card hw:2 'NVidia'/'HDA NVidia at 0xfe020000 irq 20'
  Mixer name	: 'Analog Devices AD1988B'
  Components	: 'HDA:11d4198b,104381f6,00100300'
  Controls      : 46
  Simple ctrls  : 25
Simple mixer control 'Master',0
  Capabilities: pvolume pvolume-joined pswitch pswitch-joined penum
  Playback channels: Mono
  Limits: Playback 0 - 39
  Mono: Playback 39 [100%] [0.00dB] [on]
Simple mixer control 'Headphone',0
  Capabilities: pswitch penum
  Playback channels: Front Left - Front Right
  Mono:
  Front Left: Playback [on]
  Front Right: Playback [on]
Simple mixer control 'PCM',0
  Capabilities: pvolume penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 255
  Mono:
  Front Left: Playback 255 [100%] [0.00dB]
  Front Right: Playback 255 [100%] [0.00dB]
Simple mixer control 'Front',0
  Capabilities: pvolume pswitch penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 39
  Mono:
  Front Left: Playback 39 [100%] [0.00dB] [on]
  Front Right: Playback 39 [100%] [0.00dB] [on]
Simple mixer control 'Front Mic',0
  Capabilities: pvolume pswitch penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 31
  Mono:
  Front Left: Playback 25 [81%] [3.00dB] [on]
  Front Right: Playback 25 [81%] [3.00dB] [on]
Simple mixer control 'Front Mic Boost',0
  Capabilities: volume penum
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: 0 - 3
  Front Left: 0 [0%]
  Front Right: 0 [0%]
Simple mixer control 'Surround',0
  Capabilities: pvolume pswitch penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 39
  Mono:
  Front Left: Playback 39 [100%] [0.00dB] [on]
  Front Right: Playback 39 [100%] [0.00dB] [on]
Simple mixer control 'Center',0
  Capabilities: pvolume pvolume-joined pswitch pswitch-joined penum
  Playback channels: Mono
  Limits: Playback 0 - 39
  Mono: Playback 39 [100%] [0.00dB] [on]
Simple mixer control 'LFE',0
  Capabilities: pvolume pvolume-joined pswitch pswitch-joined penum
  Playback channels: Mono
  Limits: Playback 0 - 39
  Mono: Playback 39 [100%] [0.00dB] [on]
Simple mixer control 'Side',0
  Capabilities: pvolume pswitch penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 39
  Mono:
  Front Left: Playback 39 [100%] [0.00dB] [on]
  Front Right: Playback 39 [100%] [0.00dB] [on]
Simple mixer control 'Line',0
  Capabilities: pvolume pswitch penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 31
  Mono:
  Front Left: Playback 31 [100%] [12.00dB] [on]
  Front Right: Playback 31 [100%] [12.00dB] [on]
Simple mixer control 'CD',0
  Capabilities: pvolume pswitch penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 31
  Mono:
  Front Left: Playback 30 [97%] [10.50dB] [on]
  Front Right: Playback 30 [97%] [10.50dB] [on]
Simple mixer control 'Mic',0
  Capabilities: pvolume pswitch penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 31
  Mono:
  Front Left: Playback 29 [94%] [9.00dB] [on]
  Front Right: Playback 29 [94%] [9.00dB] [on]
Simple mixer control 'Mic Boost',0
  Capabilities: volume penum
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: 0 - 3
  Front Left: 3 [100%]
  Front Right: 3 [100%]
Simple mixer control 'IEC958',0
  Capabilities: pvolume cvolume pswitch pswitch-joined cswitch cswitch-joined penum
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: Playback 0 - 39 Capture 0 - 31
  Front Left: Playback 0 [0%] [-58.50dB] [on] Capture 23 [74%] [0.00dB] [off]
  Front Right: Playback 0 [0%] [-58.50dB] [on] Capture 23 [74%] [0.00dB] [off]
Simple mixer control 'IEC958 Default PCM',0
  Capabilities: pswitch pswitch-joined penum
  Playback channels: Mono
  Mono: Playback [on]
Simple mixer control 'IEC958 Playback Source',0
  Capabilities: enum
  Items: 'PCM' 'ADC1' 'ADC2' 'ADC3'
  Item0: 'PCM'
Simple mixer control 'Mono',0
  Capabilities: pswitch penum
  Playback channels: Front Left - Front Right
  Mono:
  Front Left: Playback [on]
  Front Right: Playback [on]
Simple mixer control 'Capture',0
  Capabilities: cvolume cswitch penum
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 54
  Front Left: Capture 53 [98%] [21.00dB] [on]
  Front Right: Capture 53 [98%] [21.00dB] [on]
Simple mixer control 'Capture',1
  Capabilities: cvolume cswitch penum
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 54
  Front Left: Capture 42 [78%] [4.50dB] [off]
  Front Right: Capture 42 [78%] [4.50dB] [off]
Simple mixer control 'Capture',2
  Capabilities: cvolume cswitch penum
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 54
  Front Left: Capture 43 [80%] [6.00dB] [off]
  Front Right: Capture 43 [80%] [6.00dB] [off]
Simple mixer control 'Analog Mix',0
  Capabilities: pvolume pswitch penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 31
  Mono:
  Front Left: Playback 25 [81%] [-9.00dB] [on]
  Front Right: Playback 25 [81%] [-9.00dB] [on]
Simple mixer control 'Input Source',0
  Capabilities: cenum
  Items: 'Front Mic' 'Line' 'Mic' 'CD' 'Mix'
  Item0: 'Front Mic'
Simple mixer control 'Input Source',1
  Capabilities: cenum
  Items: 'Front Mic' 'Line' 'Mic' 'CD' 'Mix'
  Item0: 'Front Mic'
Simple mixer control 'Input Source',2
  Capabilities: cenum
  Items: 'Front Mic' 'Line' 'Mic' 'CD' 'Mix'
  Item0: 'Front Mic'


!!Alsactl output
!!-------------

--startcollapse--
state.Q9000 {
	control.1 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'Mic Capture Switch'
		value true
	}
	control.2 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 1
		comment.range '0 - 3072'
		comment.dbmin 1800
		comment.dbmax 3000
		iface MIXER
		name 'Mic Capture Volume'
		value 141
	}
}
state.Aureon51MkII {
	control.1 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'Mic Playback Switch'
		value true
	}
	control.2 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 1
		comment.range '0 - 255'
		comment.dbmin 0
		comment.dbmax 4781
		iface MIXER
		name 'Mic Playback Volume'
		value 42
	}
	control.3 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'Line Playback Switch'
		value false
	}
	control.4 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 255'
		comment.dbmin 0
		comment.dbmax 4781
		iface MIXER
		name 'Line Playback Volume'
		value.0 191
		value.1 191
	}
	control.5 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'Master Playback Switch'
		value true
	}
	control.6 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 1
		comment.range '0 - 255'
		comment.dbmin -4787
		comment.dbmax -6
		iface MIXER
		name 'Master Playback Volume'
		value 241
	}
	control.7 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'Mic Capture Switch'
		value false
	}
	control.8 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 1
		comment.range '0 - 128'
		comment.dbmin 0
		comment.dbmax 2381
		iface MIXER
		name 'Mic Capture Volume'
		value 12
	}
	control.9 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'Mic Capture'
		value false
	}
	control.10 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'Line Capture Switch'
		value false
	}
	control.11 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 128'
		comment.dbmin 0
		comment.dbmax 2381
		iface MIXER
		name 'Line Capture Volume'
		value.0 0
		value.1 0
	}
	control.12 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'IEC958 In Capture Switch'
		value true
	}
	control.13 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Mic
		comment.item.1 Line
		comment.item.2 'IEC958 In'
		iface MIXER
		name 'Capture Source'
		value Mic
	}
}
state.NVidia {
	control.1 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 39'
		comment.dbmin -5850
		comment.dbmax 0
		iface MIXER
		name 'Front Playback Volume'
		value.0 39
		value.1 39
	}
	control.2 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 39'
		comment.dbmin -5850
		comment.dbmax 0
		iface MIXER
		name 'Surround Playback Volume'
		value.0 39
		value.1 39
	}
	control.3 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 1
		comment.range '0 - 39'
		comment.dbmin -5850
		comment.dbmax 0
		iface MIXER
		name 'Center Playback Volume'
		value 39
	}
	control.4 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 1
		comment.range '0 - 39'
		comment.dbmin -5850
		comment.dbmax 0
		iface MIXER
		name 'LFE Playback Volume'
		value 39
	}
	control.5 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 39'
		comment.dbmin -5850
		comment.dbmax 0
		iface MIXER
		name 'Side Playback Volume'
		value.0 39
		value.1 39
	}
	control.6 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Front Playback Switch'
		value.0 true
		value.1 true
	}
	control.7 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Surround Playback Switch'
		value.0 true
		value.1 true
	}
	control.8 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'Center Playback Switch'
		value true
	}
	control.9 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'LFE Playback Switch'
		value true
	}
	control.10 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Side Playback Switch'
		value.0 true
		value.1 true
	}
	control.11 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Headphone Playback Switch'
		value.0 true
		value.1 true
	}
	control.12 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Mono Playback Switch'
		value.0 true
		value.1 true
	}
	control.13 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -3450
		comment.dbmax 1200
		iface MIXER
		name 'CD Playback Volume'
		value.0 30
		value.1 30
	}
	control.14 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'CD Playback Switch'
		value.0 true
		value.1 true
	}
	control.15 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -3450
		comment.dbmax 1200
		iface MIXER
		name 'Front Mic Playback Volume'
		value.0 25
		value.1 25
	}
	control.16 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Front Mic Playback Switch'
		value.0 true
		value.1 true
	}
	control.17 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -3450
		comment.dbmax 1200
		iface MIXER
		name 'Line Playback Volume'
		value.0 31
		value.1 31
	}
	control.18 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Line Playback Switch'
		value.0 true
		value.1 true
	}
	control.19 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -3450
		comment.dbmax 1200
		iface MIXER
		name 'Mic Playback Volume'
		value.0 29
		value.1 29
	}
	control.20 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Mic Playback Switch'
		value.0 true
		value.1 true
	}
	control.21 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -4650
		comment.dbmax 0
		iface MIXER
		name 'Analog Mix Playback Volume'
		value.0 25
		value.1 25
	}
	control.22 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Analog Mix Playback Switch'
		value.0 true
		value.1 true
	}
	control.23 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 3'
		comment.dbmin 0
		comment.dbmax 3000
		iface MIXER
		name 'Front Mic Boost'
		value.0 0
		value.1 0
	}
	control.24 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 3'
		comment.dbmin 0
		comment.dbmax 3000
		iface MIXER
		name 'Mic Boost'
		value.0 3
		value.1 3
	}
	control.25 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 54'
		comment.dbmin -5850
		comment.dbmax 2250
		iface MIXER
		name 'Capture Volume'
		value.0 53
		value.1 53
	}
	control.26 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Capture Switch'
		value.0 true
		value.1 true
	}
	control.27 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 54'
		comment.dbmin -5850
		comment.dbmax 2250
		iface MIXER
		name 'Capture Volume'
		index 1
		value.0 42
		value.1 42
	}
	control.28 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Capture Switch'
		index 1
		value.0 false
		value.1 false
	}
	control.29 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 54'
		comment.dbmin -5850
		comment.dbmax 2250
		iface MIXER
		name 'Capture Volume'
		index 2
		value.0 43
		value.1 43
	}
	control.30 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Capture Switch'
		index 2
		value.0 false
		value.1 false
	}
	control.31 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 'Front Mic'
		comment.item.1 Line
		comment.item.2 Mic
		comment.item.3 CD
		comment.item.4 Mix
		iface MIXER
		name 'Input Source'
		value 'Front Mic'
	}
	control.32 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 'Front Mic'
		comment.item.1 Line
		comment.item.2 Mic
		comment.item.3 CD
		comment.item.4 Mix
		iface MIXER
		name 'Input Source'
		index 1
		value 'Front Mic'
	}
	control.33 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 'Front Mic'
		comment.item.1 Line
		comment.item.2 Mic
		comment.item.3 CD
		comment.item.4 Mix
		iface MIXER
		name 'Input Source'
		index 2
		value 'Front Mic'
	}
	control.34 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 39'
		comment.dbmin -5850
		comment.dbmax 0
		iface MIXER
		name 'IEC958 Playback Volume'
		value.0 0
		value.1 0
	}
	control.35 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 PCM
		comment.item.1 ADC1
		comment.item.2 ADC2
		comment.item.3 ADC3
		iface MIXER
		name 'IEC958 Playback Source'
		value PCM
	}
	control.36 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -3450
		comment.dbmax 1200
		iface MIXER
		name 'IEC958 Capture Volume'
		value.0 23
		value.1 23
	}
	control.37 {
		comment.access read
		comment.type IEC958
		comment.count 1
		iface MIXER
		name 'IEC958 Playback Con Mask'
		value '0fff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
	}
	control.38 {
		comment.access read
		comment.type IEC958
		comment.count 1
		iface MIXER
		name 'IEC958 Playback Pro Mask'
		value '0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
	}
	control.39 {
		comment.access 'read write'
		comment.type IEC958
		comment.count 1
		iface MIXER
		name 'IEC958 Playback Default'
		value '0400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
	}
	control.40 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'IEC958 Playback Switch'
		value true
	}
	control.41 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'IEC958 Default PCM Playback Switch'
		value true
	}
	control.42 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'IEC958 Capture Switch'
		value false
	}
	control.43 {
		comment.access read
		comment.type IEC958
		comment.count 1
		iface MIXER
		name 'IEC958 Capture Default'
		value '0400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
	}
	control.44 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 1
		comment.range '0 - 39'
		comment.dbmin -5850
		comment.dbmax 0
		iface MIXER
		name 'Master Playback Volume'
		value 39
	}
	control.45 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'Master Playback Switch'
		value true
	}
	control.46 {
		comment.access 'read write user'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 255'
		comment.tlv '0000000100000008ffffec1400000014'
		comment.dbmin -5100
		comment.dbmax 0
		iface MIXER
		name 'PCM Playback Volume'
		value.0 255
		value.1 255
	}
}
--endcollapse--


!!All Loaded Modules
!!------------------

Module
vboxnetadp
vboxnetflt
vboxdrv
nvidia
bluetooth
hwmon_vid
af_packet
uinput
snd_pcm_oss
snd_mixer_oss
snd_seq
ipv6
fuse
btrfs
crc32c
libcrc32c
loop
dm_mod
i2c_dev
snd_hda_codec_analog
arc4
ecb
rtl8187
snd_hda_intel
mac80211
snd_hda_codec
snd_usb_audio
led_class
snd_hwdep
uvcvideo
parport_pc
cfg80211
snd_usb_lib
ppdev
kvm_amd
videodev
ohci1394
snd_pcm
snd_rawmidi
rfkill
v4l1_compat
usbhid
snd_timer
r8169
snd_seq_device
v4l2_compat_ioctl32
eeprom_93cx6
hid
kvm
ieee1394
parport
mii
snd
floppy
pcspkr
k8temp
sg
edac_core
asus_atk0110
button
soundcore
snd_page_alloc
i2c_nforce2
forcedeth
i2c_core
ohci_hcd
rtc_cmos
ehci_hcd
rtc_core
rtc_lib
sd_mod
crc_t10dif
usbcore
ext3
mbcache
jbd
edd
jfs
xfs
exportfs
fan
ide_pci_generic
ata_generic
pata_acpi
pata_amd
ahci
pata_jmicron
sata_nv
libata
scsi_mod
amd74xx
ide_core
thermal
processor


!!Sysfs Files
!!-----------

/sys/class/sound/hwC2D0/init_pin_configs:
0x11 0x02214130
0x12 0x01014010
0x13 0x511711f0
0x14 0x02a1912e
0x15 0x01813021
0x16 0x01011012
0x17 0x01a19020
0x18 0x99331122
0x1a 0x91f711f0
0x1b 0x0145f1f0
0x1c 0x41c5f1f0
0x24 0x01016011
0x25 0x01012014

/sys/class/sound/hwC2D0/driver_pin_configs:

/sys/class/sound/hwC2D0/user_pin_configs:

/sys/class/sound/hwC2D0/init_verbs:


!!ALSA/HDA dmesg
!!------------------

wlan0: direct probe to AP 00:1b:9e:82:66:27 timed out
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:708: cannot submit urb (err = -27)
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
wlan0: direct probe to AP 00:1b:9e:82:66:27 (try 1)
--
kmemleak: 2 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
kmemleak: 1 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
php[689] general protection ip:7f630d9b4138 sp:3021837def99698f error:0 in ld-2.11.1.so[7f630d99e000+1f000]
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:708: cannot submit urb (err = -27)
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
php[30161] general protection ip:7fe2b4b0b138 sp:e439f331bc02c843 error:0 in ld-2.11.1.so[7fe2b4af5000+1f000]



--------------080605080704010807060603--


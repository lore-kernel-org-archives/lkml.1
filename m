Return-Path: <linux-kernel-owner+w=401wt.eu-S1752858AbYKJTgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbYKJTgz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 14:36:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750952AbYKJTgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 14:36:47 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:44895 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbYKJTgo (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 14:36:44 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>, perex@perex.cz, tiwai@suse.de
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: 2.6.28-rc2-mm1 - sound semi-busted on Dell Latitude D820
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1226345758_3458P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 10 Nov 2008 14:35:58 -0500
Message-ID: <4411.1226345758@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1226345758_3458P
Content-Type: multipart/mixed ;
	boundary="==_Exmh_1226345739_34580"

This is a multipart MIME message.

--==_Exmh_1226345739_34580
Content-Type: text/plain; charset=us-ascii

Sometime between -mmotm1017  and -rc2-mm1, something odd happened to the
sound subsystem.  On my Dell Latitude D820, audio works OK if it's sitting
there standalone, or in its docking station.

However, when I plug in headphones, it goes silent.

Sorry for not having any more detail, but I've not had a chance to bisect
this down to a specific commit.

I did run alsa-info for the two kernels, here's a diff between them. I also
attached a copy of the full output for working -mmotm1017.

(- lines are working -mmotm-1017, + are busted -rc2-mm1)

--- alsa-info-mmotm1017 2008-11-10 14:17:04.000000000 -0500
+++ alsa-info-rc3-mm1   2008-11-10 14:13:17.000000000 -0500
@@ -3,7 +3,7 @@
 !!ALSA Information Script v 0.4.51
 !!################################
 
-!!Script ran on: Mon Nov 10 14:16:47 EST 2008
+!!Script ran on: Mon Nov 10 14:12:28 EST 2008
 
 
 !!Linux Distribution
@@ -15,7 +15,7 @@
 !!Kernel Information
 !!------------------
 
-Kernel release:    2.6.27-mmotm1017
+Kernel release:    2.6.28-rc3-mm1
 Operating System:  GNU/Linux
 Architecture:      x86_64
 Processor:         x86_64
@@ -25,7 +25,7 @@
 !!ALSA Version
 !!------------
 
-Driver version:     1.0.18rc3
+Driver version:     1.0.18
 Library version:    1.0.18rc3
 Utilities version:  1.0.18rc3
 
@@ -39,7 +39,7 @@
 !!-----------------------------
 
  0 [Intel          ]: HDA-Intel - HDA Intel
-                      HDA Intel at 0xefffc000 irq 314
+                      HDA Intel at 0xefffc000 irq 41
 
 
 !!PCI Soundcards installed in the system
@@ -165,8 +165,8 @@
   Pin Default 0x0321121f: [Jack] HP Out at Ext Left
     Conn = 1/8, Color = Black
     DefAssociation = 0x1, Sequence = 0xf
-  Pin-ctls: 0xc0: OUT HP
-  Unsolicited: tag=30, enabled=1
+  Pin-ctls: 0x00:
+  Unsolicited: tag=3d, enabled=1
   Connection: 1
      0x0b
 Node 0x0e [Pin Complex] wcaps 0x400181: Stereo
@@ -234,12 +234,12 @@
 !!ALSA Device nodes
 !!-----------------

Looks like it lost the bits that setup the headphone jack.



--==_Exmh_1226345739_34580
Content-Type: text/plain ; name="alsa-info-mmotm1017"; charset=us-ascii
Content-Description: alsa-info-mmotm1017
Content-Disposition: attachment; filename="alsa-info-mmotm1017"

upload=true&script=true&cardinfo=
!!################################
!!ALSA Information Script v 0.4.51
!!################################

!!Script ran on: Mon Nov 10 14:16:47 EST 2008


!!Linux Distribution
!!------------------

Fedora release 9.93 (Rawhide) Fedora release 9.93 (Rawhide) Fedora release 9.93 (Rawhide) Fedora release 9.93 (Rawhide)


!!Kernel Information
!!------------------

Kernel release:    2.6.27-mmotm1017
Operating System:  GNU/Linux
Architecture:      x86_64
Processor:         x86_64
SMP Enabled:       Yes


!!ALSA Version
!!------------

Driver version:     1.0.18rc3
Library version:    1.0.18rc3
Utilities version:  1.0.18rc3


!!Loaded ALSA modules
!!-------------------



!!Soundcards recognised by ALSA
!!-----------------------------

 0 [Intel          ]: HDA-Intel - HDA Intel
                      HDA Intel at 0xefffc000 irq 314


!!PCI Soundcards installed in the system
!!--------------------------------------

00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 01)


!!Advanced information - PCI Vendor/Device/Susbsystem ID's
!!--------------------------------------------------------

00:1b.0 0403: 8086:27d8 (rev 01)
	Subsystem: 1028:01cc


!!Modprobe options (Sound related)
!!--------------------------------

snd-card-0: index=0
snd-hda-intel: index=0 enable_msi=1 power_save=5


!!Loaded sound module options
!!--------------------------


!!HDA-Intel Codec information
!!---------------------------
--startcollapse--

Codec: SigmaTel STAC9200
Address: 0
Vendor Id: 0x83847690
Subsystem Id: 0x102801cc
Revision Id: 0x102201
No Modem Function Group found
Default PCM:
    rates [0x7e0]: 44100 48000 88200 96000 176400 192000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
Default Amp-In caps: N/A
Default Amp-Out caps: ofs=0x1f, nsteps=0x1f, stepsize=0x05, mute=1
GPIO: io=4, o=0, i=0, unsolicited=1, wake=1
  IO[0]: enable=0, dir=0, wake=0, sticky=0, data=0
  IO[1]: enable=0, dir=0, wake=0, sticky=0, data=0
  IO[2]: enable=0, dir=0, wake=0, sticky=0, data=0
  IO[3]: enable=0, dir=0, wake=0, sticky=0, data=0
Node 0x02 [Audio Output] wcaps 0xd0401: Stereo
  Converter: stream=0, channel=0
  Power: setting=D0, actual=D0
  Delay: 13 samples
Node 0x03 [Audio Input] wcaps 0x1d0541: Stereo
  Converter: stream=0, channel=0
  SDI-Select: 0
  Power: setting=D0, actual=D0
  Delay: 13 samples
  Connection: 1
     0x0a
  Processing caps: benign=0, ncoeff=0
Node 0x04 [Audio Input] wcaps 0x140311: Stereo Digital
  Converter: stream=0, channel=0
  SDI-Select: 0
  Digital:
  Digital category: 0x0
  PCM:
    rates [0x160]: 44100 48000 96000
    bits [0xe]: 16 20 24
    formats [0x5]: PCM AC3
  Delay: 4 samples
  Connection: 1
     0x08
Node 0x05 [Audio Output] wcaps 0x40211: Stereo Digital
  Converter: stream=0, channel=0
  Digital:
  Digital category: 0x0
  PCM:
    rates [0x1e0]: 44100 48000 88200 96000
    bits [0xe]: 16 20 24
    formats [0x5]: PCM AC3
  Delay: 4 samples
Node 0x06 [Vendor Defined Widget] wcaps 0xf30201: Stereo Digital
  Delay: 3 samples
Node 0x07 [Audio Selector] wcaps 0x300901: Stereo R/L
  Connection: 3
     0x02* 0x08 0x0a
Node 0x08 [Pin Complex] wcaps 0x430681: Stereo Digital
  Pincap 0x00010024: IN EAPD Detect
  EAPD 0x0:
  Pin Default 0x40c003fa: [N/A] SPDIF In at Ext N/A
    Conn = Unknown, Color = Unknown
    DefAssociation = 0xf, Sequence = 0xa
    Misc = NO_PRESENCE
  Pin-ctls: 0x00:
  Unsolicited: tag=00, enabled=0
  Power: setting=D0, actual=D0
  Delay: 3 samples
Node 0x09 [Pin Complex] wcaps 0x400301: Stereo Digital
  Pincap 0x00000010: OUT
  Pin Default 0x0144131f: [Jack] SPDIF Out at Ext Rear
    Conn = RCA, Color = Black
    DefAssociation = 0x1, Sequence = 0xf
    Misc = NO_PRESENCE
  Pin-ctls: 0x40: OUT
  Connection: 2
     0x05* 0x0a
Node 0x0a [Audio Selector] wcaps 0x30090d: Stereo Amp-Out R/L
  Amp-Out caps: ofs=0x00, nsteps=0x0f, stepsize=0x05, mute=1
  Amp-Out vals:  [0x0d 0x0d]
  Connection: 1
     0x0c
Node 0x0b [Audio Selector] wcaps 0x300105: Stereo Amp-Out
  Amp-Out caps: N/A
  Amp-Out vals:  [0x80 0x80]
  Connection: 1
     0x07
Node 0x0c [Audio Selector] wcaps 0x30010d: Stereo Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x04, stepsize=0x27, mute=0
  Amp-Out vals:  [0x00 0x00]
  Connection: 5
     0x10 0x0f* 0x0e 0x0d 0x12
Node 0x0d [Pin Complex] wcaps 0x400181: Stereo
  Pincap 0x0000003f: IN OUT HP Detect Trigger ImpSense
  Pin Default 0x0321121f: [Jack] HP Out at Ext Left
    Conn = 1/8, Color = Black
    DefAssociation = 0x1, Sequence = 0xf
  Pin-ctls: 0xc0: OUT HP
  Unsolicited: tag=30, enabled=1
  Connection: 1
     0x0b
Node 0x0e [Pin Complex] wcaps 0x400181: Stereo
  Pincap 0x0000003f: IN OUT HP Detect Trigger ImpSense
  Pin Default 0x90170310: [Fixed] Speaker at Int N/A
    Conn = Analog, Color = Unknown
    DefAssociation = 0x1, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x40: OUT
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x0b
Node 0x0f [Pin Complex] wcaps 0x400181: Stereo
  Pincap 0x00000037: IN OUT Detect Trigger ImpSense
  Pin Default 0x90a70321: [Fixed] Mic at Int N/A
    Conn = Analog, Color = Unknown
    DefAssociation = 0x2, Sequence = 0x1
    Misc = NO_PRESENCE
  Pin-ctls: 0x20: IN
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x0b
Node 0x10 [Pin Complex] wcaps 0x400181: Stereo
  Pincap 0x00001737: IN OUT Detect Trigger ImpSense
    Vref caps: HIZ 50 GRD 80
  Pin Default 0x03a11020: [Jack] Mic at Ext Left
    Conn = 1/8, Color = Black
    DefAssociation = 0x2, Sequence = 0x0
  Pin-ctls: 0x20: IN VREF_HIZ
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x0b
Node 0x11 [Pin Complex] wcaps 0x400104: Mono Amp-Out
  Amp-Out caps: N/A
  Amp-Out vals:  [0x00]
  Pincap 0x00000010: OUT
  Pin Default 0x401003fb: [N/A] Speaker at Ext N/A
    Conn = Unknown, Color = Unknown
    DefAssociation = 0xf, Sequence = 0xb
    Misc = NO_PRESENCE
  Pin-ctls: 0x00:
  Connection: 1
     0x13
Node 0x12 [Pin Complex] wcaps 0x400001: Stereo
  Pincap 0x00000020: IN
  Pin Default 0x40f000fc: [N/A] Other at Ext N/A
    Conn = Unknown, Color = Unknown
    DefAssociation = 0xf, Sequence = 0xc
  Pin-ctls: 0x20: IN
Node 0x13 [Audio Mixer] wcaps 0x200100: Mono
  Connection: 1
     0x07
Node 0x14 [Beep Generator Widget] wcaps 0x70000c: Mono Amp-Out
  Amp-Out caps: ofs=0x03, nsteps=0x03, stepsize=0x17, mute=1
  Amp-Out vals:  [0x00]
Codec: Conexant ID 2bfa
Address: 1
Vendor Id: 0x14f12bfa
Subsystem Id: 0x14f100c3
Revision Id: 0x90000
Modem Function Group: 0x2
--endcollapse--


!!ALSA Device nodes
!!-----------------

crw-rw----+ 1 valdis root 116, 7 2008-11-10 14:14 /dev/snd/controlC0
crw-rw----+ 1 valdis root 116, 6 2008-11-10 14:16 /dev/snd/pcmC0D0c
crw-rw----+ 1 valdis root 116, 5 2008-11-10 14:16 /dev/snd/pcmC0D0p
crw-rw----+ 1 valdis root 116, 4 2008-11-10 14:14 /dev/snd/pcmC0D1p
crw-rw----+ 1 valdis root 116, 3 2008-11-10 14:14 /dev/snd/seq
crw-rw----+ 1 valdis root 116, 2 2008-11-10 14:14 /dev/snd/timer


!!ALSA configuration files
!!------------------------

!!User specific config file (~/.asoundrc)

pcm.!default {
	type pulse
}

ctl.!default {
	type pulse
}


!!System wide config file (/etc/asound.conf)

#
# Place your global alsa-lib configuration here...
#

@hooks [
	{
		func load
		files [
			"/etc/alsa/pulse-default.conf"
		]
		errors false
	}
]


!!Aplay/Arecord output
!!------------

APLAY

**** List of PLAYBACK Hardware Devices ****
card 0: Intel [HDA Intel], device 0: STAC92xx Analog [STAC92xx Analog]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 0: Intel [HDA Intel], device 1: STAC92xx Digital [STAC92xx Digital]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

ARECORD

**** List of CAPTURE Hardware Devices ****
card 0: Intel [HDA Intel], device 0: STAC92xx Analog [STAC92xx Analog]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

!!Amixer output
!!-------------

!!-------Mixer controls for card 0 [Intel]

Card hw:0 'Intel'/'HDA Intel at 0xefffc000 irq 314'
  Mixer name	: 'SigmaTel STAC9200'
  Components	: 'HDA:83847690,102801cc,00102201 HDA:14f12bfa,14f100c3,00090000'
  Controls      : 10
  Simple ctrls  : 5
Simple mixer control 'Master',0
  Capabilities: pvolume pswitch
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 31
  Mono:
  Front Left: Playback 0 [0%] [-46.50dB] [off]
  Front Right: Playback 0 [0%] [-46.50dB] [off]
Simple mixer control 'IEC958',0
  Capabilities: pswitch pswitch-joined
  Playback channels: Mono
  Mono: Playback [off]
Simple mixer control 'IEC958 Default PCM',0
  Capabilities: pswitch pswitch-joined
  Playback channels: Mono
  Mono: Playback [on]
Simple mixer control 'Capture',0
  Capabilities: cvolume cswitch
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 15
  Front Left: Capture 13 [87%] [19.50dB] [on]
  Front Right: Capture 13 [87%] [19.50dB] [on]
Simple mixer control 'Input Source',0
  Capabilities: cenum
  Items: 'Mic' 'Front Mic'
  Item0: 'Mic'


!!Alsactl output
!!-------------

--startcollapse--
state.Intel {
	control.1 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 31'
		comment.dbmin -4650
		comment.dbmax 0
		iface MIXER
		name 'Master Playback Volume'
		value.0 0
		value.1 0
	}
	control.2 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Master Playback Switch'
		value.0 false
		value.1 false
	}
	control.3 {
		comment.access 'read write'
		comment.type ENUMERATED
		comment.count 1
		comment.item.0 Mic
		comment.item.1 'Front Mic'
		iface MIXER
		name 'Input Source'
		value Mic
	}
	control.4 {
		comment.access 'read write'
		comment.type INTEGER
		comment.count 2
		comment.range '0 - 15'
		comment.dbmin 0
		comment.dbmax 2250
		iface MIXER
		name 'Capture Volume'
		value.0 13
		value.1 13
	}
	control.5 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 2
		iface MIXER
		name 'Capture Switch'
		value.0 true
		value.1 true
	}
	control.6 {
		comment.access read
		comment.type IEC958
		comment.count 1
		iface MIXER
		name 'IEC958 Playback Con Mask'
		value '0fff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
	}
	control.7 {
		comment.access read
		comment.type IEC958
		comment.count 1
		iface MIXER
		name 'IEC958 Playback Pro Mask'
		value '0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
	}
	control.8 {
		comment.access 'read write'
		comment.type IEC958
		comment.count 1
		iface MIXER
		name 'IEC958 Playback Default'
		value '0400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
	}
	control.9 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'IEC958 Playback Switch'
		value false
	}
	control.10 {
		comment.access 'read write'
		comment.type BOOLEAN
		comment.count 1
		iface MIXER
		name 'IEC958 Default PCM Playback Switch'
		value true
	}
}
--endcollapse--


!!All Loaded Modules
!!------------------

Module
irnet
ppp_generic
slhc
irtty_sir
sir_dev
ircomm_tty
ircomm
irda
crc_ccitt
coretemp
nf_conntrack_ftp
xt_pkttype
ipt_REJECT
nf_conntrack_ipv4
nf_defrag_ipv4
xt_ipisforif
xt_recent
ipt_LOG
xt_u32
iptable_filter
ip_tables
xt_tcpudp
nf_conntrack_ipv6
xt_state
nf_conntrack
ip6t_LOG
xt_limit
ip6table_filter
ip6_tables
x_tables
sha256_generic
aes_x86_64
aes_generic
rtc
acpi_cpufreq
tpm_tis
tpm
tpm_bios
gspca_spca561
gspca_main
compat_ioctl32
videodev
arc4
ecb
v4l1_compat
nvidia
pcmcia
iwl3945
rfkill
mac80211
ohci1394
snd_hda_intel
ieee1394
yenta_socket
rsrc_nonstatic
pcmcia_core
video
led_class
uhci_hcd
output
iTCO_wdt
cfg80211
iTCO_vendor_support
thermal
intel_agp
processor
battery
button
dcdbas
ac



--==_Exmh_1226345739_34580--


--==_Exmh_1226345758_3458P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJGI0ecC3lWbTT17ARAu6hAKDTS/45OfL+sJO9nl5bg8pmdNO8WgCgynLk
74I7UDq2FSgYMRsp2tyk6pc=
=YgmU
-----END PGP SIGNATURE-----

--==_Exmh_1226345758_3458P--

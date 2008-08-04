Return-Path: <linux-kernel-owner+w=401wt.eu-S1754006AbYHDLRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbYHDLRS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 07:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752970AbYHDLRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 07:17:03 -0400
Received: from piggy.rz.tu-ilmenau.de ([141.24.4.8]:49044 "EHLO
	piggy.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906AbYHDLRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 07:17:01 -0400
Date: Mon, 4 Aug 2008 13:16:54 +0200
From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
To: video4linux-list@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: bttv: video grabbing via v4l1 does not work since 2.6.25
Message-ID: <20080804111654.GA14074@darkside.22.kls.lan>
Mail-Followup-To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>,
	video4linux-list@redhat.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qcHopEYAB45HaUaB"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qcHopEYAB45HaUaB
Content-Type: multipart/mixed; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

with 2.6.25 bttv video grabbing via vlc stopped working.
vlc is stable version 0.8.6.h which uses v4l(1) interface only.
Up to 2.6.24 everything was working well.
I suspect the reason to be somewhere in the v4l1->v4l2 conversion done
in 2.6.25:

	commit 402aa76aa5e57801b4db5ccf8c7beea9f580bb1b
	Author: Douglas Schilling Landgraf <dougsland@gmail.com>
	    V4L/DVB (6911): Converted bttv to use video_ioctl2

	commit e84619b17440ccca4e4db7583d126c4189b987e5
	Author: Nickolay V. Shmyrev <nshmyrev@yandex.ru>
	    V4L/DVB (6410): Partial conversion from V4L1 to V4L2

Video capturing via xawtv (overlay as well as grabdisplay method) does
still work with 2.6.25/26.

I attached the relevant dmesg snippets from bttv initialization and vlc
debugging output both for 2.6.24 and 2.6.26 as well as v4l1-compat debug
messages for 2.6.26 (there are no v4l1-compat messages for 2.6.24).

It seems like vlc is no longer able to select the I420 chroma. Please
also note the changed vlc device recognition from "1 audios" to
"0 audios" in .26. Audio grabbing did stop working as well.

The card in question is a Hauppauge WinTV PCI FM.
The vlc commandline is:
vlc -vv v4l:///dev/video0:adev=3D/dev/dsp:audio=3D0:tuner=3D0:norm=3Dpal:fr=
equency=3D182250:size=3D720x576     =20

If you need more info, please let me know.

Please CC: me in replies, M-F'up2 should be set correctly.


regards
   Mario
--=20
There are two major products that come from Berkeley: LSD and UNIX.
We don't believe this to be a coincidence.    -- Jeremy S. Anderson

--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.2.6.24"

Linux video capture interface: v2.00
bttv: driver version 0.9.17 loaded
bttv: using 8 buffers with 2080k (520 pages) each for capture
bttv: Bt8xx card found (0).
ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 16 (level, low) -> IRQ 17
bttv0: Bt878 (rev 17) at 0000:04:00.0, irq: 17, latency: 64, mmio: 0xfdffe000
bttv0: detected: Hauppauge WinTV [card=10], PCI subsystem ID is 0070:13eb
bttv0: using: Hauppauge (bt878) [card=10,autodetected]
bttv0: gpio: en=00000000, out=00000000 in=00ffffdb [init]
bttv0: Hauppauge/Voodoo msp34xx: reset line init [5]
tveeprom 1-0050: Hauppauge model 44354, rev C121, serial# 2268107
tveeprom 1-0050: tuner model is Philips FM1216 (idx 21, type 5)
tveeprom 1-0050: TV standards PAL(B/G) (eeprom 0x04)
tveeprom 1-0050: audio processor is MSP3415 (idx 6)
tveeprom 1-0050: has radio
bttv0: Hauppauge eeprom indicates model#44354
bttv0: tuner type=5
bttv0: i2c: checking for MSP34xx @ 0x80... found
msp3400 1-0040: MSP3415D-B3 found @ 0x80 (bt878 #0 [sw])
msp3400 1-0040: MSP3415D-B3 supports nicam, mode is autodetect
bttv0: i2c: checking for TDA9875 @ 0xb0... not found
bttv0: i2c: checking for TDA7432 @ 0x8a... not found
tuner 1-0061: chip found @ 0xc2 (bt878 #0 [sw])
tuner-simple 1-0061: type set to 5 (Philips PAL_BG (FI1216 and compatibles))
tuner 1-0061: type set to Philips PAL_BG (FI1
tuner-simple 1-0061: type set to 5 (Philips PAL_BG (FI1216 and compatibles))
tuner 1-0061: type set to Philips PAL_BG (FI1
bttv0: registered device video0
bttv0: registered device vbi0
bttv0: registered device radio0
bttv0: PLL: 28636363 => 35468950 .. ok
ACPI: PCI Interrupt 0000:04:00.1[A] -> GSI 16 (level, low) -> IRQ 17
bt87x0: Using board 1, analog, digital (rate 32000 Hz)
bt878: AUDIO driver version 0.0.0 loaded

--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.2.6.26"

[   24.368869] Linux video capture interface: v2.00
[   24.404665] bttv: driver version 0.9.17 loaded
[   24.429120] bttv: using 8 buffers with 2080k (520 pages) each for capture
[   24.453477] ACPI: PCI Interrupt 0000:04:00.1[A] -> GSI 16 (level, low) -> IRQ 16
[   24.476702] bt87x0: Using board 1, analog, digital (rate 32000 Hz)
[   24.512622] bttv: Bt8xx card found (0).
[   24.512622] ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[   24.544708] bttv0: Bt878 (rev 17) at 0000:04:00.0, irq: 16, latency: 64, mmio: 0xfdffe000
[   24.570800] bttv0: detected: Hauppauge WinTV [card=10], PCI subsystem ID is 0070:13eb
[   24.597855] bttv0: using: Hauppauge (bt878) [card=10,autodetected]
[   24.621849] bttv0: gpio: en=00000000, out=00000000 in=00ffffdb [init]
[   24.641830] bttv0: Hauppauge/Voodoo msp34xx: reset line init [5]
[   24.690793] tveeprom 1-0050: Hauppauge model 44354, rev C121, serial# 2268107
[   24.710797] tveeprom 1-0050: tuner model is Philips FM1216 (idx 21, type 5)
[   24.731631] tveeprom 1-0050: TV standards PAL(B/G) (eeprom 0x04)
[   24.750048] tveeprom 1-0050: audio processor is MSP3415 (idx 6)
[   24.767768] tveeprom 1-0050: has radio
[   24.779001] bttv0: Hauppauge eeprom indicates model#44354
[   24.795167] bttv0: tuner type=5
[   24.806331] bttv0: i2c: checking for MSP34xx @ 0x80... found
[   24.855672] msp3400' 1-0040: MSP3415D-B3 found @ 0x80 (bt878 #0 [sw])
[   24.875254] msp3400' 1-0040: msp3400 supports nicam, mode is autodetect
[   24.903715] bttv0: i2c: checking for TDA9875 @ 0xb0... not found
[   24.919763] bttv0: i2c: checking for TDA7432 @ 0x8a... not found
[   24.988073] tuner' 1-0061: chip found @ 0xc2 (bt878 #0 [sw])
[   25.096455] tuner-simple 1-0061: creating new instance
[   25.109634] tuner-simple 1-0061: type set to 5 (Philips PAL_BG (FI1216 and compatibles))
[   25.158913] bttv0: registered device video0
[   25.172353] bttv0: registered device vbi0
[   25.186470] bttv0: registered device radio0
[   25.204435] bttv0: PLL: 28636363 => 35468950 .. ok
[   25.280931] bt878: AUDIO driver version 0.0.0 loaded

--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="vlc.2.6.24"

[00000287] v4l demuxer debug: WxH 720x576
[00000287] v4l demuxer debug: main device=`/dev/video0'
[00000287] v4l demuxer debug: V4L device BT878 video (Hauppauge (bt878)) 4 channels 1 audios 48 < w < 924 32 < h < 576
[00000287] v4l demuxer debug: setting channel Television(0) 1 tuners flags=0x3 type=0x1 norm=0x0
[00000287] v4l demuxer debug: frequency 182250 (2916)
[00000287] v4l demuxer debug: v4l device uses brightness: 32768
[00000287] v4l demuxer debug: v4l device uses colour: 32768
[00000287] v4l demuxer debug: v4l device uses hue: 32768
[00000287] v4l demuxer debug: v4l device uses contrast: 26214
[00000287] v4l demuxer debug: v4l device uses frame size: 622080
[00000287] v4l demuxer debug: v4l device uses chroma: I420
[00000287] v4l demuxer debug: opened adev=`/dev/dsp' stereo 44100Hz
[00000287] v4l demuxer debug: v4l grabbing started
[00000287] v4l demuxer debug: added new video es I420 720x576
[00000287] v4l demuxer debug: new audio es 2 channels 44100Hz

--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="vlc.2.6.26"

[00000287] v4l demuxer debug: WxH 720x576
[00000287] v4l demuxer debug: main device=`/dev/video0'
[00000287] v4l demuxer debug: V4L device BT878 video (Hauppauge (bt878)) 4 channels 0 audios 48 < w < 924 32 < h < 576
[00000287] v4l demuxer debug: setting channel Television(0) 1 tuners flags=0x1 type=0x1 norm=0x0
[00000287] v4l demuxer debug: frequency 182250 (2916)
[00000287] v4l demuxer debug: v4l device uses brightness: 32768
[00000287] v4l demuxer debug: v4l device uses colour: 32768
[00000287] v4l demuxer debug: v4l device uses hue: 32768
[00000287] v4l demuxer debug: v4l device uses contrast: 26214
[00000287] v4l demuxer debug: v4l device uses frame size: 622080
[00000287] v4l demuxer debug: v4l device uses chroma: I420
[00000287] v4l demuxer warning: I420 refused
[00000287] v4l demuxer error: chroma selection failed
[00000287] v4l demuxer error: cannot set audio format (16b little endian) (Invalid argument)
[00000287] v4l demuxer debug: V4L device BT878 video (Hauppauge (bt878)) 4 channels 0 audios 48 < w < 924 32 < h < 576
[00000287] v4l demuxer debug: setting channel Television(0) 1 tuners flags=0x1 type=0x1 norm=0x0
[00000287] v4l demuxer debug: frequency 182250 (2916)
[00000287] v4l demuxer debug: v4l device uses brightness: 32768
[00000287] v4l demuxer debug: v4l device uses colour: 32768
[00000287] v4l demuxer debug: v4l device uses hue: 32768
[00000287] v4l demuxer debug: v4l device uses contrast: 26214
[00000287] v4l demuxer debug: v4l device uses frame size: 622080
[00000287] v4l demuxer debug: v4l device uses chroma: I420
[00000287] v4l demuxer warning: I420 refused
[00000287] v4l demuxer error: chroma selection failed
[00000287] v4l demuxer debug: opened adev=`/dev/dsp' stereo 44100Hz
[00000287] v4l demuxer debug: v4l grabbing started
[00000287] v4l demuxer debug: new audio es 2 channels 44100Hz

--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="v4l1-compat.2.6.26"

[ 1476.260792] v4l1-compat: VIDIOCSPICT / VIDIOC_S_FBUF: -1
[ 1476.260792] v4l1-compat: VIDIOCSPICT / VIDIOC_S_FBUF: -1
[ 1476.260792] v4l1-compat: VIDIOCMCAPTURE / VIDIOC_S_FMT: -16
[ 1476.272793] v4l1-compat: VIDIOCSPICT / VIDIOC_S_FBUF: -1
[ 1476.272793] v4l1-compat: VIDIOCSPICT / VIDIOC_S_FBUF: -1
[ 1476.272793] v4l1-compat: VIDIOCMCAPTURE / VIDIOC_S_FMT: -16

--VbJkn9YxBvnuCH5J--

--qcHopEYAB45HaUaB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQEVAwUBSJblJhS+e2HeSPbpAQIvgggAmfL1abVm4mkMIXJgp1wh0WXlJ9Pk+AJU
/DSummjsQfZbcJHltLZvy32Sb525y19GL5Q/zljeGfggUAwIzneV4L82F/JGjdwz
tNVbXQR0OsXUvqgRROHXnkk22aGiMV5hzgYWY/2eGYbQpgNrDagIx/mOlNvFZi1n
HC79ITqBJEO2vQdXmXO9/DampNpLb53jBdHLw5RFzoAi5hkfZXW8OaDB0kt298lM
8bjT95HwCgNNs4hxdYUUTwF+wsrSt6TvKktZ41GoBS8t1WgwSEbXP143n46cNfVo
EdnBwMvaOV0goUzuibyHpyJUM2uj/1KjFohBgqybxlz1h3jgnRMxvA==
=zYWY
-----END PGP SIGNATURE-----

--qcHopEYAB45HaUaB--

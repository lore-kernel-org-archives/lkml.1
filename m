Return-Path: <linux-kernel-owner+w=401wt.eu-S1758379AbZFIGsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379AbZFIGsE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 02:48:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756565AbZFIGry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 02:47:54 -0400
Received: from mail.technotrend.de ([212.185.20.147]:52415 "EHLO
	mail.technotrend.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756164AbZFIGrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 02:47:53 -0400
X-Greylist: delayed 486 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Jun 2009 02:47:53 EDT
Date: Tue, 9 Jun 2009 08:39:48 +0200
From: Martin Zwickel <martin.zwickel@novabasedigitaltv.de>
To: linux-kernel@vger.kernel.org
Subject: FDTI-SIO: kernel-oops after resume
Message-ID: <20090609063948.GA17564@novabasedigitaltv.de>
Reply-To: Martin Zwickel <martin.zwickel@novabasedigitaltv.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
X-Operating-System: Linux dieter 2.6.29.3-Xeno 
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

I got an oops after resuming from suspend S3 state.

I had the ttyUSB0 opened with minicom and went to suspend S3.
While in suspend I removed the physical serial device converter.
While resuming I got this kernel oops:

[output]
BUG: unable to handle kernel NULL pointer dereference at 00000044
IP: [<c012ba40>] del_timer+0xc/0x4c
*pde =3D 00000000=20
Oops: 0000 [#1] PREEMPT SMP=20
last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
Modules linked in: iptable_filter ip_tables x_tables i915 fb drm
i2c_algo_bit cfbcopyarea i2c_core cfbimgblt cfbfillrect ipv6
snd_hda_codec_conexant snd_hda_intel ftdi_sio iwlagn usbserial iwlcore
snd_hda_codec pcspkr evdev

Pid: 16129, comm: minicom Not tainted (2.6.29.4 #3) ESPRIMO Mobile V5505   =
       =20
  =20
EIP: 0060:[<c012ba40>] EFLAGS: 00210286 CPU: 0
EIP is at del_timer+0xc/0x4c
EAX: 00000044 EBX: 00000044 ECX: f2224b00 EDX: 00000044
ESI: 00000000 EDI: 00000000 EBP: f6489df0 ESP: f6489de4
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process minicom (pid: 16129, ti=3Df6488000 task=3Df1b54000 task.ti=3Df64880=
00)
Stack:
 00000000 f1a31c00 00000034 f6489e38 c01311a3 00000044 00200246 f6489e20
 00200246 00000000 c0609e00 00000002 00000000 f6489e44 00200246 f6489e30
 c014e2a6 c1aa7f80 f1a31c00 00000400 00000000 f6489e40 c01312c3 f6489e58
Call Trace:
 [<c01311a3>] ? __cancel_work_timer+0x20/0x135
 [<c014e2a6>] ? __pagevec_free+0x17/0x1e
 [<c01312c3>] ? cancel_delayed_work_sync+0xb/0xd
 [<f8103692>] ? ftdi_close+0xc3/0xe2 [ftdi_sio]
 [<c0175977>] ? fasync_helper+0xb3/0xbc
 [<f820d722>] ? serial_close+0x7b/0x113 [usbserial]
 [<c02a165c>] ? tty_release_dev+0x15b/0x392
 [<c014e2a6>] ? __pagevec_free+0x17/0x1e
 [<c0167c27>] ? add_partial+0x44/0x49
 [<c017d860>] ? mntput_no_expire+0x18/0xe7
 [<c0178b67>] ? dput+0x1d/0xfc
 [<c02a18a5>] ? tty_release+0x12/0x1c
 [<c016d193>] ? __fput+0xaf/0x155
 [<c016d45d>] ? fput+0x17/0x19
 [<c016ae36>] ? filp_close+0x51/0x5b
 [<c0125870>] ? put_files_struct+0x68/0xaa
 [<c01258e9>] ? exit_files+0x37/0x3c
 [<c012681d>] ? do_exit+0x150/0x62e
 [<c0126d5a>] ? do_group_exit+0x5f/0x88
 [<c0126d92>] ? sys_exit_group+0xf/0x13
 [<c0102df1>] ? sysenter_do_call+0x12/0x25
Code: 04 0f 0b eb fe 39 50 08 75 0a 83 38 00 b9 01 00 00 00 75 07 e8 10 fe =
ff ff 89 c1 5d 89 c8 c3 55 89 e5 56 31 f6 53 89 c3 83 ec 04 <83> 38 00 74 3=
4 8d 55 f4 e8 4c fd ff ff 83 3b 00 89 c1 74 1b 8b=20
EIP: [<c012ba40>] del_timer+0xc/0x4c SS:ESP 0068:f6489de4
---[ end trace 679defbdbe4aa1e4 ]---
[/output]

Minicom said it lost the device, but was unable to close it.

The attached device:
[output]
USB Serial support registered for FTDI USB Serial Device
ftdi_sio 6-1:1.0: FTDI USB Serial Device converter detected
usb 6-1: Detected FT8U232AM
usb 6-1: FTDI USB Serial Device converter now attached to ttyUSB0
usbcore: registered new interface driver ftdi_sio
ftdi_sio: v1.4.3:USB FTDI Serial Converters Driver
[/output]


My kernel runs with SMP and HIGHMEM if it matters:
Linux tt-business 2.6.29.4 #3 SMP PREEMPT Fri Jun 5 00:03:39 WEST 2009 i686=
 Intel(R) Core(TM)2 Duo CPU T7300 @ 2.00GHz GenuineIntel GNU/Linux


Best regards,
   Martin

--gKMricLos+KVdGMg
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEABECAAYFAkouA7QACgkQ/XnDWy8tQ2dbIwCdF7zpsgrUpUFr6XkszlLoXLb6
tXQAoKTLE1s8Wsi6kT4k5mD+0Kls3WmO
=BEDd
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--

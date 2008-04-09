Return-Path: <linux-kernel-owner+w=401wt.eu-S1754744AbYDIOfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744AbYDIOfN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 10:35:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbYDIOfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 10:35:01 -0400
Received: from wp093.webpack.hosteurope.de ([80.237.132.100]:52146 "EHLO
	wp093.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751979AbYDIOfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 10:35:00 -0400
X-Greylist: delayed 1627 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Apr 2008 10:35:00 EDT
Message-ID: <47FCCDB7.9070203@nuuz.at>
Date: Wed, 09 Apr 2008 16:07:51 +0200
From: Marcus Nutzinger <marcus@nuuz.at>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Kernel BUG at fs/sysfs/file.c:552
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;marcus@nuuz.at;1207751700;32c46ed7;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi!

I wrote a little kernel module (a "virtual char-device") and wanted to
create a sysfs entry for my device under /sys/devices. When using
"device_register" and "device_create_file", I get the following kernel
BUG message (and the module stops loading): (Kernel is 2.6.24.4)


- ------------[ cut here ]------------
kernel BUG at fs/sysfs/file.c:552!
invalid opcode: 0000 [#1] SMP
Modules linked in: vdd nvidia(P) fuse kqemu snd_hda_intel snd_pcm_oss
snd_mixer_oss snd_pcm i2c_i801 snd_timer snd_page_alloc snd_hwdep
i2c_core usb_storage rtc snd intel_agp agpgart evdev

Pid: 22769, comm: modprobe Tainted: P        (2.6.24.4 #1)
EIP: 0060:[<c0195c9d>] EFLAGS: 00010246 CPU: 0
EIP is at sysfs_create_file+0xf/0x1d
EAX: 00000000 EBX: f8875a08 ECX: c048663d EDX: f8875b28
ESI: f8875b28 EDI: 00000000 EBP: f8875b40 ESP: e2981e9c
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process modprobe (pid: 22769, ti=e2980000 task=e28caff0 task.ti=e2980000)
Stack: c026c66f 00000000 00000001 00000001 f8ddf0ee f88752a8 0fd00000
e2968540
       c013d930 00000000 00000000 00000000 00000000 000008c6 000000d7
b7e7c000
       00000348 00000200 00000000 f8ddc798 f8ddc794 00000000 00000000
00000000
Call Trace:
 [<c026c66f>] device_create_file+0x1c/0x2b
 [<f8ddf0ee>] vdd_init+0xee/0x100 [vdd]
 [<c013d930>] sys_init_module+0x154d/0x1605
 [<c026c307>] device_remove_file+0x0/0x25
 [<c0103df6>] sysenter_past_esp+0x5f/0x85
 =======================
Code: 11 f0 ff 0e 0f 94 c0 84 c0 74 07 89 f0 e8 5e 06 00 00 83 c4 10 89
f8 5b 5e 5f 5d c3 85 c0 74 0b 8b 40 1c 85 c0 74 04 85 d2 75 04 <0f> 0b
eb fe b9 02 00 00 00 e9 79 ff ff ff 57 89 cf 56 89 d6 53
EIP: [<c0195c9d>] sysfs_create_file+0xf/0x1d SS:ESP 0068:e2981e9c
- ---[ end trace 4f3d020112c37b18 ]---


I also have another question according to module loading/unloading:
I've set the kernel option 'CONFIG_MODULE_FORCE_UNLOAD', but after above
mentioned bug, the module stopped loading and it's use count (according
to lsmod) is 1 and I cannot unload it (and I thought "forced unloading"
does just that) - are there other any "tricks" how I can unload such a
"stuck in loading" module?

regards
Marcus Nutzinger

PS: please CC answers to me since I'm not subscribed to this list.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFH/M22eEFjZ1Jaui4RAt9/AKC9AV3Jp5UZvGi7oiGeYPWAXbfMvACcDp5y
wWylWxgtOLcShw8+rlkbApE=
=2NzF
-----END PGP SIGNATURE-----

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756000AbYKOLTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000AbYKOLTB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 06:19:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754135AbYKOLSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 06:18:52 -0500
Received: from orion.ambsoft.pl ([212.109.144.130]:54104 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006AbYKOLSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 06:18:49 -0500
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: moinejf@free.fr, mchehab@infradead.org
Subject: [BUG] zc3xx oopses on unplug: unable to handle kernel paging request
Date: Sat, 15 Nov 2008 12:18:44 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, video4linux-list@redhat.com,
       kernel-testers@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_VArHJ15B9mMY95d"
Message-Id: <200811151218.45664.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_VArHJ15B9mMY95d
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

	Recently I bought one of these cheap usb cameras. This would be
Logitech e1000 identified as 046d:08af Logitech, Inc. It doesn't quite
work but that's another story. On unplug though it causes oops
while /dev/video is open.=20

Steps to reproduce:=20

a) plug the camera in (zc3xx as a module)
b) wait for it to settle down
c) cat /dev/video > /dev/null
d) unplug the camera

This is from linux-2.6 current. First it oopses then after a few seconds yo=
u'll
see poison overwritten message. Not sure if this is a regression or not.

	Mariusz


zc3xx: probe 2wr ov vga 0x0000
usb 1-1: USB disconnect, address 4
gspca: urb status: -108
gspca: urb status: -108
gspca: disconnect complete
BUG: unable to handle kernel paging request at 6b6b6ceb
IP: [<c014188d>] module_put+0x14/0x49
*pde =3D 00000000=20
Oops: 0002 [#1] PREEMPT=20
last sysfs file: /sys/class/power_supply/BAT1/energy_full
Modules linked in: radeon drm nfsd lockd sunrpc exportfs hid_dell hid_pl hi=
d_cypress hid_gyration hid_bright hid_sony hid_samsung hid_microsoft hid_mo=
nterey hid_ezkey hid_apple hid_a4tech hid_logitech hid_cherry hid_sunplus h=
id_petalynx usbhid hid_belkin hid_chicony hid orinoco_cs orinoco gspca_zc3x=
x gspca_main videodev v4l1_compat hermes_dld hermes ehci_hcd snd_ali5451 uh=
ci_hcd snd_ac97_codec pcmcia parport_pc usbcore ac97_bus snd_pcm yenta_sock=
et psmouse parport snd_timer thermal pcspkr snd rsrc_nonstatic 8139too ati_=
agp ide_cd_mod cdrom rtc sony_laptop backlight soundcore snd_page_alloc flo=
ppy agpgart processor button battery ac

Pid: 4831, comm: cat Not tainted (2.6.28-rc4-00305-g4ffaf86 #8) PCG-FR285M(=
GB)
EIP: 0060:[<c014188d>] EFLAGS: 00210202 CPU: 0
EIP is at module_put+0x14/0x49
EAX: d041a000 EBX: 6b6b6b6b ECX: dd0952e0 EDX: 6b6b6b6b
ESI: dd1fb9c8 EDI: d9f63600 EBP: d041bf44 ESP: d041bf44
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process cat (pid: 4831, ti=3Dd041a000 task=3Ddda4a300 task.ti=3Dd041a000)
Stack:
 d041bf50 c016df9a 00000010 d041bf78 c016c8e0 00000000 00000000 dd4083e8
 dd804e00 dd1fb9c8 d9f63600 d9f0b200 00000000 d041bf80 c016cb6c d041bf98
 c016a0ed d9f0b224 d9f0b200 d9f0b224 00000003 d041bfb0 c016a172 d9f63600
Call Trace:
 [<c016df9a>] ? cdev_put+0x17/0x1a
 [<c016c8e0>] ? __fput+0x185/0x1ca
 [<c016cb6c>] ? fput+0x18/0x1d
 [<c016a0ed>] ? filp_close+0x41/0x67
 [<c016a172>] ? sys_close+0x5f/0xa7
 [<c0103061>] ? sysenter_do_call+0x12/0x35
Code: 63 4f 0a 00 89 f0 83 c4 08 5b 5e 5f 5d c3 89 d8 e8 04 b3 fe ff eb bb =
55 89 e5 89 c2 85 c0 74 27 89 e0 25 00 e0 ff ff 83 40 14 01 <ff> 8a 80 01 0=
0 00 83 3a 02 74 1a 89 e0 25 00 e0 ff ff 83 68 14=20
EIP: [<c014188d>] module_put+0x14/0x49 SS:ESP 0068:d041bf44
=2D--[ end trace 226d7f1b015225d3 ]---
note: cat[4831] exited with preempt_count 1
BUG: scheduling while atomic: cat/4831/0x10000002
INFO: lockdep is turned off.
Modules linked in: radeon drm nfsd lockd sunrpc exportfs hid_dell hid_pl hi=
d_cypress hid_gyration hid_bright hid_sony hid_samsung hid_microsoft hid_mo=
nterey hid_ezkey hid_apple hid_a4tech hid_logitech hid_cherry hid_sunplus h=
id_petalynx usbhid hid_belkin hid_chicony hid orinoco_cs orinoco gspca_zc3x=
x gspca_main videodev v4l1_compat hermes_dld hermes ehci_hcd snd_ali5451 uh=
ci_hcd snd_ac97_codec pcmcia parport_pc usbcore ac97_bus snd_pcm yenta_sock=
et psmouse parport snd_timer thermal pcspkr snd rsrc_nonstatic 8139too ati_=
agp ide_cd_mod cdrom rtc sony_laptop backlight soundcore snd_page_alloc flo=
ppy agpgart processor button battery ac
Pid: 4831, comm: cat Tainted: G      D    2.6.28-rc4-00305-g4ffaf86 #8
Call Trace:
 [<c011aa81>] __schedule_bug+0x73/0x7a
 [<c02c34c1>] schedule+0x29b/0x30b
 [<c015634d>] ? unmap_vmas+0x28b/0x430
 [<c011aaad>] __cond_resched+0x25/0x3b
 [<c02c366d>] _cond_resched+0x28/0x3b
 [<c01564b3>] unmap_vmas+0x3f1/0x430
 [<c01596d3>] exit_mmap+0x81/0x130
 [<c011b989>] mmput+0x32/0xa2
 [<c011ee7d>] exit_mm+0xb4/0xc0
 [<c0144ac5>] ? acct_collect+0x111/0x145
 [<c012014c>] do_exit+0x116/0x7e0
 [<c011e5d1>] ? printk+0x1b/0x1d
 [<c011d73f>] ? print_oops_end_marker+0x2a/0x2c
 [<c0105448>] oops_begin+0x0/0x72
 [<c0105b4f>] die+0x4a/0x60
 [<c01154ef>] do_page_fault+0x105/0x676
 [<c01683a8>] ? kfree+0x8a/0xe2
 [<c013aae1>] ? trace_hardirqs_on_caller+0x9d/0x11f
 [<c01153ea>] ? do_page_fault+0x0/0x676
 [<c02c5d17>] error_code+0x6f/0x74
 [<c01e007b>] ? blkdev_ioctl+0x2d0/0xaa5
 [<c014188d>] ? module_put+0x14/0x49
 [<c016df9a>] cdev_put+0x17/0x1a
 [<c016c8e0>] __fput+0x185/0x1ca
 [<c016cb6c>] fput+0x18/0x1d
 [<c016a0ed>] filp_close+0x41/0x67
 [<c016a172>] sys_close+0x5f/0xa7
 [<c0103061>] sysenter_do_call+0x12/0x35
agpgart-ati 0000:00:00.0: AGP 2.0 bridge
agpgart-ati 0000:00:00.0: putting AGP V2 device into 4x mode
pci 0000:01:05.0: putting AGP V2 device into 4x mode
[drm] Loading R100 Microcode
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
BUG kmalloc-4096: Poison overwritten
=2D------------------------------------------------------------------------=
=2D---

INFO: 0xdd0952fc-0xdd0952fc. First byte 0x6a instead of 0x6b
INFO: Allocated in gspca_dev_probe+0x82/0x283 [gspca_main] age=3D20208 cpu=
=3D0 pid=3D964
INFO: Freed in gspca_delete+0x34/0x3a [gspca_main] age=3D4471 cpu=3D0 pid=
=3D4831
INFO: Slab 0xc13a1200 objects=3D7 used=3D5 fp=3D0xdd0950f0 flags=3D0x400020=
c3
INFO: Object 0xdd0950f0 @offset=3D20720 fp=3D0xdd096120

Bytes b4 0xdd0950e0:  34 02 00 00 f8 8e ff ff 5a 5a 5a 5a 5a 5a 5a 5a 4...=
=F8.=FF=FFZZZZZZZZ
  Object 0xdd0950f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095100:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095110:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095120:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095130:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095140:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095150:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095160:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095170:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095180:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095190:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0951a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0951b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0951c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0951d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0951e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0951f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095200:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095210:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095220:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095230:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095240:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095250:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095260:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095270:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095280:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095290:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0952a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0952b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0952c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0952d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0952e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0952f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6a 6b 6b 6b kkkkk=
kkkkkkkjkkk
  Object 0xdd095300:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095310:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095320:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095330:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095340:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095350:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095360:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095370:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095380:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095390:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0953a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0953b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0953c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0953d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0953e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0953f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095400:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095410:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095420:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095430:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095440:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095450:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095460:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095470:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095480:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095490:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0954a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0954b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0954c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0954d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0954e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0954f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095500:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095510:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095520:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095530:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095540:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095550:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095560:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095570:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095580:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095590:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0955a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0955b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0955c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0955d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0955e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0955f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095600:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095610:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095620:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095630:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095640:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095650:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095660:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095670:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095680:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095690:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0956a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0956b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0956c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0956d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0956e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0956f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095700:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095710:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095720:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095730:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095740:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095750:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095760:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095770:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095780:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095790:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0957a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0957b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0957c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0957d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0957e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0957f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095800:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095810:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095820:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095830:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095840:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095850:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095860:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095870:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095880:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095890:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0958a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0958b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0958c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0958d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0958e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0958f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095900:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095910:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095920:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095930:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095940:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095950:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095960:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095970:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095980:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095990:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0959a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0959b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0959c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0959d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0959e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0959f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095a00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095a10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095a20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095a30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095a40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095a50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095a60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095a70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095a80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095a90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095aa0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095ab0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095ac0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095ad0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095ae0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095af0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095b00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095b10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095b20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095b30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095b40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095b50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095b60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095b70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095b80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095b90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095ba0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095bb0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095bc0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095bd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095be0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095bf0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095c00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095c10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095c20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095c30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095c40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095c50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095c60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095c70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095c80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095c90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095ca0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095cb0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095cc0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095cd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095ce0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095cf0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095d00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095d10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095d20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095d30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095d40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095d50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095d60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095d70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095d80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095d90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095da0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095db0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095dc0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095dd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095de0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095df0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095e00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095e10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095e20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095e30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095e40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095e50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095e60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095e70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095e80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095e90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095ea0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095eb0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095ec0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095ed0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095ee0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095ef0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095f00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095f10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095f20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095f30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095f40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095f50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095f60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095f70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095f80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095f90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095fa0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095fb0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095fc0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095fd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095fe0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd095ff0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd096000:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd096010:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd096020:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd096030:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd096040:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd096050:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd096060:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd096070:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd096080:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd096090:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0960a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0960b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0960c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0960d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkk=
kkkkkkkkkkk
  Object 0xdd0960e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5 kkkkk=
kkkkkkkkkk=A5
 Redzone 0xdd0960f0:  bb bb bb bb                                     =BB=
=BB=BB=BB           =20
 Padding 0xdd096118:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZ=
ZZZ       =20
Pid: 4860, comm: kmail Tainted: G      D    2.6.28-rc4-00305-g4ffaf86 #8
Call Trace:
 [<c0166c28>] print_trailer+0xca/0x105
 [<c0166cf4>] check_bytes_and_report+0x91/0xb2
 [<c01670db>] check_object+0x1a1/0x1f6
 [<c0167f4f>] __slab_alloc+0x456/0x5e0
 [<c02c5a19>] ? _spin_unlock_irqrestore+0x2f/0x58
 [<c0169303>] __kmalloc_track_caller+0xdc/0xe3
 [<c026a1be>] ? sock_alloc_send_skb+0x163/0x1ac
 [<c026a1be>] ? sock_alloc_send_skb+0x163/0x1ac
 [<c026dedd>] __alloc_skb+0x4b/0xfb
 [<c026a1be>] sock_alloc_send_skb+0x163/0x1ac
 [<c02c59cf>] ? _read_unlock+0x1d/0x38
 [<c0166c87>] ? check_bytes_and_report+0x24/0xb2
 [<c02b5ec3>] unix_stream_sendmsg+0x1e5/0x2e7
 [<c0267580>] sock_aio_write+0xdb/0xf7
 [<c016b829>] do_sync_write+0xcc/0x102
 [<c012e717>] ? autoremove_wake_function+0x0/0x3a
 [<c02c5a64>] ? _spin_unlock_irq+0x22/0x40
 [<c0121028>] ? it_real_fn+0x0/0x19
 [<c016c04a>] vfs_write+0x118/0x11f
 [<c016c46e>] sys_write+0x3d/0x64
 [<c0103061>] sysenter_do_call+0x12/0x35
=46IX kmalloc-4096: Restoring 0xdd0952fc-0xdd0952fc=3D0x6b

=46IX kmalloc-4096: Marking all objects used

--Boundary-00=_VArHJ15B9mMY95d
Content-Type: application/x-gzip;
  name="config.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="config.gz"

H4sIAP61HEkCA5Q8W3PbttLv/RUc98x87Uwb62LLcmf8AIGghCOSQABQF79wFFlJ9MW2fCS5Tf79
WYCiBFIAldNJnHJ3AS6Axd7pX3/5NUDv+83LYr9eLp6ffwRfVq+r7WK/egpeFt9WwXLz+nn95a/g
afP6f/tg9bTew4h4/fr+Pfi22r6unoO/V9vdevP6V9D50PvQ6f+5Xd4ASbRdB+nm76B9E7Raf7Xv
/+r0gk6r1f/lV0BilkZ0mPduBlQF613wutkHu9X+lwN81u/l3c7DjxOlhvRu3KRAd3hAAo/ykETF
48PVYrv8ev2937suFrG7XndhnqfV5+L5qhw3JCkRFOeKJuQ0WwnFCZN5xkOkLCSOGR5LlglM8ilS
eBSyoWOopiITkirZiMwHgqEQI6lOZBobEp7LjHMmLIRUCI+VQPDmM9wITUgeA6cpnivmGBzBO2BF
fIZH5hUoPuGSJDs9PLKU5GGCzvmmEnkQLEH8HDzIHDszmhI6HKna2SVoXiyB4zwKsS0BYipJchwu
OU31BjkkoiDU60NhmKN4yARVo6T2phGSOeZZTsNYHyBVjvNBMR0I2EsQqRjNbWZsgcknci6BNnbw
UnmVgFlmDjZAYFEWK8OKi0uER3CmFI5D0kdis2G2ShKV8ZwTYV6CBEE2I1VaoEiQHOcsMsRwXF6m
6YCIFCnK0pwzKengjDmZSU7S0EYf31ZKT7fjewFnPNOCKvOUhSQvJOc4HmUhVYbQN/4g2TJnHE4B
NibMQSRoSlOXtCERUvHRcQkBmnPBBtbitK4ZULjzggwYswRjbI5bnzUSJ+hR38AZwf29un5ef7p+
2Ty9P6921//KUgRj4OgJkuT6Q6l4jBYcGk37rJf2/gaQwzRkBocJb0qVfTlBQ4xJmsNxyIRXtUQ+
hqMiFi3sgspJOoGd0lwlIN3djjUCxRMiJBztw9WVCwzbr5ilcKb2tQZpn1COzwD6X6wsLkAu6CxP
PmYks3Z3IEO94ZhImSOMlX3qdVw+6TplWYEMgxZU0ok1suMQGzo+2IUfdYh5qb2nwEoW5XJEI/XQ
vj9NjYeCZVw6JjfXK0uBK7gJICMjkEej4CtqQ48ukI4pYP8irQ24IBguRljZ4Qomn1SMo1Ysc8eE
WvQkBzshbeoM7kzq3jl9ih5UJkHBeHCchj7UIB4D3xMjkSJ0kmB8vMJ5xIRRcu7dKaTrOJAkAxKG
zq3MaNjuVfYPxuYHPW1daHiS80SeQ/KC7viuI5zMwPLmHEmnEDDFY9vacUFTNbaE30aSGLQwE9bd
4Fjyscg56EXYicRmALOEIwVawGXyBqBb8iizlxZlitjGJoVbTbWmtRZLOLOHSDpMURxZcqf1nbAB
xluxAXKUENu0UkttTJKCHnjPUgWaxV4ozT9mVIwtmIyzAchKsUXHdcsYDVzSAMRVMjZwy6ZgEQWz
MHRiEyRAd3rvMytGVyzb2FgL7xASRRRTvWrQ/DHsKNxWUGWg0WpOGoWTB6OnGaz7b4dX1KGCKCfC
mEPjD44YG9eQpZ0DWwznMCICWLP3HA1oGlmHJlSeaNGp6gxF03lx1j7pk4m+Ma2jK8nCLK7OUYD0
FQfHNQZ31zHVgSZLNd47uEC7D5SFBxsmfXg9jxT4aOqcjtsYCK1rW1fk8SBsVnesOBAnUSyjxsED
ObygSxUZgk9bUfnGoaAskMuvK+16bHcnhwJ8GWOPUsYqTlYJRx5rcECHBIXa/XSZ1AMJjj7aE5ce
rWfiEt0wcUnimVivpGHUga2Hq+Xn/1xZOjQGtQ13QeDMyVckCHkk4mxb+XazXO12m22w//G2Chav
T8Hn1WL/vl1Zm6woOGLg9cqRfZ9Tlo8erSsJMQ+Ya1lo1ksxYUbjyiUAx8/Jt3ZYE86RkMQTTHNc
D6bBZUi9k03YHA2rG1HBH7itu+fVOZq4FSHudtozl2I/SKr+w8BxhUPRDjRnWuqFvQpYL5pQ0FfD
jEjlvu0kUV5ct99zI258iNsGhJLYi0uSmRvX800IcZWiWULpBXQz3qWsS9xNRbuOPXyM7zzwvhuO
RSYZ8ZyFtoyEuaUumdIUj8D/7DWiux6tPyTg2Qxn7QZsHnsOAc8FnXm3ckIR7uYdP9KzQ9wnD9rj
c0931AE8u3TzPNccRlbD2EOipwqM24ecQhHf3Nm4GQrDKvWU51MGjlpuuxYaQdNJzGtTD6qholE9
jKPQMViR2AQVmPF5FQfQnIOnkwOPeCyzpIqGm1ZfJJtUIQmEG0mWmBxHhBIazx9ubLzxMiEiSKQV
x2tiCeGZYe0cbMSkyErWMCgJHeQ6fM+EcwC4BqlMiEJObJbgCtwwLGubWqT/BnZaccSJKuxKDUYS
k2gB187auDChVVcgSbJ8RGLuUfsQepKEa8ubkkaCCYvB20fCFZAeaOz4qBgEFrkS0OLs3H+yJQQ2
ndOaGOijY+dgk9dwkIOLdg5MMDkD6CVHqJKLKTH8RoFHndioSWIS0ifPmcEtG7hTcrQ/9ltIk3uK
6KyWbjgpEooFw6DY/C6B9FtwEDbqcsBTpl2UIqY7pQ4L0I3bLT1ge1X00UgPIYyKIknUQ+s7bhX/
VXnhyL2GIk04mkMwHoYiV95ygSGMQMaBjZykyJGqNM6RH01igpV2F5iY6xjBVgCNyPKtCUozVMkY
hFTC/yk6PKGdqzyxdk5UfUn1rYe0qRlnZ+eO0+kEmS3f+ihg4NDkMEgaVhJMPAZXiyuTTQTZkA83
dnqpqHPI8wM43f6fOKYyJ6zZHz60j8EVy1L72hmfTjFwfy3llqVkQnGRXItFVvdmjaUokrZgX0XG
dd664W6B3dF1EjYFZseezIAaHTRnbaqSQAlL0eqnXKKUKvpIvPCD9JVxihUuV8n0IeqkMdxHcSRu
VwwAqiROSURdvjTBOm1kmYPHvN1qVa72Y965bbnv9WPebXlRME/LlQN5fABM1ZkfCR0bVXIoZEZc
PoyWIqrVNciu0AqjXVMXgmh1bsSgabhJvDiGH5Jok1AydyoyMfEoiCSLz6PAzT+rbfCyeF18Wb2s
XvcmDkSY02Dztl9vXq1YkFfUJ08Kh8N9/YsiikezHmswLq0Hr66UTODZJLIjT1r8hAenbFq18zZN
kW02JM75i6yebzTCDy8VwAApiNzmdWimFEtrwAhpSPWNobvKd+SGSMlEbZ7SKtfnmibUvzUIjsKP
bbLjhgBnUjE4aRl6t2YQIzzWRaJ8TpB4aNVX6hWSYrGY6jSnajg2RWq+Mohe6RHWuAXThEDUhf99
ciDP7oAOTaLt6j/vq9flj2C3XDyvX7/YFX3jcQvy0cFkWW2terym/jpkkzwG60GEB5mQVOt886bB
+668ccFvsCnBar/88Lt1+XDlWuhtGzJtGtyGy6CTpHhsIAmpADeggYDF3KnTDBKl82r2WzNUhRQv
qMJKvmqULIGzk7VVEl0OHWTyYsE0kWcbBCDvymIyRHjuRZ9Jbam8lK6tWrW2omtAO90VoFVcKJ5O
Rk0PmcQDXUVJahl8m0RzQc5mMn4E+FO5qNRwDcoUxioJEOy+2RJ/73hsoPe4MRJhdX8TTJF3nwr0
SYEdyHWGO8e0IiMGQVmlyKrfVnhKhZHCfy4X26fg03b99MVOT851PHp6i3nMmRVmFhBBMRvVgYrW
IQSMpAKf7Iyy0JKV5Ye9u869J/7ptO47PlS3d+su/mKKvftYr+UXx6FDuIM7bJmEQ7VOy8+ZoiPf
V8v3/eLT8yr4vNY/NtuXxX4XXAfk5f15UbP3uoaSKF3Qq5bswIkLs4Qf89K64jciKGwoOSGWVUvi
xdQa7C4KFPiESuydEuzSeXdOSlQpNOlq/89m+w1UucOVAZNFVDXvqiGgmpzNI1lKZzY1vAbcPVcy
gKbVeSnPwd2GM0KejC0QoHCCIFgI4VJnyunBAFFEB7pxZlSbnKfufLTmkHLahBwKX4TK3Z6bnKdw
/GxMiae0oudFIz+OSO5HUq4dWT9+FolEX8+UxH6iS3gziY52i3SVNh0/RfzT0w4IaZgxFsyPDCka
enQD167N8CgoDgk50uBsYMfH5SUt8Q9Xy/dP6+VVdfYkvJUeP4HySc8nRDqFquMxXXD20UQ0Vh6H
DMQ3xJj7cBIrN05R7k5DI5W41Ymg4ZB4r0Io3XZyEqM077c67Y+egh9OPYcdx9hjAfjMwzmKPWmz
jttgxIi7ewMI/OthawrrOdcxlb04a+OxdWmwX+32hW9sDeFjNSSVEGeEEoFC6glHPSU6KkL3MQzc
i0FRLmbCIwl8VN+Ecguo7lqz+xZwNNRn3LaMSFwDlIPAPQp1AkPnT5iYOwjITLmhRfxppVAQLl7y
UuywWOxNV/J+u3kOFs9fNtv1/usLcP68WmrjddrycmQusO5Rqjh8Fgp8S6kEcWXebLJSPzTMVJL8
bzM+XL2tn64cM4KTOvIkpw4UMQllM4VxO0385BYlQoghdGJFNKZx7L0B9/xM/MPV3+vlKgi367+L
FoRTo+N6eQAHrO5kZEWfUFF+0Lmt0cPV9e7T+vX662b/9vx+6tQGLy4NUcxs15OLYnhERTLVibOy
cF5mS6fGm7aDyyMpTc+aJ4sOr5JCd0haekxvZijoxKMXDgRkIjyGH2Q7H81hlRMqmXsO+CeFQNCD
TVToTLML0+b9UgPowv9LpWR+gML6IrfSsWggYiSCXiQrPO9GqqGnGlri0azfv7vvNdK0O33XBwDg
1lW805QfZV5KNCTS1c6x3yw3zzs7cQFhoc9BBHg9fXDCHLJw1RadM0AehfY5lNBZ6Fsx9dR19EjM
P+Y+A3BAQ+Aom2j0y0OE73utRpKs1vB1RoDZVCdVE2eCsiSKdduRY/VYzLlica2V54wsvdBrJWf9
5kUMGngTKDldGgtY9Cw+tHsunGnDv2nd9xwn6okjcChYou0/Diehz6/J2UTXCNSocT0jZ+McxH8a
S2vNvnSQ5EgmHsuPUggN3a4R4Zrh+y6euW+lHFKdinDdSEWjpGhsfamA7mazti0HUfZvqmSm/TPl
kQGF2+1Wy5u3TSRtGs1RiiRLIfZtIDI1gdhBUS6UpfMD1mZeg00eVVcU3LyPaDrWvQ+mRuCOZXQT
BNjmmE3dp5DimMlM6I88hDlbd52A5zT2uJCdeuBW6UENLTNaPBQa8nm12K2AHCz5Zvmuqx0m5XG9
flrpvx/23/c6JRJ8XT2/Xa9fP2+CzWugddaTtvB266EOCU32riKWx1ZGQEuQfFcgD6hhWGEPnvU1
qcj3EerZY+tNuLlFPSTxmDbpMT1FeK4tDDiHmztgkuRECCZ8awUuySUuJZYXV+KXKL3d+gMfkyX0
kpgqTnRuGfUJLr+u3wAQ7N7f3jbb/fWn9y+f199XVWMZElcn0hmrZSN7sw1Jwt5N69KSa8b5nEDn
lmUUnRKh1F7OrlyPlbSzJq+WDAqIzgsOMohkROjx9soZfmYr9CcOvU67kUY8eqqqtWXW2C2xiOBe
ZzZrGI9i2r6ddZ2Dk/DuZjZr5A8pSmf88mE2z6IEjWLSTIPl7W2ndZGk+xMkt83GlKtur9dI8m/T
aZM2+yC47asTHO8C7F2zkKt+p929TNI8Syr7dzft5kXzEHdaICk6SP85wpRMm9c/mY6btaukNEFD
coEGDuzCFsgY37fIhSNTIuncNx/HhKJ+B88uSLzC/R5utdpnmpLtv0Ig61EwRSJos1/9Fbxsdvtg
8zkAcjCoi+fdJtDl0/UWrOvbarlePJdfUX/awPxvi+3iZbUvQuczbm5M5Nm8z/qKX7rHocKdzl2z
1zxSvdtea9BI8zHs3V54VZbADt51Luq0Um0b6/dUJBFOG3pKSCCqjb1y1k/02JN51k+Hz5Stch7A
1FB5an2ATImKwW3zzF4azgq3BzaLbwN+e1rvvv0R7Bdvqz8CHP4JTvTv5yZHVqJBPBIF1M1XiWbS
Q3Cc1VUPOU4+dL6y2sBfLGrzsrLPYRf8tvrw5QOsJvj/92+rT5vvvx/X/PL+vF+/Pa+COEsrImt2
y5RzckD59xubwlzq+ZLTkMRsOPR9v2UIJEYpBDnzFPuOTX/fbcjKHKJZntouXnd6GeecS90PUhez
KkmEL1FQ8/MCkUQyj+lAoiYawS9NAxFETCaewkuFoildU9yZkS8+dcdgbhMSZbLWtlR4mISQoN29
vwl+i0AJTuHv73XNSV5N3XXz+vwDfqwO6jPY/7MJdvvF8tvuj+D99Xm12wU/Nu/Bt9fNP8E/Xxd7
87QAxfq0qTWlRFQQnWH2ZkANQ05kh/nSqxC8MTk6JANd6ghUySkgL/ODWZLMK7kQlob+jxPxxPeV
DvmYgaZ/9DimynPlJr7cgqlnDOrep92J6yuU8NEcxNe9fJ3K0MlVK9GfUFr9BQaczxPia43N0qEn
AYX1l1wp9S5mQtKQibyLPfmNWFcHL42WCb5EIhBG/gS5ymJPPgip9p1ns3Xw4fkVDrztGWOqwp7a
nE4Bgf+WE5Cn/NH3TVGFSgx/ikz5Ktg2kf5xc5ksZXmk+3GxEvFl6gTFOY5FTvU11J0dPznEpCp1
jO4R2LPeMQB23fVJCJj67Xbbm65DIeKKYNPKGvmUD8JdX9yAuO7F8Vj8G/eOms9jQx9HWPbvv7f8
6T6fcBEfIk5J1+NmR3CnU7drmCIlSeK7up1xvR/HQnY7bQ+L0ovqg3LHrtyBRijGbG18AEGsxrxz
abxufcrVlEpffbgk7Lc9rU+aoKiRzkw7uvucRa/lyYxAqHTvOy5Ose/EQKOGXs2nfMYGYqVcjKjn
wx+J7zutbturl7j+otVTmFZxxzdOu6deg2Th3QTq/Cte7WsYrwGWaXsHU927wMV5GdTGl2Xuelef
QHPs+10a047vGDTOd+9j3fStPO5giTTJZV2idG8rrTbPlOaDCN32aNcD49kB6t7EJGxCp0zo/HUD
hc6inaOrO+jgqkBITsAYZImvf8Xj7OrF59jHj5l5GndvW23PV2xUJrc3nl+BMsgfw3bHM1SjtbwL
8OikkRr3nVZxv91vNeDuPPYk6fvq9Mdq/2gqqafYc3vjqNRZ+zm6Hfsw924Mnca6yuPDTWlE/Q0K
QICGqQ8F/rg7hTViYE89Kcibrg/e0MKsD7TdFlPPeXRm1WtqFAec9LHPBz0t3ur5Gi0JGCnsFZMx
mvqMtEZzYNf3McJ/G7uS5sZxZP1XHH2Zy0y0qN1vog4gCUoocSuC1OILQ22ruxxdtisk18z43z8k
QEoAiQR9qHYL+RH7jswvQS67CWK1A3LxD9uuq00OegDcIZ02CkOGmKjkyFNEjm1989wezmOHDmYU
2HdscH+QxVSfPm6hdXhIScKQTxvyG/07CAJ1xxzbHoIcTCcK8T+mVQXjYYrrV/XPwa8/f733L7qu
D4O5qQUsA+ooAns/0JNCnhMBBHkUa2O/015O5x9gsvT8Kvrrn8dH45lOfppkFaeG+oIZXuecVHtU
yoOC0rTef/FG46kbc/iymC+7Of+aHToZ7wDodkjeUbHXqrqnmGR8uaEHP1N6+1cTNRUi5r+NH5rG
a41EbKY2iG7CFRNvBiH7chAiDjElMnHfclNmO7Ijdk3raxtoJ/FM2tnz8e3K9BpUkzjnFijcxTHx
N89tQi5GW16ywP4li8CieWOTgan3RjJ8mJQ/rRy4SsRRCtGFu0WTVcF6gxioKhinBUPO6wpA8jym
MiIHyA+S2f1i6kCIGsf0pRUAKtJPXAUCzYccZTkCyJbv93tCHANCjCgOtpcOiLSlLF0AqAw1bPGu
xXROhmYeklxm+sSswuHUVIhDuF+mrmlMHA3ENncQxMTpKclK+inQ2IES44jnoPQ7FJ20i0yIE3MQ
p9/OK0IHESTe6N4hr+Sf3ly2Pp6f/gt3nOz37K69ur5a+xY6+5r8WbPlaGpwBapg8V+0gypEUC7H
wQI5UytITgps5moAAUwWVsNkEIvDDEw/vcwVxL4bW5GEdnOttl3fj+fjo1jV2heLW6VstbvHdlcg
7RmUXbc2VW3LFqDZS++0sNtxuNQEYICD3uCK5WqDqdCpqaixTBKncoQdMc0esqRvn8RPZ3g7fLou
Z914lx2z7utV+L6mpIgP4netOAWa18rXf8lPLipi+bpjeYBrYv/KE8T2535Z5+XBUIBRu28ZjJ25
UuwiJc/RJT9PxOFS1FyMfCraSDR0iFwAp9uC2MoAJCkvBicPBNlbt0QMEYrJ/XyKXOqJbXHnTtpQ
KGsfqJo9+qOlZ+tGRgFMM9hpFyzfEjGlTbFLkhtgit5TNIr5CCsT2SJkMMFyMZn/r15hN2kpD3Ch
0tvA5WKCcClhA+kNQoGcrhRThDSKRjQOxb/c3mdKGgcI6bTopQ3PtvZ2FCCEHwwz0RXHr1JqCmWp
GGRQfjFHGgSyKsh+drNdXsnVSpr+xgaBtR7uMDzPQ9LnCridrJVlfx3y8QLRJF7v7LrBN94c7eyp
WNRtYwMOxTeW6eaZ+vX58XLHn388P7693vnHx79/ivPNyRgh3O/NnAk8Wf/561XairQnMMs8mkRh
jV5vgJAn2CXSugyAIZYFE/TjMsH6dmszY8/4y+np+ahNBl3J49vZcp7cspBmUjH9xQzaTuNxcy3U
FZEYnmMEwNOpWZqPvEbx1SC82fq9CjO+S2goDZ17pbFUPkDhzZtYCcBvmbcUyOuGBeJUAjq0zVOt
sZSrooZbxxhQGLFw0hAMe+SjX7qyXmkqaGPGAnx1vGXS7sS2ZVvmSCxP8Nj93bdAV1pvytgEdiIK
cuSi5yYeO+Rip05Cxh2IhB6QV4EMCPTFLGvT7RWtJC+qLC0CwU3mYjvJMiBWPA+IXlwITGbz0Ri9
FJOfwK4NUT28YcT5L+EDmIilNGdDMSWkGIoo2868+wFMToLxaDEMWkw8bwAF6vB7/zOgr0Mg8Z/Z
aPQplPcp1OxTqPmnUMvPoOaD+So3I286BKrSPK6G2rmcI4qNGmS7nE2GOvA2GE3Ge9ewqB+CyX7f
HRxbFpAEjZv5iUu8ASMKssMvtL9VLNiIGKTRFU0x7liAUlET+/EMr3oYEbiU06mjO/H0PvAckwAv
t/Ml3mcfROU6Ys8dNfBQTOaY3qVKebOjvquS+Xg8myH73RDYCqVCATKhhKS/01mdjz+/wx6ptx8g
K8OWRfwEvVHbrhQkJeuBEaWvRoYdflYNuSYqTcXMjyxYIObIUiRlkqQUFW8d0dqIadtqLYxFNQRe
hTCytzIIC2+8tEcDjUiztBtbsiJoZFhxQYaVR35Htpim9XZFQFuGOlb0rCrlBZV65bBdIRgnkqsl
rdixIZqAYp0PA2tEQLQGqlScWBwVid2k+BexODZ5kRoB8MaCs5ueQOqZ+zEzNqeNrJCK+Hsac7D8
9Q9ITQgkGOq2abswbTZcmGuO7JUQiU0zW6U1TUXnT43y+BmwELbhery+NA8DAZaySK+M6QBIFjND
KEZBLnoMduAU4oQEwOWBfu5LwrPVGq1CyQSiNsxoJCWLZe2VnWs2OclFoDB/98evP/88ne++t9ej
liMF9ABWFBWaTJ6MMVFw8Gkxxq5RBECc3lERZ7FoALQGWMJLVChq35vbew2Mmk6fSKfIwilk6xXe
Rb3Qm2CWEBAtPivDkGJbVMaWHlplMV2OZogRAnyKLhSy24m5Cc2vmmnR9igPnUm6I0WraYJK8AkX
pAztclu8WlOaiVmDod1qc0AIcoRsgi1RkGSWhVmGdpNtuZyPJ45xEKM5LsFoHe/nGPGNHHl4iqRI
MMUzIZbM7njtSgI4tBNReIfKEvT7xF927em0q69mYqvjIGwXL6tvlBYnj7ONibahAX5DZMWKDaSW
F9mKkmIAlfjOvdQNyMmamCd0xeLxfPn54/jhMMQJGc9jcrCVXMHeXi9vP8RE3MakmD/6N1Mr0n92
EYHwPMGzCKw2QNcCcjwkV2b586lumnCN3LYpA138fuLS34RfRRFc4fQffyxi0aglMEQDTWGH99z5
WZGVBOUpjrKOUYwWXi//t9QyrEI8g3Y8zlaZ9ZGhSjUTZvkTDIs6fqi4ARIQRSJqBOVBYgYUZJeI
LmcGcvqtomlAjYfgRqBawJZLlSlgXzbyVCdi61aAqJcVNLAGij+mP/QZ2ZLffZhZK8oAfx8AQKNW
pG4DOQprxoZU88XM0wHXmo47uHtNGPgUwzOH8EzKKBLCS50HR1ZqXokjdV0RnT8GBCS4X9TAMB90
G89i9GLIO6YIRquwbnWT0Fsu79G4SMwxGupGPLUbTSspm01nXjf/DkPmm1juTRMcVC2x3U0rHrvF
E4d4N8ZlD+VkguxgQO6Xy8UelQZk5CF3aFKcMEz9Xo7K/WFFU/xrPh0vPZd4vndkDbfovopn4Nwx
wzs/KWLiqHYxE7jEYkVzfq6in7qjnw5Ej8uTLCW4kOEyGqyzyQofjuIIuMoGxGwIEH7F008qb7Tx
huR409OUe5PFaEDuSIB795OlUzzHxVGyHOFxr8UuAj+NKATPnUJ8FlmziDlWGrFX9Bbe2C139CiZ
7+V+NAjAc7gRu1Jv7MhDQihodE0cPXdPMF0jIU6T8QyfkPJgv8brp2B5iVFlSXlCJ2OX9H7uls7w
r8W5bjHy8IVLMg9tmU/xddJ1ZJLrNZAUOGbMRj6wUslzUMbx8b3dj8d4OQ9J5FoSKu47Gg83NZY1
hGhIyG0pbKeplexebEuA8vrl5lUvtHhCZ4aRPWDwN14h7WidXRX9dfVhnbKQ+7YkcuQStIFbFbNF
IkJ05wMBRMtNZ7vBki8xPh6/1Arta4o1NBOQxFNX+xmyfH3J18LIFPRtzRqWqrFmkC8pkzphhfTr
boQFa1roHiBUGBO/uoGHvKC807QhjWMzhD5saOfL1aGQhykzFNRsm5LoRyMZVkd2N5wgL6rEj2lO
wnEHpcUtaWHgDGomKRZxscXuZi8nKai8xFkRmoSM12A8oZyWJD6k+06HJwnYR3cCezXavE7qiZbr
ouKlOgpglfBAiwy+s+dKPld1BxwEXp3Wr4MQkWTrgCEi2hV1HzHxASzjSVPpSkja/Dam930tmufL
4+kHKAq9/brIsdejPFcpwedRTzVBhfd1E0zQ8PlQ1SDu+kU+hJYrx1hPUdkOm5JbYR34JLLPQ0BX
Eyhu3R+ns2YuYRo3zRf70QgaGekc0JKyD7z0QsEdQ72u/Losu5Ur5WUJ7dcjVzafq3nuefN9NwM9
zGI+cmKyJptIKapbKcyGi5dga+eIuFiS+Xwm1ikXaGdJ3VwwdqQr1wkyZGO9ne9Wx6e/boRtd+9v
kriPvf7nJNrxqPXvazM3xjDBj+Plgq00JEiQamn0dbu1sgvxt+3SZFJQKsdZSf/vTr2NZwVcoJ9k
uS6SneWf0r3SPxQPzfPl77Z4/2jL8XL8UHxKf5zuXk+np9PTv2W59QjXpx8/JU/hC6jFAU8heHEw
OKI1eK+ZVfDArHNFkZJExB/EgZNhjJVCxzEejh3qNddk82A4LvH/CEWCjuJhWIzuPwWbzQZhX6sk
B1/Ig0ASizM9GYQBSzlql6MDN6RIhqNrdhpAaxPgjRYDA2DnDeG2M3w5/gU+Myyq2XKKDoOlowHl
9qGkG2vUciAjA7PifDF2dIyeidM1VnPtQ6KnCZvjCjRCOsY1sEhYlZVDB4ZuOcVHUsEyl0JZTFdZ
ieoiS4RjLvVhByo2naRAXupUEngEbYcJDotgPnHApGozrkO0BgcL+KhgYW8bb8ijMmS4827ZCLBP
b95n8KZgYvfhb1f4QInxqgADmkBshPyCYDTlsijZjhSiUXEE6pxbLeBwkIh2KGDr+HhF8Fre2cd7
grD9JDTBjehgq4nauJMAvNMxn8UMeVYGEoeU+QTZBdKQBIhheuDYg4YJsWx/b9mq9s7ugd0ElmRl
98LVSGq6D+IqvPHvKwWN5/OL1Mmw7CVpGFptlBqVIlHzymWRZlAVx3Xh230ZhEHoE6xGGHIwVyRt
zI/Af0Da32tF4P3p8nF5P71oRwS6L8e1eTpoguo9MLXZW7NFMJt9uZBO+lFOBqOcdoh8G8lX02i5
oEwsDCIu5IHpKy6SviA524vubFUHY+CSNQs2ogcYblnxGOGZa2zPdih2hSw66Mak9gDpO/wW+q3K
TGJoGdDSOcprziKyO5SW29kGL7pd2inHN3CvtbXZ1iiJZoIg41De2bTBVmZ4TSjpFK16MPO18DQr
YsnfgUoe+mevezKe3c/F2SfSblK+ZjEzHW49CBiScBVGtnTDjP8ekfL3tLSnK2RGmgkXXxgh2y4E
frduU+CtEbwUf/HGs5ENwDJYwMGX9G/Pl7flcnb/L+/qGiQtoyat2+wMQfj2XYqL/rVffjn9enqT
jt96RbwxgOoBG/P9XIbxAzc89clA6Q9bHN6ZWDi1Z1jT402Z5OZEIAPso/B2+1iJBS/2kQZtpDJ9
G0uo/NPWn+WixKwLjZTG0bcjXLZ2itTFE8JzS/FPfVzk+CooSIKIto5JLBEL9x6d4RJHAXNc9i3d
T3Fp4YpW9KEtJqt6n3U8k8EkrvzHat0wjcyxC7+3Bnm4CkG7pBTbPEQIQWjEG/YjDgdiDu1Rw0qk
xS1/CqTu3geuLbvlamzgbiOySgvTd44KAfs8SfvWSf3WRnnAaVCvxElhU/izIQzPN6byW5ta4ht1
D7/TmF9dRn10BYq34Mtvjz9h8tR8FgUM6RRpkKNDIgsJPqy5bWnIj+f3Z2lSWX78PBkOJIuSwc38
1Sef6Yw4K9Ibxj6YeDSAIAlbkSFMSQo2gAGeSCvCWM+uCINHX3RIsavexMRHXorVhMEr350HnsUi
o7zx8u5Cgrm93Ce7043DZCAi8OUykFRcFiLzA9FUQy0pr2YGMDQaygzMdPOls6HEiNCd1N3GzXXf
MP5NF7c7j3o6WRgbCF22mNht8EzQYjYMWlq5GTqQMZqR5exTaXwit0vEbLsD8j4DGn8GNPkMaPoZ
0GeqAHET0AHdD4PuJ5+I6X42+kxMn6in++kn8rRc4PUkdvbQy+vlUDeDxQLtZx5mpgcowgPGkOjb
5DVTbD2417NbwWSwQMNFng0i5oOIxSDifhDhDRfGGy6Nhxdnk7FlXbjFFdJAVRktDVO0OOmt6Bvl
l+L78fFvw5EpsHVR8O0exWTFtXdgk9BFkWwgbq2AdEoetoHtuqABKZGb1waaVLysJXWH7QYCdKtl
bAbznDSfgMVCeqHXVk2gohPhiZ/F3OHFEdu+K//daG7Ux12nkiqUr5nMzDVQ6o2DDgHsUyvjqgtM
48QSB+7mrnLQF7DSGeLgekviin4Z6Xy9a+rShZFysBJESGFBNbrG5aqkmf9VFM3qpSOu/BZk7KCk
YChe0VlokpcORFGK3lLSPXL52Yrl3bPVg3jTVDlLoR67TdjE3Q0GqKTMCIwD/1a/GtOPJDQ3tfXB
fAGjMb+lID6zcakYA7LX55qCiPqlNLflG65uSc5qTuMIakXXlS9JsJHxm7ewsourNkZrUPxrVNa7
ibI0yvrxbRNH6V22PAqxK0CrB7w2ojlKxBmpOIjkTdvQpiYYd1U/X6Ezj2QuNNlApV1rMw2GFLtp
L4KqLsXcCeQk6FOI37aAbB8c11S6bGrwohzSLWKLpa7SUmg8bIsdiwk5DQ6Yz0R1tSX/EGBERaZC
6WMwqlKZjuqm2qWXlLaqMlHbyYxPVbkT2arihBtkxfVZoTwfH7sWnmZKiOvsb2KGjFyQZopxQUTB
xeB2xqJmWQcADKylt+sdK4O1Cyk7kyspGKTuEmVg2y3VXcDVCTwQyVFg70hNk1y7L7pQkCSPrTw4
svWkWtdmFRrm4vAbKUTBAtlrMcI8OBC3NjBQJZX1FQW47ZqsG08pWngd+qvcNdShPsEVa4T55dRw
dcUx289mxRJiuTCghcrLsEpcGSqyEPO+owDpHp8XphuZT+tjS1aJzVV7oaQ9hLJM9iYb32em5rO6
POS0Hu2Xoy8jTEbDL55dVsn//zK2S1Pw7j3RxmwrheRceZJJflg+rPA5+IpJOzTN1wpunx60LIpy
3cZxThxjBMjcEvYAjLAxS20G7Pz0+Ov8/P6h6Wnp5L7IZS8NqgJ7VG6Fkftb9XIXkJzIB2pmHcnK
R3M76Qbnj5/vb4pkrPH+ejrrGVZwEXOORya2SSuiO81ug8XGuhfox5uA5Wt93Wgka8LXvcBC32g1
YQlJxRA0ludGsoq88TKpYuRZQGLSKnbK5Z/QhSBVuaZp4IJ0B6+sUvLr/fvp9f358fh+erqjr49Q
+XDB+t/n9+935HJ5e3yWovD4frQ0QoAohrWFd4s5/cb6uur+j7fHv+9e3p5Mdac2Rd9ZygB5xL6K
HX2GBr6lAWOEt78R5wMZ2pfcwrB7+Y4WcJ0Qd4SdBBtj6r9Ol3dbdRXBZOyuMYlwWB+1XTycusUz
vGbFUr8m4IaaGc8d7YBKQowtQUMgt4g3BGbhc0NMxs44+Jp4A/KBNARihlgxtaNwVXj3TsQu70Sh
WvX553fDquI6oXFLnxWh9WzpzCpJK5+5JtAimFpiFnv/XcT42tmjxIEljhGbnCuGl7MhgLMAGCNM
uzzIvy7EZk0eiHNW5STmZKDPKMhQbXNK3SnRIseMtK7zt7NCy1021C4NpJvXhkvh5ef5dLkoveV+
XUcxxujUTpMPWS/S4vj69PZyl/56+eN0vludXk/nVjO63x3BUWdeICTX7dy4ww4Cm21iMmDKozx7
6JEfyLTj5z/Ox/PH3fnt1/vzq/6S6LOyoGB3rp0TG9fbUncLFMd4CTBEnsJ5yzcP/2KKFSslK7H2
DTys8wR16Y1CFlnHqZi0S3G4v91/y6m8k/AC8/HUXxluTlW4bqpFuNiYKhpvI6hjCifClCfc/weY
25Oo7rUAAA==

--Boundary-00=_VArHJ15B9mMY95d--

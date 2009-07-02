Return-Path: <linux-kernel-owner+w=401wt.eu-S1755461AbZGBUw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbZGBUw4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 16:52:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753522AbZGBUws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 16:52:48 -0400
Received: from khc.piap.pl ([195.187.100.11]:38517 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753512AbZGBUwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 16:52:47 -0400
To: <linux-kernel@vger.kernel.org>
Subject: 2.6.30 PL2303 USB-serial: NULL ptr dereference
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 02 Jul 2009 22:52:48 +0200
Message-ID: <m3vdmast7j.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Not sure if the following has been reported. I think happened when
closing minicom, with the PL2303-based adapter still connected to USB.

usb 6-1: new full speed USB device using uhci_hcd and address 2
usb 6-1: configuration #1 chosen from 1 choice
usbcore: registered new interface driver usbserial
usbserial: USB Serial Driver core
USB Serial support registered for pl2303
pl2303 6-1:1.0: pl2303 converter detected
usb 6-1: pl2303 converter now attached to ttyUSB0
usbcore: registered new interface driver pl2303
pl2303: Prolific PL2303 USB to serial adaptor driver
hub 6-0:1.0: port 1 disabled by hub (EMI?), re-enabling...
usb 6-1: USB disconnect, address 2
pl2303 ttyUSB0: pl2303 converter now disconnected from ttyUSB0
pl2303 6-1:1.0: device disconnected
usb 6-1: new full speed USB device using uhci_hcd and address 3
usb 6-1: configuration #1 chosen from 1 choice
pl2303 6-1:1.0: pl2303 converter detected
usb 6-1: pl2303 converter now attached to ttyUSB1
hub 6-0:1.0: port 1 disabled by hub (EMI?), re-enabling...
usb 6-1: USB disconnect, address 3
pl2303 ttyUSB1: pl2303 converter now disconnected from ttyUSB1
pl2303 6-1:1.0: device disconnected
usb 6-1: new full speed USB device using uhci_hcd and address 4
usb 6-1: configuration #1 chosen from 1 choice
pl2303 6-1:1.0: pl2303 converter detected
usb 6-1: pl2303 converter now attached to ttyUSB2

Then after two hours, while exiting from minicom (most probably):

BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<ffffffff804dfb38>] _spin_lock_irqsave+0x8/0x20
PGD 0
Oops: 0002 [#1] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:1d.0/usb6/6-1/6-1:1.0/ttyUSB2/port_number
CPU 1
Modules linked in: pl2303 usbserial radeon drm coretemp f71882fg hwmon binfmt_misc sg snd_hda_codec_realtek pcspkr parport_pc snd_hda_intel parport snd_hda_codec snd_pcm snd_timer r8169 snd soundcore snd_page_alloc [last unloaded: scsi_wait_scan]
Pid: 3558, comm: minicom Not tainted 2.6.30 #15 MS-7512
RIP: 0010:[<ffffffff804dfb38>]  [<ffffffff804dfb38>] _spin_lock_irqsave+0x8/0x20
RSP: 0018:ffff88013df5dca0  EFLAGS: 00010046
RAX: 0000000000000246 RBX: 0000000000000000 RCX: ffff88013dd51000
RDX: 0000000000010000 RSI: ffff88013e537000 RDI: 0000000000000000
RBP: ffff88013e537000 R08: ffff88013d14a9c0 R09: 0000000000000000
R10: 0000000000000001 R11: ffff88002804a510 R12: ffff88013dd51000
R13: ffff880139dc0180 R14: 0000000000000000 R15: ffffffffa017aaa0
FS:  0000000000000000(0000) GS:ffff88002803a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process minicom (pid: 3558, threadinfo ffff88013df5c000, task ffff88013f1bc7d0)
Stack:
 ffffffffa0177c93 ffffffff80231110 0000000000000000 0000000000000000
 ffffe20000000002 ffffe2000408cfd8 ffffffff8022d2c0 0000000000080c00
 00000001806c6900 0000000000000040 ffff88013e537000 ffff88013dd51000
Call Trace:
 [<ffffffffa0177c93>] ? pl2303_close+0x33/0x290 [pl2303]
 [<ffffffff80231110>] ? default_wake_function+0x0/0x20
 [<ffffffff8022d2c0>] ? __wake_up_common+0x50/0x80
 [<ffffffffa016d347>] ? serial_close+0x1e7/0x220 [usbserial]
 [<ffffffff8039a3f2>] ? tty_release_dev+0x162/0x580
 [<ffffffff8039a821>] ? tty_release+0x11/0x20
 [<ffffffff80295482>] ? __fput+0xc2/0x210
 [<ffffffff80292046>] ? filp_close+0x56/0x90
 [<ffffffff8023a235>] ? put_files_struct+0x75/0xf0
 [<ffffffff8023c00e>] ? do_exit+0x65e/0x6d0
 [<ffffffff8023c0c5>] ? do_group_exit+0x45/0xb0
 [<ffffffff8023c142>] ? sys_exit_group+0x12/0x20
 [<ffffffff8020b2eb>] ? system_call_fastpath+0x16/0x1b
Code: 00 00 84 d2 75 09 f0 81 07 00 00 00 01 30 c0 f3 c3 66 90 f0 83 2f 01 79 05 e8 f5 3d e7 ff c3 0f 1f 40 00 9c 58 fa ba 00 00 01 00 <f0> 0f c1 17 0f b7 ca c1 ea 10 39 d1 74 07 f3 90 0f b7 0f eb f5
RIP  [<ffffffff804dfb38>] _spin_lock_irqsave+0x8/0x20
 RSP <ffff88013df5dca0>
CR2: 0000000000000000
---[ end trace 3989c95d46ef42fc ]---
Fixing recursive fault but reboot is needed!

Few hours later:
usb 6-1: USB disconnect, address 4
pl2303 ttyUSB2: pl2303 converter now disconnected from ttyUSB2
pl2303 6-1:1.0: device disconnected

Additional details available on request.
-- 
Krzysztof Halasa

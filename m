Return-Path: <linux-kernel-owner+w=401wt.eu-S1753220AbYHDIWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbYHDIWk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 04:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752082AbYHDIWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 04:22:31 -0400
Received: from mail.ukfsn.org ([77.75.108.10]:48587 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbYHDIW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 04:22:29 -0400
Message-ID: <4896BC3B.3080208@dgreaves.com>
Date: Mon, 04 Aug 2008 09:22:19 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: BUG and unresponsive system using cdparanoia on 2.6.26
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

2 problems:
* unresponsive system
* BUG

I've been ripping some audio CDs recently under 2.6.26 and sometimes, I assume
when there have been imperfections/retries etc, the system has become
unresponsive - 10s of seconds for mouse movement, keystrokes to respond.

This resulted in many
  kernel: ide: failed opcode was: unknown
  kernel: hda: drive not ready for command
  kernel: hda: status timeout: status=0xff { Busy }

top reported very high %si (>95%)


and when I tried (*something*) to recover using:
  hdparm -w /dev/hda
  hdparm -w /dev/hdb
I got a BUG.

I know it says 'dangerous' - so if the reply is "so don't do that then" I shall
respect it :)
OTOH this may be unexpected so I'm reporting it.

All my drives are on sata channels, I just have a Plextor CDRW and a DVDRW on
the ide channel.

One additional comment, when the CD drive gets into this state, it persists
after a hibernate, cold boot and restore. It is fine after a cold reboot.
This suggests to me that the problem may be in the kernel/driver.

Let me know what else I can provide to help.
In the meantime I'll be trying 2.6.27-rc?

David

2 syslog snips:

=========================================================================
=========================================================================
=========================================================================
Aug  3 16:10:55 ash kernel: kernel BUG at include/linux/timer.h:165!
Aug  3 16:10:55 ash kernel: invalid opcode: 0000 [#1] PREEMPT
Aug  3 16:10:55 ash kernel: Modules linked in: usb_storage bridge llc cdc_ether
usbnet radeon bnep rfcomm l2cap bluetooth binfmt_misc
 ipv6 dm_mod fbcon font bitblit softcursor nvram af_packet nls_iso8859_1
nls_cp437 usbhid 8250_pnp 8250 serial_core rtc ehci_hcd snd_
via82xx psmouse snd_mpu401_uart uhci_hcd usbcore 8139too sata_sil e1000 bitrev
crc32 evdev
Aug  3 16:10:55 ash kernel:
Aug  3 16:10:55 ash kernel: Pid: 15804, comm: hdparm Not tainted (2.6.26 #6)
Aug  3 16:10:55 ash kernel: EIP: 0060:[<c02ad446>] EFLAGS: 00010082 CPU: 0
Aug  3 16:10:55 ash kernel: EIP is at __ide_set_handler+0x35/0x45
Aug  3 16:10:55 ash kernel: EAX: 00083f61 EBX: c02ad830 ECX: 01d16478 EDX: f7fadce0
Aug  3 16:10:55 ash kernel: ESI: 00000032 EDI: c04d2cd0 EBP: 00000246 ESP: e3debdb4
Aug  3 16:10:55 ash kernel:  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Aug  3 16:10:55 ash kernel: Process hdparm (pid: 15804, ti=e3dea000
task=deec2e40 task.ti=e3dea000)
Aug  3 16:10:55 ash kernel: Stack: f7fadce0 c04d2c84 c02ad4dc 00000000 00000202
c04d2cd0 00000000 f7802860
Aug  3 16:10:55 ash kernel:        c02ab2ed c046bb48 0000031c f7fed804 f78028c4
c02b4b4b 0000031c 00000000
Aug  3 16:10:55 ash kernel:        f3de0240 00000000 00000000 f71d01e0 00000000
c17fe980 00000000 00000000
Aug  3 16:10:55 ash kernel: Call Trace:
Aug  3 16:10:55 ash kernel:  [<c02ad4dc>] do_reset1+0x86/0x17b
Aug  3 16:10:55 ash kernel:  [<c02ab2ed>] generic_ide_ioctl+0x2a8/0x395
Aug  3 16:10:55 ash kernel:  [<c02b4b4b>] idecd_ioctl+0x10e/0x142
Aug  3 16:10:55 ash kernel:  [<c0144f7a>] __do_fault+0x274/0x2ac
Aug  3 16:10:55 ash kernel:  [<c022352b>] blkdev_driver_ioctl+0x4b/0x5b
Aug  3 16:10:55 ash kernel:  [<c0223c66>] blkdev_ioctl+0x72b/0x74d
Aug  3 16:10:55 ash kernel:  [<f9a8144e>] fbcon_cursor+0x228/0x24c [fbcon]
Aug  3 16:10:55 ash kernel:  [<f9a7028b>] bit_cursor+0x0/0x4a9 [bitblit]
Aug  3 16:10:55 ash kernel:  [<c01150e9>] __wake_up+0x1d/0x3d
Aug  3 16:10:55 ash kernel:  [<c02758f4>] tty_ldisc_deref+0x4d/0x6a
Aug  3 16:10:55 ash kernel:  [<c01761ab>] block_ioctl+0x10/0x13
Aug  3 16:10:55 ash kernel:  [<c017619b>] block_ioctl+0x0/0x13
Aug  3 16:10:55 ash kernel:  [<c015f924>] vfs_ioctl+0x1c/0x5f
Aug  3 16:10:55 ash kernel:  [<c015fb96>] do_vfs_ioctl+0x22f/0x241
Aug  3 16:10:55 ash kernel:  [<c015fbe9>] sys_ioctl+0x41/0x58
Aug  3 16:10:55 ash kernel:  [<c0102bfa>] syscall_call+0x7/0xb
Aug  3 16:10:55 ash kernel:  =======================
Aug  3 16:10:55 ash kernel: Code: 4c 24 0c 8b 50 08 83 3a 00 74 04 0f 0b eb fe
89 4a 34 89 1a a1 b8 89 45 c0 83 7a 18 00 8d 0c 06 8b
42 38 89 4a 20 89 42 3c 74 04 <0f> 0b eb fe 5b 5e 8d 42 18 89 ca e9 2f 08 e7 ff
55 57 89 c7 56
Aug  3 16:10:55 ash kernel: EIP: [<c02ad446>] __ide_set_handler+0x35/0x45 SS:ESP
0068:e3debdb4
Aug  3 16:10:55 ash kernel: ---[ end trace 10d7dbc0052b883a ]---
Aug  3 16:10:55 ash kernel: note: hdparm[15804] exited with preempt_count 2
Aug  3 16:10:55 ash kernel: BUG: scheduling while atomic: hdparm/15804/0x10000002
Aug  3 16:10:55 ash kernel: Pid: 15804, comm: hdparm Tainted: G      D   2.6.26 #6
Aug  3 16:10:55 ash kernel:  [<c0385fcb>] schedule+0x62/0x2ce
Aug  3 16:10:55 ash kernel:  [<c0113825>] __cond_resched+0x13/0x28
Aug  3 16:10:55 ash kernel:  [<c03862ab>] _cond_resched+0x21/0x2a
Aug  3 16:10:55 ash kernel:  [<c01458b7>] unmap_vmas+0x37a/0x446
Aug  3 16:10:55 ash kernel:  [<c0148330>] exit_mmap+0x5a/0xd1
Aug  3 16:10:55 ash kernel:  [<c011563f>] mmput+0x1b/0x80
Aug  3 16:10:55 ash kernel:  [<c0119c4a>] do_exit+0x1a0/0x57a
Aug  3 16:10:55 ash kernel:  [<c01041d2>] die+0xe7/0xec
Aug  3 16:10:55 ash kernel:  [<c0104810>] do_invalid_op+0x0/0x6b
Aug  3 16:10:55 ash kernel:  [<c0104872>] do_invalid_op+0x62/0x6b
Aug  3 16:10:55 ash kernel:  [<c02ad446>] __ide_set_handler+0x35/0x45
Aug  3 16:10:55 ash kernel:  [<c0103583>] common_interrupt+0x23/0x28
Aug  3 16:10:55 ash kernel:  [<c023eff1>] cfb_imageblit+0x6d/0x4fc
Aug  3 16:10:55 ash kernel:  [<c02ad830>] atapi_reset_pollfunc+0x0/0x8e
Aug  3 16:10:55 ash kernel:  [<c0387872>] error_code+0x6a/0x70
Aug  3 16:10:55 ash kernel:  [<c02ad830>] atapi_reset_pollfunc+0x0/0x8e
Aug  3 16:10:55 ash kernel:  [<c02ad446>] __ide_set_handler+0x35/0x45
Aug  3 16:10:55 ash kernel:  [<c02ad4dc>] do_reset1+0x86/0x17b
Aug  3 16:10:55 ash kernel:  [<c02ab2ed>] generic_ide_ioctl+0x2a8/0x395
Aug  3 16:10:55 ash kernel:  [<c02b4b4b>] idecd_ioctl+0x10e/0x142
Aug  3 16:10:55 ash kernel:  [<c0144f7a>] __do_fault+0x274/0x2ac
Aug  3 16:10:55 ash kernel:  [<c022352b>] blkdev_driver_ioctl+0x4b/0x5b
Aug  3 16:10:55 ash kernel:  [<c0223c66>] blkdev_ioctl+0x72b/0x74d
Aug  3 16:10:55 ash kernel:  [<f9a8144e>] fbcon_cursor+0x228/0x24c [fbcon]
Aug  3 16:10:55 ash kernel:  [<f9a7028b>] bit_cursor+0x0/0x4a9 [bitblit]
Aug  3 16:10:55 ash kernel:  [<c01150e9>] __wake_up+0x1d/0x3d
Aug  3 16:10:55 ash kernel:  [<c02758f4>] tty_ldisc_deref+0x4d/0x6a
Aug  3 16:10:55 ash kernel:  [<c01761ab>] block_ioctl+0x10/0x13
Aug  3 16:10:55 ash kernel:  [<c017619b>] block_ioctl+0x0/0x13
Aug  3 16:10:55 ash kernel:  [<c015f924>] vfs_ioctl+0x1c/0x5f
Aug  3 16:10:55 ash kernel:  [<c015fb96>] do_vfs_ioctl+0x22f/0x241
Aug  3 16:10:55 ash kernel:  [<c015fbe9>] sys_ioctl+0x41/0x58
Aug  3 16:10:55 ash kernel:  [<c0102bfa>] syscall_call+0x7/0xb
Aug  3 16:10:55 ash kernel:  =======================
Aug  3 16:10:55 ash kernel: BUG: scheduling while atomic: hdparm/15804/0x10000002
Aug  3 16:10:55 ash kernel: Pid: 15804, comm: hdparm Tainted: G      D   2.6.26 #6
Aug  3 16:10:55 ash kernel:  [<c0385fcb>] schedule+0x62/0x2ce
Aug  3 16:10:55 ash kernel:  [<c0113825>] __cond_resched+0x13/0x28
Aug  3 16:10:55 ash kernel:  [<c03862ab>] _cond_resched+0x21/0x2a
Aug  3 16:10:55 ash kernel:  [<c01458b7>] unmap_vmas+0x37a/0x446
Aug  3 16:10:55 ash kernel:  [<c0148330>] exit_mmap+0x5a/0xd1
Aug  3 16:10:55 ash kernel:  [<c011563f>] mmput+0x1b/0x80
Aug  3 16:10:55 ash kernel:  [<c0119c4a>] do_exit+0x1a0/0x57a
Aug  3 16:10:55 ash kernel:  [<c01041d2>] die+0xe7/0xec
Aug  3 16:10:55 ash kernel:  [<c0104810>] do_invalid_op+0x0/0x6b
Aug  3 16:10:55 ash kernel:  [<c0104872>] do_invalid_op+0x62/0x6b
Aug  3 16:10:55 ash kernel:  [<c02ad446>] __ide_set_handler+0x35/0x45
Aug  3 16:10:55 ash kernel:  [<c0103583>] common_interrupt+0x23/0x28
Aug  3 16:10:55 ash kernel:  [<c023eff1>] cfb_imageblit+0x6d/0x4fc
Aug  3 16:10:55 ash kernel:  [<c02ad830>] atapi_reset_pollfunc+0x0/0x8e
Aug  3 16:10:55 ash kernel:  [<c0387872>] error_code+0x6a/0x70
Aug  3 16:10:55 ash kernel:  [<c02ad830>] atapi_reset_pollfunc+0x0/0x8e
Aug  3 16:10:55 ash kernel:  [<c02ad446>] __ide_set_handler+0x35/0x45
Aug  3 16:10:55 ash kernel:  [<c02ad4dc>] do_reset1+0x86/0x17b
Aug  3 16:10:55 ash kernel:  [<c02ab2ed>] generic_ide_ioctl+0x2a8/0x395
Aug  3 16:10:55 ash kernel:  [<c02b4b4b>] idecd_ioctl+0x10e/0x142
Aug  3 16:10:55 ash kernel:  [<c0144f7a>] __do_fault+0x274/0x2ac
Aug  3 16:10:55 ash kernel:  [<c022352b>] blkdev_driver_ioctl+0x4b/0x5b
Aug  3 16:10:55 ash kernel:  [<c0223c66>] blkdev_ioctl+0x72b/0x74d
Aug  3 16:10:55 ash kernel:  [<f9a8144e>] fbcon_cursor+0x228/0x24c [fbcon]
Aug  3 16:10:55 ash kernel:  [<f9a7028b>] bit_cursor+0x0/0x4a9 [bitblit]
Aug  3 16:10:55 ash kernel:  [<c01150e9>] __wake_up+0x1d/0x3d
Aug  3 16:10:55 ash kernel:  [<c02758f4>] tty_ldisc_deref+0x4d/0x6a
Aug  3 16:10:55 ash kernel:  [<c01761ab>] block_ioctl+0x10/0x13
Aug  3 16:10:55 ash kernel:  [<c017619b>] block_ioctl+0x0/0x13
Aug  3 16:10:55 ash kernel:  [<c015f924>] vfs_ioctl+0x1c/0x5f
Aug  3 16:10:55 ash kernel:  [<c015fb96>] do_vfs_ioctl+0x22f/0x241
Aug  3 16:10:55 ash kernel:  [<c015fbe9>] sys_ioctl+0x41/0x58
Aug  3 16:10:55 ash kernel:  [<c0102bfa>] syscall_call+0x7/0xb
Aug  3 16:10:55 ash kernel:  =======================
Aug  3 16:10:55 ash kernel: hdb: ATAPI reset complete
Aug  3 16:11:15 ash kernel: hda: irq timeout: status=0x80 { Busy }
Aug  3 16:11:15 ash kernel: ide: failed opcode was: unknown
=========================================================================
=========================================================================
=========================================================================
=========================================================================
=========================================================================
Aug  3 16:16:24 ash kernel: ------------[ cut here ]------------
Aug  3 16:16:24 ash kernel: kernel BUG at include/linux/timer.h:165!
Aug  3 16:16:24 ash kernel: invalid opcode: 0000 [#2] PREEMPT
Aug  3 16:16:24 ash kernel: Modules linked in: usb_storage bridge llc cdc_ether
usbnet radeon bnep rfcomm l2cap bluetooth binfmt_misc ipv6 dm_mod fbcon font
bitblit softcursor nvram af_packet nls_iso8859_1 nls_cp437 usbhid 8250_pnp 8250
serial_core rtc ehci_hcd snd_via82xx psmouse snd_mpu401_uart uhci_hcd usbcore
8139too sata_sil e1000 bitrev crc32 evdev
Aug  3 16:16:24 ash kernel:
Aug  3 16:16:24 ash kernel: Pid: 15866, comm: hdparm Tainted: G      D   (2.6.26 #6)
Aug  3 16:16:24 ash kernel: EIP: 0060:[<c02ad446>] EFLAGS: 00010082 CPU: 0
Aug  3 16:16:24 ash kernel: EIP is at __ide_set_handler+0x35/0x45
Aug  3 16:16:24 ash kernel: EAX: 00083f62 EBX: c02ad830 ECX: 01d66831 EDX: f7fadce0
Aug  3 16:16:24 ash kernel: ESI: 00000032 EDI: c04d2cd0 EBP: 00000246 ESP: c1c01db4
Aug  3 16:16:24 ash kernel:  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Aug  3 16:16:24 ash kernel: Process hdparm (pid: 15866, ti=c1c00000
task=e3c15c40 task.ti=c1c00000)
Aug  3 16:16:24 ash kernel: Stack: f7fadce0 c04d2c84 c02ad4dc 00000000 00000202
c04d2cd0 00000000 f7802860
Aug  3 16:16:24 ash kernel:        c02ab2ed c046bb48 0000031c f7fed804 f78028c4
c02b4b4b 0000031c 00000000
Aug  3 16:16:24 ash kernel:        f3eccb40 00000000 00000000 f71d01e0 00000000
c17fe980 00000000 00000000
Aug  3 16:16:24 ash kernel: Call Trace:
Aug  3 16:16:24 ash kernel:  [<c02ad4dc>] do_reset1+0x86/0x17b
Aug  3 16:16:24 ash kernel:  [<c02ab2ed>] generic_ide_ioctl+0x2a8/0x395
Aug  3 16:16:24 ash kernel:  [<c02b4b4b>] idecd_ioctl+0x10e/0x142
Aug  3 16:16:24 ash kernel:  [<c0144f7a>] __do_fault+0x274/0x2ac
Aug  3 16:16:24 ash kernel:  [<c022352b>] blkdev_driver_ioctl+0x4b/0x5b
Aug  3 16:16:24 ash kernel:  [<c0223c66>] blkdev_ioctl+0x72b/0x74d
Aug  3 16:16:24 ash kernel:  [<f9a8144e>] fbcon_cursor+0x228/0x24c [fbcon]
Aug  3 16:16:24 ash kernel:  [<f9a7028b>] bit_cursor+0x0/0x4a9 [bitblit]
Aug  3 16:16:24 ash kernel:  [<c01150e9>] __wake_up+0x1d/0x3d
Aug  3 16:16:24 ash kernel:  [<c02758f4>] tty_ldisc_deref+0x4d/0x6a
Aug  3 16:16:24 ash kernel:  [<c01761ab>] block_ioctl+0x10/0x13
Aug  3 16:16:24 ash kernel:  [<c017619b>] block_ioctl+0x0/0x13
Aug  3 16:16:24 ash kernel:  [<c015f924>] vfs_ioctl+0x1c/0x5f
Aug  3 16:16:24 ash kernel:  [<c015fb96>] do_vfs_ioctl+0x22f/0x241
Aug  3 16:16:24 ash kernel:  [<c015fbe9>] sys_ioctl+0x41/0x58
Aug  3 16:16:24 ash kernel:  [<c0102bfa>] syscall_call+0x7/0xb
Aug  3 16:16:24 ash kernel:  =======================
Aug  3 16:16:24 ash kernel: Code: 4c 24 0c 8b 50 08 83 3a 00 74 04 0f 0b eb fe
89 4a 34 89 1a a1 b8 89 45 c0 83 7a 18 00 8d 0c 06 8b 42 38 89 4a 20 89 42 3c 74
04 <0f> 0b eb fe 5b 5e 8d 42 18 89 ca e9 2f 08 e7 ff 55 57 89 c7 56
Aug  3 16:16:24 ash kernel: EIP: [<c02ad446>] __ide_set_handler+0x35/0x45 SS:ESP
0068:c1c01db4
Aug  3 16:16:24 ash kernel: ---[ end trace 10d7dbc0052b883a ]---
ug  3 16:16:24 ash kernel: note: hdparm[15866] exited with preempt_count 2
Aug  3 16:16:24 ash kernel: BUG: scheduling while atomic: hdparm/15866/0x10000002
Aug  3 16:16:24 ash kernel: Pid: 15866, comm: hdparm Tainted: G      D   2.6.26 #6
Aug  3 16:16:24 ash kernel:  [<c0385fcb>] schedule+0x62/0x2ce
Aug  3 16:16:24 ash kernel:  [<c011ded0>] run_timer_softirq+0x186/0x18e
Aug  3 16:16:24 ash kernel:  [<c0113825>] __cond_resched+0x13/0x28
Aug  3 16:16:24 ash kernel:  [<c03862ab>] _cond_resched+0x21/0x2a
Aug  3 16:16:24 ash kernel:  [<c01458b7>] unmap_vmas+0x37a/0x446
Aug  3 16:16:24 ash kernel:  [<c0148330>] exit_mmap+0x5a/0xd1
Aug  3 16:16:24 ash kernel:  [<c011563f>] mmput+0x1b/0x80
Aug  3 16:16:24 ash kernel:  [<c0119c4a>] do_exit+0x1a0/0x57a
Aug  3 16:16:24 ash kernel:  [<c01041d2>] die+0xe7/0xec
Aug  3 16:16:24 ash kernel:  [<c0104810>] do_invalid_op+0x0/0x6b
Aug  3 16:16:24 ash kernel:  [<c0104872>] do_invalid_op+0x62/0x6b
Aug  3 16:16:24 ash kernel:  [<c02ad446>] __ide_set_handler+0x35/0x45
Aug  3 16:16:24 ash kernel:  [<c0103583>] common_interrupt+0x23/0x28
Aug  3 16:16:24 ash kernel:  [<c023eff1>] cfb_imageblit+0x6d/0x4fc
Aug  3 16:16:24 ash kernel:  [<c02ad830>] atapi_reset_pollfunc+0x0/0x8e
Aug  3 16:16:24 ash kernel:  [<c0387872>] error_code+0x6a/0x70
Aug  3 16:16:24 ash kernel:  [<c02ad830>] atapi_reset_pollfunc+0x0/0x8e
Aug  3 16:16:24 ash kernel:  [<c02ad446>] __ide_set_handler+0x35/0x45
Aug  3 16:16:24 ash kernel:  [<c02ad4dc>] do_reset1+0x86/0x17b
Aug  3 16:16:24 ash kernel:  [<c02ab2ed>] generic_ide_ioctl+0x2a8/0x395
Aug  3 16:16:24 ash kernel:  [<c02b4b4b>] idecd_ioctl+0x10e/0x142
Aug  3 16:16:24 ash kernel:  [<c0144f7a>] __do_fault+0x274/0x2ac
Aug  3 16:16:24 ash kernel:  [<c022352b>] blkdev_driver_ioctl+0x4b/0x5b
Aug  3 16:16:24 ash kernel:  [<c0223c66>] blkdev_ioctl+0x72b/0x74d
Aug  3 16:16:24 ash kernel:  [<f9a8144e>] fbcon_cursor+0x228/0x24c [fbcon]
Aug  3 16:16:24 ash kernel:  [<f9a7028b>] bit_cursor+0x0/0x4a9 [bitblit]
Aug  3 16:16:24 ash kernel:  [<c01150e9>] __wake_up+0x1d/0x3d
Aug  3 16:16:24 ash kernel:  [<c02758f4>] tty_ldisc_deref+0x4d/0x6a
Aug  3 16:16:24 ash kernel:  [<c01761ab>] block_ioctl+0x10/0x13
Aug  3 16:16:24 ash kernel:  [<c017619b>] block_ioctl+0x0/0x13
Aug  3 16:16:24 ash kernel:  [<c015f924>] vfs_ioctl+0x1c/0x5f
Aug  3 16:16:24 ash kernel:  [<c015fb96>] do_vfs_ioctl+0x22f/0x241
Aug  3 16:16:24 ash kernel:  [<c015fbe9>] sys_ioctl+0x41/0x58
Aug  3 16:16:24 ash kernel:  [<c0102bfa>] syscall_call+0x7/0xb
Aug  3 16:16:24 ash kernel:  =======================
Aug  3 16:16:24 ash kernel: BUG: scheduling while atomic: hdparm/15866/0x00000002
Aug  3 16:16:24 ash kernel: Pid: 15866, comm: hdparm Tainted: G      D   2.6.26 #6
Aug  3 16:16:24 ash kernel:  [<c0385fcb>] schedule+0x62/0x2ce
Aug  3 16:16:24 ash kernel:  [<c020b8e5>] xfs_free_eofblocks+0xdc/0x259
Aug  3 16:16:24 ash kernel:  [<c0386a10>] __mutex_lock_slowpath+0x61/0xa1
Aug  3 16:16:24 ash kernel:  [<c0386894>] mutex_lock+0x9/0xa
Aug  3 16:16:24 ash kernel:  [<c01765c4>] __blkdev_put+0x1c/0x103
Aug  3 16:16:24 ash kernel:  [<c015657e>] __fput+0x8a/0x144
Aug  3 16:16:24 ash kernel:  [<c0153e5f>] filp_close+0x4d/0x53
Aug  3 16:16:24 ash kernel:  [<c01188f9>] put_files_struct+0x5f/0xa5
Aug  3 16:16:24 ash kernel:  [<c0119c63>] do_exit+0x1b9/0x57a
Aug  3 16:16:24 ash kernel:  [<c01041d2>] die+0xe7/0xec
Aug  3 16:16:24 ash kernel:  [<c0104810>] do_invalid_op+0x0/0x6b
Aug  3 16:16:24 ash kernel:  [<c0104872>] do_invalid_op+0x62/0x6b
Aug  3 16:16:24 ash kernel:  [<c02ad446>] __ide_set_handler+0x35/0x45
Aug  3 16:16:24 ash kernel:  [<c0103583>] common_interrupt+0x23/0x28
Aug  3 16:16:24 ash kernel:  [<c023eff1>] cfb_imageblit+0x6d/0x4fc
Aug  3 16:16:24 ash kernel:  [<c02ad830>] atapi_reset_pollfunc+0x0/0x8e
Aug  3 16:16:24 ash kernel:  [<c0387872>] error_code+0x6a/0x70
Aug  3 16:16:24 ash kernel:  [<c02ad830>] atapi_reset_pollfunc+0x0/0x8e
Aug  3 16:16:24 ash kernel:  [<c02ad446>] __ide_set_handler+0x35/0x45
Aug  3 16:16:24 ash kernel:  [<c02ad4dc>] do_reset1+0x86/0x17b
Aug  3 16:16:24 ash kernel:  [<c02ab2ed>] generic_ide_ioctl+0x2a8/0x395
Aug  3 16:16:24 ash kernel:  [<c02b4b4b>] idecd_ioctl+0x10e/0x142
Aug  3 16:16:24 ash kernel:  [<c0144f7a>] __do_fault+0x274/0x2ac
Aug  3 16:16:24 ash kernel:  [<c022352b>] blkdev_driver_ioctl+0x4b/0x5b
Aug  3 16:16:24 ash kernel:  [<c0223c66>] blkdev_ioctl+0x72b/0x74d
Aug  3 16:16:24 ash kernel:  [<f9a8144e>] fbcon_cursor+0x228/0x24c [fbcon]
Aug  3 16:16:24 ash kernel:  [<f9a7028b>] bit_cursor+0x0/0x4a9 [bitblit]
Aug  3 16:16:24 ash kernel:  [<c01150e9>] __wake_up+0x1d/0x3d
Aug  3 16:16:24 ash kernel:  [<c02758f4>] hdb: ATAPI reset complete
Aug  3 16:16:24 ash kernel: tty_ldisc_deref+0x4d/0x6a
Aug  3 16:16:24 ash kernel:  [<c01761ab>] block_ioctl+0x10/0x13
Aug  3 16:16:24 ash kernel:  [<c017619b>] block_ioctl+0x0/0x13
Aug  3 16:16:24 ash kernel:  [<c015f924>] vfs_ioctl+0x1c/0x5f
Aug  3 16:16:24 ash kernel:  [<c015fb96>] do_vfs_ioctl+0x22f/0x241
Aug  3 16:16:24 ash kernel:  [<c015fbe9>] sys_ioctl+0x41/0x58
Aug  3 16:16:24 ash kernel:  [<c0102bfa>] syscall_call+0x7/0xb
Aug  3 16:16:24 ash kernel:  =======================

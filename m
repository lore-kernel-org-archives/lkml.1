Return-Path: <linux-kernel-owner+w=401wt.eu-S1753829AbYJCLe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829AbYJCLe1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 07:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbYJCLeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 07:34:19 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:37149 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335AbYJCLeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 07:34:18 -0400
From: Vit Kudrle <kudrle@sci.muni.cz>
Message-Id: <200810031134.m93BYDqQ025308@elanor.sci.muni.cz>
Subject: Kernel Oops in USB HID
To: linux-kernel@vger.kernel.org
Date: Fri, 3 Oct 2008 13:34:13 +0200 (CEST)
X-Mailer: ELM [version 2.4ME+ PL93 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
X-Muni-Spam-TestIP: 147.251.24.2
X-Muni-Envelope-From: kudrle@sci.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Fri, 03 Oct 2008 13:34:15 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, this morning I found in my logs following kernel Oops:


Oct  3 01:11:06 apcupsd[4334]: Power failure.
Oct  3 01:11:08 apcupsd[4334]: Power is back. UPS running on mains.
Oct  3 01:12:24 apcupsd[4334]: Power failure.
Oct  3 01:12:27 apcupsd[4334]: Power is back. UPS running on mains.
Oct  3 01:12:39 apcupsd[4334]: Power failure.
Oct  3 01:12:41 apcupsd[4334]: Power is back. UPS running on mains.
Oct  3 01:14:57 apcupsd[4334]: Power failure.
Oct  3 01:15:01 apcupsd[4334]: Power is back. UPS running on mains.
Oct  3 01:15:10 apcupsd[4334]: Power failure.
Oct  3 01:15:13 apcupsd[4334]: Power is back. UPS running on mains.
Oct  3 01:15:55 apcupsd[4334]: Power failure.
Oct  3 01:15:58 apcupsd[4334]: Power is back. UPS running on mains.
Oct  3 01:16:58 kernel: hub 2-0:1.0: port 7 disabled by hub (EMI?), re-enabling...
Oct  3 01:16:58 kernel: usb 2-7: USB disconnect, address 39
Oct  3 01:16:58 kernel: drivers/hid/usbhid/hid-core.c: usb_submit_urb(ctrl) failed
Oct  3 01:16:58 kernel: BUG: unable to handle kernel NULL pointer dereference at 00000000000000c8
Oct  3 01:16:58 kernel: IP: [<ffffffff803b0755>] hiddev_ioctl+0x39/0x552
Oct  3 01:16:58 kernel: PGD 1d894067 PUD 1d9f1067 PMD 0 
Oct  3 01:16:58 kernel: Oops: 0000 [1] PREEMPT 
Oct  3 01:16:58 kernel: CPU 0 
Oct  3 01:16:58 kernel: Modules linked in: nls_cp437 nls_iso8859_1 parport_pc parport 8250_pnp 8250 serial_core
Oct  3 01:16:58 kernel: Pid: 4334, comm: apcupsd Not tainted 2.6.26 #2
Oct  3 01:16:58 kernel: RIP: 0010:[<ffffffff803b0755>]  [<ffffffff803b0755>] hiddev_ioctl+0x39/0x552
Oct  3 01:16:58 kernel: RSP: 0018:ffff81001d917e38  EFLAGS: 00010246
Oct  3 01:16:58 kernel: RAX: 0000000000000000 RBX: ffff81002f61c000 RCX: 00007fffa5f44be0
Oct  3 01:16:58 kernel: RDX: 00000000fffffffb RSI: ffff81003ecfe800 RDI: ffff81001d9af880
Oct  3 01:16:58 kernel: RBP: 00007fffa5f44be0 R08: 00000000400c4807 R09: 0000000000000000
Oct  3 01:16:58 kernel: R10: 00007fffa5f44c50 R11: 0000000000000246 R12: 00000000400c4807
Oct  3 01:16:58 kernel: R13: 00000000fffffff7 R14: 00000000400c4807 R15: 0000000000000000
Oct  3 01:16:58 kernel: FS:  00007f909df356d0(0000) GS:ffffffff8052d000(0000) knlGS:0000000008277840
Oct  3 01:16:58 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Oct  3 01:16:58 kernel: CR2: 00000000000000c8 CR3: 000000001da87000 CR4: 00000000000006e0
Oct  3 01:16:58 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Oct  3 01:16:58 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Oct  3 01:16:58 kernel: Process apcupsd (pid: 4334, threadinfo ffff81001d916000, task ffff81003f2d3b20)
Oct  3 01:16:58 kernel: Stack:  ffff81003f4311a8 ffff810010e75e48 ffff81001d917eb8 ffffffff8042741d
Oct  3 01:16:58 kernel:  ffff81001d917ed8 ffff81003f2d3b20 ffffffff804f2320 ffff81003f2d3d60
Oct  3 01:16:58 kernel:  000431f4b55a2feb 0000000000000296 0000000000000282 0000000000000292
Oct  3 01:16:58 kernel: Call Trace:
Oct  3 01:16:58 kernel:  [<ffffffff8042741d>] ? thread_return+0x65/0xb5
Oct  3 01:16:58 kernel:  [<ffffffff8023977e>] ? hrtimer_cancel+0xc/0x16
Oct  3 01:16:58 kernel:  [<ffffffff80428080>] ? do_nanosleep+0x61/0x99
Oct  3 01:16:58 kernel:  [<ffffffff8027a569>] ? vfs_ioctl+0x55/0x6b
Oct  3 01:16:58 kernel:  [<ffffffff8027a7d1>] ? do_vfs_ioctl+0x252/0x26b
Oct  3 01:16:58 kernel:  [<ffffffff8027a826>] ? sys_ioctl+0x3c/0x5e
Oct  3 01:16:58 kernel:  [<ffffffff8020b07b>] ? system_call_after_swapgs+0x7b/0x80
Oct  3 01:16:58 kernel: 
Oct  3 01:16:58 kernel: 
Oct  3 01:16:58 kernel: Code: 53 48 81 ec 90 00 00 00 48 8b b6 88 00 00 00 48 8b be 18 06 00 00 48 8b 5f 18 83 3f 00 48 8b 83 80 18 00 00 4c 8b 8b b8 19 00 00 <48> 8b 88 c8 00 00 00 0f 84 fe 04 00 00 41 81 f8 01 48 04 80 0f 
Oct  3 01:16:58 kernel: RIP  [<ffffffff803b0755>] hiddev_ioctl+0x39/0x552
Oct  3 01:16:58 kernel:  RSP <ffff81001d917e38>
Oct  3 01:16:58 kernel: CR2: 00000000000000c8
Oct  3 01:16:58 kernel: ---[ end trace 91d6a9f7154b114c ]---
Oct  3 01:16:59 kernel: usb 2-7: new low speed USB device using ohci_hcd and address 46
Oct  3 01:16:59 kernel: usb 2-7: configuration #1 chosen from 1 choice
Oct  3 01:16:59 kernel: hiddev96: USB HID v1.00 Device [American Power Conversion Back-UPS 500 FW: 6.4.I USB FW: c1 ] on usb-0000:00:02.0-7

Oct  3 06:16:20 kernel: hub 2-0:1.0: port 7 disabled by hub (EMI?), re-enabling...
Oct  3 06:16:20 kernel: usb 2-7: USB disconnect, address 46
Oct  3 06:16:20 kernel: usb 2-7: new low speed USB device using ohci_hcd and address 47
Oct  3 06:16:20 kernel: usb 2-7: configuration #1 chosen from 1 choice
Oct  3 06:16:21 kernel: hiddev96: USB HID v1.00 Device [American Power Conversion Back-UPS 500 FW: 6.4.I USB FW: c1 ] on usb-0000:00:02.0-7
Oct  3 06:16:26 kernel: hub 2-0:1.0: port 7 disabled by hub (EMI?), re-enabling...
Oct  3 06:16:26 kernel: usb 2-7: USB disconnect, address 47
Oct  3 06:16:26 kernel: usb 2-7: new low speed USB device using ohci_hcd and address 48
Oct  3 06:16:26 kernel: usb 2-7: configuration #1 chosen from 1 choice
Oct  3 06:16:26 kernel: usbhid: ctrl urb status -62 received
Oct  3 06:16:26 last message repeated 14 times
Oct  3 06:16:26 kernel: hiddev96: USB HID v1.00 Device [American Power Conversion Back-UPS 500 FW: 6.4.I USB FW: c1 ] on usb-0000:00:02.0-7
Oct  3 06:16:26 kernel: hub 2-0:1.0: port 7 disabled by hub (EMI?), re-enabling...
Oct  3 06:16:26 kernel: usb 2-7: USB disconnect, address 48
Oct  3 06:16:27 kernel: usb 2-7: new low speed USB device using ohci_hcd and address 49
Oct  3 06:16:27 kernel: usb 2-7: string descriptor 0 too short
Oct  3 06:16:27 kernel: usb 2-7: configuration #1 chosen from 1 choice
Oct  3 06:17:18 kernel: hub 2-0:1.0: port 7 disabled by hub (EMI?), re-enabling...
Oct  3 06:17:18 kernel: usb 2-7: USB disconnect, address 49
Oct  3 06:17:18 kernel: usb 2-7: new low speed USB device using ohci_hcd and address 50
Oct  3 06:17:19 kernel: usb 2-7: configuration #1 chosen from 1 choice
Oct  3 06:17:19 kernel: hiddev96: USB HID v1.00 Device [American Power Conversion Back-UPS 500 FW: 6.4.I USB FW: c1 ] on usb-0000:00:02.0-7
Oct  3 06:20:50 kernel: hub 2-0:1.0: port 7 disabled by hub (EMI?), re-enabling...
Oct  3 06:20:50 kernel: usb 2-7: USB disconnect, address 50
Oct  3 06:20:50 kernel: usb 2-7: new low speed USB device using ohci_hcd and address 51
Oct  3 06:20:50 kernel: usb 2-7: configuration #1 chosen from 1 choice
Oct  3 06:20:51 kernel: hiddev96: USB HID v1.00 Device [American Power Conversion Back-UPS 500 FW: 6.4.I USB FW: c1 ] on usb-0000:00:02.0-7



My UPS unit is actually quite bad, it often detects blackout when nothing
happens and so it cycles a lot (see the beginning of the log). Also, sometimes
it fails to be recognised by usb/hid subsystem (see the log around 6 am).
However, kernel oops never happened before. Therefore, I am not able
to reproduce the bug.


I am running Debian patched kernel 2.6.26, which I manually configured
and compiled for amd64 from package "linux-source-2.6.26_2.6.26-2_all.deb".
Relevant config options are, of course, 
CONFIG_PREEMPT=y
CONFIG_USB_HIDDEV=y


This bug is probably benign, but still, somebody should look into it deeper.


	Vit


Return-Path: <linux-kernel-owner+w=401wt.eu-S1751537AbXB0Kgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537AbXB0Kgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 05:36:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932160AbXB0Kgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 05:36:41 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:58209 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751537AbXB0Kgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 05:36:40 -0500
Date: Tue, 27 Feb 2007 11:36:20 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>
Subject: 2.6.21-rc1: mmc reader no longer works, usb oops
Message-ID: <20070227103620.GA8205@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

MMC card reader in x60 no longer works in -rc1. (Will have to check if
it worked before s2ram).

When playing with usb-serial, I got this oops (upon trying to start
minicom /dev/ttyUSB0 while linux gadget on the other end was
crashing).
								Pavel
...
usbcore: registered new interface driver usbserial
drivers/usb/serial/usb-serial.c: USB Serial support registered for generic
usbcore: registered new interface driver usbserial_generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core
usb 2-2: USB disconnect, address 6
PM: Removing info for No Bus:usbdev2.6_ep84
PM: Removing info for usb:2-2:1.0
PM: Removing info for No Bus:usbdev2.6_ep82
PM: Removing info for No Bus:usbdev2.6_ep03
PM: Removing info for usb:2-2:1.1
PM: Removing info for No Bus:usbdev2.6
PM: Removing info for No Bus:usbdev2.6_ep00
PM: Removing info for usb:2-2
usb 2-2: new full speed USB device using uhci_hcd and address 7
PM: Adding info for usb:2-2
PM: Adding info for No Bus:usbdev2.7_ep00
usb 2-2: configuration #1 chosen from 1 choice
PM: Adding info for usb:2-2:1.0
usbserial_generic 2-2:1.0: generic converter detected
PM: Adding info for usb-serial:ttyUSB72
PM: Adding info for No Bus:ttyUSB72
usb 2-2: generic converter now attached to ttyUSB72
PM: Adding info for No Bus:usbdev2.7_ep01
PM: Adding info for No Bus:usbdev2.7_ep82
PM: Adding info for No Bus:usbdev2.7_ep83
PM: Adding info for No Bus:usbdev2.7
usb 2-2: USB disconnect, address 7
PM: Removing info for No Bus:usbdev2.7_ep01
PM: Removing info for No Bus:usbdev2.7_ep82
PM: Removing info for No Bus:usbdev2.7_ep83
PM: Removing info for No Bus:ttyUSB72
generic ttyUSB72: generic converter now disconnected from ttyUSB72
PM: Removing info for usb-serial:ttyUSB72
usbserial_generic 2-2:1.0: device disconnected
PM: Removing info for usb:2-2:1.0
PM: Removing info for No Bus:usbdev2.7
PM: Removing info for No Bus:usbdev2.7_ep00
PM: Removing info for usb:2-2
BUG: unable to handle kernel NULL pointer dereference at virtual address 00000014
 printing eip:
c0620657
*pde = 00000000
Oops: 0002 [#1]
SMP 
Modules linked in: usbserial
CPU:    0
EIP:    0060:[<c0620657>]    Not tainted VLI
EFLAGS: 00010046   (2.6.21-rc1 #404)
EIP is at __mutex_lock_interruptible_slowpath+0x27/0x270
eax: ed832000   ebx: 00000010   ecx: ffffffed   edx: 0000006b
esi: 00000246   edi: c217c030   ebp: 00000010   esp: ed833e5c
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process minicom (pid: 7929, ti=ed832000 task=c217c030 task.ti=ed832000)
Stack: 00000000 c02dd875 f6f58000 c0170b42 f2f0a308 00000000 c078a3e0 ed833ec8 
       00000000 00000004 c20d50e8 f76ec3ec 00000010 f8cdae7c c02da5a4 22222222 
       22222222 f714e1b0 ffffffed ffffffed f714e1b0 0bc00000 f76ec3ec c02ddcdb 
Call Trace:
 [<c02dd875>] init_dev+0x2c5/0x5e0
 [<c0170b42>] get_unused_fd+0x52/0xc0
 [<f8cdae7c>] serial_open+0x5c/0x180 [usbserial]
 [<c02da5a4>] check_tty_count+0x14/0xb0
 [<c02ddcdb>] tty_open+0x14b/0x2c0
 [<c017443d>] chrdev_open+0xad/0x1a0
 [<c0174390>] chrdev_open+0x0/0x1a0
 [<c0170f88>] __dentry_open+0xb8/0x1d0
 [<c0171155>] nameidata_to_filp+0x35/0x40
 [<c01711ab>] do_filp_open+0x4b/0x60
 [<c016d46e>] cache_alloc_debugcheck_after+0x3e/0x150
 [<c0170b42>] get_unused_fd+0x52/0xc0
 [<c017120a>] do_sys_open+0x4a/0xe0
 [<c01712dc>] sys_open+0x1c/0x20
 [<c0104110>] syscall_call+0x7/0xb
 =======================
Code: 00 00 00 00 55 57 56 53 89 c3 83 ec 24 89 e0 25 00 e0 ff ff 64 8b 3d 08 00 00 00 f7 40 14 00 ff ff 0f 0f 85 f7 01 00 00 9c 5e fa <f0> fe 4b 04 79 0a f3 90 80 7b 04 00 7e f8 eb f0 3b 5b 18 0f 85 
EIP: [<c0620657>] __mutex_lock_interruptible_slowpath+0x27/0x270 SS:ESP 0068:ed833e5c
usb 2-2: new full speed USB device using uhci_hcd and address 8
Slab corruption: start=c20d50e8, len=64
Redzone: 0x5a2cf071/0x5a2cf071.
Last user: [<c0254d58>](kobject_uevent_env+0x3b8/0x4e0)
030: 6b 6b 6b 6b 6c 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5
Next obj: start=c20d5134, len=64
Redzone: 0x170fc2a5/0x170fc2a5.
Last user: [<c016dc25>](cache_alloc_refill+0x4f5/0x6c0)
000: 90 ce 7b f7 74 cf 7b f7 00 00 00 00 00 00 25 f7
010: 08 00 00 00 ff ff ff ff 00 00 5a 5a fe ff ff ff
PM: Adding info for usb:2-2
PM: Adding info for No Bus:usbdev2.8_ep00
usb 2-2: configuration #1 chosen from 2 choices
PM: Adding info for usb:2-2:1.0
PM: Adding info for No Bus:usb0
usb0: register 'cdc_ether' at usb-0000:00:1d.0-2, CDC Ethernet Device, 4e:32:36:a7:73:2e
PM: Adding info for No Bus:usbdev2.8_ep83
PM: Adding info for usb:2-2:1.1
PM: Adding info for No Bus:usbdev2.8_ep81
PM: Adding info for No Bus:usbdev2.8_ep02
PM: Adding info for No Bus:usbdev2.8
usb 2-2: USB disconnect, address 8
PM: Removing info for No Bus:usbdev2.8_ep83
usb0: unregister 'cdc_ether' usb-0000:00:1d.0-2, CDC Ethernet Device
PM: Removing info for No Bus:usb0
PM: Removing info for usb:2-2:1.0
PM: Removing info for No Bus:usbdev2.8_ep81
PM: Removing info for No Bus:usbdev2.8_ep02
PM: Removing info for usb:2-2:1.1
PM: Removing info for No Bus:usbdev2.8
PM: Removing info for No Bus:usbdev2.8_ep00
PM: Removing info for usb:2-2
usb 2-2: new full speed USB device using uhci_hcd and address 9
PM: Adding info for usb:2-2
PM: Adding info for No Bus:usbdev2.9_ep00
usb 2-2: configuration #1 chosen from 1 choice
PM: Adding info for usb:2-2:1.0
PM: Adding info for No Bus:usbdev2.9_ep84
PM: Adding info for usb:2-2:1.1
PM: Adding info for No Bus:usbdev2.9_ep82
PM: Adding info for No Bus:usbdev2.9_ep03
PM: Adding info for No Bus:usbdev2.9




-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

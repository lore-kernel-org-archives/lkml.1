Return-Path: <linux-kernel-owner+w=401wt.eu-S1757946AbYJ3XLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946AbYJ3XLn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 19:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbYJ3XLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 19:11:34 -0400
Received: from mail.gmx.net ([213.165.64.20]:59096 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753561AbYJ3XLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 19:11:32 -0400
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX185OVpu6cI5pWaO89i+sPRn0dQZr8oREiH4mFEPPp
	4B8/NTbB7olReU
From: Helge Deller <deller@gmx.de>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: 2.6.28-rc2: USB/INPUT: slab error in cache_alloc_debugcheck_after(): double free?
Date: Fri, 31 Oct 2008 00:11:08 +0100
User-Agent: KMail/1.9.7
X-Face: &[jmHH-Dw>Aj):"[/t-VasJu+(5eP`/LEckV7V"JV,!nBy[6(/?#8M>x`5xzg/7:FkM.l@
	13<&9'nfV3"OkD~P)@j{P2=(uB7J(){:CcrM2jZeA+IBq?FUTp3c8Y{t+k<95mZf~[v"':
	t"f6wKtHUPFB&/]Z5^?9~IQs=16R;Pg"NS9JD=DK!ft&4b@S~&q/MfI3;qWqlg7Q1==jS4
	9V5OJkm$WQ[dc^_Y']DvibvMjizUZ]+'Jd4UnM><yrT}Rw(
Cc: linux-parisc@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810310011.08618.deller@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed various slab errors with complete kernel crashes with my USB keyboard/mouse on a 32bit parisc machine with both 2.6.28-rc1 and -rc2.
Kernel 2.6.27 was still OK.

Linux kernel bootlog shows:
---------------
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd 0000:00:0e.2: OHCI Host Controller
ohci_hcd 0000:00:0e.2: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:0e.2: irq 1, io mem 0xf2007000
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 3 ports detected
usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: OHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.28-rc2 ohci_hcd
usb usb1: SerialNumber: 0000:00:0e.2
uhci_hcd: USB Universal Host Controller Interface driver


After sucessful bootup (without any USB devices attached)
I get this when I insert a USB keyboard:
---------------
usb 1-1: new low speed USB device using ohci_hcd and address 2
usb 1-1: configuration #1 chosen from 1 choice
input: SILITEK USB Keyboard and Mouse as /class/input/input0
Slab corruption: size-4096 start=8dd9b000, len=4096
000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
generic-usb 0004:047B:0002.0001: input,hidraw0: USB HID v1.00 Keyboard [SILITEK USB Keyboard and Mouse] on usb-0000:00:0e.2-1/input0
input: SILITEK USB Keyboard and Mouse as /class/input/input1
generic-usb 0003:047B:0002.0002: input,hidraw1: USB HID v1.00 Mouse [SILITEK USB Keyboard and Mouse] on usb-0000:00:0e.2-1/input1
usb 1-1: New USB device found, idVendor=047b, idProduct=0002
usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-1: Product: USB Keyboard and Mouse
usb 1-1: Manufacturer: SILITEK


Similiar when I insert a mouse:
------------------
usb 1-1: new low speed USB device using ohci_hcd and address 2
usb 1-1: configuration #1 chosen from 1 choice
input: Logitech N48 as /class/input/input0
Slab corruption: shmem_inode_cache start=8bd9daa0, len=640
Redzone: 0x0/0x9f911029d74e35b.
Last user: [<00000000>](0x0)
000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Prev obj: start=8bd9d870, len=640
Redzone: 0x6b6b6b6b6b6b6b6b/0x0.
Last user: [<00000000>](0x0)
000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
slab error in cache_alloc_debugcheck_after(): cache `shmem_inode_cache': double free, or memory outside objecn
Backtrace:
 [<101a4e84>] cache_alloc_debugcheck_after+0xd8/0x200
 [<101a540c>] kmem_cache_alloc+0x1a0/0x1e8
 [<101a26e4>] shmem_alloc_inode+0x18/0x34
 [<101be158>] alloc_inode+0x28/0x238
 [<101bf204>] new_inode+0x20/0xc0
 [<101a0eb8>] shmem_get_inode+0x34/0x1ac
 [<101a1be0>] shmem_symlink+0x60/0x260
 [<101b6034>] vfs_symlink+0x74/0xc8
 [<101b6118>] sys_symlinkat+0x90/0xfc
 [<101190c0>] syscall_exit+0x0/0x28

8bd9da98: redzone 1:0x0, redzone 2:0x9f911029d74e35b
Slab corruption: size-4096 start=8bd18000, len=4096
000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
generic-usb 0003:046D:C001.0001: input,hidraw0: USB HID v1.00 Mouse [Logitech N48] on usb-0000:00:0e.2-1/inpu0
usb 1-1: New USB device found, idVendor=046d, idProduct=c001
usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-1: Product: N48
usb 1-1: Manufacturer: Logitech


On 2.6.28-rc1 I saw e.g. this:
--------------------
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
usb 1-1: new low speed USB device using ohci_hcd and address 2
usb 1-1: configuration #1 chosen from 1 choice
input: Logitech N48 as /class/input/input0
generic-usb 0003:046D:C001.0001: input,hidraw0: USB HID v1.00 Mouse 
[Logitech N48] on usb-0000:00:0e.2-1/inpu0
usb 1-1: New USB device found, idVendor=046d, idProduct=c001
usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-1: Product: N48
usb 1-1: Manufacturer: Logitech
usb 1-2: new low speed USB device using ohci_hcd and address 3
usb 1-2: configuration #1 chosen from 1 choice
slab error in cache_alloc_debugcheck_after(): cache `size-512': double free, or memory outside object was oven
Backtrace:
   [<101a5724>] cache_alloc_debugcheck_after+0xd8/0x200
   [<101a5cac>] kmem_cache_alloc+0x1a0/0x1e8
   [<1042e294>] hid_register_report+0x60/0xc4
   [<1042e5f8>] hid_add_field+0x40/0x1a4
   [<1042ec40>] hid_parser_main+0x94/0xc4

Helge

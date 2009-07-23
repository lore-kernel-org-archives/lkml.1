Return-Path: <linux-kernel-owner+w=401wt.eu-S1752585AbZGWSUC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbZGWSUC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 14:20:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752282AbZGWSUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 14:20:01 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47569 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752168AbZGWSUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 14:20:00 -0400
Date: Thu, 23 Jul 2009 14:19:59 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Valdis.Kletnieks@vt.edu
cc: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Jiri Kosina <jkosina@suse.cz>, Greg Kroah-Hartman <gregkh@suse.de>,
       <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: 31-rc3-mmotm0716 - dead USB trackball mouse kills entire system
In-Reply-To: <4789.1248365209@turing-police.cc.vt.edu>
Message-ID: <Pine.LNX.4.44L0.0907231416170.3509-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jul 2009 Valdis.Kletnieks@vt.edu wrote:

> Well... Usually.  Today, on a -mmotm0716 kernel, the loose conductor struck
> again, and no amount of wiggling would resurrect it as far as the system was
> concerned.  Note however that it *did* wake up just fine when I finally
> rebooted the machine, even though I had not touched the mouse any further -
> which says to me that the wires were making a connection again, but the kernel
> wasn't picking up on it.
> 
> Meanwhile, in my kernel logs, I had:
> 
> [  571.965568] drivers/hid/usbhid/hid-core.c: can't reset device, 0000:00:1d.7-8.3/input0, status -71
> [  571.965661] usb 1-8: clear tt 3 (0060) error -32
> [  571.981570] drivers/hid/usbhid/hid-core.c: can't reset device, 0000:00:1d.7-8.3/input0, status -71
> [  571.981668] usb 1-8: clear tt 3 (0060) error -32
> [  571.997698] drivers/hid/usbhid/hid-core.c: can't reset device, 0000:00:1d.7-8.3/input0, status -71
> [  571.997782] usb 1-8: clear tt 3 (0060) error -32
> [  572.013568] drivers/hid/usbhid/hid-core.c: can't reset device, 0000:00:1d.7-8.3/input0, status -71
> [  572.013656] usb 1-8: clear tt 3 (0060) error -32
> [  572.029694] drivers/hid/usbhid/hid-core.c: can't reset device, 0000:00:1d.7-8.3/input0, status -71
> [  572.029783] usb 1-8: clear tt 3 (0060) error -32
> [  572.045696] drivers/hid/usbhid/hid-core.c: can't reset device, 0000:00:1d.7-8.3/input0, status -71
> [  572.045781] usb 1-8: clear tt 3 (0060) error -32
> [  572.061567] drivers/hid/usbhid/hid-core.c: can't reset device, 0000:00:1d.7-8.3/input0, status -71
> [  572.061655] usb 1-8: clear tt 3 (0060) error -32
> [  572.077698] drivers/hid/usbhid/hid-core.c: can't reset device, 0000:00:1d.7-8.3/input0, status -71
> [  572.077782] usb 1-8: clear tt 3 (0060) error -32
> [  572.088910] usb 1-8.3: USB disconnect, address 6
> [  572.267417] usb 1-8.3: new low speed USB device using ehci_hcd and address 7
> [  572.357781] usb 1-8.3: New USB device found, idVendor=045e, idProduct=0023
> [  572.357789] usb 1-8.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [  572.357796] usb 1-8.3: Product: Microsoft Trackball Optical®
> [  572.357802] usb 1-8.3: Manufacturer: Microsoft
> [  572.358075] usb 1-8.3: configuration #1 chosen from 1 choice
> [  572.365574] input: Microsoft Microsoft Trackball Optical® as /devices/pci0000:00/0000:00:1d.7/usb1/1-8/1-8.3/1-8.3:1.0/input/input9
> [  572.365829] generic-usb 0003:045E:0023.0002: input,hidraw0: USB HID v1.00 Mouse [Microsoft Microsoft Trackball Optical®] on usb-0000:00:1d.7-8.3/input0
> 
> The "can't reset device" is apparently new with mm-0716 - I've not seen it
> before in at least the 6 weeks my logs go back.

I don't think it is new.  You might try using an older kernel with your 
decaying trackball to see.

>  And it seems to be the
> beginning of things going pear-shaped, even though it manages to reset the
> device.

No it doesn't.  The device gets disconnected and reconnected.

>  A few seconds, the events thread whinges that not all is fine in USB
> land:
> 
> [  588.903158] usb 1-8.3: reset low speed USB device using ehci_hcd and address 7
> [  593.903075] ------------[ cut here ]------------
> [  593.903091] WARNING: at drivers/usb/host/ehci-hcd.c:906 ehci_urb_dequeue+0xa9/0x145()
> [  593.903098] Hardware name: Latitude D820                   
> [  593.903102] Modules linked in: ext4 jbd2 crc16 nvidia(P) [last unloaded: microcode]
> [  593.903127] Pid: 10, comm: events/0 Tainted: P           2.6.31-rc3-mmotm0716 #5
> [  593.903133] Call Trace:
> [  593.903147]  [<ffffffff8103f459>] warn_slowpath_common+0x77/0x8f
> [  593.903156]  [<ffffffff8103f480>] warn_slowpath_null+0xf/0x11
> [  593.903165]  [<ffffffff812d66cb>] ehci_urb_dequeue+0xa9/0x145
> [  593.903176]  [<ffffffff812c20f6>] unlink1+0xcd/0xe0
> [  593.903185]  [<ffffffff812c2279>] usb_hcd_unlink_urb+0x60/0x84
> [  593.903194]  [<ffffffff812c34d0>] usb_kill_urb+0x4f/0xc7
> [  593.903204]  [<ffffffff812c4ae4>] usb_start_wait_urb+0x9e/0xde
> [  593.903214]  [<ffffffff812c3b1d>] ? usb_init_urb+0x22/0x33
> [  593.903224]  [<ffffffff812c4dd1>] usb_control_msg+0x172/0x196
> [  593.903233]  [<ffffffff812be39b>] hub_port_init+0x348/0x71e
> [  593.903244]  [<ffffffff812be80e>] usb_reset_and_verify_device+0x9d/0x3f0
> [  593.903253]  [<ffffffff812c34a0>] ? usb_kill_urb+0x1f/0xc7
> [  593.903263]  [<ffffffff81034cb0>] ? get_parent_ip+0x11/0x42
> [  593.903273]  [<ffffffff81327812>] ? hid_cease_io+0x36/0x3b
> [  593.903282]  [<ffffffff812bebfa>] usb_reset_device+0x99/0x11c
> [  593.903291]  [<ffffffff8132808f>] ? hid_reset+0x0/0x128
> [  593.903299]  [<ffffffff8132812a>] hid_reset+0x9b/0x128
> [  593.903309]  [<ffffffff81051a48>] worker_thread+0x2ba/0x3e9
> [  593.903317]  [<ffffffff810519ef>] ? worker_thread+0x261/0x3e9
> [  593.903328]  [<ffffffff81056841>] ? autoremove_wake_function+0x0/0x34
> [  593.903337]  [<ffffffff8105178e>] ? worker_thread+0x0/0x3e9
> [  593.903346]  [<ffffffff81056433>] kthread+0x85/0x8d
> [  593.903357]  [<ffffffff8100c41a>] child_rip+0xa/0x20
> [  593.903367]  [<ffffffff8100bd80>] ? restore_args+0x0/0x30
> [  593.903377]  [<ffffffff810563ae>] ? kthread+0x0/0x8d
> [  593.903385]  [<ffffffff8100c410>] ? child_rip+0x0/0x20
> [  593.903391] ---[ end trace 816b51bf46b6656d ]---

This is a bug.  For more discussion see this thread:

	http://marc.info/?t=124807676700001&r=1&w=2

You should try the patch given there.

> And 2 minutes later, things are *still* not fine, and other things
> are hanging as well.  Since the 'events' thread is hung, both my mouse
> and keyboard are dead (though alt-sysrq kept working, since it does its
> magic behind 'events' back).

Try the patch and see if it fixes the hang.

Alan Stern


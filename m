Return-Path: <linux-kernel-owner+w=401wt.eu-S1757858AbXFNWrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858AbXFNWrt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 18:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754131AbXFNWrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 18:47:41 -0400
Received: from gw.goop.org ([64.81.55.164]:50253 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752961AbXFNWrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 18:47:40 -0400
Message-ID: <4671C588.8030507@goop.org>
Date: Thu, 14 Jun 2007 15:47:36 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, mdharm-usb@one-eyed-alien.net,
       linux-kernel@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
Subject: Re: 2.6.22-rc4-mm2 - usb-storage
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org> <1181230628.7348.266.camel@twins>
In-Reply-To: <1181230628.7348.266.camel@twins>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> My kernel went chatty when I tried to access my usb-stick; which it
> didn't seem to find.
>
>
> Initializing USB Mass Storage driver...
> scsi6 : SCSI emulation for USB Mass Storage devices
> usb-storage: device found at 2
> usb-storage: waiting for device to settle before scanning
> scsi7 : SCSI emulation for USB Mass Storage devices
> usb-storage: device found at 5
> usb-storage: waiting for device to settle before scanning
> usbcore: registered new interface driver usb-storage
> USB Mass Storage support registered.
> usb-storage: device scan complete
> WARNING: at /usr/src/linux-2.6/drivers/usb/core/urb.c:293
> usb_submit_urb()
>
> Call Trace:
>  [<ffffffff8020d4c7>] show_trace+0x34/0x4f
>  [<ffffffff8020d4f4>] dump_stack+0x12/0x17
>  [<ffffffff803cac6a>] usb_submit_urb+0x9f/0x226
>  [<ffffffff803cc4c7>] usb_sg_wait+0x56/0x132
>  [<ffffffff8820519d>] :usb_storage:usb_stor_bulk_transfer_sg+0x9d/0xf3
>  [<ffffffff88205313>] :usb_storage:usb_stor_Bulk_transport+0x120/0x244
>  [<ffffffff8820577f>] :usb_storage:usb_stor_invoke_transport+0x25/0x2d2
>  [<ffffffff882066c0>] :usb_storage:usb_stor_control_thread+0x14b/0x1e7
>  [<ffffffff8024a7df>] kthread+0x47/0x74
>  [<ffffffff8020cc28>] child_rip+0xa/0x12
>
> usb-storage: device scan complete
> WARNING: at /usr/src/linux-2.6/drivers/usb/core/urb.c:293
> usb_submit_urb()
>
> Call Trace:
>  [<ffffffff8020d4c7>] show_trace+0x34/0x4f
>  [<ffffffff8020d4f4>] dump_stack+0x12/0x17
>  [<ffffffff803cac6a>] usb_submit_urb+0x9f/0x226
>  [<ffffffff803cc4c7>] usb_sg_wait+0x56/0x132
>  [<ffffffff8820519d>] :usb_storage:usb_stor_bulk_transfer_sg+0x9d/0xf3
>  [<ffffffff88205313>] :usb_storage:usb_stor_Bulk_transport+0x120/0x244
>  [<ffffffff8820577f>] :usb_storage:usb_stor_invoke_transport+0x25/0x2d2
>  [<ffffffff882066c0>] :usb_storage:usb_stor_control_thread+0x14b/0x1e7
>  [<ffffffff8024a7df>] kthread+0x47/0x74
>  [<ffffffff8020cc28>] child_rip+0xa/0x12
>   

I got the same thing when I plugged my PSP in.

WARNING: at /home/jeremy/hg/xen/paravirt/linux/drivers/usb/core/urb.c:293 usb_submit_urb()
 [<c01091e2>] show_trace_log_lvl+0x1a/0x2f
 [<c0109cf2>] show_trace+0x12/0x14
 [<c0109d0a>] dump_stack+0x16/0x18
 [<c02dcaae>] usb_submit_urb+0x9f/0x205
 [<c02de178>] usb_sg_wait+0x4c/0x11c
 [<f8ddbfcd>] usb_stor_bulk_transfer_sg+0x8c/0xea [usb_storage]
 [<f8ddc433>] usb_stor_Bulk_transport+0x136/0x249 [usb_storage]
 [<f8ddc561>] usb_stor_invoke_transport+0x1b/0x292 [usb_storage]
 [<f8ddb82e>] usb_stor_ATAPI_command+0x24/0x26 [usb_storage]
 [<f8ddd310>] usb_stor_control_thread+0x129/0x1aa [usb_storage]
 [<c013cd87>] kthread+0x3b/0x64
 [<c0108da7>] kernel_thread_helper+0x7/0x10
 =======================

After this the USB subsystem seems dead.  For example, lsusb hangs in:

lsusb         D 0000017B  6304  6964   6507 (NOTLB)
       d8503ed4 00000082 199b6067 0000017b d8503ebc 00000000 22222222 d8502000 
       00000000 0000017b 00000000 c0127f83 d1cbcc90 d1cbce3c c2c09a40 da04cc45 
       00000960 00000046 00000001 c037d5f6 d716a1d4 d716a1c0 00266bc9 00000046 
Call Trace:
 [<c037d665>] __down+0xab/0xbf
 [<c037d432>] __down_failed+0xa/0x10
 [<c02e4611>] usbdev_read+0x5a/0x1f7
 [<c017d517>] vfs_read+0xad/0x136
 [<c017d94a>] sys_read+0x3d/0x61
 [<c0108046>] sysenter_past_esp+0x6b/0xb5



Thanks,
    J


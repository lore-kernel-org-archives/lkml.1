Return-Path: <linux-kernel-owner+w=401wt.eu-S937327AbXFGWUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937327AbXFGWUX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 18:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936766AbXFGWUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 18:20:09 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52028 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S935983AbXFGWUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 18:20:07 -0400
Date: Thu, 7 Jun 2007 18:20:06 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Peter Zijlstra <peterz@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, <mdharm-usb@one-eyed-alien.net>,
       <usb-storage@lists.one-eyed-alien.net>, <linux-kernel@vger.kernel.org>
Subject: Re: [usb-storage] 2.6.22-rc4-mm2 - usb-storage
In-Reply-To: <1181230628.7348.266.camel@twins>
Message-ID: <Pine.LNX.4.44L0.0706071815270.2676-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007, Peter Zijlstra wrote:

> My kernel went chatty when I tried to access my usb-stick; which it
> didn't seem to find.

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

This is false-alarm output from something intended to track down a 
reported bug.  The patch responsible is this one: 

http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm2/broken-out/usb-try-to-debug-bug-8561.patch

It was removed from -mm just recently; you can simply revert it in your 
kernel source.

Alan Stern


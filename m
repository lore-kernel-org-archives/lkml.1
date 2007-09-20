Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234AbXITUZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbXITUZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 16:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750985AbXITUZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 16:25:21 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48168 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750886AbXITUZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 16:25:20 -0400
Date: Thu, 20 Sep 2007 13:25:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tilman Schmidt <tilman@imap.cc>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: 2.6.23-rc6-mm1
Message-Id: <20070920132506.27195aaa.akpm@linux-foundation.org>
In-Reply-To: <46F2C7F8.3040409@imap.cc>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
	<46F1AA6E.1030708@imap.cc>
	<46F2C7F8.3040409@imap.cc>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2007 21:20:24 +0200
Tilman Schmidt <tilman@imap.cc> wrote:

> Another data point. When booting into runlevel 3, the system is usable,
> although these messages still appear after boot:
> 
> <4>[   22.731025] sysfs: duplicate filename 'bInterfaceNumber' can not be created
> <4>[   22.735872] WARNING: at fs/sysfs/dir.c:433 sysfs_add_one()
> <7>[   22.740737] bas_gigaset: <-------3: 0x11 (0 [0x00 0x00])
> <4>[   22.740881]  [dump_trace+100/498] dump_trace+0x64/0x1f2
> <7>[   22.745708] bas_gigaset: <-------3: 0x11 (0 [0x00 0x00])
> <4>[   22.745721]  [show_trace_log_lvl+26/47] show_trace_log_lvl+0x1a/0x2f
> <4>[   22.750533]  [show_trace+18/20] show_trace+0x12/0x14
> <4>[   22.755285]  [dump_stack+22/24] dump_stack+0x16/0x18
> <4>[   22.759997]  [sysfs_add_one+87/188] sysfs_add_one+0x57/0xbc
> <4>[   22.764633]  [sysfs_add_file+73/135] sysfs_add_file+0x49/0x87
> <4>[   22.769418]  [sysfs_create_group+138/240] sysfs_create_group+0x8a/0xf0
> <4>[   22.774014]  [<fa99c20a>] usb_create_sysfs_intf_files+0x2d/0xa2 [usbcore]
> <4>[   22.778659]  [<fa9989ed>] usb_set_configuration+0x450/0x48d [usbcore]
> <4>[   22.783246]  [<fa99fa9b>] generic_probe+0x53/0x94 [usbcore]
> <4>[   22.787895]  [<fa99a00b>] usb_probe_device+0x35/0x3b [usbcore]
> <4>[   22.792471]  [driver_probe_device+233/362] driver_probe_device+0xe9/0x16a
> <4>[   22.797214]  [__device_attach+8/10] __device_attach+0x8/0xa
> <4>[   22.801779]  [bus_for_each_drv+56/97] bus_for_each_drv+0x38/0x61
> <4>[   22.806344]  [device_attach+112/133] device_attach+0x70/0x85
> <4>[   22.810905]  [bus_attach_device+41/119] bus_attach_device+0x29/0x77
> <4>[   22.815468]  [device_add+795/1342] device_add+0x31b/0x53e
> <4>[   22.820052]  [<fa993de7>] usb_new_device+0x5c/0x168 [usbcore]
> <4>[   22.824653]  [<fa9954f9>] hub_thread+0x6b9/0xaa5 [usbcore]
> <4>[   22.829276]  [kthread+59/100] kthread+0x3b/0x64
> <4>[   22.833823]  [kernel_thread_helper+7/16] kernel_thread_helper+0x7/0x10
> <4>[   22.838409]  =======================

Yep, that looks like a USB bug.

> and a bit later:
> 
> Sep 20 20:54:36 xenon kernel: [   39.581898] hwinfo[5185]: segfault at b7cf9f10 eip b7cf9f10 esp bfefe20c error 4
> Sep 20 20:54:36 xenon kernel: [   39.586320] BUG: sleeping function called from invalid context at kernel/rwsem.c:47
> Sep 20 20:54:36 xenon kernel: [   39.590697] in_atomic():1, irqs_disabled():0
> Sep 20 20:54:36 xenon kernel: [   39.594987] no locks held by hwinfo/5185.
> Sep 20 20:54:36 xenon kernel: [   39.599281]  [<c0108441>] dump_trace+0x64/0x1f2
> Sep 20 20:54:36 xenon kernel: [   39.603577]  [<c01085e9>] show_trace_log_lvl+0x1a/0x2f
> Sep 20 20:54:36 xenon kernel: [   39.607851]  [<c010902b>] show_trace+0x12/0x14
> Sep 20 20:54:36 xenon kernel: [   39.612060]  [<c0109154>] dump_stack+0x16/0x18
> Sep 20 20:54:36 xenon kernel: [   39.616305]  [<c0123ecd>] __might_sleep+0xe5/0xeb
> Sep 20 20:54:36 xenon kernel: [   39.620545]  [<c013f72d>] down_write+0x18/0x54
> Sep 20 20:54:36 xenon kernel: [   39.624777]  [<c01890d7>] do_coredump+0x94/0x77d
> Sep 20 20:54:36 xenon kernel: [   39.629004]  [<c0135295>] get_signal_to_deliver+0x408/0x434
> Sep 20 20:54:36 xenon kernel: [   39.633252]  [<c010673a>] do_notify_resume+0x94/0x6a6
> Sep 20 20:54:36 xenon kernel: [   39.637554]  [<c01072e5>] work_notifysig+0x13/0x1a
> Sep 20 20:54:36 xenon kernel: [   39.641854]  [<b7cf9f10>] 0xb7cf9f10
>
> ...
>

There was a locking imbalance in the IPC code.  Do you have the fixes in
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc6/2.6.23-rc6-mm1/hot-fixes/
applied?

> As this seems to concern USB and sysfs, I guess Greg's the man?

Greg isn't the only USB developer ;)  linux-usb-devel cc added..

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758532AbXK0GGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758532AbXK0GGB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 01:06:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751795AbXK0GFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 01:05:54 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58234 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751635AbXK0GFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 01:05:53 -0500
Date: Mon, 26 Nov 2007 22:05:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Matthew Wilcox <matthew@wil.cx>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, linux-usb-devel@lists.sourceforge.net,
       linux-pm@lists.linux-foundation.org,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: WARNING: at kernel/resource.c:189 __release_resource
Message-Id: <20071126220538.1aed9c33.akpm@linux-foundation.org>
In-Reply-To: <4745F77C.7040402@gmail.com>
References: <4745F77C.7040402@gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Nov 2007 22:41:16 +0100 Jiri Slaby <jirislaby@gmail.com> wrote:

> Hi,
> 
> Step aside. What's the purpose of having two similar patches for one issue,
> it then warns about the same thing twice:
> make-sure-nobodys-leaking-resources.patch
> releasing-resources-with-children.patch

Oh well.  It's better than having none.  Matthew, could you have think
about something for mainline please?

> Ok, I hit the bug, suspend of 00:06 device complains about it:
> WARNING: at .../kernel/resource.c:185 __release_resource()
> 
> Call Trace:
>  [<ffffffff8023f7b5>] release_resource+0xb5/0xf0
>  [<ffffffff8036cda0>] pnp_release_resources+0x70/0x130
>  [<ffffffff8036db85>] pnp_stop_dev+0x45/0x90
>  [<ffffffff8036c942>] pnp_bus_suspend+0x92/0xb0
>  [<ffffffff803b9f73>] suspend_device+0x113/0x180
>  [<ffffffff803ba330>] device_suspend+0x200/0x320
>  [<ffffffff80266905>] suspend_devices_and_enter+0xa5/0x170
>  [<ffffffff80266bd9>] enter_state+0x209/0x270
>  [<ffffffff80266cef>] state_store+0xaf/0xf0
>  [<ffffffff8032ca67>] kobj_attr_store+0x17/0x20
>  [<ffffffff802e459e>] sysfs_write_file+0xce/0x140
>  [<ffffffff80299cc7>] vfs_write+0xc7/0x170
>  [<ffffffff8029a360>] sys_write+0x50/0x90
>  [<ffffffff8020bcde>] system_call+0x7e/0x83
> 
> # LANG=en ll /sys/devices/pnp0/00:06/
> total 0
> lrwxrwxrwx 1 root root    0 Nov 22 22:35 driver -> ../../../bus/pnp/drivers/serial
> -r--r--r-- 1 root root 4096 Nov 22 22:35 id
> -r--r--r-- 1 root root 4096 Nov 22 22:35 options
> drwxr-xr-x 2 root root    0 Nov 22 22:35 power
> -rw-r--r-- 1 root root 4096 Nov 22 22:35 resources
> lrwxrwxrwx 1 root root    0 Nov 22 22:35 subsystem -> ../../../bus/pnp
> drwxr-xr-x 3 root root    0 Nov 22 22:35 tty
> -rw-r--r-- 1 root root 4096 Nov 22 22:35 uevent
> 

I suppose that's a genuine leak, presumably in 8250_pnp.

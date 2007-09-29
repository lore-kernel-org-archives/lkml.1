Return-Path: <linux-kernel-owner+w=401wt.eu-S1757865AbXI2Pem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865AbXI2Pem (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 11:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754490AbXI2Pee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 11:34:34 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37547 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322AbXI2Ped (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 11:34:33 -0400
Date: Sat, 29 Sep 2007 08:19:42 -0700
From: Greg KH <greg@kroah.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: 2.6.23-rc8-mm2
Message-ID: <20070929151942.GE3653@kroah.com>
References: <20070927022220.c76a7a6e.akpm@linux-foundation.org> <a8e1da0709290237p593c57f1t6b6464dc27d0ab0a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0709290237p593c57f1t6b6464dc27d0ab0a@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 29, 2007 at 05:37:29PM +0800, Dave Young wrote:
> Hi,
> The kernel report warnings about sysfs filename duplicate under
> rc8-mm1 and rc8-mm2.
>  1.
> ----cut----
> NET: Registered protocol family 16
> ACPI: bus type pci registered
> PCI: PCI BIOS revision 2.10 entry at 0xfb93e, last bus=3
> PCI: Using configuration type 1
> Setting up standard PCI resources
> sysfs: duplicate filename 'usbcore' can not be created
> WARNING: at fs/sysfs/dir.c:433 sysfs_add_one()
>  [<c010528f>] dump_trace+0x1bf/0x1d0
>  [<c0105358>] show_trace_log_lvl+0x18/0x30
>  [<c010537f>] show_trace+0xf/0x20
>  [<c01054a2>] dump_stack+0x12/0x20
>  [<c01c6680>] sysfs_add_one+0xa0/0xe0
>  [<c01c69e8>] create_dir+0x48/0xb0
>  [<c01c6a99>] sysfs_create_dir+0x29/0x50
>  [<c02501eb>] create_dir+0x1b/0x50
>  [<c02504b6>] kobject_add+0x46/0x150
>  [<c05a38a0>] kernel_param_sysfs_setup+0x50/0xb0
>  [<c05a39ee>] param_sysfs_builtin+0xee/0x130
>  [<c05a3a54>] param_sysfs_init+0x24/0x60
>  [<c0592866>] do_initcalls+0x46/0x1e0
>  [<c0592aa2>] kernel_init+0x62/0xb0
>  [<c0104fb3>] kernel_thread_helper+0x7/0x14
>  =======================
> kobject_add failed for usbcore with -EEXIST, don't try to register
> things with the same name in the same directory.

That is very wierd, do you have both USB built in and as a module
somehow?

>  [<c010528f>] dump_trace+0x1bf/0x1d0
>  [<c0105358>] show_trace_log_lvl+0x18/0x30
>  [<c010537f>] show_trace+0xf/0x20
>  [<c01054a2>] dump_stack+0x12/0x20
>  [<c0250566>] kobject_add+0xf6/0x150
>  [<c05a38a0>] kernel_param_sysfs_setup+0x50/0xb0
>  [<c05a39ee>] param_sysfs_builtin+0xee/0x130
>  [<c05a3a54>] param_sysfs_init+0x24/0x60
>  [<c0592866>] do_initcalls+0x46/0x1e0
>  [<c0592aa2>] kernel_init+0x62/0xb0
>  [<c0104fb3>] kernel_thread_helper+0x7/0x14
>  =======================
> Module 'usbcore' failed to be added to sysfs, error number -17

I think I need to clean up the double stack trace here, that's reall not
needed :)

thanks,

greg k-h

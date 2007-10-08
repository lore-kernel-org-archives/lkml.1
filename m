Return-Path: <linux-kernel-owner+w=401wt.eu-S1754421AbXJHGnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbXJHGnV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 02:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbXJHGnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 02:43:14 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:37029 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbXJHGnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 02:43:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Pwp/91n7+WM5h9esh9XyP7uBv9cwZSDqDkWQWIDxSQl8WMC/TOZu/YcT9O1ndgVNbUDH+ePeD/zLhbtK4XEmExlhwRwwkhQBUxFIpihjY2TO2YQjmjOt/9c3G0VrdE8x/9VcQnNkc9e7+XWCwhO/4vN50S7/tO+paIHdfCpPqb4=
Message-ID: <a8e1da0710072343h2addc01eh911bdcf5c81985df@mail.gmail.com>
Date: Mon, 8 Oct 2007 14:43:12 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: 2.6.23-rc8-mm2
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
In-Reply-To: <20070929151942.GE3653@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070927022220.c76a7a6e.akpm@linux-foundation.org>
	 <a8e1da0709290237p593c57f1t6b6464dc27d0ab0a@mail.gmail.com>
	 <20070929151942.GE3653@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/29/07, Greg KH <greg@kroah.com> wrote:
> On Sat, Sep 29, 2007 at 05:37:29PM +0800, Dave Young wrote:
> > Hi,
> > The kernel report warnings about sysfs filename duplicate under
> > rc8-mm1 and rc8-mm2.
> >  1.
> > ----cut----
> > NET: Registered protocol family 16
> > ACPI: bus type pci registered
> > PCI: PCI BIOS revision 2.10 entry at 0xfb93e, last bus=3
> > PCI: Using configuration type 1
> > Setting up standard PCI resources
> > sysfs: duplicate filename 'usbcore' can not be created
> > WARNING: at fs/sysfs/dir.c:433 sysfs_add_one()
> >  [<c010528f>] dump_trace+0x1bf/0x1d0
> >  [<c0105358>] show_trace_log_lvl+0x18/0x30
> >  [<c010537f>] show_trace+0xf/0x20
> >  [<c01054a2>] dump_stack+0x12/0x20
> >  [<c01c6680>] sysfs_add_one+0xa0/0xe0
> >  [<c01c69e8>] create_dir+0x48/0xb0
> >  [<c01c6a99>] sysfs_create_dir+0x29/0x50
> >  [<c02501eb>] create_dir+0x1b/0x50
> >  [<c02504b6>] kobject_add+0x46/0x150
> >  [<c05a38a0>] kernel_param_sysfs_setup+0x50/0xb0
> >  [<c05a39ee>] param_sysfs_builtin+0xee/0x130
> >  [<c05a3a54>] param_sysfs_init+0x24/0x60
> >  [<c0592866>] do_initcalls+0x46/0x1e0
> >  [<c0592aa2>] kernel_init+0x62/0xb0
> >  [<c0104fb3>] kernel_thread_helper+0x7/0x14
> >  =======================
> > kobject_add failed for usbcore with -EEXIST, don't try to register
> > things with the same name in the same directory.
>
> That is very wierd, do you have both USB built in and as a module
> somehow?
>
> >  [<c010528f>] dump_trace+0x1bf/0x1d0
> >  [<c0105358>] show_trace_log_lvl+0x18/0x30
> >  [<c010537f>] show_trace+0xf/0x20
> >  [<c01054a2>] dump_stack+0x12/0x20
> >  [<c0250566>] kobject_add+0xf6/0x150
> >  [<c05a38a0>] kernel_param_sysfs_setup+0x50/0xb0
> >  [<c05a39ee>] param_sysfs_builtin+0xee/0x130
> >  [<c05a3a54>] param_sysfs_init+0x24/0x60
> >  [<c0592866>] do_initcalls+0x46/0x1e0
> >  [<c0592aa2>] kernel_init+0x62/0xb0
> >  [<c0104fb3>] kernel_thread_helper+0x7/0x14
> >  =======================
> > Module 'usbcore' failed to be added to sysfs, error number -17
>
> I think I need to clean up the double stack trace here, that's reall not
> needed :)
>
Hi,
I debugged the problem, found that it is a bug of kernel/params.c, I
will send a patch later to fix it.

Regards
dave

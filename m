Return-Path: <linux-kernel-owner+w=401wt.eu-S934598AbXKPAzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934598AbXKPAzi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 19:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764901AbXKPAz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 19:55:26 -0500
Received: from wr-out-0506.google.com ([64.233.184.232]:51450 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761651AbXKPAzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 19:55:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=t2pmA2wtBVcPornfZv96rH4Z/LVFZEu4GxEGaB3R66JaQA8WTvpnRTa+WtEY9PfojpRd0dXxqsFKqOcPiOC20ZyvauW7aOjXoP7QKM9UIwZDdgh7JWgj91Um1E1UYbBQ7xUBYornpKHOCpzOCAS1T1XQqOCfkvuwE8NKXS23sC0=
Message-ID: <a8e1da0711151655s566b964ayc10ca53c238ae06f@mail.gmail.com>
Date: Fri, 16 Nov 2007 08:55:23 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: 2.6.24-rc2-mm1
Cc: "Jiri Kosina" <jikos@jikos.cz>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071116004947.GA24887@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0711141728290.15844@twin.jikos.cz>
	 <20071114083906.178232cb.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0711141740110.15844@twin.jikos.cz>
	 <Pine.LNX.4.64.0711141758570.15844@twin.jikos.cz>
	 <20071114181948.GA15240@kroah.com> <20071115192319.GA30186@kroah.com>
	 <a8e1da0711151639q4be735d2kc8af9d2b5584d1ee@mail.gmail.com>
	 <20071116004947.GA24887@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 16, 2007 8:49 AM, Greg KH <greg@kroah.com> wrote:
>
> On Fri, Nov 16, 2007 at 08:39:12AM +0800, Dave Young wrote:
> > On Nov 16, 2007 3:23 AM, Greg KH <greg@kroah.com> wrote:
> > >
> > > On Wed, Nov 14, 2007 at 10:19:48AM -0800, Greg KH wrote:
> > > > On Wed, Nov 14, 2007 at 06:02:07PM +0100, Jiri Kosina wrote:
> > > > > On Wed, 14 Nov 2007, Jiri Kosina wrote:
> > > > >
> > > > > > > I'd suspect the driver tree.  I think I'll need to do a quick -mm2
> > > > > > > without that tree present.
> > > > > > I am just verifying whether reverting kset changes fixes this, will let
> > > > > > you know soon.
> > > > >
> > > > > OK, so I reverted
> > > > > gregkh-driver-kset-convert-block_subsys-to-use-kset_create (which made me
> > > > > also revert gregkh-driver-kobject-remove-subsystem_register-functions and
> > > > > gregkh-driver-kset-remove-decl_subsys-macro so that we compile). Both the
> > > > > error message from lockdep and more importantly the spinlock lockup have
> > > > > gone, and the system with these patches reverted boots for me fine.
> > > > >
> > > > > Well not that fine, I still see (which is the same backtrace that caused
> > > > > the lockup with plain -rc2-mm1, but doesn't make the machine hang):
> > > > >
> > > > > floppy0: Floppy io-port 0x03f2 in use
> > > > > WARNING: at lib/kref.c:33 kref_get()
> > > > >
> > > > > Call Trace:
> > > > >  [<ffffffff8035bd43>] kobject_add+0x9b/0x197
> > > > >  [<ffffffff8035c6e1>] kref_get+0x2f/0x36
> > > > >  [<ffffffff8035b82f>] kobject_get+0x12/0x17
> > > > >  [<ffffffff8035bd55>] kobject_add+0xad/0x197
> > > > >  [<ffffffff802c9a36>] register_disk+0x48/0x205
> > > > >  [<ffffffff80355cf3>] add_disk+0x34/0x3d
> > > > >  [<ffffffff8083cd99>] rd_init+0x172/0x1e1
> > > > >  [<ffffffff8082063a>] kernel_init+0x175/0x2e6
> > > > >  [<ffffffff8025193c>] trace_hardirqs_on+0x115/0x139
> > > > >  [<ffffffff80598769>] trace_hardirqs_on_thunk+0x35/0x3a
> > > > >  [<ffffffff8025193c>] trace_hardirqs_on+0x115/0x139
> > > > >  [<ffffffff8020c628>] child_rip+0xa/0x12
> > > > >  [<ffffffff8020bd3f>] restore_args+0x0/0x30
> > > > >  [<ffffffff808204c5>] kernel_init+0x0/0x2e6
> > > > >  [<ffffffff8020c61e>] child_rip+0x0/0x12
> > > >
> > > > someone is trying to call kref_get on a kobject that has not been
> > > > initialized yet, which could be the reason the newer patches break
> > > > something, as the pointers are not set up properly with a call to
> > > > kobject_init() first.
> > > >
> > > > But, alloc_disk() should have been called on this gendisk for it to work
> > > > properly at all, unless something is trashing that structure?
> > > >
> > > > I'm way confused...
> > >
> > > This patch, as found by Dave Young, should fix the issue:
> > >
> > > I'll roll it into my larger patchset so that Andrew will get it
> > > automatically next release, but here it is for people to use now.
> > >
> > > thanks,
> > >
> > > greg k-h
> > >
> > > --------------
> > >
> > > From: Greg Kroah-Hartman <gregkh@suse.de>
> > > Subject: fix bug with adding new block devices in -mm
> > >
> > > need to set the kset before initializing the kobject.
> > >
> > >
> > > ---
> > >  block/genhd.c |    2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > --- a/block/genhd.c
> > > +++ b/block/genhd.c
> > > @@ -718,9 +718,9 @@ struct gendisk *alloc_disk_node(int mino
> > >                         }
> > >                 }
> > >                 disk->minors = minors;
> > > -               kobject_init(&disk->kobj);
> > >                 disk->kobj.kset = block_kset;
> > >                 disk->kobj.ktype = &ktype_block;
> > > +               kobject_init(&disk->kobj);
> > >                 rand_initialize_disk(disk);
> > >                 INIT_WORK(&disk->async_notify,
> > >                         media_change_notify_thread);
> > >
> > > -
> > Hi,
> > Could you please add signed-off by me?
> >
> > Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
>
> Sure, but I've modified the original patch to not include this bug in
> the first place, so there's really not much to sign off on there, sorry.
>
> I will add your name as helping out with it, if that's ok.
>
Ok,  thanks.

Regards
dave

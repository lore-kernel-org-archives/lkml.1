Return-Path: <linux-kernel-owner+w=401wt.eu-S1758032AbXKNRGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032AbXKNRGP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 12:06:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754911AbXKNRF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 12:05:59 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:59583 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892AbXKNRF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 12:05:58 -0500
Date: Wed, 14 Nov 2007 08:59:06 -0800
From: Greg KH <greg@kroah.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: 2.6.24-rc2-mm1
Message-ID: <20071114165906.GB13889@kroah.com>
References: <20071113175906.497a1a6a.akpm@linux-foundation.org> <a8e1da0711132218h9d944d0p3c22ac313ee667a9@mail.gmail.com> <20071113223802.2ace1a61.akpm@linux-foundation.org> <a8e1da0711132247jd440f8dgc9ac0442e90f2c34@mail.gmail.com> <20071114004129.783fb98b.akpm@linux-foundation.org> <a8e1da0711140136i1e441371j306e7b2888de104e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0711140136i1e441371j306e7b2888de104e@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 05:36:48PM +0800, Dave Young wrote:
> On Nov 14, 2007 4:41 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > On Wed, 14 Nov 2007 14:47:38 +0800 "Dave Young" <hidave.darkstar@gmail.com> wrote:
> >
> > > On Nov 14, 2007 2:38 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > >
> > > > On Wed, 14 Nov 2007 14:18:39 +0800 "Dave Young" <hidave.darkstar@gmail.com> wrote:
> > > >
> > > > > Hi,
> > > > > Boot failed on my machine. hand copy some messages.
> > > > >
> > > > > First with BLK_DEV_RAM=y
> > > > >
> > > > > BUG kmalloc-64 Poison overwritting:
> > > > > Alloced in kset_create
> > > > > Freed in kobject_cleanup
> > > > >
> > > > > --cut--
> > > > > alloc_disk_node
> > > > > rd_init
> > > > > kernel_init
> > > > > --cut--
> > > > >
> > > > > Then config ramdisk as module, build and reboot:
> > > > >
> > > > > BUG: unable handle paging resuest at 6b6b6b6b
> > > > > EIP is kobject_add 0xc4/0x150
> > > > >
> > > > > --cut--
> > > > > kobject_set_name
> > > > > register_disk
> > > > > add_disk
> > > > > exact_match
> > > > > exact_lock
> > > > > loop_init
> > > > > --cut--
> > > > >
> > > >
> > > > erp.  Can you send the config over please?
> > > >
> > > > And which distro/version is that machine running?
> > > >
> > >
> > > Hi,andrew
> > >
> > > slackware 11
> > >
> > > config as follows:
> > > #
> > > # Automatically generated make config: don't edit
> > > # Linux kernel version: 2.6.24-rc2-mm1
> > > # Wed Nov 14 13:50:01 2007
> > > #
> >
> > OK, I can reproduce that on the Vaio, thanks.
> >
> > oops: http://userweb.kernel.org/~akpm/dsc00037.jpg
> > config: (what you sent)
> > dmesg: http://userweb.kernel.org/~akpm/dmesg-sony.txt
> >
> > An inspired guess led me to suspect the driver tree.  The offending patch
> > is gregkh-driver-kset-convert-block_subsys-to-use-kset_create.patch.
> >
> Hi,
> I do some printk debug, the problem hide in the kobject.c line 256 in
> kobject_add
> seems  at
> list_add_tail(&kobj->entry,&kobj->kset->list);

That's just wierd.  I'll try to figure this out...

Kay, any thoughts, I can use any hint anyone has here :)

thanks,

greg k-h

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754732AbXKNImU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbXKNImU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 03:42:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbXKNImL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 03:42:11 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47678 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751796AbXKNImK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 03:42:10 -0500
Date: Wed, 14 Nov 2007 00:41:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Dave Young" <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: 2.6.24-rc2-mm1
Message-Id: <20071114004129.783fb98b.akpm@linux-foundation.org>
In-Reply-To: <a8e1da0711132247jd440f8dgc9ac0442e90f2c34@mail.gmail.com>
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>
	<a8e1da0711132218h9d944d0p3c22ac313ee667a9@mail.gmail.com>
	<20071113223802.2ace1a61.akpm@linux-foundation.org>
	<a8e1da0711132247jd440f8dgc9ac0442e90f2c34@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2007 14:47:38 +0800 "Dave Young" <hidave.darkstar@gmail.com> wrote:

> On Nov 14, 2007 2:38 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > On Wed, 14 Nov 2007 14:18:39 +0800 "Dave Young" <hidave.darkstar@gmail.com> wrote:
> >
> > > Hi,
> > > Boot failed on my machine. hand copy some messages.
> > >
> > > First with BLK_DEV_RAM=y
> > >
> > > BUG kmalloc-64 Poison overwritting:
> > > Alloced in kset_create
> > > Freed in kobject_cleanup
> > >
> > > --cut--
> > > alloc_disk_node
> > > rd_init
> > > kernel_init
> > > --cut--
> > >
> > > Then config ramdisk as module, build and reboot:
> > >
> > > BUG: unable handle paging resuest at 6b6b6b6b
> > > EIP is kobject_add 0xc4/0x150
> > >
> > > --cut--
> > > kobject_set_name
> > > register_disk
> > > add_disk
> > > exact_match
> > > exact_lock
> > > loop_init
> > > --cut--
> > >
> >
> > erp.  Can you send the config over please?
> >
> > And which distro/version is that machine running?
> >
> 
> Hi,andrew
> 
> slackware 11
> 
> config as follows:
> #
> # Automatically generated make config: don't edit
> # Linux kernel version: 2.6.24-rc2-mm1
> # Wed Nov 14 13:50:01 2007
> #

OK, I can reproduce that on the Vaio, thanks.

oops: http://userweb.kernel.org/~akpm/dsc00037.jpg
config: (what you sent)
dmesg: http://userweb.kernel.org/~akpm/dmesg-sony.txt

An inspired guess led me to suspect the driver tree.  The offending patch
is gregkh-driver-kset-convert-block_subsys-to-use-kset_create.patch.

There's some kobject warning which comes out when
gregkh-driver-kset-convert-block_subsys-to-use-kset_create.patch isn't
applied.  More bisecting coming up..


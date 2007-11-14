Return-Path: <linux-kernel-owner+w=401wt.eu-S1756088AbXKNJg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbXKNJg5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 04:36:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbXKNJgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 04:36:50 -0500
Received: from wr-out-0506.google.com ([64.233.184.227]:21546 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbXKNJgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 04:36:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Vf4hy2ub9Sh5MkDrM/9IBryLVlucrRId0aVDY9bFYV4VmgE9gSUq9Ri22FjMiT8hn6JLT/5e1r3Pxrc55gkfsCoqwztJG/A0sUYC63EQB2etFf5PrGJkT7/cDtjiOzicILS7Sdtcv1xEHaY1kp9UtBv7ZyPmEPnCXLjRkNldbDs=
Message-ID: <a8e1da0711140136i1e441371j306e7b2888de104e@mail.gmail.com>
Date: Wed, 14 Nov 2007 17:36:48 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc2-mm1
Cc: linux-kernel@vger.kernel.org, "Greg KH" <greg@kroah.com>,
       "Kay Sievers" <kay.sievers@vrfy.org>
In-Reply-To: <20071114004129.783fb98b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>
	 <a8e1da0711132218h9d944d0p3c22ac313ee667a9@mail.gmail.com>
	 <20071113223802.2ace1a61.akpm@linux-foundation.org>
	 <a8e1da0711132247jd440f8dgc9ac0442e90f2c34@mail.gmail.com>
	 <20071114004129.783fb98b.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 14, 2007 4:41 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Wed, 14 Nov 2007 14:47:38 +0800 "Dave Young" <hidave.darkstar@gmail.com> wrote:
>
> > On Nov 14, 2007 2:38 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > >
> > > On Wed, 14 Nov 2007 14:18:39 +0800 "Dave Young" <hidave.darkstar@gmail.com> wrote:
> > >
> > > > Hi,
> > > > Boot failed on my machine. hand copy some messages.
> > > >
> > > > First with BLK_DEV_RAM=y
> > > >
> > > > BUG kmalloc-64 Poison overwritting:
> > > > Alloced in kset_create
> > > > Freed in kobject_cleanup
> > > >
> > > > --cut--
> > > > alloc_disk_node
> > > > rd_init
> > > > kernel_init
> > > > --cut--
> > > >
> > > > Then config ramdisk as module, build and reboot:
> > > >
> > > > BUG: unable handle paging resuest at 6b6b6b6b
> > > > EIP is kobject_add 0xc4/0x150
> > > >
> > > > --cut--
> > > > kobject_set_name
> > > > register_disk
> > > > add_disk
> > > > exact_match
> > > > exact_lock
> > > > loop_init
> > > > --cut--
> > > >
> > >
> > > erp.  Can you send the config over please?
> > >
> > > And which distro/version is that machine running?
> > >
> >
> > Hi,andrew
> >
> > slackware 11
> >
> > config as follows:
> > #
> > # Automatically generated make config: don't edit
> > # Linux kernel version: 2.6.24-rc2-mm1
> > # Wed Nov 14 13:50:01 2007
> > #
>
> OK, I can reproduce that on the Vaio, thanks.
>
> oops: http://userweb.kernel.org/~akpm/dsc00037.jpg
> config: (what you sent)
> dmesg: http://userweb.kernel.org/~akpm/dmesg-sony.txt
>
> An inspired guess led me to suspect the driver tree.  The offending patch
> is gregkh-driver-kset-convert-block_subsys-to-use-kset_create.patch.
>
Hi,
I do some printk debug, the problem hide in the kobject.c line 256 in
kobject_add
seems  at
list_add_tail(&kobj->entry,&kobj->kset->list);

Regards
dave

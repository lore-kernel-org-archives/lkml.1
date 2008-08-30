Return-Path: <linux-kernel-owner+w=401wt.eu-S1755736AbYH3SP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736AbYH3SP0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 14:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbYH3SPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 14:15:15 -0400
Received: from aun.it.uu.se ([130.238.12.36]:36626 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069AbYH3SPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 14:15:14 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18617.35916.80075.481108@harpo.it.uu.se>
Date: Sat, 30 Aug 2008 20:07:08 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Greg KH <gregkh@suse.de>
Cc: Mikael Pettersson <mikpe@it.uu.se>, fujita.tomonori@lab.ntt.co.jp,
       dwmw2@infradead.org, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION 2.6.27-rc4-git7] mtd broken by cmdfilter move
In-Reply-To: <20080830172024.GB12414@suse.de>
References: <200808301704.m7UH48Bn019083@harpo.it.uu.se>
	<20080830172024.GB12414@suse.de>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH writes:
 > > --- linux-2.6.27-rc4-git6/block/cmd-filter.c.~1~	2008-08-30 17:08:58.000000000 +0200
 > > +++ linux-2.6.27-rc4-git6/block/cmd-filter.c	2008-08-30 17:36:36.000000000 +0200
 > > @@ -215,6 +215,13 @@ int blk_register_filter(struct gendisk *
 > >  	if (!parent)
 > >  		return -ENODEV;
 > >  
 > > +	printk("%s: disk %p queue %p filter %p &filter->kobj %p\n",
 > > +	       __func__, disk, disk->queue, filter, &filter->kobj);
 > > +	if (filter->kobj.state_initialized) {
 > > +		printk("%s: kobj %p already inited, bailing out\n",
 > > +		       __func__, &filter->kobj);
 > > +		return 0;
 > > +	}
 > 
 > Ick, no, don't go poking into the internals of a kobject like this to
 > fix this kind of problem.  If you really don't know if you have
 > initialized this kobject or not, then you will have reference counting
 > problems, which need to be fixed for real.

This was a debug patch, I wasn't suggesting it as "the" fix.

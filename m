Return-Path: <linux-kernel-owner+w=401wt.eu-S932452AbYASPwG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932452AbYASPwG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 10:52:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759343AbYASPvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 10:51:55 -0500
Received: from waste.org ([66.93.16.53]:37531 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755126AbYASPvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 10:51:55 -0500
Subject: Re: [PATCH -v6 2/2] Updating ctime and mtime for memory-mapped
	files
From: Matt Mackall <mpm@selenic.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: riel@redhat.com, torvalds@linux-foundation.org, ioe-lkml@rameria.de,
       peterz@infradead.org, salikhmetov@gmail.com, linux-mm@kvack.org,
       jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, ksm@42.dk, staubach@redhat.com,
       jesper.juhl@gmail.com, akpm@linux-foundation.org, protasnb@gmail.com,
       r.e.wolff@bitwizard.nl, hidave.darkstar@gmail.com, hch@infradead.org
In-Reply-To: <E1JGAqW-0002Ia-UD@pomaz-ex.szeredi.hu>
References: <12006091182260-git-send-email-salikhmetov@gmail.com>
	 <E1JFwnQ-0001FB-2c@pomaz-ex.szeredi.hu>
	 <alpine.LFD.1.00.0801181127000.2957@woody.linux-foundation.org>
	 <200801182332.02945.ioe-lkml@rameria.de>
	 <alpine.LFD.1.00.0801181439330.2957@woody.linux-foundation.org>
	 <20080118175450.715ded60@bree.surriel.com>
	 <1200703803.25782.45.camel@cinder.waste.org>
	 <E1JGAqW-0002Ia-UD@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Date: Sat, 19 Jan 2008 09:49:57 -0600
Message-Id: <1200757797.25782.111.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-01-19 at 11:22 +0100, Miklos Szeredi wrote:
> > Reminds me, I've got a patch here for addressing that problem with loop mounts:
> > 
> > Writes to loop should update the mtime of the underlying file.
> > 
> > Signed-off-by: Matt Mackall <mpm@selenic.com>
> > 
> > Index: l/drivers/block/loop.c
> > ===================================================================
> > --- l.orig/drivers/block/loop.c	2007-11-05 17:50:07.000000000 -0600
> > +++ l/drivers/block/loop.c	2007-11-05 19:03:51.000000000 -0600
> > @@ -221,6 +221,7 @@ static int do_lo_send_aops(struct loop_d
> >  	offset = pos & ((pgoff_t)PAGE_CACHE_SIZE - 1);
> >  	bv_offs = bvec->bv_offset;
> >  	len = bvec->bv_len;
> > +	file_update_time(file);
> >  	while (len > 0) {
> >  		sector_t IV;
> >  		unsigned size;
> > @@ -299,6 +300,7 @@ static int __do_lo_send_write(struct fil
> >  
> >  	set_fs(get_ds());
> >  	bw = file->f_op->write(file, buf, len, &pos);
> > +	file_update_time(file);
> 
> ->write should have already updated the times, no?

Yes, this second case is redundant. Still needed in the first case.

-- 
Mathematics is the supreme nostalgia of our time.


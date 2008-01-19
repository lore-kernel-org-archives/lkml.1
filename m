Return-Path: <linux-kernel-owner+w=401wt.eu-S1757206AbYASKXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206AbYASKXQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 05:23:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752902AbYASKW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 05:22:59 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:49199 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbYASKW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 05:22:58 -0500
To: mpm@selenic.com
CC: riel@redhat.com, torvalds@linux-foundation.org, ioe-lkml@rameria.de,
       miklos@szeredi.hu, peterz@infradead.org, salikhmetov@gmail.com,
       linux-mm@kvack.org, jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, ksm@42.dk, staubach@redhat.com,
       jesper.juhl@gmail.com, akpm@linux-foundation.org, protasnb@gmail.com,
       r.e.wolff@bitwizard.nl, hidave.darkstar@gmail.com, hch@infradead.org
In-reply-to: <1200703803.25782.45.camel@cinder.waste.org> (message from Matt
	Mackall on Fri, 18 Jan 2008 18:50:03 -0600)
Subject: Re: [PATCH -v6 2/2] Updating ctime and mtime for memory-mapped
	files
References: <12006091182260-git-send-email-salikhmetov@gmail.com>
	 <E1JFwnQ-0001FB-2c@pomaz-ex.szeredi.hu>
	 <alpine.LFD.1.00.0801181127000.2957@woody.linux-foundation.org>
	 <200801182332.02945.ioe-lkml@rameria.de>
	 <alpine.LFD.1.00.0801181439330.2957@woody.linux-foundation.org>
	 <20080118175450.715ded60@bree.surriel.com> <1200703803.25782.45.camel@cinder.waste.org>
Message-Id: <E1JGAqW-0002Ia-UD@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sat, 19 Jan 2008 11:22:40 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Reminds me, I've got a patch here for addressing that problem with loop mounts:
> 
> Writes to loop should update the mtime of the underlying file.
> 
> Signed-off-by: Matt Mackall <mpm@selenic.com>
> 
> Index: l/drivers/block/loop.c
> ===================================================================
> --- l.orig/drivers/block/loop.c	2007-11-05 17:50:07.000000000 -0600
> +++ l/drivers/block/loop.c	2007-11-05 19:03:51.000000000 -0600
> @@ -221,6 +221,7 @@ static int do_lo_send_aops(struct loop_d
>  	offset = pos & ((pgoff_t)PAGE_CACHE_SIZE - 1);
>  	bv_offs = bvec->bv_offset;
>  	len = bvec->bv_len;
> +	file_update_time(file);
>  	while (len > 0) {
>  		sector_t IV;
>  		unsigned size;
> @@ -299,6 +300,7 @@ static int __do_lo_send_write(struct fil
>  
>  	set_fs(get_ds());
>  	bw = file->f_op->write(file, buf, len, &pos);
> +	file_update_time(file);

->write should have already updated the times, no?

>  	set_fs(old_fs);
>  	if (likely(bw == len))
>  		return 0;
> 
> 

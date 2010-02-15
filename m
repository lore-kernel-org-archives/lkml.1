Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761Ab0BOPcV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 10:32:21 -0500
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:43968 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755588Ab0BOPcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 10:32:20 -0500
Subject: Re: [PATCH] cfq: reorder cfq_queue removing padding on 64bit &
 allowing more objects/slab in it's kmem_cache
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Corrado Zoccolo <czoccolo@gmail.com>,
       Jeff Moyer <jmoyer@redhat.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20100215141626.GB5355@redhat.com>
References: <1266243036.2149.21.camel@localhost>
	 <20100215141626.GB5355@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Feb 2010 15:32:18 +0000
Message-ID: <1266247938.7362.0.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-15 at 09:16 -0500, Vivek Goyal wrote:
> On Mon, Feb 15, 2010 at 02:10:36PM +0000, Richard Kennedy wrote:
> > This removes 8 bytes of padding from struct cfq_queue on 64 bit builds,
> > shrinking it's size to 256 bytes, so fitting into 1 fewer cachelines and
> > allowing 1 more object/slab in it's kmem_cache.
> >  
> > 
> > Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
> > ----
> > patch against 2.6.33-rc8
> > tested on x86_64 AMDX2
> > 
> > regards
> > Richard
> > 
> > 
> > diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> > index 023f4e6..db4c127 100644
> > --- a/block/cfq-iosched.c
> > +++ b/block/cfq-iosched.c
> > @@ -116,10 +116,10 @@ struct cfq_queue {
> >  	unsigned long dispatch_start;
> >  	unsigned int allocated_slice;
> >  	/* time when first request from queue completed and slice started. */
> > +	unsigned int slice_dispatch;
> 
> Can you move it above the comment. The comment describes "slice_start" and
> now comment and variable have been separated.
> 
> Vivek
Sure, no problem. I'll send out a new version.
Richard


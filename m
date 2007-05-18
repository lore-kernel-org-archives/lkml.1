Return-Path: <linux-kernel-owner+w=401wt.eu-S1759733AbXERHf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759733AbXERHf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 03:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754876AbXERHfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 03:35:22 -0400
Received: from brick.kernel.dk ([80.160.20.94]:20772 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754798AbXERHfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 03:35:21 -0400
Date: Fri, 18 May 2007 09:33:33 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Badari Pulavarty <pbadari@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, bhalevy@panasas.com,
       Andrew Morton <akpm@linux-foundation.org>,
       fujita.tomonori@lab.ntt.co.jp, michaelc@cs.wisc.edu
Subject: Re: [PATCH] Chaining sg lists for big IO commands v5
Message-ID: <20070518073331.GC23798@kernel.dk>
References: <20070511135108.GF4629@kernel.dk> <1179249337.2836.110.camel@dyn9047017100.beaverton.ibm.com> <20070515172001.GB23798@kernel.dk> <1179251020.2836.118.camel@dyn9047017100.beaverton.ibm.com> <20070515175025.GE23798@kernel.dk> <1179349294.16195.6.camel@dyn9047017100.beaverton.ibm.com> <20070517062742.GW23798@kernel.dk> <1179414662.23725.3.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179414662.23725.3.camel@dyn9047017100.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17 2007, Badari Pulavarty wrote:
> On Thu, 2007-05-17 at 08:27 +0200, Jens Axboe wrote:
> .. 
> > > > 
> > > > Ah ok, you need the updated patch series for ppc64 support. Builds fine
> > > > here on ppc64. See the #sglist branch of the block repo:
> > > > 
> > > > git://git.kernel.dk/data/git/linux-2.6-block.git
> > > > 
> > > > I can mail you an updated patch, if you want.
> > > 
> > > 
> > > Here is the whole panic stack..
> > 
> > Thanks will fix that up, the IDE part is totally untested. Can you try
> > and backout this patch and see if it boots?
> 
> Yes. It boots fine with following backed out.
> 
> Looking at the code ide_probe.c: hwif_init() is doing
> 
>         hwif->sg_table = kmalloc(sizeof(struct scatterlist)*hwif->sg_max_nents,
>                                  GFP_KERNEL);
> 
> blk_rq_map_sg() is looking for the chaining info and going over end of the
> allocation.

Hmm, looks ok, I'm guessing it's just missing a memset (or just turn it
into a kzalloc())?

-- 
Jens Axboe


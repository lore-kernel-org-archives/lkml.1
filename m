Return-Path: <linux-kernel-owner+w=401wt.eu-S1755907AbXERRtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbXERRtw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 13:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758615AbXERRtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 13:49:33 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:55540 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758509AbXERRtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 13:49:31 -0400
Subject: Re: [PATCH] Chaining sg lists for big IO commands v5
From: Badari Pulavarty <pbadari@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, bhalevy@panasas.com,
       Andrew Morton <akpm@linux-foundation.org>,
       fujita.tomonori@lab.ntt.co.jp, michaelc@cs.wisc.edu
In-Reply-To: <20070518170323.GI23798@kernel.dk>
References: <20070511135108.GF4629@kernel.dk>
	 <1179249337.2836.110.camel@dyn9047017100.beaverton.ibm.com>
	 <20070515172001.GB23798@kernel.dk>
	 <1179251020.2836.118.camel@dyn9047017100.beaverton.ibm.com>
	 <20070515175025.GE23798@kernel.dk>
	 <1179349294.16195.6.camel@dyn9047017100.beaverton.ibm.com>
	 <20070517062742.GW23798@kernel.dk>
	 <1179414662.23725.3.camel@dyn9047017100.beaverton.ibm.com>
	 <20070518073331.GC23798@kernel.dk>
	 <1179504198.29302.12.camel@dyn9047017100.beaverton.ibm.com>
	 <20070518170323.GI23798@kernel.dk>
Content-Type: text/plain
Date: Fri, 18 May 2007 10:50:19 -0700
Message-Id: <1179510619.29302.14.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-18 at 19:03 +0200, Jens Axboe wrote:
> On Fri, May 18 2007, Badari Pulavarty wrote:
> > On Fri, 2007-05-18 at 09:33 +0200, Jens Axboe wrote:
> > > On Thu, May 17 2007, Badari Pulavarty wrote:
> > > > On Thu, 2007-05-17 at 08:27 +0200, Jens Axboe wrote:
> > > > .. 
> > > > > > > 
> > > > > > > Ah ok, you need the updated patch series for ppc64 support. Builds fine
> > > > > > > here on ppc64. See the #sglist branch of the block repo:
> > > > > > > 
> > > > > > > git://git.kernel.dk/data/git/linux-2.6-block.git
> > > > > > > 
> > > > > > > I can mail you an updated patch, if you want.
> > > > > > 
> > > > > > 
> > > > > > Here is the whole panic stack..
> > > > > 
> > > > > Thanks will fix that up, the IDE part is totally untested. Can you try
> > > > > and backout this patch and see if it boots?
> > > > 
> > > > Yes. It boots fine with following backed out.
> > > > 
> > > > Looking at the code ide_probe.c: hwif_init() is doing
> > > > 
> > > >         hwif->sg_table = kmalloc(sizeof(struct scatterlist)*hwif->sg_max_nents,
> > > >                                  GFP_KERNEL);
> > > > 
> > > > blk_rq_map_sg() is looking for the chaining info and going over end of the
> > > > allocation.
> > > 
> > > Hmm, looks ok, I'm guessing it's just missing a memset (or just turn it
> > > into a kzalloc())?
> > > 
> > 
> > Even with backing out all the ide changes, I get this on boot
> > once in a while.
> 
> Yep, I think the ide changes are fine as such, the problem is the
> missing memset/kzalloc. Can you try that?

kzalloc() made it better. I haven't seen ide panics anymore. I will try
it again after applying ide patches.

Thanks
Badari



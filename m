Return-Path: <linux-kernel-owner+w=401wt.eu-S1756178AbXI1VAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178AbXI1VAJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 17:00:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753489AbXI1U74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 16:59:56 -0400
Received: from gir.skynet.ie ([193.1.99.77]:57752 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753485AbXI1U7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 16:59:55 -0400
Date: Fri, 28 Sep 2007 21:59:52 +0100
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Christoph Lameter <clameter@sgi.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Christoph Hellwig <hch@lst.de>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [15/17] SLUB: Support virtual fallback via SLAB_VFALLBACK
Message-ID: <20070928205952.GA30404@skynet.ie>
References: <20070919033605.785839297@sgi.com> <20070919033643.763818012@sgi.com> <200709280742.38262.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0709281014060.4713@schroedinger.engr.sgi.com> <1191002119.18147.80.camel@lappy> <Pine.LNX.4.64.0709281114250.5149@schroedinger.engr.sgi.com> <1191003950.18147.85.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1191003950.18147.85.camel@lappy>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (28/09/07 20:25), Peter Zijlstra didst pronounce:
> 
> On Fri, 2007-09-28 at 11:20 -0700, Christoph Lameter wrote:
> 
> > > start 2 processes that each mmap a separate 64M file, and which does
> > > sequential writes on them. start a 3th process that does the same with
> > > 64M anonymous.
> > > 
> > > wait for a while, and you'll see order=1 failures.
> > 
> > Really? That means we can no longer even allocate stacks for forking.
> > 
> > Its surprising that neither lumpy reclaim nor the mobility patches can 
> > deal with it? Lumpy reclaim should be able to free neighboring pages to 
> > avoid the order 1 failure unless there are lots of pinned pages.
> > 
> > I guess then that lots of pages are pinned through I/O?
> 
> memory got massively fragemented, as anti-frag gets easily defeated.
> setting min_free_kbytes to 12M does seem to solve it - it forces 2 max

The 12MB is related to the size of pageblock_order. I strongly suspect
that if you forced pageblock_order to be something like 4 or 5, the
min_free_kbytes would not need to be raised. The current values are
selected based on the hugepage size.

> order blocks to stay available, so we don't mix types. however 12M on
> 128M is rather a lot.
> 
> its still on my todo list to look at it further..
> 

-- 
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab

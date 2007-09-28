Return-Path: <linux-kernel-owner+w=401wt.eu-S1756832AbXI1Saa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832AbXI1Saa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 14:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753933AbXI1SaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 14:30:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45670 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbXI1SaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 14:30:18 -0400
Subject: Re: [15/17] SLUB: Support virtual fallback via SLAB_VFALLBACK
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0709281114250.5149@schroedinger.engr.sgi.com>
References: <20070919033605.785839297@sgi.com>
	 <20070919033643.763818012@sgi.com>
	 <200709280742.38262.nickpiggin@yahoo.com.au>
	 <Pine.LNX.4.64.0709281014060.4713@schroedinger.engr.sgi.com>
	 <1191002119.18147.80.camel@lappy>
	 <Pine.LNX.4.64.0709281114250.5149@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Fri, 28 Sep 2007 20:25:50 +0200
Message-Id: <1191003950.18147.85.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-09-28 at 11:20 -0700, Christoph Lameter wrote:

> > start 2 processes that each mmap a separate 64M file, and which does
> > sequential writes on them. start a 3th process that does the same with
> > 64M anonymous.
> > 
> > wait for a while, and you'll see order=1 failures.
> 
> Really? That means we can no longer even allocate stacks for forking.
> 
> Its surprising that neither lumpy reclaim nor the mobility patches can 
> deal with it? Lumpy reclaim should be able to free neighboring pages to 
> avoid the order 1 failure unless there are lots of pinned pages.
> 
> I guess then that lots of pages are pinned through I/O?

memory got massively fragemented, as anti-frag gets easily defeated.
setting min_free_kbytes to 12M does seem to solve it - it forces 2 max
order blocks to stay available, so we don't mix types. however 12M on
128M is rather a lot.

its still on my todo list to look at it further..


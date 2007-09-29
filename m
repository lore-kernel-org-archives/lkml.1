Return-Path: <linux-kernel-owner+w=401wt.eu-S1755806AbXI2IOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806AbXI2IOX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 04:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752013AbXI2IOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 04:14:12 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51156 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751794AbXI2IOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 04:14:09 -0400
Date: Sat, 29 Sep 2007 01:13:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Christoph Lameter <clameter@sgi.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [15/17] SLUB: Support virtual fallback via SLAB_VFALLBACK
Message-Id: <20070929011311.8b51dedb.akpm@linux-foundation.org>
In-Reply-To: <1191003950.18147.85.camel@lappy>
References: <20070919033605.785839297@sgi.com>
	<20070919033643.763818012@sgi.com>
	<200709280742.38262.nickpiggin@yahoo.com.au>
	<Pine.LNX.4.64.0709281014060.4713@schroedinger.engr.sgi.com>
	<1191002119.18147.80.camel@lappy>
	<Pine.LNX.4.64.0709281114250.5149@schroedinger.engr.sgi.com>
	<1191003950.18147.85.camel@lappy>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007 20:25:50 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

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
> order blocks to stay available, so we don't mix types. however 12M on
> 128M is rather a lot.
> 
> its still on my todo list to look at it further..
> 

That would be really really bad (as in: patch-dropping time) if those
order-1 allocations are not atomic.

What's the callsite? 

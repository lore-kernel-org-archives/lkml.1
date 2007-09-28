Return-Path: <linux-kernel-owner+w=401wt.eu-S1756909AbXI1SUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909AbXI1SUg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 14:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753534AbXI1SU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 14:20:27 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:60259 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752359AbXI1SU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 14:20:26 -0400
Date: Fri, 28 Sep 2007 11:20:23 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [15/17] SLUB: Support virtual fallback via SLAB_VFALLBACK
In-Reply-To: <1191002119.18147.80.camel@lappy>
Message-ID: <Pine.LNX.4.64.0709281114250.5149@schroedinger.engr.sgi.com>
References: <20070919033605.785839297@sgi.com>  <20070919033643.763818012@sgi.com>
  <200709280742.38262.nickpiggin@yahoo.com.au> 
 <Pine.LNX.4.64.0709281014060.4713@schroedinger.engr.sgi.com>
 <1191002119.18147.80.camel@lappy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007, Peter Zijlstra wrote:

> 
> On Fri, 2007-09-28 at 10:33 -0700, Christoph Lameter wrote:
> 
> > Again I have not seen any fallbacks to vmalloc in my testing. What we are 
> > doing here is mainly to address your theoretical cases that we so far have 
> > never seen to be a problem and increase the reliability of allocations of
> > page orders larger than 3 to a usable level. So far I have so far not 
> > dared to enable orders larger than 3 by default.
> 
> take a recent -mm kernel, boot with mem=128M.

Ok so only 32k pages to play with? I have tried parallel kernel compiles 
with mem=256m and they seemed to be fine.

> start 2 processes that each mmap a separate 64M file, and which does
> sequential writes on them. start a 3th process that does the same with
> 64M anonymous.
> 
> wait for a while, and you'll see order=1 failures.

Really? That means we can no longer even allocate stacks for forking.

Its surprising that neither lumpy reclaim nor the mobility patches can 
deal with it? Lumpy reclaim should be able to free neighboring pages to 
avoid the order 1 failure unless there are lots of pinned pages.

I guess then that lots of pages are pinned through I/O?

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756736AbXJAUzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736AbXJAUzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 16:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbXJAUzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 16:55:32 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60996 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755147AbXJAUza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 16:55:30 -0400
Date: Mon, 1 Oct 2007 13:55:29 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [15/17] SLUB: Support virtual fallback via SLAB_VFALLBACK
In-Reply-To: <20070929020049.f73f4aea.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0710011354480.19779@schroedinger.engr.sgi.com>
References: <20070919033605.785839297@sgi.com> <20070919033643.763818012@sgi.com>
 <200709280742.38262.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0709281014060.4713@schroedinger.engr.sgi.com>
 <1191002119.18147.80.camel@lappy> <Pine.LNX.4.64.0709281114250.5149@schroedinger.engr.sgi.com>
 <1191003950.18147.85.camel@lappy> <20070929011311.8b51dedb.akpm@linux-foundation.org>
 <1191055632.18147.101.camel@lappy> <20070929020049.f73f4aea.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Sep 2007, Andrew Morton wrote:

> > atomic allocations. And with SLUB using higher order pages, atomic !0
> > order allocations will be very very common.
> 
> Oh OK.
> 
> I thought we'd already fixed slub so that it didn't do that.  Maybe that
> fix is in -mm but I don't think so.
> 
> Trying to do atomic order-1 allocations on behalf of arbitray slab caches
> just won't fly - this is a significant degradation in kernel reliability,
> as you've very easily demonstrated.

Ummm... SLAB also does order 1 allocations. We have always done them.

See mm/slab.c

/*
 * Do not go above this order unless 0 objects fit into the slab.
 */
#define BREAK_GFP_ORDER_HI      1
#define BREAK_GFP_ORDER_LO      0
static int slab_break_gfp_order = BREAK_GFP_ORDER_LO;


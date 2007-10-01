Return-Path: <linux-kernel-owner+w=401wt.eu-S1755699AbXJAVKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699AbXJAVKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 17:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752657AbXJAVKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 17:10:09 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:43581 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752700AbXJAVKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 17:10:07 -0400
Date: Mon, 1 Oct 2007 14:10:06 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@skynet.ie>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, Christoph Hellwig <hch@lst.de>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       akpm@linux-foundation.org
Subject: Re: [15/17] SLUB: Support virtual fallback via SLAB_VFALLBACK
In-Reply-To: <20070928210527.GB30404@skynet.ie>
Message-ID: <Pine.LNX.4.64.0710011406540.20071@schroedinger.engr.sgi.com>
References: <20070919033605.785839297@sgi.com> <20070919033643.763818012@sgi.com>
 <200709280742.38262.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0709281014060.4713@schroedinger.engr.sgi.com>
 <20070928210527.GB30404@skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007, Mel Gorman wrote:

> Minimally, SLUB by default should continue to use order-0 pages. Peter has
> managed to bust order-1 pages with mem=128MB. Admittedly, it was a really
> hostile workload but the point remains. It was artifically worked around
> with min_free_kbytes (value set based on pageblock_order, could also have
> been artifically worked around by dropping pageblock_order) and he eventually
> caused order-0 failures so the workload is pretty damn hostile to everything.

SLAB default is order 1 so is SLUB default upstream.

SLAB does runtime detection of the amount of memory and configures the max 
order correspondingly:

from mm/slab.c:

	/*
         * Fragmentation resistance on low memory - only use bigger
         * page orders on machines with more than 32MB of memory.
         */
        if (num_physpages > (32 << 20) >> PAGE_SHIFT)
                slab_break_gfp_order = BREAK_GFP_ORDER_HI;


We could duplicate something like that for SLUB.



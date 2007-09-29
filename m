Return-Path: <linux-kernel-owner+w=401wt.eu-S1756281AbXI2I62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281AbXI2I62 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 04:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbXI2I6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 04:58:19 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56651 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbXI2I6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 04:58:18 -0400
Subject: Re: [15/17] SLUB: Support virtual fallback via SLAB_VFALLBACK
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <1191055632.18147.101.camel@lappy>
References: <20070919033605.785839297@sgi.com>
	 <20070919033643.763818012@sgi.com>
	 <200709280742.38262.nickpiggin@yahoo.com.au>
	 <Pine.LNX.4.64.0709281014060.4713@schroedinger.engr.sgi.com>
	 <1191002119.18147.80.camel@lappy>
	 <Pine.LNX.4.64.0709281114250.5149@schroedinger.engr.sgi.com>
	 <1191003950.18147.85.camel@lappy>
	 <20070929011311.8b51dedb.akpm@linux-foundation.org>
	 <1191055632.18147.101.camel@lappy>
Content-Type: text/plain
Date: Sat, 29 Sep 2007 10:53:41 +0200
Message-Id: <1191056021.18147.104.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-09-29 at 10:47 +0200, Peter Zijlstra wrote:

> Ah, right, that was the detail... all this lumpy reclaim is useless for
> atomic allocations. And with SLUB using higher order pages, atomic !0
> order allocations will be very very common.
> 
> One I can remember was:
> 
>   add_to_page_cache()
>     radix_tree_insert()
>       radix_tree_node_alloc()
>         kmem_cache_alloc()
> 
> which is an atomic callsite.
> 
> Which leaves us in a situation where we can load pages, because there is
> free memory, but can't manage to allocate memory to track them.. 

Ah, I found a boot log of one of these sessions, its also full of
order-2 OOMs.. :-/


Return-Path: <linux-kernel-owner+w=401wt.eu-S1759424AbXGXHKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759424AbXGXHKa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 03:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757447AbXGXHJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 03:09:55 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56896 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756182AbXGXHJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 03:09:49 -0400
Date: Tue, 24 Jul 2007 00:09:47 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Mel Gorman <mel@skynet.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Daniel Phillips <phillips@google.com>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] add __GFP_ZERO to GFP_LEVEL_MASK
In-Reply-To: <1185256869.8197.27.camel@twins>
Message-ID: <Pine.LNX.4.64.0707240007100.3128@schroedinger.engr.sgi.com>
References: <1185185020.8197.11.camel@twins>  <20070723112143.GB19437@skynet.ie>
 <1185190711.8197.15.camel@twins>  <Pine.LNX.4.64.0707231615310.427@schroedinger.engr.sgi.com>
 <1185256869.8197.27.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jul 2007, Peter Zijlstra wrote:

> Then we can either fixup the slab allocators to mask out __GFP_ZERO, or
> do something like the below.
> 
> Personally I like the consistency of adding __GFP_ZERO here (removes
> this odd exception) and just masking it in the sl[aou]b thingies.

There is another exception for __GFP_DMA.

> Anybody else got a preference?

>  #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
>  
> -/* if you forget to add the bitmask here kernel will crash, period */
> +/*
> + * If you forget to add the bitmask here kernel will crash, period!
> + *
> + * GFP_LEVEL_MASK is used to filter out the flags that are to be passed to the
> + * page allocator.
> + *

GFP_LEVEL_MASK is also used in mm/vmalloc.c. We need a definition that 
goes beyond slab allocators.


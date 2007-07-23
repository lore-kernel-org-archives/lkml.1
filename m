Return-Path: <linux-kernel-owner+w=401wt.eu-S932294AbXGWXAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294AbXGWXAd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 19:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbXGWXA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 19:00:26 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:55406 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752846AbXGWXAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 19:00:25 -0400
Date: Mon, 23 Jul 2007 16:00:24 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Daniel Phillips <phillips@google.com>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] add __GFP_ZERP to GFP_LEVEL_MASK
In-Reply-To: <20070723155603.f1b1a735.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0707231558590.32630@schroedinger.engr.sgi.com>
References: <1185185020.8197.11.camel@twins> <20070723113712.c0ee29e5.akpm@linux-foundation.org>
 <1185216048.5535.1.camel@lappy> <20070723144323.1ac34b16@schroedinger.engr.sgi.com>
 <20070723151306.86e3e0ce.akpm@linux-foundation.org>
 <alpine.LFD.0.999.0707231539520.3607@woody.linux-foundation.org>
 <20070723155603.f1b1a735.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2007, Andrew Morton wrote:

> So this:
> 
> 	/*
> 	 * Be lazy and only check for valid flags here,  keeping it out of the
> 	 * critical path in kmem_cache_alloc().
> 	 */
> 	BUG_ON(flags & ~(GFP_DMA | __GFP_ZERO | GFP_LEVEL_MASK));
> 
> would no longer need the __GFP_ZERO.  Ditto in slob's new_slab().

That __GFP_ZERO is needed to avoid triggering the BUG_ON. The next line

	local_flags = (flags & GFP_LEVEL_MASK);

filters out the __GFP_ZERO before calling the page allocator.

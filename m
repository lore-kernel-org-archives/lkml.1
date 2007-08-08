Return-Path: <linux-kernel-owner+w=401wt.eu-S935969AbXHHR51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935969AbXHHR51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 13:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762760AbXHHR5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 13:57:16 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:38089 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762506AbXHHR5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 13:57:16 -0400
Date: Wed, 8 Aug 2007 10:57:13 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Matt Mackall <mpm@selenic.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       David Miller <davem@davemloft.net>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Steve Dickson <SteveD@redhat.com>
Subject: Re: [PATCH 04/10] mm: slub: add knowledge of reserve pages
In-Reply-To: <20070808103946.4cece16c.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0708081050590.12652@schroedinger.engr.sgi.com>
References: <20070806102922.907530000@chello.nl> <20070806103658.603735000@chello.nl>
 <Pine.LNX.4.64.0708071702560.4941@schroedinger.engr.sgi.com>
 <20070808014435.GG30556@waste.org> <Pine.LNX.4.64.0708081004290.12652@schroedinger.engr.sgi.com>
 <20070808103946.4cece16c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Aug 2007, Andrew Morton wrote:

> 3.  Perform page reclaim from hard IRQ context.  Pretty simple to
> implement, most of the work would be needed in the rmap code.  It might be
> better to make it opt-in via a new __GFP_flag.

In a hardirq context one is bound to a processor and through the slab 
allocator to a slab from which one allocates objects. The slab is per cpu 
and so the slab is reserved for the current context. Nothing can take 
objects away from it. The modifications here would not be needed for that 
context.

I think in general irq context reclaim is doable. Cannot see obvious 
issues on a first superficial pass through rmap.c. The irq holdoff would 
be pretty long though which may make it unacceptable.


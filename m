Return-Path: <linux-kernel-owner+w=401wt.eu-S1765843AbXHFR4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765843AbXHFR4Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 13:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756538AbXHFR4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 13:56:18 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:48186 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755520AbXHFR4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 13:56:17 -0400
Date: Mon, 6 Aug 2007 10:56:13 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Steve Dickson <SteveD@redhat.com>
Subject: Re: [PATCH 00/10] foundations for reserve-based allocation
In-Reply-To: <20070806102922.907530000@chello.nl>
Message-ID: <Pine.LNX.4.64.0708061052160.24256@schroedinger.engr.sgi.com>
References: <20070806102922.907530000@chello.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Aug 2007, Peter Zijlstra wrote:

> We want a guarantee for N bytes from kmalloc(), this translates to a demand
> on the slab allocator for 2*N+m (due to the power-of-two nature of kmalloc 
> slabs), where m is the meta-data needed by the allocator itself.

The guarantee occurs in what context? Looks like its global here but 
allocations may be restricted to a cpuset context? What happens in a 
GFP_THISNODE allocation? Or a memory policy restricted allocations?

> So we need functions translating our demanded kmalloc space into a page
> reserve limit, and then need to provide a reserve of pages.

Only kmalloc? What about skb heads and such?

> And we need to ensure that once we hit the reserve, the slab allocator honours
> the reserve's access. That is, a regular allocation may not get objects from
> a slab allocated from the reserves.

>From a cpuset we may hit the reserves since cpuset memory is out and then 
the rest of the system fails allocations?

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757164AbXENQ3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164AbXENQ3Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 12:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755039AbXENQ3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 12:29:18 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36932 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754670AbXENQ3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 12:29:17 -0400
Date: Mon, 14 May 2007 09:29:15 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Matt Mackall <mpm@selenic.com>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Thomas Graf <tgraf@suug.ch>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 0/5] make slab gfp fair
In-Reply-To: <20070514161224.GC11115@waste.org>
Message-ID: <Pine.LNX.4.64.0705140927470.10801@schroedinger.engr.sgi.com>
References: <20070514131904.440041502@chello.nl>
 <Pine.LNX.4.64.0705140852150.10442@schroedinger.engr.sgi.com>
 <20070514161224.GC11115@waste.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2007, Matt Mackall wrote:

> privileged thread                      unprivileged greedy process
> kmem_cache_alloc(...)
>    adds new slab page from lowmem pool

Yes but it returns an object for the privileged thread. Is that not 
enough?


> do_io()
>                                        kmem_cache_alloc(...)
>                                        kmem_cache_alloc(...)
>                                        kmem_cache_alloc(...)
>                                        kmem_cache_alloc(...)
>                                        kmem_cache_alloc(...)
>                                        ...
>                                           eats it all
> kmem_cache_alloc(...) -> ENOMEM
>    who ate my donuts?!
> 
> But I think this solution is somehow overkill. If we only care about
> this issue in the OOM avoidance case, then our rank reduces to a
> boolean.
> 
> -- 
> Mathematics is the supreme nostalgia of our time.
> 

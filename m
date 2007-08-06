Return-Path: <linux-kernel-owner+w=401wt.eu-S1764746AbXHFUXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764746AbXHFUXk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 16:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932781AbXHFUXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 16:23:20 -0400
Received: from waste.org ([66.93.16.53]:57294 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765875AbXHFUXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 16:23:19 -0400
Date: Mon, 6 Aug 2007 15:23:23 -0500
From: Matt Mackall <mpm@selenic.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Steve Dickson <SteveD@redhat.com>
Subject: Re: [PATCH 00/10] foundations for reserve-based allocation
Message-ID: <20070806202323.GH11115@waste.org>
References: <20070806102922.907530000@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070806102922.907530000@chello.nl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2007 at 12:29:22PM +0200, Peter Zijlstra wrote:
> 
> In the interrest of getting swap over network working and posting in smaller
> series, here is the first series.
> 
> This series lays the foundations needed to do reserve based allocation.
> Traditionally we have used mempools (and others like radix_tree_preload) to
> handle the problem.
> 
> However this does not fit the network stack. It is built around variable
> sized allocations using kmalloc().
> 
> This calls for a different approach.

One wonders if containers are a possible solution. I can already solve
this problem with virtualization: have one VM manage all the network
I/O and export the device as a simpler virtual block device to other
VMs. Provided this VM isn't doing any "real" work and is sized
appropriately, it won't get wedged. Since the other VMs now submit I/O
through the simpler block interface, they can avoid getting wedged
with the standard mempool approach.

If we can run nbd and friends inside their own container that can give
similar isolation, we might not need to add this other complexity.

Just food for thought. I haven't looked closely enough at the
containers implementations yet to determine whether this is possible
or if the overhead in performance or complexity is acceptable.

-- 
Mathematics is the supreme nostalgia of our time.

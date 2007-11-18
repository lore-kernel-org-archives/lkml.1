Return-Path: <linux-kernel-owner+w=401wt.eu-S1753123AbXKRFgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbXKRFgr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 00:36:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751262AbXKRFgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 00:36:39 -0500
Received: from smtp.cs.utexas.edu ([128.83.120.210]:39791 "EHLO
	smtp.cs.utexas.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbXKRFgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 00:36:38 -0500
Date: Sat, 17 Nov 2007 23:36:26 -0600
From: Don Porter <porterde@cs.utexas.edu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Chris Snook <csnook@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] Optimize zone allocator synchronization
Message-ID: <20071118053626.GC21569@olive-green.cs.utexas.edu>
References: <20071104195212.GF16354@olive-green.cs.utexas.edu> <47303D07.4050404@redhat.com> <20071106221928.f629c69f.akpm@linux-foundation.org> <200711071632.00055.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711071632.00055.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you all for your consideration and insightful responses to my
posting.  I apologize for not responding sooner---I have been under a
deadline.

It seems clear that further investigation will be needed to understand
these performance numbers better.

To summarize, I understand that the following experiments will be helpful:

1) Instrument the allocation code to determine the common size/order
of the allocations for these workloads.

2) Try to integrate these changes with ticket spinlocks

3) Try placing the zone lock in its own cacheline

4) Look for single-threaded regressions (dd benchmark).

I'll do these at my first opportunity, hopefully within the next week.
Please let me know if I misunderstood any of your comments.

My intuition about the cost of ping-ponging the lock's cache line
certainly matched yours, so I was very surprised to see these
performance numbers.  

On Wed, Nov 07, 2007 at 04:31:59PM +1100, Nick Piggin wrote:
> It's funny, Dave Miller and I were just talking about the possible
> reappearance of zone->lock contention with massively multi core and
> multi threaded CPUs. I think the right way to fix this in the long run
> if it turns into a real problem, is something like having a lock per
> MAX_ORDER block, and having CPUs prefer to allocate from different
> blocks. Anti-frag makes this pretty interesting to implement, but it
> will be possible.

As a bit of background, the zone lock is indeed one of the more
contended locks in my target workloads so it was no accident that I
was looking for ways to improve its scalability.  I am quite
interested in Nick's ideas about how to split up the zone allocator's
synchronization.

Of course, these contention levels may not meet your definition of
"real problem" (~.1% of the execution time).

Best regards,
Don

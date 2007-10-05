Return-Path: <linux-kernel-owner+w=401wt.eu-S1762278AbXJEMik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762278AbXJEMik (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 08:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753174AbXJEMib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 08:38:31 -0400
Received: from brick.kernel.dk ([87.55.233.238]:28350 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbXJEMia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 08:38:30 -0400
Date: Fri, 5 Oct 2007 14:39:53 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, David Chinner <dgc@sgi.com>,
       David Miller <davem@davemloft.net>, cebbert@redhat.com,
       willy@linux.intel.com, clameter@sgi.com, nickpiggin@yahoo.com.au,
       hch@lst.de, mel@skynet.ie, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: Re: SLUB performance regression vs SLAB
Message-ID: <20071005123953.GS5711@kernel.dk>
References: <470554D9.2050505@redhat.com> <20071004.141113.08322956.davem@davemloft.net> <47055F84.109@redhat.com> <20071004.150718.95506800.davem@davemloft.net> <20071004222356.GH23367404@sgi.com> <20071005064853.GI5711@kernel.dk> <84144f020710050219k2460631cjfd556d6eae645887@mail.gmail.com> <20071005092822.GL5711@kernel.dk> <p73bqbd6cip.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73bqbd6cip.fsf@bingen.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05 2007, Andi Kleen wrote:
> Jens Axboe <jens.axboe@oracle.com> writes:
> > 
> > Writing a small test module to exercise slub/slab in various ways
> > (allocating from all cpus freeing from one, as described) should not be
> > too hard. Perhaps that would be enough to find this performance
> > discrepancy between slab and slub?
> 
> You could simulate that by just sending packets using unix sockets
> between threads bound to different CPUs. Sending a packet allocates;
> receiving deallocates.

Sure, there are a host of ways to accomplish the same thing.

> But it's not clear that will really simulate the cache bounce
> environment of the database test. I don't think all passing of data
> between CPUs using slub objects is slow.

It might not, it might. The point is trying to isolate the problem and
making a simple test case that could be used to reproduce it, so that
Christoph (or someone else) can easily fix it.

-- 
Jens Axboe


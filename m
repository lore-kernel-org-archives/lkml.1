Return-Path: <linux-kernel-owner+w=401wt.eu-S934705AbZJNPuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934705AbZJNPuY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934589AbZJNPuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:50:21 -0400
Received: from gir.skynet.ie ([193.1.99.77]:50998 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934677AbZJNPuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:50:17 -0400
Date: Wed, 14 Oct 2009 16:49:44 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
Subject: Re: [this_cpu_xx V6 7/7] this_cpu: slub aggressive use of this_cpu
	operations in the hotpaths
Message-ID: <20091014154944.GD5027@csn.ul.ie>
References: <alpine.DEB.1.00.0910130231570.27262@chino.kir.corp.google.com> <alpine.DEB.1.10.0910131041450.21608@gentwo.org> <alpine.DEB.1.10.0910131509170.32394@gentwo.org> <4AD4D8B6.6010700@cs.helsinki.fi> <alpine.DEB.1.10.0910131541290.7246@gentwo.org> <alpine.DEB.1.00.0910131305440.3529@chino.kir.corp.google.com> <alpine.DEB.1.10.0910131625370.13756@gentwo.org> <alpine.DEB.1.00.0910131550050.15347@chino.kir.corp.google.com> <20091014133457.GB5027@csn.ul.ie> <alpine.DEB.1.10.0910141003590.9944@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0910141003590.9944@gentwo.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 14, 2009 at 10:08:12AM -0400, Christoph Lameter wrote:
> The test did not include the irqless patch I hope?
> 

Correct. Only the patches in this thread were tested.

> On Wed, 14 Oct 2009, Mel Gorman wrote:
> 
> > Small gains in the User, System and Elapsed times with this-cpu patches
> > applied. It is interest to note for the mean times that the patches more
> > than close the gap between SLUB and SLAB for the most part - the
> > exception being User which has marginally better performance. This might
> > indicate that SLAB is still slightly better at giving back cache-hot
> > memory but this is speculation.
> 
> The queuing in SLAB allows a better cache hot behavior. Without a queue
> SLUB has a difficult time improvising cache hot behavior based on objects
> restricted to a slab page. Therefore the size of the slab page will
> affect how much "queueing" SLUB can do.
> 

Ok, so the speculation is a plausible explanation.

> > The patches mostly improve the performance of netperf UDP_STREAM by a good
> > whack so the patches are a plus here. However, it should also be noted that
> > SLAB was mostly faster than SLUB, particularly for large packet sizes. Refresh
> > my memory, how do SLUB and SLAB differ in regards to off-loading large
> > allocations to the page allocator these days?
> 
> SLUB offloads allocations > 8k to the page allocator.
> SLAB does create large slabs.
> 

Allocations >8k might explain then why 8K and 16K packets for UDP_STREAM
performance suffers. That can be marked as future possible work to sort
out within the allocator.

However, does it explain why TCP_STREAM suffers so badly even for packet
sizes like 2K? It's also important to note in some cases, SLAB was far
slower even when the packet sizes were greater than 8k so I don't think
the page allocator is an adequate explanation for TCP_STREAM.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab

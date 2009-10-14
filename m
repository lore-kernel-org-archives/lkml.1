Return-Path: <linux-kernel-owner+w=401wt.eu-S933409AbZJNOQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933409AbZJNOQZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 10:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933376AbZJNOQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 10:16:24 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:35631 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933221AbZJNOQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 10:16:24 -0400
Date: Wed, 14 Oct 2009 10:08:12 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Mel Gorman <mel@csn.ul.ie>
cc: David Rientjes <rientjes@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
Subject: Re: [this_cpu_xx V6 7/7] this_cpu: slub aggressive use of this_cpu
 operations in the hotpaths
In-Reply-To: <20091014133457.GB5027@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0910141003590.9944@gentwo.org>
References: <4AD307A5.105@kernel.org> <84144f020910120614r529d8e4em9babe83a90e9371f@mail.gmail.com> <alpine.DEB.1.00.0910130231570.27262@chino.kir.corp.google.com> <alpine.DEB.1.10.0910131041450.21608@gentwo.org> <alpine.DEB.1.10.0910131509170.32394@gentwo.org>
 <4AD4D8B6.6010700@cs.helsinki.fi> <alpine.DEB.1.10.0910131541290.7246@gentwo.org> <alpine.DEB.1.00.0910131305440.3529@chino.kir.corp.google.com> <alpine.DEB.1.10.0910131625370.13756@gentwo.org> <alpine.DEB.1.00.0910131550050.15347@chino.kir.corp.google.com>
 <20091014133457.GB5027@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The test did not include the irqless patch I hope?

On Wed, 14 Oct 2009, Mel Gorman wrote:

> Small gains in the User, System and Elapsed times with this-cpu patches
> applied. It is interest to note for the mean times that the patches more
> than close the gap between SLUB and SLAB for the most part - the
> exception being User which has marginally better performance. This might
> indicate that SLAB is still slightly better at giving back cache-hot
> memory but this is speculation.

The queuing in SLAB allows a better cache hot behavior. Without a queue
SLUB has a difficult time improvising cache hot behavior based on objects
restricted to a slab page. Therefore the size of the slab page will
affect how much "queueing" SLUB can do.

> The patches mostly improve the performance of netperf UDP_STREAM by a good
> whack so the patches are a plus here. However, it should also be noted that
> SLAB was mostly faster than SLUB, particularly for large packet sizes. Refresh
> my memory, how do SLUB and SLAB differ in regards to off-loading large
> allocations to the page allocator these days?

SLUB offloads allocations > 8k to the page allocator.
SLAB does create large slabs.


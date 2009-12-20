Return-Path: <linux-kernel-owner+w=401wt.eu-S1752742AbZLTJLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbZLTJLa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 04:11:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbZLTJL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 04:11:29 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:41268 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbZLTJL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 04:11:27 -0500
Message-ID: <4B2DEA33.7000800@cs.helsinki.fi>
Date: Sun, 20 Dec 2009 11:11:15 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [this_cpu_xx V8 03/16] Use this_cpu operations in slub
References: <20091218222617.384355422@quilx.com> <20091218222649.091070364@quilx.com>
In-Reply-To: <20091218222649.091070364@quilx.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> Using per cpu allocations removes the needs for the per cpu arrays in the
> kmem_cache struct. These could get quite big if we have to support systems
> with thousands of cpus. The use of this_cpu_xx operations results in:
> 
> 1. The size of kmem_cache for SMP configuration shrinks since we will only
>    need 1 pointer instead of NR_CPUS. The same pointer can be used by all
>    processors. Reduces cache footprint of the allocator.
> 
> 2. We can dynamically size kmem_cache according to the actual nodes in the
>    system meaning less memory overhead for configurations that may potentially
>    support up to 1k NUMA nodes / 4k cpus.
> 
> 3. We can remove the diddle widdle with allocating and releasing of
>    kmem_cache_cpu structures when bringing up and shutting down cpus. The cpu
>    alloc logic will do it all for us. Removes some portions of the cpu hotplug
>    functionality.
> 
> 4. Fastpath performance increases since per cpu pointer lookups and
>    address calculations are avoided.
> 
> V7-V8
> - Convert missed get_cpu_slab() under CONFIG_SLUB_STATS
> 
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

Patches 3-6 applied.

Return-Path: <linux-kernel-owner+w=401wt.eu-S935089AbZJOJEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935089AbZJOJEh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 05:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935074AbZJOJEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 05:04:36 -0400
Received: from smtp-out.google.com ([216.239.45.13]:43222 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935072AbZJOJEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 05:04:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=uzmFhAbtF3nDbzE4PrGZ8pF4uwDWaMwYKflcda3SdnTkRuHzu8J4D41Loy5/7ncbe
	c5pGGwrZkZWoCq77S8NAw==
Date: Thu, 15 Oct 2009 02:03:17 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
Subject: Re: [this_cpu_xx V6 7/7] this_cpu: slub aggressive use of this_cpu
 operations in the hotpaths
In-Reply-To: <20091014133457.GB5027@csn.ul.ie>
Message-ID: <alpine.DEB.1.00.0910150157250.20184@chino.kir.corp.google.com>
References: <4AD307A5.105@kernel.org> <84144f020910120614r529d8e4em9babe83a90e9371f@mail.gmail.com> <alpine.DEB.1.00.0910130231570.27262@chino.kir.corp.google.com> <alpine.DEB.1.10.0910131041450.21608@gentwo.org> <alpine.DEB.1.10.0910131509170.32394@gentwo.org>
 <4AD4D8B6.6010700@cs.helsinki.fi> <alpine.DEB.1.10.0910131541290.7246@gentwo.org> <alpine.DEB.1.00.0910131305440.3529@chino.kir.corp.google.com> <alpine.DEB.1.10.0910131625370.13756@gentwo.org> <alpine.DEB.1.00.0910131550050.15347@chino.kir.corp.google.com>
 <20091014133457.GB5027@csn.ul.ie>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Oct 2009, Mel Gorman wrote:

> NETPERF TCP_STREAM
>   Packet           netperf-tcp          tcp-SLUB       netperf-tcp          tcp-SLAB
>     Size          SLUB-vanilla          this-cpu      SLAB-vanilla          this-cpu
>       64      1773.00 ( 0.00%)   1731.63 (-2.39%)*  1794.48 ( 1.20%)   2029.46 (12.64%) 
>                  1.00%             2.43%             1.00%             1.00%        
>      128      3181.12 ( 0.00%)   3471.22 ( 8.36%)   3296.37 ( 3.50%)   3251.33 ( 2.16%) 
>      256      4794.35 ( 0.00%)   4797.38 ( 0.06%)   4912.99 ( 2.41%)   4846.86 ( 1.08%) 
>     1024      9438.10 ( 0.00%)   8681.05 (-8.72%)*  8270.58 (-14.12%)   8268.85 (-14.14%) 
>                  1.00%             7.31%             1.00%             1.00%        
>     2048      9196.06 ( 0.00%)   9375.72 ( 1.92%)  11474.59 (19.86%)   9420.01 ( 2.38%) 
>     3312     10338.49 ( 0.00%)* 10021.82 (-3.16%)* 12018.72 (13.98%)* 12069.28 (14.34%)*
>                  9.49%             6.36%             1.21%             2.12%        
>     4096      9931.20 ( 0.00%)* 10285.38 ( 3.44%)* 12265.59 (19.03%)* 10175.33 ( 2.40%)*
>                  1.31%             1.38%             9.97%             8.33%        
>     6144     12775.08 ( 0.00%)* 10559.63 (-20.98%)  13139.34 ( 2.77%)  13210.79 ( 3.30%)*
>                  1.45%             1.00%             1.00%             2.99%        
>     8192     10933.93 ( 0.00%)* 10534.41 (-3.79%)* 10876.42 (-0.53%)* 10738.25 (-1.82%)*
>                 14.29%             2.10%            12.50%             9.55%        
>    10240     12868.58 ( 0.00%)  12991.65 ( 0.95%)  10892.20 (-18.14%)  13106.01 ( 1.81%) 
>    12288     11854.97 ( 0.00%)  12122.34 ( 2.21%)* 12129.79 ( 2.27%)* 12411.84 ( 4.49%)*
>                  1.00%             6.61%             5.78%             8.95%        
>    14336     12552.48 ( 0.00%)* 12501.71 (-0.41%)* 12274.54 (-2.26%)  12322.63 (-1.87%)*
>                  6.05%             2.58%             1.00%             2.23%        
>    16384     11733.09 ( 0.00%)* 12735.05 ( 7.87%)* 13195.68 (11.08%)* 14401.62 (18.53%) 
>                  1.14%             9.79%            10.30%             1.00%        
> 
> The results for the patches are a bit all over the place for TCP_STREAM
> with big gains and losses depending on the packet size, particularly 6144
> for some reason. SLUB vs SLAB shows SLAB often has really massive advantages
> and this is not always for the larger packet sizes where the page allocator
> might be a suspect.
> 

TCP_STREAM stresses a few specific caches:

		ALLOC_FASTPATH	ALLOC_SLOWPATH	FREE_FASTPATH	FREE_SLOWPATH
kmalloc-256	3868530		3450592		95628		7223491
kmalloc-1024	2440434		429		2430825		10034
kmalloc-4096	3860625		1036723		85571		4811779

This demonstrates that freeing to full (or partial) slabs causes a lot of 
pain since the fastpath normally can't be utilized and that's probably 
beyond the scope of this patchset.

It's also different from the cpu slab thrashing issue I identified with 
the TCP_RR benchmark and had a patchset to somewhat improve.  The 
criticism was the addition of an increment to a fastpath counter in struct 
kmem_cache_cpu which could probably now be much cheaper with these 
optimizations.

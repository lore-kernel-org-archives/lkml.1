Return-Path: <linux-kernel-owner+w=401wt.eu-S1754856AbZJPSkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbZJPSkv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 14:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbZJPSku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 14:40:50 -0400
Received: from smtp-out.google.com ([216.239.45.13]:21908 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754737AbZJPSks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 14:40:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=u6gLOedvYAJvIey5S0MCtT/p9p5VPz+ZF3F35/1/lHHC4nsbe4T3ht4sIT1cStGpL
	j4D91+0R+FJO290PZUB+w==
Date: Fri, 16 Oct 2009 11:40:45 -0700 (PDT)
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
In-Reply-To: <20091016105016.GB32397@csn.ul.ie>
Message-ID: <alpine.DEB.1.00.0910161135350.21328@chino.kir.corp.google.com>
References: <4AD4D8B6.6010700@cs.helsinki.fi> <alpine.DEB.1.10.0910131541290.7246@gentwo.org> <alpine.DEB.1.00.0910131305440.3529@chino.kir.corp.google.com> <alpine.DEB.1.10.0910131625370.13756@gentwo.org> <alpine.DEB.1.00.0910131550050.15347@chino.kir.corp.google.com>
 <20091014133457.GB5027@csn.ul.ie> <alpine.DEB.1.10.0910141003590.9944@gentwo.org> <20091014154944.GD5027@csn.ul.ie> <4AD5F3F8.8080603@cs.helsinki.fi> <alpine.DEB.1.10.0910141154320.26476@gentwo.org> <20091016105016.GB32397@csn.ul.ie>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Oct 2009, Mel Gorman wrote:

> NETPERF TCP
>               SLUB-vanilla   vanilla-highorder     SLUB-this-cpu  this-cpu-highorder    SLAB-vanilla     SLAB-this-cpu
>       64  1773.00 ( 0.00%)   1812.07 ( 2.16%)*  1731.63 (-2.39%)*  1717.99 (-3.20%)*  1794.48 ( 1.20%)   2029.46 (12.64%) 
>              1.00%             5.88%             2.43%             2.83%             1.00%             1.00%        
>      128  3181.12 ( 0.00%)   3193.06 ( 0.37%)*  3471.22 ( 8.36%)   3154.79 (-0.83%)   3296.37 ( 3.50%)   3251.33 ( 2.16%) 
>              1.00%             1.70%             1.00%             1.00%             1.00%             1.00%        
>      256  4794.35 ( 0.00%)   4813.37 ( 0.40%)   4797.38 ( 0.06%)   4819.16 ( 0.51%)   4912.99 ( 2.41%)   4846.86 ( 1.08%) 
>     1024  9438.10 ( 0.00%)   8144.02 (-15.89%)   8681.05 (-8.72%)*  8204.11 (-15.04%)   8270.58 (-14.12%)   8268.85 (-14.14%) 
>              1.00%             1.00%             7.31%             1.00%             1.00%             1.00%        
>     2048  9196.06 ( 0.00%)  11233.72 (18.14%)   9375.72 ( 1.92%)  10487.89 (12.32%)* 11474.59 (19.86%)   9420.01 ( 2.38%) 
>              1.00%             1.00%             1.00%             9.43%             1.00%             1.00%        
>     3312 10338.49 ( 0.00%)*  9730.79 (-6.25%)* 10021.82 (-3.16%)* 10089.90 (-2.46%)* 12018.72 (13.98%)* 12069.28 (14.34%)*
>              9.49%             2.51%             6.36%             5.96%             1.21%             2.12%        
>     4096  9931.20 ( 0.00%)* 12447.88 (20.22%)  10285.38 ( 3.44%)* 10548.56 ( 5.85%)* 12265.59 (19.03%)* 10175.33 ( 2.40%)*
>              1.31%             1.00%             1.38%             8.22%             9.97%             8.33%        
>     6144 12775.08 ( 0.00%)* 10489.24 (-21.79%)* 10559.63 (-20.98%)  11033.15 (-15.79%)* 13139.34 ( 2.77%)  13210.79 ( 3.30%)*
>              1.45%             8.46%             1.00%            12.65%             1.00%             2.99%        
>     8192 10933.93 ( 0.00%)* 10340.42 (-5.74%)* 10534.41 (-3.79%)* 10845.36 (-0.82%)* 10876.42 (-0.53%)* 10738.25 (-1.82%)*
>             14.29%             2.38%             2.10%             1.83%            12.50%             9.55%        
>    10240 12868.58 ( 0.00%)  11211.60 (-14.78%)* 12991.65 ( 0.95%)  11330.97 (-13.57%)* 10892.20 (-18.14%)  13106.01 ( 1.81%) 
>              1.00%            11.36%             1.00%             6.64%             1.00%             1.00%        
>    12288 11854.97 ( 0.00%)  11854.51 (-0.00%)  12122.34 ( 2.21%)* 12258.61 ( 3.29%)* 12129.79 ( 2.27%)* 12411.84 ( 4.49%)*
>              1.00%             1.00%             6.61%             5.69%             5.78%             8.95%        
>    14336 12552.48 ( 0.00%)* 12309.15 (-1.98%)  12501.71 (-0.41%)* 13683.57 ( 8.27%)* 12274.54 (-2.26%)  12322.63 (-1.87%)*
>              6.05%             1.00%             2.58%             2.46%             1.00%             2.23%        
>    16384 11733.09 ( 0.00%)* 11856.66 ( 1.04%)* 12735.05 ( 7.87%)* 13482.61 (12.98%)* 13195.68 (11.08%)* 14401.62 (18.53%) 
>              1.14%             1.05%             9.79%            11.52%            10.30%             1.00%        
> 
> Configuring high-rder helper in a few cases here and in one or two
> cases close the gap with SLAB, particularly for large packet sizes.
> However, it still suffered for the small packet sizes.
> 

This is understandable considering the statistics that I posted for this 
workload on my machine, higher order cpu slabs will naturally get freed to 
more often from the fastpath, which also causes it to utilize the 
allocation fastpath more often (and we can see the optimization of this 
patchset), in addition to avoiding partial list handling.

The pain with the smaller packet sizes is probably the overhead from the 
page allocator more than slub, a characteristic that also caused the 
TCP_RR benchmark to suffer.  It can be mitigated somewhat with slab 
preallocation or a higher min_partial setting, but that's probably not an 
optimal solution.

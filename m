Return-Path: <linux-kernel-owner+w=401wt.eu-S1753252AbZJNBe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbZJNBe1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 21:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbZJNBe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 21:34:26 -0400
Received: from smtp-out.google.com ([216.239.33.17]:14724 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbZJNBeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 21:34:25 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=ErFTkNsxLDHPzeWV5TMGEc54ksokDOCWL1rcuZBmk5YZ/3wfdBx0oTgisFErvqe8c
	Yb7XBw1sgWbDV1ga+TjYg==
Date: Tue, 13 Oct 2009 18:33:06 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux-foundation.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Mel Gorman <mel@csn.ul.ie>, Zhang Yanmin <yanmin_zhang@linux.intel.com>
Subject: Re: [this_cpu_xx V6 7/7] this_cpu: slub aggressive use of this_cpu
 operations in the hotpaths
In-Reply-To: <alpine.DEB.1.10.0910131041450.21608@gentwo.org>
Message-ID: <alpine.DEB.1.00.0910131829170.436@chino.kir.corp.google.com>
References: <20091007211024.442168959@gentwo.org> <20091007211053.378634196@gentwo.org> <4AD307A5.105@kernel.org> <84144f020910120614r529d8e4em9babe83a90e9371f@mail.gmail.com> <alpine.DEB.1.00.0910130231570.27262@chino.kir.corp.google.com>
 <alpine.DEB.1.10.0910131041450.21608@gentwo.org>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Oct 2009, Christoph Lameter wrote:

> > I ran 60-second netperf TCP_RR benchmarks with various thread counts over
> > two machines, both four quad-core Opterons.  I ran the trials ten times
> > each with both vanilla per-cpu#for-next at 9288f99 and with v6 of this
> > patchset.  The transfer rates were virtually identical showing no
> > improvement or regression with this patchset in this benchmark.
> >
> >  [ As I reported in http://marc.info/?l=linux-kernel&m=123839191416472,
> >    this benchmark continues to be the most significant regression slub has
> >    compared to slab. ]
> 
> Hmmm... Last time I ran the in kernel benchmarks this showed a reduction
> in cycle counts. Did not get to get my tests yet.
> 
> Can you also try the irqless hotpath?
> 

v6 of your patchset applied to percpu#for-next now at dec54bf "this_cpu: 
Use this_cpu_xx in trace_functions_graph.c" works fine, but when I apply 
the irqless patch from http://marc.info/?l=linux-kernel&m=125503037213262 
it hangs my netserver machine within the first 60 seconds when running 
this benchmark.  These kernels both include the fixes to kmem_cache_open() 
and dma_kmalloc_cache() you posted earlier.  I'll have to debug why that's 
happening before collecting results.

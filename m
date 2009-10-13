Return-Path: <linux-kernel-owner+w=401wt.eu-S934122AbZJMWyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934122AbZJMWyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 18:54:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761036AbZJMWyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 18:54:14 -0400
Received: from smtp-out.google.com ([216.239.45.13]:18114 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbZJMWyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 18:54:13 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=sWClKFp7W6IcHsKUBzjx12XPsTkt2gg80+AHcbImGu3HXmPh1aqjnJEowHeQpKAGo
	eYs9Sqi2G1MpmoMYx+1+g==
Date: Tue, 13 Oct 2009 15:53:00 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux-foundation.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Mel Gorman <mel@csn.ul.ie>, Zhang Yanmin <yanmin_zhang@linux.intel.com>
Subject: Re: [this_cpu_xx V6 7/7] this_cpu: slub aggressive use of this_cpu
 operations in the hotpaths
In-Reply-To: <alpine.DEB.1.10.0910131625370.13756@gentwo.org>
Message-ID: <alpine.DEB.1.00.0910131550050.15347@chino.kir.corp.google.com>
References: <20091007211024.442168959@gentwo.org> <20091007211053.378634196@gentwo.org> <4AD307A5.105@kernel.org> <84144f020910120614r529d8e4em9babe83a90e9371f@mail.gmail.com> <alpine.DEB.1.00.0910130231570.27262@chino.kir.corp.google.com>
 <alpine.DEB.1.10.0910131041450.21608@gentwo.org> <alpine.DEB.1.10.0910131509170.32394@gentwo.org> <4AD4D8B6.6010700@cs.helsinki.fi> <alpine.DEB.1.10.0910131541290.7246@gentwo.org> <alpine.DEB.1.00.0910131305440.3529@chino.kir.corp.google.com>
 <alpine.DEB.1.10.0910131625370.13756@gentwo.org>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Oct 2009, Christoph Lameter wrote:

> > For an optimized fastpath, I'd expect such a workload would result in at
> > least a slightly higher transfer rate.
> 
> There will be no improvements if the load is dominated by the
> instructions in the network layer or caching issues. None of that is
> changed by the path. It only reduces the cycle count in the fastpath.
> 

Right, but CONFIG_SLAB shows a 5-6% improvement over CONFIG_SLUB in the 
same workload so it shows that the slab allocator does have an impact in 
transfer rate.  I understand that the performance gain with this patchset, 
however, may not be representative with the benchmark since it also 
frequently uses the slowpath for kmalloc-256 about 25% of the time and the 
added code of the irqless patch may mask the fastpath gain.

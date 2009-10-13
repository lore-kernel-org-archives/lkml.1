Return-Path: <linux-kernel-owner+w=401wt.eu-S933629AbZJMJrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933629AbZJMJrN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 05:47:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755865AbZJMJrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 05:47:13 -0400
Received: from smtp-out.google.com ([216.239.45.13]:43019 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755365AbZJMJrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 05:47:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=i6/sR9nBkk6ruCqUeT+FAIfLTJEEvfKJE70suLEPK3L2nuojGpNqNH31ruA/RP3+L
	9XLQ3gmEhq3BZWob3pvQQ==
Date: Tue, 13 Oct 2009 02:45:56 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Mel Gorman <mel@csn.ul.ie>, Zhang Yanmin <yanmin_zhang@linux.intel.com>
Subject: Re: [this_cpu_xx V6 7/7] this_cpu: slub aggressive use of this_cpu
 operations in the hotpaths
In-Reply-To: <84144f020910120614r529d8e4em9babe83a90e9371f@mail.gmail.com>
Message-ID: <alpine.DEB.1.00.0910130231570.27262@chino.kir.corp.google.com>
References: <20091007211024.442168959@gentwo.org> <20091007211053.378634196@gentwo.org> <4AD307A5.105@kernel.org> <84144f020910120614r529d8e4em9babe83a90e9371f@mail.gmail.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Oct 2009, Pekka Enberg wrote:

> The patch looks sane to me but the changelog contains no relevant
> numbers on performance. I am fine with the patch going in -percpu but
> the patch probably needs some more beating performance-wise before it
> can go into .33. I'm CC'ing some more people who are known to do SLAB
> performance testing just in case they're interested in looking at the
> patch. In any case,
> 

I ran 60-second netperf TCP_RR benchmarks with various thread counts over 
two machines, both four quad-core Opterons.  I ran the trials ten times 
each with both vanilla per-cpu#for-next at 9288f99 and with v6 of this 
patchset.  The transfer rates were virtually identical showing no 
improvement or regression with this patchset in this benchmark.

 [ As I reported in http://marc.info/?l=linux-kernel&m=123839191416472, 
   this benchmark continues to be the most significant regression slub has 
   compared to slab. ]

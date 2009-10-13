Return-Path: <linux-kernel-owner+w=401wt.eu-S934297AbZJMUQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934297AbZJMUQn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 16:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755959AbZJMUQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 16:16:43 -0400
Received: from smtp-out.google.com ([216.239.45.13]:35230 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780AbZJMUQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 16:16:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=WSEQKH43ACZFPlyzZxk6curmyrQu5Ld5fRs6Q+Wqksy8q0BXecs7YoWoQi01mNyDj
	ax3H1hBgWc8wAQ/H9jtuw==
Date: Tue, 13 Oct 2009 13:15:27 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux-foundation.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Mel Gorman <mel@csn.ul.ie>, Zhang Yanmin <yanmin_zhang@linux.intel.com>
Subject: Re: [this_cpu_xx V6 7/7] this_cpu: slub aggressive use of this_cpu
 operations in the hotpaths
In-Reply-To: <alpine.DEB.1.10.0910131541290.7246@gentwo.org>
Message-ID: <alpine.DEB.1.00.0910131305440.3529@chino.kir.corp.google.com>
References: <20091007211024.442168959@gentwo.org> <20091007211053.378634196@gentwo.org> <4AD307A5.105@kernel.org> <84144f020910120614r529d8e4em9babe83a90e9371f@mail.gmail.com> <alpine.DEB.1.00.0910130231570.27262@chino.kir.corp.google.com>
 <alpine.DEB.1.10.0910131041450.21608@gentwo.org> <alpine.DEB.1.10.0910131509170.32394@gentwo.org> <4AD4D8B6.6010700@cs.helsinki.fi> <alpine.DEB.1.10.0910131541290.7246@gentwo.org>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Oct 2009, Christoph Lameter wrote:

> > I wonder how reliable these numbers are. We did similar testing a while back
> > because we thought kmalloc-96 caches had weird cache behavior but finally
> > figured out the anomaly was explained by the order of the tests run, not cache
> > size.
> 
> Well you need to look behind these numbers to see when the allocator uses
> the fastpath or slow path. Only the fast path is optimized here.
> 

With the netperf -t TCP_RR -l 60 benchmark I ran, CONFIG_SLUB_STATS shows 
the allocation fastpath is utilized quite a bit for a couple of key 
caches:

	cache		ALLOC_FASTPATH	ALLOC_SLOWPATH
	kmalloc-256	98125871	31585955
	kmalloc-2048	77243698	52347453

For an optimized fastpath, I'd expect such a workload would result in at 
least a slightly higher transfer rate.

I'll try the irqless patch, but this particular benchmark may not 
appropriately demonstrate any performance gain because of the added code 
in the also significantly-used slowpath.

Return-Path: <linux-kernel-owner+w=401wt.eu-S934050AbZKXVWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934050AbZKXVWL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 16:22:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933487AbZKXVWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 16:22:10 -0500
Received: from smtp-out.google.com ([216.239.45.13]:29240 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933406AbZKXVWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 16:22:09 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=dHUr6xYlJEWNdP8YlzQ3dNOlbp7bit9iElX5K5B4VNVUxhRA9MvZvBBd0x+T/vBKX
	5c0kDPGjB6JEVDtAgJfLg==
Date: Tue, 24 Nov 2009 13:22:08 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Matt Mackall <mpm@selenic.com>, paulmck@linux.vnet.ibm.com,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
       Christoph Lameter <cl@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>
Subject: Re: lockdep complaints in slab allocator
In-Reply-To: <1259097150.4531.1822.camel@laptop>
Message-ID: <alpine.DEB.2.00.0911241313220.12339@chino.kir.corp.google.com>
References: <84144f020911192249l6c7fa495t1a05294c8f5b6ac8@mail.gmail.com> <1258709153.11284.429.camel@laptop> <84144f020911200238w3d3ecb38k92ca595beee31de5@mail.gmail.com> <1258714328.11284.522.camel@laptop> <4B067816.6070304@cs.helsinki.fi>
 <1258729748.4104.223.camel@laptop> <1259002800.5630.1.camel@penberg-laptop> <1259003425.17871.328.camel@calx> <4B0ADEF5.9040001@cs.helsinki.fi> <1259080406.4531.1645.camel@laptop> <20091124170032.GC6831@linux.vnet.ibm.com> <1259082756.17871.607.camel@calx>
 <1259086459.4531.1752.camel@laptop> <1259090615.17871.696.camel@calx>  <1259095580.4531.1788.camel@laptop> <1259096004.17871.716.camel@calx> <1259096519.4531.1809.camel@laptop> <alpine.DEB.2.00.0911241302370.6593@chino.kir.corp.google.com>
 <1259097150.4531.1822.camel@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Nov 2009, Peter Zijlstra wrote:

> > slqb still has a 5-10% performance regression compared to slab for 
> > benchmarks such as netperf TCP_RR on machines with high cpu counts, 
> > forcing that type of regression isn't acceptable.
> 
> Having _4_ slab allocators is equally unacceptable.
> 

So you just advocated to merging slqb so that it gets more testing and 
development, and then use its inclusion in a statistic to say we should 
remove others solely because the space is too cluttered?

We use slab partially because the regression in slub was too severe for 
some of our benchmarks, and while CONFIG_SLUB may be the kernel default 
there are still distros that use slab as the default as well.  We cannot 
simply remove an allocator that is superior to others because it is old or 
has increased complexity.

I'd suggest looking at how widely used slob is and whether it has a 
significant advantage over slub.  We'd then have two allocators for 
specialized workloads (and slub is much better for diagnostics) and one in 
development.

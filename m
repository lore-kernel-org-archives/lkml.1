Return-Path: <linux-kernel-owner+w=401wt.eu-S1759983AbZJGUEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759983AbZJGUEx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 16:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759973AbZJGUEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 16:04:52 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:41979 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759943AbZJGUEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 16:04:52 -0400
Date: Wed, 7 Oct 2009 12:42:31 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Tejun Heo <tj@kernel.org>, Mel Gorman <mel@csn.ul.ie>, mingo@elte.hu
Subject: Re: [this_cpu_xx V5 19/19] SLUB: Experimental new fastpath w/o
 interrupt disable
In-Reply-To: <20091007154111.GA12351@Krystal>
Message-ID: <alpine.DEB.1.10.0910071237430.3467@gentwo.org>
References: <20091006233654.815079668@gentwo.org> <20091006233733.153341605@gentwo.org> <20091007025440.GB4664@Krystal> <1254906707.26976.225.camel@twins> <20091007124628.GB27363@Krystal> <alpine.DEB.1.10.0910071039520.5671@gentwo.org> <20091007150257.GA8508@Krystal>
 <alpine.DEB.1.10.0910071102590.9984@gentwo.org> <20091007151940.GA10052@Krystal> <alpine.DEB.1.10.0910071119450.9296@gentwo.org> <20091007154111.GA12351@Krystal>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Oct 2009, Mathieu Desnoyers wrote:

> preempt_check_resched is basically:
>
> a test TIF_NEED_RESCHED
>   if true, call to preempt_schedule

You did not mention the effect of incrementing the preempt counter and
the barrier(). Adds an additional cacheline to a very hot OS path.
Possibly register effects.

> I really don't see what's bothering you here. Testing a thread flag is
> incredibly cheap. That's what is typically added to your fast path.

I am trying to get rid off all unnecessary overhead. These "incredible
cheap" tricks en masse have caused lots of regressions. And the allocator
hotpaths are overloaded with these "incredibly cheap" checks alreayd.

> So, correct behavior would be:
>
> preempt disable()
> fast path attempt
>   if (fast path already taken) {
>     local_irq_save();
>     slow path.
>     local_irq_restore();
>   }
> preempt_enable()

Ok. If you have to use preempt then you have to suffer I guess..


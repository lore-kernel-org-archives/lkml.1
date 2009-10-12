Return-Path: <linux-kernel-owner+w=401wt.eu-S1757057AbZJLPAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057AbZJLPAH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 11:00:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756540AbZJLPAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 11:00:06 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:58228 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756461AbZJLPAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 11:00:05 -0400
Date: Mon, 12 Oct 2009 10:52:29 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Tejun Heo <tj@kernel.org>, Mel Gorman <mel@csn.ul.ie>, mingo@elte.hu
Subject: Re: [this_cpu_xx V5 19/19] SLUB: Experimental new fastpath w/o
 interrupt disable
In-Reply-To: <20091012135600.GB15605@Krystal>
Message-ID: <alpine.DEB.1.10.0910121049580.32595@gentwo.org>
References: <20091007151940.GA10052@Krystal> <alpine.DEB.1.10.0910071119450.9296@gentwo.org> <1254988350.26976.256.camel@twins> <alpine.DEB.1.10.0910081211050.21951@gentwo.org> <20091008171750.GA3370@Krystal> <alpine.DEB.1.10.0910081342540.7735@gentwo.org>
 <20091008191754.GA12729@Krystal> <alpine.DEB.1.10.0910081520210.8030@gentwo.org> <20091008203724.GA15798@Krystal> <alpine.DEB.1.10.0910081652190.8030@gentwo.org> <20091012135600.GB15605@Krystal>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Oct 2009, Mathieu Desnoyers wrote:

> > In the middle of the function we have determine that we have to go to the
> > page allocator to get more memory. There is not much the compiler can do
> > to speed that up.
>
> Indeed, the compiler cannot do much about it. However, the programer
> (you) can move the preempt_enable_no_resched() part of the
> preempt_enable() to the beginning of the function.

Ok but then we have the issue that the later irq enable in the
slowpath will not check for preemption.

> > > I still recommend the preempt_enable_no_resched() at the beginning of
> > > __slab_alloc(), and simply putting a check_resched() here (which saves
> > > us the odd compiler barrier in the middle of function).
> >
> > Then preemption would be unnecessarily disabled for the page allocator
> > call?
>
> No ?
> preempt_enable_no_resched() enables preemption.

If I just enable interrupts there then the preempt check will not be
done and we may miss a scheduling point.


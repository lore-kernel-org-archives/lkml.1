Return-Path: <linux-kernel-owner+w=401wt.eu-S1759450AbZJGP3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759450AbZJGP3c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 11:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759445AbZJGP3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 11:29:32 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:35274 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759308AbZJGP3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 11:29:31 -0400
Date: Wed, 7 Oct 2009 11:05:42 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Tejun Heo <tj@kernel.org>, Mel Gorman <mel@csn.ul.ie>, mingo@elte.hu
Subject: Re: [this_cpu_xx V5 19/19] SLUB: Experimental new fastpath w/o
 interrupt disable
In-Reply-To: <20091007150257.GA8508@Krystal>
Message-ID: <alpine.DEB.1.10.0910071102590.9984@gentwo.org>
References: <20091006233654.815079668@gentwo.org> <20091006233733.153341605@gentwo.org> <20091007025440.GB4664@Krystal> <1254906707.26976.225.camel@twins> <20091007124628.GB27363@Krystal> <alpine.DEB.1.10.0910071039520.5671@gentwo.org>
 <20091007150257.GA8508@Krystal>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Oct 2009, Mathieu Desnoyers wrote:

> Usually, when preemption is disabled, the scheduler restrain from
> executing. *Now the important point*: the criterion that bounds the
> maximum amount of time before the scheduler will re-check for pending
> preemption is when preempt_enable() will re-activate preemption.

Which creates additional overhead in the allocator.

> But because you run preempt_enable with interrupts off, the scheduler
> check is not done. And it's not done when interrupts are re-activated
> neither.

Ok so we should be moving the preempt_enable after the irq enable. Then we
will call into the scheduler at the end of the slow path. This may add
significantly more overhead that we had before when we simply disabled
and enabled interrupts...



Return-Path: <linux-kernel-owner+w=401wt.eu-S932537AbZJGPUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537AbZJGPUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 11:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759352AbZJGPUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 11:20:19 -0400
Received: from tomts22.bellnexxia.net ([209.226.175.184]:41195 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759332AbZJGPUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 11:20:18 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlMFAFhJzEpMROOX/2dsb2JhbACBUtVHgjSBdgQ
Date: Wed, 7 Oct 2009 11:19:40 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Tejun Heo <tj@kernel.org>, Mel Gorman <mel@csn.ul.ie>, mingo@elte.hu
Subject: Re: [this_cpu_xx V5 19/19] SLUB: Experimental new fastpath w/o
	interrupt disable
Message-ID: <20091007151940.GA10052@Krystal>
References: <20091006233654.815079668@gentwo.org> <20091006233733.153341605@gentwo.org> <20091007025440.GB4664@Krystal> <1254906707.26976.225.camel@twins> <20091007124628.GB27363@Krystal> <alpine.DEB.1.10.0910071039520.5671@gentwo.org> <20091007150257.GA8508@Krystal> <alpine.DEB.1.10.0910071102590.9984@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0910071102590.9984@gentwo.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 11:16:49 up 50 days,  2:06,  3 users,  load average: 0.24, 0.27,
	0.25
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (cl@linux-foundation.org) wrote:
> On Wed, 7 Oct 2009, Mathieu Desnoyers wrote:
> 
> > Usually, when preemption is disabled, the scheduler restrain from
> > executing. *Now the important point*: the criterion that bounds the
> > maximum amount of time before the scheduler will re-check for pending
> > preemption is when preempt_enable() will re-activate preemption.
> 
> Which creates additional overhead in the allocator.
> 

Which we like to keep as low as possible, I agree.

> > But because you run preempt_enable with interrupts off, the scheduler
> > check is not done. And it's not done when interrupts are re-activated
> > neither.
> 
> Ok so we should be moving the preempt_enable after the irq enable. Then we
> will call into the scheduler at the end of the slow path. This may add
> significantly more overhead that we had before when we simply disabled
> and enabled interrupts...
> 

You are already calling the scheduler when ending the _fast_ path. I
don't see the problem with calling it when you end the slow path
execution.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

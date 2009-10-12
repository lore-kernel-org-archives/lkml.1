Return-Path: <linux-kernel-owner+w=401wt.eu-S932596AbZJLPj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596AbZJLPj1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 11:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932574AbZJLPj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 11:39:26 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:64813 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932572AbZJLPjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 11:39:24 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AigFABzo0kpMROOX/2dsb2JhbACBUdVfhC0E
Date: Mon, 12 Oct 2009 11:38:44 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Tejun Heo <tj@kernel.org>, Mel Gorman <mel@csn.ul.ie>, mingo@elte.hu
Subject: Re: [this_cpu_xx V5 19/19] SLUB: Experimental new fastpath w/o
	interrupt disable
Message-ID: <20091012153844.GA29116@Krystal>
References: <20091008171750.GA3370@Krystal> <alpine.DEB.1.10.0910081342540.7735@gentwo.org> <20091008191754.GA12729@Krystal> <alpine.DEB.1.10.0910081520210.8030@gentwo.org> <20091008203724.GA15798@Krystal> <alpine.DEB.1.10.0910081652190.8030@gentwo.org> <20091012135600.GB15605@Krystal> <alpine.DEB.1.10.0910121049580.32595@gentwo.org> <20091012152627.GA27835@Krystal> <alpine.DEB.1.10.0910121122400.21558@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0910121122400.21558@gentwo.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 11:36:15 up 55 days,  2:25,  3 users,  load average: 0.54, 0.35,
	0.25
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (cl@linux-foundation.org) wrote:
> On Mon, 12 Oct 2009, Mathieu Desnoyers wrote:
> 
> > > If I just enable interrupts there then the preempt check will not be
> > > done and we may miss a scheduling point.
> > >
> >
> > That's why you should do:
> >
> > local_irq_save()
> > preempt_enable_no_resched()
> > ...
> > local_irq_restore()
> > preempt_check_resched()
> 
> What is the difference then to
> 
> local_irq_save()
> 
> ...
> 
> local_irq_enable();
> preempt_enable();
> 
> ?

local_irq_save()
preempt_enable_no_resched()  <- barrier()
...
local_irq_enable()
preempt_check_resched()

vs

local_irq_save()
...
local_irq_enable();
preempt_enable(); <- barrier()

In the first scenario, the compiler barrier is at the beginning of the
slow path function, which should impose less restrictions on the compiler
optimizations.

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

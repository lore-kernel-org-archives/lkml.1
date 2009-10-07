Return-Path: <linux-kernel-owner+w=401wt.eu-S932816AbZJGOfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816AbZJGOfX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 10:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758590AbZJGOfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 10:35:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:36482 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758579AbZJGOfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 10:35:20 -0400
Subject: Re: [this_cpu_xx V5 19/19] SLUB: Experimental new fastpath w/o
 interrupt disable
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: cl@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Tejun Heo <tj@kernel.org>, Mel Gorman <mel@csn.ul.ie>, mingo@elte.hu
In-Reply-To: <20091007133106.GC29632@Krystal>
References: <20091006233654.815079668@gentwo.org>
	 <20091006233733.153341605@gentwo.org> <20091007025440.GB4664@Krystal>
	 <1254906707.26976.225.camel@twins> <20091007124628.GB27363@Krystal>
	 <1254920460.26976.241.camel@twins>  <20091007133106.GC29632@Krystal>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 07 Oct 2009 16:37:13 +0200
Message-Id: <1254926233.26976.250.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-07 at 09:31 -0400, Mathieu Desnoyers wrote:
> * Peter Zijlstra (peterz@infradead.org) wrote:
> > On Wed, 2009-10-07 at 08:46 -0400, Mathieu Desnoyers wrote:
> > > * local_irq_restore
> > >   -> the interrupt line is low. The scheduler won't be called. There is
> > >      no preempt_check_resched() call.
> > 
> > That would be an issue with all irq disable sections, so I don't think
> > this is actually true.
> > 
> 
> AFAIK, irq disable sections rely on the fact that if you get a timer
> interrupt during this section, the timer interrupt line stays triggered
> for the duration of the irqoff section. Therefore, when interrupts are
> re-enabled, the interrupt kicks in, so does the scheduler.
> 
> This is not the case with the preempt/irqoff dance proposed by
> Christoph.

Ah, you're quite right indeed.


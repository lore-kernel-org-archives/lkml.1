Return-Path: <linux-kernel-owner+w=401wt.eu-S1756767AbYHUM5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767AbYHUM5L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 08:57:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753076AbYHUM45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 08:56:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:54882 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbYHUM45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 08:56:57 -0400
Subject: Re: [PATCH] sched: properly account IRQ and RT load in SCHED_OTHER
	load balancing
From: Peter Zijlstra <peterz@infradead.org>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <nickpiggin@yahoo.com.au>,
       vatsa <vatsa@in.ibm.com>, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <48AD63DD.7000701@novell.com>
References: <1219310330.8651.93.camel@twins>
	 <1219322602.8651.123.camel@twins>  <48AD63DD.7000701@novell.com>
Content-Type: text/plain
Date: Thu, 21 Aug 2008 14:56:42 +0200
Message-Id: <1219323402.8651.126.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-21 at 08:47 -0400, Gregory Haskins wrote:
> Peter Zijlstra wrote:
> > OK, how overboard is this? (utterly uncompiled and such)
> >
> > I realized while trying to do the (soft)irq accounting Ingo asked for,
> > that IRQs can preempt SoftIRQs which can preempt RT tasks.
> >
> > Therefore we actually need to account all these times, so that we can
> > subtract irq time from measured softirq time, etc.
> >
> > So this patch does all that.. we could even use this more accurate time
> > spend on the task delta to drive the scheduler.
> >
> > NOTE - for now I've only considered softirq from hardirq time, as
> > ksoftirqd is its own task and is already accounted the regular way.
> >   
> 
> Actually, if you really want to get crazy, you could account for each RT 
> prio level as well ;)
> 
> e.g. RT98 tasks have to account for RT99 + softirqs + irqs, RT97 need to 
> look at RT98, 99, softirqs, irqs, etc.
> 
> I'm not suggesting we do this, per se.   Just food for thought.  It 
> would have the benefit of allowing us to make even better routing 
> decisions for RT tasks.  E.g. if cores 2 and 6 both have the lowest 
> priority, we currently sort by sched-domain topology, but we could also 
> factor in the load that is "above" us.

I'll let you be that crazy ;-) It'd be a 3-rd order placement decision,
I doubt that's going to make a large difference.


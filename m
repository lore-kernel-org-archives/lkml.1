Return-Path: <linux-kernel-owner+w=401wt.eu-S1754925AbYDHI45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925AbYDHI45 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 04:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751781AbYDHI4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 04:56:50 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:56580 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbYDHI4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 04:56:49 -0400
Date: Tue, 8 Apr 2008 14:26:37 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       mathieu.desnoyers@polymtl.ca, mingo@elte.hu, hch@infradead.org,
       mmlnx@us.ibm.com, dipankar@in.ibm.com, dsmith@redhat.com,
       rostedt@goodmis.org, adrian.bunk@movial.fi, a.p.zijlstra@chello.nl,
       niv@us.ibm.com, dvhltc@us.ibm.com, rusty@au1.ibm.com,
       jkenisto@linux.vnet.ibm.com, oleg@tv-sign.ru
Subject: Re: [PATCH,RFC] Add call_rcu_sched()
Message-ID: <20080408085637.GA30496@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20080321143615.GA936@linux.vnet.ibm.com> <20080321224026.GA10169@linux.vnet.ibm.com> <20080406213719.GA10533@linux.vnet.ibm.com> <20080408003449.873574d7.akpm@linux-foundation.org> <20080408081048.GA15001@in.ibm.com> <20080408013936.b84ae895.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080408013936.b84ae895.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2008 at 01:39:36AM -0700, Andrew Morton wrote:
> On Tue, 8 Apr 2008 13:40:48 +0530 Gautham R Shenoy <ego@in.ibm.com> wrote:
> 
> > > > +			rdp = RCU_DATA_CPU(cpu);
> >                                                                <-- here ------\
> > > > +			spin_lock_irqsave(&rdp->lock, flags);                   |
> > > > +                                                                         |
> > > > +			/*                                                      |
> > > > +			 * We are running on this CPU irq-disabled, so no       |
> > > > +			 * CPU can go offline until we re-enable irqs.          |
> > >                                                                             |
> > > but, but, but.  The cpu at `cpu' could have gone offline just before we     |
> > > disabled local interrupts.                                                  |
> >                                                                               |
> > In that case the CPU_DEAD callback should have migrated the rcu-lists to      |
> > a cpu which is online.                                                        |
>                                                                                 |
> But local variable rdp might be pointing at the now-offlined CPU's data? -------/

Right. But then rdp wouldn't contain anything useful at this point.
So, we may only end up taking the rdp->lock, observe that there's nothing to do,
and move on.

Is there something else that I am missing?

-- 
Thanks and Regards
gautham

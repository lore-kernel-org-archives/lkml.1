Return-Path: <linux-kernel-owner+w=401wt.eu-S1755561AbYDHIlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561AbYDHIlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 04:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbYDHIlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 04:41:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42177 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751290AbYDHIlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 04:41:13 -0400
Date: Tue, 8 Apr 2008 01:39:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ego@in.ibm.com
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       mathieu.desnoyers@polymtl.ca, mingo@elte.hu, hch@infradead.org,
       mmlnx@us.ibm.com, dipankar@in.ibm.com, dsmith@redhat.com,
       rostedt@goodmis.org, adrian.bunk@movial.fi, a.p.zijlstra@chello.nl,
       niv@us.ibm.com, dvhltc@us.ibm.com, rusty@au1.ibm.com,
       jkenisto@linux.vnet.ibm.com, oleg@tv-sign.ru
Subject: Re: [PATCH,RFC] Add call_rcu_sched()
Message-Id: <20080408013936.b84ae895.akpm@linux-foundation.org>
In-Reply-To: <20080408081048.GA15001@in.ibm.com>
References: <20080321143615.GA936@linux.vnet.ibm.com>
	<20080321224026.GA10169@linux.vnet.ibm.com>
	<20080406213719.GA10533@linux.vnet.ibm.com>
	<20080408003449.873574d7.akpm@linux-foundation.org>
	<20080408081048.GA15001@in.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Apr 2008 13:40:48 +0530 Gautham R Shenoy <ego@in.ibm.com> wrote:

> > > +			rdp = RCU_DATA_CPU(cpu);
>                                                                <-- here ------\
> > > +			spin_lock_irqsave(&rdp->lock, flags);                   |
> > > +                                                                         |
> > > +			/*                                                      |
> > > +			 * We are running on this CPU irq-disabled, so no       |
> > > +			 * CPU can go offline until we re-enable irqs.          |
> >                                                                             |
> > but, but, but.  The cpu at `cpu' could have gone offline just before we     |
> > disabled local interrupts.                                                  |
>                                                                               |
> In that case the CPU_DEAD callback should have migrated the rcu-lists to      |
> a cpu which is online.                                                        |
                                                                                |
But local variable rdp might be pointing at the now-offlined CPU's data? -------/

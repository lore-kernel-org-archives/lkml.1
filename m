Return-Path: <linux-kernel-owner+w=401wt.eu-S1753909AbZCREha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbZCREha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 00:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751180AbZCREhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 00:37:20 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:47920 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbZCREhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 00:37:19 -0400
Date: Wed, 18 Mar 2009 10:06:50 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       a.p.zijlstra@chello.nl, ego@in.ibm.com, mingo@elte.hu,
       andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, arjan@infradead.org,
       svaidy@linux.vnet.ibm.com
Subject: Re: [v3 PATCH 2/4] timers: Identifying the existing pinned timers
Message-ID: <20090318043650.GA7138@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20090316111045.GA4686@linux.vnet.ibm.com> <20090316111337.GC4686@linux.vnet.ibm.com> <alpine.LFD.2.00.0903171401190.29264@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903171401190.29264@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Gleixner <tglx@linutronix.de> [2009-03-17 14:07:44]:

> On Mon, 16 Mar 2009, Arun R Bharadwaj wrote:
> > * Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-03-16 16:40:45]:
> > 
> > The following pinned hrtimers have been identified and marked:
> > 1)sched_rt_period_timer
> > 2)tick_sched_timer
> > 3)stack_trace_timer_fn
> 
> How did you verify that these are the only timers which need to be
> pinned ?
>

Until 2.6.28, there was a callback mode called HRTIMER_CB_IRQSAFE_PERCPU
which did not allow timers to be migrated, if set.
These were the only 3 hrtimers which were using that callback mode.

--arun

> Can we be sure that there is no code which relies on the current
> behaviour to keep functionality tied together ? Networking and block
> layer comes to mind.
> 
> Thanks,
> 
> 	tglx

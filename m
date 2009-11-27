Return-Path: <linux-kernel-owner+w=401wt.eu-S1753089AbZK0EUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089AbZK0EUE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 23:20:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751882AbZK0EUC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 23:20:02 -0500
Received: from ozlabs.org ([203.10.76.45]:49909 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854AbZK0EUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 23:20:01 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19215.18562.408682.656799@drongo.ozlabs.ibm.com>
Date: Fri, 27 Nov 2009 14:33:22 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/4 tip/sched/core] sched: rename preempt_notifier to
 sched_notifier and always enable it
In-Reply-To: <20091126102936.GA1196@elte.hu>
References: <20091126190018.88a6dd77.sfr@canb.auug.org.au>
	<20091126081237.GA31034@elte.hu>
	<4B0E4741.10509@kernel.org>
	<20091126092631.GA17253@elte.hu>
	<4B0E4EFB.2070705@kernel.org>
	<20091126095154.GE32275@elte.hu>
	<4B0E5458.30303@kernel.org>
	<20091126102936.GA1196@elte.hu>
X-Mailer: VM 8.0.12 under 22.3.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> The sched notifiers and the various event notifiers we have in the same 
> codepaths should really be unified into a single callback framework.
> 
> We have these _5_ callbacks:
> 
> ...
>         perf_event_task_sched_out(prev, next, cpu);
> ...
>         fire_sched_out_notifiers(prev, next);
> ...
>         trace_sched_switch(rq, prev, next);
> ...
>         perf_event_task_sched_in(current, cpu_of(rq));
> 	fire_sched_in_notifiers(current);
> ...
> 
> That could be done with just two callbacks - one for sched-out, one for 
> sched-in.
> 
> The best way to do that would be to use two TRACE_EVENT() callbacks, 
> make them unconditional and register to them. (with wrappers to make it 
> all convenient to use)

I'd rather 5 explicit direct function calls than two direct calls and
five indirect function calls, actually...

Paul.

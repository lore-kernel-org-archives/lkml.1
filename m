Return-Path: <linux-kernel-owner+w=401wt.eu-S1754253AbYJ0UNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253AbYJ0UNx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 16:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752964AbYJ0UN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 16:13:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:34823 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbYJ0UNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 16:13:23 -0400
Date: Mon, 27 Oct 2008 16:13:21 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Frank Ch. Eigler" <fche@redhat.com>
cc: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       lenb@kernel.org
Subject: Re: PATCH] ftrace: Add a C/P state tracer to help power
 optimization
In-Reply-To: <y0m3aihx1kd.fsf@ton.toronto.redhat.com>
Message-ID: <alpine.DEB.1.10.0810271610590.13777@gandalf.stny.rr.com>
References: <20081006102640.481acd23@infradead.org> <20081027155920.GS5704@elte.hu> <20081027110522.6cb7b142@infradead.org> <y0m3aihx1kd.fsf@ton.toronto.redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 27 Oct 2008, Frank Ch. Eigler wrote:

> 
> Arjan van de Ven <arjan@infradead.org> writes:
> 
> > [...]
> > --- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> > +++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> > [...]
> > @@ -427,6 +429,8 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
> >  		}
> >  	}
> >  
> > +	trace_power_mark(&it, POWER_PSTATE, next_perf_state);
> > +
> >  	switch (data->cpu_feature) {
> >  	case SYSTEM_INTEL_MSR_CAPABLE:
> >  		cmd.type = SYSTEM_INTEL_MSR_CAPABLE;
> > [...]
> 
> Is there some reason that this doesn't use tracepoints instead
> of such a single-backend hook?

Yeah, this should be converted to a trace_point. See include/trace/sched.h 
for examples.

The users are in kernel/sched.c.  Just add "trace_" in front of the names 
to find the users. Then you can look at kernel/trace/trace_sched_switch.c 
to see an example on how to hook into it.

-- Steve


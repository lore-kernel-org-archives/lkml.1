Return-Path: <linux-kernel-owner+w=401wt.eu-S1752943AbYJ0TsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943AbYJ0TsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 15:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbYJ0TsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 15:48:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45132 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954AbYJ0TsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 15:48:08 -0400
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, lenb@kernel.org
Subject: Re: PATCH] ftrace: Add a C/P state tracer to help power optimization
References: <20081006102640.481acd23@infradead.org>
	<20081027155920.GS5704@elte.hu>
	<20081027110522.6cb7b142@infradead.org>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Mon, 27 Oct 2008 15:47:30 -0400
In-Reply-To: <20081027110522.6cb7b142@infradead.org> (Arjan van de Ven's message of "Mon, 27 Oct 2008 11:05:22 -0700")
Message-ID: <y0m3aihx1kd.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Arjan van de Ven <arjan@infradead.org> writes:

> [...]
> --- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> +++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> [...]
> @@ -427,6 +429,8 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
>  		}
>  	}
>  
> +	trace_power_mark(&it, POWER_PSTATE, next_perf_state);
> +
>  	switch (data->cpu_feature) {
>  	case SYSTEM_INTEL_MSR_CAPABLE:
>  		cmd.type = SYSTEM_INTEL_MSR_CAPABLE;
> [...]

Is there some reason that this doesn't use tracepoints instead
of such a single-backend hook?


- FChE

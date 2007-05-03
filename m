Return-Path: <linux-kernel-owner+w=401wt.eu-S1751878AbXECUOD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbXECUOD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 16:14:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754265AbXECUOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 16:14:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54014 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878AbXECUOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 16:14:00 -0400
Message-ID: <463A421C.4080507@redhat.com>
Date: Thu, 03 May 2007 16:12:12 -0400
From: Steven Rostedt <srostedt@redhat.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Daniel Walker <dwalker@mvista.com>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -rt] wrong usage of smp_processor_id()
References: <20070503200822.696754319@mvista.com>
In-Reply-To: <20070503200822.696754319@mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker wrote:

> ---
>  kernel/latency_trace.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6.21/kernel/latency_trace.c
> ===================================================================
> --- linux-2.6.21.orig/kernel/latency_trace.c
> +++ linux-2.6.21/kernel/latency_trace.c
> @@ -105,7 +105,7 @@ static inline int DEBUG_WARN_ON(int cond
>  #ifdef CONFIG_CRITICAL_IRQSOFF_TIMING
>  # ifdef CONFIG_CRITICAL_PREEMPT_TIMING
>     static DEFINE_PER_CPU(int, trace_cpu_idle);
> -#  define irqs_off_preempt_count() (!__get_cpu_var(trace_cpu_idle) && preempt_count())
> +#  define irqs_off_preempt_count() (preempt_count() && !__get_cpu_var(trace_cpu_idle))
>  # else
>  #  define irqs_off_preempt_count() 0
>  # endif

Ingo,

This is on top of one of my patches that I sent you (the cpu idle one). 
So it's not for the 2.6.21-rt1, but if you apply my patch, this needs to 
be added too.

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve



Return-Path: <linux-kernel-owner+w=401wt.eu-S1756081AbZCELEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081AbZCELEy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 06:04:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755600AbZCELEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 06:04:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58350 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755569AbZCELEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 06:04:42 -0500
Date: Thu, 5 Mar 2009 12:04:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] tracing/function-graph-tracer: use the more
	lightweight local clock
Message-ID: <20090305110433.GH32407@elte.hu>
References: <49af243d.06e9300a.53ad.ffff840c@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49af243d.06e9300a.53ad.ffff840c@mx.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Impact: decrease hangs risks with the graph tracer on slow systems
> 
> Since the function graph tracer can spend too much time on 
> timer interrupts, it's better now to use the more lightweight 
> local clock. Anyway, the function graph traces are more 
> reliable on a per cpu trace.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  arch/x86/kernel/ftrace.c             |    2 +-
>  kernel/trace/trace_functions_graph.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> index 3925ec0..40960c2 100644
> --- a/arch/x86/kernel/ftrace.c
> +++ b/arch/x86/kernel/ftrace.c
> @@ -436,7 +436,7 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
>  		return;
>  	}
>  
> -	calltime = cpu_clock(raw_smp_processor_id());
> +	calltime = sched_clock();

I changed this to trace_clock_local() :-)

(btw, we should turn trace_clock_local() into an inline 
function)

There will be one problem though: function trace elapsed time 
measurements across idle. Those are not correctly measured by 
the local clock.

	Ingo

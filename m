Return-Path: <linux-kernel-owner+w=401wt.eu-S1757822AbZCYKM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822AbZCYKM3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 06:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086AbZCYKMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 06:12:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51260 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994AbZCYKMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 06:12:19 -0400
Date: Wed, 25 Mar 2009 11:11:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tim Bird <tim.bird@am.sony.com>, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 5/5][RFC] function-graph: add option to calculate graph
	time or not
Message-ID: <20090325101139.GJ2341@elte.hu>
References: <20090325035646.662994901@goodmis.org> <20090325040833.213388591@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325040833.213388591@goodmis.org>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> --- a/kernel/trace/trace_functions_graph.c
> +++ b/kernel/trace/trace_functions_graph.c
> @@ -104,9 +105,6 @@ ftrace_pop_return_trace(struct ftrace_graph_ret *trace, unsigned long *ret)
>  	trace->calltime = current->ret_stack[index].calltime;
>  	trace->overrun = atomic_read(&current->trace_overrun);
>  	trace->depth = index;
> -	barrier();
> -	current->curr_ret_stack--;
> -
>  }
>  
>  /*
> @@ -121,6 +119,8 @@ unsigned long ftrace_return_to_handler(void)
>  	ftrace_pop_return_trace(&trace, &ret);
>  	trace.rettime = trace_clock_local();
>  	ftrace_graph_return(&trace);
> +	barrier();
> +	current->curr_ret_stack--;

this will modify the regular graph tracer too. No discussion of this 
change in the changelog - is it a fix?

	Ingo

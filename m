Return-Path: <linux-kernel-owner+w=401wt.eu-S1756658AbZBKMGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658AbZBKMGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 07:06:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754795AbZBKMGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 07:06:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55090 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754497AbZBKMGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 07:06:41 -0500
Date: Wed, 11 Feb 2009 13:06:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH tip 1/1] tracing: Use a single trace_enabled variable
Message-ID: <20090211120632.GE23873@elte.hu>
References: <20090209211535.GA12820@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090209211535.GA12820@ghostprotocols.net>
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


* Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> Impact: API change/cleanup
> 
> $ codiff kernel/trace/built-in.o.before kernel/trace/built-in.o
> kernel/trace/trace.c:
>   tracing_is_enabled |  -12
>   __find_next_entry  |   -5
>  2 functions changed, 17 bytes removed, diff: -17
> 
> kernel/trace/trace_sched_switch.c:
>   tracing_sched_switch_assign_trace |  -13
>   tracing_stop_sched_switch_record  |  -74
>   tracing_start_sched_switch_record |  -30
>  3 functions changed, 117 bytes removed, diff: -117
> 
> kernel/trace/trace_sysprof.c:
>   stack_trace_reset |  -10
>   stack_trace_init  |  -10
>  2 functions changed, 20 bytes removed, diff: -20
> 
> kernel/trace/trace_irqsoff.c:
>   irqsoff_tracer_start |  -16
>   irqsoff_tracer_stop  |  -16
>   irqsoff_tracer_reset |  -10
>   irqsoff_tracer_init  |  -19
>  4 functions changed, 61 bytes removed, diff: -61
> 
> kernel/trace/trace_sched_wakeup.c:
>   wakeup_tracer_stop  |  -16
>   wakeup_tracer_start |  -10
>   start_wakeup_tracer |  -19
>   wakeup_tracer_reset |  -10
>  4 functions changed, 55 bytes removed, diff: -55
> 
> kernel/trace/built-in.o:
>  15 functions changed, 270 bytes removed, diff: -270
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  kernel/trace/trace.c              |   15 +-------------
>  kernel/trace/trace.h              |    3 +-
>  kernel/trace/trace_irqsoff.c      |   22 --------------------
>  kernel/trace/trace_sched_switch.c |   40 +------------------------------------
>  kernel/trace/trace_sched_wakeup.c |   26 ------------------------
>  kernel/trace/trace_sysprof.c      |    5 +---
>  6 files changed, 5 insertions(+), 106 deletions(-)

Applied to tip:tracing/ftrace, thanks Arnaldo!

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753112AbZHFMYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbZHFMYy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 08:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbZHFMYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 08:24:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41769 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbZHFMYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 08:24:52 -0400
Date: Thu, 6 Aug 2009 14:24:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [GIT PULL] tracing: Various cleanups for 2.6.32, v2
Message-ID: <20090806122442.GA15314@elte.hu>
References: <20090802195312.GA18598@elte.hu> <1249540058-5528-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249540058-5528-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Ingo,
> 
> This new shot fixes the build errors you've reported after testing 
> the first version. The fact is that the trace_function() helper is 
> not only used by the function tracer but also by various other 
> tracing callsites.
> 
> Instead of keeping it in the function tracer file and paint it 
> with messy #ifdefs, I think it's better to keep it in the generic 
> trace.c because it's actually a general helper for various 
> tracers.
> 
> I've then zapped the trace_function() moving in the third patch 
> but kept one of its side effects necessary for the function graph 
> tracer helpers moving: the ftrace_cpu_disabled var globalizing.
> 
> This series also gained a new patch that shuts down a warning in 
> trace_events.c
> 
> Thanks,
> Frederic.
> 
> 
> 
> The following changes since commit 1f9963cbb0280e0cd554161e00f1a0eeddbf1ae1:
>   Li Zefan (1):
>         tracing/filters: improve subsystem filter
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git tracing/core
> 
> Frederic Weisbecker (6):
>       tracing/function-graph-tracer: Drop the useless nmi protection
>       tracing/core: Turn ftrace_cpu_disabled into a global var
>       tracing/core: Make the stack entry helpers global
>       tracing: Move sched event insertion helpers in the sched switch tracer file
>       tracing/function-graph-tracer: Move graph event insertion helpers in the graph tracer file
>       tracing/events: Only define remove_subsystem_dir() if CONFIG_MODULES
> 
> Lai Jiangshan (1):
>       tracing: Simplify print_graph_cpu()
> 
>  arch/x86/kernel/ftrace.c             |    4 -
>  kernel/trace/trace.c                 |  192 ++--------------------------------
>  kernel/trace/trace.h                 |   30 +++++-
>  kernel/trace/trace_events.c          |   52 +++++-----
>  kernel/trace/trace_functions_graph.c |  152 ++++++++++++++++++++++-----
>  kernel/trace/trace_sched_switch.c    |   57 ++++++++++
>  kernel/trace/trace_selftest.c        |    1 +
>  7 files changed, 243 insertions(+), 245 deletions(-)

Pulled, thanks Frederic!

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbZBIJi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbZBIJi0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 04:38:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752504AbZBIJiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 04:38:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42225 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430AbZBIJiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 04:38:17 -0500
Date: Mon, 9 Feb 2009 10:37:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/8] git pull request for tip/tracing/core
Message-ID: <20090209093751.GD7930@elte.hu>
References: <20090208054955.777429253@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090208054955.777429253@goodmis.org>
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

> Ingo,
> 
> I rebased the previous changes onto tip/tracing/core. The first patch
> is new, which is the elimination of the entry->cpu.
> 
> I did not remove it when it became obsolete, and thus we had
> other developers using it, thinking that it was the way to
> get the current cpu number. Unfortunately, the entry->cpu was
> just taking up space, and never was initialized.
> 
> The rest of the patches, I've posted before, but this time I ported
> them over to tip/tracing/core.
> 
> 
> The following patches are in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>     branch: tip/tracing/core/devel
> 
> 
> Steven Rostedt (7):
>       trace: remove deprecated entry->cpu
>       ring-buffer: add NMI protection for spinlocks
>       ring-buffer: allow tracing_off to be used in core kernel code
>       ftrace, x86: rename in_nmi variable
>       nmi: add generic nmi tracking state
>       ftrace: change function graph tracer to use new in_nmi
>       ring-buffer: use generic version of in_nmi
> 
> Wenji Huang (1):
>       trace: trivial fixes in comment typos.
> 
> ----
>  arch/x86/Kconfig                 |    1 +
>  arch/x86/kernel/ftrace.c         |   35 ++++++++---------------------------
>  include/linux/ftrace.h           |    2 +-
>  include/linux/ftrace_irq.h       |    2 +-
>  include/linux/hardirq.h          |   15 +++++++++++++++
>  include/linux/ring_buffer.h      |    9 +++++++++
>  kernel/trace/Kconfig             |    8 ++++++++
>  kernel/trace/ftrace.c            |    6 +++---
>  kernel/trace/ring_buffer.c       |   31 +++++++++++++++++++++++++++++--
>  kernel/trace/trace.c             |    2 +-
>  kernel/trace/trace.h             |    7 +++----
>  kernel/trace/trace_hw_branches.c |    3 +--
>  kernel/trace/trace_output.c      |    6 +++---
>  13 files changed, 83 insertions(+), 44 deletions(-)

Pulled into tip/tracing/ftrace, thanks Steve!

There was a conflict in kernel/trace/trace_hw_branches.c - i resolved it,
please double-check the end result.

One small detail, for future pull requests to me, could you please use the
customary "tracing: " tags for generic commits, instead the "trace: " tag
you started using recently? Thanks,

	Ingo

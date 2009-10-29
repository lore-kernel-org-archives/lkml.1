Return-Path: <linux-kernel-owner+w=401wt.eu-S1756596AbZJ2HHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596AbZJ2HHn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 03:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756557AbZJ2HHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 03:07:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58565 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756555AbZJ2HHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 03:07:42 -0400
Date: Thu, 29 Oct 2009 08:07:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Pavel Machek <pavel@ucw.cz>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf events: Remove CONFIG_EVENT_PROFILE
Message-ID: <20091029070731.GD12874@elte.hu>
References: <4AE93C93.9060607@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE93C93.9060607@cn.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
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


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> Quote from Ingo:
> 
> | This reminds me - i think we should eliminate CONFIG_EVENT_PROFILE -
> | it's an unnecessary Kconfig complication. If both PERF_EVENTS and
> | EVENT_TRACING is enabled we should expose generic tracepoints.
> |
> | Nor is it limited to event 'profiling', so it has become a misnomer as
> | well.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  include/linux/ftrace_event.h       |    2 +-
>  include/linux/perf_event.h         |    2 +-
>  include/linux/syscalls.h           |    4 ++--
>  include/trace/ftrace.h             |   12 ++++++------
>  include/trace/syscall.h            |    4 ++--
>  init/Kconfig                       |   13 -------------
>  kernel/perf_event.c                |    4 ++--
>  kernel/trace/Makefile              |    4 +++-
>  kernel/trace/trace_events_filter.c |    4 ++--
>  kernel/trace/trace_kprobe.c        |   14 +++++++-------
>  kernel/trace/trace_syscalls.c      |    4 ++--
>  11 files changed, 28 insertions(+), 39 deletions(-)

Thanks!

There's a logistical complication: this rename couples the pending perf 
tree with the pending tracing tree and that makes dependencies a bit 
awkward.

Would you mind to resend this patch in the merge window, to be merged 
soon after both the perf events and the tracing tree went uptream?

The rename/elimination itself looks fine and simple and shouldnt break 
anything, so we dont need to have it in the tracing and perf trees for 
long.

	Ingo

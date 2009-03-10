Return-Path: <linux-kernel-owner+w=401wt.eu-S1753772AbZCJJAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbZCJJAp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 05:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753867AbZCJJAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 05:00:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43288 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753639AbZCJJAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 05:00:23 -0400
Date: Tue, 10 Mar 2009 09:59:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "Martin J. Bligh" <mbligh@mbligh.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Larry Woodman <lwoodman@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>
Subject: Re: [PATCH 0/7] [GIT PULL] enhancements for tracing in tip
Message-ID: <20090310085946.GC3097@elte.hu>
References: <20090310045710.286915983@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090310045710.286915983@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> This patch series replaces the TRACE_EVENT_FORMAT with the new 
> TRACE_EVENT
> 
> NOTE: I started with a pull from tip/tracing/printk. It does 
> not show up as a merge since I did the pull at the point where 
> it forked. But by pulling this branch, you will also receive 
> your changes from tracing/printk. I rebased my changes off of 
> this pull so that my changes would be after the pull, making 
> this patch series cleaner.

(that's OK - tracing/printk is still an active branch.)

> Please pull the latest tip/tracing/ftrace tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/ftrace
> 
> 
> Steven Rostedt (7):
>       tracing: typecast sizeof and offsetof to unsigned int
>       tracing: replace TP<var> with TP_<var>
>       tracing: use generic __stringify
>       tracing: new format for specialized trace points
>       tracing: convert the sched trace points to the TRACE_EVENT macros
>       tracing: convert irq trace points to new macros
>       tracing: remove obsolete TRACE_EVENT_FORMAT macro
> 
> ----
>  Documentation/tracepoints.txt          |    8 +-
>  include/linux/tracepoint.h             |   10 +-
>  include/trace/block.h                  |   70 +++---
>  include/trace/irq_event_types.h        |   46 ++--
>  include/trace/lockdep_event_types.h    |   26 +-
>  include/trace/power.h                  |   12 +-
>  include/trace/sched_event_types.h      |  442 +++++++++++++++++++++++---------
>  include/trace/workqueue.h              |   16 +-
>  kernel/trace/events.c                  |    4 +-
>  kernel/trace/trace.h                   |    5 -
>  kernel/trace/trace_event_types.h       |   29 +-
>  kernel/trace/trace_events.c            |  174 +------------
>  kernel/trace/trace_events_stage_1.h    |   27 +-
>  kernel/trace/trace_events_stage_2.h    |   91 +++++--
>  kernel/trace/trace_events_stage_3.h    |   42 +---
>  kernel/trace/trace_export.c            |   41 +++-
>  kernel/trace/trace_format.h            |   55 ----
>  kernel/trace/trace_selftest.c          |    6 +-
>  samples/tracepoints/tp-samples-trace.h |    8 +-
>  19 files changed, 575 insertions(+), 537 deletions(-)

Pulled, thanks Steve! (i suspect you'll fix the %z thing Andrew 
noticed in the next drop.)

	Ingo

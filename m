Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758870Ab0CMHZ0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 02:25:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45298 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754445Ab0CMHZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 02:25:25 -0500
Date: Sat, 13 Mar 2010 08:25:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH 0/5][GIT PULL][2.6.34] tracing: urgent fixes
Message-ID: <20100313072512.GA4892@elte.hu>
References: <20100313025655.104950166@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100313025655.104950166@goodmis.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> Li Zefan and Lai Jiangshan told me they were finding various bugs
> with running a stress test. I asked for this test, and Li sent it
> to me. Running the test I was also able to trigger the same bugs that
> they were seeing. Unfortunately, these bugs were very hard to figure
> out and it took me most of the week to fix them.
> 
> These bugs would most likely not happen in normal use, since they
> all require multiple users writing to the control files of ftrace.
> This stress test does just that, it creates several processes that
> each write to a different part of a ftrace control system. One resizes
> the ring buffer, the other enables and disables various options,
> another changes the ftrace plugins, another enables and disables
> various events, another enables and disables the tracer, etc.
> 
> Normal use generally has a single user that would only do one of these
> actions at a time. But that is no excuse for not fixing the issues
> that this test uncovered, so I took this very seriously.
> 
> Even the fix "tracing: Disable buffer switching when starting or
> stopping trace" may look like it could happen if wakeup tracer is running,
> but since opening the trace file would cause the wakeup tracer to stop,
> it actually required another task to change the current tracer to
> the wakeup tracer while the trace file was being read.
> 
> In any event, I've been running Li's ftrace_stress_test for a few
> hours now, and it seems pretty stable with these patches. I'll continue
> to run it to see if it finds anything else.
> 
> All of these patches I consider urgent and have also Cc'd stable on them.
> 
> Please pull the latest tip/tracing/urgent tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/urgent
> 
> 
> Lai Jiangshan (1):
>       ring-buffer: Move disabled check into preempt disable section
> 
> Steven Rostedt (4):
>       function-graph: Init curr_ret_stack with ret_stack
>       tracing: Use same local variable when resetting the ring buffer
>       tracing: Disable buffer switching when starting or stopping trace
>       tracing: Do not record user stack trace from NMI context
> 
> ----
>  kernel/trace/ftrace.c      |    2 +-
>  kernel/trace/ring_buffer.c |   12 ++++++------
>  kernel/trace/trace.c       |   24 ++++++++++++++++++++----
>  3 files changed, 27 insertions(+), 11 deletions(-)

Pulled, thanks a lot Steve!

	Ingo

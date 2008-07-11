Return-Path: <linux-kernel-owner+w=401wt.eu-S1756899AbYGKOrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899AbYGKOrv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 10:47:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbYGKOrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 10:47:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41985 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287AbYGKOrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 10:47:42 -0400
Date: Fri, 11 Jul 2008 16:47:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] ftrace: updates
Message-ID: <20080711144725.GA23875@elte.hu>
References: <20080711005808.316194101@goodmis.org> <20080711135057.GC32159@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080711135057.GC32159@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Working on the ftrace.txt file proved to show some bugs with ftrace. 
> > These are a list of patches that I have accumulated for ftrace that 
> > solve those bugs (as well as other things).
> 
> applied them to tip/tracing/ftrace:
> 
>  Steven Rostedt (8):
>       ftrace: move sched_switch enable after markers
>       ftrace: define function trace nop
>       ftrace: trace schedule
>       ftrace: check proper config for preempt type
>       ftrace: start wakeup tracing after setting function tracer
>       ftrace: use current CPU for function startup
>       ftrace: add ftrace_kill_atomic
>       ftrace: separate out the function enabled variable

found a build bug in testing - find the fix below.

	Ingo

-------------->
commit b2613e370dbeb69edbff989382fa54f2395aa471
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Jul 11 16:44:27 2008 +0200

    ftrace: build fix for ftraced_suspend
    
    fix:
    
     kernel/trace/ftrace.c:1615: error: 'ftraced_suspend' undeclared (first use in this function)
     kernel/trace/ftrace.c:1615: error: (Each undeclared identifier is reported only once
     kernel/trace/ftrace.c:1615: error: for each function it appears in.)
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/ftrace.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 1359632..4231a3d 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1612,7 +1612,9 @@ void ftrace_kill_atomic(void)
 {
 	ftrace_disabled = 1;
 	ftrace_enabled = 0;
+#ifdef CONFIG_DYNAMIC_FTRACE
 	ftraced_suspend = -1;
+#endif
 	clear_ftrace_function();
 }
 

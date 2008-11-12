Return-Path: <linux-kernel-owner+w=401wt.eu-S1753766AbYKLNPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766AbYKLNPG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 08:15:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbYKLNOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 08:14:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60717 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbYKLNOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 08:14:52 -0500
Date: Wed, 12 Nov 2008 14:14:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH] tracing: branch tracer, tweak output
Message-ID: <20081112131409.GB24472@elte.hu>
References: <20081112051438.843792214@goodmis.org> <20081112051518.503323629@goodmis.org> <20081112112536.GC31958@elte.hu> <alpine.DEB.1.10.0811120803141.2529@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811120803141.2529@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Wed, 12 Nov 2008, Ingo Molnar wrote:
> 
> > 
> > a small detail:
> > 
> > > For example:
> > >
> > >  bash-3471  [003]   357.014755: [INCORRECT] sched_info_dequeued:sched_stats.h:177
> > >  bash-3471  [003]   357.014756: [correct] update_curr:sched_fair.c:489
> > >  bash-3471  [003]   357.014758: [correct] calc_delta_fair:sched_fair.c:411
> > >  bash-3471  [003]   357.014759: [correct] account_group_exec_runtime:sched_stats.h:356
> > >  bash-3471  [003]   357.014761: [correct] update_curr:sched_fair.c:489
> > >  bash-3471  [003]   357.014763: [INCORRECT] calc_delta_fair:sched_fair.c:411
> > >  bash-3471  [003]   357.014765: [correct] calc_delta_mine:sched.c:1279
> > 
> > it's always good to have such fields aligned vertically. Something 
> > like this would be shorter and visually much easier to parse:
> > 
> >  bash-3471  [003]   357.014755: [ MISS ] sched_info_dequeued:sched_stats.h:177
> >  bash-3471  [003]   357.014756: [ .... ] update_curr:sched_fair.c:489
> >  bash-3471  [003]   357.014758: [ .... ] calc_delta_fair:sched_fair.c:411
> > 
> > any objections against the patch below which implements this?
> 
> How about "[ OK ]" instead of "[ .... ]". That would be easier to 
> understand.

ok, agreed - just the use of capitals is not good, as it unnecessarily 
draws visual attention. How about:

>  bash-3471  [003]   357.014755: [ MISS ] sched_info_dequeued:sched_stats.h:177
>  bash-3471  [003]   357.014756: [  ok  ] update_curr:sched_fair.c:489
>  bash-3471  [003]   357.014758: [  ok  ] calc_delta_fair:sched_fair.c:411

via the patch below?

	Ingo

-------------->
>From 68d119f0a66f7e3663304343b072e56a2693446b Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Wed, 12 Nov 2008 14:09:30 +0100
Subject: [PATCH] tracing: finetune branch-tracer output

Steve suggested the to change the output from this:

>  bash-3471  [003]   357.014755: [ MISS ] sched_info_dequeued:sched_stats.h:177
>  bash-3471  [003]   357.014756: [ .... ] update_curr:sched_fair.c:489
>  bash-3471  [003]   357.014758: [ .... ] calc_delta_fair:sched_fair.c:411

to this:

>  bash-3471  [003]   357.014755: [ MISS ] sched_info_dequeued:sched_stats.h:177
>  bash-3471  [003]   357.014756: [  ok  ] update_curr:sched_fair.c:489
>  bash-3471  [003]   357.014758: [  ok  ] calc_delta_fair:sched_fair.c:411

as it makes it clearer to the user what it means exactly.

Acked-by: Steven Rostedt <srostedt@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 728a46e..d842db1 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1657,7 +1657,7 @@ print_lat_fmt(struct trace_iterator *iter, unsigned int trace_idx, int cpu)
 		trace_assign_type(field, entry);
 
 		trace_seq_printf(s, "[%s] %s:%s:%d\n",
-				 field->correct ? " .... " : " MISS ",
+				 field->correct ? "  ok  " : " MISS ",
 				 field->func,
 				 field->file,
 				 field->line);
@@ -1808,7 +1808,7 @@ static enum print_line_t print_trace_fmt(struct trace_iterator *iter)
 		trace_assign_type(field, entry);
 
 		trace_seq_printf(s, "[%s] %s:%s:%d\n",
-				 field->correct ? " .... " : " MISS ",
+				 field->correct ? "  ok  " : " MISS ",
 				 field->func,
 				 field->file,
 				 field->line);

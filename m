Return-Path: <linux-kernel-owner+w=401wt.eu-S1753265AbZCYEIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbZCYEIr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 00:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbZCYEIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 00:08:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:32828 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbZCYEIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 00:08:35 -0400
Message-Id: <20090325035646.662994901@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 24 Mar 2009 23:56:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tim Bird <tim.bird@am.sony.com>
Subject: [PATCH 0/5][RFC] [RFC] function profiler
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches are RFC, and to discuss is this work would be
useful.

This patch series adds a function profiler hook to the function tracer
and function graph tracer. That is, it uses the mcount calls to track the
functions being called. Now with the function graph tracer it also
keeps track of the times the functions have been executing.

Note, this is similar to oprofile, but is not a sampling approach, but
a true recorder. Of course, by recording every function the overhead
compared to oprofile is higher. With the use of dynamic ftrace, you could
just trace certain functions, or just a certain module. The flexibility
is a bit greater with this profiling.

The last patch adds another feature to the function graph. It gives
the ability to only trace the amount of time inside a function and
not the amount spent in sub functions that are also recorded. That is,
if A calls B, you can decide if the time spent in A should include the
time spent in B. This is an option added to trace_options.

Again, this is all RFC, but if there is any interest in having this
feature, prehaps we should include it.

-- Steve


The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: rfc/tip/tracing/function-profiler


Steven Rostedt (5):
      tracing: add function profiler
      tracing: move function profiler data out of function struct
      tracing: adding function timings to function profiler
      tracing: make the function profiler per cpu
      function-graph: add option to calculate graph time or not

----
 include/linux/ftrace.h               |    3 +-
 kernel/trace/Kconfig                 |   15 +
 kernel/trace/ftrace.c                |  558 +++++++++++++++++++++++++++++++++-
 kernel/trace/trace.c                 |   15 +-
 kernel/trace/trace.h                 |    4 +-
 kernel/trace/trace_functions_graph.c |   25 ++-
 kernel/trace/trace_output.c          |   10 +
 kernel/trace/trace_output.h          |    2 +
 8 files changed, 608 insertions(+), 24 deletions(-)
-- 

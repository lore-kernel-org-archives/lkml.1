Return-Path: <linux-kernel-owner+w=401wt.eu-S1753277AbZFBSqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277AbZFBSqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 14:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbZFBSqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 14:46:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:61801 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbZFBSqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 14:46:00 -0400
Message-Id: <20090602183036.621443366@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 02 Jun 2009 14:30:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, stable@kernel.org,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: [PATCH 0/3] [GIT PULL][urgent] function-graph: memory leak and race fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

During testing of the -rt patch, Luis found a bug with the function
profiler (not in 30-rc and I sent the patch for you already), that
he could trigger a crash when enabling and disabling the function
profiler in a loop.

During my investigation of this, I tried enabling and disabling the
function graph tracer in a loop and was able to also crash the kernel.
This crash was not the same as the profiler crash. Looking into this
I found a few problems with the enabling of the function graph tracer.

One was a memory leak, the other two were races on SMP machines.
The races were more likely the cause of the crashes I saw. With these
patches applied, I no longer can produce the crash.

I've also Cc'd the stable team since these bugs also exist in 2.6.29.


Please pull the latest tip/tracing/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/urgent


Steven Rostedt (3):
      function-graph: only allocate init tasks if it was not already done
      function-graph: enable the stack after initialization of other variables
      function-graph: add memory barriers for accessing task's ret_stack

----
 kernel/trace/ftrace.c                |   23 +++++++++++++++--------
 kernel/trace/trace_functions_graph.c |    6 ++++++
 2 files changed, 21 insertions(+), 8 deletions(-)
-- 

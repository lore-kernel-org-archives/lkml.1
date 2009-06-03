Return-Path: <linux-kernel-owner+w=401wt.eu-S1757517AbZFCPSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517AbZFCPSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 11:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755866AbZFCPSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 11:18:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:59079 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754295AbZFCPSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 11:18:20 -0400
Message-Id: <20090603151820.607760021@goodmis.org>
References: <20090603151724.144915858@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 03 Jun 2009 11:17:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       walimis <walimisdev@gmail.com>
Subject: [PATCH 1/5] tracing/trace_stack: fix the number of entries in the header
Content-Disposition: inline; filename=0001-tracing-trace_stack-fix-the-number-of-entries-in-the.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: walimis <walimisdev@gmail.com>

The last entry in the stack_dump_trace is ULONG_MAX, which is not
a valid entry, but max_stack_trace.nr_entries has accounted for it.
So when printing the header, we should decrease it by one.
Before fix, print as following, for example:

	Depth    Size   Location    (53 entries)	<--- should be 52
	-----    ----   --------
  0)     3264     108   update_wall_time+0x4d5/0x9a0
  ...
 51)       80      80   syscall_call+0x7/0xb
 ^^^
   it's correct.

Signed-off-by: walimis <walimisdev@gmail.com>
LKML-Reference: <1244016090-7814-1-git-send-email-walimisdev@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_stack.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index 1796f00..2d7aebd 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -265,7 +265,7 @@ static int t_show(struct seq_file *m, void *v)
 		seq_printf(m, "        Depth    Size   Location"
 			   "    (%d entries)\n"
 			   "        -----    ----   --------\n",
-			   max_stack_trace.nr_entries);
+			   max_stack_trace.nr_entries - 1);
 
 		if (!stack_tracer_enabled && !max_stack_size)
 			print_disabled(m);
-- 
1.6.3.1

-- 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1751144AbZIJEND@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751144AbZIJEND (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 00:13:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750923AbZIJENA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 00:13:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:41354 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbZIJEM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 00:12:58 -0400
Message-Id: <20090910041300.993426140@goodmis.org>
References: <20090910041219.149954890@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 10 Sep 2009 00:12:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 3/6] tracing: remove dead code
Content-Disposition: inline; filename=0003-tracing-remove-dead-code.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

Removes unreachable code.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4AA8579B.4020706@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h |   22 ----------------------
 1 files changed, 0 insertions(+), 22 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index fa1dccb..536ae1d 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -120,14 +120,6 @@ struct print_entry {
 	char			buf[];
 };
 
-#define TRACE_OLD_SIZE		88
-
-struct trace_field_cont {
-	unsigned char		type;
-	/* Temporary till we get rid of this completely */
-	char			buf[TRACE_OLD_SIZE - 1];
-};
-
 struct trace_mmiotrace_rw {
 	struct trace_entry	ent;
 	struct mmiotrace_rw	rw;
@@ -509,20 +501,6 @@ static inline void __trace_stack(struct trace_array *tr, unsigned long flags,
 
 extern cycle_t ftrace_now(int cpu);
 
-#ifdef CONFIG_CONTEXT_SWITCH_TRACER
-typedef void
-(*tracer_switch_func_t)(void *private,
-			void *__rq,
-			struct task_struct *prev,
-			struct task_struct *next);
-
-struct tracer_switch_ops {
-	tracer_switch_func_t		func;
-	void				*private;
-	struct tracer_switch_ops	*next;
-};
-#endif /* CONFIG_CONTEXT_SWITCH_TRACER */
-
 extern void trace_find_cmdline(int pid, char comm[]);
 
 #ifdef CONFIG_DYNAMIC_FTRACE
-- 
1.6.3.3

-- 

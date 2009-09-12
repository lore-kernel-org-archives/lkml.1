Return-Path: <linux-kernel-owner+w=401wt.eu-S1752489AbZILHxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489AbZILHxH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 03:53:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbZILHxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 03:53:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:33453 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249AbZILHw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 03:52:59 -0400
Date: Sat, 12 Sep 2009 07:52:41 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, lizf@cn.fujitsu.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <4AA8579B.4020706@cn.fujitsu.com>
References: <4AA8579B.4020706@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: remove dead code
Message-ID: <tip-e0ab5f2daee1c7a6a387591bf37f0bad4e407112@git.kernel.org>
Git-Commit-ID: e0ab5f2daee1c7a6a387591bf37f0bad4e407112
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 12 Sep 2009 07:52:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e0ab5f2daee1c7a6a387591bf37f0bad4e407112
Gitweb:     http://git.kernel.org/tip/e0ab5f2daee1c7a6a387591bf37f0bad4e407112
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Thu, 10 Sep 2009 09:34:19 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 9 Sep 2009 23:54:06 -0400

tracing: remove dead code

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

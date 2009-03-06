Return-Path: <linux-kernel-owner+w=401wt.eu-S1756380AbZCFRE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380AbZCFRE2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 12:04:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756565AbZCFRDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 12:03:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:58561 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756581AbZCFRDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 12:03:19 -0500
Date: Fri, 6 Mar 2009 17:01:15 GMT
From: Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1236356510-8381-5-git-send-email-fweisbec@gmail.com>
References: <1236356510-8381-5-git-send-email-fweisbec@gmail.com>
Subject: [tip:tracing/printk] tracing: trace_bprintk() cleanups
Message-ID: <tip-9de36825b321fe9fe9cf73260554251af579f4ca@git.kernel.org>
Git-Commit-ID: 9de36825b321fe9fe9cf73260554251af579f4ca
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 06 Mar 2009 17:01:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9de36825b321fe9fe9cf73260554251af579f4ca
Gitweb:     http://git.kernel.org/tip/9de36825b321fe9fe9cf73260554251af579f4ca
Author:     "Ingo Molnar" <mingo@elte.hu>
AuthorDate: Fri, 6 Mar 2009 17:52:03 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 6 Mar 2009 17:59:12 +0100

tracing: trace_bprintk() cleanups

Impact: cleanup

Remove a few leftovers and clean up the code a bit.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <1236356510-8381-5-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/module.c      |    6 ------
 kernel/trace/trace.h |   19 ++++++++-----------
 2 files changed, 8 insertions(+), 17 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 2dece10..22d7379 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2158,12 +2158,6 @@ static noinline struct module *load_module(void __user *umod,
 					&mod->num_tracepoints);
 #endif
 
-#ifdef CONFIG_TRACE_BPRINTK
-	mod->trace_bprintk_fmt_start = section_objs(hdr, sechdrs, secstrings,
-			"__trace_bprintk_fmt", sizeof(char *),
-			&mod->num_trace_bprintk_fmt);
-#endif
-
 #ifdef CONFIG_MODVERSIONS
 	if ((mod->num_syms && !mod->crcs)
 	    || (mod->num_gpl_syms && !mod->gpl_crcs)
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 6140922..2bfb7d1 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -119,14 +119,11 @@ struct userstack_entry {
  */
 struct print_entry {
 	struct trace_entry	ent;
-	unsigned long 		ip;
+	unsigned long		ip;
 	int			depth;
 	const char		*fmt;
-	u32 			buf[];
+	u32			buf[];
 };
-#ifdef CONFIG_TRACE_BPRINTK
-extern int trace_bprintk_enable;
-#endif
 
 #define TRACE_OLD_SIZE		88
 
@@ -199,7 +196,7 @@ struct kmemtrace_free_entry {
  * trace_flag_type is an enumeration that holds different
  * states when a trace occurs. These are:
  *  IRQS_OFF		- interrupts were disabled
- *  IRQS_NOSUPPORT 	- arch does not support irqs_disabled_flags
+ *  IRQS_NOSUPPORT	- arch does not support irqs_disabled_flags
  *  NEED_RESCED		- reschedule is requested
  *  HARDIRQ		- inside an interrupt handler
  *  SOFTIRQ		- inside a softirq handler
@@ -302,7 +299,7 @@ extern void __ftrace_bad_type(void);
 		IF_ASSIGN(var, ent, struct ftrace_graph_ret_entry,	\
 			  TRACE_GRAPH_RET);		\
 		IF_ASSIGN(var, ent, struct hw_branch_entry, TRACE_HW_BRANCHES);\
- 		IF_ASSIGN(var, ent, struct trace_power, TRACE_POWER); \
+		IF_ASSIGN(var, ent, struct trace_power, TRACE_POWER); \
 		IF_ASSIGN(var, ent, struct kmemtrace_alloc_entry,	\
 			  TRACE_KMEM_ALLOC);	\
 		IF_ASSIGN(var, ent, struct kmemtrace_free_entry,	\
@@ -325,8 +322,8 @@ enum print_line_t {
  * flags value in struct tracer_flags.
  */
 struct tracer_opt {
-	const char 	*name; /* Will appear on the trace_options file */
-	u32 		bit; /* Mask assigned in val field in tracer_flags */
+	const char	*name; /* Will appear on the trace_options file */
+	u32		bit; /* Mask assigned in val field in tracer_flags */
 };
 
 /*
@@ -335,7 +332,7 @@ struct tracer_opt {
  */
 struct tracer_flags {
 	u32			val;
-	struct tracer_opt 	*opts;
+	struct tracer_opt	*opts;
 };
 
 /* Makes more easy to define a tracer opt */
@@ -390,7 +387,7 @@ struct tracer {
 	int			(*set_flag)(u32 old_flags, u32 bit, int set);
 	struct tracer		*next;
 	int			print_max;
-	struct tracer_flags 	*flags;
+	struct tracer_flags	*flags;
 	struct tracer_stat	*stats;
 };
 

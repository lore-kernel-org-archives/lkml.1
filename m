Return-Path: <linux-kernel-owner+w=401wt.eu-S1752191AbZL1KKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbZL1KKw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 05:10:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbZL1KKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 05:10:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:36430 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618AbZL1KKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 05:10:47 -0500
Date: Mon, 28 Dec 2009 10:09:06 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, lizf@cn.fujitsu.com, peterz@infradead.org,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com, peterz@infradead.org,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4B2F1557.2050705@cn.fujitsu.com>
References: <4B2F1557.2050705@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf events: Remove CONFIG_EVENT_PROFILE
Message-ID: <tip-07b139c8c81b97bbe55c68daf0cbeca8b1c609ca@git.kernel.org>
Git-Commit-ID: 07b139c8c81b97bbe55c68daf0cbeca8b1c609ca
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  07b139c8c81b97bbe55c68daf0cbeca8b1c609ca
Gitweb:     http://git.kernel.org/tip/07b139c8c81b97bbe55c68daf0cbeca8b1c609ca
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Mon, 21 Dec 2009 14:27:35 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 28 Dec 2009 10:33:06 +0100

perf events: Remove CONFIG_EVENT_PROFILE

Quoted from Ingo:

| This reminds me - i think we should eliminate CONFIG_EVENT_PROFILE -
| it's an unnecessary Kconfig complication. If both PERF_EVENTS and
| EVENT_TRACING is enabled we should expose generic tracepoints.
|
| Nor is it limited to event 'profiling', so it has become a misnomer as
| well.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <4B2F1557.2050705@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/ftrace_event.h       |    2 +-
 include/linux/perf_event.h         |    2 +-
 include/linux/syscalls.h           |    4 ++--
 include/trace/ftrace.h             |   12 ++++++------
 include/trace/syscall.h            |    4 ++--
 init/Kconfig                       |   13 -------------
 kernel/perf_event.c                |    4 ++--
 kernel/trace/Makefile              |    4 +++-
 kernel/trace/trace_events_filter.c |    4 ++--
 kernel/trace/trace_kprobe.c        |   14 +++++++-------
 kernel/trace/trace_syscalls.c      |    5 ++---
 11 files changed, 28 insertions(+), 40 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 2233c98..0a09e75 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -188,7 +188,7 @@ do {									\
 		__trace_printk(ip, fmt, ##args);			\
 } while (0)
 
-#ifdef CONFIG_EVENT_PROFILE
+#ifdef CONFIG_PERF_EVENTS
 struct perf_event;
 extern int ftrace_profile_enable(int event_id);
 extern void ftrace_profile_disable(int event_id);
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index a494e75..9a1d276 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -658,7 +658,7 @@ struct perf_event {
 
 	perf_overflow_handler_t		overflow_handler;
 
-#ifdef CONFIG_EVENT_PROFILE
+#ifdef CONFIG_EVENT_TRACING
 	struct event_filter		*filter;
 #endif
 
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 65793e9..b7c7fcf 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -99,7 +99,7 @@ struct perf_event_attr;
 #define __SC_TEST5(t5, a5, ...)	__SC_TEST(t5); __SC_TEST4(__VA_ARGS__)
 #define __SC_TEST6(t6, a6, ...)	__SC_TEST(t6); __SC_TEST5(__VA_ARGS__)
 
-#ifdef CONFIG_EVENT_PROFILE
+#ifdef CONFIG_PERF_EVENTS
 
 #define TRACE_SYS_ENTER_PROFILE_INIT(sname)				       \
 	.profile_enable = prof_sysenter_enable,				       \
@@ -113,7 +113,7 @@ struct perf_event_attr;
 #define TRACE_SYS_ENTER_PROFILE_INIT(sname)
 #define TRACE_SYS_EXIT_PROFILE(sname)
 #define TRACE_SYS_EXIT_PROFILE_INIT(sname)
-#endif
+#endif /* CONFIG_PERF_EVENTS */
 
 #ifdef CONFIG_FTRACE_SYSCALLS
 #define __SC_STR_ADECL1(t, a)		#a
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 7352315..2fdd36d 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -498,7 +498,7 @@ static inline int ftrace_get_offsets_##call(				\
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
-#ifdef CONFIG_EVENT_PROFILE
+#ifdef CONFIG_PERF_EVENTS
 
 /*
  * Generate the functions needed for tracepoint perf_event support.
@@ -541,7 +541,7 @@ static void ftrace_profile_disable_##name(struct ftrace_event_call *unused)\
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
-#endif
+#endif /* CONFIG_PERF_EVENTS */
 
 /*
  * Stage 4 of the trace events.
@@ -626,7 +626,7 @@ static void ftrace_profile_disable_##name(struct ftrace_event_call *unused)\
  *
  */
 
-#ifdef CONFIG_EVENT_PROFILE
+#ifdef CONFIG_PERF_EVENTS
 
 #define _TRACE_PROFILE_INIT(call)					\
 	.profile_enable = ftrace_profile_enable_##call,			\
@@ -634,7 +634,7 @@ static void ftrace_profile_disable_##name(struct ftrace_event_call *unused)\
 
 #else
 #define _TRACE_PROFILE_INIT(call)
-#endif
+#endif /* CONFIG_PERF_EVENTS */
 
 #undef __entry
 #define __entry entry
@@ -834,7 +834,7 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
  * }
  */
 
-#ifdef CONFIG_EVENT_PROFILE
+#ifdef CONFIG_PERF_EVENTS
 
 #undef __perf_addr
 #define __perf_addr(a) __addr = (a)
@@ -926,7 +926,7 @@ static void ftrace_profile_##call(proto)			\
 	DEFINE_EVENT(template, name, PARAMS(proto), PARAMS(args))
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
-#endif /* CONFIG_EVENT_PROFILE */
+#endif /* CONFIG_PERF_EVENTS */
 
 #undef _TRACE_PROFILE_INIT
 
diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index 961fda3..3d463dc 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -49,12 +49,12 @@ ftrace_format_syscall(struct ftrace_event_call *call, struct trace_seq *s);
 enum print_line_t print_syscall_enter(struct trace_iterator *iter, int flags);
 enum print_line_t print_syscall_exit(struct trace_iterator *iter, int flags);
 #endif
-#ifdef CONFIG_EVENT_PROFILE
+
+#ifdef CONFIG_PERF_EVENTS
 int prof_sysenter_enable(struct ftrace_event_call *call);
 void prof_sysenter_disable(struct ftrace_event_call *call);
 int prof_sysexit_enable(struct ftrace_event_call *call);
 void prof_sysexit_disable(struct ftrace_event_call *call);
-
 #endif
 
 #endif /* _TRACE_SYSCALL_H */
diff --git a/init/Kconfig b/init/Kconfig
index a23da9f..06dab27 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -966,19 +966,6 @@ config PERF_EVENTS
 
 	  Say Y if unsure.
 
-config EVENT_PROFILE
-	bool "Tracepoint profiling sources"
-	depends on PERF_EVENTS && EVENT_TRACING
-	default y
-	help
-	 Allow the use of tracepoints as software performance events.
-
-	 When this is enabled, you can create perf events based on
-	 tracepoints using PERF_TYPE_TRACEPOINT and the tracepoint ID
-	 found in debugfs://tracing/events/*/*/id. (The -e/--events
-	 option to the perf tool can parse and interpret symbolic
-	 tracepoints, in the subsystem:tracepoint_name format.)
-
 config PERF_COUNTERS
 	bool "Kernel performance counters (old config option)"
 	depends on HAVE_PERF_EVENTS
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 099bd66..5b987b4 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4177,7 +4177,7 @@ static const struct pmu perf_ops_task_clock = {
 	.read		= task_clock_perf_event_read,
 };
 
-#ifdef CONFIG_EVENT_PROFILE
+#ifdef CONFIG_EVENT_TRACING
 
 void perf_tp_event(int event_id, u64 addr, u64 count, void *record,
 			  int entry_size)
@@ -4282,7 +4282,7 @@ static void perf_event_free_filter(struct perf_event *event)
 {
 }
 
-#endif /* CONFIG_EVENT_PROFILE */
+#endif /* CONFIG_EVENT_TRACING */
 
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
 static void bp_perf_event_destroy(struct perf_event *event)
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index cd9ecd8..d00c6fe 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -51,7 +51,9 @@ endif
 obj-$(CONFIG_EVENT_TRACING) += trace_events.o
 obj-$(CONFIG_EVENT_TRACING) += trace_export.o
 obj-$(CONFIG_FTRACE_SYSCALLS) += trace_syscalls.o
-obj-$(CONFIG_EVENT_PROFILE) += trace_event_profile.o
+ifeq ($(CONFIG_PERF_EVENTS),y)
+obj-$(CONFIG_EVENT_TRACING) += trace_event_profile.o
+endif
 obj-$(CONFIG_EVENT_TRACING) += trace_events_filter.o
 obj-$(CONFIG_KPROBE_EVENT) += trace_kprobe.o
 obj-$(CONFIG_KSYM_TRACER) += trace_ksym.o
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 50504cb..74563d7 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1360,7 +1360,7 @@ out_unlock:
 	return err;
 }
 
-#ifdef CONFIG_EVENT_PROFILE
+#ifdef CONFIG_PERF_EVENTS
 
 void ftrace_profile_free_filter(struct perf_event *event)
 {
@@ -1428,5 +1428,5 @@ out_unlock:
 	return err;
 }
 
-#endif /* CONFIG_EVENT_PROFILE */
+#endif /* CONFIG_PERF_EVENTS */
 
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 375f81a..75d75de 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1249,7 +1249,7 @@ static int kretprobe_event_show_format(struct ftrace_event_call *call,
 					 ", REC->" FIELD_STRING_RETIP);
 }
 
-#ifdef CONFIG_EVENT_PROFILE
+#ifdef CONFIG_PERF_EVENTS
 
 /* Kprobe profile handler */
 static __kprobes int kprobe_profile_func(struct kprobe *kp,
@@ -1407,7 +1407,7 @@ static void probe_profile_disable(struct ftrace_event_call *call)
 			disable_kprobe(&tp->rp.kp);
 	}
 }
-#endif	/* CONFIG_EVENT_PROFILE */
+#endif	/* CONFIG_PERF_EVENTS */
 
 
 static __kprobes
@@ -1417,10 +1417,10 @@ int kprobe_dispatcher(struct kprobe *kp, struct pt_regs *regs)
 
 	if (tp->flags & TP_FLAG_TRACE)
 		kprobe_trace_func(kp, regs);
-#ifdef CONFIG_EVENT_PROFILE
+#ifdef CONFIG_PERF_EVENTS
 	if (tp->flags & TP_FLAG_PROFILE)
 		kprobe_profile_func(kp, regs);
-#endif	/* CONFIG_EVENT_PROFILE */
+#endif
 	return 0;	/* We don't tweek kernel, so just return 0 */
 }
 
@@ -1431,10 +1431,10 @@ int kretprobe_dispatcher(struct kretprobe_instance *ri, struct pt_regs *regs)
 
 	if (tp->flags & TP_FLAG_TRACE)
 		kretprobe_trace_func(ri, regs);
-#ifdef CONFIG_EVENT_PROFILE
+#ifdef CONFIG_PERF_EVENTS
 	if (tp->flags & TP_FLAG_PROFILE)
 		kretprobe_profile_func(ri, regs);
-#endif	/* CONFIG_EVENT_PROFILE */
+#endif
 	return 0;	/* We don't tweek kernel, so just return 0 */
 }
 
@@ -1463,7 +1463,7 @@ static int register_probe_event(struct trace_probe *tp)
 	call->regfunc = probe_event_enable;
 	call->unregfunc = probe_event_disable;
 
-#ifdef CONFIG_EVENT_PROFILE
+#ifdef CONFIG_PERF_EVENTS
 	call->profile_enable = probe_profile_enable;
 	call->profile_disable = probe_profile_disable;
 #endif
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 75289f3..f694f66 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -421,7 +421,7 @@ int __init init_ftrace_syscalls(void)
 }
 core_initcall(init_ftrace_syscalls);
 
-#ifdef CONFIG_EVENT_PROFILE
+#ifdef CONFIG_PERF_EVENTS
 
 static DECLARE_BITMAP(enabled_prof_enter_syscalls, NR_syscalls);
 static DECLARE_BITMAP(enabled_prof_exit_syscalls, NR_syscalls);
@@ -626,6 +626,5 @@ void prof_sysexit_disable(struct ftrace_event_call *call)
 	mutex_unlock(&syscall_trace_lock);
 }
 
-#endif
-
+#endif /* CONFIG_PERF_EVENTS */
 

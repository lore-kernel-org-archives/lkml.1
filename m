Return-Path: <linux-kernel-owner+w=401wt.eu-S1756763AbZA0Tyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763AbZA0Tyu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 14:54:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755909AbZA0Tym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 14:54:42 -0500
Received: from mx2.redhat.com ([66.187.237.31]:35407 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755887AbZA0Tyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 14:54:41 -0500
Date: Tue, 27 Jan 2009 14:54:26 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: utrace-devel@redhat.com
Cc: systemtap@sources.redhat.com, linux-kernel@vger.kernel.org
Subject: proof-of-concept, utrace->ftrace engine
Message-ID: <20090127195425.GF32568@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

Here's the start of a little ditty that ties process-related events as
hooked by the Roland McGrath's utrace code into the ftrace
buffer/control widgetry.  If nothing else, think of it as one
potential in-tree user of utrace.


Script started on Tue 27 Jan 2009 02:39:06 PM EST

[root@vm-fed10-64 tracing]# cat available_tracers 
process wakeup irqsoff sysprof sched_switch nop
[root@vm-fed10-64 tracing]# echo process > current_tracer 
[root@vm-fed10-64 tracing]# echo 500 > process_trace_uid_filter 
[root@vm-fed10-64 tracing]# cat trace
# tracer: process
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |
[root@vm-fed10-64 tracing]# su - fche
%                                                                               
vm-fed10-64 /home/fche
[14:39:50] % pwd
/home/fche
%                                                                               
vm-fed10-64 /home/fche
[14:39:52] % ls /tmp
firstbootX.log     pulse-PKdhtXMmr18n  stapbXg0xB  stapUniATd
foo                stap6cNJ5M          stapl9Ww2f  virtual-fche.4SkpzQ
kerneloops.pxnITL  stap9MajHI          stapT1LKnQ
%                                                                               
vm-fed10-64 /home/fche
[14:39:59] % df
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/mapper/VolGroup00-LogVol00
                      13706328  11417980   2149176  85% /
/dev/sda1               194442     34259    150144  19% /boot
tmpfs                   382320         0    382320   0% /dev/shm
super:/home          1300999168 496440320 750835712  40% /home
%                                                                               
vm-fed10-64 /home/fche
[14:40:03] % exit
Tue Jan 27 14:40:05 EST 2009
[root@vm-fed10-64 tracing]# cat trace
# tracer: process
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |
             zsh  2091   0   2616701.950948 exec
             zsh  2091   0   2616701.966410 fork 2092 flags 0x1200011
          whoami  2092   1   2616702.005276 exec
          whoami  2092   0   2616702.008612 exit 0
             zsh  2091   0   2616702.009193 signal 17 errno 0 code 262145
             zsh  2091   0   2616702.011385 fork 2093 flags 0x1200011
           mkdir  2093   1   2616702.013701 exec
           mkdir  2093   0   2616702.017300 exit 0
             zsh  2091   0   2616702.018133 signal 17 errno 0 code 262145
             zsh  2091   0   2616702.018951 fork 2094 flags 0x1200011
          whoami  2094   0   2616702.023867 exec
          whoami  2094   0   2616702.026108 exit 0
             zsh  2091   0   2616702.026567 signal 17 errno 0 code 262145
             zsh  2091   0   2616702.027358 fork 2095 flags 0x1200011
           mkdir  2095   1   2616702.029712 exec
           mkdir  2095   1   2616702.031703 exit 0
             zsh  2091   0   2616702.032275 signal 17 errno 0 code 262145
             zsh  2091   0   2616702.035062 fork 2096 flags 0x1200011
             zsh  2096   1   2616702.036457 exit 0
             zsh  2091   0   2616702.037344 fork 2097 flags 0x1200011
             zsh  2091   0   2616702.038959 signal 17 errno 0 code 262145
           egrep  2097   1   2616702.039692 exec
           egrep  2097   1   2616702.041620 exit 256
             zsh  2091   0   2616702.042150 signal 17 errno 0 code 262145
             zsh  2091   0   2616702.043095 fork 2098 flags 0x1200011
             zsh  2098   1   2616702.044435 exit 0
             zsh  2091   0   2616702.045329 fork 2099 flags 0x1200011
             zsh  2091   0   2616702.046846 signal 17 errno 0 code 262145
           egrep  2099   1   2616702.047646 exec
           egrep  2099   1   2616702.049571 exit 0
             zsh  2091   0   2616702.050141 signal 17 errno 0 code 262145
             zsh  2091   0   2616702.051020 fork 2100 flags 0x1200011
             zsh  2100   0   2616702.052046 exit 0
             zsh  2091   0   2616702.053346 fork 2101 flags 0x1200011
             zsh  2091   0   2616702.054672 signal 17 errno 0 code 262145
           egrep  2101   1   2616702.055515 exec
           egrep  2101   1   2616702.057346 exit 0
             zsh  2091   0   2616702.057907 signal 17 errno 0 code 262145
             zsh  2091   0   2616702.058982 fork 2102 flags 0x1200011
              id  2102   1   2616702.064822 exec
              id  2102   1   2616702.067609 exit 0
             zsh  2091   0   2616702.068307 signal 17 errno 0 code 262145
             zsh  2091   0   2616702.069246 fork 2103 flags 0x1200011
        hostname  2103   0   2616702.072067 exec
        hostname  2103   0   2616702.074154 exit 0
             zsh  2091   0   2616702.074766 signal 17 errno 0 code 262145
             zsh  2091   0   2616702.076529 fork 2104 flags 0x1200011
             zsh  2104   1   2616702.077982 exit 0
             zsh  2091   0   2616702.079742 fork 2105 flags 0x1200011
             zsh  2091   0   2616702.081672 signal 17 errno 0 code 262145
            grep  2105   1   2616702.082929 exec
            grep  2105   0   2616702.087867 exec
            grep  2105   0   2616702.089716 exit 256
             zsh  2091   0   2616702.090205 signal 17 errno 0 code 262145
             zsh  2091   0   2616702.092925 fork 2106 flags 0x1200011
            tput  2106   1   2616702.099077 exec
            tput  2106   1   2616702.100918 exit 0
             zsh  2091   0   2616702.101588 signal 17 errno 0 code 262145
             zsh  2091   0   2616702.102659 fork 2107 flags 0x1200011
       dircolors  2107   1   2616702.108917 exec
       dircolors  2107   1   2616702.110359 exit 0
             zsh  2091   0   2616702.110997 signal 17 errno 0 code 262145
             zsh  2091   0   2616702.134110 fork 2108 flags 0x1200011
           egrep  2108   0   2616702.136910 exec
           egrep  2108   0   2616702.138921 exit 256
             zsh  2091   0   2616702.139430 signal 17 errno 0 code 262145
             zsh  2091   0   2616702.141230 fork 2109 flags 0x1200011
             zsh  2109   1   2616702.142714 exit 0
             zsh  2091   0   2616702.143685 fork 2110 flags 0x1200011
             zsh  2091   0   2616702.145204 signal 17 errno 0 code 262145
            grep  2110   1   2616702.145974 exec
            grep  2110   1   2616702.147934 exit 256
             zsh  2091   0   2616702.150523 signal 17 errno 0 code 262145
             zsh  2091   0   2616702.151842 fork 2111 flags 0x1200011
             zsh  2111   1   2616702.153271 exit 0
             zsh  2091   0   2616702.154703 fork 2112 flags 0x1200011
             zsh  2091   0   2616702.156063 signal 17 errno 0 code 262145
            grep  2112   1   2616702.157028 exec
            grep  2112   1   2616702.158834 exit 256
             zsh  2091   0   2616702.159476 signal 17 errno 0 code 262145
             zsh  2091   0   2616702.160319 fork 2113 flags 0x1200011
              id  2113   1   2616702.162848 exec
              id  2113   1   2616702.165115 exit 0
             zsh  2091   0   2616702.165872 signal 17 errno 0 code 262145
             zsh  2091   0   2616702.168590 fork 2114 flags 0x1200011
     consoletype  2114   1   2616702.171021 exec
     consoletype  2114   1   2616702.171988 exit 512
             zsh  2091   0   2616702.172443 signal 17 errno 0 code 262145
             zsh  2091   0   2616702.181959 fork 2115 flags 0x1200011
          whoami  2115   1   2616702.188936 exec
          whoami  2115   1   2616702.191366 exit 0
             zsh  2091   0   2616702.192051 signal 17 errno 0 code 262145
             zsh  2091   0   2616702.194605 fork 2116 flags 0x1200011
           mkdir  2116   0   2616702.197377 exec
           mkdir  2116   0   2616702.199480 exit 0
             zsh  2091   0   2616702.200084 signal 17 errno 0 code 262145
             zsh  2091   0   2616702.201017 fork 2117 flags 0x1200011
          whoami  2117   0   2616702.206033 exec
          whoami  2117   0   2616702.208245 exit 0
             zsh  2091   0   2616702.208888 signal 17 errno 0 code 262145
             zsh  2091   0   2616702.209836 fork 2118 flags 0x1200011
           mkdir  2118   0   2616702.212527 exec
           mkdir  2118   0   2616702.214474 exit 0
             zsh  2091   0   2616702.215117 signal 17 errno 0 code 262145
             zsh  2091   0   2616702.217011 fork 2119 flags 0x1200011
            stty  2119   0   2616702.220137 exec
            stty  2119   0   2616702.223496 exit 0
             zsh  2091   0   2616702.223977 signal 17 errno 0 code 262145
             zsh  2091   0   2616702.229063 fork 2120 flags 0x1200011
            mesg  2120   0   2616702.232073 exec
            mesg  2120   0   2616702.233994 exit 0
             zsh  2091   0   2616702.234454 signal 17 errno 0 code 262145
             zsh  2091   0   2616711.333172 fork 2121 flags 0x1200011
              ls  2121   0   2616711.336055 exec
              ls  2121   0   2616711.356496 exit 0
             zsh  2091   0   2616711.364547 signal 17 errno 0 code 262145
             zsh  2091   0   2616714.474787 fork 2125 flags 0x1200011
              df  2125   0   2616714.479280 exec
              df  2125   0   2616714.483010 exit 0
             zsh  2091   0   2616714.483701 signal 17 errno 0 code 262145
             zsh  2091   0   2616716.594615 fork 2126 flags 0x1200011
           clear  2126   0   2616716.598083 exec
           clear  2126   0   2616716.599856 exit 0
             zsh  2091   0   2616716.600439 signal 17 errno 0 code 262145
             zsh  2091   0   2616716.601532 fork 2127 flags 0x1200011
            date  2127   0   2616716.613852 exec
            date  2127   0   2616716.619608 exit 0
             zsh  2091   0   2616716.620334 signal 17 errno 0 code 262145
             zsh  2091   0   2616716.632090 fork 2128 flags 0x1200011
           clear  2128   0   2616716.634284 exec
           clear  2128   0   2616716.636012 exit 0
             zsh  2091   0   2616716.636775 signal 17 errno 0 code 262145
             zsh  2091   0   2616716.637448 exit 0
[root@vm-fed10-64 tracing]# nop > current_tracer 
[root@vm-fed10-64 tracing]# cat trace
# tracer: nop
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |
[root@vm-fed10-64 tracing]# exit

Script done on Tue 27 Jan 2009 02:40:26 PM EST



diff --git a/include/linux/processtrace.h b/include/linux/processtrace.h
new file mode 100644
index 0000000..f902443
--- /dev/null
+++ b/include/linux/processtrace.h
@@ -0,0 +1,33 @@
+#ifndef PROCESSTRACE_H
+#define PROCESSTRACE_H
+
+#include <linux/types.h>
+#include <linux/list.h>
+
+struct process_trace_entry {
+	unsigned char opcode;	/* one of _UTRACE_EVENT_* */
+        char comm[TASK_COMM_LEN]; /* XXX: should be in/via trace_entry */
+        union {
+                struct {
+                        pid_t child;
+                        unsigned long flags;
+                } trace_clone;
+                struct {
+                        long code;
+                } trace_exit;
+                struct {
+                } trace_exec;
+                struct {
+                        int si_signo;
+                        int si_errno;
+                        int si_code;
+                } trace_signal;
+        };
+};
+
+/* in kernel/trace/trace_process.c */
+
+extern void enable_process_trace (void);
+extern void disable_process_trace (void);
+
+#endif /* PROCESSTRACE_H */
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 33dbefd..9276863 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -119,6 +119,15 @@ config CONTEXT_SWITCH_TRACER
 	  This tracer gets called from the context switch and records
 	  all switching of tasks.
 
+config PROCESS_TRACER
+	bool "Trace process events via utrace"
+	depends on DEBUG_KERNEL
+	select TRACING
+	select UTRACE
+	help
+	  This tracer provides trace records from process events
+	  accessible to utrace: lifecycle, system calls, and signals.
+
 config BOOT_TRACER
 	bool "Trace boot initcalls"
 	depends on DEBUG_KERNEL
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index c8228b1..b06a5d6 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -24,5 +24,6 @@ obj-$(CONFIG_NOP_TRACER) += trace_nop.o
 obj-$(CONFIG_STACK_TRACER) += trace_stack.o
 obj-$(CONFIG_MMIOTRACE) += trace_mmiotrace.o
 obj-$(CONFIG_BOOT_TRACER) += trace_boot.o
+obj-$(CONFIG_PROCESS_TRACER) += trace_process.o
 
 libftrace-y := ftrace.o
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 8465ad0..7c0cd57 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -7,6 +7,7 @@
 #include <linux/clocksource.h>
 #include <linux/ring_buffer.h>
 #include <linux/mmiotrace.h>
+#include <linux/processtrace.h>
 #include <linux/ftrace.h>
 
 enum trace_type {
@@ -22,6 +23,7 @@ enum trace_type {
 	TRACE_MMIO_RW,
 	TRACE_MMIO_MAP,
 	TRACE_BOOT,
+	TRACE_PROCESS,
 
 	__TRACE_LAST_TYPE
 };
@@ -117,6 +119,11 @@ struct trace_boot {
 	struct boot_trace	initcall;
 };
 
+struct trace_process {
+        struct trace_entry		ent;
+	struct process_trace_entry	event;
+};
+
 /*
  * trace_flag_type is an enumeration that holds different
  * states when a trace occurs. These are:
@@ -219,6 +226,7 @@ extern void __ftrace_bad_type(void);
 		IF_ASSIGN(var, ent, struct trace_mmiotrace_map,		\
 			  TRACE_MMIO_MAP);				\
 		IF_ASSIGN(var, ent, struct trace_boot, TRACE_BOOT);	\
+		IF_ASSIGN(var, ent, struct trace_process, TRACE_PROCESS); \
 		__ftrace_bad_type();					\
 	} while (0)
 
diff --git a/kernel/trace/trace_process.c b/kernel/trace/trace_process.c
new file mode 100644
index 0000000..10c2c3c
--- /dev/null
+++ b/kernel/trace/trace_process.c
@@ -0,0 +1,440 @@
+/*
+ * utrace-based process event tracing
+ * Copyright (C) 2009 Red Hat Inc.
+ * By Frank Ch. Eigler <fche@redhat.com>
+ */
+
+#define DEBUG 1
+
+#include <linux/kernel.h>
+#include <linux/utrace.h>
+#include <linux/uaccess.h>
+#include <linux/debugfs.h>
+
+#include "trace.h"
+
+/* A process must match these filters in order to be traced. */
+static char trace_taskcomm_filter[TASK_COMM_LEN]; /* \0: unrestricted */
+static u32 trace_taskuid_filter = -1; /* -1: unrestricted */
+
+/* A process must be a direct child of given pid in order to be
+   followed. */ 
+static u32 process_follow_pid; /* 0: unrestricted/systemwide */
+
+/* XXX: lock the above? */
+
+
+/* trace data collection */
+
+static struct trace_array *process_trace_array;
+
+static void process_reset_data(struct trace_array *tr)
+{
+	int cpu;
+
+	pr_debug("in %s\n", __func__);
+	tr->time_start = ftrace_now(tr->cpu);
+	for_each_online_cpu(cpu)
+		tracing_reset(tr, cpu);
+}
+
+static void process_trace_init(struct trace_array *tr)
+{
+	pr_debug("in %s\n", __func__);
+	process_trace_array = tr;
+	if (tr->ctrl) {
+		process_reset_data(tr);
+		enable_process_trace();
+	}
+}
+
+static void process_trace_reset(struct trace_array *tr)
+{
+	pr_debug("in %s\n", __func__);
+	if (tr->ctrl)
+		disable_process_trace();
+	process_reset_data(tr);
+	process_trace_array = NULL;
+}
+
+static void process_trace_ctrl_update(struct trace_array *tr)
+{
+	pr_debug("in %s\n", __func__);
+	if (tr->ctrl) {
+		process_reset_data(tr);
+		enable_process_trace();
+	} else {
+		disable_process_trace();
+	}
+}
+
+static void __trace_processtrace(struct trace_array *tr,
+				struct trace_array_cpu *data,
+				struct process_trace_entry *ent)
+{
+	struct ring_buffer_event *event;
+	struct trace_process *entry;
+	unsigned long irq_flags;
+
+	event	= ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
+					   &irq_flags);
+	if (!event)
+		return;
+	entry	= ring_buffer_event_data(event);
+	tracing_generic_entry_update(&entry->ent, 0, preempt_count());
+        entry->ent.cpu                  = raw_smp_processor_id();
+	entry->ent.type			= TRACE_PROCESS;
+        strlcpy (ent->comm, current->comm, TASK_COMM_LEN);
+	entry->event			= *ent;
+	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
+
+	trace_wake_up();
+}
+
+void process_trace(struct process_trace_entry *ent)
+{
+	struct trace_array *tr = process_trace_array;
+	struct trace_array_cpu *data = tr->data[smp_processor_id()];
+
+	__trace_processtrace(tr, data, ent);
+}
+
+
+/* trace data rendering */
+
+static void process_pipe_open(struct trace_iterator *iter)
+{
+	struct trace_seq *s = &iter->seq;
+	pr_debug("in %s\n", __func__);
+	trace_seq_printf(s, "VERSION 200901\n");
+}
+
+static void process_close(struct trace_iterator *iter)
+{
+	iter->private = NULL;
+}
+
+static ssize_t process_read(struct trace_iterator *iter, struct file *filp,
+				char __user *ubuf, size_t cnt, loff_t *ppos)
+{
+	ssize_t ret;
+	struct trace_seq *s = &iter->seq;
+	ret = trace_seq_to_user(s, ubuf, cnt);
+	return (ret == -EBUSY) ? 0 : ret;
+}
+
+static enum print_line_t process_print(struct trace_iterator *iter)
+{
+	struct trace_entry *entry = iter->ent;
+	struct trace_process *field;
+	struct trace_seq *s	= &iter->seq;
+	unsigned long long t	= ns2usecs(iter->ts);
+	unsigned long usec_rem	= do_div(t, 1000000ULL);
+	unsigned secs		= (unsigned long)t;
+	int ret = 1;
+
+	pr_debug("in %s\n", __func__);
+	trace_assign_type(field, entry);
+
+        /* XXX: If print_lat_fmt() were not static, we wouldn't have
+           to duplicate this. */
+        trace_seq_printf(s, "%16s %5d %3d %9lu.%06ld ",
+                         field->event.comm,
+                         entry->pid, entry->cpu,
+                         secs,
+                         usec_rem);
+
+	switch (field->event.opcode) {
+	case _UTRACE_EVENT_CLONE:
+		ret = trace_seq_printf(s, "fork %d flags 0x%lx\n",
+                                       field->event.trace_clone.child,
+                                       field->event.trace_clone.flags);
+		break;
+	case _UTRACE_EVENT_EXEC:
+		ret = trace_seq_printf(s, "exec\n");
+		break;
+	case _UTRACE_EVENT_EXIT:
+		ret = trace_seq_printf(s, "exit %ld\n",
+                                       field->event.trace_exit.code);
+		break;
+	case _UTRACE_EVENT_SIGNAL:
+		ret = trace_seq_printf(s, "signal %d errno %d code %d\n",
+                                       field->event.trace_signal.si_signo,
+                                       field->event.trace_signal.si_errno,
+                                       field->event.trace_signal.si_code);
+		break;
+	default:
+		ret = trace_seq_printf(s, "process code %d?\n", field->event.opcode);
+		break;
+	}
+	if (ret)
+		return TRACE_TYPE_HANDLED;
+	return TRACE_TYPE_PARTIAL_LINE;
+}
+
+
+static enum print_line_t process_print_line(struct trace_iterator *iter)
+{
+	switch (iter->ent->type) {
+	case TRACE_PROCESS:
+		return process_print(iter);
+	default:
+		return TRACE_TYPE_HANDLED; /* ignore unknown entries */
+	}
+}
+
+static struct tracer process_tracer __read_mostly =
+{
+	.name		= "process",
+	.init		= process_trace_init,
+	.reset		= process_trace_reset,
+	.pipe_open	= process_pipe_open,
+	.close		= process_close,
+	.read		= process_read,
+	.ctrl_update	= process_trace_ctrl_update,
+	.print_line	= process_print_line,
+};
+
+
+
+/* utrace backend */
+
+/* Should tracing apply to given task?  Compare against filter
+   values. */
+static int trace_test (struct task_struct *tsk) 
+{
+        if (trace_taskcomm_filter[0]
+            && strcmp (trace_taskcomm_filter, tsk->comm))
+                return 0;
+        if (trace_taskuid_filter != (u32)-1 
+            && trace_taskuid_filter != task_uid (tsk))
+                return 0;
+
+        return 1;
+}
+
+
+static struct utrace_engine_ops process_trace_ops __read_mostly;
+
+static void process_trace_tryattach (struct task_struct *tsk) 
+{
+        struct utrace_attached_engine *engine;
+        
+        pr_debug("in %s\n", __func__);
+        engine = utrace_attach_task (tsk, UTRACE_ATTACH_CREATE,
+                                     & process_trace_ops, NULL);
+        if (IS_ERR(engine) || (engine == NULL)) {
+                pr_warning ("utrace_attach_task %d (rc %p)\n",
+                            tsk->pid, engine);
+        } else {
+                int rc;
+
+                /* XXX: Why is this not implicit from the fields
+                   set in the process_trace_ops? */
+                rc = utrace_set_events (tsk, engine,
+                                        UTRACE_EVENT(CLONE) |
+                                        UTRACE_EVENT(EXEC) |
+                                        UTRACE_EVENT(SIGNAL) |
+                                        UTRACE_EVENT(EXIT));
+                if (rc == -EINPROGRESS)
+                        rc = utrace_barrier (tsk, engine);
+                if (rc)
+                        pr_warning ("utrace_set_events/barrier rc %d\n", rc);
+                
+                utrace_engine_put (engine);
+                pr_debug("attached in %s to %s(%d)\n", __func__, tsk->comm, tsk->pid);
+        }
+}
+
+
+u32 process_trace_report_clone (enum utrace_resume_action action,
+                                struct utrace_attached_engine *engine,
+                                struct task_struct *parent,
+                                unsigned long clone_flags,
+                                struct task_struct *child) 
+{
+        if (trace_test (parent)) {
+                struct process_trace_entry ent;
+                ent.opcode = _UTRACE_EVENT_CLONE;
+                ent.trace_clone.child = child->pid;
+                ent.trace_clone.flags = clone_flags;
+                process_trace(& ent);
+        }
+
+        process_trace_tryattach (child);
+                        
+        return action;
+}
+
+
+u32 process_trace_report_exec (enum utrace_resume_action action,
+                               struct utrace_attached_engine *engine,
+                               struct task_struct *task,
+                               const struct linux_binfmt *fmt,
+                               const struct linux_binprm *bprm,
+                               struct pt_regs *regs) 
+{
+        if (trace_test (task)) {
+                struct process_trace_entry ent;
+                ent.opcode = _UTRACE_EVENT_EXEC;
+                process_trace(& ent);
+        }
+
+        /* We're already attached; no need for a new tryattach. */
+
+        return action;
+}
+
+
+u32 process_trace_report_signal (u32 action,
+                                 struct utrace_attached_engine *engine,
+                                 struct task_struct *task,
+                                 struct pt_regs *regs,
+                                 siginfo_t *info,
+                                 const struct k_sigaction *orig_ka,
+                                 struct k_sigaction *return_ka)
+{
+        if (trace_test (task)) {
+                struct process_trace_entry ent;
+                ent.opcode = _UTRACE_EVENT_SIGNAL;
+                ent.trace_signal.si_signo = info->si_signo;
+                ent.trace_signal.si_errno = info->si_errno;
+                ent.trace_signal.si_code = info->si_code;
+                process_trace(& ent);
+        }
+
+        /* We're already attached; no need for a new tryattach. */
+
+        return action;
+}
+
+
+u32 process_trace_report_exit (enum utrace_resume_action action,
+                               struct utrace_attached_engine *engine,
+                               struct task_struct *task,
+                               long orig_code, long *code) 
+{
+        if (trace_test (task)) {
+                struct process_trace_entry ent;
+                ent.opcode = _UTRACE_EVENT_EXIT;
+                ent.trace_exit.code = orig_code;
+                process_trace(& ent);
+        }
+
+        /* There is no need to explicitly attach or detach here. */
+
+        return action;
+}
+
+
+void enable_process_trace () { 
+        struct task_struct *grp, *tsk;
+
+        pr_debug("in %s\n", __func__);
+        rcu_read_lock();
+        do_each_thread(grp, tsk) {
+                struct mm_struct *mm;
+
+                /* Skip over kernel threads. */
+                mm = get_task_mm (tsk);
+                if (!mm)
+                        continue;
+                
+                if (process_follow_pid) {
+                        if (tsk->tgid == process_follow_pid ||
+                            tsk->parent->tgid == process_follow_pid)
+                        process_trace_tryattach (tsk);
+                } else {
+                        process_trace_tryattach (tsk);
+                }
+        } while_each_thread(grp, tsk);
+        rcu_read_unlock();
+}
+
+void disable_process_trace () {
+        struct utrace_attached_engine *engine;
+        struct task_struct *grp, *tsk;
+        int rc;
+
+        pr_debug("in %s\n", __func__);
+        rcu_read_lock();
+        do_each_thread(grp, tsk) {
+                if (tsk->pid <= 1)
+                        continue;
+
+                /* Find matching engine, if any.  Returns -ENOENT for
+                   unattached threads. */ 
+                engine = utrace_attach_task (tsk, UTRACE_ATTACH_MATCH_OPS,
+                                             & process_trace_ops, 0);
+                if (IS_ERR(engine)) {
+                        if (PTR_ERR(engine) != -ENOENT)
+                                pr_warning ("utrace_attach_task %d (rc %ld)\n",
+                                            tsk->pid, -PTR_ERR(engine));
+                } else if (engine == NULL) {
+                        pr_warning ("utrace_attach_task %d (null engine)\n",
+                                    tsk->pid);
+                } else {
+                        /* Found one of our own engines.  Detach.  */
+                        rc = utrace_control (tsk, engine, UTRACE_DETACH);
+                        switch (rc) {
+                        case 0:             /* success */
+                                break;
+                        case -ESRCH:        /* REAP callback already begun */
+                        case -EALREADY:     /* DEATH callback already begun */
+                                break;
+                        default:
+                                rc = -rc;
+                                pr_warning ("utrace_detach %d (rc %d)\n",
+                                            tsk->pid, rc);
+                                break;
+                        }
+                        utrace_engine_put(engine);
+                        pr_debug("detached in %s from %s(%d)\n", __func__, tsk->comm, tsk->pid);
+                }
+        } while_each_thread(grp, tsk);
+        rcu_read_unlock();
+}
+
+
+static struct utrace_engine_ops process_trace_ops __read_mostly = {
+        .report_clone = process_trace_report_clone,
+        .report_exec = process_trace_report_exec,
+        .report_exit = process_trace_report_exit,
+        .report_signal = process_trace_report_signal,
+};
+
+
+
+/* control interfaces */
+
+static struct debugfs_blob_wrapper trace_taskcomm_filter_blob = {
+        .data = trace_taskcomm_filter,
+        .size = sizeof (trace_taskcomm_filter),
+};
+
+static __init int init_process_trace(void)
+{
+        struct dentry *d_tracer;
+        struct dentry *entry;
+
+        d_tracer = tracing_init_dentry();
+
+        entry = debugfs_create_blob("process_trace_taskcomm_filter", 0644, d_tracer,
+                                    & trace_taskcomm_filter_blob);
+        if (!entry)
+                pr_warning("Could not create debugfs 'process_trace_taskcomm_filter' entry\n");
+
+        entry = debugfs_create_u32("process_trace_uid_filter", 0644, d_tracer,
+                                   & trace_taskuid_filter);
+        if (!entry)
+                pr_warning("Could not create debugfs 'process_trace_uid_filter' entry\n");
+
+        entry = debugfs_create_u32("process_follow_pid", 0644, d_tracer,
+                                   & process_follow_pid);
+        if (!entry)
+                pr_warning("Could not create debugfs 'process_follow_pid' entry\n");
+
+	return register_tracer(&process_tracer);
+}
+
+device_initcall(init_process_trace);

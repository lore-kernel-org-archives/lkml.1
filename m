Return-Path: <linux-kernel-owner+w=401wt.eu-S1756660AbZKDP07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660AbZKDP07 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 10:26:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751187AbZKDP05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 10:26:57 -0500
Received: from hera.kernel.org ([140.211.167.34]:57367 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756585AbZKDP0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 10:26:34 -0500
Date: Wed, 4 Nov 2009 15:25:42 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, hpa@zytor.com, fche@redhat.com,
       linux-kernel@vger.kernel.org, jkenisto@us.ibm.com, hch@infradead.org,
       ananth@in.ibm.com, srikar@linux.vnet.ibm.com, prasad@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, hpa@zytor.com, fche@redhat.com,
       linux-kernel@vger.kernel.org, jkenisto@us.ibm.com, hch@infradead.org,
       ananth@in.ibm.com, srikar@linux.vnet.ibm.com, prasad@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <20091104001247.3454.14131.stgit@harusame>
References: <20091104001247.3454.14131.stgit@harusame>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] tracing/kprobes: Rename Kprobe-tracer to kprobe-event
Message-ID: <tip-77b44d1b7c28360910cdbd427fb62d485c08674c@git.kernel.org>
Git-Commit-ID: 77b44d1b7c28360910cdbd427fb62d485c08674c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  77b44d1b7c28360910cdbd427fb62d485c08674c
Gitweb:     http://git.kernel.org/tip/77b44d1b7c28360910cdbd427fb62d485c08674c
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 3 Nov 2009 19:12:47 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 4 Nov 2009 13:02:48 +0100

tracing/kprobes: Rename Kprobe-tracer to kprobe-event

Rename Kprobes-based event tracer to kprobes-based tracing event
(kprobe-event), since it is not a tracer but an extensible
tracing event interface.

This also changes CONFIG_KPROBE_TRACER to CONFIG_KPROBE_EVENT
and sets it y by default.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
LKML-Reference: <20091104001247.3454.14131.stgit@harusame>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/trace/kprobetrace.txt |   34 ++++++++++++++++------------------
 kernel/trace/Kconfig                |   19 ++++++++++++-------
 kernel/trace/Makefile               |    2 +-
 kernel/trace/trace_kprobe.c         |    6 ++----
 4 files changed, 31 insertions(+), 30 deletions(-)

diff --git a/Documentation/trace/kprobetrace.txt b/Documentation/trace/kprobetrace.txt
index 1541524..47aabee 100644
--- a/Documentation/trace/kprobetrace.txt
+++ b/Documentation/trace/kprobetrace.txt
@@ -1,26 +1,23 @@
-                        Kprobe-based Event Tracer
-                         =========================
+                        Kprobe-based Event Tracing
+                        ==========================
 
                  Documentation is written by Masami Hiramatsu
 
 
 Overview
 --------
-This tracer is similar to the events tracer which is based on Tracepoint
-infrastructure. Instead of Tracepoint, this tracer is based on kprobes(kprobe
-and kretprobe). It probes anywhere where kprobes can probe(this means, all
-functions body except for __kprobes functions).
+These events are similar to tracepoint based events. Instead of Tracepoint,
+this is based on kprobes (kprobe and kretprobe). So it can probe wherever
+kprobes can probe (this means, all functions body except for __kprobes
+functions). Unlike the Tracepoint based event, this can be added and removed
+dynamically, on the fly.
 
-Unlike the function tracer, this tracer can probe instructions inside of
-kernel functions. It allows you to check which instruction has been executed.
+To enable this feature, build your kernel with CONFIG_KPROBE_TRACING=y.
 
-Unlike the Tracepoint based events tracer, this tracer can add and remove
-probe points on the fly.
-
-Similar to the events tracer, this tracer doesn't need to be activated via
-current_tracer, instead of that, just set probe points via
-/sys/kernel/debug/tracing/kprobe_events. And you can set filters on each
-probe events via /sys/kernel/debug/tracing/events/kprobes/<EVENT>/filter.
+Similar to the events tracer, this doesn't need to be activated via
+current_tracer. Instead of that, add probe points via
+/sys/kernel/debug/tracing/kprobe_events, and enable it via
+/sys/kernel/debug/tracing/events/kprobes/<EVENT>/enabled.
 
 
 Synopsis of kprobe_events
@@ -55,9 +52,9 @@ Per-Probe Event Filtering
 -------------------------
  Per-probe event filtering feature allows you to set different filter on each
 probe and gives you what arguments will be shown in trace buffer. If an event
-name is specified right after 'p:' or 'r:' in kprobe_events, the tracer adds
-an event under tracing/events/kprobes/<EVENT>, at the directory you can see
-'id', 'enabled', 'format' and 'filter'.
+name is specified right after 'p:' or 'r:' in kprobe_events, it adds an event
+under tracing/events/kprobes/<EVENT>, at the directory you can see 'id',
+'enabled', 'format' and 'filter'.
 
 enabled:
   You can enable/disable the probe by writing 1 or 0 on it.
@@ -71,6 +68,7 @@ filter:
 id:
   This shows the id of this probe event.
 
+
 Event Profiling
 ---------------
  You can check the total number of probe hits and probe miss-hits via
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 15372a9..f056716 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -428,17 +428,22 @@ config BLK_DEV_IO_TRACE
 
 	  If unsure, say N.
 
-config KPROBE_TRACER
+config KPROBE_EVENT
 	depends on KPROBES
 	depends on X86
-	bool "Trace kprobes"
+	bool "Enable kprobes-based dynamic events"
 	select TRACING
-	select GENERIC_TRACER
+	default y
 	help
-	  This tracer probes everywhere where kprobes can probe it, and
-	  records various registers and memories specified by user.
-	  This also allows you to trace kprobe probe points as a dynamic
-	  defined events. It provides per-probe event filtering interface.
+	  This allows the user to add tracing events (similar to tracepoints) on the fly
+	  via the ftrace interface. See Documentation/trace/kprobetrace.txt
+	  for more details.
+
+	  Those events can be inserted wherever kprobes can probe, and record
+	  various register and memory values.
+
+	  This option is also required by perf-probe subcommand of perf tools. If
+	  you want to use perf tools, this option is strongly recommended.
 
 config DYNAMIC_FTRACE
 	bool "enable/disable ftrace tracepoints dynamically"
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index c8cb75d..edc3a3c 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -53,7 +53,7 @@ obj-$(CONFIG_EVENT_TRACING) += trace_export.o
 obj-$(CONFIG_FTRACE_SYSCALLS) += trace_syscalls.o
 obj-$(CONFIG_EVENT_PROFILE) += trace_event_profile.o
 obj-$(CONFIG_EVENT_TRACING) += trace_events_filter.o
-obj-$(CONFIG_KPROBE_TRACER) += trace_kprobe.o
+obj-$(CONFIG_KPROBE_EVENT) += trace_kprobe.o
 obj-$(CONFIG_EVENT_TRACING) += power-traces.o
 
 libftrace-y := ftrace.o
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index a86c3ac..cf17a66 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1,5 +1,5 @@
 /*
- * kprobe based kernel tracer
+ * Kprobes-based tracing events
  *
  * Created by Masami Hiramatsu <mhiramat@redhat.com>
  *
@@ -57,8 +57,6 @@ const char *reserved_field_names[] = {
 	FIELD_STRING_FUNC,
 };
 
-/* currently, trace_kprobe only supports X86. */
-
 struct fetch_func {
 	unsigned long (*func)(struct pt_regs *, void *);
 	void *data;
@@ -191,7 +189,7 @@ static __kprobes void free_indirect_fetch_data(struct indirect_fetch_data *data)
 }
 
 /**
- * Kprobe tracer core functions
+ * Kprobe event core functions
  */
 
 struct probe_arg {

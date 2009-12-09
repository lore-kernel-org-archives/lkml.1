Return-Path: <linux-kernel-owner+w=401wt.eu-S1758442AbZLIWkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758442AbZLIWkz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 17:40:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758376AbZLIWku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 17:40:50 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:16409 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758363AbZLIWkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 17:40:49 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzab9bhzz1202hzzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <4B202763.10604@am.sony.com>
Date: Wed, 9 Dec 2009 14:40:35 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: linux kernel <linux-kernel@vger.kernel.org>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/4] ftrace - expose tracing_thresh and global_trace
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Dec 2009 22:40:36.0653 (UTC) FILETIME=[A02A6DD0:01CA7920]
X-SEL-encryption-scan: scanned
X-Reverse-DNS: mail8.fw-sd.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make tracing_thresh and global_trace available for
function_duration tracer.

Signed-off-by: Tim Bird <tim.bird@am.sony.com>
---
 kernel/trace/trace.c |    7 ++++---
 kernel/trace/trace.h |    5 ++++-
 2 files changed, 8 insertions(+), 4 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -165,7 +165,7 @@ unsigned long long ns2usecs(cycle_t nsec
  * pages for the buffer for that CPU. Each CPU has the same number
  * of pages allocated for its buffer.
  */
-static struct trace_array	global_trace;
+struct trace_array	global_trace;

 static DEFINE_PER_CPU(struct trace_array_cpu, global_trace_cpu);

@@ -503,9 +503,10 @@ static ssize_t trace_seq_to_buffer(struc
 static raw_spinlock_t ftrace_max_lock =
 	(raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;

+unsigned long __read_mostly	tracing_thresh;
+
 #ifdef CONFIG_TRACER_MAX_TRACE
 unsigned long __read_mostly	tracing_max_latency;
-unsigned long __read_mostly	tracing_thresh;

 /*
  * Copy the new maximum trace into the separate maximum-trace
@@ -4177,9 +4178,9 @@ static __init int tracer_init_debugfs(vo
 	trace_create_file("tracing_max_latency", 0644, d_tracer,
 			&tracing_max_latency, &tracing_max_lat_fops);

+#endif
 	trace_create_file("tracing_thresh", 0644, d_tracer,
 			&tracing_thresh, &tracing_max_lat_fops);
-#endif

 	trace_create_file("README", 0444, d_tracer,
 			NULL, &tracing_readme_fops);
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -157,6 +157,8 @@ struct trace_array {
 	struct trace_array_cpu	*data[NR_CPUS];
 };

+extern struct trace_array	global_trace;
+
 #define FTRACE_CMP_TYPE(var, type) \
 	__builtin_types_compatible_p(typeof(var), type *)

@@ -366,9 +368,10 @@ int is_tracing_stopped(void);

 extern unsigned long nsecs_to_usecs(unsigned long nsecs);

+extern unsigned long tracing_thresh;
+
 #ifdef CONFIG_TRACER_MAX_TRACE
 extern unsigned long tracing_max_latency;
-extern unsigned long tracing_thresh;

 void update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu);
 void update_max_tr_single(struct trace_array *tr,



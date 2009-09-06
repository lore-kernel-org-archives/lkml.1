Return-Path: <linux-kernel-owner+w=401wt.eu-S1751424AbZIFEhC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424AbZIFEhC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 00:37:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751034AbZIFEhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 00:37:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:46899 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863AbZIFEg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 00:36:59 -0400
Date: Sun, 6 Sep 2009 04:36:45 GMT
From: tip-bot for Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org,
       albin.tonnerre@free-electrons.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org,
       albin.tonnerre@free-electrons.com, tglx@linutronix.de
In-Reply-To: <20090831204007.GE4237@pc-ras4041.res.insa>
References: <20090831204007.GE4237@pc-ras4041.res.insa>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Remove mentioning of legacy latency_trace file from documentation
Message-ID: <tip-4a88d44ab17da5f8a238050d1b43dfd2e204bc2f@git.kernel.org>
Git-Commit-ID: 4a88d44ab17da5f8a238050d1b43dfd2e204bc2f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 06 Sep 2009 04:36:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4a88d44ab17da5f8a238050d1b43dfd2e204bc2f
Gitweb:     http://git.kernel.org/tip/4a88d44ab17da5f8a238050d1b43dfd2e204bc2f
Author:     Albin Tonnerre <albin.tonnerre@free-electrons.com>
AuthorDate: Mon, 31 Aug 2009 22:40:08 +0200
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Fri, 4 Sep 2009 23:30:38 +0200

tracing: Remove mentioning of legacy latency_trace file from documentation

The latency_trace file got removed a while back by commit
886b5b73d71e4027d7dc6c14f5f7ab102201ea6b and has been replaced
by the latency-format option.

This patch fixes the documentation by reflecting this change.

Changes since v1:
 - mention that the trace format is configurable through the
   latency-format option
 - Fix a couple mistakes related to the timestamps

Signed-off-by: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20090831204007.GE4237@pc-ras4041.res.insa>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>


---
 Documentation/trace/ftrace.txt |   68 +++++++++++++++++++++-------------------
 1 files changed, 36 insertions(+), 32 deletions(-)

diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index a39b3c7..355d0f1 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -85,26 +85,19 @@ of ftrace. Here is a list of some of the key files:
 	This file holds the output of the trace in a human
 	readable format (described below).
 
-  latency_trace:
-
-	This file shows the same trace but the information
-	is organized more to display possible latencies
-	in the system (described below).
-
   trace_pipe:
 
 	The output is the same as the "trace" file but this
 	file is meant to be streamed with live tracing.
-	Reads from this file will block until new data
-	is retrieved. Unlike the "trace" and "latency_trace"
-	files, this file is a consumer. This means reading
-	from this file causes sequential reads to display
-	more current data. Once data is read from this
-	file, it is consumed, and will not be read
-	again with a sequential read. The "trace" and
-	"latency_trace" files are static, and if the
-	tracer is not adding more data, they will display
-	the same information every time they are read.
+	Reads from this file will block until new data is
+	retrieved.  Unlike the "trace" file, this file is a
+	consumer. This means reading from this file causes
+	sequential reads to display more current data. Once
+	data is read from this file, it is consumed, and
+	will not be read again with a sequential read. The
+	"trace" file is static, and if the tracer is not
+	adding more data,they will display the same
+	information every time they are read.
 
   trace_options:
 
@@ -117,10 +110,10 @@ of ftrace. Here is a list of some of the key files:
 	Some of the tracers record the max latency.
 	For example, the time interrupts are disabled.
 	This time is saved in this file. The max trace
-	will also be stored, and displayed by either
-	"trace" or "latency_trace".  A new max trace will
-	only be recorded if the latency is greater than
-	the value in this file. (in microseconds)
+	will also be stored, and displayed by "trace".
+	A new max trace will only be recorded if the
+	latency is greater than the value in this
+	file. (in microseconds)
 
   buffer_size_kb:
 
@@ -210,7 +203,7 @@ Here is the list of current tracers that may be configured.
 	the trace with the longest max latency.
 	See tracing_max_latency. When a new max is recorded,
 	it replaces the old trace. It is best to view this
-	trace via the latency_trace file.
+	trace with the latency-format option enabled.
 
   "preemptoff"
 
@@ -307,8 +300,8 @@ the lowest priority thread (pid 0).
 Latency trace format
 --------------------
 
-For traces that display latency times, the latency_trace file
-gives somewhat more information to see why a latency happened.
+When the latency-format option is enabled, the trace file gives
+somewhat more information to see why a latency happened.
 Here is a typical trace.
 
 # tracer: irqsoff
@@ -380,9 +373,10 @@ explains which is which.
 
 The above is mostly meaningful for kernel developers.
 
-  time: This differs from the trace file output. The trace file output
-	includes an absolute timestamp. The timestamp used by the
-	latency_trace file is relative to the start of the trace.
+  time: When the latency-format option is enabled, the trace file
+	output includes a timestamp relative to the start of the
+	trace. This differs from the output when latency-format
+	is disabled, which includes an absolute timestamp.
 
   delay: This is just to help catch your eye a bit better. And
 	 needs to be fixed to be only relative to the same CPU.
@@ -440,7 +434,8 @@ Here are the available options:
   sym-addr:
    bash-4000  [01]  1477.606694: simple_strtoul <c0339346>
 
-  verbose - This deals with the latency_trace file.
+  verbose - This deals with the trace file when the
+            latency-format option is enabled.
 
     bash  4000 1 0 00000000 00010a95 [58127d26] 1720.415ms \
     (+0.000ms): simple_strtoul (strict_strtoul)
@@ -472,7 +467,7 @@ Here are the available options:
 		the app is no longer running
 
 		The lookup is performed when you read
-		trace,trace_pipe,latency_trace. Example:
+		trace,trace_pipe. Example:
 
 		a.out-1623  [000] 40874.465068: /root/a.out[+0x480] <-/root/a.out[+0
 x494] <- /root/a.out[+0x4a8] <- /lib/libc-2.7.so[+0x1e1a6]
@@ -481,6 +476,11 @@ x494] <- /root/a.out[+0x4a8] <- /lib/libc-2.7.so[+0x1e1a6]
 	       every scheduling event. Will add overhead if
 	       there's a lot of tasks running at once.
 
+  latency-format - This option changes the trace. When
+                   it is enabled, the trace displays
+                   additional information about the
+                   latencies, as described in "Latency
+                   trace format".
 
 sched_switch
 ------------
@@ -596,12 +596,13 @@ To reset the maximum, echo 0 into tracing_max_latency. Here is
 an example:
 
  # echo irqsoff > current_tracer
+ # echo latency-format > trace_options
  # echo 0 > tracing_max_latency
  # echo 1 > tracing_enabled
  # ls -ltr
  [...]
  # echo 0 > tracing_enabled
- # cat latency_trace
+ # cat trace
 # tracer: irqsoff
 #
 irqsoff latency trace v1.1.5 on 2.6.26
@@ -703,12 +704,13 @@ which preemption was disabled. The control of preemptoff tracer
 is much like the irqsoff tracer.
 
  # echo preemptoff > current_tracer
+ # echo latency-format > trace_options
  # echo 0 > tracing_max_latency
  # echo 1 > tracing_enabled
  # ls -ltr
  [...]
  # echo 0 > tracing_enabled
- # cat latency_trace
+ # cat trace
 # tracer: preemptoff
 #
 preemptoff latency trace v1.1.5 on 2.6.26-rc8
@@ -850,12 +852,13 @@ Again, using this trace is much like the irqsoff and preemptoff
 tracers.
 
  # echo preemptirqsoff > current_tracer
+ # echo latency-format > trace_options
  # echo 0 > tracing_max_latency
  # echo 1 > tracing_enabled
  # ls -ltr
  [...]
  # echo 0 > tracing_enabled
- # cat latency_trace
+ # cat trace
 # tracer: preemptirqsoff
 #
 preemptirqsoff latency trace v1.1.5 on 2.6.26-rc8
@@ -1012,11 +1015,12 @@ Instead of performing an 'ls', we will run 'sleep 1' under
 'chrt' which changes the priority of the task.
 
  # echo wakeup > current_tracer
+ # echo latency-format > trace_options
  # echo 0 > tracing_max_latency
  # echo 1 > tracing_enabled
  # chrt -f 5 sleep 1
  # echo 0 > tracing_enabled
- # cat latency_trace
+ # cat trace
 # tracer: wakeup
 #
 wakeup latency trace v1.1.5 on 2.6.26-rc8

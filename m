Return-Path: <linux-kernel-owner+w=401wt.eu-S1754053AbZHaSuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbZHaSuu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 14:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753197AbZHaSus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 14:50:48 -0400
Received: from mail.free-electrons.com ([88.191.76.200]:49188 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbZHaSur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 14:50:47 -0400
From: Albin Tonnerre <albin.tonnerre@free-electrons.com>
To: srostedt@redhat.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
       Albin Tonnerre <albin.tonnerre@free-electrons.com>
Subject: [PATCH] tracing: remove mentioning of legacy latency_trace file from documentation
Date: Mon, 31 Aug 2009 20:50:35 +0200
Message-Id: <1251744635-14926-1-git-send-email-albin.tonnerre@free-electrons.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latency_trace file got removed a while back by commit
886b5b73d71e4027d7dc6c14f5f7ab102201ea6b. This patch fixes the
documentation to stop mentioning it.

Signed-off-by: Albin Tonnerre <albin.tonnerre@free-electrons.com>
---
 Documentation/trace/ftrace.txt |   55 +++++++++++++++++----------------------
 1 files changed, 24 insertions(+), 31 deletions(-)

diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index a39b3c7..3f058ab 100644
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
 
@@ -209,8 +202,7 @@ Here is the list of current tracers that may be configured.
 	Traces the areas that disable interrupts and saves
 	the trace with the longest max latency.
 	See tracing_max_latency. When a new max is recorded,
-	it replaces the old trace. It is best to view this
-	trace via the latency_trace file.
+	it replaces the old trace.
 
   "preemptoff"
 
@@ -307,8 +299,8 @@ the lowest priority thread (pid 0).
 Latency trace format
 --------------------
 
-For traces that display latency times, the latency_trace file
-gives somewhat more information to see why a latency happened.
+For traces that display latency times, the trace file gives
+somewhat more information to see why a latency happened.
 Here is a typical trace.
 
 # tracer: irqsoff
@@ -382,7 +374,7 @@ The above is mostly meaningful for kernel developers.
 
   time: This differs from the trace file output. The trace file output
 	includes an absolute timestamp. The timestamp used by the
-	latency_trace file is relative to the start of the trace.
+	trace file is relative to the start of the trace.
 
   delay: This is just to help catch your eye a bit better. And
 	 needs to be fixed to be only relative to the same CPU.
@@ -440,7 +432,8 @@ Here are the available options:
   sym-addr:
    bash-4000  [01]  1477.606694: simple_strtoul <c0339346>
 
-  verbose - This deals with the latency_trace file.
+  verbose - This deals with the trace file when it
+            displays lantecy times.
 
     bash  4000 1 0 00000000 00010a95 [58127d26] 1720.415ms \
     (+0.000ms): simple_strtoul (strict_strtoul)
@@ -472,7 +465,7 @@ Here are the available options:
 		the app is no longer running
 
 		The lookup is performed when you read
-		trace,trace_pipe,latency_trace. Example:
+		trace,trace_pipe. Example:
 
 		a.out-1623  [000] 40874.465068: /root/a.out[+0x480] <-/root/a.out[+0
 x494] <- /root/a.out[+0x4a8] <- /lib/libc-2.7.so[+0x1e1a6]
@@ -601,7 +594,7 @@ an example:
  # ls -ltr
  [...]
  # echo 0 > tracing_enabled
- # cat latency_trace
+ # cat trace
 # tracer: irqsoff
 #
 irqsoff latency trace v1.1.5 on 2.6.26
@@ -708,7 +701,7 @@ is much like the irqsoff tracer.
  # ls -ltr
  [...]
  # echo 0 > tracing_enabled
- # cat latency_trace
+ # cat trace
 # tracer: preemptoff
 #
 preemptoff latency trace v1.1.5 on 2.6.26-rc8
@@ -855,7 +848,7 @@ tracers.
  # ls -ltr
  [...]
  # echo 0 > tracing_enabled
- # cat latency_trace
+ # cat trace
 # tracer: preemptirqsoff
 #
 preemptirqsoff latency trace v1.1.5 on 2.6.26-rc8
@@ -1016,7 +1009,7 @@ Instead of performing an 'ls', we will run 'sleep 1' under
  # echo 1 > tracing_enabled
  # chrt -f 5 sleep 1
  # echo 0 > tracing_enabled
- # cat latency_trace
+ # cat trace
 # tracer: wakeup
 #
 wakeup latency trace v1.1.5 on 2.6.26-rc8
-- 
1.6.3.3


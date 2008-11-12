Return-Path: <linux-kernel-owner+w=401wt.eu-S1755227AbYKLWzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227AbYKLWzS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 17:55:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbYKLWzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 17:55:04 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:44109 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534AbYKLWzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 17:55:03 -0500
Message-Id: <20081112225500.895400389@goodmis.org>
References: <20081112225235.056515739@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 12 Nov 2008 17:52:36 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       David Miller <davem@davemloft.net>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/3] ftrace: rename trace_entries to buffer_size
Content-Disposition: inline; filename=0001-ftrace-rename-trace_entries-to-buffer_size.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: rename of debugfs file trace_entries to buffer_size

The original ftrace had fixed size entries, and the number of entries
was shown and modified via the file called trace_entries. By converting
to the unified trace buffer, we now allow for variable size entries
which makes the meaning of trace_entries pointless.

Since trace_size might be confused to the size of the trace, this patch
names it "buffer_size" (thanks to Arjan van de Ven for this idea).

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 Documentation/ftrace.txt |   18 +++++++++---------
 kernel/trace/trace.c     |    4 ++--
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/Documentation/ftrace.txt b/Documentation/ftrace.txt
index 9cc4d68..58cba1f 100644
--- a/Documentation/ftrace.txt
+++ b/Documentation/ftrace.txt
@@ -94,7 +94,7 @@ of ftrace. Here is a list of some of the key files:
 		only be recorded if the latency is greater than
 		the value in this file. (in microseconds)
 
-  trace_entries: This sets or displays the number of bytes each CPU
+  buffer_size: This sets or displays the number of bytes each CPU
 		buffer can hold. The tracer buffers are the same size
 		for each CPU. The displayed number is the size of the
 		 CPU buffer and not total size of all buffers. The
@@ -1299,13 +1299,13 @@ trace entries
 -------------
 
 Having too much or not enough data can be troublesome in diagnosing
-an issue in the kernel. The file trace_entries is used to modify
+an issue in the kernel. The file buffer_size is used to modify
 the size of the internal trace buffers. The number listed
 is the number of entries that can be recorded per CPU. To know
 the full size, multiply the number of possible CPUS with the
 number of entries.
 
- # cat /debug/tracing/trace_entries
+ # cat /debug/tracing/buffer_size
 65620
 
 Note, to modify this, you must have tracing completely disabled. To do that,
@@ -1313,8 +1313,8 @@ echo "nop" into the current_tracer. If the current_tracer is not set
 to "nop", an EINVAL error will be returned.
 
  # echo nop > /debug/tracing/current_tracer
- # echo 100000 > /debug/tracing/trace_entries
- # cat /debug/tracing/trace_entries
+ # echo 100000 > /debug/tracing/buffer_size
+ # cat /debug/tracing/buffer_size
 100045
 
 
@@ -1323,8 +1323,8 @@ are held in individual pages. It allocates the number of pages it takes
 to fulfill the request. If more entries may fit on the last page
 then they will be added.
 
- # echo 1 > /debug/tracing/trace_entries
- # cat /debug/tracing/trace_entries
+ # echo 1 > /debug/tracing/buffer_size
+ # cat /debug/tracing/buffer_size
 85
 
 This shows us that 85 entries can fit in a single page.
@@ -1332,8 +1332,8 @@ This shows us that 85 entries can fit in a single page.
 The number of pages which will be allocated is limited to a percentage
 of available memory. Allocating too much will produce an error.
 
- # echo 1000000000000 > /debug/tracing/trace_entries
+ # echo 1000000000000 > /debug/tracing/buffer_size
 -bash: echo: write error: Cannot allocate memory
- # cat /debug/tracing/trace_entries
+ # cat /debug/tracing/buffer_size
 85
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 4bf070b..c681778 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3198,11 +3198,11 @@ static __init int tracer_init_debugfs(void)
 		pr_warning("Could not create debugfs "
 			   "'trace_pipe' entry\n");
 
-	entry = debugfs_create_file("trace_entries", 0644, d_tracer,
+	entry = debugfs_create_file("buffer_size", 0644, d_tracer,
 				    &global_trace, &tracing_entries_fops);
 	if (!entry)
 		pr_warning("Could not create debugfs "
-			   "'trace_entries' entry\n");
+			   "'buffer_size' entry\n");
 
 	entry = debugfs_create_file("trace_marker", 0220, d_tracer,
 				    NULL, &tracing_mark_fops);
-- 
1.5.6.5

-- 

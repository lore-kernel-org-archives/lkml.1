Return-Path: <linux-kernel-owner+w=401wt.eu-S1756465AbYKCUP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465AbYKCUP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 15:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbYKCUPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 15:15:14 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:52004 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592AbYKCUPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 15:15:12 -0500
Date: Mon, 3 Nov 2008 15:15:08 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Randy Dunlap <randy.dunlap@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] ftrace: update txt document
In-Reply-To: <alpine.DEB.1.10.0810311102280.20404@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.1.10.0811031514120.16323@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0810231921590.4182@gandalf.stny.rr.com> <20081026193339.91e0c644.randy.dunlap@oracle.com> <alpine.DEB.1.10.0810311102280.20404@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: Documentation update only

A lot of changes have gone into ftrace. This patch updates
the ftrace.txt document.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/ftrace.txt |  169 ++++++++++++++++++++---------------------------
 1 file changed, 72 insertions(+), 97 deletions(-)

Index: linux-tip.git/Documentation/ftrace.txt
===================================================================
--- linux-tip.git.orig/Documentation/ftrace.txt	2008-10-31 11:01:08.000000000 -0400
+++ linux-tip.git/Documentation/ftrace.txt	2008-10-31 11:02:00.000000000 -0400
@@ -50,26 +50,26 @@ of ftrace. Here is a list of some of the
 
  Note: all time values are in microseconds.
 
-  current_tracer : This is used to set or display the current tracer
+  current_tracer: This is used to set or display the current tracer
 		that is configured.
 
-  available_tracers : This holds the different types of tracers that
+  available_tracers: This holds the different types of tracers that
 		have been compiled into the kernel. The tracers
 		listed here can be configured by echoing their name
 		into current_tracer.
 
-  tracing_enabled : This sets or displays whether the current_tracer
+  tracing_enabled: This sets or displays whether the current_tracer
 		is activated and tracing or not. Echo 0 into this
 		file to disable the tracer or 1 to enable it.
 
-  trace : This file holds the output of the trace in a human readable
+  trace: This file holds the output of the trace in a human readable
 		format (described below).
 
-  latency_trace : This file shows the same trace but the information
+  latency_trace: This file shows the same trace but the information
 		is organized more to display possible latencies
 		in the system (described below).
 
-  trace_pipe : The output is the same as the "trace" file but this
+  trace_pipe: The output is the same as the "trace" file but this
 		file is meant to be streamed with live tracing.
 		Reads from this file will block until new data
 		is retrieved. Unlike the "trace" and "latency_trace"
@@ -82,11 +82,11 @@ of ftrace. Here is a list of some of the
 		tracer is not adding more data, they will display
 		the same information every time they are read.
 
-  iter_ctrl : This file lets the user control the amount of data
+  iter_ctrl: This file lets the user control the amount of data
 		that is displayed in one of the above output
 		files.
 
-  trace_max_latency : Some of the tracers record the max latency.
+  trace_max_latency: Some of the tracers record the max latency.
 		For example, the time interrupts are disabled.
 		This time is saved in this file. The max trace
 		will also be stored, and displayed by either
@@ -94,29 +94,26 @@ of ftrace. Here is a list of some of the
 		only be recorded if the latency is greater than
 		the value in this file. (in microseconds)
 
-  trace_entries : This sets or displays the number of trace
-		entries each CPU buffer can hold. The tracer buffers
-		are the same size for each CPU. The displayed number
-		is the size of the CPU buffer and not total size. The
+  trace_entries: This sets or displays the number of bytes each CPU
+		buffer can hold. The tracer buffers are the same size
+		for each CPU. The displayed number is the size of the
+		 CPU buffer and not total size of all buffers. The
 		trace buffers are allocated in pages (blocks of memory
 		that the kernel uses for allocation, usually 4 KB in size).
-		Since each entry is smaller than a page, if the last
-		allocated page has room for more entries than were
-		requested, the rest of the page is used to allocate
-		entries.
+		If the last page allocated has room for more bytes
+		than requested, the rest of the page will be used,
+		making the actual allocation bigger than requested.
+		(Note, the size may not be a multiple of the page size due
+		to buffer managment overhead.)
 
 		This can only be updated when the current_tracer
-		is set to "none".
+		is set to "nop".
 
-		NOTE: It is planned on changing the allocated buffers
-		      from being the number of possible CPUS to
-		      the number of online CPUS.
-
-  tracing_cpumask : This is a mask that lets the user only trace
+  tracing_cpumask: This is a mask that lets the user only trace
 		on specified CPUS. The format is a hex string
 		representing the CPUS.
 
-  set_ftrace_filter : When dynamic ftrace is configured in (see the
+  set_ftrace_filter: When dynamic ftrace is configured in (see the
 		section below "dynamic ftrace"), the code is dynamically
 		modified (code text rewrite) to disable calling of the
 		function profiler (mcount). This lets tracing be configured
@@ -130,14 +127,11 @@ of ftrace. Here is a list of some of the
 		be traced. If a function exists in both set_ftrace_filter
 		and set_ftrace_notrace,	the function will _not_ be traced.
 
-  available_filter_functions : When a function is encountered the first
-		time by the dynamic tracer, it is recorded and
-		later the call is converted into a nop. This file
-		lists the functions that have been recorded
-		by the dynamic tracer and these functions can
-		be used to set the ftrace filter by the above
-		"set_ftrace_filter" file. (See the section "dynamic ftrace"
-		below for more details).
+  available_filter_functions: This lists the functions that ftrace
+		has processed and can trace. These are the function
+		names that you can pass to "set_ftrace_filter" or
+		"set_ftrace_notrace". (See the section "dynamic ftrace"
+		below for more details.)
 
 
 The Tracers
@@ -145,7 +139,7 @@ The Tracers
 
 Here is the list of current tracers that may be configured.
 
-  ftrace - function tracer that uses mcount to trace all functions.
+  function - function tracer that uses mcount to trace all functions.
 
   sched_switch - traces the context switches between tasks.
 
@@ -166,8 +160,8 @@ Here is the list of current tracers that
 		the highest priority task to get scheduled after
 		it has been woken up.
 
-  none - This is not a tracer. To remove all tracers from tracing
-		simply echo "none" into current_tracer.
+  nop - This is not a tracer. To remove all tracers from tracing
+		simply echo "nop" into current_tracer.
 
 
 Examples of using the tracer
@@ -182,7 +176,7 @@ Output format:
 Here is an example of the output format of the file "trace"
 
                              --------
-# tracer: ftrace
+# tracer: function
 #
 #           TASK-PID   CPU#    TIMESTAMP  FUNCTION
 #              | |      |          |         |
@@ -192,7 +186,7 @@ Here is an example of the output format 
                              --------
 
 A header is printed with the tracer name that is represented by the trace.
-In this case the tracer is "ftrace". Then a header showing the format. Task
+In this case the tracer is "function". Then a header showing the format. Task
 name "bash", the task PID "4251", the CPU that it was running on
 "01", the timestamp in <secs>.<usecs> format, the function name that was
 traced "path_put" and the parent function that called this function
@@ -1000,22 +994,20 @@ is the stack for the hard interrupt. Thi
 has been set. We do not see the 'N' until we switch back to the task's
 assigned stack.
 
-ftrace
-------
+function
+--------
 
-ftrace is not only the name of the tracing infrastructure, but it
-is also a name of one of the tracers. The tracer is the function
-tracer. Enabling the function tracer can be done from the
-debug file system. Make sure the ftrace_enabled is set otherwise
-this tracer is a nop.
+This tracer is the function tracer. Enabling the function tracer
+can be done from the debug file system. Make sure the ftrace_enabled is
+set; otherwise this tracer is a nop.
 
  # sysctl kernel.ftrace_enabled=1
- # echo ftrace > /debug/tracing/current_tracer
+ # echo function > /debug/tracing/current_tracer
  # echo 1 > /debug/tracing/tracing_enabled
  # usleep 1
  # echo 0 > /debug/tracing/tracing_enabled
  # cat /debug/tracing/trace
-# tracer: ftrace
+# tracer: function
 #
 #           TASK-PID   CPU#    TIMESTAMP  FUNCTION
 #              | |      |          |         |
@@ -1037,10 +1029,10 @@ this tracer is a nop.
 [...]
 
 
-Note: ftrace uses ring buffers to store the above entries. The newest data
-may overwrite the oldest data. Sometimes using echo to stop the trace
-is not sufficient because the tracing could have overwritten the data
-that you wanted to record. For this reason, it is sometimes better to
+Note: function tracer uses ring buffers to store the above entries.
+The newest data may overwrite the oldest data. Sometimes using echo to
+stop the trace is not sufficient because the tracing could have overwritten
+the data that you wanted to record. For this reason, it is sometimes better to
 disable tracing directly from a program. This allows you to stop the
 tracing at the point that you hit the part that you are interested in.
 To disable the tracing directly from a C program, something like following
@@ -1074,18 +1066,31 @@ every kernel function, produced by the -
 of pointing to a simple return. (Enabling FTRACE will include the
 -pg switch in the compiling of the kernel.)
 
-When dynamic ftrace is initialized, it calls kstop_machine to make
-the machine act like a uniprocessor so that it can freely modify code
-without worrying about other processors executing that same code.  At
-initialization, the mcount calls are changed to call a "record_ip"
-function.  After this, the first time a kernel function is called,
-it has the calling address saved in a hash table.
-
-Later on the ftraced kernel thread is awoken and will again call
-kstop_machine if new functions have been recorded. The ftraced thread
-will change all calls to mcount to "nop".  Just calling mcount
-and having mcount return has shown a 10% overhead. By converting
-it to a nop, there is no measurable overhead to the system.
+At compile time every C file object is run through the
+recordmcount.pl script (located in the scripts directory). This
+script will process the C object using objdump to find all the
+locations in the .text section that call mcount. (Note, only
+the .text section is processed, since processing other sections
+like .init.text may cause races due to those sections being freed).
+
+A new section called "__mcount_loc" is created that holds references
+to all the mcount call sites in the .text section. This section is
+compiled back into the original object. The final linker will add
+all these references into a single table.
+
+On boot up, before SMP is initialized, the dynamic ftrace code
+scans this table and updates all the locations into nops. It also
+records the locations, which are added to the available_filter_functions
+list.  Modules are processed as they are loaded and before they are
+executed.  When a module is unloaded, it also removes its functions from
+the ftrace function list. This is automatic in the module unload
+code, and the module author does not need to worry about it.
+
+When tracing is enabled, kstop_machine is called to prevent races
+with the CPUS executing code being modified (which can cause the
+CPU to do undesireable things), and the nops are patched back
+to calls. But this time, they do not call mcount (which is just
+a function stub). They now call into the ftrace infrastructure.
 
 One special side-effect to the recording of the functions being
 traced is that we can now selectively choose which functions we
@@ -1248,36 +1253,6 @@ Produces:
 
 We can see that there's no more lock or preempt tracing.
 
-ftraced
--------
-
-As mentioned above, when dynamic ftrace is configured in, a kernel
-thread wakes up once a second and checks to see if there are mcount
-calls that need to be converted into nops. If there are not any, then
-it simply goes back to sleep. But if there are some, it will call
-kstop_machine to convert the calls to nops.
-
-There may be a case in which you do not want this added latency.
-Perhaps you are doing some audio recording and this activity might
-cause skips in the playback. There is an interface to disable
-and enable the "ftraced" kernel thread.
-
- # echo 0 > /debug/tracing/ftraced_enabled
-
-This will disable the calling of kstop_machine to update the
-mcount calls to nops. Remember that there is a large overhead
-to calling mcount. Without this kernel thread, that overhead will
-exist.
-
-If there are recorded calls to mcount, any write to the ftraced_enabled
-file will cause the kstop_machine to run. This means that a
-user can manually perform the updates when they want to by simply
-echoing a '0' into the ftraced_enabled file.
-
-The updates are also done at the beginning of enabling a tracer
-that uses ftrace function recording.
-
-
 trace_pipe
 ----------
 
@@ -1286,14 +1261,14 @@ on the tracing is different. Every read 
 This means that subsequent reads will be different. The trace
 is live.
 
- # echo ftrace > /debug/tracing/current_tracer
+ # echo function > /debug/tracing/current_tracer
  # cat /debug/tracing/trace_pipe > /tmp/trace.out &
 [1] 4153
  # echo 1 > /debug/tracing/tracing_enabled
  # usleep 1
  # echo 0 > /debug/tracing/tracing_enabled
  # cat /debug/tracing/trace
-# tracer: ftrace
+# tracer: function
 #
 #           TASK-PID   CPU#    TIMESTAMP  FUNCTION
 #              | |      |          |         |
@@ -1314,7 +1289,7 @@ is live.
 
 Note, reading the trace_pipe file will block until more input is added.
 By changing the tracer, trace_pipe will issue an EOF. We needed
-to set the ftrace tracer _before_ cating the trace_pipe file.
+to set the function tracer _before_ we "cat" the trace_pipe file.
 
 
 trace entries
@@ -1331,10 +1306,10 @@ number of entries.
 65620
 
 Note, to modify this, you must have tracing completely disabled. To do that,
-echo "none" into the current_tracer. If the current_tracer is not set
-to "none", an EINVAL error will be returned.
+echo "nop" into the current_tracer. If the current_tracer is not set
+to "nop", an EINVAL error will be returned.
 
- # echo none > /debug/tracing/current_tracer
+ # echo nop > /debug/tracing/current_tracer
  # echo 100000 > /debug/tracing/trace_entries
  # cat /debug/tracing/trace_entries
 100045



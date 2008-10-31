Return-Path: <linux-kernel-owner+w=401wt.eu-S1753244AbYJaPFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbYJaPFX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 11:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbYJaPFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 11:05:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:34769 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbYJaPFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 11:05:01 -0400
Date: Fri, 31 Oct 2008 11:04:59 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2] ftrace: update txt document
In-Reply-To: <alpine.DEB.1.10.0810311102280.20404@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.1.10.0810311104150.20404@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0810231921590.4182@gandalf.stny.rr.com> <20081026193339.91e0c644.randy.dunlap@oracle.com> <alpine.DEB.1.10.0810311102280.20404@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


To make the above patch easier to review, here's a diff between v1 and v2.

-- Steve

--- Documentation/ftrace.txt	2008-10-31 11:01:11.000000000 -0400
+++ Documentation/ftrace.txt.hold	2008-10-31 11:01:03.000000000 -0400
@@ -50,26 +50,26 @@
 
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
@@ -82,11 +82,11 @@
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
@@ -94,25 +94,26 @@
 		only be recorded if the latency is greater than
 		the value in this file. (in microseconds)
 
-  trace_entries : This sets or displays the number of bytes each CPU
+  trace_entries: This sets or displays the number of bytes each CPU
 		buffer can hold. The tracer buffers are the same size
 		for each CPU. The displayed number is the size of the
 		 CPU buffer and not total size of all buffers. The
 		trace buffers are allocated in pages (blocks of memory
 		that the kernel uses for allocation, usually 4 KB in size).
 		If the last page allocated has room for more bytes
-		than requested, the rest of the page is used to allocate.
+		than requested, the rest of the page will be used,
+		making the actual allocation bigger than requested.
 		(Note, the size may not be a multiple of the page size due
-		to buffer managment overhead).
+		to buffer managment overhead.)
 
 		This can only be updated when the current_tracer
 		is set to "nop".
 
-  tracing_cpumask : This is a mask that lets the user only trace
+  tracing_cpumask: This is a mask that lets the user only trace
 		on specified CPUS. The format is a hex string
 		representing the CPUS.
 
-  set_ftrace_filter : When dynamic ftrace is configured in (see the
+  set_ftrace_filter: When dynamic ftrace is configured in (see the
 		section below "dynamic ftrace"), the code is dynamically
 		modified (code text rewrite) to disable calling of the
 		function profiler (mcount). This lets tracing be configured
@@ -126,11 +127,11 @@
 		be traced. If a function exists in both set_ftrace_filter
 		and set_ftrace_notrace,	the function will _not_ be traced.
 
-  available_filter_functions : This lists the functions that ftrace
+  available_filter_functions: This lists the functions that ftrace
 		has processed and can trace. These are the function
 		names that you can pass to "set_ftrace_filter" or
 		"set_ftrace_notrace". (See the section "dynamic ftrace"
-		below for more details).
+		below for more details.)
 
 
 The Tracers
@@ -998,7 +999,7 @@
 
 This tracer is the function tracer. Enabling the function tracer
 can be done from the debug file system. Make sure the ftrace_enabled is
-set otherwise this tracer is a nop.
+set; otherwise this tracer is a nop.
 
  # sysctl kernel.ftrace_enabled=1
  # echo function > /debug/tracing/current_tracer
@@ -1081,8 +1082,9 @@
 scans this table and updates all the locations into nops. It also
 records the locations, which are added to the available_filter_functions
 list.  Modules are processed as they are loaded and before they are
-executed.  They also remove their functions from the list when they
-are removed.
+executed.  When a module is unloaded, it also removes its functions from
+the ftrace function list. This is automatic in the module unload
+code, and the module author does not need to worry about it.
 
 When tracing is enabled, kstop_machine is called to prevent races
 with the CPUS executing code being modified (which can cause the
@@ -1287,7 +1289,7 @@
 
 Note, reading the trace_pipe file will block until more input is added.
 By changing the tracer, trace_pipe will issue an EOF. We needed
-to set the function tracer _before_ cating the trace_pipe file.
+to set the function tracer _before_ we "cat" the trace_pipe file.
 
 
 trace entries



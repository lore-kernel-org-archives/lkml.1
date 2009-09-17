Return-Path: <linux-kernel-owner+w=401wt.eu-S1753617AbZIQU7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617AbZIQU7V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 16:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753039AbZIQU7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 16:59:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52229 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322AbZIQU7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 16:59:15 -0400
Date: Thu, 17 Sep 2009 22:58:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       =?unknown-8bit?B?RnLDqWTDqXJpYw==?= Weisbecker 
	<fweisbec@gmail.com>
Subject: [GIT PULL] tracing updates for v2.6.32, part 2
Message-ID: <20090917205856.GA3919@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest tracing-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-core-for-linus

This is the second (and final) part of tracing updates for this window: 
a few late coming items and fixes.

 Thanks,

	Ingo

------------------>
Atsushi Tsuji (1):
      tracing: Fix minor bugs for __unregister_ftrace_function_probe

Carsten Emde (3):
      tracing: prevent NULL pointer dereference in ftrace_raw_event_block_bio_bounce
      tracing: remove unused local variables in tracer probe functions
      tracing: do not update tracing_max_latency when tracer is stopped

Christian Borntraeger (1):
      oprofile: fix oprofile regression: select RING_BUFFER_ALLOW_SWAP

Ingo Molnar (1):
      MAINTAINERS: Update tracing tree details

Jiri Olsa (1):
      tracing/function-graph: x86_64 stack allocation cleanup

John Reiser (1):
      ftrace: __start_mcount_loc should be .init.rodata

Li Zefan (9):
      tracing: remove dead code
      tracing: format clean ups
      tracing: remove stats from struct tracer
      tracing: move PRED macros to trace_events_filter.c
      tracing/profile: fix profile_disable vs module_unload
      tracing: fix F_printk() typos
      ftrace: add compile-time check on F_printk()
      tracing: remove some unused macros
      softirq: add BLOCK_IOPOLL to softirq_to_name

Mike Frysinger (1):
      ftrace: document function and function graph implementation

Robert Richter (1):
      ring-buffer: consolidate interface of rb_buffer_peek()

Steven Rostedt (21):
      tracing: do not grab lock in wakeup latency function tracing
      x86/tracing: comment need for atomic nop
      tracing: add latency format to function_graph tracer
      tracing: move tgid out of generic entry and into userstack
      tracing: add lock depth to entries
      tracing: consolidate code between trace_output.c and trace_function_graph.c
      tracing: allow filter predicates to handle ksym symbols
      tracing: use macros to create internal ftrace entry ring buffer structures
      tracing: show details of structures within the ftrace structures
      tracing: use the new trace_entries.h to create format files
      tracing: remove trace_event_types.h
      tracing: add filter event logic to special, mmiotrace and boot tracers
      ring-buffer: typecast cmpxchg to fix PowerPC warning
      tracing: add static to generated TRACE_EVENT functions
      tracing: have TRACE_EVENT macro use __flags to not shadow parameter
      tracing: make testing syscall events a separate configuration
      tracing: optimize global_trace_clock cachelines
      tracing: remove notrace from __kprobes annotation
      vsprintf: add %ps that is the same as %pS but is like %pf
      tracing: switch function prints from %pf to %ps
      vsnprintf: remove duplicate comment of vsnprintf

Tom Zanussi (1):
      tracing/filters: add filter Documentation

jolsa@redhat.com (3):
      tracing: create generic trace parser
      tracing: trace parser support for set_event
      tracing: trace parser support for function and graph


 Documentation/trace/events.txt        |  184 ++++++++++++++++-
 Documentation/trace/ftrace-design.txt |  233 ++++++++++++++++++++
 Documentation/trace/ftrace.txt        |    6 +
 MAINTAINERS                           |    7 +-
 arch/Kconfig                          |    1 +
 arch/x86/include/asm/nops.h           |    2 +
 arch/x86/kernel/entry_64.S            |    6 +-
 include/asm-generic/vmlinux.lds.h     |    5 +-
 include/linux/ftrace_event.h          |    6 +-
 include/linux/kprobes.h               |    4 +-
 include/trace/events/block.h          |    4 +-
 include/trace/events/irq.h            |   21 +-
 include/trace/ftrace.h                |    8 +-
 kernel/softirq.c                      |    2 +-
 kernel/trace/Kconfig                  |   28 +++-
 kernel/trace/ftrace.c                 |  158 ++++----------
 kernel/trace/ring_buffer.c            |   17 +-
 kernel/trace/trace.c                  |  127 +++++++++++-
 kernel/trace/trace.h                  |  276 +++++++-----------------
 kernel/trace/trace_boot.c             |    8 +-
 kernel/trace/trace_clock.c            |   24 ++-
 kernel/trace/trace_entries.h          |  383 +++++++++++++++++++++++++++++++++
 kernel/trace/trace_event_profile.c    |    5 +-
 kernel/trace/trace_event_types.h      |  178 ---------------
 kernel/trace/trace_events.c           |   79 +++-----
 kernel/trace/trace_events_filter.c    |   41 ++++
 kernel/trace/trace_export.c           |  284 +++++++++++++-----------
 kernel/trace/trace_functions.c        |    2 +-
 kernel/trace/trace_functions_graph.c  |   66 +++++-
 kernel/trace/trace_irqsoff.c          |   16 +-
 kernel/trace/trace_mmiotrace.c        |   10 +-
 kernel/trace/trace_output.c           |   42 +++-
 kernel/trace/trace_output.h           |    2 +
 kernel/trace/trace_sched_wakeup.c     |   52 +++---
 lib/vsprintf.c                        |   16 +-
 35 files changed, 1506 insertions(+), 797 deletions(-)
 create mode 100644 Documentation/trace/ftrace-design.txt
 create mode 100644 kernel/trace/trace_entries.h
 delete mode 100644 kernel/trace/trace_event_types.h

diff --git a/Documentation/trace/events.txt b/Documentation/trace/events.txt
index 90e8b33..78c45a8 100644
--- a/Documentation/trace/events.txt
+++ b/Documentation/trace/events.txt
@@ -1,7 +1,7 @@
 			     Event Tracing
 
 		Documentation written by Theodore Ts'o
-			Updated by Li Zefan
+		Updated by Li Zefan and Tom Zanussi
 
 1. Introduction
 ===============
@@ -97,3 +97,185 @@ The format of this boot option is the same as described in section 2.1.
 
 See The example provided in samples/trace_events
 
+4. Event formats
+================
+
+Each trace event has a 'format' file associated with it that contains
+a description of each field in a logged event.  This information can
+be used to parse the binary trace stream, and is also the place to
+find the field names that can be used in event filters (see section 5).
+
+It also displays the format string that will be used to print the
+event in text mode, along with the event name and ID used for
+profiling.
+
+Every event has a set of 'common' fields associated with it; these are
+the fields prefixed with 'common_'.  The other fields vary between
+events and correspond to the fields defined in the TRACE_EVENT
+definition for that event.
+
+Each field in the format has the form:
+
+     field:field-type field-name; offset:N; size:N;
+
+where offset is the offset of the field in the trace record and size
+is the size of the data item, in bytes.
+
+For example, here's the information displayed for the 'sched_wakeup'
+event:
+
+# cat /debug/tracing/events/sched/sched_wakeup/format
+
+name: sched_wakeup
+ID: 60
+format:
+	field:unsigned short common_type;	offset:0;	size:2;
+	field:unsigned char common_flags;	offset:2;	size:1;
+	field:unsigned char common_preempt_count;	offset:3;	size:1;
+	field:int common_pid;	offset:4;	size:4;
+	field:int common_tgid;	offset:8;	size:4;
+
+	field:char comm[TASK_COMM_LEN];	offset:12;	size:16;
+	field:pid_t pid;	offset:28;	size:4;
+	field:int prio;	offset:32;	size:4;
+	field:int success;	offset:36;	size:4;
+	field:int cpu;	offset:40;	size:4;
+
+print fmt: "task %s:%d [%d] success=%d [%03d]", REC->comm, REC->pid,
+	   REC->prio, REC->success, REC->cpu
+
+This event contains 10 fields, the first 5 common and the remaining 5
+event-specific.  All the fields for this event are numeric, except for
+'comm' which is a string, a distinction important for event filtering.
+
+5. Event filtering
+==================
+
+Trace events can be filtered in the kernel by associating boolean
+'filter expressions' with them.  As soon as an event is logged into
+the trace buffer, its fields are checked against the filter expression
+associated with that event type.  An event with field values that
+'match' the filter will appear in the trace output, and an event whose
+values don't match will be discarded.  An event with no filter
+associated with it matches everything, and is the default when no
+filter has been set for an event.
+
+5.1 Expression syntax
+---------------------
+
+A filter expression consists of one or more 'predicates' that can be
+combined using the logical operators '&&' and '||'.  A predicate is
+simply a clause that compares the value of a field contained within a
+logged event with a constant value and returns either 0 or 1 depending
+on whether the field value matched (1) or didn't match (0):
+
+	  field-name relational-operator value
+
+Parentheses can be used to provide arbitrary logical groupings and
+double-quotes can be used to prevent the shell from interpreting
+operators as shell metacharacters.
+
+The field-names available for use in filters can be found in the
+'format' files for trace events (see section 4).
+
+The relational-operators depend on the type of the field being tested:
+
+The operators available for numeric fields are:
+
+==, !=, <, <=, >, >=
+
+And for string fields they are:
+
+==, !=
+
+Currently, only exact string matches are supported.
+
+Currently, the maximum number of predicates in a filter is 16.
+
+5.2 Setting filters
+-------------------
+
+A filter for an individual event is set by writing a filter expression
+to the 'filter' file for the given event.
+
+For example:
+
+# cd /debug/tracing/events/sched/sched_wakeup
+# echo "common_preempt_count > 4" > filter
+
+A slightly more involved example:
+
+# cd /debug/tracing/events/sched/sched_signal_send
+# echo "((sig >= 10 && sig < 15) || sig == 17) && comm != bash" > filter
+
+If there is an error in the expression, you'll get an 'Invalid
+argument' error when setting it, and the erroneous string along with
+an error message can be seen by looking at the filter e.g.:
+
+# cd /debug/tracing/events/sched/sched_signal_send
+# echo "((sig >= 10 && sig < 15) || dsig == 17) && comm != bash" > filter
+-bash: echo: write error: Invalid argument
+# cat filter
+((sig >= 10 && sig < 15) || dsig == 17) && comm != bash
+^
+parse_error: Field not found
+
+Currently the caret ('^') for an error always appears at the beginning of
+the filter string; the error message should still be useful though
+even without more accurate position info.
+
+5.3 Clearing filters
+--------------------
+
+To clear the filter for an event, write a '0' to the event's filter
+file.
+
+To clear the filters for all events in a subsystem, write a '0' to the
+subsystem's filter file.
+
+5.3 Subsystem filters
+---------------------
+
+For convenience, filters for every event in a subsystem can be set or
+cleared as a group by writing a filter expression into the filter file
+at the root of the subsytem.  Note however, that if a filter for any
+event within the subsystem lacks a field specified in the subsystem
+filter, or if the filter can't be applied for any other reason, the
+filter for that event will retain its previous setting.  This can
+result in an unintended mixture of filters which could lead to
+confusing (to the user who might think different filters are in
+effect) trace output.  Only filters that reference just the common
+fields can be guaranteed to propagate successfully to all events.
+
+Here are a few subsystem filter examples that also illustrate the
+above points:
+
+Clear the filters on all events in the sched subsytem:
+
+# cd /sys/kernel/debug/tracing/events/sched
+# echo 0 > filter
+# cat sched_switch/filter
+none
+# cat sched_wakeup/filter
+none
+
+Set a filter using only common fields for all events in the sched
+subsytem (all events end up with the same filter):
+
+# cd /sys/kernel/debug/tracing/events/sched
+# echo common_pid == 0 > filter
+# cat sched_switch/filter
+common_pid == 0
+# cat sched_wakeup/filter
+common_pid == 0
+
+Attempt to set a filter using a non-common field for all events in the
+sched subsytem (all events but those that have a prev_pid field retain
+their old filters):
+
+# cd /sys/kernel/debug/tracing/events/sched
+# echo prev_pid == 0 > filter
+# cat sched_switch/filter
+prev_pid == 0
+# cat sched_wakeup/filter
+common_pid == 0
diff --git a/Documentation/trace/ftrace-design.txt b/Documentation/trace/ftrace-design.txt
new file mode 100644
index 0000000..7003e10
--- /dev/null
+++ b/Documentation/trace/ftrace-design.txt
@@ -0,0 +1,233 @@
+		function tracer guts
+		====================
+
+Introduction
+------------
+
+Here we will cover the architecture pieces that the common function tracing
+code relies on for proper functioning.  Things are broken down into increasing
+complexity so that you can start simple and at least get basic functionality.
+
+Note that this focuses on architecture implementation details only.  If you
+want more explanation of a feature in terms of common code, review the common
+ftrace.txt file.
+
+
+Prerequisites
+-------------
+
+Ftrace relies on these features being implemented:
+ STACKTRACE_SUPPORT - implement save_stack_trace()
+ TRACE_IRQFLAGS_SUPPORT - implement include/asm/irqflags.h
+
+
+HAVE_FUNCTION_TRACER
+--------------------
+
+You will need to implement the mcount and the ftrace_stub functions.
+
+The exact mcount symbol name will depend on your toolchain.  Some call it
+"mcount", "_mcount", or even "__mcount".  You can probably figure it out by
+running something like:
+	$ echo 'main(){}' | gcc -x c -S -o - - -pg | grep mcount
+	        call    mcount
+We'll make the assumption below that the symbol is "mcount" just to keep things
+nice and simple in the examples.
+
+Keep in mind that the ABI that is in effect inside of the mcount function is
+*highly* architecture/toolchain specific.  We cannot help you in this regard,
+sorry.  Dig up some old documentation and/or find someone more familiar than
+you to bang ideas off of.  Typically, register usage (argument/scratch/etc...)
+is a major issue at this point, especially in relation to the location of the
+mcount call (before/after function prologue).  You might also want to look at
+how glibc has implemented the mcount function for your architecture.  It might
+be (semi-)relevant.
+
+The mcount function should check the function pointer ftrace_trace_function
+to see if it is set to ftrace_stub.  If it is, there is nothing for you to do,
+so return immediately.  If it isn't, then call that function in the same way
+the mcount function normally calls __mcount_internal -- the first argument is
+the "frompc" while the second argument is the "selfpc" (adjusted to remove the
+size of the mcount call that is embedded in the function).
+
+For example, if the function foo() calls bar(), when the bar() function calls
+mcount(), the arguments mcount() will pass to the tracer are:
+	"frompc" - the address bar() will use to return to foo()
+	"selfpc" - the address bar() (with _mcount() size adjustment)
+
+Also keep in mind that this mcount function will be called *a lot*, so
+optimizing for the default case of no tracer will help the smooth running of
+your system when tracing is disabled.  So the start of the mcount function is
+typically the bare min with checking things before returning.  That also means
+the code flow should usually kept linear (i.e. no branching in the nop case).
+This is of course an optimization and not a hard requirement.
+
+Here is some pseudo code that should help (these functions should actually be
+implemented in assembly):
+
+void ftrace_stub(void)
+{
+	return;
+}
+
+void mcount(void)
+{
+	/* save any bare state needed in order to do initial checking */
+
+	extern void (*ftrace_trace_function)(unsigned long, unsigned long);
+	if (ftrace_trace_function != ftrace_stub)
+		goto do_trace;
+
+	/* restore any bare state */
+
+	return;
+
+do_trace:
+
+	/* save all state needed by the ABI (see paragraph above) */
+
+	unsigned long frompc = ...;
+	unsigned long selfpc = <return address> - MCOUNT_INSN_SIZE;
+	ftrace_trace_function(frompc, selfpc);
+
+	/* restore all state needed by the ABI */
+}
+
+Don't forget to export mcount for modules !
+extern void mcount(void);
+EXPORT_SYMBOL(mcount);
+
+
+HAVE_FUNCTION_TRACE_MCOUNT_TEST
+-------------------------------
+
+This is an optional optimization for the normal case when tracing is turned off
+in the system.  If you do not enable this Kconfig option, the common ftrace
+code will take care of doing the checking for you.
+
+To support this feature, you only need to check the function_trace_stop
+variable in the mcount function.  If it is non-zero, there is no tracing to be
+done at all, so you can return.
+
+This additional pseudo code would simply be:
+void mcount(void)
+{
+	/* save any bare state needed in order to do initial checking */
+
++	if (function_trace_stop)
++		return;
+
+	extern void (*ftrace_trace_function)(unsigned long, unsigned long);
+	if (ftrace_trace_function != ftrace_stub)
+...
+
+
+HAVE_FUNCTION_GRAPH_TRACER
+--------------------------
+
+Deep breath ... time to do some real work.  Here you will need to update the
+mcount function to check ftrace graph function pointers, as well as implement
+some functions to save (hijack) and restore the return address.
+
+The mcount function should check the function pointers ftrace_graph_return
+(compare to ftrace_stub) and ftrace_graph_entry (compare to
+ftrace_graph_entry_stub).  If either of those are not set to the relevant stub
+function, call the arch-specific function ftrace_graph_caller which in turn
+calls the arch-specific function prepare_ftrace_return.  Neither of these
+function names are strictly required, but you should use them anyways to stay
+consistent across the architecture ports -- easier to compare & contrast
+things.
+
+The arguments to prepare_ftrace_return are slightly different than what are
+passed to ftrace_trace_function.  The second argument "selfpc" is the same,
+but the first argument should be a pointer to the "frompc".  Typically this is
+located on the stack.  This allows the function to hijack the return address
+temporarily to have it point to the arch-specific function return_to_handler.
+That function will simply call the common ftrace_return_to_handler function and
+that will return the original return address with which, you can return to the
+original call site.
+
+Here is the updated mcount pseudo code:
+void mcount(void)
+{
+...
+	if (ftrace_trace_function != ftrace_stub)
+		goto do_trace;
+
++#ifdef CONFIG_FUNCTION_GRAPH_TRACER
++	extern void (*ftrace_graph_return)(...);
++	extern void (*ftrace_graph_entry)(...);
++	if (ftrace_graph_return != ftrace_stub ||
++	    ftrace_graph_entry != ftrace_graph_entry_stub)
++		ftrace_graph_caller();
++#endif
+
+	/* restore any bare state */
+...
+
+Here is the pseudo code for the new ftrace_graph_caller assembly function:
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+void ftrace_graph_caller(void)
+{
+	/* save all state needed by the ABI */
+
+	unsigned long *frompc = &...;
+	unsigned long selfpc = <return address> - MCOUNT_INSN_SIZE;
+	prepare_ftrace_return(frompc, selfpc);
+
+	/* restore all state needed by the ABI */
+}
+#endif
+
+For information on how to implement prepare_ftrace_return(), simply look at
+the x86 version.  The only architecture-specific piece in it is the setup of
+the fault recovery table (the asm(...) code).  The rest should be the same
+across architectures.
+
+Here is the pseudo code for the new return_to_handler assembly function.  Note
+that the ABI that applies here is different from what applies to the mcount
+code.  Since you are returning from a function (after the epilogue), you might
+be able to skimp on things saved/restored (usually just registers used to pass
+return values).
+
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+void return_to_handler(void)
+{
+	/* save all state needed by the ABI (see paragraph above) */
+
+	void (*original_return_point)(void) = ftrace_return_to_handler();
+
+	/* restore all state needed by the ABI */
+
+	/* this is usually either a return or a jump */
+	original_return_point();
+}
+#endif
+
+
+HAVE_FTRACE_NMI_ENTER
+---------------------
+
+If you can't trace NMI functions, then skip this option.
+
+<details to be filled>
+
+
+HAVE_FTRACE_SYSCALLS
+---------------------
+
+<details to be filled>
+
+
+HAVE_FTRACE_MCOUNT_RECORD
+-------------------------
+
+See scripts/recordmcount.pl for more info.
+
+<details to be filled>
+
+
+HAVE_DYNAMIC_FTRACE
+---------------------
+
+<details to be filled>
diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index 355d0f1..1b6292b 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -26,6 +26,12 @@ disabled, and more (ftrace allows for tracer plugins, which
 means that the list of tracers can always grow).
 
 
+Implementation Details
+----------------------
+
+See ftrace-design.txt for details for arch porters and such.
+
+
 The File System
 ---------------
 
diff --git a/MAINTAINERS b/MAINTAINERS
index 9117b65..9addc28 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2152,13 +2152,16 @@ F:	Documentation/filesystems/caching/
 F:	fs/fscache/
 F:	include/linux/fscache*.h
 
-FTRACE
+TRACING
 M:	Steven Rostedt <rostedt@goodmis.org>
+M:	Frederic Weisbecker <fweisbec@gmail.com>
+M:	Ingo Molnar <mingo@redhat.com>
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing/core
 S:	Maintained
 F:	Documentation/trace/ftrace.txt
 F:	arch/*/*/*/ftrace.h
 F:	arch/*/kernel/ftrace.c
-F:	include/*/ftrace.h
+F:	include/*/ftrace.h include/trace/ include/linux/trace*.h
 F:	kernel/trace/
 
 FUJITSU FR-V (FRV) PORT
diff --git a/arch/Kconfig b/arch/Kconfig
index beea3cc..7f418bb 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -9,6 +9,7 @@ config OPROFILE
 	depends on TRACING_SUPPORT
 	select TRACING
 	select RING_BUFFER
+	select RING_BUFFER_ALLOW_SWAP
 	help
 	  OProfile is a profiling system capable of profiling the
 	  whole system, include the kernel, kernel modules, libraries,
diff --git a/arch/x86/include/asm/nops.h b/arch/x86/include/asm/nops.h
index ad2668e..6d8723a 100644
--- a/arch/x86/include/asm/nops.h
+++ b/arch/x86/include/asm/nops.h
@@ -65,6 +65,8 @@
    6: osp nopl 0x00(%eax,%eax,1)
    7: nopl 0x00000000(%eax)
    8: nopl 0x00000000(%eax,%eax,1)
+   Note: All the above are assumed to be a single instruction.
+	There is kernel code that depends on this.
 */
 #define P6_NOP1	GENERIC_NOP1
 #define P6_NOP2	".byte 0x66,0x90\n"
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index c251be7..d59fe32 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -146,7 +146,7 @@ ENTRY(ftrace_graph_caller)
 END(ftrace_graph_caller)
 
 GLOBAL(return_to_handler)
-	subq  $80, %rsp
+	subq  $24, %rsp
 
 	/* Save the return values */
 	movq %rax, (%rsp)
@@ -155,10 +155,10 @@ GLOBAL(return_to_handler)
 
 	call ftrace_return_to_handler
 
-	movq %rax, 72(%rsp)
+	movq %rax, 16(%rsp)
 	movq 8(%rsp), %rdx
 	movq (%rsp), %rax
-	addq $72, %rsp
+	addq $16, %rsp
 	retq
 #endif
 
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index a43223a..29ca8f5 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -88,7 +88,8 @@
 #endif
 
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD
-#define MCOUNT_REC()	VMLINUX_SYMBOL(__start_mcount_loc) = .; \
+#define MCOUNT_REC()	. = ALIGN(8);				\
+			VMLINUX_SYMBOL(__start_mcount_loc) = .; \
 			*(__mcount_loc)				\
 			VMLINUX_SYMBOL(__stop_mcount_loc) = .;
 #else
@@ -328,7 +329,6 @@
 	/* __*init sections */						\
 	__init_rodata : AT(ADDR(__init_rodata) - LOAD_OFFSET) {		\
 		*(.ref.rodata)						\
-		MCOUNT_REC()						\
 		DEV_KEEP(init.rodata)					\
 		DEV_KEEP(exit.rodata)					\
 		CPU_KEEP(init.rodata)					\
@@ -452,6 +452,7 @@
 	MEM_DISCARD(init.data)						\
 	KERNEL_CTORS()							\
 	*(.init.rodata)							\
+	MCOUNT_REC()							\
 	DEV_DISCARD(init.rodata)					\
 	CPU_DISCARD(init.rodata)					\
 	MEM_DISCARD(init.rodata)
diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 23f7179..bd099ba 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -1,8 +1,8 @@
 #ifndef _LINUX_FTRACE_EVENT_H
 #define _LINUX_FTRACE_EVENT_H
 
-#include <linux/trace_seq.h>
 #include <linux/ring_buffer.h>
+#include <linux/trace_seq.h>
 #include <linux/percpu.h>
 
 struct trace_array;
@@ -34,7 +34,7 @@ struct trace_entry {
 	unsigned char		flags;
 	unsigned char		preempt_count;
 	int			pid;
-	int			tgid;
+	int			lock_depth;
 };
 
 #define FTRACE_MAX_EVENT						\
@@ -135,7 +135,7 @@ struct ftrace_event_call {
 };
 
 #define MAX_FILTER_PRED		32
-#define MAX_FILTER_STR_VAL	128
+#define MAX_FILTER_STR_VAL	256	/* Should handle KSYM_SYMBOL_LEN */
 
 extern void destroy_preds(struct ftrace_event_call *call);
 extern int filter_match_preds(struct ftrace_event_call *call, void *rec);
diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index bcd9c07..3a46b7b 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -48,13 +48,13 @@
 #define KPROBE_HIT_SSDONE	0x00000008
 
 /* Attach to insert probes on any functions which should be ignored*/
-#define __kprobes	__attribute__((__section__(".kprobes.text"))) notrace
+#define __kprobes	__attribute__((__section__(".kprobes.text")))
 #else /* CONFIG_KPROBES */
 typedef int kprobe_opcode_t;
 struct arch_specific_insn {
 	int dummy;
 };
-#define __kprobes	notrace
+#define __kprobes
 #endif /* CONFIG_KPROBES */
 
 struct kprobe;
diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index 9a74b46..d86af94 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -171,6 +171,7 @@ TRACE_EVENT(block_rq_complete,
 		  (unsigned long long)__entry->sector,
 		  __entry->nr_sector, __entry->errors)
 );
+
 TRACE_EVENT(block_bio_bounce,
 
 	TP_PROTO(struct request_queue *q, struct bio *bio),
@@ -186,7 +187,8 @@ TRACE_EVENT(block_bio_bounce,
 	),
 
 	TP_fast_assign(
-		__entry->dev		= bio->bi_bdev->bd_dev;
+		__entry->dev		= bio->bi_bdev ?
+					  bio->bi_bdev->bd_dev : 0;
 		__entry->sector		= bio->bi_sector;
 		__entry->nr_sector	= bio->bi_size >> 9;
 		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);
diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
index 1cb0c3a..b89f9db 100644
--- a/include/trace/events/irq.h
+++ b/include/trace/events/irq.h
@@ -8,16 +8,17 @@
 #include <linux/interrupt.h>
 
 #define softirq_name(sirq) { sirq##_SOFTIRQ, #sirq }
-#define show_softirq_name(val)			\
-	__print_symbolic(val,			\
-			 softirq_name(HI),	\
-			 softirq_name(TIMER),	\
-			 softirq_name(NET_TX),	\
-			 softirq_name(NET_RX),	\
-			 softirq_name(BLOCK),	\
-			 softirq_name(TASKLET),	\
-			 softirq_name(SCHED),	\
-			 softirq_name(HRTIMER),	\
+#define show_softirq_name(val)				\
+	__print_symbolic(val,				\
+			 softirq_name(HI),		\
+			 softirq_name(TIMER),		\
+			 softirq_name(NET_TX),		\
+			 softirq_name(NET_RX),		\
+			 softirq_name(BLOCK),		\
+			 softirq_name(BLOCK_IOPOLL),	\
+			 softirq_name(TASKLET),		\
+			 softirq_name(SCHED),		\
+			 softirq_name(HRTIMER),		\
 			 softirq_name(RCU))
 
 /**
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 308bafd..72a3b43 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -239,9 +239,9 @@ ftrace_format_##call(struct ftrace_event_call *unused,			\
 #undef __print_flags
 #define __print_flags(flag, delim, flag_array...)			\
 	({								\
-		static const struct trace_print_flags flags[] =		\
+		static const struct trace_print_flags __flags[] =	\
 			{ flag_array, { -1, NULL }};			\
-		ftrace_print_flags_seq(p, delim, flag, flags);		\
+		ftrace_print_flags_seq(p, delim, flag, __flags);	\
 	})
 
 #undef __print_symbolic
@@ -254,7 +254,7 @@ ftrace_format_##call(struct ftrace_event_call *unused,			\
 
 #undef TRACE_EVENT
 #define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
-enum print_line_t							\
+static enum print_line_t						\
 ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 {									\
 	struct trace_seq *s = &iter->seq;				\
@@ -317,7 +317,7 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 
 #undef TRACE_EVENT
 #define TRACE_EVENT(call, proto, args, tstruct, func, print)		\
-int									\
+static int								\
 ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
 {									\
 	struct ftrace_raw_##call field;					\
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 7db2506..f8749e5 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -57,7 +57,7 @@ static struct softirq_action softirq_vec[NR_SOFTIRQS] __cacheline_aligned_in_smp
 static DEFINE_PER_CPU(struct task_struct *, ksoftirqd);
 
 char *softirq_to_name[NR_SOFTIRQS] = {
-	"HI", "TIMER", "NET_TX", "NET_RX", "BLOCK",
+	"HI", "TIMER", "NET_TX", "NET_RX", "BLOCK", "BLOCK_IOPOLL",
 	"TASKLET", "SCHED", "HRTIMER",	"RCU"
 };
 
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 1ea0d12..e716346 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -11,12 +11,18 @@ config NOP_TRACER
 
 config HAVE_FTRACE_NMI_ENTER
 	bool
+	help
+	  See Documentation/trace/ftrace-implementation.txt
 
 config HAVE_FUNCTION_TRACER
 	bool
+	help
+	  See Documentation/trace/ftrace-implementation.txt
 
 config HAVE_FUNCTION_GRAPH_TRACER
 	bool
+	help
+	  See Documentation/trace/ftrace-implementation.txt
 
 config HAVE_FUNCTION_GRAPH_FP_TEST
 	bool
@@ -28,21 +34,25 @@ config HAVE_FUNCTION_GRAPH_FP_TEST
 config HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	bool
 	help
-	 This gets selected when the arch tests the function_trace_stop
-	 variable at the mcount call site. Otherwise, this variable
-	 is tested by the called function.
+	  See Documentation/trace/ftrace-implementation.txt
 
 config HAVE_DYNAMIC_FTRACE
 	bool
+	help
+	  See Documentation/trace/ftrace-implementation.txt
 
 config HAVE_FTRACE_MCOUNT_RECORD
 	bool
+	help
+	  See Documentation/trace/ftrace-implementation.txt
 
 config HAVE_HW_BRANCH_TRACER
 	bool
 
 config HAVE_SYSCALL_TRACEPOINTS
 	bool
+	help
+	  See Documentation/trace/ftrace-implementation.txt
 
 config TRACER_MAX_TRACE
 	bool
@@ -469,6 +479,18 @@ config FTRACE_STARTUP_TEST
 	  functioning properly. It will do tests on all the configured
 	  tracers of ftrace.
 
+config EVENT_TRACE_TEST_SYSCALLS
+	bool "Run selftest on syscall events"
+	depends on FTRACE_STARTUP_TEST
+	help
+	 This option will also enable testing every syscall event.
+	 It only enables the event and disables it and runs various loads
+	 with the event enabled. This adds a bit more time for kernel boot
+	 up since it runs this on every system call defined.
+
+	 TBD - enable a way to actually call the syscalls as we test their
+	       events
+
 config MMIOTRACE
 	bool "Memory mapped IO tracing"
 	depends on HAVE_MMIOTRACE_SUPPORT && PCI
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 8c804e2..cc615f8 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1323,11 +1323,10 @@ static int __init ftrace_dyn_table_alloc(unsigned long num_to_init)
 
 enum {
 	FTRACE_ITER_FILTER	= (1 << 0),
-	FTRACE_ITER_CONT	= (1 << 1),
-	FTRACE_ITER_NOTRACE	= (1 << 2),
-	FTRACE_ITER_FAILURES	= (1 << 3),
-	FTRACE_ITER_PRINTALL	= (1 << 4),
-	FTRACE_ITER_HASH	= (1 << 5),
+	FTRACE_ITER_NOTRACE	= (1 << 1),
+	FTRACE_ITER_FAILURES	= (1 << 2),
+	FTRACE_ITER_PRINTALL	= (1 << 3),
+	FTRACE_ITER_HASH	= (1 << 4),
 };
 
 #define FTRACE_BUFF_MAX (KSYM_SYMBOL_LEN+4) /* room for wildcards */
@@ -1337,8 +1336,7 @@ struct ftrace_iterator {
 	int			hidx;
 	int			idx;
 	unsigned		flags;
-	unsigned char		buffer[FTRACE_BUFF_MAX+1];
-	unsigned		buffer_idx;
+	struct trace_parser	parser;
 };
 
 static void *
@@ -1407,7 +1405,7 @@ static int t_hash_show(struct seq_file *m, void *v)
 	if (rec->ops->print)
 		return rec->ops->print(m, rec->ip, rec->ops, rec->data);
 
-	seq_printf(m, "%pf:%pf", (void *)rec->ip, (void *)rec->ops->func);
+	seq_printf(m, "%ps:%ps", (void *)rec->ip, (void *)rec->ops->func);
 
 	if (rec->data)
 		seq_printf(m, ":%p", rec->data);
@@ -1517,7 +1515,7 @@ static int t_show(struct seq_file *m, void *v)
 	if (!rec)
 		return 0;
 
-	seq_printf(m, "%pf\n", (void *)rec->ip);
+	seq_printf(m, "%ps\n", (void *)rec->ip);
 
 	return 0;
 }
@@ -1604,6 +1602,11 @@ ftrace_regex_open(struct inode *inode, struct file *file, int enable)
 	if (!iter)
 		return -ENOMEM;
 
+	if (trace_parser_get_init(&iter->parser, FTRACE_BUFF_MAX)) {
+		kfree(iter);
+		return -ENOMEM;
+	}
+
 	mutex_lock(&ftrace_regex_lock);
 	if ((file->f_mode & FMODE_WRITE) &&
 	    (file->f_flags & O_TRUNC))
@@ -2059,9 +2062,9 @@ __unregister_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
 	int i, len = 0;
 	char *search;
 
-	if (glob && (strcmp(glob, "*") || !strlen(glob)))
+	if (glob && (strcmp(glob, "*") == 0 || !strlen(glob)))
 		glob = NULL;
-	else {
+	else if (glob) {
 		int not;
 
 		type = ftrace_setup_glob(glob, strlen(glob), &search, &not);
@@ -2196,9 +2199,8 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
 		   size_t cnt, loff_t *ppos, int enable)
 {
 	struct ftrace_iterator *iter;
-	char ch;
-	size_t read = 0;
-	ssize_t ret;
+	struct trace_parser *parser;
+	ssize_t ret, read;
 
 	if (!cnt || cnt < 0)
 		return 0;
@@ -2211,72 +2213,23 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
 	} else
 		iter = file->private_data;
 
-	if (!*ppos) {
-		iter->flags &= ~FTRACE_ITER_CONT;
-		iter->buffer_idx = 0;
-	}
-
-	ret = get_user(ch, ubuf++);
-	if (ret)
-		goto out;
-	read++;
-	cnt--;
+	parser = &iter->parser;
+	read = trace_get_user(parser, ubuf, cnt, ppos);
 
-	/*
-	 * If the parser haven't finished with the last write,
-	 * continue reading the user input without skipping spaces.
-	 */
-	if (!(iter->flags & FTRACE_ITER_CONT)) {
-		/* skip white space */
-		while (cnt && isspace(ch)) {
-			ret = get_user(ch, ubuf++);
-			if (ret)
-				goto out;
-			read++;
-			cnt--;
-		}
-
-		/* only spaces were written */
-		if (isspace(ch)) {
-			*ppos += read;
-			ret = read;
-			goto out;
-		}
-
-		iter->buffer_idx = 0;
-	}
-
-	while (cnt && !isspace(ch)) {
-		if (iter->buffer_idx < FTRACE_BUFF_MAX)
-			iter->buffer[iter->buffer_idx++] = ch;
-		else {
-			ret = -EINVAL;
-			goto out;
-		}
-		ret = get_user(ch, ubuf++);
+	if (trace_parser_loaded(parser) &&
+	    !trace_parser_cont(parser)) {
+		ret = ftrace_process_regex(parser->buffer,
+					   parser->idx, enable);
 		if (ret)
 			goto out;
-		read++;
-		cnt--;
-	}
 
-	if (isspace(ch)) {
-		iter->buffer[iter->buffer_idx] = 0;
-		ret = ftrace_process_regex(iter->buffer,
-					   iter->buffer_idx, enable);
-		if (ret)
-			goto out;
-		iter->buffer_idx = 0;
-	} else {
-		iter->flags |= FTRACE_ITER_CONT;
-		iter->buffer[iter->buffer_idx++] = ch;
+		trace_parser_clear(parser);
 	}
 
-	*ppos += read;
 	ret = read;
- out:
-	mutex_unlock(&ftrace_regex_lock);
 
+	mutex_unlock(&ftrace_regex_lock);
+out:
 	return ret;
 }
 
@@ -2381,6 +2334,7 @@ ftrace_regex_release(struct inode *inode, struct file *file, int enable)
 {
 	struct seq_file *m = (struct seq_file *)file->private_data;
 	struct ftrace_iterator *iter;
+	struct trace_parser *parser;
 
 	mutex_lock(&ftrace_regex_lock);
 	if (file->f_mode & FMODE_READ) {
@@ -2390,9 +2344,10 @@ ftrace_regex_release(struct inode *inode, struct file *file, int enable)
 	} else
 		iter = file->private_data;
 
-	if (iter->buffer_idx) {
-		iter->buffer[iter->buffer_idx] = 0;
-		ftrace_match_records(iter->buffer, iter->buffer_idx, enable);
+	parser = &iter->parser;
+	if (trace_parser_loaded(parser)) {
+		parser->buffer[parser->idx] = 0;
+		ftrace_match_records(parser->buffer, parser->idx, enable);
 	}
 
 	mutex_lock(&ftrace_lock);
@@ -2400,7 +2355,9 @@ ftrace_regex_release(struct inode *inode, struct file *file, int enable)
 		ftrace_run_update_code(FTRACE_ENABLE_CALLS);
 	mutex_unlock(&ftrace_lock);
 
+	trace_parser_put(parser);
 	kfree(iter);
+
 	mutex_unlock(&ftrace_regex_lock);
 	return 0;
 }
@@ -2499,7 +2456,7 @@ static int g_show(struct seq_file *m, void *v)
 		return 0;
 	}
 
-	seq_printf(m, "%pf\n", v);
+	seq_printf(m, "%ps\n", (void *)*ptr);
 
 	return 0;
 }
@@ -2602,12 +2559,10 @@ static ssize_t
 ftrace_graph_write(struct file *file, const char __user *ubuf,
 		   size_t cnt, loff_t *ppos)
 {
-	unsigned char buffer[FTRACE_BUFF_MAX+1];
+	struct trace_parser parser;
 	unsigned long *array;
 	size_t read = 0;
 	ssize_t ret;
-	int index = 0;
-	char ch;
 
 	if (!cnt || cnt < 0)
 		return 0;
@@ -2625,51 +2580,26 @@ ftrace_graph_write(struct file *file, const char __user *ubuf,
 	} else
 		array = file->private_data;
 
-	ret = get_user(ch, ubuf++);
-	if (ret)
+	if (trace_parser_get_init(&parser, FTRACE_BUFF_MAX)) {
+		ret = -ENOMEM;
 		goto out;
-	read++;
-	cnt--;
-
-	/* skip white space */
-	while (cnt && isspace(ch)) {
-		ret = get_user(ch, ubuf++);
-		if (ret)
-			goto out;
-		read++;
-		cnt--;
 	}
 
-	if (isspace(ch)) {
-		*ppos += read;
-		ret = read;
-		goto out;
-	}
+	read = trace_get_user(&parser, ubuf, cnt, ppos);
 
-	while (cnt && !isspace(ch)) {
-		if (index < FTRACE_BUFF_MAX)
-			buffer[index++] = ch;
-		else {
-			ret = -EINVAL;
-			goto out;
-		}
-		ret = get_user(ch, ubuf++);
+	if (trace_parser_loaded((&parser))) {
+		parser.buffer[parser.idx] = 0;
+
+		/* we allow only one expression at a time */
+		ret = ftrace_set_func(array, &ftrace_graph_count,
+					parser.buffer);
 		if (ret)
 			goto out;
-		read++;
-		cnt--;
 	}
-	buffer[index] = 0;
-
-	/* we allow only one expression at a time */
-	ret = ftrace_set_func(array, &ftrace_graph_count, buffer);
-	if (ret)
-		goto out;
-
-	file->f_pos += read;
 
 	ret = read;
  out:
+	trace_parser_put(&parser);
 	mutex_unlock(&graph_lock);
 
 	return ret;
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 454e74e..6eef389 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -701,8 +701,8 @@ static int rb_head_page_set(struct ring_buffer_per_cpu *cpu_buffer,
 
 	val &= ~RB_FLAG_MASK;
 
-	ret = (unsigned long)cmpxchg(&list->next,
-				     val | old_flag, val | new_flag);
+	ret = cmpxchg((unsigned long *)&list->next,
+		      val | old_flag, val | new_flag);
 
 	/* check if the reader took the page */
 	if ((ret & ~RB_FLAG_MASK) != val)
@@ -794,7 +794,7 @@ static int rb_head_page_replace(struct buffer_page *old,
 	val = *ptr & ~RB_FLAG_MASK;
 	val |= RB_PAGE_HEAD;
 
-	ret = cmpxchg(ptr, val, &new->list);
+	ret = cmpxchg(ptr, val, (unsigned long)&new->list);
 
 	return ret == val;
 }
@@ -2997,15 +2997,12 @@ static void rb_advance_iter(struct ring_buffer_iter *iter)
 }
 
 static struct ring_buffer_event *
-rb_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
+rb_buffer_peek(struct ring_buffer_per_cpu *cpu_buffer, u64 *ts)
 {
-	struct ring_buffer_per_cpu *cpu_buffer;
 	struct ring_buffer_event *event;
 	struct buffer_page *reader;
 	int nr_loops = 0;
 
-	cpu_buffer = buffer->buffers[cpu];
-
  again:
 	/*
 	 * We repeat when a timestamp is encountered. It is possible
@@ -3049,7 +3046,7 @@ rb_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
 	case RINGBUF_TYPE_DATA:
 		if (ts) {
 			*ts = cpu_buffer->read_stamp + event->time_delta;
-			ring_buffer_normalize_time_stamp(buffer,
+			ring_buffer_normalize_time_stamp(cpu_buffer->buffer,
 							 cpu_buffer->cpu, ts);
 		}
 		return event;
@@ -3168,7 +3165,7 @@ ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
 	local_irq_save(flags);
 	if (dolock)
 		spin_lock(&cpu_buffer->reader_lock);
-	event = rb_buffer_peek(buffer, cpu, ts);
+	event = rb_buffer_peek(cpu_buffer, ts);
 	if (event && event->type_len == RINGBUF_TYPE_PADDING)
 		rb_advance_reader(cpu_buffer);
 	if (dolock)
@@ -3237,7 +3234,7 @@ ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts)
 	if (dolock)
 		spin_lock(&cpu_buffer->reader_lock);
 
-	event = rb_buffer_peek(buffer, cpu, ts);
+	event = rb_buffer_peek(cpu_buffer, ts);
 	if (event)
 		rb_advance_reader(cpu_buffer);
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 5c75dee..fd52a19 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -339,6 +339,112 @@ static struct {
 
 int trace_clock_id;
 
+/*
+ * trace_parser_get_init - gets the buffer for trace parser
+ */
+int trace_parser_get_init(struct trace_parser *parser, int size)
+{
+	memset(parser, 0, sizeof(*parser));
+
+	parser->buffer = kmalloc(size, GFP_KERNEL);
+	if (!parser->buffer)
+		return 1;
+
+	parser->size = size;
+	return 0;
+}
+
+/*
+ * trace_parser_put - frees the buffer for trace parser
+ */
+void trace_parser_put(struct trace_parser *parser)
+{
+	kfree(parser->buffer);
+}
+
+/*
+ * trace_get_user - reads the user input string separated by  space
+ * (matched by isspace(ch))
+ *
+ * For each string found the 'struct trace_parser' is updated,
+ * and the function returns.
+ *
+ * Returns number of bytes read.
+ *
+ * See kernel/trace/trace.h for 'struct trace_parser' details.
+ */
+int trace_get_user(struct trace_parser *parser, const char __user *ubuf,
+	size_t cnt, loff_t *ppos)
+{
+	char ch;
+	size_t read = 0;
+	ssize_t ret;
+
+	if (!*ppos)
+		trace_parser_clear(parser);
+
+	ret = get_user(ch, ubuf++);
+	if (ret)
+		goto out;
+
+	read++;
+	cnt--;
+
+	/*
+	 * The parser is not finished with the last write,
+	 * continue reading the user input without skipping spaces.
+	 */
+	if (!parser->cont) {
+		/* skip white space */
+		while (cnt && isspace(ch)) {
+			ret = get_user(ch, ubuf++);
+			if (ret)
+				goto out;
+			read++;
+			cnt--;
+		}
+
+		/* only spaces were written */
+		if (isspace(ch)) {
+			*ppos += read;
+			ret = read;
+			goto out;
+		}
+
+		parser->idx = 0;
+	}
+
+	/* read the non-space input */
+	while (cnt && !isspace(ch)) {
+		if (parser->idx < parser->size)
+			parser->buffer[parser->idx++] = ch;
+		else {
+			ret = -EINVAL;
+			goto out;
+		}
+		ret = get_user(ch, ubuf++);
+		if (ret)
+			goto out;
+		read++;
+		cnt--;
+	}
+
+	/* We either got finished input or we have to wait for another call. */
+	if (isspace(ch)) {
+		parser->buffer[parser->idx] = 0;
+		parser->cont = false;
+	} else {
+		parser->cont = true;
+		parser->buffer[parser->idx++] = ch;
+	}
+
+	*ppos += read;
+	ret = read;
+
+out:
+	return ret;
+}
+
 ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf, size_t cnt)
 {
 	int len;
@@ -719,6 +825,11 @@ static void trace_init_cmdlines(void)
 	cmdline_idx = 0;
 }
 
+int is_tracing_stopped(void)
+{
+	return trace_stop_count;
+}
+
 /**
  * ftrace_off_permanent - disable all ftrace code permanently
  *
@@ -886,7 +997,7 @@ tracing_generic_entry_update(struct trace_entry *entry, unsigned long flags,
 
 	entry->preempt_count		= pc & 0xff;
 	entry->pid			= (tsk) ? tsk->pid : 0;
-	entry->tgid			= (tsk) ? tsk->tgid : 0;
+	entry->lock_depth		= (tsk) ? tsk->lock_depth : 0;
 	entry->flags =
 #ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
 		(irqs_disabled_flags(flags) ? TRACE_FLAG_IRQS_OFF : 0) |
@@ -1068,6 +1179,7 @@ ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags, int pc)
 		return;
 	entry	= ring_buffer_event_data(event);
 
+	entry->tgid		= current->tgid;
 	memset(&entry->caller, 0, sizeof(entry->caller));
 
 	trace.nr_entries	= 0;
@@ -1094,6 +1206,7 @@ ftrace_trace_special(void *__tr,
 		     unsigned long arg1, unsigned long arg2, unsigned long arg3,
 		     int pc)
 {
+	struct ftrace_event_call *call = &event_special;
 	struct ring_buffer_event *event;
 	struct trace_array *tr = __tr;
 	struct ring_buffer *buffer = tr->buffer;
@@ -1107,7 +1220,9 @@ ftrace_trace_special(void *__tr,
 	entry->arg1			= arg1;
 	entry->arg2			= arg2;
 	entry->arg3			= arg3;
-	trace_buffer_unlock_commit(buffer, event, 0, pc);
+
+	if (!filter_check_discard(call, entry, buffer, event))
+		trace_buffer_unlock_commit(buffer, event, 0, pc);
 }
 
 void
@@ -1530,10 +1645,10 @@ static void print_lat_help_header(struct seq_file *m)
 	seq_puts(m, "#                | / _----=> need-resched    \n");
 	seq_puts(m, "#                || / _---=> hardirq/softirq \n");
 	seq_puts(m, "#                ||| / _--=> preempt-depth   \n");
-	seq_puts(m, "#                |||| /                      \n");
-	seq_puts(m, "#                |||||     delay             \n");
-	seq_puts(m, "#  cmd     pid   ||||| time  |   caller      \n");
-	seq_puts(m, "#     \\   /      |||||   \\   |   /           \n");
+	seq_puts(m, "#                |||| /_--=> lock-depth       \n");
+	seq_puts(m, "#                |||||/     delay             \n");
+	seq_puts(m, "#  cmd     pid   |||||| time  |   caller      \n");
+	seq_puts(m, "#     \\   /      ||||||   \\   |   /           \n");
 }
 
 static void print_func_help_header(struct seq_file *m)
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index fa1dccb..86bcff9 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -7,6 +7,7 @@
 #include <linux/clocksource.h>
 #include <linux/ring_buffer.h>
 #include <linux/mmiotrace.h>
+#include <linux/tracepoint.h>
 #include <linux/ftrace.h>
 #include <trace/boot.h>
 #include <linux/kmemtrace.h>
@@ -42,157 +43,54 @@ enum trace_type {
 	__TRACE_LAST_TYPE,
 };
 
-/*
- * Function trace entry - function address and parent function addres:
- */
-struct ftrace_entry {
-	struct trace_entry	ent;
-	unsigned long		ip;
-	unsigned long		parent_ip;
-};
-
-/* Function call entry */
-struct ftrace_graph_ent_entry {
-	struct trace_entry		ent;
-	struct ftrace_graph_ent		graph_ent;
+enum kmemtrace_type_id {
+	KMEMTRACE_TYPE_KMALLOC = 0,	/* kmalloc() or kfree(). */
+	KMEMTRACE_TYPE_CACHE,		/* kmem_cache_*(). */
+	KMEMTRACE_TYPE_PAGES,		/* __get_free_pages() and friends. */
 };
 
-/* Function return entry */
-struct ftrace_graph_ret_entry {
-	struct trace_entry		ent;
-	struct ftrace_graph_ret		ret;
-};
 extern struct tracer boot_tracer;
 
-/*
- * Context switch trace entry - which task (and prio) we switched from/to:
- */
-struct ctx_switch_entry {
-	struct trace_entry	ent;
-	unsigned int		prev_pid;
-	unsigned char		prev_prio;
-	unsigned char		prev_state;
-	unsigned int		next_pid;
-	unsigned char		next_prio;
-	unsigned char		next_state;
-	unsigned int		next_cpu;
-};
-
-/*
- * Special (free-form) trace entry:
- */
-struct special_entry {
-	struct trace_entry	ent;
-	unsigned long		arg1;
-	unsigned long		arg2;
-	unsigned long		arg3;
-};
-
-/*
- * Stack-trace entry:
- */
-
-#define FTRACE_STACK_ENTRIES	8
-
-struct stack_entry {
-	struct trace_entry	ent;
-	unsigned long		caller[FTRACE_STACK_ENTRIES];
-};
-
-struct userstack_entry {
-	struct trace_entry	ent;
-	unsigned long		caller[FTRACE_STACK_ENTRIES];
-};
-
-/*
- * trace_printk entry:
- */
-struct bprint_entry {
-	struct trace_entry	ent;
-	unsigned long		ip;
-	const char		*fmt;
-	u32			buf[];
-};
+#undef __field
+#define __field(type, item)		type	item;
 
-struct print_entry {
-	struct trace_entry	ent;
-	unsigned long		ip;
-	char			buf[];
-};
+#undef __field_struct
+#define __field_struct(type, item)	__field(type, item)
 
-#define TRACE_OLD_SIZE		88
+#undef __field_desc
+#define __field_desc(type, container, item)
 
-struct trace_field_cont {
-	unsigned char		type;
-	/* Temporary till we get rid of this completely */
-	char			buf[TRACE_OLD_SIZE - 1];
-};
+#undef __array
+#define __array(type, item, size)	type	item[size];
 
-struct trace_mmiotrace_rw {
-	struct trace_entry	ent;
-	struct mmiotrace_rw	rw;
-};
+#undef __array_desc
+#define __array_desc(type, container, item, size)
 
-struct trace_mmiotrace_map {
-	struct trace_entry	ent;
-	struct mmiotrace_map	map;
-};
+#undef __dynamic_array
+#define __dynamic_array(type, item)	type	item[];
 
-struct trace_boot_call {
-	struct trace_entry	ent;
-	struct boot_trace_call boot_call;
-};
+#undef F_STRUCT
+#define F_STRUCT(args...)		args
 
-struct trace_boot_ret {
-	struct trace_entry	ent;
-	struct boot_trace_ret boot_ret;
-};
-
-#define TRACE_FUNC_SIZE 30
-#define TRACE_FILE_SIZE 20
-struct trace_branch {
-	struct trace_entry	ent;
-	unsigned	        line;
-	char			func[TRACE_FUNC_SIZE+1];
-	char			file[TRACE_FILE_SIZE+1];
-	char			correct;
-};
-
-struct hw_branch_entry {
-	struct trace_entry	ent;
-	u64			from;
-	u64			to;
-};
-
-struct trace_power {
-	struct trace_entry	ent;
-	struct power_trace	state_data;
-};
+#undef FTRACE_ENTRY
+#define FTRACE_ENTRY(name, struct_name, id, tstruct, print)	\
+	struct struct_name {					\
+		struct trace_entry	ent;			\
+		tstruct						\
+	}
 
-enum kmemtrace_type_id {
-	KMEMTRACE_TYPE_KMALLOC = 0,	/* kmalloc() or kfree(). */
-	KMEMTRACE_TYPE_CACHE,		/* kmem_cache_*(). */
-	KMEMTRACE_TYPE_PAGES,		/* __get_free_pages() and friends. */
-};
+#undef TP_ARGS
+#define TP_ARGS(args...)	args
 
-struct kmemtrace_alloc_entry {
-	struct trace_entry	ent;
-	enum kmemtrace_type_id type_id;
-	unsigned long call_site;
-	const void *ptr;
-	size_t bytes_req;
-	size_t bytes_alloc;
-	gfp_t gfp_flags;
-	int node;
-};
+#undef FTRACE_ENTRY_DUP
+#define FTRACE_ENTRY_DUP(name, name_struct, id, tstruct, printk)
 
-struct kmemtrace_free_entry {
-	struct trace_entry	ent;
-	enum kmemtrace_type_id type_id;
-	unsigned long call_site;
-	const void *ptr;
-};
+#include "trace_entries.h"
 
+/*
+ * syscalls are special, and need special handling, this is why
+ * they are not included in trace_entries.h
+ */
 struct syscall_trace_enter {
 	struct trace_entry	ent;
 	int			nr;
@@ -205,13 +103,12 @@ struct syscall_trace_exit {
 	unsigned long		ret;
 };
 
-
 /*
  * trace_flag_type is an enumeration that holds different
  * states when a trace occurs. These are:
  *  IRQS_OFF		- interrupts were disabled
  *  IRQS_NOSUPPORT	- arch does not support irqs_disabled_flags
- *  NEED_RESCED		- reschedule is requested
+ *  NEED_RESCHED	- reschedule is requested
  *  HARDIRQ		- inside an interrupt handler
  *  SOFTIRQ		- inside a softirq handler
  */
@@ -390,7 +287,6 @@ struct tracer {
 	struct tracer		*next;
 	int			print_max;
 	struct tracer_flags	*flags;
-	struct tracer_stat	*stats;
 };
 
 
@@ -469,6 +365,7 @@ void tracing_stop_sched_switch_record(void);
 void tracing_start_sched_switch_record(void);
 int register_tracer(struct tracer *type);
 void unregister_tracer(struct tracer *type);
+int is_tracing_stopped(void);
 
 extern unsigned long nsecs_to_usecs(unsigned long nsecs);
 
@@ -509,20 +406,6 @@ static inline void __trace_stack(struct trace_array *tr, unsigned long flags,
 
 extern cycle_t ftrace_now(int cpu);
 
-#ifdef CONFIG_CONTEXT_SWITCH_TRACER
-typedef void
-(*tracer_switch_func_t)(void *private,
-			void *__rq,
-			struct task_struct *prev,
-			struct task_struct *next);
-
-struct tracer_switch_ops {
-	tracer_switch_func_t		func;
-	void				*private;
-	struct tracer_switch_ops	*next;
-};
-#endif /* CONFIG_CONTEXT_SWITCH_TRACER */
-
 extern void trace_find_cmdline(int pid, char comm[]);
 
 #ifdef CONFIG_DYNAMIC_FTRACE
@@ -638,6 +521,41 @@ static inline int ftrace_trace_task(struct task_struct *task)
 #endif
 
 /*
+ * struct trace_parser - servers for reading the user input separated by spaces
+ * @cont: set if the input is not complete - no final space char was found
+ * @buffer: holds the parsed user input
+ * @idx: user input lenght
+ * @size: buffer size
+ */
+struct trace_parser {
+	bool		cont;
+	char		*buffer;
+	unsigned	idx;
+	unsigned	size;
+};
+
+static inline bool trace_parser_loaded(struct trace_parser *parser)
+{
+	return (parser->idx != 0);
+}
+
+static inline bool trace_parser_cont(struct trace_parser *parser)
+{
+	return parser->cont;
+}
+
+static inline void trace_parser_clear(struct trace_parser *parser)
+{
+	parser->cont = false;
+	parser->idx = 0;
+}
+
+extern int trace_parser_get_init(struct trace_parser *parser, int size);
+extern void trace_parser_put(struct trace_parser *parser);
+extern int trace_get_user(struct trace_parser *parser, const char __user *ubuf,
+	size_t cnt, loff_t *ppos);
+
+/*
  * trace_iterator_flags is an enumeration that defines bit
  * positions into trace_flags that controls the output.
  *
@@ -823,58 +741,18 @@ filter_check_discard(struct ftrace_event_call *call, void *rec,
 	return 0;
 }
 
-#define DEFINE_COMPARISON_PRED(type)					\
-static int filter_pred_##type(struct filter_pred *pred, void *event,	\
-			      int val1, int val2)			\
-{									\
-	type *addr = (type *)(event + pred->offset);			\
-	type val = (type)pred->val;					\
-	int match = 0;							\
-									\
-	switch (pred->op) {						\
-	case OP_LT:							\
-		match = (*addr < val);					\
-		break;							\
-	case OP_LE:							\
-		match = (*addr <= val);					\
-		break;							\
-	case OP_GT:							\
-		match = (*addr > val);					\
-		break;							\
-	case OP_GE:							\
-		match = (*addr >= val);					\
-		break;							\
-	default:							\
-		break;							\
-	}								\
-									\
-	return match;							\
-}
-
-#define DEFINE_EQUALITY_PRED(size)					\
-static int filter_pred_##size(struct filter_pred *pred, void *event,	\
-			      int val1, int val2)			\
-{									\
-	u##size *addr = (u##size *)(event + pred->offset);		\
-	u##size val = (u##size)pred->val;				\
-	int match;							\
-									\
-	match = (val == *addr) ^ pred->not;				\
-									\
-	return match;							\
-}
-
 extern struct mutex event_mutex;
 extern struct list_head ftrace_events;
 
 extern const char *__start___trace_bprintk_fmt[];
 extern const char *__stop___trace_bprintk_fmt[];
 
-#undef TRACE_EVENT_FORMAT
-#define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
+#undef FTRACE_ENTRY
+#define FTRACE_ENTRY(call, struct_name, id, tstruct, print)		\
 	extern struct ftrace_event_call event_##call;
-#undef TRACE_EVENT_FORMAT_NOFILTER
-#define TRACE_EVENT_FORMAT_NOFILTER(call, proto, args, fmt, tstruct, tpfmt)
-#include "trace_event_types.h"
+#undef FTRACE_ENTRY_DUP
+#define FTRACE_ENTRY_DUP(call, struct_name, id, tstruct, print)		\
+	FTRACE_ENTRY(call, struct_name, id, PARAMS(tstruct), PARAMS(print))
+#include "trace_entries.h"
 
 #endif /* _LINUX_KERNEL_TRACE_H */
diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
index 19bfc75..c21d5f3 100644
--- a/kernel/trace/trace_boot.c
+++ b/kernel/trace/trace_boot.c
@@ -129,6 +129,7 @@ struct tracer boot_tracer __read_mostly =
 
 void trace_boot_call(struct boot_trace_call *bt, initcall_t fn)
 {
+	struct ftrace_event_call *call = &event_boot_call;
 	struct ring_buffer_event *event;
 	struct ring_buffer *buffer;
 	struct trace_boot_call *entry;
@@ -150,13 +151,15 @@ void trace_boot_call(struct boot_trace_call *bt, initcall_t fn)
 		goto out;
 	entry	= ring_buffer_event_data(event);
 	entry->boot_call = *bt;
-	trace_buffer_unlock_commit(buffer, event, 0, 0);
+	if (!filter_check_discard(call, entry, buffer, event))
+		trace_buffer_unlock_commit(buffer, event, 0, 0);
  out:
 	preempt_enable();
 }
 
 void trace_boot_ret(struct boot_trace_ret *bt, initcall_t fn)
 {
+	struct ftrace_event_call *call = &event_boot_ret;
 	struct ring_buffer_event *event;
 	struct ring_buffer *buffer;
 	struct trace_boot_ret *entry;
@@ -175,7 +178,8 @@ void trace_boot_ret(struct boot_trace_ret *bt, initcall_t fn)
 		goto out;
 	entry	= ring_buffer_event_data(event);
 	entry->boot_ret = *bt;
-	trace_buffer_unlock_commit(buffer, event, 0, 0);
+	if (!filter_check_discard(call, entry, buffer, event))
+		trace_buffer_unlock_commit(buffer, event, 0, 0);
  out:
 	preempt_enable();
 }
diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
index b588fd8..20c5f92 100644
--- a/kernel/trace/trace_clock.c
+++ b/kernel/trace/trace_clock.c
@@ -66,10 +66,14 @@ u64 notrace trace_clock(void)
  * Used by plugins that need globally coherent timestamps.
  */
 
-static u64 prev_trace_clock_time;
-
-static raw_spinlock_t trace_clock_lock ____cacheline_aligned_in_smp =
-	(raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
+/* keep prev_time and lock in the same cacheline. */
+static struct {
+	u64 prev_time;
+	raw_spinlock_t lock;
+} trace_clock_struct ____cacheline_aligned_in_smp =
+	{
+		.lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED,
+	};
 
 u64 notrace trace_clock_global(void)
 {
@@ -88,19 +92,19 @@ u64 notrace trace_clock_global(void)
 	if (unlikely(in_nmi()))
 		goto out;
 
-	__raw_spin_lock(&trace_clock_lock);
+	__raw_spin_lock(&trace_clock_struct.lock);
 
 	/*
 	 * TODO: if this happens often then maybe we should reset
-	 * my_scd->clock to prev_trace_clock_time+1, to make sure
+	 * my_scd->clock to prev_time+1, to make sure
 	 * we start ticking with the local clock from now on?
 	 */
-	if ((s64)(now - prev_trace_clock_time) < 0)
-		now = prev_trace_clock_time + 1;
+	if ((s64)(now - trace_clock_struct.prev_time) < 0)
+		now = trace_clock_struct.prev_time + 1;
 
-	prev_trace_clock_time = now;
+	trace_clock_struct.prev_time = now;
 
-	__raw_spin_unlock(&trace_clock_lock);
+	__raw_spin_unlock(&trace_clock_struct.lock);
 
  out:
 	raw_local_irq_restore(flags);
diff --git a/kernel/trace/trace_entries.h b/kernel/trace/trace_entries.h
new file mode 100644
index 0000000..a431748
--- /dev/null
+++ b/kernel/trace/trace_entries.h
@@ -0,0 +1,383 @@
+/*
+ * This file defines the trace event structures that go into the ring
+ * buffer directly. They are created via macros so that changes for them
+ * appear in the format file. Using macros will automate this process.
+ *
+ * The macro used to create a ftrace data structure is:
+ *
+ * FTRACE_ENTRY( name, struct_name, id, structure, print )
+ *
+ * @name: the name used the event name, as well as the name of
+ *   the directory that holds the format file.
+ *
+ * @struct_name: the name of the structure that is created.
+ *
+ * @id: The event identifier that is used to detect what event
+ *    this is from the ring buffer.
+ *
+ * @structure: the structure layout
+ *
+ *  - __field(	type,	item	)
+ *	  This is equivalent to declaring
+ *		type	item;
+ *	  in the structure.
+ *  - __array(	type,	item,	size	)
+ *	  This is equivalent to declaring
+ *		type	item[size];
+ *	  in the structure.
+ *
+ *   * for structures within structures, the format of the internal
+ *	structure is layed out. This allows the internal structure
+ *	to be deciphered for the format file. Although these macros
+ *	may become out of sync with the internal structure, they
+ *	will create a compile error if it happens. Since the
+ *	internel structures are just tracing helpers, this is not
+ *	an issue.
+ *
+ *	When an internal structure is used, it should use:
+ *
+ *	__field_struct(	type,	item	)
+ *
+ *	instead of __field. This will prevent it from being shown in
+ *	the output file. The fields in the structure should use.
+ *
+ *	__field_desc(	type,	container,	item		)
+ *	__array_desc(	type,	container,	item,	len	)
+ *
+ *	type, item and len are the same as __field and __array, but
+ *	container is added. This is the name of the item in
+ *	__field_struct that this is describing.
+ *
+ *
+ * @print: the print format shown to users in the format file.
+ */
+
+/*
+ * Function trace entry - function address and parent function addres:
+ */
+FTRACE_ENTRY(function, ftrace_entry,
+
+	TRACE_FN,
+
+	F_STRUCT(
+		__field(	unsigned long,	ip		)
+		__field(	unsigned long,	parent_ip	)
+	),
+
+	F_printk(" %lx <-- %lx", __entry->ip, __entry->parent_ip)
+);
+
+/* Function call entry */
+FTRACE_ENTRY(funcgraph_entry, ftrace_graph_ent_entry,
+
+	TRACE_GRAPH_ENT,
+
+	F_STRUCT(
+		__field_struct(	struct ftrace_graph_ent,	graph_ent	)
+		__field_desc(	unsigned long,	graph_ent,	func		)
+		__field_desc(	int,		graph_ent,	depth		)
+	),
+
+	F_printk("--> %lx (%d)", __entry->func, __entry->depth)
+);
+
+/* Function return entry */
+FTRACE_ENTRY(funcgraph_exit, ftrace_graph_ret_entry,
+
+	TRACE_GRAPH_RET,
+
+	F_STRUCT(
+		__field_struct(	struct ftrace_graph_ret,	ret	)
+		__field_desc(	unsigned long,	ret,		func	)
+		__field_desc(	unsigned long long, ret,	calltime)
+		__field_desc(	unsigned long long, ret,	rettime	)
+		__field_desc(	unsigned long,	ret,		overrun	)
+		__field_desc(	int,		ret,		depth	)
+	),
+
+	F_printk("<-- %lx (%d) (start: %llx  end: %llx) over: %d",
+		 __entry->func, __entry->depth,
+		 __entry->calltime, __entry->rettime,
+		 __entry->depth)
+);
+
+/*
+ * Context switch trace entry - which task (and prio) we switched from/to:
+ *
+ * This is used for both wakeup and context switches. We only want
+ * to create one structure, but we need two outputs for it.
+ */
+#define FTRACE_CTX_FIELDS					\
+	__field(	unsigned int,	prev_pid	)	\
+	__field(	unsigned char,	prev_prio	)	\
+	__field(	unsigned char,	prev_state	)	\
+	__field(	unsigned int,	next_pid	)	\
+	__field(	unsigned char,	next_prio	)	\
+	__field(	unsigned char,	next_state	)	\
+	__field(	unsigned int,	next_cpu	)
+
+FTRACE_ENTRY(context_switch, ctx_switch_entry,
+
+	TRACE_CTX,
+
+	F_STRUCT(
+		FTRACE_CTX_FIELDS
+	),
+
+	F_printk("%u:%u:%u  ==> %u:%u:%u [%03u]",
+		 __entry->prev_pid, __entry->prev_prio, __entry->prev_state,
+		 __entry->next_pid, __entry->next_prio, __entry->next_state,
+		 __entry->next_cpu
+		)
+);
+
+/*
+ * FTRACE_ENTRY_DUP only creates the format file, it will not
+ *  create another structure.
+ */
+FTRACE_ENTRY_DUP(wakeup, ctx_switch_entry,
+
+	TRACE_WAKE,
+
+	F_STRUCT(
+		FTRACE_CTX_FIELDS
+	),
+
+	F_printk("%u:%u:%u  ==+ %u:%u:%u [%03u]",
+		 __entry->prev_pid, __entry->prev_prio, __entry->prev_state,
+		 __entry->next_pid, __entry->next_prio, __entry->next_state,
+		 __entry->next_cpu
+		)
+);
+
+/*
+ * Special (free-form) trace entry:
+ */
+FTRACE_ENTRY(special, special_entry,
+
+	TRACE_SPECIAL,
+
+	F_STRUCT(
+		__field(	unsigned long,	arg1	)
+		__field(	unsigned long,	arg2	)
+		__field(	unsigned long,	arg3	)
+	),
+
+	F_printk("(%08lx) (%08lx) (%08lx)",
+		 __entry->arg1, __entry->arg2, __entry->arg3)
+);
+
+/*
+ * Stack-trace entry:
+ */
+
+#define FTRACE_STACK_ENTRIES	8
+
+FTRACE_ENTRY(kernel_stack, stack_entry,
+
+	TRACE_STACK,
+
+	F_STRUCT(
+		__array(	unsigned long,	caller, FTRACE_STACK_ENTRIES	)
+	),
+
+	F_printk("\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n"
+		 "\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n",
+		 __entry->caller[0], __entry->caller[1], __entry->caller[2],
+		 __entry->caller[3], __entry->caller[4], __entry->caller[5],
+		 __entry->caller[6], __entry->caller[7])
+);
+
+FTRACE_ENTRY(user_stack, userstack_entry,
+
+	TRACE_USER_STACK,
+
+	F_STRUCT(
+		__field(	unsigned int,	tgid	)
+		__array(	unsigned long,	caller, FTRACE_STACK_ENTRIES	)
+	),
+
+	F_printk("\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n"
+		 "\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n",
+		 __entry->caller[0], __entry->caller[1], __entry->caller[2],
+		 __entry->caller[3], __entry->caller[4], __entry->caller[5],
+		 __entry->caller[6], __entry->caller[7])
+);
+
+/*
+ * trace_printk entry:
+ */
+FTRACE_ENTRY(bprint, bprint_entry,
+
+	TRACE_BPRINT,
+
+	F_STRUCT(
+		__field(	unsigned long,	ip	)
+		__field(	const char *,	fmt	)
+		__dynamic_array(	u32,	buf	)
+	),
+
+	F_printk("%08lx fmt:%p",
+		 __entry->ip, __entry->fmt)
+);
+
+FTRACE_ENTRY(print, print_entry,
+
+	TRACE_PRINT,
+
+	F_STRUCT(
+		__field(	unsigned long,	ip	)
+		__dynamic_array(	char,	buf	)
+	),
+
+	F_printk("%08lx %s",
+		 __entry->ip, __entry->buf)
+);
+
+FTRACE_ENTRY(mmiotrace_rw, trace_mmiotrace_rw,
+
+	TRACE_MMIO_RW,
+
+	F_STRUCT(
+		__field_struct(	struct mmiotrace_rw,	rw	)
+		__field_desc(	resource_size_t, rw,	phys	)
+		__field_desc(	unsigned long,	rw,	value	)
+		__field_desc(	unsigned long,	rw,	pc	)
+		__field_desc(	int, 		rw,	map_id	)
+		__field_desc(	unsigned char,	rw,	opcode	)
+		__field_desc(	unsigned char,	rw,	width	)
+	),
+
+	F_printk("%lx %lx %lx %d %x %x",
+		 (unsigned long)__entry->phys, __entry->value, __entry->pc,
+		 __entry->map_id, __entry->opcode, __entry->width)
+);
+
+FTRACE_ENTRY(mmiotrace_map, trace_mmiotrace_map,
+
+	TRACE_MMIO_MAP,
+
+	F_STRUCT(
+		__field_struct(	struct mmiotrace_map,	map	)
+		__field_desc(	resource_size_t, map,	phys	)
+		__field_desc(	unsigned long,	map,	virt	)
+		__field_desc(	unsigned long,	map,	len	)
+		__field_desc(	int, 		map,	map_id	)
+		__field_desc(	unsigned char,	map,	opcode	)
+	),
+
+	F_printk("%lx %lx %lx %d %x",
+		 (unsigned long)__entry->phys, __entry->virt, __entry->len,
+		 __entry->map_id, __entry->opcode)
+);
+
+FTRACE_ENTRY(boot_call, trace_boot_call,
+
+	TRACE_BOOT_CALL,
+
+	F_STRUCT(
+		__field_struct(	struct boot_trace_call,	boot_call	)
+		__field_desc(	pid_t,	boot_call,	caller		)
+		__array_desc(	char,	boot_call,	func,	KSYM_SYMBOL_LEN)
+	),
+
+	F_printk("%d  %s", __entry->caller, __entry->func)
+);
+
+FTRACE_ENTRY(boot_ret, trace_boot_ret,
+
+	TRACE_BOOT_RET,
+
+	F_STRUCT(
+		__field_struct(	struct boot_trace_ret,	boot_ret	)
+		__array_desc(	char,	boot_ret,	func,	KSYM_SYMBOL_LEN)
+		__field_desc(	int,	boot_ret,	result		)
+		__field_desc(	unsigned long, boot_ret, duration	)
+	),
+
+	F_printk("%s %d %lx",
+		 __entry->func, __entry->result, __entry->duration)
+);
+
+#define TRACE_FUNC_SIZE 30
+#define TRACE_FILE_SIZE 20
+
+FTRACE_ENTRY(branch, trace_branch,
+
+	TRACE_BRANCH,
+
+	F_STRUCT(
+		__field(	unsigned int,	line				)
+		__array(	char,		func,	TRACE_FUNC_SIZE+1	)
+		__array(	char,		file,	TRACE_FILE_SIZE+1	)
+		__field(	char,		correct				)
+	),
+
+	F_printk("%u:%s:%s (%u)",
+		 __entry->line,
+		 __entry->func, __entry->file, __entry->correct)
+);
+
+FTRACE_ENTRY(hw_branch, hw_branch_entry,
+
+	TRACE_HW_BRANCHES,
+
+	F_STRUCT(
+		__field(	u64,	from	)
+		__field(	u64,	to	)
+	),
+
+	F_printk("from: %llx to: %llx", __entry->from, __entry->to)
+);
+
+FTRACE_ENTRY(power, trace_power,
+
+	TRACE_POWER,
+
+	F_STRUCT(
+		__field_struct(	struct power_trace,	state_data	)
+		__field_desc(	s64,	state_data,	stamp		)
+		__field_desc(	s64,	state_data,	end		)
+		__field_desc(	int,	state_data,	type		)
+		__field_desc(	int,	state_data,	state		)
+	),
+
+	F_printk("%llx->%llx type:%u state:%u",
+		 __entry->stamp, __entry->end,
+		 __entry->type, __entry->state)
+);
+
+FTRACE_ENTRY(kmem_alloc, kmemtrace_alloc_entry,
+
+	TRACE_KMEM_ALLOC,
+
+	F_STRUCT(
+		__field(	enum kmemtrace_type_id,	type_id		)
+		__field(	unsigned long,		call_site	)
+		__field(	const void *,		ptr		)
+		__field(	size_t,			bytes_req	)
+		__field(	size_t,			bytes_alloc	)
+		__field(	gfp_t,			gfp_flags	)
+		__field(	int,			node		)
+	),
+
+	F_printk("type:%u call_site:%lx ptr:%p req:%zi alloc:%zi"
+		 " flags:%x node:%d",
+		 __entry->type_id, __entry->call_site, __entry->ptr,
+		 __entry->bytes_req, __entry->bytes_alloc,
+		 __entry->gfp_flags, __entry->node)
+);
+
+FTRACE_ENTRY(kmem_free, kmemtrace_free_entry,
+
+	TRACE_KMEM_FREE,
+
+	F_STRUCT(
+		__field(	enum kmemtrace_type_id,	type_id		)
+		__field(	unsigned long,		call_site	)
+		__field(	const void *,		ptr		)
+	),
+
+	F_printk("type:%u call_site:%lx ptr:%p",
+		 __entry->type_id, __entry->call_site, __entry->ptr)
+);
diff --git a/kernel/trace/trace_event_profile.c b/kernel/trace/trace_event_profile.c
index 11ba5bb..55a25c9 100644
--- a/kernel/trace/trace_event_profile.c
+++ b/kernel/trace/trace_event_profile.c
@@ -5,6 +5,7 @@
  *
  */
 
+#include <linux/module.h>
 #include "trace.h"
 
 int ftrace_profile_enable(int event_id)
@@ -14,7 +15,8 @@ int ftrace_profile_enable(int event_id)
 
 	mutex_lock(&event_mutex);
 	list_for_each_entry(event, &ftrace_events, list) {
-		if (event->id == event_id && event->profile_enable) {
+		if (event->id == event_id && event->profile_enable &&
+		    try_module_get(event->mod)) {
 			ret = event->profile_enable(event);
 			break;
 		}
@@ -32,6 +34,7 @@ void ftrace_profile_disable(int event_id)
 	list_for_each_entry(event, &ftrace_events, list) {
 		if (event->id == event_id) {
 			event->profile_disable(event);
+			module_put(event->mod);
 			break;
 		}
 	}
diff --git a/kernel/trace/trace_event_types.h b/kernel/trace/trace_event_types.h
deleted file mode 100644
index 6db005e..0000000
--- a/kernel/trace/trace_event_types.h
+++ /dev/null
@@ -1,178 +0,0 @@
-#undef TRACE_SYSTEM
-#define TRACE_SYSTEM	ftrace
-
-/*
- * We cheat and use the proto type field as the ID
- * and args as the entry type (minus 'struct')
- */
-TRACE_EVENT_FORMAT(function, TRACE_FN, ftrace_entry, ignore,
-	TRACE_STRUCT(
-		TRACE_FIELD(unsigned long, ip, ip)
-		TRACE_FIELD(unsigned long, parent_ip, parent_ip)
-	),
-	TP_RAW_FMT(" %lx <-- %lx")
-);
-
-TRACE_EVENT_FORMAT(funcgraph_entry, TRACE_GRAPH_ENT,
-		   ftrace_graph_ent_entry, ignore,
-	TRACE_STRUCT(
-		TRACE_FIELD(unsigned long, graph_ent.func, func)
-		TRACE_FIELD(int, graph_ent.depth, depth)
-	),
-	TP_RAW_FMT("--> %lx (%d)")
-);
-
-TRACE_EVENT_FORMAT(funcgraph_exit, TRACE_GRAPH_RET,
-		   ftrace_graph_ret_entry, ignore,
-	TRACE_STRUCT(
-		TRACE_FIELD(unsigned long, ret.func, func)
-		TRACE_FIELD(unsigned long long, ret.calltime, calltime)
-		TRACE_FIELD(unsigned long long, ret.rettime, rettime)
-		TRACE_FIELD(unsigned long, ret.overrun, overrun)
-		TRACE_FIELD(int, ret.depth, depth)
-	),
-	TP_RAW_FMT("<-- %lx (%d)")
-);
-
-TRACE_EVENT_FORMAT(wakeup, TRACE_WAKE, ctx_switch_entry, ignore,
-	TRACE_STRUCT(
-		TRACE_FIELD(unsigned int, prev_pid, prev_pid)
-		TRACE_FIELD(unsigned char, prev_prio, prev_prio)
-		TRACE_FIELD(unsigned char, prev_state, prev_state)
-		TRACE_FIELD(unsigned int, next_pid, next_pid)
-		TRACE_FIELD(unsigned char, next_prio, next_prio)
-		TRACE_FIELD(unsigned char, next_state, next_state)
-		TRACE_FIELD(unsigned int, next_cpu, next_cpu)
-	),
-	TP_RAW_FMT("%u:%u:%u  ==+ %u:%u:%u [%03u]")
-);
-
-TRACE_EVENT_FORMAT(context_switch, TRACE_CTX, ctx_switch_entry, ignore,
-	TRACE_STRUCT(
-		TRACE_FIELD(unsigned int, prev_pid, prev_pid)
-		TRACE_FIELD(unsigned char, prev_prio, prev_prio)
-		TRACE_FIELD(unsigned char, prev_state, prev_state)
-		TRACE_FIELD(unsigned int, next_pid, next_pid)
-		TRACE_FIELD(unsigned char, next_prio, next_prio)
-		TRACE_FIELD(unsigned char, next_state, next_state)
-		TRACE_FIELD(unsigned int, next_cpu, next_cpu)
-	),
-	TP_RAW_FMT("%u:%u:%u  ==+ %u:%u:%u [%03u]")
-);
-
-TRACE_EVENT_FORMAT_NOFILTER(special, TRACE_SPECIAL, special_entry, ignore,
-	TRACE_STRUCT(
-		TRACE_FIELD(unsigned long, arg1, arg1)
-		TRACE_FIELD(unsigned long, arg2, arg2)
-		TRACE_FIELD(unsigned long, arg3, arg3)
-	),
-	TP_RAW_FMT("(%08lx) (%08lx) (%08lx)")
-);
-
-/*
- * Stack-trace entry:
- */
-
-/* #define FTRACE_STACK_ENTRIES   8 */
-
-TRACE_EVENT_FORMAT(kernel_stack, TRACE_STACK, stack_entry, ignore,
-	TRACE_STRUCT(
-		TRACE_FIELD(unsigned long, caller[0], stack0)
-		TRACE_FIELD(unsigned long, caller[1], stack1)
-		TRACE_FIELD(unsigned long, caller[2], stack2)
-		TRACE_FIELD(unsigned long, caller[3], stack3)
-		TRACE_FIELD(unsigned long, caller[4], stack4)
-		TRACE_FIELD(unsigned long, caller[5], stack5)
-		TRACE_FIELD(unsigned long, caller[6], stack6)
-		TRACE_FIELD(unsigned long, caller[7], stack7)
-	),
-	TP_RAW_FMT("\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n"
-		 "\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n")
-);
-
-TRACE_EVENT_FORMAT(user_stack, TRACE_USER_STACK, userstack_entry, ignore,
-	TRACE_STRUCT(
-		TRACE_FIELD(unsigned long, caller[0], stack0)
-		TRACE_FIELD(unsigned long, caller[1], stack1)
-		TRACE_FIELD(unsigned long, caller[2], stack2)
-		TRACE_FIELD(unsigned long, caller[3], stack3)
-		TRACE_FIELD(unsigned long, caller[4], stack4)
-		TRACE_FIELD(unsigned long, caller[5], stack5)
-		TRACE_FIELD(unsigned long, caller[6], stack6)
-		TRACE_FIELD(unsigned long, caller[7], stack7)
-	),
-	TP_RAW_FMT("\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n"
-		 "\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n")
-);
-
-TRACE_EVENT_FORMAT(bprint, TRACE_BPRINT, bprint_entry, ignore,
-	TRACE_STRUCT(
-		TRACE_FIELD(unsigned long, ip, ip)
-		TRACE_FIELD(char *, fmt, fmt)
-		TRACE_FIELD_ZERO_CHAR(buf)
-	),
-	TP_RAW_FMT("%08lx (%d) fmt:%p %s")
-);
-
-TRACE_EVENT_FORMAT(print, TRACE_PRINT, print_entry, ignore,
-	TRACE_STRUCT(
-		TRACE_FIELD(unsigned long, ip, ip)
-		TRACE_FIELD_ZERO_CHAR(buf)
-	),
-	TP_RAW_FMT("%08lx (%d) fmt:%p %s")
-);
-
-TRACE_EVENT_FORMAT(branch, TRACE_BRANCH, trace_branch, ignore,
-	TRACE_STRUCT(
-		TRACE_FIELD(unsigned int, line, line)
-		TRACE_FIELD_SPECIAL(char func[TRACE_FUNC_SIZE+1], func,
-				    TRACE_FUNC_SIZE+1, func)
-		TRACE_FIELD_SPECIAL(char file[TRACE_FUNC_SIZE+1], file,
-				    TRACE_FUNC_SIZE+1, file)
-		TRACE_FIELD(char, correct, correct)
-	),
-	TP_RAW_FMT("%u:%s:%s (%u)")
-);
-
-TRACE_EVENT_FORMAT(hw_branch, TRACE_HW_BRANCHES, hw_branch_entry, ignore,
-	TRACE_STRUCT(
-		TRACE_FIELD(u64, from, from)
-		TRACE_FIELD(u64, to, to)
-	),
-	TP_RAW_FMT("from: %llx to: %llx")
-);
-
-TRACE_EVENT_FORMAT(power, TRACE_POWER, trace_power, ignore,
-	TRACE_STRUCT(
-		TRACE_FIELD_SIGN(ktime_t, state_data.stamp, stamp, 1)
-		TRACE_FIELD_SIGN(ktime_t, state_data.end, end, 1)
-		TRACE_FIELD(int, state_data.type, type)
-		TRACE_FIELD(int, state_data.state, state)
-	),
-	TP_RAW_FMT("%llx->%llx type:%u state:%u")
-);
-
-TRACE_EVENT_FORMAT(kmem_alloc, TRACE_KMEM_ALLOC, kmemtrace_alloc_entry, ignore,
-	TRACE_STRUCT(
-		TRACE_FIELD(enum kmemtrace_type_id, type_id, type_id)
-		TRACE_FIELD(unsigned long, call_site, call_site)
-		TRACE_FIELD(const void *, ptr, ptr)
-		TRACE_FIELD(size_t, bytes_req, bytes_req)
-		TRACE_FIELD(size_t, bytes_alloc, bytes_alloc)
-		TRACE_FIELD(gfp_t, gfp_flags, gfp_flags)
-		TRACE_FIELD(int, node, node)
-	),
-	TP_RAW_FMT("type:%u call_site:%lx ptr:%p req:%lu alloc:%lu"
-		 " flags:%x node:%d")
-);
-
-TRACE_EVENT_FORMAT(kmem_free, TRACE_KMEM_FREE, kmemtrace_free_entry, ignore,
-	TRACE_STRUCT(
-		TRACE_FIELD(enum kmemtrace_type_id, type_id, type_id)
-		TRACE_FIELD(unsigned long, call_site, call_site)
-		TRACE_FIELD(const void *, ptr, ptr)
-	),
-	TP_RAW_FMT("type:%u call_site:%lx ptr:%p")
-);
-
-#undef TRACE_SYSTEM
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 97e2c4d..56c260b 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -21,6 +21,7 @@
 
 #include "trace_output.h"
 
+#undef TRACE_SYSTEM
 #define TRACE_SYSTEM "TRACE_SYSTEM"
 
 DEFINE_MUTEX(event_mutex);
@@ -86,7 +87,7 @@ int trace_define_common_fields(struct ftrace_event_call *call)
 	__common_field(unsigned char, flags);
 	__common_field(unsigned char, preempt_count);
 	__common_field(int, pid);
-	__common_field(int, tgid);
+	__common_field(int, lock_depth);
 
 	return ret;
 }
@@ -230,11 +231,9 @@ static ssize_t
 ftrace_event_write(struct file *file, const char __user *ubuf,
 		   size_t cnt, loff_t *ppos)
 {
+	struct trace_parser parser;
 	size_t read = 0;
-	int i, set = 1;
 	ssize_t ret;
-	char *buf;
-	char ch;
 
 	if (!cnt || cnt < 0)
 		return 0;
@@ -243,60 +242,28 @@ ftrace_event_write(struct file *file, const char __user *ubuf,
 	if (ret < 0)
 		return ret;
 
-	ret = get_user(ch, ubuf++);
-	if (ret)
-		return ret;
-	read++;
-	cnt--;
-
-	/* skip white space */
-	while (cnt && isspace(ch)) {
-		ret = get_user(ch, ubuf++);
-		if (ret)
-			return ret;
-		read++;
-		cnt--;
-	}
-
-	/* Only white space found? */
-	if (isspace(ch)) {
-		file->f_pos += read;
-		ret = read;
-		return ret;
-	}
-
-	buf = kmalloc(EVENT_BUF_SIZE+1, GFP_KERNEL);
-	if (!buf)
+	if (trace_parser_get_init(&parser, EVENT_BUF_SIZE + 1))
 		return -ENOMEM;
 
-	if (cnt > EVENT_BUF_SIZE)
-		cnt = EVENT_BUF_SIZE;
+	read = trace_get_user(&parser, ubuf, cnt, ppos);
+
+	if (trace_parser_loaded((&parser))) {
+		int set = 1;
 
-	i = 0;
-	while (cnt && !isspace(ch)) {
-		if (!i && ch == '!')
+		if (*parser.buffer == '!')
 			set = 0;
-		else
-			buf[i++] = ch;
 
-		ret = get_user(ch, ubuf++);
+		parser.buffer[parser.idx] = 0;
+
+		ret = ftrace_set_clr_event(parser.buffer + !set, set);
 		if (ret)
-			goto out_free;
-		read++;
-		cnt--;
+			goto out_put;
 	}
-	buf[i] = 0;
-
-	file->f_pos += read;
-
-	ret = ftrace_set_clr_event(buf, set);
-	if (ret)
-		goto out_free;
 
 	ret = read;
 
- out_free:
-	kfree(buf);
+ out_put:
+	trace_parser_put(&parser);
 
 	return ret;
 }
@@ -578,7 +545,7 @@ static int trace_write_header(struct trace_seq *s)
 				FIELD(unsigned char, flags),
 				FIELD(unsigned char, preempt_count),
 				FIELD(int, pid),
-				FIELD(int, tgid));
+				FIELD(int, lock_depth));
 }
 
 static ssize_t
@@ -1187,7 +1154,7 @@ static int trace_module_notify(struct notifier_block *self,
 }
 #endif /* CONFIG_MODULES */
 
-struct notifier_block trace_module_nb = {
+static struct notifier_block trace_module_nb = {
 	.notifier_call = trace_module_notify,
 	.priority = 0,
 };
@@ -1359,6 +1326,18 @@ static __init void event_trace_self_tests(void)
 		if (!call->regfunc)
 			continue;
 
+/*
+ * Testing syscall events here is pretty useless, but
+ * we still do it if configured. But this is time consuming.
+ * What we really need is a user thread to perform the
+ * syscalls as we test.
+ */
+#ifndef CONFIG_EVENT_TRACE_TEST_SYSCALLS
+		if (call->system &&
+		    strcmp(call->system, "syscalls") == 0)
+			continue;
+#endif
+
 		pr_info("Testing event %s: ", call->name);
 
 		/*
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 93660fb..2324578 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -121,6 +121,47 @@ struct filter_parse_state {
 	} operand;
 };
 
+#define DEFINE_COMPARISON_PRED(type)					\
+static int filter_pred_##type(struct filter_pred *pred, void *event,	\
+			      int val1, int val2)			\
+{									\
+	type *addr = (type *)(event + pred->offset);			\
+	type val = (type)pred->val;					\
+	int match = 0;							\
+									\
+	switch (pred->op) {						\
+	case OP_LT:							\
+		match = (*addr < val);					\
+		break;							\
+	case OP_LE:							\
+		match = (*addr <= val);					\
+		break;							\
+	case OP_GT:							\
+		match = (*addr > val);					\
+		break;							\
+	case OP_GE:							\
+		match = (*addr >= val);					\
+		break;							\
+	default:							\
+		break;							\
+	}								\
+									\
+	return match;							\
+}
+
+#define DEFINE_EQUALITY_PRED(size)					\
+static int filter_pred_##size(struct filter_pred *pred, void *event,	\
+			      int val1, int val2)			\
+{									\
+	u##size *addr = (u##size *)(event + pred->offset);		\
+	u##size val = (u##size)pred->val;				\
+	int match;							\
+									\
+	match = (val == *addr) ^ pred->not;				\
+									\
+	return match;							\
+}
+
 DEFINE_COMPARISON_PRED(s64);
 DEFINE_COMPARISON_PRED(u64);
 DEFINE_COMPARISON_PRED(s32);
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index df1bf6e..9753fcc 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -15,146 +15,125 @@
 
 #include "trace_output.h"
 
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM	ftrace
 
-#undef TRACE_STRUCT
-#define TRACE_STRUCT(args...) args
+/* not needed for this file */
+#undef __field_struct
+#define __field_struct(type, item)
 
-extern void __bad_type_size(void);
+#undef __field
+#define __field(type, item)				type item;
 
-#undef TRACE_FIELD
-#define TRACE_FIELD(type, item, assign)					\
-	if (sizeof(type) != sizeof(field.item))				\
-		__bad_type_size();					\
+#undef __field_desc
+#define __field_desc(type, container, item)		type item;
+
+#undef __array
+#define __array(type, item, size)			type item[size];
+
+#undef __array_desc
+#define __array_desc(type, container, item, size)	type item[size];
+
+#undef __dynamic_array
+#define __dynamic_array(type, item)			type item[];
+
+#undef F_STRUCT
+#define F_STRUCT(args...)				args
+
+#undef F_printk
+#define F_printk(fmt, args...) fmt, args
+
+#undef FTRACE_ENTRY
+#define FTRACE_ENTRY(name, struct_name, id, tstruct, print)	\
+struct ____ftrace_##name {					\
+	tstruct							\
+};								\
+static void __used ____ftrace_check_##name(void)		\
+{								\
+	struct ____ftrace_##name *__entry = NULL;		\
+								\
+	/* force cmpile-time check on F_printk() */		\
+	printk(print);						\
+}
+
+#undef FTRACE_ENTRY_DUP
+#define FTRACE_ENTRY_DUP(name, struct_name, id, tstruct, print)	\
+	FTRACE_ENTRY(name, struct_name, id, PARAMS(tstruct), PARAMS(print))
+
+#include "trace_entries.h"
+
+
+#undef __field
+#define __field(type, item)						\
 	ret = trace_seq_printf(s, "\tfield:" #type " " #item ";\t"	\
-			       "offset:%u;\tsize:%u;\n",		\
-			       (unsigned int)offsetof(typeof(field), item), \
-			       (unsigned int)sizeof(field.item));	\
+			       "offset:%zu;\tsize:%zu;\n",		\
+			       offsetof(typeof(field), item),		\
+			       sizeof(field.item));			\
 	if (!ret)							\
 		return 0;
 
+#undef __field_desc
+#define __field_desc(type, container, item)				\
+	ret = trace_seq_printf(s, "\tfield:" #type " " #item ";\t"	\
+			       "offset:%zu;\tsize:%zu;\n",		\
+			       offsetof(typeof(field), container.item),	\
+			       sizeof(field.container.item));		\
+	if (!ret)							\
+		return 0;
 
-#undef TRACE_FIELD_SPECIAL
-#define TRACE_FIELD_SPECIAL(type_item, item, len, cmd)			\
-	ret = trace_seq_printf(s, "\tfield special:" #type_item ";\t"	\
-			       "offset:%u;\tsize:%u;\n",		\
-			       (unsigned int)offsetof(typeof(field), item), \
-			       (unsigned int)sizeof(field.item));	\
+#undef __array
+#define __array(type, item, len)					\
+	ret = trace_seq_printf(s, "\tfield:" #type " " #item "[" #len "];\t" \
+			       "offset:%zu;\tsize:%zu;\n",		\
+			       offsetof(typeof(field), item),	\
+			       sizeof(field.item));		\
 	if (!ret)							\
 		return 0;
 
-#undef TRACE_FIELD_ZERO_CHAR
-#define TRACE_FIELD_ZERO_CHAR(item)					\
-	ret = trace_seq_printf(s, "\tfield:char " #item ";\t"		\
-			       "offset:%u;\tsize:0;\n",			\
-			       (unsigned int)offsetof(typeof(field), item)); \
+#undef __array_desc
+#define __array_desc(type, container, item, len)			\
+	ret = trace_seq_printf(s, "\tfield:" #type " " #item "[" #len "];\t" \
+			       "offset:%zu;\tsize:%zu;\n",		\
+			       offsetof(typeof(field), container.item),	\
+			       sizeof(field.container.item));		\
 	if (!ret)							\
 		return 0;
 
-#undef TRACE_FIELD_SIGN
-#define TRACE_FIELD_SIGN(type, item, assign, is_signed)	\
-	TRACE_FIELD(type, item, assign)
+#undef __dynamic_array
+#define __dynamic_array(type, item)					\
+	ret = trace_seq_printf(s, "\tfield:" #type " " #item ";\t"	\
+			       "offset:%zu;\tsize:0;\n",		\
+			       offsetof(typeof(field), item));		\
+	if (!ret)							\
+		return 0;
 
-#undef TP_RAW_FMT
-#define TP_RAW_FMT(args...) args
+#undef F_printk
+#define F_printk(fmt, args...) "%s, %s\n", #fmt, __stringify(args)
 
-#undef TRACE_EVENT_FORMAT
-#define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
-static int								\
-ftrace_format_##call(struct ftrace_event_call *unused,			\
-		      struct trace_seq *s)				\
-{									\
-	struct args field;						\
-	int ret;							\
-									\
-	tstruct;							\
-									\
-	trace_seq_printf(s, "\nprint fmt: \"%s\"\n", tpfmt);		\
-									\
-	return ret;							\
-}
+#undef __entry
+#define __entry REC
 
-#undef TRACE_EVENT_FORMAT_NOFILTER
-#define TRACE_EVENT_FORMAT_NOFILTER(call, proto, args, fmt, tstruct,	\
-				    tpfmt)				\
+#undef FTRACE_ENTRY
+#define FTRACE_ENTRY(name, struct_name, id, tstruct, print)		\
 static int								\
-ftrace_format_##call(struct ftrace_event_call *unused,			\
-		      struct trace_seq *s)				\
+ftrace_format_##name(struct ftrace_event_call *unused,			\
+		     struct trace_seq *s)				\
 {									\
-	struct args field;						\
-	int ret;							\
+	struct struct_name field __attribute__((unused));		\
+	int ret = 0;							\
 									\
 	tstruct;							\
 									\
-	trace_seq_printf(s, "\nprint fmt: \"%s\"\n", tpfmt);		\
+	trace_seq_printf(s, "\nprint fmt: " print);			\
 									\
 	return ret;							\
 }
 
-#include "trace_event_types.h"
-
-#undef TRACE_ZERO_CHAR
-#define TRACE_ZERO_CHAR(arg)
-
-#undef TRACE_FIELD
-#define TRACE_FIELD(type, item, assign)\
-	entry->item = assign;
-
-#undef TRACE_FIELD
-#define TRACE_FIELD(type, item, assign)\
-	entry->item = assign;
-
-#undef TRACE_FIELD_SIGN
-#define TRACE_FIELD_SIGN(type, item, assign, is_signed)	\
-	TRACE_FIELD(type, item, assign)
-
-#undef TP_CMD
-#define TP_CMD(cmd...)	cmd
-
-#undef TRACE_ENTRY
-#define TRACE_ENTRY	entry
-
-#undef TRACE_FIELD_SPECIAL
-#define TRACE_FIELD_SPECIAL(type_item, item, len, cmd)	\
-	cmd;
-
-#undef TRACE_EVENT_FORMAT
-#define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
-int ftrace_define_fields_##call(struct ftrace_event_call *event_call);	\
-static int ftrace_raw_init_event_##call(void);				\
-									\
-struct ftrace_event_call __used						\
-__attribute__((__aligned__(4)))						\
-__attribute__((section("_ftrace_events"))) event_##call = {		\
-	.name			= #call,				\
-	.id			= proto,				\
-	.system			= __stringify(TRACE_SYSTEM),		\
-	.raw_init		= ftrace_raw_init_event_##call,		\
-	.show_format		= ftrace_format_##call,			\
-	.define_fields		= ftrace_define_fields_##call,		\
-};									\
-static int ftrace_raw_init_event_##call(void)				\
-{									\
-	INIT_LIST_HEAD(&event_##call.fields);				\
-	return 0;							\
-}									\
-
-#undef TRACE_EVENT_FORMAT_NOFILTER
-#define TRACE_EVENT_FORMAT_NOFILTER(call, proto, args, fmt, tstruct,	\
-				    tpfmt)				\
-									\
-struct ftrace_event_call __used						\
-__attribute__((__aligned__(4)))						\
-__attribute__((section("_ftrace_events"))) event_##call = {		\
-	.name			= #call,				\
-	.id			= proto,				\
-	.system			= __stringify(TRACE_SYSTEM),		\
-	.show_format		= ftrace_format_##call,			\
-};
+#include "trace_entries.h"
 
-#include "trace_event_types.h"
 
-#undef TRACE_FIELD
-#define TRACE_FIELD(type, item, assign)					\
+#undef __field
+#define __field(type, item)						\
 	ret = trace_define_field(event_call, #type, #item,		\
 				 offsetof(typeof(field), item),		\
 				 sizeof(field.item),			\
@@ -162,32 +141,45 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 	if (ret)							\
 		return ret;
 
-#undef TRACE_FIELD_SPECIAL
-#define TRACE_FIELD_SPECIAL(type, item, len, cmd)			\
+#undef __field_desc
+#define __field_desc(type, container, item)	\
+	ret = trace_define_field(event_call, #type, #item,		\
+				 offsetof(typeof(field),		\
+					  container.item),		\
+				 sizeof(field.container.item),		\
+				 is_signed_type(type), FILTER_OTHER);	\
+	if (ret)							\
+		return ret;
+
+#undef __array
+#define __array(type, item, len)					\
+	BUILD_BUG_ON(len > MAX_FILTER_STR_VAL);				\
 	ret = trace_define_field(event_call, #type "[" #len "]", #item,	\
 				 offsetof(typeof(field), item),		\
 				 sizeof(field.item), 0, FILTER_OTHER);	\
 	if (ret)							\
 		return ret;
 
-#undef TRACE_FIELD_SIGN
-#define TRACE_FIELD_SIGN(type, item, assign, is_signed)			\
-	ret = trace_define_field(event_call, #type, #item,		\
-				 offsetof(typeof(field), item),		\
-				 sizeof(field.item), is_signed,		\
+#undef __array_desc
+#define __array_desc(type, container, item, len)			\
+	BUILD_BUG_ON(len > MAX_FILTER_STR_VAL);				\
+	ret = trace_define_field(event_call, #type "[" #len "]", #item,	\
+				 offsetof(typeof(field),		\
+					  container.item),		\
+				 sizeof(field.container.item), 0,	\
 				 FILTER_OTHER);				\
 	if (ret)							\
 		return ret;
 
-#undef TRACE_FIELD_ZERO_CHAR
-#define TRACE_FIELD_ZERO_CHAR(item)
+#undef __dynamic_array
+#define __dynamic_array(type, item)
 
-#undef TRACE_EVENT_FORMAT
-#define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
+#undef FTRACE_ENTRY
+#define FTRACE_ENTRY(name, struct_name, id, tstruct, print)		\
 int									\
-ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
+ftrace_define_fields_##name(struct ftrace_event_call *event_call)	\
 {									\
-	struct args field;						\
+	struct struct_name field;					\
 	int ret;							\
 									\
 	ret = trace_define_common_fields(event_call);			\
@@ -199,8 +191,42 @@ ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
 	return ret;							\
 }
 
-#undef TRACE_EVENT_FORMAT_NOFILTER
-#define TRACE_EVENT_FORMAT_NOFILTER(call, proto, args, fmt, tstruct,	\
-				    tpfmt)
+#include "trace_entries.h"
+
+
+#undef __field
+#define __field(type, item)
+
+#undef __field_desc
+#define __field_desc(type, container, item)
+
+#undef __array
+#define __array(type, item, len)
+
+#undef __array_desc
+#define __array_desc(type, container, item, len)
+
+#undef __dynamic_array
+#define __dynamic_array(type, item)
+
+#undef FTRACE_ENTRY
+#define FTRACE_ENTRY(call, struct_name, type, tstruct, print)		\
+static int ftrace_raw_init_event_##call(void);				\
+									\
+struct ftrace_event_call __used						\
+__attribute__((__aligned__(4)))						\
+__attribute__((section("_ftrace_events"))) event_##call = {		\
+	.name			= #call,				\
+	.id			= type,					\
+	.system			= __stringify(TRACE_SYSTEM),		\
+	.raw_init		= ftrace_raw_init_event_##call,		\
+	.show_format		= ftrace_format_##call,			\
+	.define_fields		= ftrace_define_fields_##call,		\
+};									\
+static int ftrace_raw_init_event_##call(void)				\
+{									\
+	INIT_LIST_HEAD(&event_##call.fields);				\
+	return 0;							\
+}									\
 
-#include "trace_event_types.h"
+#include "trace_entries.h"
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 5b01b94..b3f3776 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -290,7 +290,7 @@ ftrace_trace_onoff_print(struct seq_file *m, unsigned long ip,
 {
 	long count = (long)data;
 
-	seq_printf(m, "%pf:", (void *)ip);
+	seq_printf(m, "%ps:", (void *)ip);
 
 	if (ops == &traceon_probe_ops)
 		seq_printf(m, "traceon");
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index b3749a2..45e6c01 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -124,7 +124,7 @@ ftrace_pop_return_trace(struct ftrace_graph_ret *trace, unsigned long *ret,
 	if (unlikely(current->ret_stack[index].fp != frame_pointer)) {
 		ftrace_graph_stop();
 		WARN(1, "Bad frame pointer: expected %lx, received %lx\n"
-		     "  from func %pF return to %lx\n",
+		     "  from func %ps return to %lx\n",
 		     current->ret_stack[index].fp,
 		     frame_pointer,
 		     (void *)current->ret_stack[index].func,
@@ -364,6 +364,15 @@ print_graph_proc(struct trace_seq *s, pid_t pid)
 }
 
 
+static enum print_line_t
+print_graph_lat_fmt(struct trace_seq *s, struct trace_entry *entry)
+{
+	if (!trace_seq_putc(s, ' '))
+		return 0;
+
+	return trace_print_lat_fmt(s, entry);
+}
+
 /* If the pid changed since the last trace, output this event */
 static enum print_line_t
 verif_pid(struct trace_seq *s, pid_t pid, int cpu, struct fgraph_data *data)
@@ -521,6 +530,7 @@ print_graph_irq(struct trace_iterator *iter, unsigned long addr,
 		if (ret == TRACE_TYPE_PARTIAL_LINE)
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
+
 	/* Proc */
 	if (tracer_flags.val & TRACE_GRAPH_PRINT_PROC) {
 		ret = print_graph_proc(s, pid);
@@ -659,7 +669,7 @@ print_graph_entry_leaf(struct trace_iterator *iter,
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
 
-	ret = trace_seq_printf(s, "%pf();\n", (void *)call->func);
+	ret = trace_seq_printf(s, "%ps();\n", (void *)call->func);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
@@ -702,7 +712,7 @@ print_graph_entry_nested(struct trace_iterator *iter,
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
 
-	ret = trace_seq_printf(s, "%pf() {\n", (void *)call->func);
+	ret = trace_seq_printf(s, "%ps() {\n", (void *)call->func);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
@@ -758,6 +768,13 @@ print_graph_prologue(struct trace_iterator *iter, struct trace_seq *s,
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
 
+	/* Latency format */
+	if (trace_flags & TRACE_ITER_LATENCY_FMT) {
+		ret = print_graph_lat_fmt(s, ent);
+		if (ret == TRACE_TYPE_PARTIAL_LINE)
+			return TRACE_TYPE_PARTIAL_LINE;
+	}
+
 	return 0;
 }
 
@@ -952,28 +969,59 @@ print_graph_function(struct trace_iterator *iter)
 	return TRACE_TYPE_HANDLED;
 }
 
+static void print_lat_header(struct seq_file *s)
+{
+	static const char spaces[] = "                "	/* 16 spaces */
+		"    "					/* 4 spaces */
+		"                 ";			/* 17 spaces */
+	int size = 0;
+
+	if (tracer_flags.val & TRACE_GRAPH_PRINT_ABS_TIME)
+		size += 16;
+	if (tracer_flags.val & TRACE_GRAPH_PRINT_CPU)
+		size += 4;
+	if (tracer_flags.val & TRACE_GRAPH_PRINT_PROC)
+		size += 17;
+
+	seq_printf(s, "#%.*s  _-----=> irqs-off        \n", size, spaces);
+	seq_printf(s, "#%.*s / _----=> need-resched    \n", size, spaces);
+	seq_printf(s, "#%.*s| / _---=> hardirq/softirq \n", size, spaces);
+	seq_printf(s, "#%.*s|| / _--=> preempt-depth   \n", size, spaces);
+	seq_printf(s, "#%.*s||| / _-=> lock-depth      \n", size, spaces);
+	seq_printf(s, "#%.*s|||| /                     \n", size, spaces);
+}
+
 static void print_graph_headers(struct seq_file *s)
 {
+	int lat = trace_flags & TRACE_ITER_LATENCY_FMT;
+
+	if (lat)
+		print_lat_header(s);
+
 	/* 1st line */
-	seq_printf(s, "# ");
+	seq_printf(s, "#");
 	if (tracer_flags.val & TRACE_GRAPH_PRINT_ABS_TIME)
 		seq_printf(s, "     TIME       ");
 	if (tracer_flags.val & TRACE_GRAPH_PRINT_CPU)
-		seq_printf(s, "CPU");
+		seq_printf(s, " CPU");
 	if (tracer_flags.val & TRACE_GRAPH_PRINT_PROC)
-		seq_printf(s, "  TASK/PID      ");
+		seq_printf(s, "  TASK/PID       ");
+	if (lat)
+		seq_printf(s, "|||||");
 	if (tracer_flags.val & TRACE_GRAPH_PRINT_DURATION)
 		seq_printf(s, "  DURATION   ");
 	seq_printf(s, "               FUNCTION CALLS\n");
 
 	/* 2nd line */
-	seq_printf(s, "# ");
+	seq_printf(s, "#");
 	if (tracer_flags.val & TRACE_GRAPH_PRINT_ABS_TIME)
 		seq_printf(s, "      |         ");
 	if (tracer_flags.val & TRACE_GRAPH_PRINT_CPU)
-		seq_printf(s, "|  ");
+		seq_printf(s, " |  ");
 	if (tracer_flags.val & TRACE_GRAPH_PRINT_PROC)
-		seq_printf(s, "  |    |        ");
+		seq_printf(s, "   |    |        ");
+	if (lat)
+		seq_printf(s, "|||||");
 	if (tracer_flags.val & TRACE_GRAPH_PRINT_DURATION)
 		seq_printf(s, "   |   |      ");
 	seq_printf(s, "               |   |   |   |\n");
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 5555b75..3aa7eaa 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -129,15 +129,10 @@ check_critical_timing(struct trace_array *tr,
 		      unsigned long parent_ip,
 		      int cpu)
 {
-	unsigned long latency, t0, t1;
 	cycle_t T0, T1, delta;
 	unsigned long flags;
 	int pc;
 
-	/*
-	 * usecs conversion is slow so we try to delay the conversion
-	 * as long as possible:
-	 */
 	T0 = data->preempt_timestamp;
 	T1 = ftrace_now(cpu);
 	delta = T1-T0;
@@ -157,18 +152,15 @@ check_critical_timing(struct trace_array *tr,
 
 	trace_function(tr, CALLER_ADDR0, parent_ip, flags, pc);
 
-	latency = nsecs_to_usecs(delta);
-
 	if (data->critical_sequence != max_sequence)
 		goto out_unlock;
 
-	tracing_max_latency = delta;
-	t0 = nsecs_to_usecs(T0);
-	t1 = nsecs_to_usecs(T1);
-
 	data->critical_end = parent_ip;
 
-	update_max_tr_single(tr, current, cpu);
+	if (likely(!is_tracing_stopped())) {
+		tracing_max_latency = delta;
+		update_max_tr_single(tr, current, cpu);
+	}
 
 	max_sequence++;
 
diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index c4c9bbd..0acd834 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -307,6 +307,7 @@ static void __trace_mmiotrace_rw(struct trace_array *tr,
 				struct trace_array_cpu *data,
 				struct mmiotrace_rw *rw)
 {
+	struct ftrace_event_call *call = &event_mmiotrace_rw;
 	struct ring_buffer *buffer = tr->buffer;
 	struct ring_buffer_event *event;
 	struct trace_mmiotrace_rw *entry;
@@ -320,7 +321,9 @@ static void __trace_mmiotrace_rw(struct trace_array *tr,
 	}
 	entry	= ring_buffer_event_data(event);
 	entry->rw			= *rw;
-	trace_buffer_unlock_commit(buffer, event, 0, pc);
+
+	if (!filter_check_discard(call, entry, buffer, event))
+		trace_buffer_unlock_commit(buffer, event, 0, pc);
 }
 
 void mmio_trace_rw(struct mmiotrace_rw *rw)
@@ -334,6 +337,7 @@ static void __trace_mmiotrace_map(struct trace_array *tr,
 				struct trace_array_cpu *data,
 				struct mmiotrace_map *map)
 {
+	struct ftrace_event_call *call = &event_mmiotrace_map;
 	struct ring_buffer *buffer = tr->buffer;
 	struct ring_buffer_event *event;
 	struct trace_mmiotrace_map *entry;
@@ -347,7 +351,9 @@ static void __trace_mmiotrace_map(struct trace_array *tr,
 	}
 	entry	= ring_buffer_event_data(event);
 	entry->map			= *map;
-	trace_buffer_unlock_commit(buffer, event, 0, pc);
+
+	if (!filter_check_discard(call, entry, buffer, event))
+		trace_buffer_unlock_commit(buffer, event, 0, pc);
 }
 
 void mmio_trace_mapping(struct mmiotrace_map *map)
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index e0c2545..f572f44 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -407,7 +407,7 @@ seq_print_userip_objs(const struct userstack_entry *entry, struct trace_seq *s,
 		 * since individual threads might have already quit!
 		 */
 		rcu_read_lock();
-		task = find_task_by_vpid(entry->ent.tgid);
+		task = find_task_by_vpid(entry->tgid);
 		if (task)
 			mm = get_task_mm(task);
 		rcu_read_unlock();
@@ -460,18 +460,23 @@ seq_print_ip_sym(struct trace_seq *s, unsigned long ip, unsigned long sym_flags)
 	return ret;
 }
 
-static int
-lat_print_generic(struct trace_seq *s, struct trace_entry *entry, int cpu)
+/**
+ * trace_print_lat_fmt - print the irq, preempt and lockdep fields
+ * @s: trace seq struct to write to
+ * @entry: The trace entry field from the ring buffer
+ *
+ * Prints the generic fields of irqs off, in hard or softirq, preempt
+ * count and lock depth.
+ */
+int trace_print_lat_fmt(struct trace_seq *s, struct trace_entry *entry)
 {
 	int hardirq, softirq;
-	char comm[TASK_COMM_LEN];
+	int ret;
 
-	trace_find_cmdline(entry->pid, comm);
 	hardirq = entry->flags & TRACE_FLAG_HARDIRQ;
 	softirq = entry->flags & TRACE_FLAG_SOFTIRQ;
 
-	if (!trace_seq_printf(s, "%8.8s-%-5d %3d%c%c%c",
-			      comm, entry->pid, cpu,
+	if (!trace_seq_printf(s, "%c%c%c",
 			      (entry->flags & TRACE_FLAG_IRQS_OFF) ? 'd' :
 				(entry->flags & TRACE_FLAG_IRQS_NOSUPPORT) ?
 				  'X' : '.',
@@ -481,9 +486,30 @@ lat_print_generic(struct trace_seq *s, struct trace_entry *entry, int cpu)
 				hardirq ? 'h' : softirq ? 's' : '.'))
 		return 0;
 
+	if (entry->lock_depth < 0)
+		ret = trace_seq_putc(s, '.');
+	else
+		ret = trace_seq_printf(s, "%d", entry->lock_depth);
+	if (!ret)
+		return 0;
+
 	if (entry->preempt_count)
 		return trace_seq_printf(s, "%x", entry->preempt_count);
-	return trace_seq_puts(s, ".");
+	return trace_seq_putc(s, '.');
+}
+
+static int
+lat_print_generic(struct trace_seq *s, struct trace_entry *entry, int cpu)
+{
+	char comm[TASK_COMM_LEN];
+
+	trace_find_cmdline(entry->pid, comm);
+
+	if (!trace_seq_printf(s, "%8.8s-%-5d %3d",
+			      comm, entry->pid, cpu))
+		return 0;
+
+	return trace_print_lat_fmt(s, entry);
 }
 
 static unsigned long preempt_mark_thresh = 100;
diff --git a/kernel/trace/trace_output.h b/kernel/trace/trace_output.h
index d38bec4..9d91c72 100644
--- a/kernel/trace/trace_output.h
+++ b/kernel/trace/trace_output.h
@@ -26,6 +26,8 @@ extern struct trace_event *ftrace_find_event(int type);
 
 extern enum print_line_t trace_nop_print(struct trace_iterator *iter,
 					 int flags);
+extern int
+trace_print_lat_fmt(struct trace_seq *s, struct trace_entry *entry);
 
 /* used by module unregistering */
 extern int __unregister_ftrace_event(struct trace_event *event);
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index ad69f10..26185d7 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -24,6 +24,7 @@ static int __read_mostly	tracer_enabled;
 
 static struct task_struct	*wakeup_task;
 static int			wakeup_cpu;
+static int			wakeup_current_cpu;
 static unsigned			wakeup_prio = -1;
 static int			wakeup_rt;
 
@@ -56,33 +57,23 @@ wakeup_tracer_call(unsigned long ip, unsigned long parent_ip)
 	resched = ftrace_preempt_disable();
 
 	cpu = raw_smp_processor_id();
+	if (cpu != wakeup_current_cpu)
+		goto out_enable;
+
 	data = tr->data[cpu];
 	disabled = atomic_inc_return(&data->disabled);
 	if (unlikely(disabled != 1))
 		goto out;
 
 	local_irq_save(flags);
-	__raw_spin_lock(&wakeup_lock);
-
-	if (unlikely(!wakeup_task))
-		goto unlock;
-
-	/*
-	 * The task can't disappear because it needs to
-	 * wake up first, and we have the wakeup_lock.
-	 */
-	if (task_cpu(wakeup_task) != cpu)
-		goto unlock;
 
 	trace_function(tr, ip, parent_ip, flags, pc);
 
- unlock:
-	__raw_spin_unlock(&wakeup_lock);
 	local_irq_restore(flags);
 
  out:
 	atomic_dec(&data->disabled);
-
+ out_enable:
 	ftrace_preempt_enable(resched);
 }
 
@@ -107,11 +98,18 @@ static int report_latency(cycle_t delta)
 	return 1;
 }
 
+static void probe_wakeup_migrate_task(struct task_struct *task, int cpu)
+{
+	if (task != wakeup_task)
+		return;
+
+	wakeup_current_cpu = cpu;
+}
+
 static void notrace
 probe_wakeup_sched_switch(struct rq *rq, struct task_struct *prev,
 	struct task_struct *next)
 {
-	unsigned long latency = 0, t0 = 0, t1 = 0;
 	struct trace_array_cpu *data;
 	cycle_t T0, T1, delta;
 	unsigned long flags;
@@ -157,10 +155,6 @@ probe_wakeup_sched_switch(struct rq *rq, struct task_struct *prev,
 	trace_function(wakeup_trace, CALLER_ADDR0, CALLER_ADDR1, flags, pc);
 	tracing_sched_switch_trace(wakeup_trace, prev, next, flags, pc);
 
-	/*
-	 * usecs conversion is slow so we try to delay the conversion
-	 * as long as possible:
-	 */
 	T0 = data->preempt_timestamp;
 	T1 = ftrace_now(cpu);
 	delta = T1-T0;
@@ -168,13 +162,10 @@ probe_wakeup_sched_switch(struct rq *rq, struct task_struct *prev,
 	if (!report_latency(delta))
 		goto out_unlock;
 
-	latency = nsecs_to_usecs(delta);
-
-	tracing_max_latency = delta;
-	t0 = nsecs_to_usecs(T0);
-	t1 = nsecs_to_usecs(T1);
-
-	update_max_tr(wakeup_trace, wakeup_task, wakeup_cpu);
+	if (likely(!is_tracing_stopped())) {
+		tracing_max_latency = delta;
+		update_max_tr(wakeup_trace, wakeup_task, wakeup_cpu);
+	}
 
 out_unlock:
 	__wakeup_reset(wakeup_trace);
@@ -244,6 +235,7 @@ probe_wakeup(struct rq *rq, struct task_struct *p, int success)
 	__wakeup_reset(wakeup_trace);
 
 	wakeup_cpu = task_cpu(p);
+	wakeup_current_cpu = wakeup_cpu;
 	wakeup_prio = p->prio;
 
 	wakeup_task = p;
@@ -293,6 +285,13 @@ static void start_wakeup_tracer(struct trace_array *tr)
 		goto fail_deprobe_wake_new;
 	}
 
+	ret = register_trace_sched_migrate_task(probe_wakeup_migrate_task);
+	if (ret) {
+		pr_info("wakeup trace: Couldn't activate tracepoint"
+			" probe to kernel_sched_migrate_task\n");
+		return;
+	}
+
 	wakeup_reset(tr);
 
 	/*
@@ -325,6 +324,7 @@ static void stop_wakeup_tracer(struct trace_array *tr)
 	unregister_trace_sched_switch(probe_wakeup_sched_switch);
 	unregister_trace_sched_wakeup_new(probe_wakeup);
 	unregister_trace_sched_wakeup(probe_wakeup);
+	unregister_trace_sched_migrate_task(probe_wakeup_migrate_task);
 }
 
 static int __wakeup_tracer_init(struct trace_array *tr)
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index cb8a112..d320c18 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -581,7 +581,7 @@ static char *symbol_string(char *buf, char *end, void *ptr,
 	unsigned long value = (unsigned long) ptr;
 #ifdef CONFIG_KALLSYMS
 	char sym[KSYM_SYMBOL_LEN];
-	if (ext != 'f')
+	if (ext != 'f' && ext != 's')
 		sprint_symbol(sym, value);
 	else
 		kallsyms_lookup(value, NULL, NULL, NULL, sym);
@@ -794,7 +794,8 @@ static char *ip4_addr_string(char *buf, char *end, const u8 *addr,
  *
  * - 'F' For symbolic function descriptor pointers with offset
  * - 'f' For simple symbolic function names without offset
- * - 'S' For symbolic direct pointers
+ * - 'S' For symbolic direct pointers with offset
+ * - 's' For symbolic direct pointers without offset
  * - 'R' For a struct resource pointer, it prints the range of
  *       addresses (not the name nor the flags)
  * - 'M' For a 6-byte MAC address, it prints the address in the
@@ -822,6 +823,7 @@ static char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 	case 'F':
 	case 'f':
 		ptr = dereference_function_descriptor(ptr);
+	case 's':
 		/* Fallthrough */
 	case 'S':
 		return symbol_string(buf, end, ptr, spec, *fmt);
@@ -1063,10 +1065,12 @@ qualifier:
  * @args: Arguments for the format string
  *
  * This function follows C99 vsnprintf, but has some extensions:
- * %pS output the name of a text symbol
+ * %pS output the name of a text symbol with offset
+ * %ps output the name of a text symbol without offset
  * %pF output the name of a function pointer with its offset
  * %pf output the name of a function pointer without its offset
  * %pR output the address range in a struct resource
+ * %n is ignored
  *
  * The return value is the number of characters which would
  * be generated for the given input, excluding the trailing
@@ -1522,11 +1526,7 @@ EXPORT_SYMBOL_GPL(vbin_printf);
  * a binary buffer that generated by vbin_printf.
  *
  * The format follows C99 vsnprintf, but has some extensions:
- * %pS output the name of a text symbol
- * %pF output the name of a function pointer with its offset
- * %pf output the name of a function pointer without its offset
- * %pR output the address range in a struct resource
- * %n is ignored
+ *  see vsnprintf comment for details.
  *
  * The return value is the number of characters which would
  * be generated for the given input, excluding the trailing

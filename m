Return-Path: <linux-kernel-owner+w=401wt.eu-S1757637AbZDBXeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757637AbZDBXeL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 19:34:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765983AbZDBXdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 19:33:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56647 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765965AbZDBXdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 19:33:33 -0400
Date: Fri, 3 Apr 2009 01:33:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [GIT PULL] tracing bits for v2.6.30
Message-ID: <20090402233321.GA27734@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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

Please pull the latest tracing-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-for-linus

 ( If you pull it then please pull the printk tree first:

     git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git printk-for-linus

    The pull request for that was:

        http://marc.info/?l=linux-kernel&m=123828022817508&q=raw

     The tracing tree depends on the new printk facilities factored 
     out into the printk branch - but i did not merge back the 
     latest printk fixes back there to reduce criss-cross merging. )

The tree has the ugly criss-crossy merge structure you complained 
about before - i fixed my topic workload and the branch structure 
will look much nicer in the future.

Highlights:

 - New architectures:

   - IA64 ftrace support

 - New plugins:

   - kmemtrace to trace SLAB allocation/freeing and usage patterns

   - blktrace: new ftrace plugin, also ABI compatible with existing 
     relayfs + ioctl based blktrace user-space.

   - lock acquire/release tracing

   - workqueue tracer

 - Updated plugins:

   - enhanced function graph tracer: IRQ entry/exit augmentation, 
     lock acquire/release augmentation, support for regexp, and 
     more.

   - updated max-stack-footprint tracer

   - updated and performance-fixed sysprof plugin, updated userspace

   - updated mmiotrace plugin

   - enhanced hardware-driven branch execution tracing, 
     hw-branch-tracer

 - Tracing infrastructure updates:

   - add trace_printk() for general debugging, accessible generally
     via kernel.h.

   - regexp filter enhancements: module filters, inversion/negation  
     filter rules.

   - separate files for per cpu buffers in /debug/tracing/per_cpu/, 
     for high-speed streaming of tracing data

   - splice() zero-copy tracing support straight from the 
     ring-buffer to the target pipe

   - optionally record call-chain stack traces with events

   - event tracer with structured-logging format descriptors under 
     /debug/tracing/events/* and fast binary tracing records
     (no vsprintf overhead)

   - user-definable runtime filter expressions

   - all tracepoints in the kernel now show up in 
     /debug/tracing/events/ and can be toggled on/off individually 
     and filter expressions can be set.

   - function symbol driven 'trigger' regexp filters: tracing 
     start/stop events based on hitting a specific function or set 
     of functions. Trigger count-down support.

   - per function tracing attributes and trigger state

   - system-wide syscall (and parameters) tracing

   - IRQ/softirq tracepoints

   - ftrace= boot parameter to start tracing early

   - all trace options in separate symbolic files in 
     /debug/tracing/options/

   - improved statistics (in-kernel histogram) framework

Known risks:

 - The scheduler tracepoints were a bit more problematic than
   usual in this development cycle: deadlocks, crashes.

 - The blktrace plugin finalized a bit slower than expected. Most
   of the bugs were on the new ftrace plugin side.

 - It's a big tree with 500 commits. It's problem-free for me, but 
   these things are never problem-free for everyone.

 - No known regressions.

 Thanks,

	Ingo

------------------>
Ananth N Mavinakayanahalli (1):
      kprobes: Fix locking imbalance in kretprobes

Andrew Morton (2):
      kernel/trace/ring_buffer.c: reduce inlining
      kernel/trace/ring_buffer.c: use DIV_ROUND_UP

Anton Vorontsov (1):
      tracing: Fix TRACING_SUPPORT dependency for PPC32

Arnaldo Carvalho de Melo (20):
      ftrace: add ftrace_vprintk
      blktrace: add ftrace plugin
      tracing/blktrace: fix up checkpatch reported problems in ftrace plugin patch
      blktrace: the ftrace interface needs CONFIG_TRACING
      blktrace: Use tracing_reset_online_cpus
      trace: Use tracing_reset_online_cpus in more places
      trace_sched_wakeup: Remove unused variable
      trace: Change struct trace_event callbacks parameter list
      blkftrace: binary tracing, synthesizing old format
      blktrace: fix coding style in recent patches
      trace: judicious error checking of trace_seq results
      trace: make the trace_event callbacks return enum print_line_t
      trace: assign defaults at register_ftrace_event
      trace_branch: Remove unused function
      trace: Remove unused trace_array_cpu parameter
      ring_buffer: remove unused flags parameter
      tracing: Introduce trace_buffer_{lock_reserve,unlock_commit}
      trace: Call tracing_reset_online_cpus before tracer->init()
      tracing: handle unregistering the current tracer
      ring_buffer: pahole struct ring_buffer

Carsten Emde (1):
      tracing: fix command line to pid reverse map

Christoph Lameter (1):
      SLUB: Introduce and use SLUB_MAX_SIZE and SLUB_PAGE_SHIFT constants

Cyrill Gorcunov (1):
      x86: ftrace - simplify wait_for_nmi

David Rientjes (1):
      lockdep: remove duplicate CONFIG_DEBUG_LOCKDEP definitions

Dmitri Vorobiev (2):
      tracing, Text Edit Lock: Fix one sparse warning in kernel/extable.c
      tracing: fix four sparse warnings

Eduard - Gabriel Munteanu (14):
      SLUB: Replace __builtin_return_address(0) with _RET_IP_.
      kmemtrace: Core implementation.
      kmemtrace: Additional documentation.
      kmemtrace: SLAB hooks.
      kmemtrace: SLOB hooks.
      kmemtrace: SLUB hooks.
      kmemtrace: Fix typos in documentation.
      kmemtrace: Better alternative to "kmemtrace: fix printk format warnings".
      kmemtrace: SLUB hooks for caller-tracking functions.
      kmemtrace: Remove the relay version of kmemtrace
      tracing: splice support for tracing_pipe
      tracing: Move pipe waiting code out of tracing_read_pipe().
      tracing: provide trace_seq_reserve()
      tracing: add missing 'extern' keywords to trace_output.h

Frederic Weisbecker (55):
      tracing/function-graph-tracer: strip ending newlines on comments
      tracing/ftrace: provide the base infrastructure for histogram tracing
      tracing/branch-tracer: adapt to the stat tracing API
      tracing/kmemtrace: normalize the raw tracer event to the unified tracing API
      tracing/ftrace: fix a memory leak in stat tracing
      tracing/ftrace: handle more than one stat file per tracer
      tracing/ftrace: separate events tracing and stats tracing engine
      tracing: add a new workqueue tracer
      tracing/function-graph-tracer: fix a regression while suspend to disk
      tracing/function-graph-tracer: various fixes and features
      trace: better manage the context info for events
      tracing/blktrace: move the tracing file to kernel/trace
      tracing/function-graph-tracer: provide a selftest for the function graph tracer
      tracing/power: move the power trace headers to a dedicated file
      tracing/function-graph-tracer: drop the kernel_text_address check
      tracing/function-graph-tracer: handle the leaf functions from trace_pipe
      tracing/sysprof: add missing tracing_{start,stop}_record_cmdline()
      tracing/core: use appropriate waiting on trace_pipe
      tracing/core: remove unused parameter in tracing_fill_pipe_page()
      tracing/function-graph-tracer: fix traces weirdness while absolute time printing
      tracing/function-graph-tracer: provide documentation for the function graph tracer
      tracing/function-graph-tracer: make set_graph_function file support ftrace regex
      tracing/markers: make markers select tracepoints
      tracing/core: introduce per cpu tracing files
      tracing/core: make the read callbacks reentrants
      tracing/core: make the per cpu trace files in per cpu directories
      tracing/function-graph-tracer: use the more lightweight local clock
      vsprintf: unify the format decoding layer for its 3 users
      tracing/core: drop the old trace_printk() implementation in favour of trace_bprintk()
      vsprintf: fix bug in negative value printing
      tracing/core: bring back raw trace_printk for dynamic formats strings
      tracing/ftrace: syscall tracing infrastructure, basics
      tracing/x86: basic implementation of syscall tracing for x86
      tracing/syscalls: support for syscalls tracing on x86
      tracing/syscalls: core infrastructure for syscalls tracing, enhancements
      tracing/syscalls: fix missing release of tracing
      tracing/syscalls: various cleanups
      tracing/syscalls: protect thread flag toggling from races
      tracing/syscalls: select kallsysms
      tracing/core: fix missing mutex unlock on tracing_set_tracer()
      tracing/ftrace: fix double calls to tracing_start()
      tracing/core: fix early free of cpumasks
      tracing/ftrace: fix the check on nopped sites
      tracing/ftrace: stop {irqs, preempt}soff tracers when tracing is stopped
      tracing/ring-buffer: fix non cpu hotplug case
      tracing/ring-buffer: don't annotate rb_cpu_notify with __cpuinit
      tracing/function-graph-tracer: prevent hangs during self-tests
      tracing: keep the tracing buffer after self-test failure
      tracing/events: make the filter files writable
      tracing/events: don't use wake up for events
      tracing/ftrace: make nop-tracer use polling wait for events on pipe
      tracing/events: don't discard an event after commit
      debugfs: function to know if debugfs is initialized
      tracing/ftrace: check if debugfs is registered before creating files
      tracing/function-graph-tracer: fix functions call traces imbalance

Hannes Eder (3):
      tracing: fix sparse warnings: make symbols static
      tracing: fix sparse warnings: fix (un-)signedness
      tracing: fix sparse warning: attribute function with __acquires/__releases

Ingo Molnar (34):
      tracing/ftrace: make trace_find_cmdline() generally available
      tracing/selftest: remove TRACE_CONT reference
      kmemtrace: move #include lines
      relayfs: replace BUG() with WARN_ON() in relay_late_setup_files()
      tracing, kvm: change MARKERS to select instead of depends on
      tracing/kmemtrace: export kmemtrace_mark_alloc_node() / kmemtrace_mark_free()
      tracing/kmemtrace: fix typo
      kmemtrace: add kmemtrace_init()
      tracing: trace_stat.c cleanup
      printk: introduce printk_once()
      ring_buffer: remove unused flags parameter, fix
      tracing/blktrace: move the tracing file to kernel/trace, fix
      ftrace: fix !CONFIG_FTRACE [un_]register_ftrace_command() prototypes
      ftrace: fix !CONFIG_DYNAMIC_FTRACE ftrace_swapper_pid definition
      Documentation/ftrace.txt: update
      tracing/function-graph-tracer: fix merge
      tracing/hw-branch-tracing: convert bts-tracer mutex to a spinlock
      tracing: remove /debug/tracing/latency_trace
      sched: sched_clock() improvement: use in_nmi()
      tracing: implement trace_clock_*() APIs
      tracing: rename ftrace_printk() => trace_printk()
      tracing: move utility functions from ftrace.h to kernel.h
      tracing: clean up menu
      tracing, power-trace: make it build even if the power-tracer is turned off
      tracing: trace_bprintk() cleanups
      tracing: trace_printk() fix, move format array to data section
      tracing: optimize trace_printk()
      locking: rename trace_softirq_[enter|exit] => lockdep_softirq_[enter|exit]
      Merge branches 'tracing/ftrace' and 'linus' into tracing/core
      tracing/syscalls: support for syscalls tracing on x86, fix
      tracepoints: dont update zero-sized tracepoint sections
      tracing, Text Edit Lock - kprobes architecture independent support, nommu fix
      tracing: add run-time field descriptions for event filtering, kfree fix
      tracing, Text Edit Lock: cleanup

Jason Baron (4):
      tracing: convert c/p state power tracer to use tracepoints
      tracing, genirq: add irq enter and exit trace events
      tracing: tracepoints for softirq entry/exit - add softirq-to-name array
      tracing: tracepoints for softirq entry/exit - tracepoints

Jaswinder Singh Rajput (1):
      tracing: fix oops in tracepoint_update_probe_range()

Jody McIntyre (1):
      tracing: Documentation / sample code fixes for tracepoints

KOSAKI Motohiro (8):
      tracing: current tip/master can't enable ftrace
      tracing: fix deadlock when setting set_ftrace_pid
      ftrace: fix documentation typo s/trace_max_latency/tracing_max_latency/
      ftrace: tracing header should put '#' at the beginning of a line
      tracing: Don't use tracing_record_cmdline() in workqueue tracer
      doc: add trace_buf_size description to kernel-parameters.txt
      tracing: Don't assume possible cpu list have continuous numbers
      tracing: Don't use tracing_record_cmdline() in workqueue tracer fix

Lai Jiangshan (18):
      ring_buffer: reset write when reserve buffer fail
      ftrace: fix trace_output
      trace_workqueue: use percpu data for workqueue stat
      ring_buffer: fix typing mistake
      ring_buffer: fix ring_buffer_read_page()
      vsprintf: add binary printf
      tracing: infrastructure for supporting binary record
      tracing: add trace_bprintk()
      ftrace: use seq_read
      ftrace: remove struct list_head from struct dyn_ftrace
      kallsyms, tracing: output more proper symbol name
      ftrace: protect running nmi (V3)
      ftrace: show virtual PID
      tracing: use union for multi-usages field
      trace_stat: don't call seq_printf() in seq_operation->start()
      trace_stat: keep original order
      trace_workqueues: fix empty line's output
      init,cpuset: fix initialize order

Li Zefan (22):
      tracing/ftrace: add missing unlock in register_stat_tracer()
      blktrace: fix possible memory leak
      blktrace: make blk_tracer_enabled a bool flag
      blktrace: remove blk_probe_mutex
      blktrace: don't increase blk_probes_ref if failed to setup blk trace
      blktrace: report EBUSY correctly
      blktrace: remove sysfs_blk_trace_enable_show/store()
      blktrace: avoid accessing NULL bdev->bd_disk
      blktrace: mark ddir_act[] const
      blktrace: fix wrong calculation of RWBS
      blktrace: fix t_error()
      blktrace: print human-readable act_mask
      blktrace: fix timestamp in binary output
      blktrace: fix a race when creating blk_tree_root in debugfs
      blktrace: fix the original blktrace
      blktrace: fix off-by-one bug
      blktrace: make classic output more classic
      blktrace: fix blk_probes_ref chaos
      blktrace: fix memory leak when freeing struct blk_io_trace
      blktrace: extract duplidate code
      blktrace: print out BLK_TN_MESSAGE properly
      trace: make argument 'mem' of trace_seq_putmem() const

Markus Metzger (8):
      x86, ftrace, hw-branch-tracer: support hotplug cpus
      x86, ftrace, hw-branch-tracer: dump trace on oops
      x86, ftrace, hw-branch-tracer: reset trace buffer on close
      x86, ftrace, hw-branch-tracer: change trace format
      x86, ftrace, hw-branch-tracer: documentation
      x86, ds, bts: cleanup DS configuration
      x86, ftrace: fix section mismatch in hw-branch-tracer
      x86, ptrace: remove CONFIG guards around declarations

Masami Hiramatsu (4):
      tracing, Text Edit Lock - SMP alternatives support
      x86: implement atomic text_poke() via fixmap
      x86: expand irq-off region in text_poke()
      x86: kretprobe-booster interrupt emulation code fix

Mathieu Desnoyers (2):
      tracing, Text Edit Lock - Architecture Independent Code
      tracing, Text Edit Lock - kprobes architecture independent support

Pekka Enberg (3):
      kmemtrace: remove unnecessary casts
      kmemtrace: allow kmemtrace to be enabled after boot
      kmemtrace: remove config option for enabling tracing at boot

Pekka Paalanen (3):
      doc: mmiotrace.txt, buffer size control change
      trace: mmiotrace to the tracer menu in Kconfig
      mmiotrace: count events lost due to not recording

Peter Zijlstra (8):
      lockdep: fix incorrect state name
      lockdep: remove extra "irq" string
      lockdep: require framepointers for x86
      tracing: add lockdep tracepoints for lock acquire/release
      trace_clock: fix preemption bug
      ftrace: provide an id file for each event
      ftrace: ensure every event gets an id
      ftrace: event profile hooks

Rakib Mullick (1):
      tracing: fix section mismatch in trace_hw_branches.c

Randy Dunlap (3):
      sysrq: fix ftrace help msg & doc.
      kmemtrace: fix printk format warnings
      kmemtrace: fix printk formats, fix

Shaohua Li (6):
      ftrace, ia64: make recordmcount distinct module compile
      ftrace, ia64: explictly ignore a file in recordmcount.pl
      ftrace, ia64: Add macro for ftrace_caller
      ftrace, ia64: Add recordmcount for ia64
      ftrace, ia64: IA64 static ftrace support
      ftrace, ia64: IA64 dynamic ftrace support

Stephen Rothwell (2):
      tracing, powerpc: fix powerpc tree and tracing tree interaction
      tracing, net: fix net tree and tracing tree merge interaction

Steven Rostedt (161):
      ftrace: remove obsolete print continue functionality
      ftrace: set up trace event hash infrastructure
      ftrace: change trace.c to use registered events
      ftrace: convert unsigned index to signed
      trace: clean up funny line breaks in stat_seq_show
      trace: print ftrace_dump at KERN_EMERG log level
      trace: stop all recording to ring buffer on ftrace_dump
      ftrace: add stack trace to function tracer
      ftrace: move function tracer functions out of trace.c
      trace: add gcc printf check to trace_seq_printf
      trace: clean up format errors in calls to trace_seq_printf
      ftrace: combine stack trace in function call
      ftrace: remove static from function tracer functions
      trace: set max latency variable to zero on default
      ftrace: test for running of recordmcount.pl twice on an object
      trace: do not disable wake up tracer on output of trace
      ring-buffer: do not swap if recording is disabled
      trace: separate out rt tasks from wakeup tracer
      wakeup-tracer: show scheduling data in output
      ring-buffer: reset timestamps when ring buffer is reset
      trace: remove internal irqsoff disabling for trace output
      trace: fix logic to start/stop counting
      trace, lockdep: manual preempt count adding for local_bh_disable
      trace: fix default boot up tracer
      trace: let boot trace be chosen by command line
      trace: code style clean up
      trace: remove deprecated entry->cpu
      ring-buffer: add NMI protection for spinlocks
      ring-buffer: allow tracing_off to be used in core kernel code
      ftrace, x86: rename in_nmi variable
      nmi: add generic nmi tracking state
      ftrace: change function graph tracer to use new in_nmi
      ring-buffer: use generic version of in_nmi
      tracing: clean up splice code
      tracing, x86: fix constraint for parent variable
      preempt-count: force hardirq-count to max of 10
      ring-buffer: rename label out_unlock to out_reset
      sched: do not account for NMIs
      ftrace: state that all functions are enabled in set_ftrace_filter
      ftrace: add do_for_each_ftrace_rec and while_for_each_ftrace_rec
      ftrace: rename ftrace_match to ftrace_match_records
      ftrace: break up ftrace_match_records into smaller components
      ftrace: add module command function filter selection
      ftrace: enable filtering only when a function is filtered on
      ftrace: add command interface for function selection
      ftrace: convert ftrace_lock from a spinlock to mutex
      ftrace: consolidate mutexes
      ftrace: trace different functions with a different tracer
      ring-buffer: add tracing_is_on to test if ring buffer is enabled
      ftrace: add traceon traceoff commands to enable/disable the buffers
      ftrace: show selected functions in set_ftrace_filter
      ftrace: add pretty print to selected fuction traces
      ftrace: add pretty print function for traceon and traceoff hooks
      ftrace: clean up coding style
      ftrace: rename _hook to _probe
      ftrace: show unlimited when traceon or traceoff has no counter
      ftrace: allow archs to preform pre and post process for code modification
      ftrace, x86: make kernel text writable only for conversions
      ftrace: immediately stop code modification if failure is detected
      ftrace: break out modify loop immediately on detection of error
      tracing: add DEFINE_TRACE_FMT to tracepoint.h
      tracing: add event trace infrastructure
      tracing: add schedule events to event trace
      tracing: make event directory structure
      tracing: rename DEFINE_TRACE_FMT to just TRACE_FORMAT
      tracing: wrap arguments with PARAMS
      tracing: add options directory and core option files
      tracing: add tracer dependent options to options directory
      tracing: add protection around open use of current_tracer
      tracing: use pointer error returns for __tracing_open
      tracing: use newline separator for trace options list
      tracing: replace kzalloc with kcalloc
      tracing: move trace point formats to files in include/trace directory
      tracing: add subsystem level to trace events
      tracing: make the set_event and available_events subsystem aware
      tracing: add subsystem irq for irq events
      tracing: add subsystem sched for sched events
      tracing: add interface to write into current tracer buffer
      tracing: add raw trace point recording infrastructure
      tracing: add raw fast tracing interface for trace events
      tracing: create the C style tracing for the sched subsystem
      tracing: create the C style tracing for the irq subsystem
      tracing: add TRACE_FIELD_SPECIAL to record complex entries
      tracing: add protection around modify trace event fields
      tracing: make trace_seq_reset global and rename to trace_seq_init
      tracing: add format file to describe event struct fields
      tracing: add ftrace headers to event format files
      tracing: add trace name and id to event formats
      tracing: add print format to event trace format files
      tracing: fix return value to registering events
      ring-buffer: reset write field for ring_buffer_read_page
      ring-buffer: fix ring_buffer_read_page
      ring-buffer: replace sizeof of event header with offsetof
      ring-buffer: make ring_buffer_read_page read from start on partial page
      tracing: add binary buffer files for use with splice
      tracing: add cpu_file intialization for ftrace_dump
      ring-buffer: fix timestamp in partial ring_buffer_page_read
      tracing: do not return EFAULT if read copied anything
      tracing: fix seq read from trace files
      tracing: add latency output format option
      tracing: remove extra latency_trace method from trace structure
      tracing: consolidate print_lat_fmt and print_trace_fmt
      tracing: have latency tracers set the latency format
      tracing: add tracing_on/tracing_off to kernel.h
      tracing: make all file_operations const
      tracing: move print of event format to separate file
      tracing: add format files for ftrace default entries
      tracing: typecast sizeof and offsetof to unsigned int
      tracing: replace TP<var> with TP_<var>
      tracing: use generic __stringify
      tracing: new format for specialized trace points
      tracing: convert the sched trace points to the TRACE_EVENT macros
      tracing: convert irq trace points to new macros
      tracing: remove obsolete TRACE_EVENT_FORMAT macro
      tracing: fix printk format specifier
      tracing: do not allow modifying the ftrace events via the event files
      tracing: add back the available_events file
      tracing: flip the TP_printk and TP_fast_assign in the TRACE_EVENT macro
      tracing: document TRACE_EVENT macro in tracepoint.h
      tracing: update comments to match event code macros
      tracing: remove funky whitespace in the trace code
      tracing: use raw spinlocks for trace_vprintk
      tracing: keep ring buffer to minimum size till used
      tracing: expand the ring buffers when an event is activated
      tracing: fix trace_wait to know to wait on all cpus or just one
      ring-buffer: only allocate buffers for online cpus
      tracing: fix comments about trace buffer resizing
      tracing: protect ring_buffer_expanded with trace_types_lock
      ring-buffer: use CONFIG_HOTPLUG_CPU not CONFIG_HOTPLUG
      ring-buffer: remove unneeded get_online_cpus
      tracing: show that buffer size is not expanded
      tracing: make bprint event use the proper event id
      tracing: have event_trace_printk use static tracer
      tracing: export trace formats to user space
      tracing: fix stack tracer header
      tracing: explain why stack tracer is empty
      tracing: show event name in trace for TRACE_EVENT created events
      ring-buffer: document reader page design
      tracing: left align location header in stack_trace
      tracing: add comment for use of double __builtin_consant_p
      tracing: move binary buffers into per cpu directory
      softirq: no need to have SOFTIRQ in softirq name
      tracing: protect reader of cmdline output
      tracing: stop comm recording on tracing off
      ring-buffer: add api to allow a tracer to change clock source
      tracing: add global-clock option to provide cross CPU clock to traces
      tracing: make sched_switch stop/start light weight
      tracing: make power tracer start/stop methods lighter weight
      tracing: give easy way to clear trace buffer
      function-graph: consolidate prologues for output
      tracing: make print_(b)printk_msg_only global
      function-graph: calculate function depth within function graph tracer
      tracing: remove recording function depth from trace_printk
      function-graph: show binary events as comments
      tracing: fix memory leak in trace_stat
      function-graph: moved the timestamp from arch to generic code
      function-graph: prevent more than one tracer registering
      function-graph: ignore times across schedule
      function-graph: add option for include sleep times
      function-graph: allow unregistering twice
      ring-buffer: do not remove reader page from list on ring buffer free

Thomas Gleixner (3):
      tracing: stop command line recording when tracing is disabled
      tracing: replace the crude (unsigned) -1 hackery
      tracing: fix trace_find_cmdline()

Tobias Klauser (1):
      tracing: storage class should be before const qualifier

Tom Zanussi (13):
      tracing: fix leak in event_format_read()
      tracing: add run-time field descriptions for event filtering
      tracing: add ring_buffer_event_discard() to ring buffer
      tracing: add per-event filtering
      tracing: add per-subsystem filtering
      tracing/filters: use list_for_each_entry_safe
      tracing/filters: fix bug in copy_pred()
      tracing/filters: clean up filter_add_subsystem_pred()
      tracing/filters: use list_for_each_entry
      tracing/filters: free pred when clearing filters
      tracing/filters: use trace_seq_printf() to print filters
      tracing/filters: disallow integer values for string filters and vice versa
      tracing: filter fix for TRACE_EVENT_FORMAT events

Uwe Kleine-Koenig (2):
      ftrace, trivial: fix typo "resgister" -> "register"
      tracing: make CALLER_ADDRx overwriteable

Vegard Nossum (1):
      kmemtrace: add missing newline

Wenji Huang (7):
      trace: trivial fixes in comment typos.
      tracing: remove unneeded variable
      tracing: provide correct return value after outputting the event
      tracing: fix typos in comments
      tracing: use the more proper parameter
      tracing: fix the return value of trace selftest
      tracing: fix typing mistake in hint message and comments

Witold Baryluk (1):
      tracing: optimization of branch tracer

Zhaolei (3):
      ftrace: avoid double-free of dyn_ftrace
      ftrace: don't try to __ftrace_replace_code on !FTRACE_FL_CONVERTED rec
      ftrace: Using FTRACE_WARN_ON() to check "freed record" in ftrace_release()


 Documentation/ABI/testing/debugfs-kmemtrace |   71 +
 Documentation/ftrace.txt                    | 1134 +++++++----
 Documentation/kernel-parameters.txt         |   12 +
 Documentation/sysrq.txt                     |    2 +
 Documentation/tracepoints.txt               |   21 +-
 Documentation/vm/kmemtrace.txt              |  126 ++
 MAINTAINERS                                 |    6 +
 arch/Kconfig                                |    1 +
 arch/alpha/include/asm/ftrace.h             |    1 +
 arch/alpha/include/asm/hardirq.h            |   13 -
 arch/avr32/include/asm/ftrace.h             |    1 +
 arch/avr32/include/asm/hardirq.h            |   11 -
 arch/blackfin/include/asm/ftrace.h          |    1 +
 arch/cris/include/asm/ftrace.h              |    1 +
 arch/h8300/include/asm/ftrace.h             |    1 +
 arch/ia64/Kconfig                           |    3 +
 arch/ia64/include/asm/ftrace.h              |   28 +
 arch/ia64/include/asm/hardirq.h             |   10 -
 arch/ia64/kernel/Makefile                   |    5 +
 arch/ia64/kernel/entry.S                    |  100 +
 arch/ia64/kernel/ftrace.c                   |  206 ++
 arch/ia64/kernel/ia64_ksyms.c               |    6 +
 arch/m68k/include/asm/ftrace.h              |    1 +
 arch/mips/include/asm/ftrace.h              |    1 +
 arch/parisc/include/asm/ftrace.h            |    1 +
 arch/powerpc/kernel/ftrace.c                |    6 +-
 arch/um/include/asm/ftrace.h                |    1 +
 arch/x86/Kconfig                            |    2 +
 arch/x86/include/asm/cacheflush.h           |    5 +
 arch/x86/include/asm/fixmap.h               |    2 +
 arch/x86/include/asm/ftrace.h               |    7 +
 arch/x86/include/asm/ptrace-abi.h           |    3 -
 arch/x86/include/asm/thread_info.h          |    9 +-
 arch/x86/kernel/Makefile                    |    3 +-
 arch/x86/kernel/alternative.c               |   29 +-
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c  |    4 +-
 arch/x86/kernel/dumpstack.c                 |    6 +
 arch/x86/kernel/ftrace.c                    |  192 ++-
 arch/x86/kernel/kprobes.c                   |   17 +-
 arch/x86/kernel/process.c                   |    5 +-
 arch/x86/kernel/ptrace.c                    |    7 +
 arch/x86/kvm/Kconfig                        |    3 +-
 arch/x86/mm/init_32.c                       |   35 +-
 arch/x86/mm/init_64.c                       |   37 +-
 arch/xtensa/include/asm/ftrace.h            |    1 +
 block/Kconfig                               |   16 -
 block/Makefile                              |    1 -
 block/blktrace.c                            |  860 --------
 drivers/char/sysrq.c                        |    2 +-
 drivers/oprofile/cpu_buffer.c               |    5 +-
 fs/debugfs/inode.c                          |   16 +
 fs/partitions/check.c                       |    4 +
 include/asm-frv/ftrace.h                    |    1 +
 include/asm-generic/vmlinux.lds.h           |   29 +-
 include/asm-m32r/ftrace.h                   |    1 +
 include/asm-mn10300/ftrace.h                |    1 +
 include/linux/blktrace_api.h                |    5 +
 include/linux/compiler.h                    |    6 +-
 include/linux/debugfs.h                     |    8 +
 include/linux/ftrace.h                      |  244 ++-
 include/linux/ftrace_irq.h                  |    2 +-
 include/linux/hardirq.h                     |   73 +-
 include/linux/interrupt.h                   |    5 +
 include/linux/irqflags.h                    |    8 +-
 include/linux/kernel.h                      |  150 ++
 include/linux/memory.h                      |    6 +
 include/linux/module.h                      |    5 +
 include/linux/ring_buffer.h                 |   38 +-
 include/linux/sched.h                       |    4 +
 include/linux/slab_def.h                    |   68 +-
 include/linux/slob_def.h                    |    9 +-
 include/linux/slub_def.h                    |   53 +-
 include/linux/string.h                      |    7 +
 include/linux/syscalls.h                    |   60 +-
 include/linux/trace_clock.h                 |   19 +
 include/linux/tracepoint.h                  |  116 +-
 include/trace/block.h                       |   70 +-
 include/trace/irq.h                         |    9 +
 include/trace/irq_event_types.h             |   55 +
 include/trace/kmemtrace.h                   |   75 +
 include/trace/lockdep.h                     |    9 +
 include/trace/lockdep_event_types.h         |   44 +
 include/trace/power.h                       |   32 +
 include/trace/sched.h                       |   49 +-
 include/trace/sched_event_types.h           |  337 +++
 include/trace/skb.h                         |    4 +-
 include/trace/trace_event_types.h           |    5 +
 include/trace/trace_events.h                |    5 +
 include/trace/workqueue.h                   |   25 +
 init/Kconfig                                |    2 +-
 init/main.c                                 |    5 +-
 kernel/extable.c                            |   19 +-
 kernel/irq/handle.c                         |    6 +
 kernel/kprobes.c                            |   19 +-
 kernel/lockdep.c                            |   33 +-
 kernel/module.c                             |    2 +-
 kernel/relay.c                              |    4 +-
 kernel/sched.c                              |    8 +-
 kernel/sched_clock.c                        |   12 +
 kernel/softirq.c                            |   32 +-
 kernel/trace/Kconfig                        |  123 +-
 kernel/trace/Makefile                       |   13 +
 kernel/trace/blktrace.c                     | 1549 ++++++++++++++
 kernel/trace/events.c                       |   14 +
 kernel/trace/ftrace.c                       | 1133 ++++++++---
 kernel/trace/kmemtrace.c                    |  339 +++
 kernel/trace/ring_buffer.c                  |  693 +++++--
 kernel/trace/trace.c                        | 3034 +++++++++++++++------------
 kernel/trace/trace.h                        |  315 +++-
 kernel/trace/trace_boot.c                   |   36 +-
 kernel/trace/trace_branch.c                 |  278 ++--
 kernel/trace/trace_clock.c                  |  109 +
 kernel/trace/trace_event_profile.c          |   31 +
 kernel/trace/trace_event_types.h            |  173 ++
 kernel/trace/trace_events.c                 |  824 ++++++++
 kernel/trace/trace_events_filter.c          |  427 ++++
 kernel/trace/trace_events_stage_1.h         |   39 +
 kernel/trace/trace_events_stage_2.h         |  176 ++
 kernel/trace/trace_events_stage_3.h         |  281 +++
 kernel/trace/trace_export.c                 |  102 +
 kernel/trace/trace_functions.c              |  369 ++++-
 kernel/trace/trace_functions_graph.c        |  570 ++++--
 kernel/trace/trace_hw_branches.c            |  185 ++-
 kernel/trace/trace_irqsoff.c                |   54 +-
 kernel/trace/trace_mmiotrace.c              |   45 +-
 kernel/trace/trace_nop.c                    |    6 +-
 kernel/trace/trace_output.c                 | 1017 +++++++++
 kernel/trace/trace_output.h                 |   71 +
 kernel/trace/trace_power.c                  |  194 +-
 kernel/trace/trace_printk.c                 |  270 +++
 kernel/trace/trace_sched_switch.c           |   24 +-
 kernel/trace/trace_sched_wakeup.c           |   96 +-
 kernel/trace/trace_selftest.c               |  169 ++-
 kernel/trace/trace_stack.c                  |   19 +-
 kernel/trace/trace_stat.c                   |  326 +++
 kernel/trace/trace_stat.h                   |   31 +
 kernel/trace/trace_syscalls.c               |  250 +++
 kernel/trace/trace_sysprof.c                |   23 +-
 kernel/trace/trace_workqueue.c              |  288 +++
 kernel/tracepoint.c                         |    7 +-
 kernel/workqueue.c                          |   16 +-
 lib/Kconfig                                 |    3 +
 lib/locking-selftest.c                      |    4 +-
 lib/vsprintf.c                              | 1005 +++++++--
 mm/slab.c                                   |   71 +-
 mm/slob.c                                   |   35 +-
 mm/slub.c                                   |   83 +-
 samples/tracepoints/tp-samples-trace.h      |    8 +-
 samples/tracepoints/tracepoint-sample.c     |   24 +-
 scripts/Makefile.build                      |   13 +-
 scripts/kallsyms.c                          |   57 +
 scripts/recordmcount.pl                     |   37 +-
 152 files changed, 15404 insertions(+), 4475 deletions(-)
 create mode 100644 Documentation/ABI/testing/debugfs-kmemtrace
 create mode 100644 Documentation/vm/kmemtrace.txt
 create mode 100644 arch/alpha/include/asm/ftrace.h
 create mode 100644 arch/avr32/include/asm/ftrace.h
 create mode 100644 arch/blackfin/include/asm/ftrace.h
 create mode 100644 arch/cris/include/asm/ftrace.h
 create mode 100644 arch/h8300/include/asm/ftrace.h
 create mode 100644 arch/ia64/include/asm/ftrace.h
 create mode 100644 arch/ia64/kernel/ftrace.c
 create mode 100644 arch/m68k/include/asm/ftrace.h
 create mode 100644 arch/mips/include/asm/ftrace.h
 create mode 100644 arch/parisc/include/asm/ftrace.h
 create mode 100644 arch/um/include/asm/ftrace.h
 create mode 100644 arch/xtensa/include/asm/ftrace.h
 delete mode 100644 block/blktrace.c
 create mode 100644 include/asm-frv/ftrace.h
 create mode 100644 include/asm-m32r/ftrace.h
 create mode 100644 include/asm-mn10300/ftrace.h
 create mode 100644 include/linux/trace_clock.h
 create mode 100644 include/trace/irq.h
 create mode 100644 include/trace/irq_event_types.h
 create mode 100644 include/trace/kmemtrace.h
 create mode 100644 include/trace/lockdep.h
 create mode 100644 include/trace/lockdep_event_types.h
 create mode 100644 include/trace/power.h
 create mode 100644 include/trace/sched_event_types.h
 create mode 100644 include/trace/trace_event_types.h
 create mode 100644 include/trace/trace_events.h
 create mode 100644 include/trace/workqueue.h
 create mode 100644 kernel/trace/blktrace.c
 create mode 100644 kernel/trace/events.c
 create mode 100644 kernel/trace/kmemtrace.c
 create mode 100644 kernel/trace/trace_clock.c
 create mode 100644 kernel/trace/trace_event_profile.c
 create mode 100644 kernel/trace/trace_event_types.h
 create mode 100644 kernel/trace/trace_events.c
 create mode 100644 kernel/trace/trace_events_filter.c
 create mode 100644 kernel/trace/trace_events_stage_1.h
 create mode 100644 kernel/trace/trace_events_stage_2.h
 create mode 100644 kernel/trace/trace_events_stage_3.h
 create mode 100644 kernel/trace/trace_export.c
 create mode 100644 kernel/trace/trace_output.c
 create mode 100644 kernel/trace/trace_output.h
 create mode 100644 kernel/trace/trace_printk.c
 create mode 100644 kernel/trace/trace_stat.c
 create mode 100644 kernel/trace/trace_stat.h
 create mode 100644 kernel/trace/trace_syscalls.c
 create mode 100644 kernel/trace/trace_workqueue.c

[ full diff omitted due to lkml message size limit. ]


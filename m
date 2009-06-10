Return-Path: <linux-kernel-owner+w=401wt.eu-S1759145AbZFJWvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759145AbZFJWvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 18:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756896AbZFJWvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 18:51:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34867 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756904AbZFJWux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 18:50:53 -0400
Date: Thu, 11 Jun 2009 00:50:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: [GIT PULL] Tracing updates for v2.6.31
Message-ID: <20090610225005.GA25583@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -0.4
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.4 required=5.9 tests=BAYES_00,FR_3TAG_3TAG autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	1.1 FR_3TAG_3TAG           RAW: Looks like 3 <e> small tags.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest tracing-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-for-linus

This tree underwent a workflow change since the last cycle - instead 
of a criss-cross daily merge cycle with lots of merge commit we 
transitioned to a fast-forward mostly-linear tree structure. We also 
reduced the number of merges drastically via various measures: from 
15% down to ~4%.

Hopefully this new tree structure looks nicer than the .30-rc1 one - 
with the same good quality.

There's still a lot of tracing changes - with hopefully the last and 
near-final tracepoint version. Better runtime filters, continued 
conversions to generic event-tracepoints (which show up all at once, 
instead of being tied to splintered specialistic plugins), 
performance optimizations and much more.

Note: in 'make oldconfig' there's a new menu that shows up by 
default if KERNEL_DEBUGGING is enabled - but no new options are 
selected by default.

 Thanks,

	Ingo

------------------>
Alan D. Brunelle (2):
      blktrace: correct remap names
      blktrace: from-sector redundant in trace_block_remap

Avadh Patel (1):
      tracing: add saved_cmdlines file to show cached task comms

Chris Wright (1):
      x86: use native register access for native tlb flushing

Christoph Hellwig (1):
      tracing: small trave_events sample Makefile cleanup

Frederic Weisbecker (12):
      tracing/ftrace: factorize the tracing files creation
      tracing/lockdep: report the time waited for a lock
      tracing/core: Add current context on tracing recursion warning
      tracing/ring-buffer: Add unlock recursion protection on discard
      tracing/events: provide string with undefined size support
      tracing/lock: provide lock_acquired event support for dynamic size string
      tracing/events: protect __get_str()
      tracing/filters: support for filters of dynamic sized arrays
      tracing/filters: support for operator reserved characters in strings
      tracing/stat: replace trace_stat_session by stat_session
      tracing/stat: replace linked list by an rbtree for sorting
      tracing/stat: remove unappropriate safe walk on list

Heiko Carstens (2):
      tracing: fix build failure on s390
      trace: disable preemption before taking raw spinlocks

Ingo Molnar (6):
      x86, bts: cleanups
      x86, bts: detect size of DS fields, fix
      mm, x86, ptrace, bts: defer branch trace stopping, cleanup
      mm, x86, ptrace, bts: defer branch trace stopping, remove dead code
      tracing: make the trace clocks available generally
      Revert "x86, bts: reenable ptrace branch trace support"

Jason Baron (3):
      kerneldoc, tracing: make kernel-doc understand TRACE_EVENT() macro (take #2)
      tracing: add new tracepoints docbook
      tracing: add irq tracepoint documentation

Jaswinder Singh Rajput (1):
      tracing: trace_output.c, fix false positive compiler warning

Jeremy Fitzhardinge (1):
      tracing: avoid warnings from zero-arg tracepoints

Lai Jiangshan (2):
      ring_buffer: compressed event header
      tracing: add trace_event_read_lock()

Li Zefan (31):
      tracing: use macros to denote usec and nsec per second
      blktrace: fix output of unknown events
      blktrace: fix output of BLK_TC_PC events
      blktrace: support per-partition tracing for ftrace plugin
      blktrace: add trace/ to /sys/block/sda
      blktrace: fix context-info when mixed-using blk tracer and trace events
      tracing: fix file mode of trace and README
      tracing/filters: don't remove old filters when failed to write subsys->filter
      tracing/filters: allow user-input to be integer-like string
      tracing/events: make struct trace_entry->type to be int type
      tracing/events: don't say hi when loading the trace event sample
      tracing/events: make SAMPLE_TRACE_EVENTS default to n
      tracing/events: fix memory leak when unloading module
      tracing/events: fix concurrent access to ftrace_events list
      tracing/events: fix concurrent access to ftrace_events list, fix
      tracing/events: clean up for ftrace_set_clr_event()
      tracing/events: simplify system_enable_read()
      blktrace: pdu_buf of pc events should be unsigned
      blktrace: from-sector redundant in trace_block_remap, cleanup
      tracing/filters: add missing unlock in a failure path
      tracing/filters: fix off-by-one bug
      tracing/events: Documentation updates
      tracing/events: change the type of __str_loc_item to unsigned short
      tracing/stat: change dummpy_cmp() to return -1
      tracing/stat: remember to free root node
      tracing/stat: do some cleanups
      tracing/events: fix a typo in __string() format output
      tracing/events: put TP_fast_assign into braces
      tracing/events: introduce __dynamic_array()
      tracing/events: convert block trace points to TRACE_EVENT()
      tracing/events: convert block trace points to TRACE_EVENT(), fix !CONFIG_BLOCK

Markus Metzger (29):
      x86, bts: detect size of DS fields
      x86, bts: add selftest for BTS
      x86, bts: correct comment style in ds.c
      x86, hw-branch-tracer: keep resources on stop
      x86, hw-branch-tracer: add selftest
      x86, bts: use atomic memory allocation
      x86, bts: fix race when bts tracer is removed
      sched, hw-branch-tracer: add wait_task_context_switch() function to sched.h
      mm, x86, ptrace, bts: defer branch trace stopping
      x86, bts: wait until traced task has been scheduled out
      x86, bts: fix race between per-task and per-cpu branch tracing
      x86, bts: use trace_clock_global() for timestamps
      x86, debugctlmsr: add _on_cpu variants to debugctlmsr functions
      x86, bts, hw-branch-tracer: add _noirq variants to the debug store interface
      x86, hw-branch-tracer: allocate selftest iterator on heap
      x86, ds: fix compiler warning
      x86, ds: fix bounds check in ds selftest
      x86, ds: selftest each cpu
      x86, ds: add task tracing selftest
      x86, ds: add leakage warning
      x86, ds: use single debug store cpu configuration
      x86, ptrace: add bts context unconditionally
      x86, ds: dont use TIF_DEBUGCTLMSR
      x86, ds: fix bad ds_reset_pebs()
      x86, ds: allow small debug store buffers
      x86, ds: support Core i7
      x86, ds: fix buffer alignment in debug store selftest
      x86, bts: reenable ptrace branch trace support
      x86, bts, mm: clean up buffer allocation

Mathieu Desnoyers (1):
      tracepoint: trace_sched_migrate_task(): remove parameter

Mike Frysinger (1):
      ftrace/documentation: fix typo in function grapher name

Ming Lei (2):
      tracing: fix check for return value of register_module_notifier
      ftrace: fix check for return value of register_module_notifier in event_trace_init

Pekka Enberg (1):
      kmemtrace: fix kernel parameter documentation

Peter Zijlstra (1):
      ring-buffer: pass in lockdep class key for reader_lock

Shawn Du (1):
      blktrace: support per-partition tracing

Stefan Raspl (1):
      blktrace: remove debugfs entries on bad path

Steven Rostedt (111):
      tracing: add handler to trace_stat
      tracing: add function profiler
      tracing: move function profiler data out of function struct
      tracing: adding function timings to function profiler
      tracing: make the function profiler per cpu
      function-graph: add option to calculate graph time or not
      tracing: clean up tracing profiler
      tracing: remove on the fly allocator from function profiler
      tracing: add average time in function to function profiler
      function-graph: use int instead of atomic for ftrace_graph_active
      x86, function-graph: only save return values on x86_64
      ring-buffer: add ring_buffer_discard_commit
      tracing/filters: use ring_buffer_discard_commit for discarded events
      tracing: consolidate trace and trace_event headers
      tracing: create automated trace defines
      tracing: make trace_seq operations available for core kernel
      tracing/events: move declarations from trace directory to core include
      tracing/events: move the ftrace event tracing code to core
      tracing/events: convert event call sites to use a link list
      tracing/events: add export symbols for trace events in modules
      tracing/events: add support for modules to TRACE_EVENT
      tracing/events: fix compile for modules disabled
      tracing/events: fix lockdep system name
      tracing/events: move trace point headers into include/trace/events
      tracing/events: add trace-events-sample
      ftrace: use module notifier for function tracer
      tracing/events: add startup tests for events
      tracing/events/ring-buffer: expose format of ring buffer headers to users
      tracing/events: perform function tracing in event selftests
      tracing/events: enable code with EVENT_TRACING not EVENT_TRACER
      tracing: add EXPORT_SYMBOL_GPL for trace commits
      tracing: add same level recursion detection
      tracing: protect trace_printk from recursion
      tracing: remove format attribute of inline function
      tracing: change branch profiling to a choice selection
      tracing: create menuconfig for tracing infrastructure
      tracing: rename EVENT_TRACER config to ENABLE_EVENT_TRACING
      tracing/events: call the correct event trace selftest init function
      tracing: remove dangling semicolon
      tracing: fix recursive test level calculation
      tracing: remove recursive test from ring_buffer_event_discard
      tracing: use recursive counter over irq level
      tracing: use nowakeup version of commit for function event trace tests
      ring-buffer: only warn on wrap if buffer is bigger than two pages
      tracing/wakeup: move access to wakeup_cpu into spinlock
      tracing: increase size of number of possible events
      tracing: add size checks for exported ftrace internal structures
      tracing: fix cut and paste macro error
      tracing/lockdep: convert lockdep to use TRACE_EVENT macro
      tracing/irq: convert irq traces to use TRACE_EVENT macro
      tracing: remove deprecated TRACE_FORMAT
      tracing/events: reuse trace event ids after overflow
      tracing/events: make modules have their own file_operations structure
      tracing: convert ftrace_dump spinlocks to raw
      tracing: fix ref count in splice pages
      tracing: only add splice page if entries exist
      tracing: have splice only copy full pages
      ring-buffer: fix printk output
      ring-buffer: export symbols
      ring-buffer: add counters for commit overrun and nmi dropped entries
      tracing: export stats of ring buffers to userspace
      ring-buffer: convert cpu buffer entries to local_t
      ring-buffer: record page entries in buffer page descriptor
      ring-buffer: have read page swap increment counter with page entries
      ring-buffer: disable writers when resetting buffers
      tracing: use proper export symbol for tracing api
      ring-buffer: move big if statement down
      ring-buffer: add benchmark and tester
      ring-buffer: remove unneeded conditional in rb_reserve_next
      ring-buffer: check for failed allocation in ring buffer benchmark
      ring-buffer: make moving the tail page a separate function
      ring-buffer: change test to be more latency friendly
      tracing: update sample with TRACE_INCLUDE_FILE
      tracing: reset ring buffer when removing modules with events
      tracing: add hierarchical enabling of events
      ring-buffer: remove complex calculations in ring-buffer-test
      tracing: append ":*" to internal setting of system events
      tracing: have menu default enabled when kernel debug is configured
      ring-buffer: only periodically call cond_resched to ring-buffer-benchmark
      ring-buffer: add total count in ring-buffer-benchmark
      ring-buffer: change WARN_ON from checking preempt_count to preemptible
      tracing: initialize return value for __ftrace_set_clr_event
      tracing: add trace_set_clr_event to export event enabling function
      ring-buffer: replace constants with time macros in ring-buffer-benchmark
      ring-buffer: check for divide by zero in ring-buffer-benchmark
      ring-buffer: remove type parameter from rb_reserve_next_event
      ring-buffer: move calculation of event length
      ring-buffer: small optimizations
      ring-buffer: use internal time stamp function
      ring-buffer: move code around to remove some branches
      x86/stacktrace: return 0 instead of -1 for stack ops
      tracing: stop stack trace on first empty entry
      tracing: add __print_flags for events
      tracing: add previous task state info to sched switch event
      tracing: add flag output for kmem events
      tracing: add __print_symbolic to trace events
      tracing: convert irq events to use __print_symbolic
      ftrace: add kernel command line function filtering
      tracing: fix config options to not show when automatically selected
      tracing: combine the default tracers into one config
      tracing: remove redundant SOFTIRQ from softirq event traces
      tracing: make trace pipe recognize latency format flag
      ftrace: do not profile functions when disabled
      ring-buffer: try to discard unneeded timestamps
      ring-buffer: discard timestamps that are at the start of the buffer
      tracing: add annotation to what type of stack trace is recorded
      ring-buffer: fix ret in rb_add_time_stamp
      tracing: fix the block trace points print size
      tracing: add trace_seq_vprint interface
      tracing: add protection around module events unload
      tracing: do not translate event helper macros in print format

Steven Whitehouse (2):
      tracing: add exports to use __print_symbolic and __print_flags from a module
      tracing: fix multiple use of __print_flags and __print_symbolic

Stuart Bennett (3):
      tracing: x86, mmiotrace: code consistency/legibility improvement
      tracing: x86, mmiotrace: refactor clearing/restore of page presence
      tracing: x86, mmiotrace: only register for die notifier when tracer active

Theodore Ts'o (2):
      tracing: Add documentation for the power tracer
      tracing: Document the event tracing system

Tim Abbott (1):
      ftrace: use .sched.text, not .text.sched in recordmcount.pl

Tim Bird (1):
      ring-buffer: fix bug in ring_buffer_discard_commit

Tom Zanussi (9):
      tracing/filters: add run-time field descriptions to TRACE_EVENT_FORMAT events
      tracing/filters: add TRACE_EVENT_FORMAT_NOFILTER event macro
      tracing/infrastructure: separate event tracer from event support
      tracing/filters: use ring_buffer_discard_commit() in filter_check_discard()
      tracing/filters: allow on-the-fly filter switching
      tracing/filters: add filter_mutex to protect filter predicates
      tracing/filters: move preds into event_filter object
      tracing/filters: distinguish between signed and unsigned fields
      tracing/filters: a better event parser

Zhaolei (12):
      ftrace: clean up enable logic for sched_switch
      tracing, net, skb tracepoint: make skb tracepoint use the TRACE_EVENT() macro
      tracing, kmemtrace: Separate include/trace/kmemtrace.h to kmemtrace part and tracepoint part
      tracing, kmemtrace: Make kmem tracepoints use TRACE_EVENT macro
      tracing: Remove include/trace/kmem_event_types.h
      ftrace: Add task_comm support for trace_event
      ftrace: clean up of using ftrace_event_enable_disable()
      ftrace: don't convert function's local variable name in macro
      ftrace, workqueuetrace: make workqueue tracepoints use TRACE_EVENT macro
      trace_workqueue: use list_for_each_entry() instead of list_for_each_entry_safe()
      trace_workqueue: remove cpu_workqueue_stats->first_entry
      trace_workqueue: remove blank line between each cpu

walimis (3):
      tracing/trace_stack: fix the number of entries in the header
      tracing/events: fix output format of kernel stack
      tracing/events: fix output format of user stack


 Documentation/DocBook/Makefile                     |    3 +-
 Documentation/DocBook/tracepoint.tmpl              |   89 ++
 Documentation/kernel-parameters.txt                |   27 +-
 Documentation/trace/events.txt                     |   90 ++
 Documentation/trace/ftrace.txt                     |    2 +-
 Documentation/trace/power.txt                      |   17 +
 arch/x86/Kconfig.debug                             |    9 +
 arch/x86/include/asm/ds.h                          |   82 +-
 arch/x86/include/asm/processor.h                   |   35 +-
 arch/x86/include/asm/ptrace.h                      |    9 +-
 arch/x86/include/asm/tlbflush.h                    |    8 +-
 arch/x86/kernel/Makefile                           |    1 +
 arch/x86/kernel/ds.c                               |  921 +++++++++++-----
 arch/x86/kernel/ds_selftest.c                      |  408 +++++++
 arch/x86/kernel/ds_selftest.h                      |   15 +
 arch/x86/kernel/entry_64.S                         |   19 +-
 arch/x86/kernel/process.c                          |    5 +-
 arch/x86/kernel/process_32.c                       |    3 +-
 arch/x86/kernel/process_64.c                       |    3 +-
 arch/x86/kernel/ptrace.c                           |  284 +++--
 arch/x86/kernel/stacktrace.c                       |    2 +-
 arch/x86/mm/kmmio.c                                |  104 +-
 arch/x86/mm/mmio-mod.c                             |    2 +
 block/blk-core.c                                   |   21 +-
 block/blk-sysfs.c                                  |    7 +-
 block/compat_ioctl.c                               |    2 +-
 block/elevator.c                                   |    8 +-
 drivers/md/dm.c                                    |    8 +-
 drivers/scsi/sg.c                                  |    1 +
 fs/bio.c                                           |    3 +-
 include/asm-generic/vmlinux.lds.h                  |    2 +-
 include/linux/blktrace_api.h                       |   45 +-
 include/linux/ftrace.h                             |   17 +-
 include/linux/ftrace_event.h                       |  172 +++
 include/linux/init_task.h                          |    1 +
 include/linux/kmemtrace.h                          |   25 +
 include/linux/mm.h                                 |    7 +-
 include/linux/mmiotrace.h                          |    2 +
 include/linux/module.h                             |    8 +
 include/linux/ptrace.h                             |   10 -
 include/linux/ring_buffer.h                        |   66 +-
 include/linux/sched.h                              |   17 +-
 include/linux/slab_def.h                           |    2 +-
 include/linux/slub_def.h                           |    2 +-
 include/linux/trace_seq.h                          |   92 ++
 include/linux/tracepoint.h                         |    8 +-
 include/trace/block.h                              |   76 --
 include/trace/define_trace.h                       |   75 ++
 include/trace/events/block.h                       |  498 ++++++++
 include/trace/events/irq.h                         |  145 +++
 include/trace/events/kmem.h                        |  231 ++++
 include/trace/events/lockdep.h                     |   96 ++
 .../trace/{sched_event_types.h => events/sched.h}  |   29 +-
 include/trace/events/skb.h                         |   40 +
 include/trace/events/workqueue.h                   |  100 ++
 include/trace/ftrace.h                             |  591 ++++++++++
 include/trace/irq.h                                |    9 -
 include/trace/irq_event_types.h                    |   55 -
 include/trace/kmemtrace.h                          |   63 -
 include/trace/lockdep.h                            |    9 -
 include/trace/lockdep_event_types.h                |   44 -
 include/trace/sched.h                              |    9 -
 include/trace/skb.h                                |   11 -
 include/trace/trace_event_types.h                  |    5 -
 include/trace/trace_events.h                       |    5 -
 include/trace/workqueue.h                          |   25 -
 init/main.c                                        |    2 +-
 kernel/Makefile                                    |    1 +
 kernel/exit.c                                      |    6 +-
 kernel/fork.c                                      |    9 +-
 kernel/irq/handle.c                                |    5 +-
 kernel/kthread.c                                   |    5 +-
 kernel/lockdep.c                                   |   16 +-
 kernel/module.c                                    |   26 +-
 kernel/ptrace.c                                    |   10 -
 kernel/sched.c                                     |   55 +-
 kernel/signal.c                                    |    4 +-
 kernel/softirq.c                                   |    7 +-
 kernel/trace/Kconfig                               |  143 ++-
 kernel/trace/Makefile                              |   20 +-
 kernel/trace/blktrace.c                            |  272 ++++-
 kernel/trace/events.c                              |   14 -
 kernel/trace/ftrace.c                              |  772 ++++++++++++--
 kernel/trace/kmemtrace.c                           |   10 +-
 kernel/trace/ring_buffer.c                         |  777 ++++++++-----
 kernel/trace/ring_buffer_benchmark.c               |  416 +++++++
 kernel/trace/trace.c                               |  383 ++++---
 kernel/trace/trace.h                               |  243 ++---
 kernel/trace/trace_boot.c                          |    5 +-
 kernel/trace/trace_branch.c                        |    8 +-
 kernel/trace/trace_event_profile.c                 |   24 +-
 kernel/trace/trace_event_types.h                   |   12 +-
 kernel/trace/trace_events.c                        |  839 ++++++++++++---
 kernel/trace/trace_events_filter.c                 | 1204 ++++++++++++++++----
 kernel/trace/trace_events_stage_1.h                |   39 -
 kernel/trace/trace_events_stage_2.h                |  176 ---
 kernel/trace/trace_events_stage_3.h                |  281 -----
 kernel/trace/trace_export.c                        |  110 ++-
 kernel/trace/trace_functions_graph.c               |   25 +-
 kernel/trace/trace_hw_branches.c                   |  203 ++--
 kernel/trace/trace_mmiotrace.c                     |    6 +-
 kernel/trace/trace_output.c                        |  240 ++++-
 kernel/trace/trace_output.h                        |   34 +-
 kernel/trace/trace_power.c                         |    8 +-
 kernel/trace/trace_printk.c                        |    6 +-
 kernel/trace/trace_sched_switch.c                  |   12 +-
 kernel/trace/trace_sched_wakeup.c                  |    8 +-
 kernel/trace/trace_selftest.c                      |   58 +
 kernel/trace/trace_stack.c                         |   15 +-
 kernel/trace/trace_stat.c                          |  208 +++--
 kernel/trace/trace_stat.h                          |    2 +-
 kernel/trace/trace_sysprof.c                       |    6 +-
 kernel/trace/trace_workqueue.c                     |   25 +-
 kernel/workqueue.c                                 |   11 +-
 mm/bounce.c                                        |    5 +-
 mm/mlock.c                                         |   51 +-
 mm/slab.c                                          |    2 +-
 mm/slob.c                                          |    2 +-
 mm/slub.c                                          |    2 +-
 mm/util.c                                          |   11 +-
 net/core/drop_monitor.c                            |    2 +-
 net/core/net-traces.c                              |    4 +-
 net/core/skbuff.c                                  |    2 +-
 samples/Kconfig                                    |    6 +
 samples/Makefile                                   |    2 +-
 samples/trace_events/Makefile                      |    6 +
 samples/trace_events/trace-events-sample.c         |   52 +
 samples/trace_events/trace-events-sample.h         |  129 +++
 scripts/kernel-doc                                 |   22 +
 scripts/recordmcount.pl                            |    6 +-
 130 files changed, 8926 insertions(+), 2919 deletions(-)
 create mode 100644 Documentation/DocBook/tracepoint.tmpl
 create mode 100644 Documentation/trace/events.txt
 create mode 100644 Documentation/trace/power.txt
 create mode 100644 arch/x86/kernel/ds_selftest.c
 create mode 100644 arch/x86/kernel/ds_selftest.h
 create mode 100644 include/linux/ftrace_event.h
 create mode 100644 include/linux/kmemtrace.h
 create mode 100644 include/linux/trace_seq.h
 delete mode 100644 include/trace/block.h
 create mode 100644 include/trace/define_trace.h
 create mode 100644 include/trace/events/block.h
 create mode 100644 include/trace/events/irq.h
 create mode 100644 include/trace/events/kmem.h
 create mode 100644 include/trace/events/lockdep.h
 rename include/trace/{sched_event_types.h => events/sched.h} (91%)
 create mode 100644 include/trace/events/skb.h
 create mode 100644 include/trace/events/workqueue.h
 create mode 100644 include/trace/ftrace.h
 delete mode 100644 include/trace/irq.h
 delete mode 100644 include/trace/irq_event_types.h
 delete mode 100644 include/trace/kmemtrace.h
 delete mode 100644 include/trace/lockdep.h
 delete mode 100644 include/trace/lockdep_event_types.h
 delete mode 100644 include/trace/sched.h
 delete mode 100644 include/trace/skb.h
 delete mode 100644 include/trace/trace_event_types.h
 delete mode 100644 include/trace/trace_events.h
 delete mode 100644 include/trace/workqueue.h
 delete mode 100644 kernel/trace/events.c
 create mode 100644 kernel/trace/ring_buffer_benchmark.c
 delete mode 100644 kernel/trace/trace_events_stage_1.h
 delete mode 100644 kernel/trace/trace_events_stage_2.h
 delete mode 100644 kernel/trace/trace_events_stage_3.h
 create mode 100644 samples/trace_events/Makefile
 create mode 100644 samples/trace_events/trace-events-sample.c
 create mode 100644 samples/trace_events/trace-events-sample.h

diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefile
index b1eb661..9632444 100644
--- a/Documentation/DocBook/Makefile
+++ b/Documentation/DocBook/Makefile
@@ -13,7 +13,8 @@ DOCBOOKS := z8530book.xml mcabook.xml device-drivers.xml \
 	    gadget.xml libata.xml mtdnand.xml librs.xml rapidio.xml \
 	    genericirq.xml s390-drivers.xml uio-howto.xml scsi.xml \
 	    mac80211.xml debugobjects.xml sh.xml regulator.xml \
-	    alsa-driver-api.xml writing-an-alsa-driver.xml
+	    alsa-driver-api.xml writing-an-alsa-driver.xml \
+	    tracepoint.xml
 
 ###
 # The build process is as follows (targets):
diff --git a/Documentation/DocBook/tracepoint.tmpl b/Documentation/DocBook/tracepoint.tmpl
new file mode 100644
index 0000000..b0756d0
--- /dev/null
+++ b/Documentation/DocBook/tracepoint.tmpl
@@ -0,0 +1,89 @@
+<?xml version="1.0" encoding="UTF-8"?>
+<!DOCTYPE book PUBLIC "-//OASIS//DTD DocBook XML V4.1.2//EN"
+	"http://www.oasis-open.org/docbook/xml/4.1.2/docbookx.dtd" []>
+
+<book id="Tracepoints">
+ <bookinfo>
+  <title>The Linux Kernel Tracepoint API</title>
+
+  <authorgroup>
+   <author>
+    <firstname>Jason</firstname>
+    <surname>Baron</surname>
+    <affiliation>
+     <address>
+      <email>jbaron@redhat.com</email>
+     </address>
+    </affiliation>
+   </author>
+  </authorgroup>
+
+  <legalnotice>
+   <para>
+     This documentation is free software; you can redistribute
+     it and/or modify it under the terms of the GNU General Public
+     License as published by the Free Software Foundation; either
+     version 2 of the License, or (at your option) any later
+     version.
+   </para>
+
+   <para>
+     This program is distributed in the hope that it will be
+     useful, but WITHOUT ANY WARRANTY; without even the implied
+     warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+     See the GNU General Public License for more details.
+   </para>
+
+   <para>
+     You should have received a copy of the GNU General Public
+     License along with this program; if not, write to the Free
+     Software Foundation, Inc., 59 Temple Place, Suite 330, Boston,
+     MA 02111-1307 USA
+   </para>
+
+   <para>
+     For more details see the file COPYING in the source
+     distribution of Linux.
+   </para>
+  </legalnotice>
+ </bookinfo>
+
+ <toc></toc>
+  <chapter id="intro">
+   <title>Introduction</title>
+   <para>
+     Tracepoints are static probe points that are located in strategic points
+     throughout the kernel. 'Probes' register/unregister with tracepoints
+     via a callback mechanism. The 'probes' are strictly typed functions that
+     are passed a unique set of parameters defined by each tracepoint.
+   </para>
+
+   <para>
+     From this simple callback mechanism, 'probes' can be used to profile, debug,
+     and understand kernel behavior. There are a number of tools that provide a
+     framework for using 'probes'. These tools include Systemtap, ftrace, and
+     LTTng.
+   </para>
+
+   <para>
+     Tracepoints are defined in a number of header files via various macros. Thus,
+     the purpose of this document is to provide a clear accounting of the available
+     tracepoints. The intention is to understand not only what tracepoints are
+     available but also to understand where future tracepoints might be added.
+   </para>
+
+   <para>
+     The API presented has functions of the form:
+     <function>trace_tracepointname(function parameters)</function>. These are the
+     tracepoints callbacks that are found throughout the code. Registering and
+     unregistering probes with these callback sites is covered in the
+     <filename>Documentation/trace/*</filename> directory.
+   </para>
+  </chapter>
+
+  <chapter id="irq">
+   <title>IRQ</title>
+!Iinclude/trace/events/irq.h
+  </chapter>
+
+</book>
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index e87bdbf..fcd3bfb 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -56,7 +56,6 @@ parameter is applicable:
 	ISAPNP	ISA PnP code is enabled.
 	ISDN	Appropriate ISDN support is enabled.
 	JOY	Appropriate joystick support is enabled.
-	KMEMTRACE kmemtrace is enabled.
 	LIBATA  Libata driver is enabled
 	LP	Printer support is enabled.
 	LOOP	Loopback device support is enabled.
@@ -752,12 +751,25 @@ and is between 256 and 4096 characters. It is defined in the file
 			ia64_pal_cache_flush instead of SAL_CACHE_FLUSH.
 
 	ftrace=[tracer]
-			[ftrace] will set and start the specified tracer
+			[FTRACE] will set and start the specified tracer
 			as early as possible in order to facilitate early
 			boot debugging.
 
 	ftrace_dump_on_oops
-			[ftrace] will dump the trace buffers on oops.
+			[FTRACE] will dump the trace buffers on oops.
+
+	ftrace_filter=[function-list]
+			[FTRACE] Limit the functions traced by the function
+			tracer at boot up. function-list is a comma separated
+			list of functions. This list can be changed at run
+			time by the set_ftrace_filter file in the debugfs
+			tracing directory. 
+
+	ftrace_notrace=[function-list]
+			[FTRACE] Do not trace the functions specified in
+			function-list. This list can be changed at run time
+			by the set_ftrace_notrace file in the debugfs
+			tracing directory.
 
 	gamecon.map[2|3]=
 			[HW,JOY] Multisystem joystick and NES/SNES/PSX pad
@@ -1054,15 +1066,6 @@ and is between 256 and 4096 characters. It is defined in the file
 			use the HighMem zone if it exists, and the Normal
 			zone if it does not.
 
-	kmemtrace.enable=	[KNL,KMEMTRACE] Format: { yes | no }
-				Controls whether kmemtrace is enabled
-				at boot-time.
-
-	kmemtrace.subbufs=n	[KNL,KMEMTRACE] Overrides the number of
-			subbufs kmemtrace's relay channel has. Set this
-			higher than default (KMEMTRACE_N_SUBBUFS in code) if
-			you experience buffer overruns.
-
 	kgdboc=		[HW] kgdb over consoles.
 			Requires a tty driver that supports console polling.
 			(only serial suported for now)
diff --git a/Documentation/trace/events.txt b/Documentation/trace/events.txt
new file mode 100644
index 0000000..f157d75
--- /dev/null
+++ b/Documentation/trace/events.txt
@@ -0,0 +1,90 @@
+			     Event Tracing
+
+		Documentation written by Theodore Ts'o
+			Updated by Li Zefan
+
+1. Introduction
+===============
+
+Tracepoints (see Documentation/trace/tracepoints.txt) can be used
+without creating custom kernel modules to register probe functions
+using the event tracing infrastructure.
+
+Not all tracepoints can be traced using the event tracing system;
+the kernel developer must provide code snippets which define how the
+tracing information is saved into the tracing buffer, and how the
+tracing information should be printed.
+
+2. Using Event Tracing
+======================
+
+2.1 Via the 'set_event' interface
+---------------------------------
+
+The events which are available for tracing can be found in the file
+/debug/tracing/available_events.
+
+To enable a particular event, such as 'sched_wakeup', simply echo it
+to /debug/tracing/set_event. For example:
+
+	# echo sched_wakeup >> /debug/tracing/set_event
+
+[ Note: '>>' is necessary, otherwise it will firstly disable
+  all the events. ]
+
+To disable an event, echo the event name to the set_event file prefixed
+with an exclamation point:
+
+	# echo '!sched_wakeup' >> /debug/tracing/set_event
+
+To disable all events, echo an empty line to the set_event file:
+
+	# echo > /debug/tracing/set_event
+
+To enable all events, echo '*:*' or '*:' to the set_event file:
+
+	# echo *:* > /debug/tracing/set_event
+
+The events are organized into subsystems, such as ext4, irq, sched,
+etc., and a full event name looks like this: <subsystem>:<event>.  The
+subsystem name is optional, but it is displayed in the available_events
+file.  All of the events in a subsystem can be specified via the syntax
+"<subsystem>:*"; for example, to enable all irq events, you can use the
+command:
+
+	# echo 'irq:*' > /debug/tracing/set_event
+
+2.2 Via the 'enable' toggle
+---------------------------
+
+The events available are also listed in /debug/tracing/events/ hierarchy
+of directories.
+
+To enable event 'sched_wakeup':
+
+	# echo 1 > /debug/tracing/events/sched/sched_wakeup/enable
+
+To disable it:
+
+	# echo 0 > /debug/tracing/events/sched/sched_wakeup/enable
+
+To enable all events in sched subsystem:
+
+	# echo 1 > /debug/tracing/events/sched/enable
+
+To eanble all events:
+
+	# echo 1 > /debug/tracing/events/enable
+
+When reading one of these enable files, there are four results:
+
+ 0 - all events this file affects are disabled
+ 1 - all events this file affects are enabled
+ X - there is a mixture of events enabled and disabled
+ ? - this file does not affect any event
+
+3. Defining an event-enabled tracepoint
+=======================================
+
+See The example provided in samples/trace_events
+
diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index fd9a3e6..5ad2ded 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -179,7 +179,7 @@ Here is the list of current tracers that may be configured.
 
 	Function call tracer to trace all kernel functions.
 
-  "function_graph_tracer"
+  "function_graph"
 
 	Similar to the function tracer except that the
 	function tracer probes the functions on their entry
diff --git a/Documentation/trace/power.txt b/Documentation/trace/power.txt
new file mode 100644
index 0000000..cd805e1
--- /dev/null
+++ b/Documentation/trace/power.txt
@@ -0,0 +1,17 @@
+The power tracer collects detailed information about C-state and P-state
+transitions, instead of just looking at the high-level "average"
+information.
+
+There is a helper script found in scrips/tracing/power.pl in the kernel
+sources which can be used to parse this information and create a
+Scalable Vector Graphics (SVG) picture from the trace data.
+
+To use this tracer:
+
+	echo 0 > /sys/kernel/debug/tracing/tracing_enabled
+	echo power > /sys/kernel/debug/tracing/current_tracer
+	echo 1 > /sys/kernel/debug/tracing/tracing_enabled
+	sleep 1
+	echo 0 > /sys/kernel/debug/tracing/tracing_enabled
+	cat /sys/kernel/debug/tracing/trace | \
+		perl scripts/tracing/power.pl > out.sv
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index d8359e7..22b752e 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -167,6 +167,15 @@ config IOMMU_LEAK
 	  Add a simple leak tracer to the IOMMU code. This is useful when you
 	  are debugging a buggy device driver that leaks IOMMU mappings.
 
+config X86_DS_SELFTEST
+    bool "DS selftest"
+    default y
+    depends on DEBUG_KERNEL
+    depends on X86_DS
+	---help---
+	  Perform Debug Store selftests at boot time.
+	  If in doubt, say "N".
+
 config HAVE_MMIOTRACE_SUPPORT
 	def_bool y
 
diff --git a/arch/x86/include/asm/ds.h b/arch/x86/include/asm/ds.h
index a8f672b..70dac19 100644
--- a/arch/x86/include/asm/ds.h
+++ b/arch/x86/include/asm/ds.h
@@ -15,8 +15,8 @@
  * - buffer allocation (memory accounting)
  *
  *
- * Copyright (C) 2007-2008 Intel Corporation.
- * Markus Metzger <markus.t.metzger@intel.com>, 2007-2008
+ * Copyright (C) 2007-2009 Intel Corporation.
+ * Markus Metzger <markus.t.metzger@intel.com>, 2007-2009
  */
 
 #ifndef _ASM_X86_DS_H
@@ -83,8 +83,10 @@ enum ds_feature {
  * The interrupt threshold is independent from the overflow callback
  * to allow users to use their own overflow interrupt handling mechanism.
  *
- * task: the task to request recording for;
- *       NULL for per-cpu recording on the current cpu
+ * The function might sleep.
+ *
+ * task: the task to request recording for
+ * cpu:  the cpu to request recording for
  * base: the base pointer for the (non-pageable) buffer;
  * size: the size of the provided buffer in bytes
  * ovfl: pointer to a function to be called on buffer overflow;
@@ -93,19 +95,28 @@ enum ds_feature {
  *     -1 if no interrupt threshold is requested.
  * flags: a bit-mask of the above flags
  */
-extern struct bts_tracer *ds_request_bts(struct task_struct *task,
-					 void *base, size_t size,
-					 bts_ovfl_callback_t ovfl,
-					 size_t th, unsigned int flags);
-extern struct pebs_tracer *ds_request_pebs(struct task_struct *task,
-					   void *base, size_t size,
-					   pebs_ovfl_callback_t ovfl,
-					   size_t th, unsigned int flags);
+extern struct bts_tracer *ds_request_bts_task(struct task_struct *task,
+					      void *base, size_t size,
+					      bts_ovfl_callback_t ovfl,
+					      size_t th, unsigned int flags);
+extern struct bts_tracer *ds_request_bts_cpu(int cpu, void *base, size_t size,
+					     bts_ovfl_callback_t ovfl,
+					     size_t th, unsigned int flags);
+extern struct pebs_tracer *ds_request_pebs_task(struct task_struct *task,
+						void *base, size_t size,
+						pebs_ovfl_callback_t ovfl,
+						size_t th, unsigned int flags);
+extern struct pebs_tracer *ds_request_pebs_cpu(int cpu,
+					       void *base, size_t size,
+					       pebs_ovfl_callback_t ovfl,
+					       size_t th, unsigned int flags);
 
 /*
  * Release BTS or PEBS resources
  * Suspend and resume BTS or PEBS tracing
  *
+ * Must be called with irq's enabled.
+ *
  * tracer: the tracer handle returned from ds_request_~()
  */
 extern void ds_release_bts(struct bts_tracer *tracer);
@@ -115,6 +126,28 @@ extern void ds_release_pebs(struct pebs_tracer *tracer);
 extern void ds_suspend_pebs(struct pebs_tracer *tracer);
 extern void ds_resume_pebs(struct pebs_tracer *tracer);
 
+/*
+ * Release BTS or PEBS resources
+ * Suspend and resume BTS or PEBS tracing
+ *
+ * Cpu tracers must call this on the traced cpu.
+ * Task tracers must call ds_release_~_noirq() for themselves.
+ *
+ * May be called with irq's disabled.
+ *
+ * Returns 0 if successful;
+ * -EPERM if the cpu tracer does not trace the current cpu.
+ * -EPERM if the task tracer does not trace itself.
+ *
+ * tracer: the tracer handle returned from ds_request_~()
+ */
+extern int ds_release_bts_noirq(struct bts_tracer *tracer);
+extern int ds_suspend_bts_noirq(struct bts_tracer *tracer);
+extern int ds_resume_bts_noirq(struct bts_tracer *tracer);
+extern int ds_release_pebs_noirq(struct pebs_tracer *tracer);
+extern int ds_suspend_pebs_noirq(struct pebs_tracer *tracer);
+extern int ds_resume_pebs_noirq(struct pebs_tracer *tracer);
+
 
 /*
  * The raw DS buffer state as it is used for BTS and PEBS recording.
@@ -170,9 +203,9 @@ struct bts_struct {
 		} lbr;
 		/* BTS_TASK_ARRIVES or BTS_TASK_DEPARTS */
 		struct {
-			__u64 jiffies;
+			__u64 clock;
 			pid_t pid;
-		} timestamp;
+		} event;
 	} variant;
 };
 
@@ -201,8 +234,12 @@ struct bts_trace {
 struct pebs_trace {
 	struct ds_trace ds;
 
-	/* the PEBS reset value */
-	unsigned long long reset_value;
+	/* the number of valid counters in the below array */
+	unsigned int counters;
+
+#define MAX_PEBS_COUNTERS 4
+	/* the counter reset value */
+	unsigned long long counter_reset[MAX_PEBS_COUNTERS];
 };
 
 
@@ -237,9 +274,11 @@ extern int ds_reset_pebs(struct pebs_tracer *tracer);
  * Returns 0 on success; -Eerrno on error
  *
  * tracer: the tracer handle returned from ds_request_pebs()
+ * counter: the index of the counter
  * value: the new counter reset value
  */
-extern int ds_set_pebs_reset(struct pebs_tracer *tracer, u64 value);
+extern int ds_set_pebs_reset(struct pebs_tracer *tracer,
+			     unsigned int counter, u64 value);
 
 /*
  * Initialization
@@ -252,21 +291,12 @@ extern void __cpuinit ds_init_intel(struct cpuinfo_x86 *);
  */
 extern void ds_switch_to(struct task_struct *prev, struct task_struct *next);
 
-/*
- * Task clone/init and cleanup work
- */
-extern void ds_copy_thread(struct task_struct *tsk, struct task_struct *father);
-extern void ds_exit_thread(struct task_struct *tsk);
-
 #else /* CONFIG_X86_DS */
 
 struct cpuinfo_x86;
 static inline void __cpuinit ds_init_intel(struct cpuinfo_x86 *ignored) {}
 static inline void ds_switch_to(struct task_struct *prev,
 				struct task_struct *next) {}
-static inline void ds_copy_thread(struct task_struct *tsk,
-				  struct task_struct *father) {}
-static inline void ds_exit_thread(struct task_struct *tsk) {}
 
 #endif /* CONFIG_X86_DS */
 #endif /* _ASM_X86_DS_H */
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index c2cceae..0b2fab0 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -460,14 +460,8 @@ struct thread_struct {
 	unsigned		io_bitmap_max;
 /* MSR_IA32_DEBUGCTLMSR value to switch in if TIF_DEBUGCTLMSR is set.  */
 	unsigned long	debugctlmsr;
-#ifdef CONFIG_X86_DS
-/* Debug Store context; see include/asm-x86/ds.h; goes into MSR_IA32_DS_AREA */
+	/* Debug Store context; see asm/ds.h */
 	struct ds_context	*ds_ctx;
-#endif /* CONFIG_X86_DS */
-#ifdef CONFIG_X86_PTRACE_BTS
-/* the signal to send on a bts buffer overflow */
-	unsigned int	bts_ovfl_signal;
-#endif /* CONFIG_X86_PTRACE_BTS */
 };
 
 static inline unsigned long native_get_debugreg(int regno)
@@ -795,6 +789,21 @@ static inline unsigned long get_debugctlmsr(void)
     return debugctlmsr;
 }
 
+static inline unsigned long get_debugctlmsr_on_cpu(int cpu)
+{
+	u64 debugctlmsr = 0;
+	u32 val1, val2;
+
+#ifndef CONFIG_X86_DEBUGCTLMSR
+	if (boot_cpu_data.x86 < 6)
+		return 0;
+#endif
+	rdmsr_on_cpu(cpu, MSR_IA32_DEBUGCTLMSR, &val1, &val2);
+	debugctlmsr = val1 | ((u64)val2 << 32);
+
+	return debugctlmsr;
+}
+
 static inline void update_debugctlmsr(unsigned long debugctlmsr)
 {
 #ifndef CONFIG_X86_DEBUGCTLMSR
@@ -804,6 +813,18 @@ static inline void update_debugctlmsr(unsigned long debugctlmsr)
 	wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctlmsr);
 }
 
+static inline void update_debugctlmsr_on_cpu(int cpu,
+					     unsigned long debugctlmsr)
+{
+#ifndef CONFIG_X86_DEBUGCTLMSR
+	if (boot_cpu_data.x86 < 6)
+		return;
+#endif
+	wrmsr_on_cpu(cpu, MSR_IA32_DEBUGCTLMSR,
+		     (u32)((u64)debugctlmsr),
+		     (u32)((u64)debugctlmsr >> 32));
+}
+
 /*
  * from system description table in BIOS. Mostly for MCA use, but
  * others may find it useful:
diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index e304b66..5cdd19f 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -235,12 +235,11 @@ extern int do_get_thread_area(struct task_struct *p, int idx,
 extern int do_set_thread_area(struct task_struct *p, int idx,
 			      struct user_desc __user *info, int can_allocate);
 
-extern void x86_ptrace_untrace(struct task_struct *);
-extern void x86_ptrace_fork(struct task_struct *child,
-			    unsigned long clone_flags);
+#ifdef CONFIG_X86_PTRACE_BTS
+extern void ptrace_bts_untrace(struct task_struct *tsk);
 
-#define arch_ptrace_untrace(tsk) x86_ptrace_untrace(tsk)
-#define arch_ptrace_fork(child, flags) x86_ptrace_fork(child, flags)
+#define arch_ptrace_untrace(tsk)	ptrace_bts_untrace(tsk)
+#endif /* CONFIG_X86_PTRACE_BTS */
 
 #endif /* __KERNEL__ */
 
diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 16a5c84..a5ecc9c 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -17,7 +17,7 @@
 
 static inline void __native_flush_tlb(void)
 {
-	write_cr3(read_cr3());
+	native_write_cr3(native_read_cr3());
 }
 
 static inline void __native_flush_tlb_global(void)
@@ -32,11 +32,11 @@ static inline void __native_flush_tlb_global(void)
 	 */
 	raw_local_irq_save(flags);
 
-	cr4 = read_cr4();
+	cr4 = native_read_cr4();
 	/* clear PGE */
-	write_cr4(cr4 & ~X86_CR4_PGE);
+	native_write_cr4(cr4 & ~X86_CR4_PGE);
 	/* write old PGE again and flush TLBs */
-	write_cr4(cr4);
+	native_write_cr4(cr4);
 
 	raw_local_irq_restore(flags);
 }
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 145cce7..77df4d6 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -44,6 +44,7 @@ obj-y				+= process.o
 obj-y				+= i387.o xsave.o
 obj-y				+= ptrace.o
 obj-$(CONFIG_X86_DS)		+= ds.o
+obj-$(CONFIG_X86_DS_SELFTEST)		+= ds_selftest.o
 obj-$(CONFIG_X86_32)		+= tls.o
 obj-$(CONFIG_IA32_EMULATION)	+= tls.o
 obj-y				+= step.o
diff --git a/arch/x86/kernel/ds.c b/arch/x86/kernel/ds.c
index 87b67e3..48bfe13 100644
--- a/arch/x86/kernel/ds.c
+++ b/arch/x86/kernel/ds.c
@@ -19,45 +19,61 @@
  * Markus Metzger <markus.t.metzger@intel.com>, 2007-2009
  */
 
-
-#include <asm/ds.h>
-
-#include <linux/errno.h>
+#include <linux/kernel.h>
 #include <linux/string.h>
-#include <linux/slab.h>
+#include <linux/errno.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 #include <linux/mm.h>
-#include <linux/kernel.h>
+#include <linux/trace_clock.h>
+
+#include <asm/ds.h>
 
+#include "ds_selftest.h"
 
 /*
- * The configuration for a particular DS hardware implementation.
+ * The configuration for a particular DS hardware implementation:
  */
 struct ds_configuration {
-	/* the name of the configuration */
-	const char *name;
-	/* the size of one pointer-typed field in the DS structure and
-	   in the BTS and PEBS buffers in bytes;
-	   this covers the first 8 DS fields related to buffer management. */
-	unsigned char  sizeof_field;
-	/* the size of a BTS/PEBS record in bytes */
-	unsigned char  sizeof_rec[2];
-	/* a series of bit-masks to control various features indexed
-	 * by enum ds_feature */
-	unsigned long ctl[dsf_ctl_max];
+	/* The name of the configuration: */
+	const char		*name;
+
+	/* The size of pointer-typed fields in DS, BTS, and PEBS: */
+	unsigned char		sizeof_ptr_field;
+
+	/* The size of a BTS/PEBS record in bytes: */
+	unsigned char		sizeof_rec[2];
+
+	/* The number of pebs counter reset values in the DS structure. */
+	unsigned char		nr_counter_reset;
+
+	/* Control bit-masks indexed by enum ds_feature: */
+	unsigned long		ctl[dsf_ctl_max];
 };
-static DEFINE_PER_CPU(struct ds_configuration, ds_cfg_array);
+static struct ds_configuration ds_cfg __read_mostly;
+
+
+/* Maximal size of a DS configuration: */
+#define MAX_SIZEOF_DS		0x80
 
-#define ds_cfg per_cpu(ds_cfg_array, smp_processor_id())
+/* Maximal size of a BTS record: */
+#define MAX_SIZEOF_BTS		(3 * 8)
 
-#define MAX_SIZEOF_DS (12 * 8)	/* maximal size of a DS configuration */
-#define MAX_SIZEOF_BTS (3 * 8)	/* maximal size of a BTS record */
-#define DS_ALIGNMENT (1 << 3)	/* BTS and PEBS buffer alignment */
+/* BTS and PEBS buffer alignment: */
+#define DS_ALIGNMENT		(1 << 3)
 
-#define BTS_CONTROL \
- (ds_cfg.ctl[dsf_bts] | ds_cfg.ctl[dsf_bts_kernel] | ds_cfg.ctl[dsf_bts_user] |\
-  ds_cfg.ctl[dsf_bts_overflow])
+/* Number of buffer pointers in DS: */
+#define NUM_DS_PTR_FIELDS	8
 
+/* Size of a pebs reset value in DS: */
+#define PEBS_RESET_FIELD_SIZE	8
+
+/* Mask of control bits in the DS MSR register: */
+#define BTS_CONTROL				  \
+	( ds_cfg.ctl[dsf_bts]			| \
+	  ds_cfg.ctl[dsf_bts_kernel]		| \
+	  ds_cfg.ctl[dsf_bts_user]		| \
+	  ds_cfg.ctl[dsf_bts_overflow] )
 
 /*
  * A BTS or PEBS tracer.
@@ -66,29 +82,36 @@ static DEFINE_PER_CPU(struct ds_configuration, ds_cfg_array);
  * to identify tracers.
  */
 struct ds_tracer {
-	/* the DS context (partially) owned by this tracer */
-	struct ds_context *context;
-	/* the buffer provided on ds_request() and its size in bytes */
-	void *buffer;
-	size_t size;
+	/* The DS context (partially) owned by this tracer. */
+	struct ds_context	*context;
+	/* The buffer provided on ds_request() and its size in bytes. */
+	void			*buffer;
+	size_t			size;
 };
 
 struct bts_tracer {
-	/* the common DS part */
-	struct ds_tracer ds;
-	/* the trace including the DS configuration */
-	struct bts_trace trace;
-	/* buffer overflow notification function */
-	bts_ovfl_callback_t ovfl;
+	/* The common DS part: */
+	struct ds_tracer	ds;
+
+	/* The trace including the DS configuration: */
+	struct bts_trace	trace;
+
+	/* Buffer overflow notification function: */
+	bts_ovfl_callback_t	ovfl;
+
+	/* Active flags affecting trace collection. */
+	unsigned int		flags;
 };
 
 struct pebs_tracer {
-	/* the common DS part */
-	struct ds_tracer ds;
-	/* the trace including the DS configuration */
-	struct pebs_trace trace;
-	/* buffer overflow notification function */
-	pebs_ovfl_callback_t ovfl;
+	/* The common DS part: */
+	struct ds_tracer	ds;
+
+	/* The trace including the DS configuration: */
+	struct pebs_trace	trace;
+
+	/* Buffer overflow notification function: */
+	pebs_ovfl_callback_t	ovfl;
 };
 
 /*
@@ -97,6 +120,7 @@ struct pebs_tracer {
  *
  * The DS configuration consists of the following fields; different
  * architetures vary in the size of those fields.
+ *
  * - double-word aligned base linear address of the BTS buffer
  * - write pointer into the BTS buffer
  * - end linear address of the BTS buffer (one byte beyond the end of
@@ -135,21 +159,22 @@ enum ds_field {
 };
 
 enum ds_qualifier {
-	ds_bts  = 0,
+	ds_bts = 0,
 	ds_pebs
 };
 
-static inline unsigned long ds_get(const unsigned char *base,
-				   enum ds_qualifier qual, enum ds_field field)
+static inline unsigned long
+ds_get(const unsigned char *base, enum ds_qualifier qual, enum ds_field field)
 {
-	base += (ds_cfg.sizeof_field * (field + (4 * qual)));
+	base += (ds_cfg.sizeof_ptr_field * (field + (4 * qual)));
 	return *(unsigned long *)base;
 }
 
-static inline void ds_set(unsigned char *base, enum ds_qualifier qual,
-			  enum ds_field field, unsigned long value)
+static inline void
+ds_set(unsigned char *base, enum ds_qualifier qual, enum ds_field field,
+       unsigned long value)
 {
-	base += (ds_cfg.sizeof_field * (field + (4 * qual)));
+	base += (ds_cfg.sizeof_ptr_field * (field + (4 * qual)));
 	(*(unsigned long *)base) = value;
 }
 
@@ -159,7 +184,6 @@ static inline void ds_set(unsigned char *base, enum ds_qualifier qual,
  */
 static DEFINE_SPINLOCK(ds_lock);
 
-
 /*
  * We either support (system-wide) per-cpu or per-thread allocation.
  * We distinguish the two based on the task_struct pointer, where a
@@ -178,12 +202,28 @@ static DEFINE_SPINLOCK(ds_lock);
  */
 static atomic_t tracers = ATOMIC_INIT(0);
 
-static inline void get_tracer(struct task_struct *task)
+static inline int get_tracer(struct task_struct *task)
 {
-	if (task)
+	int error;
+
+	spin_lock_irq(&ds_lock);
+
+	if (task) {
+		error = -EPERM;
+		if (atomic_read(&tracers) < 0)
+			goto out;
 		atomic_inc(&tracers);
-	else
+	} else {
+		error = -EPERM;
+		if (atomic_read(&tracers) > 0)
+			goto out;
 		atomic_dec(&tracers);
+	}
+
+	error = 0;
+out:
+	spin_unlock_irq(&ds_lock);
+	return error;
 }
 
 static inline void put_tracer(struct task_struct *task)
@@ -194,14 +234,6 @@ static inline void put_tracer(struct task_struct *task)
 		atomic_inc(&tracers);
 }
 
-static inline int check_tracer(struct task_struct *task)
-{
-	return task ?
-		(atomic_read(&tracers) >= 0) :
-		(atomic_read(&tracers) <= 0);
-}
-
-
 /*
  * The DS context is either attached to a thread or to a cpu:
  * - in the former case, the thread_struct contains a pointer to the
@@ -213,61 +245,58 @@ static inline int check_tracer(struct task_struct *task)
  * deallocated when the last user puts the context.
  */
 struct ds_context {
-	/* pointer to the DS configuration; goes into MSR_IA32_DS_AREA */
-	unsigned char ds[MAX_SIZEOF_DS];
-	/* the owner of the BTS and PEBS configuration, respectively */
-	struct bts_tracer *bts_master;
-	struct pebs_tracer *pebs_master;
-	/* use count */
-	unsigned long count;
-	/* a pointer to the context location inside the thread_struct
-	 * or the per_cpu context array */
-	struct ds_context **this;
-	/* a pointer to the task owning this context, or NULL, if the
-	 * context is owned by a cpu */
-	struct task_struct *task;
-};
+	/* The DS configuration; goes into MSR_IA32_DS_AREA: */
+	unsigned char		ds[MAX_SIZEOF_DS];
+
+	/* The owner of the BTS and PEBS configuration, respectively: */
+	struct bts_tracer	*bts_master;
+	struct pebs_tracer	*pebs_master;
 
-static DEFINE_PER_CPU(struct ds_context *, system_context_array);
+	/* Use count: */
+	unsigned long		count;
 
-#define system_context per_cpu(system_context_array, smp_processor_id())
+	/* Pointer to the context pointer field: */
+	struct ds_context	**this;
+
+	/* The traced task; NULL for cpu tracing: */
+	struct task_struct	*task;
+
+	/* The traced cpu; only valid if task is NULL: */
+	int			cpu;
+};
 
+static DEFINE_PER_CPU(struct ds_context *, cpu_context);
 
-static inline struct ds_context *ds_get_context(struct task_struct *task)
+
+static struct ds_context *ds_get_context(struct task_struct *task, int cpu)
 {
 	struct ds_context **p_context =
-		(task ? &task->thread.ds_ctx : &system_context);
+		(task ? &task->thread.ds_ctx : &per_cpu(cpu_context, cpu));
 	struct ds_context *context = NULL;
 	struct ds_context *new_context = NULL;
-	unsigned long irq;
 
 	/* Chances are small that we already have a context. */
 	new_context = kzalloc(sizeof(*new_context), GFP_KERNEL);
 	if (!new_context)
 		return NULL;
 
-	spin_lock_irqsave(&ds_lock, irq);
+	spin_lock_irq(&ds_lock);
 
 	context = *p_context;
-	if (!context) {
+	if (likely(!context)) {
 		context = new_context;
 
 		context->this = p_context;
 		context->task = task;
+		context->cpu = cpu;
 		context->count = 0;
 
-		if (task)
-			set_tsk_thread_flag(task, TIF_DS_AREA_MSR);
-
-		if (!task || (task == current))
-			wrmsrl(MSR_IA32_DS_AREA, (unsigned long)context->ds);
-
 		*p_context = context;
 	}
 
 	context->count++;
 
-	spin_unlock_irqrestore(&ds_lock, irq);
+	spin_unlock_irq(&ds_lock);
 
 	if (context != new_context)
 		kfree(new_context);
@@ -275,8 +304,9 @@ static inline struct ds_context *ds_get_context(struct task_struct *task)
 	return context;
 }
 
-static inline void ds_put_context(struct ds_context *context)
+static void ds_put_context(struct ds_context *context)
 {
+	struct task_struct *task;
 	unsigned long irq;
 
 	if (!context)
@@ -291,17 +321,55 @@ static inline void ds_put_context(struct ds_context *context)
 
 	*(context->this) = NULL;
 
-	if (context->task)
-		clear_tsk_thread_flag(context->task, TIF_DS_AREA_MSR);
+	task = context->task;
+
+	if (task)
+		clear_tsk_thread_flag(task, TIF_DS_AREA_MSR);
 
-	if (!context->task || (context->task == current))
-		wrmsrl(MSR_IA32_DS_AREA, 0);
+	/*
+	 * We leave the (now dangling) pointer to the DS configuration in
+	 * the DS_AREA msr. This is as good or as bad as replacing it with
+	 * NULL - the hardware would crash if we enabled tracing.
+	 *
+	 * This saves us some problems with having to write an msr on a
+	 * different cpu while preventing others from doing the same for the
+	 * next context for that same cpu.
+	 */
 
 	spin_unlock_irqrestore(&ds_lock, irq);
 
+	/* The context might still be in use for context switching. */
+	if (task && (task != current))
+		wait_task_context_switch(task);
+
 	kfree(context);
 }
 
+static void ds_install_ds_area(struct ds_context *context)
+{
+	unsigned long ds;
+
+	ds = (unsigned long)context->ds;
+
+	/*
+	 * There is a race between the bts master and the pebs master.
+	 *
+	 * The thread/cpu access is synchronized via get/put_cpu() for
+	 * task tracing and via wrmsr_on_cpu for cpu tracing.
+	 *
+	 * If bts and pebs are collected for the same task or same cpu,
+	 * the same confiuration is written twice.
+	 */
+	if (context->task) {
+		get_cpu();
+		if (context->task == current)
+			wrmsrl(MSR_IA32_DS_AREA, ds);
+		set_tsk_thread_flag(context->task, TIF_DS_AREA_MSR);
+		put_cpu();
+	} else
+		wrmsr_on_cpu(context->cpu, MSR_IA32_DS_AREA,
+			     (u32)((u64)ds), (u32)((u64)ds >> 32));
+}
 
 /*
  * Call the tracer's callback on a buffer overflow.
@@ -332,9 +400,9 @@ static void ds_overflow(struct ds_context *context, enum ds_qualifier qual)
  * The remainder of any partially written record is zeroed out.
  *
  * context: the DS context
- * qual: the buffer type
- * record: the data to write
- * size: the size of the data
+ * qual:    the buffer type
+ * record:  the data to write
+ * size:    the size of the data
  */
 static int ds_write(struct ds_context *context, enum ds_qualifier qual,
 		    const void *record, size_t size)
@@ -349,14 +417,14 @@ static int ds_write(struct ds_context *context, enum ds_qualifier qual,
 		unsigned long write_size, adj_write_size;
 
 		/*
-		 * write as much as possible without producing an
+		 * Write as much as possible without producing an
 		 * overflow interrupt.
 		 *
-		 * interrupt_threshold must either be
+		 * Interrupt_threshold must either be
 		 * - bigger than absolute_maximum or
 		 * - point to a record between buffer_base and absolute_maximum
 		 *
-		 * index points to a valid record.
+		 * Index points to a valid record.
 		 */
 		base   = ds_get(context->ds, qual, ds_buffer_base);
 		index  = ds_get(context->ds, qual, ds_index);
@@ -365,8 +433,10 @@ static int ds_write(struct ds_context *context, enum ds_qualifier qual,
 
 		write_end = min(end, int_th);
 
-		/* if we are already beyond the interrupt threshold,
-		 * we fill the entire buffer */
+		/*
+		 * If we are already beyond the interrupt threshold,
+		 * we fill the entire buffer.
+		 */
 		if (write_end <= index)
 			write_end = end;
 
@@ -383,7 +453,7 @@ static int ds_write(struct ds_context *context, enum ds_qualifier qual,
 		adj_write_size = write_size / ds_cfg.sizeof_rec[qual];
 		adj_write_size *= ds_cfg.sizeof_rec[qual];
 
-		/* zero out trailing bytes */
+		/* Zero out trailing bytes. */
 		memset((char *)index + write_size, 0,
 		       adj_write_size - write_size);
 		index += adj_write_size;
@@ -410,7 +480,7 @@ static int ds_write(struct ds_context *context, enum ds_qualifier qual,
  * Later architectures use 64bit pointers throughout, whereas earlier
  * architectures use 32bit pointers in 32bit mode.
  *
- * We compute the base address for the first 8 fields based on:
+ * We compute the base address for the fields based on:
  * - the field size stored in the DS configuration
  * - the relative field position
  *
@@ -431,23 +501,23 @@ enum bts_field {
 	bts_to,
 	bts_flags,
 
-	bts_qual = bts_from,
-	bts_jiffies = bts_to,
-	bts_pid = bts_flags,
+	bts_qual		= bts_from,
+	bts_clock		= bts_to,
+	bts_pid			= bts_flags,
 
-	bts_qual_mask = (bts_qual_max - 1),
-	bts_escape = ((unsigned long)-1 & ~bts_qual_mask)
+	bts_qual_mask		= (bts_qual_max - 1),
+	bts_escape		= ((unsigned long)-1 & ~bts_qual_mask)
 };
 
 static inline unsigned long bts_get(const char *base, enum bts_field field)
 {
-	base += (ds_cfg.sizeof_field * field);
+	base += (ds_cfg.sizeof_ptr_field * field);
 	return *(unsigned long *)base;
 }
 
 static inline void bts_set(char *base, enum bts_field field, unsigned long val)
 {
-	base += (ds_cfg.sizeof_field * field);;
+	base += (ds_cfg.sizeof_ptr_field * field);;
 	(*(unsigned long *)base) = val;
 }
 
@@ -463,8 +533,8 @@ static inline void bts_set(char *base, enum bts_field field, unsigned long val)
  *
  * return: bytes read/written on success; -Eerrno, otherwise
  */
-static int bts_read(struct bts_tracer *tracer, const void *at,
-		    struct bts_struct *out)
+static int
+bts_read(struct bts_tracer *tracer, const void *at, struct bts_struct *out)
 {
 	if (!tracer)
 		return -EINVAL;
@@ -478,8 +548,8 @@ static int bts_read(struct bts_tracer *tracer, const void *at,
 	memset(out, 0, sizeof(*out));
 	if ((bts_get(at, bts_qual) & ~bts_qual_mask) == bts_escape) {
 		out->qualifier = (bts_get(at, bts_qual) & bts_qual_mask);
-		out->variant.timestamp.jiffies = bts_get(at, bts_jiffies);
-		out->variant.timestamp.pid = bts_get(at, bts_pid);
+		out->variant.event.clock = bts_get(at, bts_clock);
+		out->variant.event.pid = bts_get(at, bts_pid);
 	} else {
 		out->qualifier = bts_branch;
 		out->variant.lbr.from = bts_get(at, bts_from);
@@ -516,8 +586,8 @@ static int bts_write(struct bts_tracer *tracer, const struct bts_struct *in)
 	case bts_task_arrives:
 	case bts_task_departs:
 		bts_set(raw, bts_qual, (bts_escape | in->qualifier));
-		bts_set(raw, bts_jiffies, in->variant.timestamp.jiffies);
-		bts_set(raw, bts_pid, in->variant.timestamp.pid);
+		bts_set(raw, bts_clock, in->variant.event.clock);
+		bts_set(raw, bts_pid, in->variant.event.pid);
 		break;
 	default:
 		return -EINVAL;
@@ -555,7 +625,8 @@ static void ds_init_ds_trace(struct ds_trace *trace, enum ds_qualifier qual,
 			     unsigned int flags) {
 	unsigned long buffer, adj;
 
-	/* adjust the buffer address and size to meet alignment
+	/*
+	 * Adjust the buffer address and size to meet alignment
 	 * constraints:
 	 * - buffer is double-word aligned
 	 * - size is multiple of record size
@@ -577,9 +648,11 @@ static void ds_init_ds_trace(struct ds_trace *trace, enum ds_qualifier qual,
 	trace->begin = (void *)buffer;
 	trace->top = trace->begin;
 	trace->end = (void *)(buffer + size);
-	/* The value for 'no threshold' is -1, which will set the
+	/*
+	 * The value for 'no threshold' is -1, which will set the
 	 * threshold outside of the buffer, just like we want it.
 	 */
+	ith *= ds_cfg.sizeof_rec[qual];
 	trace->ith = (void *)(buffer + size - ith);
 
 	trace->flags = flags;
@@ -588,18 +661,27 @@ static void ds_init_ds_trace(struct ds_trace *trace, enum ds_qualifier qual,
 
 static int ds_request(struct ds_tracer *tracer, struct ds_trace *trace,
 		      enum ds_qualifier qual, struct task_struct *task,
-		      void *base, size_t size, size_t th, unsigned int flags)
+		      int cpu, void *base, size_t size, size_t th)
 {
 	struct ds_context *context;
 	int error;
+	size_t req_size;
+
+	error = -EOPNOTSUPP;
+	if (!ds_cfg.sizeof_rec[qual])
+		goto out;
 
 	error = -EINVAL;
 	if (!base)
 		goto out;
 
-	/* we require some space to do alignment adjustments below */
+	req_size = ds_cfg.sizeof_rec[qual];
+	/* We might need space for alignment adjustments. */
+	if (!IS_ALIGNED((unsigned long)base, DS_ALIGNMENT))
+		req_size += DS_ALIGNMENT;
+
 	error = -EINVAL;
-	if (size < (DS_ALIGNMENT + ds_cfg.sizeof_rec[qual]))
+	if (size < req_size)
 		goto out;
 
 	if (th != (size_t)-1) {
@@ -614,182 +696,318 @@ static int ds_request(struct ds_tracer *tracer, struct ds_trace *trace,
 	tracer->size = size;
 
 	error = -ENOMEM;
-	context = ds_get_context(task);
+	context = ds_get_context(task, cpu);
 	if (!context)
 		goto out;
 	tracer->context = context;
 
-	ds_init_ds_trace(trace, qual, base, size, th, flags);
+	/*
+	 * Defer any tracer-specific initialization work for the context until
+	 * context ownership has been clarified.
+	 */
 
 	error = 0;
  out:
 	return error;
 }
 
-struct bts_tracer *ds_request_bts(struct task_struct *task,
-				  void *base, size_t size,
-				  bts_ovfl_callback_t ovfl, size_t th,
-				  unsigned int flags)
+static struct bts_tracer *ds_request_bts(struct task_struct *task, int cpu,
+					 void *base, size_t size,
+					 bts_ovfl_callback_t ovfl, size_t th,
+					 unsigned int flags)
 {
 	struct bts_tracer *tracer;
-	unsigned long irq;
 	int error;
 
+	/* Buffer overflow notification is not yet implemented. */
 	error = -EOPNOTSUPP;
-	if (!ds_cfg.ctl[dsf_bts])
+	if (ovfl)
 		goto out;
 
-	/* buffer overflow notification is not yet implemented */
-	error = -EOPNOTSUPP;
-	if (ovfl)
+	error = get_tracer(task);
+	if (error < 0)
 		goto out;
 
 	error = -ENOMEM;
 	tracer = kzalloc(sizeof(*tracer), GFP_KERNEL);
 	if (!tracer)
-		goto out;
+		goto out_put_tracer;
 	tracer->ovfl = ovfl;
 
+	/* Do some more error checking and acquire a tracing context. */
 	error = ds_request(&tracer->ds, &tracer->trace.ds,
-			   ds_bts, task, base, size, th, flags);
+			   ds_bts, task, cpu, base, size, th);
 	if (error < 0)
 		goto out_tracer;
 
-
-	spin_lock_irqsave(&ds_lock, irq);
-
-	error = -EPERM;
-	if (!check_tracer(task))
-		goto out_unlock;
-	get_tracer(task);
+	/* Claim the bts part of the tracing context we acquired above. */
+	spin_lock_irq(&ds_lock);
 
 	error = -EPERM;
 	if (tracer->ds.context->bts_master)
-		goto out_put_tracer;
+		goto out_unlock;
 	tracer->ds.context->bts_master = tracer;
 
-	spin_unlock_irqrestore(&ds_lock, irq);
+	spin_unlock_irq(&ds_lock);
 
+	/*
+	 * Now that we own the bts part of the context, let's complete the
+	 * initialization for that part.
+	 */
+	ds_init_ds_trace(&tracer->trace.ds, ds_bts, base, size, th, flags);
+	ds_write_config(tracer->ds.context, &tracer->trace.ds, ds_bts);
+	ds_install_ds_area(tracer->ds.context);
 
 	tracer->trace.read  = bts_read;
 	tracer->trace.write = bts_write;
 
-	ds_write_config(tracer->ds.context, &tracer->trace.ds, ds_bts);
+	/* Start tracing. */
 	ds_resume_bts(tracer);
 
 	return tracer;
 
- out_put_tracer:
-	put_tracer(task);
  out_unlock:
-	spin_unlock_irqrestore(&ds_lock, irq);
+	spin_unlock_irq(&ds_lock);
 	ds_put_context(tracer->ds.context);
  out_tracer:
 	kfree(tracer);
+ out_put_tracer:
+	put_tracer(task);
  out:
 	return ERR_PTR(error);
 }
 
-struct pebs_tracer *ds_request_pebs(struct task_struct *task,
-				    void *base, size_t size,
-				    pebs_ovfl_callback_t ovfl, size_t th,
-				    unsigned int flags)
+struct bts_tracer *ds_request_bts_task(struct task_struct *task,
+				       void *base, size_t size,
+				       bts_ovfl_callback_t ovfl,
+				       size_t th, unsigned int flags)
+{
+	return ds_request_bts(task, 0, base, size, ovfl, th, flags);
+}
+
+struct bts_tracer *ds_request_bts_cpu(int cpu, void *base, size_t size,
+				      bts_ovfl_callback_t ovfl,
+				      size_t th, unsigned int flags)
+{
+	return ds_request_bts(NULL, cpu, base, size, ovfl, th, flags);
+}
+
+static struct pebs_tracer *ds_request_pebs(struct task_struct *task, int cpu,
+					   void *base, size_t size,
+					   pebs_ovfl_callback_t ovfl, size_t th,
+					   unsigned int flags)
 {
 	struct pebs_tracer *tracer;
-	unsigned long irq;
 	int error;
 
-	/* buffer overflow notification is not yet implemented */
+	/* Buffer overflow notification is not yet implemented. */
 	error = -EOPNOTSUPP;
 	if (ovfl)
 		goto out;
 
+	error = get_tracer(task);
+	if (error < 0)
+		goto out;
+
 	error = -ENOMEM;
 	tracer = kzalloc(sizeof(*tracer), GFP_KERNEL);
 	if (!tracer)
-		goto out;
+		goto out_put_tracer;
 	tracer->ovfl = ovfl;
 
+	/* Do some more error checking and acquire a tracing context. */
 	error = ds_request(&tracer->ds, &tracer->trace.ds,
-			   ds_pebs, task, base, size, th, flags);
+			   ds_pebs, task, cpu, base, size, th);
 	if (error < 0)
 		goto out_tracer;
 
-	spin_lock_irqsave(&ds_lock, irq);
-
-	error = -EPERM;
-	if (!check_tracer(task))
-		goto out_unlock;
-	get_tracer(task);
+	/* Claim the pebs part of the tracing context we acquired above. */
+	spin_lock_irq(&ds_lock);
 
 	error = -EPERM;
 	if (tracer->ds.context->pebs_master)
-		goto out_put_tracer;
+		goto out_unlock;
 	tracer->ds.context->pebs_master = tracer;
 
-	spin_unlock_irqrestore(&ds_lock, irq);
+	spin_unlock_irq(&ds_lock);
 
+	/*
+	 * Now that we own the pebs part of the context, let's complete the
+	 * initialization for that part.
+	 */
+	ds_init_ds_trace(&tracer->trace.ds, ds_pebs, base, size, th, flags);
 	ds_write_config(tracer->ds.context, &tracer->trace.ds, ds_pebs);
+	ds_install_ds_area(tracer->ds.context);
+
+	/* Start tracing. */
 	ds_resume_pebs(tracer);
 
 	return tracer;
 
- out_put_tracer:
-	put_tracer(task);
  out_unlock:
-	spin_unlock_irqrestore(&ds_lock, irq);
+	spin_unlock_irq(&ds_lock);
 	ds_put_context(tracer->ds.context);
  out_tracer:
 	kfree(tracer);
+ out_put_tracer:
+	put_tracer(task);
  out:
 	return ERR_PTR(error);
 }
 
-void ds_release_bts(struct bts_tracer *tracer)
+struct pebs_tracer *ds_request_pebs_task(struct task_struct *task,
+					 void *base, size_t size,
+					 pebs_ovfl_callback_t ovfl,
+					 size_t th, unsigned int flags)
 {
-	if (!tracer)
-		return;
+	return ds_request_pebs(task, 0, base, size, ovfl, th, flags);
+}
 
-	ds_suspend_bts(tracer);
+struct pebs_tracer *ds_request_pebs_cpu(int cpu, void *base, size_t size,
+					pebs_ovfl_callback_t ovfl,
+					size_t th, unsigned int flags)
+{
+	return ds_request_pebs(NULL, cpu, base, size, ovfl, th, flags);
+}
+
+static void ds_free_bts(struct bts_tracer *tracer)
+{
+	struct task_struct *task;
+
+	task = tracer->ds.context->task;
 
 	WARN_ON_ONCE(tracer->ds.context->bts_master != tracer);
 	tracer->ds.context->bts_master = NULL;
 
-	put_tracer(tracer->ds.context->task);
+	/* Make sure tracing stopped and the tracer is not in use. */
+	if (task && (task != current))
+		wait_task_context_switch(task);
+
 	ds_put_context(tracer->ds.context);
+	put_tracer(task);
 
 	kfree(tracer);
 }
 
+void ds_release_bts(struct bts_tracer *tracer)
+{
+	might_sleep();
+
+	if (!tracer)
+		return;
+
+	ds_suspend_bts(tracer);
+	ds_free_bts(tracer);
+}
+
+int ds_release_bts_noirq(struct bts_tracer *tracer)
+{
+	struct task_struct *task;
+	unsigned long irq;
+	int error;
+
+	if (!tracer)
+		return 0;
+
+	task = tracer->ds.context->task;
+
+	local_irq_save(irq);
+
+	error = -EPERM;
+	if (!task &&
+	    (tracer->ds.context->cpu != smp_processor_id()))
+		goto out;
+
+	error = -EPERM;
+	if (task && (task != current))
+		goto out;
+
+	ds_suspend_bts_noirq(tracer);
+	ds_free_bts(tracer);
+
+	error = 0;
+ out:
+	local_irq_restore(irq);
+	return error;
+}
+
+static void update_task_debugctlmsr(struct task_struct *task,
+				    unsigned long debugctlmsr)
+{
+	task->thread.debugctlmsr = debugctlmsr;
+
+	get_cpu();
+	if (task == current)
+		update_debugctlmsr(debugctlmsr);
+	put_cpu();
+}
+
 void ds_suspend_bts(struct bts_tracer *tracer)
 {
 	struct task_struct *task;
+	unsigned long debugctlmsr;
+	int cpu;
 
 	if (!tracer)
 		return;
 
+	tracer->flags = 0;
+
 	task = tracer->ds.context->task;
+	cpu  = tracer->ds.context->cpu;
 
-	if (!task || (task == current))
-		update_debugctlmsr(get_debugctlmsr() & ~BTS_CONTROL);
+	WARN_ON(!task && irqs_disabled());
 
-	if (task) {
-		task->thread.debugctlmsr &= ~BTS_CONTROL;
+	debugctlmsr = (task ?
+		       task->thread.debugctlmsr :
+		       get_debugctlmsr_on_cpu(cpu));
+	debugctlmsr &= ~BTS_CONTROL;
 
-		if (!task->thread.debugctlmsr)
-			clear_tsk_thread_flag(task, TIF_DEBUGCTLMSR);
-	}
+	if (task)
+		update_task_debugctlmsr(task, debugctlmsr);
+	else
+		update_debugctlmsr_on_cpu(cpu, debugctlmsr);
 }
 
-void ds_resume_bts(struct bts_tracer *tracer)
+int ds_suspend_bts_noirq(struct bts_tracer *tracer)
 {
 	struct task_struct *task;
-	unsigned long control;
+	unsigned long debugctlmsr, irq;
+	int cpu, error = 0;
 
 	if (!tracer)
-		return;
+		return 0;
+
+	tracer->flags = 0;
 
 	task = tracer->ds.context->task;
+	cpu  = tracer->ds.context->cpu;
+
+	local_irq_save(irq);
+
+	error = -EPERM;
+	if (!task && (cpu != smp_processor_id()))
+		goto out;
+
+	debugctlmsr = (task ?
+		       task->thread.debugctlmsr :
+		       get_debugctlmsr());
+	debugctlmsr &= ~BTS_CONTROL;
+
+	if (task)
+		update_task_debugctlmsr(task, debugctlmsr);
+	else
+		update_debugctlmsr(debugctlmsr);
+
+	error = 0;
+ out:
+	local_irq_restore(irq);
+	return error;
+}
+
+static unsigned long ds_bts_control(struct bts_tracer *tracer)
+{
+	unsigned long control;
 
 	control = ds_cfg.ctl[dsf_bts];
 	if (!(tracer->trace.ds.flags & BTS_KERNEL))
@@ -797,41 +1015,149 @@ void ds_resume_bts(struct bts_tracer *tracer)
 	if (!(tracer->trace.ds.flags & BTS_USER))
 		control |= ds_cfg.ctl[dsf_bts_user];
 
-	if (task) {
-		task->thread.debugctlmsr |= control;
-		set_tsk_thread_flag(task, TIF_DEBUGCTLMSR);
-	}
-
-	if (!task || (task == current))
-		update_debugctlmsr(get_debugctlmsr() | control);
+	return control;
 }
 
-void ds_release_pebs(struct pebs_tracer *tracer)
+void ds_resume_bts(struct bts_tracer *tracer)
 {
+	struct task_struct *task;
+	unsigned long debugctlmsr;
+	int cpu;
+
 	if (!tracer)
 		return;
 
-	ds_suspend_pebs(tracer);
+	tracer->flags = tracer->trace.ds.flags;
+
+	task = tracer->ds.context->task;
+	cpu  = tracer->ds.context->cpu;
+
+	WARN_ON(!task && irqs_disabled());
+
+	debugctlmsr = (task ?
+		       task->thread.debugctlmsr :
+		       get_debugctlmsr_on_cpu(cpu));
+	debugctlmsr |= ds_bts_control(tracer);
+
+	if (task)
+		update_task_debugctlmsr(task, debugctlmsr);
+	else
+		update_debugctlmsr_on_cpu(cpu, debugctlmsr);
+}
+
+int ds_resume_bts_noirq(struct bts_tracer *tracer)
+{
+	struct task_struct *task;
+	unsigned long debugctlmsr, irq;
+	int cpu, error = 0;
+
+	if (!tracer)
+		return 0;
+
+	tracer->flags = tracer->trace.ds.flags;
+
+	task = tracer->ds.context->task;
+	cpu  = tracer->ds.context->cpu;
+
+	local_irq_save(irq);
+
+	error = -EPERM;
+	if (!task && (cpu != smp_processor_id()))
+		goto out;
+
+	debugctlmsr = (task ?
+		       task->thread.debugctlmsr :
+		       get_debugctlmsr());
+	debugctlmsr |= ds_bts_control(tracer);
+
+	if (task)
+		update_task_debugctlmsr(task, debugctlmsr);
+	else
+		update_debugctlmsr(debugctlmsr);
+
+	error = 0;
+ out:
+	local_irq_restore(irq);
+	return error;
+}
+
+static void ds_free_pebs(struct pebs_tracer *tracer)
+{
+	struct task_struct *task;
+
+	task = tracer->ds.context->task;
 
 	WARN_ON_ONCE(tracer->ds.context->pebs_master != tracer);
 	tracer->ds.context->pebs_master = NULL;
 
-	put_tracer(tracer->ds.context->task);
 	ds_put_context(tracer->ds.context);
+	put_tracer(task);
 
 	kfree(tracer);
 }
 
+void ds_release_pebs(struct pebs_tracer *tracer)
+{
+	might_sleep();
+
+	if (!tracer)
+		return;
+
+	ds_suspend_pebs(tracer);
+	ds_free_pebs(tracer);
+}
+
+int ds_release_pebs_noirq(struct pebs_tracer *tracer)
+{
+	struct task_struct *task;
+	unsigned long irq;
+	int error;
+
+	if (!tracer)
+		return 0;
+
+	task = tracer->ds.context->task;
+
+	local_irq_save(irq);
+
+	error = -EPERM;
+	if (!task &&
+	    (tracer->ds.context->cpu != smp_processor_id()))
+		goto out;
+
+	error = -EPERM;
+	if (task && (task != current))
+		goto out;
+
+	ds_suspend_pebs_noirq(tracer);
+	ds_free_pebs(tracer);
+
+	error = 0;
+ out:
+	local_irq_restore(irq);
+	return error;
+}
+
 void ds_suspend_pebs(struct pebs_tracer *tracer)
 {
 
 }
 
+int ds_suspend_pebs_noirq(struct pebs_tracer *tracer)
+{
+	return 0;
+}
+
 void ds_resume_pebs(struct pebs_tracer *tracer)
 {
 
 }
 
+int ds_resume_pebs_noirq(struct pebs_tracer *tracer)
+{
+	return 0;
+}
+
 const struct bts_trace *ds_read_bts(struct bts_tracer *tracer)
 {
 	if (!tracer)
@@ -847,8 +1173,12 @@ const struct pebs_trace *ds_read_pebs(struct pebs_tracer *tracer)
 		return NULL;
 
 	ds_read_config(tracer->ds.context, &tracer->trace.ds, ds_pebs);
-	tracer->trace.reset_value =
-		*(u64 *)(tracer->ds.context->ds + (ds_cfg.sizeof_field * 8));
+
+	tracer->trace.counters = ds_cfg.nr_counter_reset;
+	memcpy(tracer->trace.counter_reset,
+	       tracer->ds.context->ds +
+	       (NUM_DS_PTR_FIELDS * ds_cfg.sizeof_ptr_field),
+	       ds_cfg.nr_counter_reset * PEBS_RESET_FIELD_SIZE);
 
 	return &tracer->trace;
 }
@@ -873,18 +1203,24 @@ int ds_reset_pebs(struct pebs_tracer *tracer)
 
 	tracer->trace.ds.top = tracer->trace.ds.begin;
 
-	ds_set(tracer->ds.context->ds, ds_bts, ds_index,
+	ds_set(tracer->ds.context->ds, ds_pebs, ds_index,
 	       (unsigned long)tracer->trace.ds.top);
 
 	return 0;
 }
 
-int ds_set_pebs_reset(struct pebs_tracer *tracer, u64 value)
+int ds_set_pebs_reset(struct pebs_tracer *tracer,
+		      unsigned int counter, u64 value)
 {
 	if (!tracer)
 		return -EINVAL;
 
-	*(u64 *)(tracer->ds.context->ds + (ds_cfg.sizeof_field * 8)) = value;
+	if (ds_cfg.nr_counter_reset < counter)
+		return -EINVAL;
+
+	*(u64 *)(tracer->ds.context->ds +
+		 (NUM_DS_PTR_FIELDS * ds_cfg.sizeof_ptr_field) +
+		 (counter * PEBS_RESET_FIELD_SIZE)) = value;
 
 	return 0;
 }
@@ -894,73 +1230,117 @@ static const struct ds_configuration ds_cfg_netburst = {
 	.ctl[dsf_bts]		= (1 << 2) | (1 << 3),
 	.ctl[dsf_bts_kernel]	= (1 << 5),
 	.ctl[dsf_bts_user]	= (1 << 6),
-
-	.sizeof_field		= sizeof(long),
-	.sizeof_rec[ds_bts]	= sizeof(long) * 3,
-#ifdef __i386__
-	.sizeof_rec[ds_pebs]	= sizeof(long) * 10,
-#else
-	.sizeof_rec[ds_pebs]	= sizeof(long) * 18,
-#endif
+	.nr_counter_reset	= 1,
 };
 static const struct ds_configuration ds_cfg_pentium_m = {
 	.name = "Pentium M",
 	.ctl[dsf_bts]		= (1 << 6) | (1 << 7),
-
-	.sizeof_field		= sizeof(long),
-	.sizeof_rec[ds_bts]	= sizeof(long) * 3,
-#ifdef __i386__
-	.sizeof_rec[ds_pebs]	= sizeof(long) * 10,
-#else
-	.sizeof_rec[ds_pebs]	= sizeof(long) * 18,
-#endif
+	.nr_counter_reset	= 1,
 };
 static const struct ds_configuration ds_cfg_core2_atom = {
 	.name = "Core 2/Atom",
 	.ctl[dsf_bts]		= (1 << 6) | (1 << 7),
 	.ctl[dsf_bts_kernel]	= (1 << 9),
 	.ctl[dsf_bts_user]	= (1 << 10),
-
-	.sizeof_field		= 8,
-	.sizeof_rec[ds_bts]	= 8 * 3,
-	.sizeof_rec[ds_pebs]	= 8 * 18,
+	.nr_counter_reset	= 1,
+};
+static const struct ds_configuration ds_cfg_core_i7 = {
+	.name = "Core i7",
+	.ctl[dsf_bts]		= (1 << 6) | (1 << 7),
+	.ctl[dsf_bts_kernel]	= (1 << 9),
+	.ctl[dsf_bts_user]	= (1 << 10),
+	.nr_counter_reset	= 4,
 };
 
 static void
-ds_configure(const struct ds_configuration *cfg)
+ds_configure(const struct ds_configuration *cfg,
+	     struct cpuinfo_x86 *cpu)
 {
+	unsigned long nr_pebs_fields = 0;
+
+	printk(KERN_INFO "[ds] using %s configuration\n", cfg->name);
+
+#ifdef __i386__
+	nr_pebs_fields = 10;
+#else
+	nr_pebs_fields = 18;
+#endif
+
+	/*
+	 * Starting with version 2, architectural performance
+	 * monitoring supports a format specifier.
+	 */
+	if ((cpuid_eax(0xa) & 0xff) > 1) {
+		unsigned long perf_capabilities, format;
+
+		rdmsrl(MSR_IA32_PERF_CAPABILITIES, perf_capabilities);
+
+		format = (perf_capabilities >> 8) & 0xf;
+
+		switch (format) {
+		case 0:
+			nr_pebs_fields = 18;
+			break;
+		case 1:
+			nr_pebs_fields = 22;
+			break;
+		default:
+			printk(KERN_INFO
+			       "[ds] unknown PEBS format: %lu\n", format);
+			nr_pebs_fields = 0;
+			break;
+		}
+	}
+
 	memset(&ds_cfg, 0, sizeof(ds_cfg));
 	ds_cfg = *cfg;
 
-	printk(KERN_INFO "[ds] using %s configuration\n", ds_cfg.name);
+	ds_cfg.sizeof_ptr_field =
+		(cpu_has(cpu, X86_FEATURE_DTES64) ? 8 : 4);
+
+	ds_cfg.sizeof_rec[ds_bts]  = ds_cfg.sizeof_ptr_field * 3;
+	ds_cfg.sizeof_rec[ds_pebs] = ds_cfg.sizeof_ptr_field * nr_pebs_fields;
 
-	if (!cpu_has_bts) {
-		ds_cfg.ctl[dsf_bts] = 0;
+	if (!cpu_has(cpu, X86_FEATURE_BTS)) {
+		ds_cfg.sizeof_rec[ds_bts] = 0;
 		printk(KERN_INFO "[ds] bts not available\n");
 	}
-	if (!cpu_has_pebs)
+	if (!cpu_has(cpu, X86_FEATURE_PEBS)) {
+		ds_cfg.sizeof_rec[ds_pebs] = 0;
 		printk(KERN_INFO "[ds] pebs not available\n");
+	}
+
+	printk(KERN_INFO "[ds] sizes: address: %u bit, ",
+	       8 * ds_cfg.sizeof_ptr_field);
+	printk("bts/pebs record: %u/%u bytes\n",
+	       ds_cfg.sizeof_rec[ds_bts], ds_cfg.sizeof_rec[ds_pebs]);
 
-	WARN_ON_ONCE(MAX_SIZEOF_DS < (12 * ds_cfg.sizeof_field));
+	WARN_ON_ONCE(MAX_PEBS_COUNTERS < ds_cfg.nr_counter_reset);
 }
 
 void __cpuinit ds_init_intel(struct cpuinfo_x86 *c)
 {
+	/* Only configure the first cpu. Others are identical. */
+	if (ds_cfg.name)
+		return;
+
 	switch (c->x86) {
 	case 0x6:
 		switch (c->x86_model) {
 		case 0x9:
 		case 0xd: /* Pentium M */
-			ds_configure(&ds_cfg_pentium_m);
+			ds_configure(&ds_cfg_pentium_m, c);
 			break;
 		case 0xf:
 		case 0x17: /* Core2 */
 		case 0x1c: /* Atom */
-			ds_configure(&ds_cfg_core2_atom);
+			ds_configure(&ds_cfg_core2_atom, c);
+			break;
+		case 0x1a: /* Core i7 */
+			ds_configure(&ds_cfg_core_i7, c);
 			break;
-		case 0x1a: /* i7 */
 		default:
-			/* sorry, don't know about them */
+			/* Sorry, don't know about them. */
 			break;
 		}
 		break;
@@ -969,64 +1349,89 @@ void __cpuinit ds_init_intel(struct cpuinfo_x86 *c)
 		case 0x0:
 		case 0x1:
 		case 0x2: /* Netburst */
-			ds_configure(&ds_cfg_netburst);
+			ds_configure(&ds_cfg_netburst, c);
 			break;
 		default:
-			/* sorry, don't know about them */
+			/* Sorry, don't know about them. */
 			break;
 		}
 		break;
 	default:
-		/* sorry, don't know about them */
+		/* Sorry, don't know about them. */
 		break;
 	}
 }
 
+static inline void ds_take_timestamp(struct ds_context *context,
+				     enum bts_qualifier qualifier,
+				     struct task_struct *task)
+{
+	struct bts_tracer *tracer = context->bts_master;
+	struct bts_struct ts;
+
+	/* Prevent compilers from reading the tracer pointer twice. */
+	barrier();
+
+	if (!tracer || !(tracer->flags & BTS_TIMESTAMPS))
+		return;
+
+	memset(&ts, 0, sizeof(ts));
+	ts.qualifier		= qualifier;
+	ts.variant.event.clock	= trace_clock_global();
+	ts.variant.event.pid	= task->pid;
+
+	bts_write(tracer, &ts);
+}
+
 /*
  * Change the DS configuration from tracing prev to tracing next.
  */
 void ds_switch_to(struct task_struct *prev, struct task_struct *next)
 {
-	struct ds_context *prev_ctx = prev->thread.ds_ctx;
-	struct ds_context *next_ctx = next->thread.ds_ctx;
+	struct ds_context *prev_ctx	= prev->thread.ds_ctx;
+	struct ds_context *next_ctx	= next->thread.ds_ctx;
+	unsigned long debugctlmsr	= next->thread.debugctlmsr;
+
+	/* Make sure all data is read before we start. */
+	barrier();
 
 	if (prev_ctx) {
 		update_debugctlmsr(0);
 
-		if (prev_ctx->bts_master &&
-		    (prev_ctx->bts_master->trace.ds.flags & BTS_TIMESTAMPS)) {
-			struct bts_struct ts = {
-				.qualifier = bts_task_departs,
-				.variant.timestamp.jiffies = jiffies_64,
-				.variant.timestamp.pid = prev->pid
-			};
-			bts_write(prev_ctx->bts_master, &ts);
-		}
+		ds_take_timestamp(prev_ctx, bts_task_departs, prev);
 	}
 
 	if (next_ctx) {
-		if (next_ctx->bts_master &&
-		    (next_ctx->bts_master->trace.ds.flags & BTS_TIMESTAMPS)) {
-			struct bts_struct ts = {
-				.qualifier = bts_task_arrives,
-				.variant.timestamp.jiffies = jiffies_64,
-				.variant.timestamp.pid = next->pid
-			};
-			bts_write(next_ctx->bts_master, &ts);
-		}
+		ds_take_timestamp(next_ctx, bts_task_arrives, next);
 
 		wrmsrl(MSR_IA32_DS_AREA, (unsigned long)next_ctx->ds);
 	}
 
-	update_debugctlmsr(next->thread.debugctlmsr);
+	update_debugctlmsr(debugctlmsr);
 }
 
-void ds_copy_thread(struct task_struct *tsk, struct task_struct *father)
+static __init int ds_selftest(void)
 {
-	clear_tsk_thread_flag(tsk, TIF_DS_AREA_MSR);
-	tsk->thread.ds_ctx = NULL;
-}
+	if (ds_cfg.sizeof_rec[ds_bts]) {
+		int error;
 
-void ds_exit_thread(struct task_struct *tsk)
-{
+		error = ds_selftest_bts();
+		if (error) {
+			WARN(1, "[ds] selftest failed. disabling bts.\n");
+			ds_cfg.sizeof_rec[ds_bts] = 0;
+		}
+	}
+
+	if (ds_cfg.sizeof_rec[ds_pebs]) {
+		int error;
+
+		error = ds_selftest_pebs();
+		if (error) {
+			WARN(1, "[ds] selftest failed. disabling pebs.\n");
+			ds_cfg.sizeof_rec[ds_pebs] = 0;
+		}
+	}
+
+	return 0;
 }
+device_initcall(ds_selftest);
diff --git a/arch/x86/kernel/ds_selftest.c b/arch/x86/kernel/ds_selftest.c
new file mode 100644
index 0000000..6bc7c19
--- /dev/null
+++ b/arch/x86/kernel/ds_selftest.c
@@ -0,0 +1,408 @@
+/*
+ * Debug Store support - selftest
+ *
+ *
+ * Copyright (C) 2009 Intel Corporation.
+ * Markus Metzger <markus.t.metzger@intel.com>, 2009
+ */
+
+#include "ds_selftest.h"
+
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/smp.h>
+#include <linux/cpu.h>
+
+#include <asm/ds.h>
+
+
+#define BUFFER_SIZE		521	/* Intentionally chose an odd size. */
+#define SMALL_BUFFER_SIZE	24	/* A single bts entry. */
+
+struct ds_selftest_bts_conf {
+	struct bts_tracer *tracer;
+	int error;
+	int (*suspend)(struct bts_tracer *);
+	int (*resume)(struct bts_tracer *);
+};
+
+static int ds_selftest_bts_consistency(const struct bts_trace *trace)
+{
+	int error = 0;
+
+	if (!trace) {
+		printk(KERN_CONT "failed to access trace...");
+		/* Bail out. Other tests are pointless. */
+		return -1;
+	}
+
+	if (!trace->read) {
+		printk(KERN_CONT "bts read not available...");
+		error = -1;
+	}
+
+	/* Do some sanity checks on the trace configuration. */
+	if (!trace->ds.n) {
+		printk(KERN_CONT "empty bts buffer...");
+		error = -1;
+	}
+	if (!trace->ds.size) {
+		printk(KERN_CONT "bad bts trace setup...");
+		error = -1;
+	}
+	if (trace->ds.end !=
+	    (char *)trace->ds.begin + (trace->ds.n * trace->ds.size)) {
+		printk(KERN_CONT "bad bts buffer setup...");
+		error = -1;
+	}
+	/*
+	 * We allow top in [begin; end], since its not clear when the
+	 * overflow adjustment happens: after the increment or before the
+	 * write.
+	 */
+	if ((trace->ds.top < trace->ds.begin) ||
+	    (trace->ds.end < trace->ds.top)) {
+		printk(KERN_CONT "bts top out of bounds...");
+		error = -1;
+	}
+
+	return error;
+}
+
+static int ds_selftest_bts_read(struct bts_tracer *tracer,
+				const struct bts_trace *trace,
+				const void *from, const void *to)
+{
+	const unsigned char *at;
+
+	/*
+	 * Check a few things which do not belong to this test.
+	 * They should be covered by other tests.
+	 */
+	if (!trace)
+		return -1;
+
+	if (!trace->read)
+		return -1;
+
+	if (to < from)
+		return -1;
+
+	if (from < trace->ds.begin)
+		return -1;
+
+	if (trace->ds.end < to)
+		return -1;
+
+	if (!trace->ds.size)
+		return -1;
+
+	/* Now to the test itself. */
+	for (at = from; (void *)at < to; at += trace->ds.size) {
+		struct bts_struct bts;
+		unsigned long index;
+		int error;
+
+		if (((void *)at - trace->ds.begin) % trace->ds.size) {
+			printk(KERN_CONT
+			       "read from non-integer index...");
+			return -1;
+		}
+		index = ((void *)at - trace->ds.begin) / trace->ds.size;
+
+		memset(&bts, 0, sizeof(bts));
+		error = trace->read(tracer, at, &bts);
+		if (error < 0) {
+			printk(KERN_CONT
+			       "error reading bts trace at [%lu] (0x%p)...",
+			       index, at);
+			return error;
+		}
+
+		switch (bts.qualifier) {
+		case BTS_BRANCH:
+			break;
+		default:
+			printk(KERN_CONT
+			       "unexpected bts entry %llu at [%lu] (0x%p)...",
+			       bts.qualifier, index, at);
+			return -1;
+		}
+	}
+
+	return 0;
+}
+
+static void ds_selftest_bts_cpu(void *arg)
+{
+	struct ds_selftest_bts_conf *conf = arg;
+	const struct bts_trace *trace;
+	void *top;
+
+	if (IS_ERR(conf->tracer)) {
+		conf->error = PTR_ERR(conf->tracer);
+		conf->tracer = NULL;
+
+		printk(KERN_CONT
+		       "initialization failed (err: %d)...", conf->error);
+		return;
+	}
+
+	/* We should meanwhile have enough trace. */
+	conf->error = conf->suspend(conf->tracer);
+	if (conf->error < 0)
+		return;
+
+	/* Let's see if we can access the trace. */
+	trace = ds_read_bts(conf->tracer);
+
+	conf->error = ds_selftest_bts_consistency(trace);
+	if (conf->error < 0)
+		return;
+
+	/* If everything went well, we should have a few trace entries. */
+	if (trace->ds.top == trace->ds.begin) {
+		/*
+		 * It is possible but highly unlikely that we got a
+		 * buffer overflow and end up at exactly the same
+		 * position we started from.
+		 * Let's issue a warning, but continue.
+		 */
+		printk(KERN_CONT "no trace/overflow...");
+	}
+
+	/* Let's try to read the trace we collected. */
+	conf->error =
+		ds_selftest_bts_read(conf->tracer, trace,
+				     trace->ds.begin, trace->ds.top);
+	if (conf->error < 0)
+		return;
+
+	/*
+	 * Let's read the trace again.
+	 * Since we suspended tracing, we should get the same result.
+	 */
+	top = trace->ds.top;
+
+	trace = ds_read_bts(conf->tracer);
+	conf->error = ds_selftest_bts_consistency(trace);
+	if (conf->error < 0)
+		return;
+
+	if (top != trace->ds.top) {
+		printk(KERN_CONT "suspend not working...");
+		conf->error = -1;
+		return;
+	}
+
+	/* Let's collect some more trace - see if resume is working. */
+	conf->error = conf->resume(conf->tracer);
+	if (conf->error < 0)
+		return;
+
+	conf->error = conf->suspend(conf->tracer);
+	if (conf->error < 0)
+		return;
+
+	trace = ds_read_bts(conf->tracer);
+
+	conf->error = ds_selftest_bts_consistency(trace);
+	if (conf->error < 0)
+		return;
+
+	if (trace->ds.top == top) {
+		/*
+		 * It is possible but highly unlikely that we got a
+		 * buffer overflow and end up at exactly the same
+		 * position we started from.
+		 * Let's issue a warning and check the full trace.
+		 */
+		printk(KERN_CONT
+		       "no resume progress/overflow...");
+
+		conf->error =
+			ds_selftest_bts_read(conf->tracer, trace,
+					     trace->ds.begin, trace->ds.end);
+	} else if (trace->ds.top < top) {
+		/*
+		 * We had a buffer overflow - the entire buffer should
+		 * contain trace records.
+		 */
+		conf->error =
+			ds_selftest_bts_read(conf->tracer, trace,
+					     trace->ds.begin, trace->ds.end);
+	} else {
+		/*
+		 * It is quite likely that the buffer did not overflow.
+		 * Let's just check the delta trace.
+		 */
+		conf->error =
+			ds_selftest_bts_read(conf->tracer, trace, top,
+					     trace->ds.top);
+	}
+	if (conf->error < 0)
+		return;
+
+	conf->error = 0;
+}
+
+static int ds_suspend_bts_wrap(struct bts_tracer *tracer)
+{
+	ds_suspend_bts(tracer);
+	return 0;
+}
+
+static int ds_resume_bts_wrap(struct bts_tracer *tracer)
+{
+	ds_resume_bts(tracer);
+	return 0;
+}
+
+static void ds_release_bts_noirq_wrap(void *tracer)
+{
+	(void)ds_release_bts_noirq(tracer);
+}
+
+static int ds_selftest_bts_bad_release_noirq(int cpu,
+					     struct bts_tracer *tracer)
+{
+	int error = -EPERM;
+
+	/* Try to release the tracer on the wrong cpu. */
+	get_cpu();
+	if (cpu != smp_processor_id()) {
+		error = ds_release_bts_noirq(tracer);
+		if (error != -EPERM)
+			printk(KERN_CONT "release on wrong cpu...");
+	}
+	put_cpu();
+
+	return error ? 0 : -1;
+}
+
+static int ds_selftest_bts_bad_request_cpu(int cpu, void *buffer)
+{
+	struct bts_tracer *tracer;
+	int error;
+
+	/* Try to request cpu tracing while task tracing is active. */
+	tracer = ds_request_bts_cpu(cpu, buffer, BUFFER_SIZE, NULL,
+				    (size_t)-1, BTS_KERNEL);
+	error = PTR_ERR(tracer);
+	if (!IS_ERR(tracer)) {
+		ds_release_bts(tracer);
+		error = 0;
+	}
+
+	if (error != -EPERM)
+		printk(KERN_CONT "cpu/task tracing overlap...");
+
+	return error ? 0 : -1;
+}
+
+static int ds_selftest_bts_bad_request_task(void *buffer)
+{
+	struct bts_tracer *tracer;
+	int error;
+
+	/* Try to request cpu tracing while task tracing is active. */
+	tracer = ds_request_bts_task(current, buffer, BUFFER_SIZE, NULL,
+				    (size_t)-1, BTS_KERNEL);
+	error = PTR_ERR(tracer);
+	if (!IS_ERR(tracer)) {
+		error = 0;
+		ds_release_bts(tracer);
+	}
+
+	if (error != -EPERM)
+		printk(KERN_CONT "task/cpu tracing overlap...");
+
+	return error ? 0 : -1;
+}
+
+int ds_selftest_bts(void)
+{
+	struct ds_selftest_bts_conf conf;
+	unsigned char buffer[BUFFER_SIZE], *small_buffer;
+	unsigned long irq;
+	int cpu;
+
+	printk(KERN_INFO "[ds] bts selftest...");
+	conf.error = 0;
+
+	small_buffer = (unsigned char *)ALIGN((unsigned long)buffer, 8) + 8;
+
+	get_online_cpus();
+	for_each_online_cpu(cpu) {
+		conf.suspend = ds_suspend_bts_wrap;
+		conf.resume = ds_resume_bts_wrap;
+		conf.tracer =
+			ds_request_bts_cpu(cpu, buffer, BUFFER_SIZE,
+					   NULL, (size_t)-1, BTS_KERNEL);
+		ds_selftest_bts_cpu(&conf);
+		if (conf.error >= 0)
+			conf.error = ds_selftest_bts_bad_request_task(buffer);
+		ds_release_bts(conf.tracer);
+		if (conf.error < 0)
+			goto out;
+
+		conf.suspend = ds_suspend_bts_noirq;
+		conf.resume = ds_resume_bts_noirq;
+		conf.tracer =
+			ds_request_bts_cpu(cpu, buffer, BUFFER_SIZE,
+					   NULL, (size_t)-1, BTS_KERNEL);
+		smp_call_function_single(cpu, ds_selftest_bts_cpu, &conf, 1);
+		if (conf.error >= 0) {
+			conf.error =
+				ds_selftest_bts_bad_release_noirq(cpu,
+								  conf.tracer);
+			/* We must not release the tracer twice. */
+			if (conf.error < 0)
+				conf.tracer = NULL;
+		}
+		if (conf.error >= 0)
+			conf.error = ds_selftest_bts_bad_request_task(buffer);
+		smp_call_function_single(cpu, ds_release_bts_noirq_wrap,
+					 conf.tracer, 1);
+		if (conf.error < 0)
+			goto out;
+	}
+
+	conf.suspend = ds_suspend_bts_wrap;
+	conf.resume = ds_resume_bts_wrap;
+	conf.tracer =
+		ds_request_bts_task(current, buffer, BUFFER_SIZE,
+				    NULL, (size_t)-1, BTS_KERNEL);
+	ds_selftest_bts_cpu(&conf);
+	if (conf.error >= 0)
+		conf.error = ds_selftest_bts_bad_request_cpu(0, buffer);
+	ds_release_bts(conf.tracer);
+	if (conf.error < 0)
+		goto out;
+
+	conf.suspend = ds_suspend_bts_noirq;
+	conf.resume = ds_resume_bts_noirq;
+	conf.tracer =
+		ds_request_bts_task(current, small_buffer, SMALL_BUFFER_SIZE,
+				   NULL, (size_t)-1, BTS_KERNEL);
+	local_irq_save(irq);
+	ds_selftest_bts_cpu(&conf);
+	if (conf.error >= 0)
+		conf.error = ds_selftest_bts_bad_request_cpu(0, buffer);
+	ds_release_bts_noirq(conf.tracer);
+	local_irq_restore(irq);
+	if (conf.error < 0)
+		goto out;
+
+	conf.error = 0;
+ out:
+	put_online_cpus();
+	printk(KERN_CONT "%s.\n", (conf.error ? "failed" : "passed"));
+
+	return conf.error;
+}
+
+int ds_selftest_pebs(void)
+{
+	return 0;
+}
diff --git a/arch/x86/kernel/ds_selftest.h b/arch/x86/kernel/ds_selftest.h
new file mode 100644
index 0000000..2ba8745
--- /dev/null
+++ b/arch/x86/kernel/ds_selftest.h
@@ -0,0 +1,15 @@
+/*
+ * Debug Store support - selftest
+ *
+ *
+ * Copyright (C) 2009 Intel Corporation.
+ * Markus Metzger <markus.t.metzger@intel.com>, 2009
+ */
+
+#ifdef CONFIG_X86_DS_SELFTEST
+extern int ds_selftest_bts(void);
+extern int ds_selftest_pebs(void);
+#else
+static inline int ds_selftest_bts(void) { return 0; }
+static inline int ds_selftest_pebs(void) { return 0; }
+#endif
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 38946c6..987f91f 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -147,27 +147,14 @@ END(ftrace_graph_caller)
 GLOBAL(return_to_handler)
 	subq  $80, %rsp
 
+	/* Save the return values */
 	movq %rax, (%rsp)
-	movq %rcx, 8(%rsp)
-	movq %rdx, 16(%rsp)
-	movq %rsi, 24(%rsp)
-	movq %rdi, 32(%rsp)
-	movq %r8, 40(%rsp)
-	movq %r9, 48(%rsp)
-	movq %r10, 56(%rsp)
-	movq %r11, 64(%rsp)
+	movq %rdx, 8(%rsp)
 
 	call ftrace_return_to_handler
 
 	movq %rax, 72(%rsp)
-	movq 64(%rsp), %r11
-	movq 56(%rsp), %r10
-	movq 48(%rsp), %r9
-	movq 40(%rsp), %r8
-	movq 32(%rsp), %rdi
-	movq 24(%rsp), %rsi
-	movq 16(%rsp), %rdx
-	movq 8(%rsp), %rcx
+	movq 8(%rsp), %rdx
 	movq (%rsp), %rax
 	addq $72, %rsp
 	retq
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index ca98915..fb5dfb8 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -14,6 +14,7 @@
 #include <asm/idle.h>
 #include <asm/uaccess.h>
 #include <asm/i387.h>
+#include <asm/ds.h>
 
 unsigned long idle_halt;
 EXPORT_SYMBOL(idle_halt);
@@ -45,6 +46,8 @@ void free_thread_xstate(struct task_struct *tsk)
 		kmem_cache_free(task_xstate_cachep, tsk->thread.xstate);
 		tsk->thread.xstate = NULL;
 	}
+
+	WARN(tsk->thread.ds_ctx, "leaking DS context\n");
 }
 
 void free_thread_info(struct thread_info *ti)
@@ -83,8 +86,6 @@ void exit_thread(void)
 		put_cpu();
 		kfree(bp);
 	}
-
-	ds_exit_thread(current);
 }
 
 void flush_thread(void)
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 76f8f84..b5e4bfe 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -290,7 +290,8 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 		p->thread.io_bitmap_max = 0;
 	}
 
-	ds_copy_thread(p, current);
+	clear_tsk_thread_flag(p, TIF_DS_AREA_MSR);
+	p->thread.ds_ctx = NULL;
 
 	clear_tsk_thread_flag(p, TIF_DEBUGCTLMSR);
 	p->thread.debugctlmsr = 0;
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index b751a41..5a1a1de 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -335,7 +335,8 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 			goto out;
 	}
 
-	ds_copy_thread(p, me);
+	clear_tsk_thread_flag(p, TIF_DS_AREA_MSR);
+	p->thread.ds_ctx = NULL;
 
 	clear_tsk_thread_flag(p, TIF_DEBUGCTLMSR);
 	p->thread.debugctlmsr = 0;
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 23b7c8f..09ecbde 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -21,6 +21,7 @@
 #include <linux/audit.h>
 #include <linux/seccomp.h>
 #include <linux/signal.h>
+#include <linux/workqueue.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -578,17 +579,130 @@ static int ioperm_get(struct task_struct *target,
 }
 
 #ifdef CONFIG_X86_PTRACE_BTS
+/*
+ * A branch trace store context.
+ *
+ * Contexts may only be installed by ptrace_bts_config() and only for
+ * ptraced tasks.
+ *
+ * Contexts are destroyed when the tracee is detached from the tracer.
+ * The actual destruction work requires interrupts enabled, so the
+ * work is deferred and will be scheduled during __ptrace_unlink().
+ *
+ * Contexts hold an additional task_struct reference on the traced
+ * task, as well as a reference on the tracer's mm.
+ *
+ * Ptrace already holds a task_struct for the duration of ptrace operations,
+ * but since destruction is deferred, it may be executed after both
+ * tracer and tracee exited.
+ */
+struct bts_context {
+	/* The branch trace handle. */
+	struct bts_tracer	*tracer;
+
+	/* The buffer used to store the branch trace and its size. */
+	void			*buffer;
+	unsigned int		size;
+
+	/* The mm that paid for the above buffer. */
+	struct mm_struct	*mm;
+
+	/* The task this context belongs to. */
+	struct task_struct	*task;
+
+	/* The signal to send on a bts buffer overflow. */
+	unsigned int		bts_ovfl_signal;
+
+	/* The work struct to destroy a context. */
+	struct work_struct	work;
+};
+
+static int alloc_bts_buffer(struct bts_context *context, unsigned int size)
+{
+	void *buffer = NULL;
+	int err = -ENOMEM;
+
+	err = account_locked_memory(current->mm, current->signal->rlim, size);
+	if (err < 0)
+		return err;
+
+	buffer = kzalloc(size, GFP_KERNEL);
+	if (!buffer)
+		goto out_refund;
+
+	context->buffer = buffer;
+	context->size = size;
+	context->mm = get_task_mm(current);
+
+	return 0;
+
+ out_refund:
+	refund_locked_memory(current->mm, size);
+	return err;
+}
+
+static inline void free_bts_buffer(struct bts_context *context)
+{
+	if (!context->buffer)
+		return;
+
+	kfree(context->buffer);
+	context->buffer = NULL;
+
+	refund_locked_memory(context->mm, context->size);
+	context->size = 0;
+
+	mmput(context->mm);
+	context->mm = NULL;
+}
+
+static void free_bts_context_work(struct work_struct *w)
+{
+	struct bts_context *context;
+
+	context = container_of(w, struct bts_context, work);
+
+	ds_release_bts(context->tracer);
+	put_task_struct(context->task);
+	free_bts_buffer(context);
+	kfree(context);
+}
+
+static inline void free_bts_context(struct bts_context *context)
+{
+	INIT_WORK(&context->work, free_bts_context_work);
+	schedule_work(&context->work);
+}
+
+static inline struct bts_context *alloc_bts_context(struct task_struct *task)
+{
+	struct bts_context *context = kzalloc(sizeof(*context), GFP_KERNEL);
+	if (context) {
+		context->task = task;
+		task->bts = context;
+
+		get_task_struct(task);
+	}
+
+	return context;
+}
+
 static int ptrace_bts_read_record(struct task_struct *child, size_t index,
 				  struct bts_struct __user *out)
 {
+	struct bts_context *context;
 	const struct bts_trace *trace;
 	struct bts_struct bts;
 	const unsigned char *at;
 	int error;
 
-	trace = ds_read_bts(child->bts);
+	context = child->bts;
+	if (!context)
+		return -ESRCH;
+
+	trace = ds_read_bts(context->tracer);
 	if (!trace)
-		return -EPERM;
+		return -ESRCH;
 
 	at = trace->ds.top - ((index + 1) * trace->ds.size);
 	if ((void *)at < trace->ds.begin)
@@ -597,7 +711,7 @@ static int ptrace_bts_read_record(struct task_struct *child, size_t index,
 	if (!trace->read)
 		return -EOPNOTSUPP;
 
-	error = trace->read(child->bts, at, &bts);
+	error = trace->read(context->tracer, at, &bts);
 	if (error < 0)
 		return error;
 
@@ -611,13 +725,18 @@ static int ptrace_bts_drain(struct task_struct *child,
 			    long size,
 			    struct bts_struct __user *out)
 {
+	struct bts_context *context;
 	const struct bts_trace *trace;
 	const unsigned char *at;
 	int error, drained = 0;
 
-	trace = ds_read_bts(child->bts);
+	context = child->bts;
+	if (!context)
+		return -ESRCH;
+
+	trace = ds_read_bts(context->tracer);
 	if (!trace)
-		return -EPERM;
+		return -ESRCH;
 
 	if (!trace->read)
 		return -EOPNOTSUPP;
@@ -628,9 +747,8 @@ static int ptrace_bts_drain(struct task_struct *child,
 	for (at = trace->ds.begin; (void *)at < trace->ds.top;
 	     out++, drained++, at += trace->ds.size) {
 		struct bts_struct bts;
-		int error;
 
-		error = trace->read(child->bts, at, &bts);
+		error = trace->read(context->tracer, at, &bts);
 		if (error < 0)
 			return error;
 
@@ -640,35 +758,18 @@ static int ptrace_bts_drain(struct task_struct *child,
 
 	memset(trace->ds.begin, 0, trace->ds.n * trace->ds.size);
 
-	error = ds_reset_bts(child->bts);
+	error = ds_reset_bts(context->tracer);
 	if (error < 0)
 		return error;
 
 	return drained;
 }
 
-static int ptrace_bts_allocate_buffer(struct task_struct *child, size_t size)
-{
-	child->bts_buffer = alloc_locked_buffer(size);
-	if (!child->bts_buffer)
-		return -ENOMEM;
-
-	child->bts_size = size;
-
-	return 0;
-}
-
-static void ptrace_bts_free_buffer(struct task_struct *child)
-{
-	free_locked_buffer(child->bts_buffer, child->bts_size);
-	child->bts_buffer = NULL;
-	child->bts_size = 0;
-}
-
 static int ptrace_bts_config(struct task_struct *child,
 			     long cfg_size,
 			     const struct ptrace_bts_config __user *ucfg)
 {
+	struct bts_context *context;
 	struct ptrace_bts_config cfg;
 	unsigned int flags = 0;
 
@@ -678,28 +779,33 @@ static int ptrace_bts_config(struct task_struct *child,
 	if (copy_from_user(&cfg, ucfg, sizeof(cfg)))
 		return -EFAULT;
 
-	if (child->bts) {
-		ds_release_bts(child->bts);
-		child->bts = NULL;
-	}
+	context = child->bts;
+	if (!context)
+		context = alloc_bts_context(child);
+	if (!context)
+		return -ENOMEM;
 
 	if (cfg.flags & PTRACE_BTS_O_SIGNAL) {
 		if (!cfg.signal)
 			return -EINVAL;
 
-		child->thread.bts_ovfl_signal = cfg.signal;
 		return -EOPNOTSUPP;
+		context->bts_ovfl_signal = cfg.signal;
 	}
 
-	if ((cfg.flags & PTRACE_BTS_O_ALLOC) &&
-	    (cfg.size != child->bts_size)) {
-		int error;
+	ds_release_bts(context->tracer);
+	context->tracer = NULL;
 
-		ptrace_bts_free_buffer(child);
+	if ((cfg.flags & PTRACE_BTS_O_ALLOC) && (cfg.size != context->size)) {
+		int err;
 
-		error = ptrace_bts_allocate_buffer(child, cfg.size);
-		if (error < 0)
-			return error;
+		free_bts_buffer(context);
+		if (!cfg.size)
+			return 0;
+
+		err = alloc_bts_buffer(context, cfg.size);
+		if (err < 0)
+			return err;
 	}
 
 	if (cfg.flags & PTRACE_BTS_O_TRACE)
@@ -708,15 +814,14 @@ static int ptrace_bts_config(struct task_struct *child,
 	if (cfg.flags & PTRACE_BTS_O_SCHED)
 		flags |= BTS_TIMESTAMPS;
 
-	child->bts = ds_request_bts(child, child->bts_buffer, child->bts_size,
-				    /* ovfl = */ NULL, /* th = */ (size_t)-1,
-				    flags);
-	if (IS_ERR(child->bts)) {
-		int error = PTR_ERR(child->bts);
-
-		ptrace_bts_free_buffer(child);
-		child->bts = NULL;
+	context->tracer =
+		ds_request_bts_task(child, context->buffer, context->size,
+				    NULL, (size_t)-1, flags);
+	if (unlikely(IS_ERR(context->tracer))) {
+		int error = PTR_ERR(context->tracer);
 
+		free_bts_buffer(context);
+		context->tracer = NULL;
 		return error;
 	}
 
@@ -727,20 +832,25 @@ static int ptrace_bts_status(struct task_struct *child,
 			     long cfg_size,
 			     struct ptrace_bts_config __user *ucfg)
 {
+	struct bts_context *context;
 	const struct bts_trace *trace;
 	struct ptrace_bts_config cfg;
 
+	context = child->bts;
+	if (!context)
+		return -ESRCH;
+
 	if (cfg_size < sizeof(cfg))
 		return -EIO;
 
-	trace = ds_read_bts(child->bts);
+	trace = ds_read_bts(context->tracer);
 	if (!trace)
-		return -EPERM;
+		return -ESRCH;
 
 	memset(&cfg, 0, sizeof(cfg));
-	cfg.size = trace->ds.end - trace->ds.begin;
-	cfg.signal = child->thread.bts_ovfl_signal;
-	cfg.bts_size = sizeof(struct bts_struct);
+	cfg.size	= trace->ds.end - trace->ds.begin;
+	cfg.signal	= context->bts_ovfl_signal;
+	cfg.bts_size	= sizeof(struct bts_struct);
 
 	if (cfg.signal)
 		cfg.flags |= PTRACE_BTS_O_SIGNAL;
@@ -759,80 +869,51 @@ static int ptrace_bts_status(struct task_struct *child,
 
 static int ptrace_bts_clear(struct task_struct *child)
 {
+	struct bts_context *context;
 	const struct bts_trace *trace;
 
-	trace = ds_read_bts(child->bts);
+	context = child->bts;
+	if (!context)
+		return -ESRCH;
+
+	trace = ds_read_bts(context->tracer);
 	if (!trace)
-		return -EPERM;
+		return -ESRCH;
 
 	memset(trace->ds.begin, 0, trace->ds.n * trace->ds.size);
 
-	return ds_reset_bts(child->bts);
+	return ds_reset_bts(context->tracer);
 }
 
 static int ptrace_bts_size(struct task_struct *child)
 {
+	struct bts_context *context;
 	const struct bts_trace *trace;
 
-	trace = ds_read_bts(child->bts);
+	context = child->bts;
+	if (!context)
+		return -ESRCH;
+
+	trace = ds_read_bts(context->tracer);
 	if (!trace)
-		return -EPERM;
+		return -ESRCH;
 
 	return (trace->ds.top - trace->ds.begin) / trace->ds.size;
 }
 
-static void ptrace_bts_fork(struct task_struct *tsk)
-{
-	tsk->bts = NULL;
-	tsk->bts_buffer = NULL;
-	tsk->bts_size = 0;
-	tsk->thread.bts_ovfl_signal = 0;
-}
-
-static void ptrace_bts_untrace(struct task_struct *child)
+/*
+ * Called from __ptrace_unlink() after the child has been moved back
+ * to its original parent.
+ */
+void ptrace_bts_untrace(struct task_struct *child)
 {
 	if (unlikely(child->bts)) {
-		ds_release_bts(child->bts);
+		free_bts_context(child->bts);
 		child->bts = NULL;
-
-		/* We cannot update total_vm and locked_vm since
-		   child's mm is already gone. But we can reclaim the
-		   memory. */
-		kfree(child->bts_buffer);
-		child->bts_buffer = NULL;
-		child->bts_size = 0;
 	}
 }
-
-static void ptrace_bts_detach(struct task_struct *child)
-{
-	/*
-	 * Ptrace_detach() races with ptrace_untrace() in case
-	 * the child dies and is reaped by another thread.
-	 *
-	 * We only do the memory accounting at this point and
-	 * leave the buffer deallocation and the bts tracer
-	 * release to ptrace_bts_untrace() which will be called
-	 * later on with tasklist_lock held.
-	 */
-	release_locked_buffer(child->bts_buffer, child->bts_size);
-}
-#else
-static inline void ptrace_bts_fork(struct task_struct *tsk) {}
-static inline void ptrace_bts_detach(struct task_struct *child) {}
-static inline void ptrace_bts_untrace(struct task_struct *child) {}
 #endif /* CONFIG_X86_PTRACE_BTS */
 
-void x86_ptrace_fork(struct task_struct *child, unsigned long clone_flags)
-{
-	ptrace_bts_fork(child);
-}
-
-void x86_ptrace_untrace(struct task_struct *child)
-{
-	ptrace_bts_untrace(child);
-}
-
 /*
  * Called by kernel/ptrace.c when detaching..
  *
@@ -844,7 +925,6 @@ void ptrace_disable(struct task_struct *child)
 #ifdef TIF_SYSCALL_EMU
 	clear_tsk_thread_flag(child, TIF_SYSCALL_EMU);
 #endif
-	ptrace_bts_detach(child);
 }
 
 #if defined CONFIG_X86_32 || defined CONFIG_IA32_EMULATION
diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
index f7bddc2..4aaf7e4 100644
--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -20,7 +20,7 @@ save_stack_warning_symbol(void *data, char *msg, unsigned long symbol)
 
 static int save_stack_stack(void *data, char *name)
 {
-	return -1;
+	return 0;
 }
 
 static void save_stack_address(void *data, unsigned long addr, int reliable)
diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
index 50dc802..16ccbd7 100644
--- a/arch/x86/mm/kmmio.c
+++ b/arch/x86/mm/kmmio.c
@@ -32,7 +32,7 @@ struct kmmio_fault_page {
 	struct list_head list;
 	struct kmmio_fault_page *release_next;
 	unsigned long page; /* location of the fault page */
-	bool old_presence; /* page presence prior to arming */
+	pteval_t old_presence; /* page presence prior to arming */
 	bool armed;
 
 	/*
@@ -97,60 +97,62 @@ static struct kmmio_probe *get_kmmio_probe(unsigned long addr)
 static struct kmmio_fault_page *get_kmmio_fault_page(unsigned long page)
 {
 	struct list_head *head;
-	struct kmmio_fault_page *p;
+	struct kmmio_fault_page *f;
 
 	page &= PAGE_MASK;
 	head = kmmio_page_list(page);
-	list_for_each_entry_rcu(p, head, list) {
-		if (p->page == page)
-			return p;
+	list_for_each_entry_rcu(f, head, list) {
+		if (f->page == page)
+			return f;
 	}
 	return NULL;
 }
 
-static void set_pmd_presence(pmd_t *pmd, bool present, bool *old)
+static void clear_pmd_presence(pmd_t *pmd, bool clear, pmdval_t *old)
 {
 	pmdval_t v = pmd_val(*pmd);
-	*old = !!(v & _PAGE_PRESENT);
-	v &= ~_PAGE_PRESENT;
-	if (present)
-		v |= _PAGE_PRESENT;
+	if (clear) {
+		*old = v & _PAGE_PRESENT;
+		v &= ~_PAGE_PRESENT;
+	} else	/* presume this has been called with clear==true previously */
+		v |= *old;
 	set_pmd(pmd, __pmd(v));
 }
 
-static void set_pte_presence(pte_t *pte, bool present, bool *old)
+static void clear_pte_presence(pte_t *pte, bool clear, pteval_t *old)
 {
 	pteval_t v = pte_val(*pte);
-	*old = !!(v & _PAGE_PRESENT);
-	v &= ~_PAGE_PRESENT;
-	if (present)
-		v |= _PAGE_PRESENT;
+	if (clear) {
+		*old = v & _PAGE_PRESENT;
+		v &= ~_PAGE_PRESENT;
+	} else	/* presume this has been called with clear==true previously */
+		v |= *old;
 	set_pte_atomic(pte, __pte(v));
 }
 
-static int set_page_presence(unsigned long addr, bool present, bool *old)
+static int clear_page_presence(struct kmmio_fault_page *f, bool clear)
 {
 	unsigned int level;
-	pte_t *pte = lookup_address(addr, &level);
+	pte_t *pte = lookup_address(f->page, &level);
 
 	if (!pte) {
-		pr_err("kmmio: no pte for page 0x%08lx\n", addr);
+		pr_err("kmmio: no pte for page 0x%08lx\n", f->page);
 		return -1;
 	}
 
 	switch (level) {
 	case PG_LEVEL_2M:
-		set_pmd_presence((pmd_t *)pte, present, old);
+		clear_pmd_presence((pmd_t *)pte, clear, &f->old_presence);
 		break;
 	case PG_LEVEL_4K:
-		set_pte_presence(pte, present, old);
+		clear_pte_presence(pte, clear, &f->old_presence);
 		break;
 	default:
 		pr_err("kmmio: unexpected page level 0x%x.\n", level);
 		return -1;
 	}
 
-	__flush_tlb_one(addr);
+	__flush_tlb_one(f->page);
 	return 0;
 }
 
@@ -171,9 +173,9 @@ static int arm_kmmio_fault_page(struct kmmio_fault_page *f)
 	WARN_ONCE(f->armed, KERN_ERR "kmmio page already armed.\n");
 	if (f->armed) {
 		pr_warning("kmmio double-arm: page 0x%08lx, ref %d, old %d\n",
-					f->page, f->count, f->old_presence);
+					f->page, f->count, !!f->old_presence);
 	}
-	ret = set_page_presence(f->page, false, &f->old_presence);
+	ret = clear_page_presence(f, true);
 	WARN_ONCE(ret < 0, KERN_ERR "kmmio arming 0x%08lx failed.\n", f->page);
 	f->armed = true;
 	return ret;
@@ -182,8 +184,7 @@ static int arm_kmmio_fault_page(struct kmmio_fault_page *f)
 /** Restore the given page to saved presence state. */
 static void disarm_kmmio_fault_page(struct kmmio_fault_page *f)
 {
-	bool tmp;
-	int ret = set_page_presence(f->page, f->old_presence, &tmp);
+	int ret = clear_page_presence(f, false);
 	WARN_ONCE(ret < 0,
 			KERN_ERR "kmmio disarming 0x%08lx failed.\n", f->page);
 	f->armed = false;
@@ -310,7 +311,12 @@ static int post_kmmio_handler(unsigned long condition, struct pt_regs *regs)
 	struct kmmio_context *ctx = &get_cpu_var(kmmio_ctx);
 
 	if (!ctx->active) {
-		pr_debug("kmmio: spurious debug trap on CPU %d.\n",
+		/*
+		 * debug traps without an active context are due to either
+		 * something external causing them (f.e. using a debugger while
+		 * mmio tracing enabled), or erroneous behaviour
+		 */
+		pr_warning("kmmio: unexpected debug trap on CPU %d.\n",
 							smp_processor_id());
 		goto out;
 	}
@@ -439,12 +445,12 @@ static void rcu_free_kmmio_fault_pages(struct rcu_head *head)
 						head,
 						struct kmmio_delayed_release,
 						rcu);
-	struct kmmio_fault_page *p = dr->release_list;
-	while (p) {
-		struct kmmio_fault_page *next = p->release_next;
-		BUG_ON(p->count);
-		kfree(p);
-		p = next;
+	struct kmmio_fault_page *f = dr->release_list;
+	while (f) {
+		struct kmmio_fault_page *next = f->release_next;
+		BUG_ON(f->count);
+		kfree(f);
+		f = next;
 	}
 	kfree(dr);
 }
@@ -453,19 +459,19 @@ static void remove_kmmio_fault_pages(struct rcu_head *head)
 {
 	struct kmmio_delayed_release *dr =
 		container_of(head, struct kmmio_delayed_release, rcu);
-	struct kmmio_fault_page *p = dr->release_list;
+	struct kmmio_fault_page *f = dr->release_list;
 	struct kmmio_fault_page **prevp = &dr->release_list;
 	unsigned long flags;
 
 	spin_lock_irqsave(&kmmio_lock, flags);
-	while (p) {
-		if (!p->count) {
-			list_del_rcu(&p->list);
-			prevp = &p->release_next;
+	while (f) {
+		if (!f->count) {
+			list_del_rcu(&f->list);
+			prevp = &f->release_next;
 		} else {
-			*prevp = p->release_next;
+			*prevp = f->release_next;
 		}
-		p = p->release_next;
+		f = f->release_next;
 	}
 	spin_unlock_irqrestore(&kmmio_lock, flags);
 
@@ -528,8 +534,8 @@ void unregister_kmmio_probe(struct kmmio_probe *p)
 }
 EXPORT_SYMBOL(unregister_kmmio_probe);
 
-static int kmmio_die_notifier(struct notifier_block *nb, unsigned long val,
-								void *args)
+static int
+kmmio_die_notifier(struct notifier_block *nb, unsigned long val, void *args)
 {
 	struct die_args *arg = args;
 
@@ -544,11 +550,23 @@ static struct notifier_block nb_die = {
 	.notifier_call = kmmio_die_notifier
 };
 
-static int __init init_kmmio(void)
+int kmmio_init(void)
 {
 	int i;
+
 	for (i = 0; i < KMMIO_PAGE_TABLE_SIZE; i++)
 		INIT_LIST_HEAD(&kmmio_page_table[i]);
+
 	return register_die_notifier(&nb_die);
 }
-fs_initcall(init_kmmio); /* should be before device_initcall() */
+
+void kmmio_cleanup(void)
+{
+	int i;
+
+	unregister_die_notifier(&nb_die);
+	for (i = 0; i < KMMIO_PAGE_TABLE_SIZE; i++) {
+		WARN_ONCE(!list_empty(&kmmio_page_table[i]),
+			KERN_ERR "kmmio_page_table not empty at cleanup, any further tracing will leak memory.\n");
+	}
+}
diff --git a/arch/x86/mm/mmio-mod.c b/arch/x86/mm/mmio-mod.c
index c9342ed..132772a 100644
--- a/arch/x86/mm/mmio-mod.c
+++ b/arch/x86/mm/mmio-mod.c
@@ -451,6 +451,7 @@ void enable_mmiotrace(void)
 
 	if (nommiotrace)
 		pr_info(NAME "MMIO tracing disabled.\n");
+	kmmio_init();
 	enter_uniprocessor();
 	spin_lock_irq(&trace_lock);
 	atomic_inc(&mmiotrace_enabled);
@@ -473,6 +474,7 @@ void disable_mmiotrace(void)
 
 	clear_trace_list(); /* guarantees: no more kmmio callbacks */
 	leave_uniprocessor();
+	kmmio_cleanup();
 	pr_info(NAME "disabled.\n");
 out:
 	mutex_unlock(&mmiotrace_mutex);
diff --git a/block/blk-core.c b/block/blk-core.c
index c89883b..9475bf9 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -28,22 +28,14 @@
 #include <linux/task_io_accounting_ops.h>
 #include <linux/blktrace_api.h>
 #include <linux/fault-inject.h>
-#include <trace/block.h>
+
+#define CREATE_TRACE_POINTS
+#include <trace/events/block.h>
 
 #include "blk.h"
 
-DEFINE_TRACE(block_plug);
-DEFINE_TRACE(block_unplug_io);
-DEFINE_TRACE(block_unplug_timer);
-DEFINE_TRACE(block_getrq);
-DEFINE_TRACE(block_sleeprq);
-DEFINE_TRACE(block_rq_requeue);
-DEFINE_TRACE(block_bio_backmerge);
-DEFINE_TRACE(block_bio_frontmerge);
-DEFINE_TRACE(block_bio_queue);
-DEFINE_TRACE(block_rq_complete);
-DEFINE_TRACE(block_remap);	/* Also used in drivers/md/dm.c */
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_remap);
+EXPORT_TRACEPOINT_SYMBOL_GPL(block_bio_complete);
 
 static int __make_request(struct request_queue *q, struct bio *bio);
 
@@ -1277,7 +1269,7 @@ static inline void blk_partition_remap(struct bio *bio)
 		bio->bi_bdev = bdev->bd_contains;
 
 		trace_block_remap(bdev_get_queue(bio->bi_bdev), bio,
-				    bdev->bd_dev, bio->bi_sector,
+				    bdev->bd_dev,
 				    bio->bi_sector - p->start_sect);
 	}
 }
@@ -1446,8 +1438,7 @@ static inline void __generic_make_request(struct bio *bio)
 			goto end_io;
 
 		if (old_sector != -1)
-			trace_block_remap(q, bio, old_dev, bio->bi_sector,
-					    old_sector);
+			trace_block_remap(q, bio, old_dev, old_sector);
 
 		trace_block_bio_queue(q, bio);
 
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 3ff9bba..26f9ec2 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -383,16 +383,21 @@ struct kobj_type blk_queue_ktype = {
 int blk_register_queue(struct gendisk *disk)
 {
 	int ret;
+	struct device *dev = disk_to_dev(disk);
 
 	struct request_queue *q = disk->queue;
 
 	if (WARN_ON(!q))
 		return -ENXIO;
 
+	ret = blk_trace_init_sysfs(dev);
+	if (ret)
+		return ret;
+
 	if (!q->request_fn)
 		return 0;
 
-	ret = kobject_add(&q->kobj, kobject_get(&disk_to_dev(disk)->kobj),
+	ret = kobject_add(&q->kobj, kobject_get(&dev->kobj),
 			  "%s", "queue");
 	if (ret < 0)
 		return ret;
diff --git a/block/compat_ioctl.c b/block/compat_ioctl.c
index f87615d..f8c218c 100644
--- a/block/compat_ioctl.c
+++ b/block/compat_ioctl.c
@@ -568,7 +568,7 @@ static int compat_blk_trace_setup(struct block_device *bdev, char __user *arg)
 	memcpy(&buts.name, &cbuts.name, 32);
 
 	mutex_lock(&bdev->bd_mutex);
-	ret = do_blk_trace_setup(q, b, bdev->bd_dev, &buts);
+	ret = do_blk_trace_setup(q, b, bdev->bd_dev, bdev, &buts);
 	mutex_unlock(&bdev->bd_mutex);
 	if (ret)
 		return ret;
diff --git a/block/elevator.c b/block/elevator.c
index 7073a90..e220f0c 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -33,17 +33,16 @@
 #include <linux/compiler.h>
 #include <linux/delay.h>
 #include <linux/blktrace_api.h>
-#include <trace/block.h>
 #include <linux/hash.h>
 #include <linux/uaccess.h>
 
+#include <trace/events/block.h>
+
 #include "blk.h"
 
 static DEFINE_SPINLOCK(elv_list_lock);
 static LIST_HEAD(elv_list);
 
-DEFINE_TRACE(block_rq_abort);
-
 /*
  * Merge hash stuff.
  */
@@ -55,9 +54,6 @@ static const int elv_hash_shift = 6;
 #define rq_hash_key(rq)		((rq)->sector + (rq)->nr_sectors)
 #define ELV_ON_HASH(rq)		(!hlist_unhashed(&(rq)->hash))
 
-DEFINE_TRACE(block_rq_insert);
-DEFINE_TRACE(block_rq_issue);
-
 /*
  * Query io scheduler to see if the current process issuing bio may be
  * merged with rq.
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 424f7b0..3fd8b1e 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -20,7 +20,8 @@
 #include <linux/idr.h>
 #include <linux/hdreg.h>
 #include <linux/blktrace_api.h>
-#include <trace/block.h>
+
+#include <trace/events/block.h>
 
 #define DM_MSG_PREFIX "core"
 
@@ -53,8 +54,6 @@ struct dm_target_io {
 	union map_info info;
 };
 
-DEFINE_TRACE(block_bio_complete);
-
 /*
  * For request-based dm.
  * One of these is allocated per request.
@@ -656,8 +655,7 @@ static void __map_bio(struct dm_target *ti, struct bio *clone,
 		/* the bio has been remapped so dispatch it */
 
 		trace_block_remap(bdev_get_queue(clone->bi_bdev), clone,
-				    tio->io->bio->bi_bdev->bd_dev,
-				    clone->bi_sector, sector);
+				    tio->io->bio->bi_bdev->bd_dev, sector);
 
 		generic_make_request(clone);
 	} else if (r < 0 || r == DM_MAPIO_REQUEUE) {
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index e1716f1..91e316f 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1065,6 +1065,7 @@ sg_ioctl(struct inode *inode, struct file *filp,
 		return blk_trace_setup(sdp->device->request_queue,
 				       sdp->disk->disk_name,
 				       MKDEV(SCSI_GENERIC_MAJOR, sdp->index),
+				       NULL,
 				       (char *)arg);
 	case BLKTRACESTART:
 		return blk_trace_startstop(sdp->device->request_queue, 1);
diff --git a/fs/bio.c b/fs/bio.c
index 9871164..740699c 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -26,10 +26,9 @@
 #include <linux/mempool.h>
 #include <linux/workqueue.h>
 #include <linux/blktrace_api.h>
-#include <trace/block.h>
 #include <scsi/sg.h>		/* for struct sg_iovec */
 
-DEFINE_TRACE(block_split);
+#include <trace/events/block.h>
 
 /*
  * Test patch to inline a certain number of bi_io_vec's inside the bio
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 89853bc..f1736ca 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -63,7 +63,7 @@
 #define BRANCH_PROFILE()
 #endif
 
-#ifdef CONFIG_EVENT_TRACER
+#ifdef CONFIG_EVENT_TRACING
 #define FTRACE_EVENTS()	VMLINUX_SYMBOL(__start_ftrace_events) = .;	\
 			*(_ftrace_events)				\
 			VMLINUX_SYMBOL(__stop_ftrace_events) = .;
diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
index d960889..7e4350e 100644
--- a/include/linux/blktrace_api.h
+++ b/include/linux/blktrace_api.h
@@ -116,9 +116,9 @@ struct blk_io_trace {
  * The remap event
  */
 struct blk_io_trace_remap {
-	__be32 device;
 	__be32 device_from;
-	__be64 sector;
+	__be32 device_to;
+	__be64 sector_from;
 };
 
 enum {
@@ -165,8 +165,9 @@ struct blk_trace {
 
 extern int blk_trace_ioctl(struct block_device *, unsigned, char __user *);
 extern void blk_trace_shutdown(struct request_queue *);
-extern int do_blk_trace_setup(struct request_queue *q,
-	char *name, dev_t dev, struct blk_user_trace_setup *buts);
+extern int do_blk_trace_setup(struct request_queue *q, char *name,
+			      dev_t dev, struct block_device *bdev,
+			      struct blk_user_trace_setup *buts);
 extern void __trace_note_message(struct blk_trace *, const char *fmt, ...);
 
 /**
@@ -193,22 +194,42 @@ extern void __trace_note_message(struct blk_trace *, const char *fmt, ...);
 extern void blk_add_driver_data(struct request_queue *q, struct request *rq,
 				void *data, size_t len);
 extern int blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
+			   struct block_device *bdev,
 			   char __user *arg);
 extern int blk_trace_startstop(struct request_queue *q, int start);
 extern int blk_trace_remove(struct request_queue *q);
+extern int blk_trace_init_sysfs(struct device *dev);
 
 extern struct attribute_group blk_trace_attr_group;
 
 #else /* !CONFIG_BLK_DEV_IO_TRACE */
-#define blk_trace_ioctl(bdev, cmd, arg)		(-ENOTTY)
-#define blk_trace_shutdown(q)			do { } while (0)
-#define do_blk_trace_setup(q, name, dev, buts)	(-ENOTTY)
-#define blk_add_driver_data(q, rq, data, len)	do {} while (0)
-#define blk_trace_setup(q, name, dev, arg)	(-ENOTTY)
-#define blk_trace_startstop(q, start)		(-ENOTTY)
-#define blk_trace_remove(q)			(-ENOTTY)
-#define blk_add_trace_msg(q, fmt, ...)		do { } while (0)
+# define blk_trace_ioctl(bdev, cmd, arg)		(-ENOTTY)
+# define blk_trace_shutdown(q)				do { } while (0)
+# define do_blk_trace_setup(q, name, dev, bdev, buts)	(-ENOTTY)
+# define blk_add_driver_data(q, rq, data, len)		do {} while (0)
+# define blk_trace_setup(q, name, dev, bdev, arg)	(-ENOTTY)
+# define blk_trace_startstop(q, start)			(-ENOTTY)
+# define blk_trace_remove(q)				(-ENOTTY)
+# define blk_add_trace_msg(q, fmt, ...)			do { } while (0)
+static inline int blk_trace_init_sysfs(struct device *dev)
+{
+	return 0;
+}
 
 #endif /* CONFIG_BLK_DEV_IO_TRACE */
+
+#if defined(CONFIG_EVENT_TRACING) && defined(CONFIG_BLOCK)
+
+static inline int blk_cmd_buf_len(struct request *rq)
+{
+	return blk_pc_request(rq) ? rq->cmd_len * 3 : 1;
+}
+
+extern void blk_dump_cmd(char *buf, struct request *rq);
+extern void blk_fill_rwbs(char *rwbs, u32 rw, int bytes);
+extern void blk_fill_rwbs_rq(char *rwbs, struct request *rq);
+
+#endif /* CONFIG_EVENT_TRACING && CONFIG_BLOCK */
+
 #endif /* __KERNEL__ */
 #endif
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 8a0c2f2..39b95c5 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -233,8 +233,6 @@ extern int ftrace_arch_read_dyn_info(char *buf, int size);
 
 extern int skip_trace(unsigned long ip);
 
-extern void ftrace_release(void *start, unsigned long size);
-
 extern void ftrace_disable_daemon(void);
 extern void ftrace_enable_daemon(void);
 #else
@@ -325,13 +323,8 @@ static inline void __ftrace_enabled_restore(int enabled)
 
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD
 extern void ftrace_init(void);
-extern void ftrace_init_module(struct module *mod,
-			       unsigned long *start, unsigned long *end);
 #else
 static inline void ftrace_init(void) { }
-static inline void
-ftrace_init_module(struct module *mod,
-		   unsigned long *start, unsigned long *end) { }
 #endif
 
 /*
@@ -368,6 +361,7 @@ struct ftrace_ret_stack {
 	unsigned long ret;
 	unsigned long func;
 	unsigned long long calltime;
+	unsigned long long subtime;
 };
 
 /*
@@ -379,8 +373,6 @@ extern void return_to_handler(void);
 
 extern int
 ftrace_push_return_trace(unsigned long ret, unsigned long func, int *depth);
-extern void
-ftrace_pop_return_trace(struct ftrace_graph_ret *trace, unsigned long *ret);
 
 /*
  * Sometimes we don't want to trace a function with the function
@@ -496,8 +488,15 @@ static inline int test_tsk_trace_graph(struct task_struct *tsk)
 
 extern int ftrace_dump_on_oops;
 
+#ifdef CONFIG_PREEMPT
+#define INIT_TRACE_RECURSION		.trace_recursion = 0,
+#endif
+
 #endif /* CONFIG_TRACING */
 
+#ifndef INIT_TRACE_RECURSION
+#define INIT_TRACE_RECURSION
+#endif
 
 #ifdef CONFIG_HW_BRANCH_TRACER
 
diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
new file mode 100644
index 0000000..5c093ff
--- /dev/null
+++ b/include/linux/ftrace_event.h
@@ -0,0 +1,172 @@
+#ifndef _LINUX_FTRACE_EVENT_H
+#define _LINUX_FTRACE_EVENT_H
+
+#include <linux/trace_seq.h>
+#include <linux/ring_buffer.h>
+#include <linux/percpu.h>
+
+struct trace_array;
+struct tracer;
+struct dentry;
+
+DECLARE_PER_CPU(struct trace_seq, ftrace_event_seq);
+
+struct trace_print_flags {
+	unsigned long		mask;
+	const char		*name;
+};
+
+const char *ftrace_print_flags_seq(struct trace_seq *p, const char *delim,
+				   unsigned long flags,
+				   const struct trace_print_flags *flag_array);
+
+const char *ftrace_print_symbols_seq(struct trace_seq *p, unsigned long val,
+				     const struct trace_print_flags *symbol_array);
+
+/*
+ * The trace entry - the most basic unit of tracing. This is what
+ * is printed in the end as a single line in the trace output, such as:
+ *
+ *     bash-15816 [01]   235.197585: idle_cpu <- irq_enter
+ */
+struct trace_entry {
+	unsigned short		type;
+	unsigned char		flags;
+	unsigned char		preempt_count;
+	int			pid;
+	int			tgid;
+};
+
+#define FTRACE_MAX_EVENT						\
+	((1 << (sizeof(((struct trace_entry *)0)->type) * 8)) - 1)
+
+/*
+ * Trace iterator - used by printout routines who present trace
+ * results to users and which routines might sleep, etc:
+ */
+struct trace_iterator {
+	struct trace_array	*tr;
+	struct tracer		*trace;
+	void			*private;
+	int			cpu_file;
+	struct mutex		mutex;
+	struct ring_buffer_iter	*buffer_iter[NR_CPUS];
+	unsigned long		iter_flags;
+
+	/* The below is zeroed out in pipe_read */
+	struct trace_seq	seq;
+	struct trace_entry	*ent;
+	int			cpu;
+	u64			ts;
+
+	loff_t			pos;
+	long			idx;
+
+	cpumask_var_t		started;
+};
+
+
+typedef enum print_line_t (*trace_print_func)(struct trace_iterator *iter,
+					      int flags);
+struct trace_event {
+	struct hlist_node	node;
+	struct list_head	list;
+	int			type;
+	trace_print_func	trace;
+	trace_print_func	raw;
+	trace_print_func	hex;
+	trace_print_func	binary;
+};
+
+extern int register_ftrace_event(struct trace_event *event);
+extern int unregister_ftrace_event(struct trace_event *event);
+
+/* Return values for print_line callback */
+enum print_line_t {
+	TRACE_TYPE_PARTIAL_LINE	= 0,	/* Retry after flushing the seq */
+	TRACE_TYPE_HANDLED	= 1,
+	TRACE_TYPE_UNHANDLED	= 2,	/* Relay to other output functions */
+	TRACE_TYPE_NO_CONSUME	= 3	/* Handled but ask to not consume */
+};
+
+
+struct ring_buffer_event *
+trace_current_buffer_lock_reserve(int type, unsigned long len,
+				  unsigned long flags, int pc);
+void trace_current_buffer_unlock_commit(struct ring_buffer_event *event,
+					unsigned long flags, int pc);
+void trace_nowake_buffer_unlock_commit(struct ring_buffer_event *event,
+					unsigned long flags, int pc);
+void trace_current_buffer_discard_commit(struct ring_buffer_event *event);
+
+void tracing_record_cmdline(struct task_struct *tsk);
+
+struct ftrace_event_call {
+	struct list_head	list;
+	char			*name;
+	char			*system;
+	struct dentry		*dir;
+	struct trace_event	*event;
+	int			enabled;
+	int			(*regfunc)(void);
+	void			(*unregfunc)(void);
+	int			id;
+	int			(*raw_init)(void);
+	int			(*show_format)(struct trace_seq *s);
+	int			(*define_fields)(void);
+	struct list_head	fields;
+	int			filter_active;
+	void			*filter;
+	void			*mod;
+
+#ifdef CONFIG_EVENT_PROFILE
+	atomic_t	profile_count;
+	int		(*profile_enable)(struct ftrace_event_call *);
+	void		(*profile_disable)(struct ftrace_event_call *);
+#endif
+};
+
+#define MAX_FILTER_PRED		32
+#define MAX_FILTER_STR_VAL	128
+
+extern int init_preds(struct ftrace_event_call *call);
+extern void destroy_preds(struct ftrace_event_call *call);
+extern int filter_match_preds(struct ftrace_event_call *call, void *rec);
+extern int filter_current_check_discard(struct ftrace_event_call *call,
+					void *rec,
+					struct ring_buffer_event *event);
+
+extern int trace_define_field(struct ftrace_event_call *call, char *type,
+			      char *name, int offset, int size, int is_signed);
+
+#define is_signed_type(type)	(((type)(-1)) < 0)
+
+int trace_set_clr_event(const char *system, const char *event, int set);
+
+/*
+ * The double __builtin_constant_p is because gcc will give us an error
+ * if we try to allocate the static variable to fmt if it is not a
+ * constant. Even with the outer if statement optimizing out.
+ */
+#define event_trace_printk(ip, fmt, args...)				\
+do {									\
+	__trace_printk_check_format(fmt, ##args);			\
+	tracing_record_cmdline(current);				\
+	if (__builtin_constant_p(fmt)) {				\
+		static const char *trace_printk_fmt			\
+		  __attribute__((section("__trace_printk_fmt"))) =	\
+			__builtin_constant_p(fmt) ? fmt : NULL;		\
+									\
+		__trace_bprintk(ip, trace_printk_fmt, ##args);		\
+	} else								\
+		__trace_printk(ip, fmt, ##args);			\
+} while (0)
+
+#define __common_field(type, item, is_signed)				\
+	ret = trace_define_field(event_call, #type, "common_" #item,	\
+				 offsetof(typeof(field.ent), item),	\
+				 sizeof(field.ent.item), is_signed);	\
+	if (ret)							\
+		return ret;
+
+#endif /* _LINUX_FTRACE_EVENT_H */
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index d87247d..889bf99 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -174,6 +174,7 @@ extern struct cred init_cred;
 	INIT_TRACE_IRQFLAGS						\
 	INIT_LOCKDEP							\
 	INIT_FTRACE_GRAPH						\
+	INIT_TRACE_RECURSION						\
 }
 
 
diff --git a/include/linux/kmemtrace.h b/include/linux/kmemtrace.h
new file mode 100644
index 0000000..b616d39
--- /dev/null
+++ b/include/linux/kmemtrace.h
@@ -0,0 +1,25 @@
+/*
+ * Copyright (C) 2008 Eduard - Gabriel Munteanu
+ *
+ * This file is released under GPL version 2.
+ */
+
+#ifndef _LINUX_KMEMTRACE_H
+#define _LINUX_KMEMTRACE_H
+
+#ifdef __KERNEL__
+
+#include <trace/events/kmem.h>
+
+#ifdef CONFIG_KMEMTRACE
+extern void kmemtrace_init(void);
+#else
+static inline void kmemtrace_init(void)
+{
+}
+#endif
+
+#endif /* __KERNEL__ */
+
+#endif /* _LINUX_KMEMTRACE_H */
+
diff --git a/include/linux/mm.h b/include/linux/mm.h
index bff1f0d..009eabd 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -19,6 +19,7 @@ struct anon_vma;
 struct file_ra_state;
 struct user_struct;
 struct writeback_control;
+struct rlimit;
 
 #ifndef CONFIG_DISCONTIGMEM          /* Don't use mapnrs, do it properly */
 extern unsigned long max_mapnr;
@@ -1319,8 +1320,8 @@ int vmemmap_populate_basepages(struct page *start_page,
 int vmemmap_populate(struct page *start_page, unsigned long pages, int node);
 void vmemmap_populate_print_last(void);
 
-extern void *alloc_locked_buffer(size_t size);
-extern void free_locked_buffer(void *buffer, size_t size);
-extern void release_locked_buffer(void *buffer, size_t size);
+extern int account_locked_memory(struct mm_struct *mm, struct rlimit *rlim,
+				 size_t size);
+extern void refund_locked_memory(struct mm_struct *mm, size_t size);
 #endif /* __KERNEL__ */
 #endif /* _LINUX_MM_H */
diff --git a/include/linux/mmiotrace.h b/include/linux/mmiotrace.h
index 3d1b7bd..97491f7 100644
--- a/include/linux/mmiotrace.h
+++ b/include/linux/mmiotrace.h
@@ -30,6 +30,8 @@ extern unsigned int kmmio_count;
 
 extern int register_kmmio_probe(struct kmmio_probe *p);
 extern void unregister_kmmio_probe(struct kmmio_probe *p);
+extern int kmmio_init(void);
+extern void kmmio_cleanup(void);
 
 #ifdef CONFIG_MMIOTRACE
 /* kmmio is active by some kmmio_probes? */
diff --git a/include/linux/module.h b/include/linux/module.h
index 627ac08..a8f2c0a 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -337,6 +337,14 @@ struct module
 	const char **trace_bprintk_fmt_start;
 	unsigned int num_trace_bprintk_fmt;
 #endif
+#ifdef CONFIG_EVENT_TRACING
+	struct ftrace_event_call *trace_events;
+	unsigned int num_trace_events;
+#endif
+#ifdef CONFIG_FTRACE_MCOUNT_RECORD
+	unsigned long *ftrace_callsites;
+	unsigned int num_ftrace_callsites;
+#endif
 
 #ifdef CONFIG_MODULE_UNLOAD
 	/* What modules depend on me? */
diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 67c1565..59e133d 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -95,7 +95,6 @@ extern void __ptrace_link(struct task_struct *child,
 			  struct task_struct *new_parent);
 extern void __ptrace_unlink(struct task_struct *child);
 extern void exit_ptrace(struct task_struct *tracer);
-extern void ptrace_fork(struct task_struct *task, unsigned long clone_flags);
 #define PTRACE_MODE_READ   1
 #define PTRACE_MODE_ATTACH 2
 /* Returns 0 on success, -errno on denial. */
@@ -327,15 +326,6 @@ static inline void user_enable_block_step(struct task_struct *task)
 #define arch_ptrace_untrace(task)		do { } while (0)
 #endif
 
-#ifndef arch_ptrace_fork
-/*
- * Do machine-specific work to initialize a new task.
- *
- * This is called from copy_process().
- */
-#define arch_ptrace_fork(child, clone_flags)	do { } while (0)
-#endif
-
 extern int task_current_syscall(struct task_struct *target, long *callno,
 				unsigned long args[6], unsigned int maxargs,
 				unsigned long *sp, unsigned long *pc);
diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index e1b7b21..8670f15 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -11,7 +11,7 @@ struct ring_buffer_iter;
  * Don't refer to this struct directly, use functions below.
  */
 struct ring_buffer_event {
-	u32		type:2, len:3, time_delta:27;
+	u32		type_len:5, time_delta:27;
 	u32		array[];
 };
 
@@ -24,7 +24,8 @@ struct ring_buffer_event {
  *				  size is variable depending on how much
  *				  padding is needed
  *				 If time_delta is non zero:
- *				  everything else same as RINGBUF_TYPE_DATA
+ *				  array[0] holds the actual length
+ *				  size = 4 + length (bytes)
  *
  * @RINGBUF_TYPE_TIME_EXTEND:	Extend the time delta
  *				 array[0] = time delta (28 .. 59)
@@ -35,22 +36,23 @@ struct ring_buffer_event {
  *				 array[1..2] = tv_sec
  *				 size = 16 bytes
  *
- * @RINGBUF_TYPE_DATA:		Data record
- *				 If len is zero:
+ * <= @RINGBUF_TYPE_DATA_TYPE_LEN_MAX:
+ *				Data record
+ *				 If type_len is zero:
  *				  array[0] holds the actual length
  *				  array[1..(length+3)/4] holds data
- *				  size = 4 + 4 + length (bytes)
+ *				  size = 4 + length (bytes)
  *				 else
- *				  length = len << 2
+ *				  length = type_len << 2
  *				  array[0..(length+3)/4-1] holds data
  *				  size = 4 + length (bytes)
  */
 enum ring_buffer_type {
+	RINGBUF_TYPE_DATA_TYPE_LEN_MAX = 28,
 	RINGBUF_TYPE_PADDING,
 	RINGBUF_TYPE_TIME_EXTEND,
 	/* FIXME: RINGBUF_TYPE_TIME_STAMP not implemented */
 	RINGBUF_TYPE_TIME_STAMP,
-	RINGBUF_TYPE_DATA,
 };
 
 unsigned ring_buffer_event_length(struct ring_buffer_event *event);
@@ -68,13 +70,54 @@ ring_buffer_event_time_delta(struct ring_buffer_event *event)
 	return event->time_delta;
 }
 
+/*
+ * ring_buffer_event_discard can discard any event in the ring buffer.
+ *   it is up to the caller to protect against a reader from
+ *   consuming it or a writer from wrapping and replacing it.
+ *
+ * No external protection is needed if this is called before
+ * the event is commited. But in that case it would be better to
+ * use ring_buffer_discard_commit.
+ *
+ * Note, if an event that has not been committed is discarded
+ * with ring_buffer_event_discard, it must still be committed.
+ */
 void ring_buffer_event_discard(struct ring_buffer_event *event);
 
 /*
+ * ring_buffer_discard_commit will remove an event that has not
+ *   ben committed yet. If this is used, then ring_buffer_unlock_commit
+ *   must not be called on the discarded event. This function
+ *   will try to remove the event from the ring buffer completely
+ *   if another event has not been written after it.
+ *
+ * Example use:
+ *
+ *  if (some_condition)
+ *    ring_buffer_discard_commit(buffer, event);
+ *  else
+ *    ring_buffer_unlock_commit(buffer, event);
+ */
+void ring_buffer_discard_commit(struct ring_buffer *buffer,
+				struct ring_buffer_event *event);
+
+/*
  * size is in bytes for each per CPU buffer.
  */
 struct ring_buffer *
-ring_buffer_alloc(unsigned long size, unsigned flags);
+__ring_buffer_alloc(unsigned long size, unsigned flags, struct lock_class_key *key);
+
+/*
+ * Because the ring buffer is generic, if other users of the ring buffer get
+ * traced by ftrace, it can produce lockdep warnings. We need to keep each
+ * ring buffer's lock class separate.
+ */
+#define ring_buffer_alloc(size, flags)			\
+({							\
+	static struct lock_class_key __key;		\
+	__ring_buffer_alloc((size), (flags), &__key);	\
+})
+
 void ring_buffer_free(struct ring_buffer *buffer);
 
 int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size);
@@ -122,6 +165,8 @@ unsigned long ring_buffer_entries(struct ring_buffer *buffer);
 unsigned long ring_buffer_overruns(struct ring_buffer *buffer);
 unsigned long ring_buffer_entries_cpu(struct ring_buffer *buffer, int cpu);
 unsigned long ring_buffer_overrun_cpu(struct ring_buffer *buffer, int cpu);
+unsigned long ring_buffer_commit_overrun_cpu(struct ring_buffer *buffer, int cpu);
+unsigned long ring_buffer_nmi_dropped_cpu(struct ring_buffer *buffer, int cpu);
 
 u64 ring_buffer_time_stamp(struct ring_buffer *buffer, int cpu);
 void ring_buffer_normalize_time_stamp(struct ring_buffer *buffer,
@@ -137,6 +182,11 @@ void ring_buffer_free_read_page(struct ring_buffer *buffer, void *data);
 int ring_buffer_read_page(struct ring_buffer *buffer, void **data_page,
 			  size_t len, int cpu, int full);
 
+struct trace_seq;
+
+int ring_buffer_print_entry_header(struct trace_seq *s);
+int ring_buffer_print_page_header(struct trace_seq *s);
+
 enum ring_buffer_flags {
 	RB_FL_OVERWRITE		= 1 << 0,
 };
diff --git a/include/linux/sched.h b/include/linux/sched.h
index b4c38bc..1ed4ef5 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -96,8 +96,8 @@ struct exec_domain;
 struct futex_pi_state;
 struct robust_list_head;
 struct bio;
-struct bts_tracer;
 struct fs_struct;
+struct bts_context;
 
 /*
  * List of flags we want to share for kernel threads,
@@ -1209,18 +1209,11 @@ struct task_struct {
 	struct list_head ptraced;
 	struct list_head ptrace_entry;
 
-#ifdef CONFIG_X86_PTRACE_BTS
 	/*
 	 * This is the tracer handle for the ptrace BTS extension.
 	 * This field actually belongs to the ptracer task.
 	 */
-	struct bts_tracer *bts;
-	/*
-	 * The buffer to hold the BTS data.
-	 */
-	void *bts_buffer;
-	size_t bts_size;
-#endif /* CONFIG_X86_PTRACE_BTS */
+	struct bts_context *bts;
 
 	/* PID/PID hash table linkage. */
 	struct pid_link pids[PIDTYPE_MAX];
@@ -1428,7 +1421,9 @@ struct task_struct {
 #ifdef CONFIG_TRACING
 	/* state flags for use by tracers */
 	unsigned long trace;
-#endif
+	/* bitmask of trace recursion */
+	unsigned long trace_recursion;
+#endif /* CONFIG_TRACING */
 };
 
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
@@ -2001,8 +1996,10 @@ extern void set_task_comm(struct task_struct *tsk, char *from);
 extern char *get_task_comm(char *to, struct task_struct *tsk);
 
 #ifdef CONFIG_SMP
+extern void wait_task_context_switch(struct task_struct *p);
 extern unsigned long wait_task_inactive(struct task_struct *, long match_state);
 #else
+static inline void wait_task_context_switch(struct task_struct *p) {}
 static inline unsigned long wait_task_inactive(struct task_struct *p,
 					       long match_state)
 {
diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
index 5ac9b0b..713f841 100644
--- a/include/linux/slab_def.h
+++ b/include/linux/slab_def.h
@@ -14,7 +14,7 @@
 #include <asm/page.h>		/* kmalloc_sizes.h needs PAGE_SIZE */
 #include <asm/cache.h>		/* kmalloc_sizes.h needs L1_CACHE_BYTES */
 #include <linux/compiler.h>
-#include <trace/kmemtrace.h>
+#include <linux/kmemtrace.h>
 
 /* Size description struct for general caches. */
 struct cache_sizes {
diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index 5046f90..be5d40c 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -10,7 +10,7 @@
 #include <linux/gfp.h>
 #include <linux/workqueue.h>
 #include <linux/kobject.h>
-#include <trace/kmemtrace.h>
+#include <linux/kmemtrace.h>
 
 enum stat_item {
 	ALLOC_FASTPATH,		/* Allocation from cpu slab */
diff --git a/include/linux/trace_seq.h b/include/linux/trace_seq.h
new file mode 100644
index 0000000..c68bccb
--- /dev/null
+++ b/include/linux/trace_seq.h
@@ -0,0 +1,92 @@
+#ifndef _LINUX_TRACE_SEQ_H
+#define _LINUX_TRACE_SEQ_H
+
+#include <linux/fs.h>
+
+/*
+ * Trace sequences are used to allow a function to call several other functions
+ * to create a string of data to use (up to a max of PAGE_SIZE.
+ */
+
+struct trace_seq {
+	unsigned char		buffer[PAGE_SIZE];
+	unsigned int		len;
+	unsigned int		readpos;
+};
+
+static inline void
+trace_seq_init(struct trace_seq *s)
+{
+	s->len = 0;
+	s->readpos = 0;
+}
+
+/*
+ * Currently only defined when tracing is enabled.
+ */
+#ifdef CONFIG_TRACING
+extern int trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
+	__attribute__ ((format (printf, 2, 3)));
+extern int trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args)
+	__attribute__ ((format (printf, 2, 0)));
+extern int
+trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary);
+extern void trace_print_seq(struct seq_file *m, struct trace_seq *s);
+extern ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf,
+				 size_t cnt);
+extern int trace_seq_puts(struct trace_seq *s, const char *str);
+extern int trace_seq_putc(struct trace_seq *s, unsigned char c);
+extern int trace_seq_putmem(struct trace_seq *s, const void *mem, size_t len);
+extern int trace_seq_putmem_hex(struct trace_seq *s, const void *mem,
+				size_t len);
+extern void *trace_seq_reserve(struct trace_seq *s, size_t len);
+extern int trace_seq_path(struct trace_seq *s, struct path *path);
+
+#else /* CONFIG_TRACING */
+static inline int trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
+{
+	return 0;
+}
+static inline int
+trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary)
+{
+	return 0;
+}
+
+static inline void trace_print_seq(struct seq_file *m, struct trace_seq *s)
+{
+}
+static inline ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf,
+				 size_t cnt)
+{
+	return 0;
+}
+static inline int trace_seq_puts(struct trace_seq *s, const char *str)
+{
+	return 0;
+}
+static inline int trace_seq_putc(struct trace_seq *s, unsigned char c)
+{
+	return 0;
+}
+static inline int
+trace_seq_putmem(struct trace_seq *s, const void *mem, size_t len)
+{
+	return 0;
+}
+static inline int trace_seq_putmem_hex(struct trace_seq *s, const void *mem,
+				       size_t len)
+{
+	return 0;
+}
+static inline void *trace_seq_reserve(struct trace_seq *s, size_t len)
+{
+	return NULL;
+}
+static inline int trace_seq_path(struct trace_seq *s, struct path *path)
+{
+	return 0;
+}
+#endif /* CONFIG_TRACING */
+
+#endif /* _LINUX_TRACE_SEQ_H */
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index d35a7ee..14df7e6 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -31,6 +31,8 @@ struct tracepoint {
 					 * Keep in sync with vmlinux.lds.h.
 					 */
 
+#ifndef DECLARE_TRACE
+
 #define TP_PROTO(args...)	args
 #define TP_ARGS(args...)		args
 
@@ -114,6 +116,7 @@ static inline void tracepoint_update_probe_range(struct tracepoint *begin,
 	struct tracepoint *end)
 { }
 #endif /* CONFIG_TRACEPOINTS */
+#endif /* DECLARE_TRACE */
 
 /*
  * Connect a probe to a tracepoint.
@@ -154,10 +157,8 @@ static inline void tracepoint_synchronize_unregister(void)
 }
 
 #define PARAMS(args...) args
-#define TRACE_FORMAT(name, proto, args, fmt)		\
-	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
-
 
+#ifndef TRACE_EVENT
 /*
  * For use with the TRACE_EVENT macro:
  *
@@ -262,5 +263,6 @@ static inline void tracepoint_synchronize_unregister(void)
 
 #define TRACE_EVENT(name, proto, args, struct, assign, print)	\
 	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
+#endif
 
 #endif
diff --git a/include/trace/block.h b/include/trace/block.h
deleted file mode 100644
index 25b7068..0000000
--- a/include/trace/block.h
+++ /dev/null
@@ -1,76 +0,0 @@
-#ifndef _TRACE_BLOCK_H
-#define _TRACE_BLOCK_H
-
-#include <linux/blkdev.h>
-#include <linux/tracepoint.h>
-
-DECLARE_TRACE(block_rq_abort,
-	TP_PROTO(struct request_queue *q, struct request *rq),
-	      TP_ARGS(q, rq));
-
-DECLARE_TRACE(block_rq_insert,
-	TP_PROTO(struct request_queue *q, struct request *rq),
-	      TP_ARGS(q, rq));
-
-DECLARE_TRACE(block_rq_issue,
-	TP_PROTO(struct request_queue *q, struct request *rq),
-	      TP_ARGS(q, rq));
-
-DECLARE_TRACE(block_rq_requeue,
-	TP_PROTO(struct request_queue *q, struct request *rq),
-	      TP_ARGS(q, rq));
-
-DECLARE_TRACE(block_rq_complete,
-	TP_PROTO(struct request_queue *q, struct request *rq),
-	      TP_ARGS(q, rq));
-
-DECLARE_TRACE(block_bio_bounce,
-	TP_PROTO(struct request_queue *q, struct bio *bio),
-	      TP_ARGS(q, bio));
-
-DECLARE_TRACE(block_bio_complete,
-	TP_PROTO(struct request_queue *q, struct bio *bio),
-	      TP_ARGS(q, bio));
-
-DECLARE_TRACE(block_bio_backmerge,
-	TP_PROTO(struct request_queue *q, struct bio *bio),
-	      TP_ARGS(q, bio));
-
-DECLARE_TRACE(block_bio_frontmerge,
-	TP_PROTO(struct request_queue *q, struct bio *bio),
-	      TP_ARGS(q, bio));
-
-DECLARE_TRACE(block_bio_queue,
-	TP_PROTO(struct request_queue *q, struct bio *bio),
-	      TP_ARGS(q, bio));
-
-DECLARE_TRACE(block_getrq,
-	TP_PROTO(struct request_queue *q, struct bio *bio, int rw),
-	      TP_ARGS(q, bio, rw));
-
-DECLARE_TRACE(block_sleeprq,
-	TP_PROTO(struct request_queue *q, struct bio *bio, int rw),
-	      TP_ARGS(q, bio, rw));
-
-DECLARE_TRACE(block_plug,
-	TP_PROTO(struct request_queue *q),
-	      TP_ARGS(q));
-
-DECLARE_TRACE(block_unplug_timer,
-	TP_PROTO(struct request_queue *q),
-	      TP_ARGS(q));
-
-DECLARE_TRACE(block_unplug_io,
-	TP_PROTO(struct request_queue *q),
-	      TP_ARGS(q));
-
-DECLARE_TRACE(block_split,
-	TP_PROTO(struct request_queue *q, struct bio *bio, unsigned int pdu),
-	      TP_ARGS(q, bio, pdu));
-
-DECLARE_TRACE(block_remap,
-	TP_PROTO(struct request_queue *q, struct bio *bio, dev_t dev,
-		 sector_t from, sector_t to),
-	      TP_ARGS(q, bio, dev, from, to));
-
-#endif
diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
new file mode 100644
index 0000000..f7a7ae1
--- /dev/null
+++ b/include/trace/define_trace.h
@@ -0,0 +1,75 @@
+/*
+ * Trace files that want to automate creationg of all tracepoints defined
+ * in their file should include this file. The following are macros that the
+ * trace file may define:
+ *
+ * TRACE_SYSTEM defines the system the tracepoint is for
+ *
+ * TRACE_INCLUDE_FILE if the file name is something other than TRACE_SYSTEM.h
+ *     This macro may be defined to tell define_trace.h what file to include.
+ *     Note, leave off the ".h".
+ *
+ * TRACE_INCLUDE_PATH if the path is something other than core kernel include/trace
+ *     then this macro can define the path to use. Note, the path is relative to
+ *     define_trace.h, not the file including it. Full path names for out of tree
+ *     modules must be used.
+ */
+
+#ifdef CREATE_TRACE_POINTS
+
+/* Prevent recursion */
+#undef CREATE_TRACE_POINTS
+
+#include <linux/stringify.h>
+
+#undef TRACE_EVENT
+#define TRACE_EVENT(name, proto, args, tstruct, assign, print)	\
+	DEFINE_TRACE(name)
+
+#undef DECLARE_TRACE
+#define DECLARE_TRACE(name, proto, args)	\
+	DEFINE_TRACE(name)
+
+#undef TRACE_INCLUDE
+#undef __TRACE_INCLUDE
+
+#ifndef TRACE_INCLUDE_FILE
+# define TRACE_INCLUDE_FILE TRACE_SYSTEM
+# define UNDEF_TRACE_INCLUDE_FILE
+#endif
+
+#ifndef TRACE_INCLUDE_PATH
+# define __TRACE_INCLUDE(system) <trace/events/system.h>
+# define UNDEF_TRACE_INCLUDE_PATH
+#else
+# define __TRACE_INCLUDE(system) __stringify(TRACE_INCLUDE_PATH/system.h)
+#endif
+
+# define TRACE_INCLUDE(system) __TRACE_INCLUDE(system)
+
+/* Let the trace headers be reread */
+#define TRACE_HEADER_MULTI_READ
+
+#include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
+
+#ifdef CONFIG_EVENT_TRACING
+#include <trace/ftrace.h>
+#endif
+
+#undef TRACE_HEADER_MULTI_READ
+
+/* Only undef what we defined in this file */
+#ifdef UNDEF_TRACE_INCLUDE_FILE
+# undef TRACE_INCLUDE_FILE
+# undef UNDEF_TRACE_INCLUDE_FILE
+#endif
+
+#ifdef UNDEF_TRACE_INCLUDE_PATH
+# undef TRACE_INCLUDE_PATH
+# undef UNDEF_TRACE_INCLUDE_PATH
+#endif
+
+/* We may be processing more files */
+#define CREATE_TRACE_POINTS
+
+#endif /* CREATE_TRACE_POINTS */
diff --git a/include/trace/events/block.h b/include/trace/events/block.h
new file mode 100644
index 0000000..53effd4
--- /dev/null
+++ b/include/trace/events/block.h
@@ -0,0 +1,498 @@
+#if !defined(_TRACE_BLOCK_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_BLOCK_H
+
+#include <linux/blktrace_api.h>
+#include <linux/blkdev.h>
+#include <linux/tracepoint.h>
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM block
+
+TRACE_EVENT(block_rq_abort,
+
+	TP_PROTO(struct request_queue *q, struct request *rq),
+
+	TP_ARGS(q, rq),
+
+	TP_STRUCT__entry(
+		__field(  dev_t,	dev			)
+		__field(  sector_t,	sector			)
+		__field(  unsigned int,	nr_sector		)
+		__field(  int,		errors			)
+		__array(  char,		rwbs,	6		)
+		__dynamic_array( char,	cmd,	blk_cmd_buf_len(rq)	)
+	),
+
+	TP_fast_assign(
+		__entry->dev	   = rq->rq_disk ? disk_devt(rq->rq_disk) : 0;
+		__entry->sector    = blk_pc_request(rq) ? 0 : rq->hard_sector;
+		__entry->nr_sector = blk_pc_request(rq) ?
+						0 : rq->hard_nr_sectors;
+		__entry->errors    = rq->errors;
+
+		blk_fill_rwbs_rq(__entry->rwbs, rq);
+		blk_dump_cmd(__get_str(cmd), rq);
+	),
+
+	TP_printk("%d,%d %s (%s) %llu + %u [%d]",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->rwbs, __get_str(cmd),
+		  (unsigned long long)__entry->sector,
+		  __entry->nr_sector, __entry->errors)
+);
+
+TRACE_EVENT(block_rq_insert,
+
+	TP_PROTO(struct request_queue *q, struct request *rq),
+
+	TP_ARGS(q, rq),
+
+	TP_STRUCT__entry(
+		__field(  dev_t,	dev			)
+		__field(  sector_t,	sector			)
+		__field(  unsigned int,	nr_sector		)
+		__field(  unsigned int,	bytes			)
+		__array(  char,		rwbs,	6		)
+		__array(  char,         comm,   TASK_COMM_LEN   )
+		__dynamic_array( char,	cmd,	blk_cmd_buf_len(rq)	)
+	),
+
+	TP_fast_assign(
+		__entry->dev	   = rq->rq_disk ? disk_devt(rq->rq_disk) : 0;
+		__entry->sector    = blk_pc_request(rq) ? 0 : rq->hard_sector;
+		__entry->nr_sector = blk_pc_request(rq) ?
+						0 : rq->hard_nr_sectors;
+		__entry->bytes     = blk_pc_request(rq) ? rq->data_len : 0;
+
+		blk_fill_rwbs_rq(__entry->rwbs, rq);
+		blk_dump_cmd(__get_str(cmd), rq);
+		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+	),
+
+	TP_printk("%d,%d %s %u (%s) %llu + %u [%s]",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->rwbs, __entry->bytes, __get_str(cmd),
+		  (unsigned long long)__entry->sector,
+		  __entry->nr_sector, __entry->comm)
+);
+
+TRACE_EVENT(block_rq_issue,
+
+	TP_PROTO(struct request_queue *q, struct request *rq),
+
+	TP_ARGS(q, rq),
+
+	TP_STRUCT__entry(
+		__field(  dev_t,	dev			)
+		__field(  sector_t,	sector			)
+		__field(  unsigned int,	nr_sector		)
+		__field(  unsigned int,	bytes			)
+		__array(  char,		rwbs,	6		)
+		__array(  char,		comm,   TASK_COMM_LEN   )
+		__dynamic_array( char,	cmd,	blk_cmd_buf_len(rq)	)
+	),
+
+	TP_fast_assign(
+		__entry->dev	   = rq->rq_disk ? disk_devt(rq->rq_disk) : 0;
+		__entry->sector    = blk_pc_request(rq) ? 0 : rq->hard_sector;
+		__entry->nr_sector = blk_pc_request(rq) ?
+						0 : rq->hard_nr_sectors;
+		__entry->bytes     = blk_pc_request(rq) ? rq->data_len : 0;
+
+		blk_fill_rwbs_rq(__entry->rwbs, rq);
+		blk_dump_cmd(__get_str(cmd), rq);
+		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+	),
+
+	TP_printk("%d,%d %s %u (%s) %llu + %u [%s]",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->rwbs, __entry->bytes, __get_str(cmd),
+		  (unsigned long long)__entry->sector,
+		  __entry->nr_sector, __entry->comm)
+);
+
+TRACE_EVENT(block_rq_requeue,
+
+	TP_PROTO(struct request_queue *q, struct request *rq),
+
+	TP_ARGS(q, rq),
+
+	TP_STRUCT__entry(
+		__field(  dev_t,	dev			)
+		__field(  sector_t,	sector			)
+		__field(  unsigned int,	nr_sector		)
+		__field(  int,		errors			)
+		__array(  char,		rwbs,	6		)
+		__dynamic_array( char,	cmd,	blk_cmd_buf_len(rq)	)
+	),
+
+	TP_fast_assign(
+		__entry->dev	   = rq->rq_disk ? disk_devt(rq->rq_disk) : 0;
+		__entry->sector    = blk_pc_request(rq) ? 0 : rq->hard_sector;
+		__entry->nr_sector = blk_pc_request(rq) ?
+						0 : rq->hard_nr_sectors;
+		__entry->errors	   = rq->errors;
+
+		blk_fill_rwbs_rq(__entry->rwbs, rq);
+		blk_dump_cmd(__get_str(cmd), rq);
+	),
+
+	TP_printk("%d,%d %s (%s) %llu + %u [%d]",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->rwbs, __get_str(cmd),
+		  (unsigned long long)__entry->sector,
+		  __entry->nr_sector, __entry->errors)
+);
+
+TRACE_EVENT(block_rq_complete,
+
+	TP_PROTO(struct request_queue *q, struct request *rq),
+
+	TP_ARGS(q, rq),
+
+	TP_STRUCT__entry(
+		__field(  dev_t,	dev			)
+		__field(  sector_t,	sector			)
+		__field(  unsigned int,	nr_sector		)
+		__field(  int,		errors			)
+		__array(  char,		rwbs,	6		)
+		__dynamic_array( char,	cmd,	blk_cmd_buf_len(rq)	)
+	),
+
+	TP_fast_assign(
+		__entry->dev	   = rq->rq_disk ? disk_devt(rq->rq_disk) : 0;
+		__entry->sector    = blk_pc_request(rq) ? 0 : rq->hard_sector;
+		__entry->nr_sector = blk_pc_request(rq) ?
+						0 : rq->hard_nr_sectors;
+		__entry->errors    = rq->errors;
+
+		blk_fill_rwbs_rq(__entry->rwbs, rq);
+		blk_dump_cmd(__get_str(cmd), rq);
+	),
+
+	TP_printk("%d,%d %s (%s) %llu + %u [%d]",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->rwbs, __get_str(cmd),
+		  (unsigned long long)__entry->sector,
+		  __entry->nr_sector, __entry->errors)
+);
+TRACE_EVENT(block_bio_bounce,
+
+	TP_PROTO(struct request_queue *q, struct bio *bio),
+
+	TP_ARGS(q, bio),
+
+	TP_STRUCT__entry(
+		__field( dev_t,		dev			)
+		__field( sector_t,	sector			)
+		__field( unsigned int,	nr_sector		)
+		__array( char,		rwbs,	6		)
+		__array( char,		comm,	TASK_COMM_LEN	)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= bio->bi_bdev->bd_dev;
+		__entry->sector		= bio->bi_sector;
+		__entry->nr_sector	= bio->bi_size >> 9;
+		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);
+		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+	),
+
+	TP_printk("%d,%d %s %llu + %u [%s]",
+		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
+		  (unsigned long long)__entry->sector,
+		  __entry->nr_sector, __entry->comm)
+);
+
+TRACE_EVENT(block_bio_complete,
+
+	TP_PROTO(struct request_queue *q, struct bio *bio),
+
+	TP_ARGS(q, bio),
+
+	TP_STRUCT__entry(
+		__field( dev_t,		dev		)
+		__field( sector_t,	sector		)
+		__field( unsigned,	nr_sector	)
+		__field( int,		error		)
+		__array( char,		rwbs,	6	)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= bio->bi_bdev->bd_dev;
+		__entry->sector		= bio->bi_sector;
+		__entry->nr_sector	= bio->bi_size >> 9;
+		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);
+	),
+
+	TP_printk("%d,%d %s %llu + %u [%d]",
+		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
+		  (unsigned long long)__entry->sector,
+		  __entry->nr_sector, __entry->error)
+);
+
+TRACE_EVENT(block_bio_backmerge,
+
+	TP_PROTO(struct request_queue *q, struct bio *bio),
+
+	TP_ARGS(q, bio),
+
+	TP_STRUCT__entry(
+		__field( dev_t,		dev			)
+		__field( sector_t,	sector			)
+		__field( unsigned int,	nr_sector		)
+		__array( char,		rwbs,	6		)
+		__array( char,		comm,	TASK_COMM_LEN	)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= bio->bi_bdev->bd_dev;
+		__entry->sector		= bio->bi_sector;
+		__entry->nr_sector	= bio->bi_size >> 9;
+		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);
+		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+	),
+
+	TP_printk("%d,%d %s %llu + %u [%s]",
+		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
+		  (unsigned long long)__entry->sector,
+		  __entry->nr_sector, __entry->comm)
+);
+
+TRACE_EVENT(block_bio_frontmerge,
+
+	TP_PROTO(struct request_queue *q, struct bio *bio),
+
+	TP_ARGS(q, bio),
+
+	TP_STRUCT__entry(
+		__field( dev_t,		dev			)
+		__field( sector_t,	sector			)
+		__field( unsigned,	nr_sector		)
+		__array( char,		rwbs,	6		)
+		__array( char,		comm,	TASK_COMM_LEN	)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= bio->bi_bdev->bd_dev;
+		__entry->sector		= bio->bi_sector;
+		__entry->nr_sector	= bio->bi_size >> 9;
+		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);
+		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+	),
+
+	TP_printk("%d,%d %s %llu + %u [%s]",
+		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
+		  (unsigned long long)__entry->sector,
+		  __entry->nr_sector, __entry->comm)
+);
+
+TRACE_EVENT(block_bio_queue,
+
+	TP_PROTO(struct request_queue *q, struct bio *bio),
+
+	TP_ARGS(q, bio),
+
+	TP_STRUCT__entry(
+		__field( dev_t,		dev			)
+		__field( sector_t,	sector			)
+		__field( unsigned int,	nr_sector		)
+		__array( char,		rwbs,	6		)
+		__array( char,		comm,	TASK_COMM_LEN	)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= bio->bi_bdev->bd_dev;
+		__entry->sector		= bio->bi_sector;
+		__entry->nr_sector	= bio->bi_size >> 9;
+		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);
+		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+	),
+
+	TP_printk("%d,%d %s %llu + %u [%s]",
+		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
+		  (unsigned long long)__entry->sector,
+		  __entry->nr_sector, __entry->comm)
+);
+
+TRACE_EVENT(block_getrq,
+
+	TP_PROTO(struct request_queue *q, struct bio *bio, int rw),
+
+	TP_ARGS(q, bio, rw),
+
+	TP_STRUCT__entry(
+		__field( dev_t,		dev			)
+		__field( sector_t,	sector			)
+		__field( unsigned int,	nr_sector		)
+		__array( char,		rwbs,	6		)
+		__array( char,		comm,	TASK_COMM_LEN	)
+        ),
+
+	TP_fast_assign(
+		__entry->dev		= bio ? bio->bi_bdev->bd_dev : 0;
+		__entry->sector		= bio ? bio->bi_sector : 0;
+		__entry->nr_sector	= bio ? bio->bi_size >> 9 : 0;
+		blk_fill_rwbs(__entry->rwbs,
+			      bio ? bio->bi_rw : 0, __entry->nr_sector);
+		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+        ),
+
+	TP_printk("%d,%d %s %llu + %u [%s]",
+		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
+		  (unsigned long long)__entry->sector,
+		  __entry->nr_sector, __entry->comm)
+);
+
+TRACE_EVENT(block_sleeprq,
+
+	TP_PROTO(struct request_queue *q, struct bio *bio, int rw),
+
+	TP_ARGS(q, bio, rw),
+
+	TP_STRUCT__entry(
+		__field( dev_t,		dev			)
+		__field( sector_t,	sector			)
+		__field( unsigned int,	nr_sector		)
+		__array( char,		rwbs,	6		)
+		__array( char,		comm,	TASK_COMM_LEN	)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= bio ? bio->bi_bdev->bd_dev : 0;
+		__entry->sector		= bio ? bio->bi_sector : 0;
+		__entry->nr_sector	= bio ? bio->bi_size >> 9 : 0;
+		blk_fill_rwbs(__entry->rwbs,
+			    bio ? bio->bi_rw : 0, __entry->nr_sector);
+		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+	),
+
+	TP_printk("%d,%d %s %llu + %u [%s]",
+		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
+		  (unsigned long long)__entry->sector,
+		  __entry->nr_sector, __entry->comm)
+);
+
+TRACE_EVENT(block_plug,
+
+	TP_PROTO(struct request_queue *q),
+
+	TP_ARGS(q),
+
+	TP_STRUCT__entry(
+		__array( char,		comm,	TASK_COMM_LEN	)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+	),
+
+	TP_printk("[%s]", __entry->comm)
+);
+
+TRACE_EVENT(block_unplug_timer,
+
+	TP_PROTO(struct request_queue *q),
+
+	TP_ARGS(q),
+
+	TP_STRUCT__entry(
+		__field( int,		nr_rq			)
+		__array( char,		comm,	TASK_COMM_LEN	)
+	),
+
+	TP_fast_assign(
+		__entry->nr_rq	= q->rq.count[READ] + q->rq.count[WRITE];
+		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+	),
+
+	TP_printk("[%s] %d", __entry->comm, __entry->nr_rq)
+);
+
+TRACE_EVENT(block_unplug_io,
+
+	TP_PROTO(struct request_queue *q),
+
+	TP_ARGS(q),
+
+	TP_STRUCT__entry(
+		__field( int,		nr_rq			)
+		__array( char,		comm,	TASK_COMM_LEN	)
+	),
+
+	TP_fast_assign(
+		__entry->nr_rq	= q->rq.count[READ] + q->rq.count[WRITE];
+		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+	),
+
+	TP_printk("[%s] %d", __entry->comm, __entry->nr_rq)
+);
+
+TRACE_EVENT(block_split,
+
+	TP_PROTO(struct request_queue *q, struct bio *bio,
+		 unsigned int new_sector),
+
+	TP_ARGS(q, bio, new_sector),
+
+	TP_STRUCT__entry(
+		__field( dev_t,		dev				)
+		__field( sector_t,	sector				)
+		__field( sector_t,	new_sector			)
+		__array( char,		rwbs,		6		)
+		__array( char,		comm,		TASK_COMM_LEN	)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= bio->bi_bdev->bd_dev;
+		__entry->sector		= bio->bi_sector;
+		__entry->new_sector	= new_sector;
+		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);
+		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+	),
+
+	TP_printk("%d,%d %s %llu / %llu [%s]",
+		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
+		  (unsigned long long)__entry->sector,
+		  (unsigned long long)__entry->new_sector,
+		  __entry->comm)
+);
+
+TRACE_EVENT(block_remap,
+
+	TP_PROTO(struct request_queue *q, struct bio *bio, dev_t dev,
+		 sector_t from),
+
+	TP_ARGS(q, bio, dev, from),
+
+	TP_STRUCT__entry(
+		__field( dev_t,		dev		)
+		__field( sector_t,	sector		)
+		__field( unsigned int,	nr_sector	)
+		__field( dev_t,		old_dev		)
+		__field( sector_t,	old_sector	)
+		__array( char,		rwbs,	6	)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= bio->bi_bdev->bd_dev;
+		__entry->sector		= bio->bi_sector;
+		__entry->nr_sector	= bio->bi_size >> 9;
+		__entry->old_dev	= dev;
+		__entry->old_sector	= from;
+		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);
+	),
+
+	TP_printk("%d,%d %s %llu + %u <- (%d,%d) %llu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
+		  (unsigned long long)__entry->sector,
+		  __entry->nr_sector,
+		  MAJOR(__entry->old_dev), MINOR(__entry->old_dev),
+		  (unsigned long long)__entry->old_sector)
+);
+
+#endif /* _TRACE_BLOCK_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
+
diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
new file mode 100644
index 0000000..b0c7ede
--- /dev/null
+++ b/include/trace/events/irq.h
@@ -0,0 +1,145 @@
+#if !defined(_TRACE_IRQ_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_IRQ_H
+
+#include <linux/tracepoint.h>
+#include <linux/interrupt.h>
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM irq
+
+#define softirq_name(sirq) { sirq##_SOFTIRQ, #sirq }
+#define show_softirq_name(val)			\
+	__print_symbolic(val,			\
+			 softirq_name(HI),	\
+			 softirq_name(TIMER),	\
+			 softirq_name(NET_TX),	\
+			 softirq_name(NET_RX),	\
+			 softirq_name(BLOCK),	\
+			 softirq_name(TASKLET),	\
+			 softirq_name(SCHED),	\
+			 softirq_name(HRTIMER),	\
+			 softirq_name(RCU))
+
+/**
+ * irq_handler_entry - called immediately before the irq action handler
+ * @irq: irq number
+ * @action: pointer to struct irqaction
+ *
+ * The struct irqaction pointed to by @action contains various
+ * information about the handler, including the device name,
+ * @action->name, and the device id, @action->dev_id. When used in
+ * conjunction with the irq_handler_exit tracepoint, we can figure
+ * out irq handler latencies.
+ */
+TRACE_EVENT(irq_handler_entry,
+
+	TP_PROTO(int irq, struct irqaction *action),
+
+	TP_ARGS(irq, action),
+
+	TP_STRUCT__entry(
+		__field(	int,	irq		)
+		__string(	name,	action->name	)
+	),
+
+	TP_fast_assign(
+		__entry->irq = irq;
+		__assign_str(name, action->name);
+	),
+
+	TP_printk("irq=%d handler=%s", __entry->irq, __get_str(name))
+);
+
+/**
+ * irq_handler_exit - called immediately after the irq action handler returns
+ * @irq: irq number
+ * @action: pointer to struct irqaction
+ * @ret: return value
+ *
+ * If the @ret value is set to IRQ_HANDLED, then we know that the corresponding
+ * @action->handler scuccessully handled this irq. Otherwise, the irq might be
+ * a shared irq line, or the irq was not handled successfully. Can be used in
+ * conjunction with the irq_handler_entry to understand irq handler latencies.
+ */
+TRACE_EVENT(irq_handler_exit,
+
+	TP_PROTO(int irq, struct irqaction *action, int ret),
+
+	TP_ARGS(irq, action, ret),
+
+	TP_STRUCT__entry(
+		__field(	int,	irq	)
+		__field(	int,	ret	)
+	),
+
+	TP_fast_assign(
+		__entry->irq	= irq;
+		__entry->ret	= ret;
+	),
+
+	TP_printk("irq=%d return=%s",
+		  __entry->irq, __entry->ret ? "handled" : "unhandled")
+);
+
+/**
+ * softirq_entry - called immediately before the softirq handler
+ * @h: pointer to struct softirq_action
+ * @vec: pointer to first struct softirq_action in softirq_vec array
+ *
+ * The @h parameter, contains a pointer to the struct softirq_action
+ * which has a pointer to the action handler that is called. By subtracting
+ * the @vec pointer from the @h pointer, we can determine the softirq
+ * number. Also, when used in combination with the softirq_exit tracepoint
+ * we can determine the softirq latency.
+ */
+TRACE_EVENT(softirq_entry,
+
+	TP_PROTO(struct softirq_action *h, struct softirq_action *vec),
+
+	TP_ARGS(h, vec),
+
+	TP_STRUCT__entry(
+		__field(	int,	vec			)
+	),
+
+	TP_fast_assign(
+		__entry->vec = (int)(h - vec);
+	),
+
+	TP_printk("softirq=%d action=%s", __entry->vec,
+		  show_softirq_name(__entry->vec))
+);
+
+/**
+ * softirq_exit - called immediately after the softirq handler returns
+ * @h: pointer to struct softirq_action
+ * @vec: pointer to first struct softirq_action in softirq_vec array
+ *
+ * The @h parameter contains a pointer to the struct softirq_action
+ * that has handled the softirq. By subtracting the @vec pointer from
+ * the @h pointer, we can determine the softirq number. Also, when used in
+ * combination with the softirq_entry tracepoint we can determine the softirq
+ * latency.
+ */
+TRACE_EVENT(softirq_exit,
+
+	TP_PROTO(struct softirq_action *h, struct softirq_action *vec),
+
+	TP_ARGS(h, vec),
+
+	TP_STRUCT__entry(
+		__field(	int,	vec			)
+	),
+
+	TP_fast_assign(
+		__entry->vec = (int)(h - vec);
+	),
+
+	TP_printk("softirq=%d action=%s", __entry->vec,
+		  show_softirq_name(__entry->vec))
+);
+
+#endif /*  _TRACE_IRQ_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/include/trace/events/kmem.h b/include/trace/events/kmem.h
new file mode 100644
index 0000000..9baba50
--- /dev/null
+++ b/include/trace/events/kmem.h
@@ -0,0 +1,231 @@
+#if !defined(_TRACE_KMEM_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_KMEM_H
+
+#include <linux/types.h>
+#include <linux/tracepoint.h>
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM kmem
+
+/*
+ * The order of these masks is important. Matching masks will be seen
+ * first and the left over flags will end up showing by themselves.
+ *
+ * For example, if we have GFP_KERNEL before GFP_USER we wil get:
+ *
+ *  GFP_KERNEL|GFP_HARDWALL
+ *
+ * Thus most bits set go first.
+ */
+#define show_gfp_flags(flags)						\
+	(flags) ? __print_flags(flags, "|",				\
+	{(unsigned long)GFP_HIGHUSER_MOVABLE,	"GFP_HIGHUSER_MOVABLE"}, \
+	{(unsigned long)GFP_HIGHUSER,		"GFP_HIGHUSER"},	\
+	{(unsigned long)GFP_USER,		"GFP_USER"},		\
+	{(unsigned long)GFP_TEMPORARY,		"GFP_TEMPORARY"},	\
+	{(unsigned long)GFP_KERNEL,		"GFP_KERNEL"},		\
+	{(unsigned long)GFP_NOFS,		"GFP_NOFS"},		\
+	{(unsigned long)GFP_ATOMIC,		"GFP_ATOMIC"},		\
+	{(unsigned long)GFP_NOIO,		"GFP_NOIO"},		\
+	{(unsigned long)__GFP_HIGH,		"GFP_HIGH"},		\
+	{(unsigned long)__GFP_WAIT,		"GFP_WAIT"},		\
+	{(unsigned long)__GFP_IO,		"GFP_IO"},		\
+	{(unsigned long)__GFP_COLD,		"GFP_COLD"},		\
+	{(unsigned long)__GFP_NOWARN,		"GFP_NOWARN"},		\
+	{(unsigned long)__GFP_REPEAT,		"GFP_REPEAT"},		\
+	{(unsigned long)__GFP_NOFAIL,		"GFP_NOFAIL"},		\
+	{(unsigned long)__GFP_NORETRY,		"GFP_NORETRY"},		\
+	{(unsigned long)__GFP_COMP,		"GFP_COMP"},		\
+	{(unsigned long)__GFP_ZERO,		"GFP_ZERO"},		\
+	{(unsigned long)__GFP_NOMEMALLOC,	"GFP_NOMEMALLOC"},	\
+	{(unsigned long)__GFP_HARDWALL,		"GFP_HARDWALL"},	\
+	{(unsigned long)__GFP_THISNODE,		"GFP_THISNODE"},	\
+	{(unsigned long)__GFP_RECLAIMABLE,	"GFP_RECLAIMABLE"},	\
+	{(unsigned long)__GFP_MOVABLE,		"GFP_MOVABLE"}		\
+	) : "GFP_NOWAIT"
+
+TRACE_EVENT(kmalloc,
+
+	TP_PROTO(unsigned long call_site,
+		 const void *ptr,
+		 size_t bytes_req,
+		 size_t bytes_alloc,
+		 gfp_t gfp_flags),
+
+	TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	call_site	)
+		__field(	const void *,	ptr		)
+		__field(	size_t,		bytes_req	)
+		__field(	size_t,		bytes_alloc	)
+		__field(	gfp_t,		gfp_flags	)
+	),
+
+	TP_fast_assign(
+		__entry->call_site	= call_site;
+		__entry->ptr		= ptr;
+		__entry->bytes_req	= bytes_req;
+		__entry->bytes_alloc	= bytes_alloc;
+		__entry->gfp_flags	= gfp_flags;
+	),
+
+	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%s",
+		__entry->call_site,
+		__entry->ptr,
+		__entry->bytes_req,
+		__entry->bytes_alloc,
+		show_gfp_flags(__entry->gfp_flags))
+);
+
+TRACE_EVENT(kmem_cache_alloc,
+
+	TP_PROTO(unsigned long call_site,
+		 const void *ptr,
+		 size_t bytes_req,
+		 size_t bytes_alloc,
+		 gfp_t gfp_flags),
+
+	TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	call_site	)
+		__field(	const void *,	ptr		)
+		__field(	size_t,		bytes_req	)
+		__field(	size_t,		bytes_alloc	)
+		__field(	gfp_t,		gfp_flags	)
+	),
+
+	TP_fast_assign(
+		__entry->call_site	= call_site;
+		__entry->ptr		= ptr;
+		__entry->bytes_req	= bytes_req;
+		__entry->bytes_alloc	= bytes_alloc;
+		__entry->gfp_flags	= gfp_flags;
+	),
+
+	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%s",
+		__entry->call_site,
+		__entry->ptr,
+		__entry->bytes_req,
+		__entry->bytes_alloc,
+		show_gfp_flags(__entry->gfp_flags))
+);
+
+TRACE_EVENT(kmalloc_node,
+
+	TP_PROTO(unsigned long call_site,
+		 const void *ptr,
+		 size_t bytes_req,
+		 size_t bytes_alloc,
+		 gfp_t gfp_flags,
+		 int node),
+
+	TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags, node),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	call_site	)
+		__field(	const void *,	ptr		)
+		__field(	size_t,		bytes_req	)
+		__field(	size_t,		bytes_alloc	)
+		__field(	gfp_t,		gfp_flags	)
+		__field(	int,		node		)
+	),
+
+	TP_fast_assign(
+		__entry->call_site	= call_site;
+		__entry->ptr		= ptr;
+		__entry->bytes_req	= bytes_req;
+		__entry->bytes_alloc	= bytes_alloc;
+		__entry->gfp_flags	= gfp_flags;
+		__entry->node		= node;
+	),
+
+	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%s node=%d",
+		__entry->call_site,
+		__entry->ptr,
+		__entry->bytes_req,
+		__entry->bytes_alloc,
+		show_gfp_flags(__entry->gfp_flags),
+		__entry->node)
+);
+
+TRACE_EVENT(kmem_cache_alloc_node,
+
+	TP_PROTO(unsigned long call_site,
+		 const void *ptr,
+		 size_t bytes_req,
+		 size_t bytes_alloc,
+		 gfp_t gfp_flags,
+		 int node),
+
+	TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags, node),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	call_site	)
+		__field(	const void *,	ptr		)
+		__field(	size_t,		bytes_req	)
+		__field(	size_t,		bytes_alloc	)
+		__field(	gfp_t,		gfp_flags	)
+		__field(	int,		node		)
+	),
+
+	TP_fast_assign(
+		__entry->call_site	= call_site;
+		__entry->ptr		= ptr;
+		__entry->bytes_req	= bytes_req;
+		__entry->bytes_alloc	= bytes_alloc;
+		__entry->gfp_flags	= gfp_flags;
+		__entry->node		= node;
+	),
+
+	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%s node=%d",
+		__entry->call_site,
+		__entry->ptr,
+		__entry->bytes_req,
+		__entry->bytes_alloc,
+		show_gfp_flags(__entry->gfp_flags),
+		__entry->node)
+);
+
+TRACE_EVENT(kfree,
+
+	TP_PROTO(unsigned long call_site, const void *ptr),
+
+	TP_ARGS(call_site, ptr),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	call_site	)
+		__field(	const void *,	ptr		)
+	),
+
+	TP_fast_assign(
+		__entry->call_site	= call_site;
+		__entry->ptr		= ptr;
+	),
+
+	TP_printk("call_site=%lx ptr=%p", __entry->call_site, __entry->ptr)
+);
+
+TRACE_EVENT(kmem_cache_free,
+
+	TP_PROTO(unsigned long call_site, const void *ptr),
+
+	TP_ARGS(call_site, ptr),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	call_site	)
+		__field(	const void *,	ptr		)
+	),
+
+	TP_fast_assign(
+		__entry->call_site	= call_site;
+		__entry->ptr		= ptr;
+	),
+
+	TP_printk("call_site=%lx ptr=%p", __entry->call_site, __entry->ptr)
+);
+#endif /* _TRACE_KMEM_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/include/trace/events/lockdep.h b/include/trace/events/lockdep.h
new file mode 100644
index 0000000..0e956c9
--- /dev/null
+++ b/include/trace/events/lockdep.h
@@ -0,0 +1,96 @@
+#if !defined(_TRACE_LOCKDEP_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_LOCKDEP_H
+
+#include <linux/lockdep.h>
+#include <linux/tracepoint.h>
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM lockdep
+
+#ifdef CONFIG_LOCKDEP
+
+TRACE_EVENT(lock_acquire,
+
+	TP_PROTO(struct lockdep_map *lock, unsigned int subclass,
+		int trylock, int read, int check,
+		struct lockdep_map *next_lock, unsigned long ip),
+
+	TP_ARGS(lock, subclass, trylock, read, check, next_lock, ip),
+
+	TP_STRUCT__entry(
+		__field(unsigned int, flags)
+		__string(name, lock->name)
+	),
+
+	TP_fast_assign(
+		__entry->flags = (trylock ? 1 : 0) | (read ? 2 : 0);
+		__assign_str(name, lock->name);
+	),
+
+	TP_printk("%s%s%s", (__entry->flags & 1) ? "try " : "",
+		  (__entry->flags & 2) ? "read " : "",
+		  __get_str(name))
+);
+
+TRACE_EVENT(lock_release,
+
+	TP_PROTO(struct lockdep_map *lock, int nested, unsigned long ip),
+
+	TP_ARGS(lock, nested, ip),
+
+	TP_STRUCT__entry(
+		__string(name, lock->name)
+	),
+
+	TP_fast_assign(
+		__assign_str(name, lock->name);
+	),
+
+	TP_printk("%s", __get_str(name))
+);
+
+#ifdef CONFIG_LOCK_STAT
+
+TRACE_EVENT(lock_contended,
+
+	TP_PROTO(struct lockdep_map *lock, unsigned long ip),
+
+	TP_ARGS(lock, ip),
+
+	TP_STRUCT__entry(
+		__string(name, lock->name)
+	),
+
+	TP_fast_assign(
+		__assign_str(name, lock->name);
+	),
+
+	TP_printk("%s", __get_str(name))
+);
+
+TRACE_EVENT(lock_acquired,
+	TP_PROTO(struct lockdep_map *lock, unsigned long ip, s64 waittime),
+
+	TP_ARGS(lock, ip, waittime),
+
+	TP_STRUCT__entry(
+		__string(name, lock->name)
+		__field(unsigned long, wait_usec)
+		__field(unsigned long, wait_nsec_rem)
+	),
+	TP_fast_assign(
+		__assign_str(name, lock->name);
+		__entry->wait_nsec_rem = do_div(waittime, NSEC_PER_USEC);
+		__entry->wait_usec = (unsigned long) waittime;
+	),
+	TP_printk("%s (%lu.%03lu us)", __get_str(name), __entry->wait_usec,
+				       __entry->wait_nsec_rem)
+);
+
+#endif
+#endif
+
+#endif /* _TRACE_LOCKDEP_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/include/trace/sched_event_types.h b/include/trace/events/sched.h
similarity index 91%
rename from include/trace/sched_event_types.h
rename to include/trace/events/sched.h
index 63547dc..24ab5bc 100644
--- a/include/trace/sched_event_types.h
+++ b/include/trace/events/sched.h
@@ -1,9 +1,8 @@
+#if !defined(_TRACE_SCHED_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_SCHED_H
 
-/* use <trace/sched.h> instead */
-#ifndef TRACE_EVENT
-# error Do not include this file directly.
-# error Unless you know what you are doing.
-#endif
+#include <linux/sched.h>
+#include <linux/tracepoint.h>
 
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM sched
@@ -157,6 +156,7 @@ TRACE_EVENT(sched_switch,
 		__array(	char,	prev_comm,	TASK_COMM_LEN	)
 		__field(	pid_t,	prev_pid			)
 		__field(	int,	prev_prio			)
+		__field(	long,	prev_state			)
 		__array(	char,	next_comm,	TASK_COMM_LEN	)
 		__field(	pid_t,	next_pid			)
 		__field(	int,	next_prio			)
@@ -166,13 +166,19 @@ TRACE_EVENT(sched_switch,
 		memcpy(__entry->next_comm, next->comm, TASK_COMM_LEN);
 		__entry->prev_pid	= prev->pid;
 		__entry->prev_prio	= prev->prio;
+		__entry->prev_state	= prev->state;
 		memcpy(__entry->prev_comm, prev->comm, TASK_COMM_LEN);
 		__entry->next_pid	= next->pid;
 		__entry->next_prio	= next->prio;
 	),
 
-	TP_printk("task %s:%d [%d] ==> %s:%d [%d]",
+	TP_printk("task %s:%d [%d] (%s) ==> %s:%d [%d]",
 		__entry->prev_comm, __entry->prev_pid, __entry->prev_prio,
+		__entry->prev_state ?
+		  __print_flags(__entry->prev_state, "|",
+				{ 1, "S"} , { 2, "D" }, { 4, "T" }, { 8, "t" },
+				{ 16, "Z" }, { 32, "X" }, { 64, "x" },
+				{ 128, "W" }) : "R",
 		__entry->next_comm, __entry->next_pid, __entry->next_prio)
 );
 
@@ -181,9 +187,9 @@ TRACE_EVENT(sched_switch,
  */
 TRACE_EVENT(sched_migrate_task,
 
-	TP_PROTO(struct task_struct *p, int orig_cpu, int dest_cpu),
+	TP_PROTO(struct task_struct *p, int dest_cpu),
 
-	TP_ARGS(p, orig_cpu, dest_cpu),
+	TP_ARGS(p, dest_cpu),
 
 	TP_STRUCT__entry(
 		__array(	char,	comm,	TASK_COMM_LEN	)
@@ -197,7 +203,7 @@ TRACE_EVENT(sched_migrate_task,
 		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
 		__entry->pid		= p->pid;
 		__entry->prio		= p->prio;
-		__entry->orig_cpu	= orig_cpu;
+		__entry->orig_cpu	= task_cpu(p);
 		__entry->dest_cpu	= dest_cpu;
 	),
 
@@ -334,4 +340,7 @@ TRACE_EVENT(sched_signal_send,
 		  __entry->sig, __entry->comm, __entry->pid)
 );
 
-#undef TRACE_SYSTEM
+#endif /* _TRACE_SCHED_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
new file mode 100644
index 0000000..1e8fabb
--- /dev/null
+++ b/include/trace/events/skb.h
@@ -0,0 +1,40 @@
+#if !defined(_TRACE_SKB_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_SKB_H
+
+#include <linux/skbuff.h>
+#include <linux/tracepoint.h>
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM skb
+
+/*
+ * Tracepoint for free an sk_buff:
+ */
+TRACE_EVENT(kfree_skb,
+
+	TP_PROTO(struct sk_buff *skb, void *location),
+
+	TP_ARGS(skb, location),
+
+	TP_STRUCT__entry(
+		__field(	void *,		skbaddr		)
+		__field(	unsigned short,	protocol	)
+		__field(	void *,		location	)
+	),
+
+	TP_fast_assign(
+		__entry->skbaddr = skb;
+		if (skb) {
+			__entry->protocol = ntohs(skb->protocol);
+		}
+		__entry->location = location;
+	),
+
+	TP_printk("skbaddr=%p protocol=%u location=%p",
+		__entry->skbaddr, __entry->protocol, __entry->location)
+);
+
+#endif /* _TRACE_SKB_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/include/trace/events/workqueue.h b/include/trace/events/workqueue.h
new file mode 100644
index 0000000..035f1bf
--- /dev/null
+++ b/include/trace/events/workqueue.h
@@ -0,0 +1,100 @@
+#if !defined(_TRACE_WORKQUEUE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_WORKQUEUE_H
+
+#include <linux/workqueue.h>
+#include <linux/sched.h>
+#include <linux/tracepoint.h>
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM workqueue
+
+TRACE_EVENT(workqueue_insertion,
+
+	TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
+
+	TP_ARGS(wq_thread, work),
+
+	TP_STRUCT__entry(
+		__array(char,		thread_comm,	TASK_COMM_LEN)
+		__field(pid_t,		thread_pid)
+		__field(work_func_t,	func)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->thread_comm, wq_thread->comm, TASK_COMM_LEN);
+		__entry->thread_pid	= wq_thread->pid;
+		__entry->func		= work->func;
+	),
+
+	TP_printk("thread=%s:%d func=%pF", __entry->thread_comm,
+		__entry->thread_pid, __entry->func)
+);
+
+TRACE_EVENT(workqueue_execution,
+
+	TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
+
+	TP_ARGS(wq_thread, work),
+
+	TP_STRUCT__entry(
+		__array(char,		thread_comm,	TASK_COMM_LEN)
+		__field(pid_t,		thread_pid)
+		__field(work_func_t,	func)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->thread_comm, wq_thread->comm, TASK_COMM_LEN);
+		__entry->thread_pid	= wq_thread->pid;
+		__entry->func		= work->func;
+	),
+
+	TP_printk("thread=%s:%d func=%pF", __entry->thread_comm,
+		__entry->thread_pid, __entry->func)
+);
+
+/* Trace the creation of one workqueue thread on a cpu */
+TRACE_EVENT(workqueue_creation,
+
+	TP_PROTO(struct task_struct *wq_thread, int cpu),
+
+	TP_ARGS(wq_thread, cpu),
+
+	TP_STRUCT__entry(
+		__array(char,	thread_comm,	TASK_COMM_LEN)
+		__field(pid_t,	thread_pid)
+		__field(int,	cpu)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->thread_comm, wq_thread->comm, TASK_COMM_LEN);
+		__entry->thread_pid	= wq_thread->pid;
+		__entry->cpu		= cpu;
+	),
+
+	TP_printk("thread=%s:%d cpu=%d", __entry->thread_comm,
+		__entry->thread_pid, __entry->cpu)
+);
+
+TRACE_EVENT(workqueue_destruction,
+
+	TP_PROTO(struct task_struct *wq_thread),
+
+	TP_ARGS(wq_thread),
+
+	TP_STRUCT__entry(
+		__array(char,	thread_comm,	TASK_COMM_LEN)
+		__field(pid_t,	thread_pid)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->thread_comm, wq_thread->comm, TASK_COMM_LEN);
+		__entry->thread_pid	= wq_thread->pid;
+	),
+
+	TP_printk("thread=%s:%d", __entry->thread_comm, __entry->thread_pid)
+);
+
+#endif /* _TRACE_WORKQUEUE_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
new file mode 100644
index 0000000..1867553
--- /dev/null
+++ b/include/trace/ftrace.h
@@ -0,0 +1,591 @@
+/*
+ * Stage 1 of the trace events.
+ *
+ * Override the macros in <trace/trace_events.h> to include the following:
+ *
+ * struct ftrace_raw_<call> {
+ *	struct trace_entry		ent;
+ *	<type>				<item>;
+ *	<type2>				<item2>[<len>];
+ *	[...]
+ * };
+ *
+ * The <type> <item> is created by the __field(type, item) macro or
+ * the __array(type2, item2, len) macro.
+ * We simply do "type item;", and that will create the fields
+ * in the structure.
+ */
+
+#include <linux/ftrace_event.h>
+
+#undef __field
+#define __field(type, item)		type	item;
+
+#undef __array
+#define __array(type, item, len)	type	item[len];
+
+#undef __dynamic_array
+#define __dynamic_array(type, item, len) unsigned short __data_loc_##item;
+
+#undef __string
+#define __string(item, src) __dynamic_array(char, item, -1)
+
+#undef TP_STRUCT__entry
+#define TP_STRUCT__entry(args...) args
+
+#undef TRACE_EVENT
+#define TRACE_EVENT(name, proto, args, tstruct, assign, print)	\
+	struct ftrace_raw_##name {				\
+		struct trace_entry	ent;			\
+		tstruct						\
+		char			__data[0];		\
+	};							\
+	static struct ftrace_event_call event_##name
+
+#include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
+
+
+/*
+ * Stage 2 of the trace events.
+ *
+ * Include the following:
+ *
+ * struct ftrace_data_offsets_<call> {
+ *	int				<item1>;
+ *	int				<item2>;
+ *	[...]
+ * };
+ *
+ * The __dynamic_array() macro will create each int <item>, this is
+ * to keep the offset of each array from the beginning of the event.
+ */
+
+#undef __field
+#define __field(type, item);
+
+#undef __array
+#define __array(type, item, len)
+
+#undef __dynamic_array
+#define __dynamic_array(type, item, len)	int item;
+
+#undef __string
+#define __string(item, src) __dynamic_array(char, item, -1)
+
+#undef TRACE_EVENT
+#define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
+	struct ftrace_data_offsets_##call {				\
+		tstruct;						\
+	};
+
+#include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
+
+/*
+ * Setup the showing format of trace point.
+ *
+ * int
+ * ftrace_format_##call(struct trace_seq *s)
+ * {
+ *	struct ftrace_raw_##call field;
+ *	int ret;
+ *
+ *	ret = trace_seq_printf(s, #type " " #item ";"
+ *			       " offset:%u; size:%u;\n",
+ *			       offsetof(struct ftrace_raw_##call, item),
+ *			       sizeof(field.type));
+ *
+ * }
+ */
+
+#undef TP_STRUCT__entry
+#define TP_STRUCT__entry(args...) args
+
+#undef __field
+#define __field(type, item)					\
+	ret = trace_seq_printf(s, "\tfield:" #type " " #item ";\t"	\
+			       "offset:%u;\tsize:%u;\n",		\
+			       (unsigned int)offsetof(typeof(field), item), \
+			       (unsigned int)sizeof(field.item));	\
+	if (!ret)							\
+		return 0;
+
+#undef __array
+#define __array(type, item, len)						\
+	ret = trace_seq_printf(s, "\tfield:" #type " " #item "[" #len "];\t"	\
+			       "offset:%u;\tsize:%u;\n",		\
+			       (unsigned int)offsetof(typeof(field), item), \
+			       (unsigned int)sizeof(field.item));	\
+	if (!ret)							\
+		return 0;
+
+#undef __dynamic_array
+#define __dynamic_array(type, item, len)				       \
+	ret = trace_seq_printf(s, "\tfield:__data_loc " #item ";\t"	       \
+			       "offset:%u;\tsize:%u;\n",		       \
+			       (unsigned int)offsetof(typeof(field),	       \
+					__data_loc_##item),		       \
+			       (unsigned int)sizeof(field.__data_loc_##item)); \
+	if (!ret)							       \
+		return 0;
+
+#undef __string
+#define __string(item, src) __dynamic_array(char, item, -1)
+
+#undef __entry
+#define __entry REC
+
+#undef __print_symbolic
+#undef __get_dynamic_array
+#undef __get_str
+
+#undef TP_printk
+#define TP_printk(fmt, args...) "%s, %s\n", #fmt, __stringify(args)
+
+#undef TP_fast_assign
+#define TP_fast_assign(args...) args
+
+#undef TRACE_EVENT
+#define TRACE_EVENT(call, proto, args, tstruct, func, print)		\
+static int								\
+ftrace_format_##call(struct trace_seq *s)				\
+{									\
+	struct ftrace_raw_##call field __attribute__((unused));		\
+	int ret = 0;							\
+									\
+	tstruct;							\
+									\
+	trace_seq_printf(s, "\nprint fmt: " print);			\
+									\
+	return ret;							\
+}
+
+#include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
+
+/*
+ * Stage 3 of the trace events.
+ *
+ * Override the macros in <trace/trace_events.h> to include the following:
+ *
+ * enum print_line_t
+ * ftrace_raw_output_<call>(struct trace_iterator *iter, int flags)
+ * {
+ *	struct trace_seq *s = &iter->seq;
+ *	struct ftrace_raw_<call> *field; <-- defined in stage 1
+ *	struct trace_entry *entry;
+ *	struct trace_seq *p;
+ *	int ret;
+ *
+ *	entry = iter->ent;
+ *
+ *	if (entry->type != event_<call>.id) {
+ *		WARN_ON_ONCE(1);
+ *		return TRACE_TYPE_UNHANDLED;
+ *	}
+ *
+ *	field = (typeof(field))entry;
+ *
+ *	p = get_cpu_var(ftrace_event_seq);
+ *	trace_seq_init(p);
+ *	ret = trace_seq_printf(s, <TP_printk> "\n");
+ *	put_cpu();
+ *	if (!ret)
+ *		return TRACE_TYPE_PARTIAL_LINE;
+ *
+ *	return TRACE_TYPE_HANDLED;
+ * }
+ *
+ * This is the method used to print the raw event to the trace
+ * output format. Note, this is not needed if the data is read
+ * in binary.
+ */
+
+#undef __entry
+#define __entry field
+
+#undef TP_printk
+#define TP_printk(fmt, args...) fmt "\n", args
+
+#undef __get_dynamic_array
+#define __get_dynamic_array(field)	\
+		((void *)__entry + __entry->__data_loc_##field)
+
+#undef __get_str
+#define __get_str(field) (char *)__get_dynamic_array(field)
+
+#undef __print_flags
+#define __print_flags(flag, delim, flag_array...)			\
+	({								\
+		static const struct trace_print_flags flags[] =		\
+			{ flag_array, { -1, NULL }};			\
+		ftrace_print_flags_seq(p, delim, flag, flags);		\
+	})
+
+#undef __print_symbolic
+#define __print_symbolic(value, symbol_array...)			\
+	({								\
+		static const struct trace_print_flags symbols[] =	\
+			{ symbol_array, { -1, NULL }};			\
+		ftrace_print_symbols_seq(p, value, symbols);		\
+	})
+
+#undef TRACE_EVENT
+#define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
+enum print_line_t							\
+ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
+{									\
+	struct trace_seq *s = &iter->seq;				\
+	struct ftrace_raw_##call *field;				\
+	struct trace_entry *entry;					\
+	struct trace_seq *p;						\
+	int ret;							\
+									\
+	entry = iter->ent;						\
+									\
+	if (entry->type != event_##call.id) {				\
+		WARN_ON_ONCE(1);					\
+		return TRACE_TYPE_UNHANDLED;				\
+	}								\
+									\
+	field = (typeof(field))entry;					\
+									\
+	p = &get_cpu_var(ftrace_event_seq);				\
+	trace_seq_init(p);						\
+	ret = trace_seq_printf(s, #call ": " print);			\
+	put_cpu();							\
+	if (!ret)							\
+		return TRACE_TYPE_PARTIAL_LINE;				\
+									\
+	return TRACE_TYPE_HANDLED;					\
+}
+	
+#include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
+
+#undef __field
+#define __field(type, item)						\
+	ret = trace_define_field(event_call, #type, #item,		\
+				 offsetof(typeof(field), item),		\
+				 sizeof(field.item), is_signed_type(type));	\
+	if (ret)							\
+		return ret;
+
+#undef __array
+#define __array(type, item, len)					\
+	BUILD_BUG_ON(len > MAX_FILTER_STR_VAL);				\
+	ret = trace_define_field(event_call, #type "[" #len "]", #item,	\
+				 offsetof(typeof(field), item),		\
+				 sizeof(field.item), 0);		\
+	if (ret)							\
+		return ret;
+
+#undef __dynamic_array
+#define __dynamic_array(type, item, len)				       \
+	ret = trace_define_field(event_call, "__data_loc" "[" #type "]", #item,\
+				offsetof(typeof(field), __data_loc_##item),    \
+				 sizeof(field.__data_loc_##item), 0);
+
+#undef __string
+#define __string(item, src) __dynamic_array(char, item, -1)
+
+#undef TRACE_EVENT
+#define TRACE_EVENT(call, proto, args, tstruct, func, print)		\
+int									\
+ftrace_define_fields_##call(void)					\
+{									\
+	struct ftrace_raw_##call field;					\
+	struct ftrace_event_call *event_call = &event_##call;		\
+	int ret;							\
+									\
+	__common_field(int, type, 1);					\
+	__common_field(unsigned char, flags, 0);			\
+	__common_field(unsigned char, preempt_count, 0);		\
+	__common_field(int, pid, 1);					\
+	__common_field(int, tgid, 1);					\
+									\
+	tstruct;							\
+									\
+	return ret;							\
+}
+
+#include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
+
+/*
+ * remember the offset of each array from the beginning of the event.
+ */
+
+#undef __entry
+#define __entry entry
+
+#undef __field
+#define __field(type, item)
+
+#undef __array
+#define __array(type, item, len)
+
+#undef __dynamic_array
+#define __dynamic_array(type, item, len)				\
+	__data_offsets->item = __data_size +				\
+			       offsetof(typeof(*entry), __data);	\
+	__data_size += (len) * sizeof(type);
+
+#undef __string
+#define __string(item, src) __dynamic_array(char, item, strlen(src) + 1)       \
+
+#undef TRACE_EVENT
+#define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
+static inline int ftrace_get_offsets_##call(				\
+	struct ftrace_data_offsets_##call *__data_offsets, proto)       \
+{									\
+	int __data_size = 0;						\
+	struct ftrace_raw_##call __maybe_unused *entry;			\
+									\
+	tstruct;							\
+									\
+	return __data_size;						\
+}
+
+#include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
+
+/*
+ * Stage 4 of the trace events.
+ *
+ * Override the macros in <trace/trace_events.h> to include the following:
+ *
+ * static void ftrace_event_<call>(proto)
+ * {
+ *	event_trace_printk(_RET_IP_, "<call>: " <fmt>);
+ * }
+ *
+ * static int ftrace_reg_event_<call>(void)
+ * {
+ *	int ret;
+ *
+ *	ret = register_trace_<call>(ftrace_event_<call>);
+ *	if (!ret)
+ *		pr_info("event trace: Could not activate trace point "
+ *			"probe to  <call>");
+ *	return ret;
+ * }
+ *
+ * static void ftrace_unreg_event_<call>(void)
+ * {
+ *	unregister_trace_<call>(ftrace_event_<call>);
+ * }
+ *
+ *
+ * For those macros defined with TRACE_EVENT:
+ *
+ * static struct ftrace_event_call event_<call>;
+ *
+ * static void ftrace_raw_event_<call>(proto)
+ * {
+ *	struct ring_buffer_event *event;
+ *	struct ftrace_raw_<call> *entry; <-- defined in stage 1
+ *	unsigned long irq_flags;
+ *	int pc;
+ *
+ *	local_save_flags(irq_flags);
+ *	pc = preempt_count();
+ *
+ *	event = trace_current_buffer_lock_reserve(event_<call>.id,
+ *				  sizeof(struct ftrace_raw_<call>),
+ *				  irq_flags, pc);
+ *	if (!event)
+ *		return;
+ *	entry	= ring_buffer_event_data(event);
+ *
+ *	<assign>;  <-- Here we assign the entries by the __field and
+ *			__array macros.
+ *
+ *	trace_current_buffer_unlock_commit(event, irq_flags, pc);
+ * }
+ *
+ * static int ftrace_raw_reg_event_<call>(void)
+ * {
+ *	int ret;
+ *
+ *	ret = register_trace_<call>(ftrace_raw_event_<call>);
+ *	if (!ret)
+ *		pr_info("event trace: Could not activate trace point "
+ *			"probe to <call>");
+ *	return ret;
+ * }
+ *
+ * static void ftrace_unreg_event_<call>(void)
+ * {
+ *	unregister_trace_<call>(ftrace_raw_event_<call>);
+ * }
+ *
+ * static struct trace_event ftrace_event_type_<call> = {
+ *	.trace			= ftrace_raw_output_<call>, <-- stage 2
+ * };
+ *
+ * static int ftrace_raw_init_event_<call>(void)
+ * {
+ *	int id;
+ *
+ *	id = register_ftrace_event(&ftrace_event_type_<call>);
+ *	if (!id)
+ *		return -ENODEV;
+ *	event_<call>.id = id;
+ *	return 0;
+ * }
+ *
+ * static struct ftrace_event_call __used
+ * __attribute__((__aligned__(4)))
+ * __attribute__((section("_ftrace_events"))) event_<call> = {
+ *	.name			= "<call>",
+ *	.system			= "<system>",
+ *	.raw_init		= ftrace_raw_init_event_<call>,
+ *	.regfunc		= ftrace_reg_event_<call>,
+ *	.unregfunc		= ftrace_unreg_event_<call>,
+ *	.show_format		= ftrace_format_<call>,
+ * }
+ *
+ */
+
+#undef TP_FMT
+#define TP_FMT(fmt, args...)	fmt "\n", ##args
+
+#ifdef CONFIG_EVENT_PROFILE
+#define _TRACE_PROFILE(call, proto, args)				\
+static void ftrace_profile_##call(proto)				\
+{									\
+	extern void perf_tpcounter_event(int);				\
+	perf_tpcounter_event(event_##call.id);				\
+}									\
+									\
+static int ftrace_profile_enable_##call(struct ftrace_event_call *event_call) \
+{									\
+	int ret = 0;							\
+									\
+	if (!atomic_inc_return(&event_call->profile_count))		\
+		ret = register_trace_##call(ftrace_profile_##call);	\
+									\
+	return ret;							\
+}									\
+									\
+static void ftrace_profile_disable_##call(struct ftrace_event_call *event_call)\
+{									\
+	if (atomic_add_negative(-1, &event_call->profile_count))	\
+		unregister_trace_##call(ftrace_profile_##call);		\
+}
+
+#define _TRACE_PROFILE_INIT(call)					\
+	.profile_count = ATOMIC_INIT(-1),				\
+	.profile_enable = ftrace_profile_enable_##call,			\
+	.profile_disable = ftrace_profile_disable_##call,
+
+#else
+#define _TRACE_PROFILE(call, proto, args)
+#define _TRACE_PROFILE_INIT(call)
+#endif
+
+#undef __entry
+#define __entry entry
+
+#undef __field
+#define __field(type, item)
+
+#undef __array
+#define __array(type, item, len)
+
+#undef __dynamic_array
+#define __dynamic_array(type, item, len)				\
+	__entry->__data_loc_##item = __data_offsets.item;
+
+#undef __string
+#define __string(item, src) __dynamic_array(char, item, -1)       	\
+
+#undef __assign_str
+#define __assign_str(dst, src)						\
+	strcpy(__get_str(dst), src);
+
+#undef TRACE_EVENT
+#define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
+_TRACE_PROFILE(call, PARAMS(proto), PARAMS(args))			\
+									\
+static struct ftrace_event_call event_##call;				\
+									\
+static void ftrace_raw_event_##call(proto)				\
+{									\
+	struct ftrace_data_offsets_##call __maybe_unused __data_offsets;\
+	struct ftrace_event_call *event_call = &event_##call;		\
+	struct ring_buffer_event *event;				\
+	struct ftrace_raw_##call *entry;				\
+	unsigned long irq_flags;					\
+	int __data_size;						\
+	int pc;								\
+									\
+	local_save_flags(irq_flags);					\
+	pc = preempt_count();						\
+									\
+	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
+									\
+	event = trace_current_buffer_lock_reserve(event_##call.id,	\
+				 sizeof(*entry) + __data_size,		\
+				 irq_flags, pc);			\
+	if (!event)							\
+		return;							\
+	entry	= ring_buffer_event_data(event);			\
+									\
+									\
+	tstruct								\
+									\
+	{ assign; }							\
+									\
+	if (!filter_current_check_discard(event_call, entry, event))	\
+		trace_nowake_buffer_unlock_commit(event, irq_flags, pc); \
+}									\
+									\
+static int ftrace_raw_reg_event_##call(void)				\
+{									\
+	int ret;							\
+									\
+	ret = register_trace_##call(ftrace_raw_event_##call);		\
+	if (ret)							\
+		pr_info("event trace: Could not activate trace point "	\
+			"probe to " #call "\n");			\
+	return ret;							\
+}									\
+									\
+static void ftrace_raw_unreg_event_##call(void)				\
+{									\
+	unregister_trace_##call(ftrace_raw_event_##call);		\
+}									\
+									\
+static struct trace_event ftrace_event_type_##call = {			\
+	.trace			= ftrace_raw_output_##call,		\
+};									\
+									\
+static int ftrace_raw_init_event_##call(void)				\
+{									\
+	int id;								\
+									\
+	id = register_ftrace_event(&ftrace_event_type_##call);		\
+	if (!id)							\
+		return -ENODEV;						\
+	event_##call.id = id;						\
+	INIT_LIST_HEAD(&event_##call.fields);				\
+	init_preds(&event_##call);					\
+	return 0;							\
+}									\
+									\
+static struct ftrace_event_call __used					\
+__attribute__((__aligned__(4)))						\
+__attribute__((section("_ftrace_events"))) event_##call = {		\
+	.name			= #call,				\
+	.system			= __stringify(TRACE_SYSTEM),		\
+	.event			= &ftrace_event_type_##call,		\
+	.raw_init		= ftrace_raw_init_event_##call,		\
+	.regfunc		= ftrace_raw_reg_event_##call,		\
+	.unregfunc		= ftrace_raw_unreg_event_##call,	\
+	.show_format		= ftrace_format_##call,			\
+	.define_fields		= ftrace_define_fields_##call,		\
+	_TRACE_PROFILE_INIT(call)					\
+}
+
+#include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
+
+#undef _TRACE_PROFILE
+#undef _TRACE_PROFILE_INIT
+
diff --git a/include/trace/irq.h b/include/trace/irq.h
deleted file mode 100644
index ff5d449..0000000
--- a/include/trace/irq.h
+++ /dev/null
@@ -1,9 +0,0 @@
-#ifndef _TRACE_IRQ_H
-#define _TRACE_IRQ_H
-
-#include <linux/interrupt.h>
-#include <linux/tracepoint.h>
-
-#include <trace/irq_event_types.h>
-
-#endif
diff --git a/include/trace/irq_event_types.h b/include/trace/irq_event_types.h
deleted file mode 100644
index 85964eb..0000000
--- a/include/trace/irq_event_types.h
+++ /dev/null
@@ -1,55 +0,0 @@
-
-/* use <trace/irq.h> instead */
-#ifndef TRACE_FORMAT
-# error Do not include this file directly.
-# error Unless you know what you are doing.
-#endif
-
-#undef TRACE_SYSTEM
-#define TRACE_SYSTEM irq
-
-/*
- * Tracepoint for entry of interrupt handler:
- */
-TRACE_FORMAT(irq_handler_entry,
-	TP_PROTO(int irq, struct irqaction *action),
-	TP_ARGS(irq, action),
-	TP_FMT("irq=%d handler=%s", irq, action->name)
-	);
-
-/*
- * Tracepoint for return of an interrupt handler:
- */
-TRACE_EVENT(irq_handler_exit,
-
-	TP_PROTO(int irq, struct irqaction *action, int ret),
-
-	TP_ARGS(irq, action, ret),
-
-	TP_STRUCT__entry(
-		__field(	int,	irq	)
-		__field(	int,	ret	)
-	),
-
-	TP_fast_assign(
-		__entry->irq	= irq;
-		__entry->ret	= ret;
-	),
-
-	TP_printk("irq=%d return=%s",
-		  __entry->irq, __entry->ret ? "handled" : "unhandled")
-);
-
-TRACE_FORMAT(softirq_entry,
-	TP_PROTO(struct softirq_action *h, struct softirq_action *vec),
-	TP_ARGS(h, vec),
-	TP_FMT("softirq=%d action=%s", (int)(h - vec), softirq_to_name[h-vec])
-	);
-
-TRACE_FORMAT(softirq_exit,
-	TP_PROTO(struct softirq_action *h, struct softirq_action *vec),
-	TP_ARGS(h, vec),
-	TP_FMT("softirq=%d action=%s", (int)(h - vec), softirq_to_name[h-vec])
-	);
-
-#undef TRACE_SYSTEM
diff --git a/include/trace/kmemtrace.h b/include/trace/kmemtrace.h
deleted file mode 100644
index 28ee69f..0000000
--- a/include/trace/kmemtrace.h
+++ /dev/null
@@ -1,63 +0,0 @@
-/*
- * Copyright (C) 2008 Eduard - Gabriel Munteanu
- *
- * This file is released under GPL version 2.
- */
-
-#ifndef _LINUX_KMEMTRACE_H
-#define _LINUX_KMEMTRACE_H
-
-#ifdef __KERNEL__
-
-#include <linux/tracepoint.h>
-#include <linux/types.h>
-
-#ifdef CONFIG_KMEMTRACE
-extern void kmemtrace_init(void);
-#else
-static inline void kmemtrace_init(void)
-{
-}
-#endif
-
-DECLARE_TRACE(kmalloc,
-	      TP_PROTO(unsigned long call_site,
-		      const void *ptr,
-		      size_t bytes_req,
-		      size_t bytes_alloc,
-		      gfp_t gfp_flags),
-	      TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags));
-DECLARE_TRACE(kmem_cache_alloc,
-	      TP_PROTO(unsigned long call_site,
-		      const void *ptr,
-		      size_t bytes_req,
-		      size_t bytes_alloc,
-		      gfp_t gfp_flags),
-	      TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags));
-DECLARE_TRACE(kmalloc_node,
-	      TP_PROTO(unsigned long call_site,
-		      const void *ptr,
-		      size_t bytes_req,
-		      size_t bytes_alloc,
-		      gfp_t gfp_flags,
-		      int node),
-	      TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags, node));
-DECLARE_TRACE(kmem_cache_alloc_node,
-	      TP_PROTO(unsigned long call_site,
-		      const void *ptr,
-		      size_t bytes_req,
-		      size_t bytes_alloc,
-		      gfp_t gfp_flags,
-		      int node),
-	      TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags, node));
-DECLARE_TRACE(kfree,
-	      TP_PROTO(unsigned long call_site, const void *ptr),
-	      TP_ARGS(call_site, ptr));
-DECLARE_TRACE(kmem_cache_free,
-	      TP_PROTO(unsigned long call_site, const void *ptr),
-	      TP_ARGS(call_site, ptr));
-
-#endif /* __KERNEL__ */
-
-#endif /* _LINUX_KMEMTRACE_H */
-
diff --git a/include/trace/lockdep.h b/include/trace/lockdep.h
deleted file mode 100644
index 5ca67df..0000000
--- a/include/trace/lockdep.h
+++ /dev/null
@@ -1,9 +0,0 @@
-#ifndef _TRACE_LOCKDEP_H
-#define _TRACE_LOCKDEP_H
-
-#include <linux/lockdep.h>
-#include <linux/tracepoint.h>
-
-#include <trace/lockdep_event_types.h>
-
-#endif
diff --git a/include/trace/lockdep_event_types.h b/include/trace/lockdep_event_types.h
deleted file mode 100644
index adccfcd..0000000
--- a/include/trace/lockdep_event_types.h
+++ /dev/null
@@ -1,44 +0,0 @@
-
-#ifndef TRACE_FORMAT
-# error Do not include this file directly.
-# error Unless you know what you are doing.
-#endif
-
-#undef TRACE_SYSTEM
-#define TRACE_SYSTEM lock
-
-#ifdef CONFIG_LOCKDEP
-
-TRACE_FORMAT(lock_acquire,
-	TP_PROTO(struct lockdep_map *lock, unsigned int subclass,
-		int trylock, int read, int check,
-		struct lockdep_map *next_lock, unsigned long ip),
-	TP_ARGS(lock, subclass, trylock, read, check, next_lock, ip),
-	TP_FMT("%s%s%s", trylock ? "try " : "",
-		read ? "read " : "", lock->name)
-	);
-
-TRACE_FORMAT(lock_release,
-	TP_PROTO(struct lockdep_map *lock, int nested, unsigned long ip),
-	TP_ARGS(lock, nested, ip),
-	TP_FMT("%s", lock->name)
-	);
-
-#ifdef CONFIG_LOCK_STAT
-
-TRACE_FORMAT(lock_contended,
-	TP_PROTO(struct lockdep_map *lock, unsigned long ip),
-	TP_ARGS(lock, ip),
-	TP_FMT("%s", lock->name)
-	);
-
-TRACE_FORMAT(lock_acquired,
-	TP_PROTO(struct lockdep_map *lock, unsigned long ip),
-	TP_ARGS(lock, ip),
-	TP_FMT("%s", lock->name)
-	);
-
-#endif
-#endif
-
-#undef TRACE_SYSTEM
diff --git a/include/trace/sched.h b/include/trace/sched.h
deleted file mode 100644
index 4e372a1..0000000
--- a/include/trace/sched.h
+++ /dev/null
@@ -1,9 +0,0 @@
-#ifndef _TRACE_SCHED_H
-#define _TRACE_SCHED_H
-
-#include <linux/sched.h>
-#include <linux/tracepoint.h>
-
-#include <trace/sched_event_types.h>
-
-#endif
diff --git a/include/trace/skb.h b/include/trace/skb.h
deleted file mode 100644
index b66206d..0000000
--- a/include/trace/skb.h
+++ /dev/null
@@ -1,11 +0,0 @@
-#ifndef _TRACE_SKB_H_
-#define _TRACE_SKB_H_
-
-#include <linux/skbuff.h>
-#include <linux/tracepoint.h>
-
-DECLARE_TRACE(kfree_skb,
-	TP_PROTO(struct sk_buff *skb, void *location),
-	TP_ARGS(skb, location));
-
-#endif
diff --git a/include/trace/trace_event_types.h b/include/trace/trace_event_types.h
deleted file mode 100644
index df56f56..0000000
--- a/include/trace/trace_event_types.h
+++ /dev/null
@@ -1,5 +0,0 @@
-/* trace/<type>_event_types.h here */
-
-#include <trace/sched_event_types.h>
-#include <trace/irq_event_types.h>
-#include <trace/lockdep_event_types.h>
diff --git a/include/trace/trace_events.h b/include/trace/trace_events.h
deleted file mode 100644
index fd13750..0000000
--- a/include/trace/trace_events.h
+++ /dev/null
@@ -1,5 +0,0 @@
-/* trace/<type>.h here */
-
-#include <trace/sched.h>
-#include <trace/irq.h>
-#include <trace/lockdep.h>
diff --git a/include/trace/workqueue.h b/include/trace/workqueue.h
deleted file mode 100644
index 7626523..0000000
--- a/include/trace/workqueue.h
+++ /dev/null
@@ -1,25 +0,0 @@
-#ifndef __TRACE_WORKQUEUE_H
-#define __TRACE_WORKQUEUE_H
-
-#include <linux/tracepoint.h>
-#include <linux/workqueue.h>
-#include <linux/sched.h>
-
-DECLARE_TRACE(workqueue_insertion,
-	   TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
-	   TP_ARGS(wq_thread, work));
-
-DECLARE_TRACE(workqueue_execution,
-	   TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
-	   TP_ARGS(wq_thread, work));
-
-/* Trace the creation of one workqueue thread on a cpu */
-DECLARE_TRACE(workqueue_creation,
-	   TP_PROTO(struct task_struct *wq_thread, int cpu),
-	   TP_ARGS(wq_thread, cpu));
-
-DECLARE_TRACE(workqueue_destruction,
-	   TP_PROTO(struct task_struct *wq_thread),
-	   TP_ARGS(wq_thread));
-
-#endif /* __TRACE_WORKQUEUE_H */
diff --git a/init/main.c b/init/main.c
index 3bbf93b..7c6a652 100644
--- a/init/main.c
+++ b/init/main.c
@@ -64,6 +64,7 @@
 #include <linux/idr.h>
 #include <linux/ftrace.h>
 #include <linux/async.h>
+#include <linux/kmemtrace.h>
 #include <trace/boot.h>
 
 #include <asm/io.h>
@@ -71,7 +72,6 @@
 #include <asm/setup.h>
 #include <asm/sections.h>
 #include <asm/cacheflush.h>
-#include <trace/kmemtrace.h>
 
 #ifdef CONFIG_X86_LOCAL_APIC
 #include <asm/smp.h>
diff --git a/kernel/Makefile b/kernel/Makefile
index 4242366..a35eee3 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -93,6 +93,7 @@ obj-$(CONFIG_LATENCYTOP) += latencytop.o
 obj-$(CONFIG_HAVE_GENERIC_DMA_COHERENT) += dma-coherent.o
 obj-$(CONFIG_FUNCTION_TRACER) += trace/
 obj-$(CONFIG_TRACING) += trace/
+obj-$(CONFIG_X86_DS) += trace/
 obj-$(CONFIG_SMP) += sched_cpupri.o
 obj-$(CONFIG_SLOW_WORK) += slow-work.o
 
diff --git a/kernel/exit.c b/kernel/exit.c
index abf9cf3..cab535c 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -48,7 +48,7 @@
 #include <linux/tracehook.h>
 #include <linux/fs_struct.h>
 #include <linux/init_task.h>
-#include <trace/sched.h>
+#include <trace/events/sched.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -56,10 +56,6 @@
 #include <asm/mmu_context.h>
 #include "cred-internals.h"
 
-DEFINE_TRACE(sched_process_free);
-DEFINE_TRACE(sched_process_exit);
-DEFINE_TRACE(sched_process_wait);
-
 static void exit_mm(struct task_struct * tsk);
 
 static void __unhash_process(struct task_struct *p)
diff --git a/kernel/fork.c b/kernel/fork.c
index b9e2edd..711468f 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -61,7 +61,6 @@
 #include <linux/proc_fs.h>
 #include <linux/blkdev.h>
 #include <linux/fs_struct.h>
-#include <trace/sched.h>
 #include <linux/magic.h>
 
 #include <asm/pgtable.h>
@@ -71,6 +70,8 @@
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 
+#include <trace/events/sched.h>
+
 /*
  * Protected counters by write_lock_irq(&tasklist_lock)
  */
@@ -83,8 +84,6 @@ DEFINE_PER_CPU(unsigned long, process_counts) = 0;
 
 __cacheline_aligned DEFINE_RWLOCK(tasklist_lock);  /* outer */
 
-DEFINE_TRACE(sched_process_fork);
-
 int nr_processes(void)
 {
 	int cpu;
@@ -1089,8 +1088,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 #ifdef CONFIG_DEBUG_MUTEXES
 	p->blocked_on = NULL; /* not blocked yet */
 #endif
-	if (unlikely(current->ptrace))
-		ptrace_fork(p, clone_flags);
+
+	p->bts = NULL;
 
 	/* Perform scheduler related setup. Assign this task to a CPU. */
 	sched_fork(p, clone_flags);
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 26e0875..5dd2572 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -17,8 +17,8 @@
 #include <linux/kernel_stat.h>
 #include <linux/rculist.h>
 #include <linux/hash.h>
-#include <trace/irq.h>
 #include <linux/bootmem.h>
+#include <trace/events/irq.h>
 
 #include "internals.h"
 
@@ -348,9 +348,6 @@ static void warn_no_thread(unsigned int irq, struct irqaction *action)
 	       "but no thread function available.", irq, action->name);
 }
 
-DEFINE_TRACE(irq_handler_entry);
-DEFINE_TRACE(irq_handler_exit);
-
 /**
  * handle_IRQ_event - irq action chain handler
  * @irq:	the interrupt number
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 4ebaf85..41c88fe 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -13,7 +13,7 @@
 #include <linux/file.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
-#include <trace/sched.h>
+#include <trace/events/sched.h>
 
 #define KTHREAD_NICE_LEVEL (-5)
 
@@ -21,9 +21,6 @@ static DEFINE_SPINLOCK(kthread_create_lock);
 static LIST_HEAD(kthread_create_list);
 struct task_struct *kthreadd_task;
 
-DEFINE_TRACE(sched_kthread_stop);
-DEFINE_TRACE(sched_kthread_stop_ret);
-
 struct kthread_create_info
 {
 	/* Information passed to kthread() from kthreadd. */
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index accb40c..8bbeef9 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -42,12 +42,14 @@
 #include <linux/hash.h>
 #include <linux/ftrace.h>
 #include <linux/stringify.h>
-#include <trace/lockdep.h>
 
 #include <asm/sections.h>
 
 #include "lockdep_internals.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/lockdep.h>
+
 #ifdef CONFIG_PROVE_LOCKING
 int prove_locking = 1;
 module_param(prove_locking, int, 0644);
@@ -2935,8 +2937,6 @@ void lock_set_class(struct lockdep_map *lock, const char *name,
 }
 EXPORT_SYMBOL_GPL(lock_set_class);
 
-DEFINE_TRACE(lock_acquire);
-
 /*
  * We are not always called with irqs disabled - do that here,
  * and also avoid lockdep recursion:
@@ -2963,8 +2963,6 @@ void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 }
 EXPORT_SYMBOL_GPL(lock_acquire);
 
-DEFINE_TRACE(lock_release);
-
 void lock_release(struct lockdep_map *lock, int nested,
 			  unsigned long ip)
 {
@@ -3105,6 +3103,8 @@ found_it:
 		hlock->holdtime_stamp = now;
 	}
 
+	trace_lock_acquired(lock, ip, waittime);
+
 	stats = get_lock_stats(hlock_class(hlock));
 	if (waittime) {
 		if (hlock->read)
@@ -3120,8 +3120,6 @@ found_it:
 	lock->ip = ip;
 }
 
-DEFINE_TRACE(lock_contended);
-
 void lock_contended(struct lockdep_map *lock, unsigned long ip)
 {
 	unsigned long flags;
@@ -3143,14 +3141,10 @@ void lock_contended(struct lockdep_map *lock, unsigned long ip)
 }
 EXPORT_SYMBOL_GPL(lock_contended);
 
-DEFINE_TRACE(lock_acquired);
-
 void lock_acquired(struct lockdep_map *lock, unsigned long ip)
 {
 	unsigned long flags;
 
-	trace_lock_acquired(lock, ip);
-
 	if (unlikely(!lock_stat))
 		return;
 
diff --git a/kernel/module.c b/kernel/module.c
index e797812..2383e60 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -18,6 +18,7 @@
 */
 #include <linux/module.h>
 #include <linux/moduleloader.h>
+#include <linux/ftrace_event.h>
 #include <linux/init.h>
 #include <linux/kallsyms.h>
 #include <linux/fs.h>
@@ -1489,9 +1490,6 @@ static void free_module(struct module *mod)
 	/* Free any allocated parameters. */
 	destroy_params(mod->kp, mod->num_kp);
 
-	/* release any pointers to mcount in this module */
-	ftrace_release(mod->module_core, mod->core_size);
-
 	/* This may be NULL, but that's OK */
 	module_free(mod, mod->module_init);
 	kfree(mod->args);
@@ -1892,11 +1890,9 @@ static noinline struct module *load_module(void __user *umod,
 	unsigned int symindex = 0;
 	unsigned int strindex = 0;
 	unsigned int modindex, versindex, infoindex, pcpuindex;
-	unsigned int num_mcount;
 	struct module *mod;
 	long err = 0;
 	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
-	unsigned long *mseg;
 	mm_segment_t old_fs;
 
 	DEBUGP("load_module: umod=%p, len=%lu, uargs=%p\n",
@@ -2172,7 +2168,19 @@ static noinline struct module *load_module(void __user *umod,
 					sizeof(*mod->tracepoints),
 					&mod->num_tracepoints);
 #endif
-
+#ifdef CONFIG_EVENT_TRACING
+	mod->trace_events = section_objs(hdr, sechdrs, secstrings,
+					 "_ftrace_events",
+					 sizeof(*mod->trace_events),
+					 &mod->num_trace_events);
+#endif
+#ifdef CONFIG_FTRACE_MCOUNT_RECORD
+	/* sechdrs[0].sh_size is always zero */
+	mod->ftrace_callsites = section_objs(hdr, sechdrs, secstrings,
+					     "__mcount_loc",
+					     sizeof(*mod->ftrace_callsites),
+					     &mod->num_ftrace_callsites);
+#endif
 #ifdef CONFIG_MODVERSIONS
 	if ((mod->num_syms && !mod->crcs)
 	    || (mod->num_gpl_syms && !mod->gpl_crcs)
@@ -2237,11 +2245,6 @@ static noinline struct module *load_module(void __user *umod,
 			dynamic_debug_setup(debug, num_debug);
 	}
 
-	/* sechdrs[0].sh_size is always zero */
-	mseg = section_objs(hdr, sechdrs, secstrings, "__mcount_loc",
-			    sizeof(*mseg), &num_mcount);
-	ftrace_init_module(mod, mseg, mseg + num_mcount);
-
 	err = module_finalize(hdr, sechdrs, mod);
 	if (err < 0)
 		goto cleanup;
@@ -2302,7 +2305,6 @@ static noinline struct module *load_module(void __user *umod,
  cleanup:
 	kobject_del(&mod->mkobj.kobj);
 	kobject_put(&mod->mkobj.kobj);
-	ftrace_release(mod->module_core, mod->core_size);
  free_unload:
 	module_unload_free(mod);
 #if defined(CONFIG_MODULE_UNLOAD) && defined(CONFIG_SMP)
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 0692ab5..e950805 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -25,16 +25,6 @@
 
 
 /*
- * Initialize a new task whose father had been ptraced.
- *
- * Called from copy_process().
- */
-void ptrace_fork(struct task_struct *child, unsigned long clone_flags)
-{
-	arch_ptrace_fork(child, clone_flags);
-}
-
-/*
  * ptrace a task: make the debugger its new parent and
  * move it to the ptrace list.
  *
diff --git a/kernel/sched.c b/kernel/sched.c
index 26efa47..6530a27 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -72,13 +72,15 @@
 #include <linux/debugfs.h>
 #include <linux/ctype.h>
 #include <linux/ftrace.h>
-#include <trace/sched.h>
 
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
 
 #include "sched_cpupri.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/sched.h>
+
 /*
  * Convert user-nice values [ -20 ... 0 ... 19 ]
  * to static priority [ MAX_RT_PRIO..MAX_PRIO-1 ],
@@ -118,12 +120,6 @@
  */
 #define RUNTIME_INF	((u64)~0ULL)
 
-DEFINE_TRACE(sched_wait_task);
-DEFINE_TRACE(sched_wakeup);
-DEFINE_TRACE(sched_wakeup_new);
-DEFINE_TRACE(sched_switch);
-DEFINE_TRACE(sched_migrate_task);
-
 #ifdef CONFIG_SMP
 
 static void double_rq_lock(struct rq *rq1, struct rq *rq2);
@@ -1958,7 +1954,7 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 
 	clock_offset = old_rq->clock - new_rq->clock;
 
-	trace_sched_migrate_task(p, task_cpu(p), new_cpu);
+	trace_sched_migrate_task(p, new_cpu);
 
 #ifdef CONFIG_SCHEDSTATS
 	if (p->se.wait_start)
@@ -2015,6 +2011,49 @@ migrate_task(struct task_struct *p, int dest_cpu, struct migration_req *req)
 }
 
 /*
+ * wait_task_context_switch -	wait for a thread to complete at least one
+ *				context switch.
+ *
+ * @p must not be current.
+ */
+void wait_task_context_switch(struct task_struct *p)
+{
+	unsigned long nvcsw, nivcsw, flags;
+	int running;
+	struct rq *rq;
+
+	nvcsw	= p->nvcsw;
+	nivcsw	= p->nivcsw;
+	for (;;) {
+		/*
+		 * The runqueue is assigned before the actual context
+		 * switch. We need to take the runqueue lock.
+		 *
+		 * We could check initially without the lock but it is
+		 * very likely that we need to take the lock in every
+		 * iteration.
+		 */
+		rq = task_rq_lock(p, &flags);
+		running = task_running(rq, p);
+		task_rq_unlock(rq, &flags);
+
+		if (likely(!running))
+			break;
+		/*
+		 * The switch count is incremented before the actual
+		 * context switch. We thus wait for two switches to be
+		 * sure at least one completed.
+		 */
+		if ((p->nvcsw - nvcsw) > 1)
+			break;
+		if ((p->nivcsw - nivcsw) > 1)
+			break;
+
+		cpu_relax();
+	}
+}
+
+/*
  * wait_task_inactive - wait for a thread to unschedule.
  *
  * If @match_state is nonzero, it's the @p->state value just checked and
diff --git a/kernel/signal.c b/kernel/signal.c
index d803473..94ec0a4 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -27,7 +27,7 @@
 #include <linux/freezer.h>
 #include <linux/pid_namespace.h>
 #include <linux/nsproxy.h>
-#include <trace/sched.h>
+#include <trace/events/sched.h>
 
 #include <asm/param.h>
 #include <asm/uaccess.h>
@@ -41,8 +41,6 @@
 
 static struct kmem_cache *sigqueue_cachep;
 
-DEFINE_TRACE(sched_signal_send);
-
 static void __user *sig_handler(struct task_struct *t, int sig)
 {
 	return t->sighand->action[sig - 1].sa.sa_handler;
diff --git a/kernel/softirq.c b/kernel/softirq.c
index b525dd3..dc4d0cf 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -24,7 +24,9 @@
 #include <linux/ftrace.h>
 #include <linux/smp.h>
 #include <linux/tick.h>
-#include <trace/irq.h>
+
+#define CREATE_TRACE_POINTS
+#include <trace/events/irq.h>
 
 #include <asm/irq.h>
 /*
@@ -186,9 +188,6 @@ EXPORT_SYMBOL(local_bh_enable_ip);
  */
 #define MAX_SOFTIRQ_RESTART 10
 
-DEFINE_TRACE(softirq_entry);
-DEFINE_TRACE(softirq_exit);
-
 asmlinkage void __do_softirq(void)
 {
 	struct softirq_action *h;
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 417d198..4a13e5a 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -48,6 +48,21 @@ config FTRACE_NMI_ENTER
        depends on HAVE_FTRACE_NMI_ENTER
        default y
 
+config EVENT_TRACING
+	select CONTEXT_SWITCH_TRACER
+	bool
+
+config CONTEXT_SWITCH_TRACER
+	select MARKERS
+	bool
+
+# All tracer options should select GENERIC_TRACER. For those options that are
+# enabled by all tracers (context switch and event tracer) they select TRACING.
+# This allows those options to appear when no other tracer is selected. But the
+# options do not appear when something else selects it. We need the two options
+# GENERIC_TRACER and TRACING to avoid circular dependencies to accomplish the
+# hidding of the automatic options options.
+
 config TRACING
 	bool
 	select DEBUG_FS
@@ -56,6 +71,11 @@ config TRACING
 	select TRACEPOINTS
 	select NOP_TRACER
 	select BINARY_PRINTF
+	select EVENT_TRACING
+
+config GENERIC_TRACER
+	bool
+	select TRACING
 
 #
 # Minimum requirements an architecture has to meet for us to
@@ -73,14 +93,20 @@ config TRACING_SUPPORT
 
 if TRACING_SUPPORT
 
-menu "Tracers"
+menuconfig FTRACE
+	bool "Tracers"
+	default y if DEBUG_KERNEL
+	help
+	 Enable the kernel tracing infrastructure.
+
+if FTRACE
 
 config FUNCTION_TRACER
 	bool "Kernel Function Tracer"
 	depends on HAVE_FUNCTION_TRACER
 	select FRAME_POINTER
 	select KALLSYMS
-	select TRACING
+	select GENERIC_TRACER
 	select CONTEXT_SWITCH_TRACER
 	help
 	  Enable the kernel to trace every kernel function. This is done
@@ -104,13 +130,14 @@ config FUNCTION_GRAPH_TRACER
 	  the return value. This is done by setting the current return 
 	  address on the current task structure into a stack of calls.
 
+
 config IRQSOFF_TRACER
 	bool "Interrupts-off Latency Tracer"
 	default n
 	depends on TRACE_IRQFLAGS_SUPPORT
 	depends on GENERIC_TIME
 	select TRACE_IRQFLAGS
-	select TRACING
+	select GENERIC_TRACER
 	select TRACER_MAX_TRACE
 	help
 	  This option measures the time spent in irqs-off critical
@@ -131,7 +158,7 @@ config PREEMPT_TRACER
 	default n
 	depends on GENERIC_TIME
 	depends on PREEMPT
-	select TRACING
+	select GENERIC_TRACER
 	select TRACER_MAX_TRACE
 	help
 	  This option measures the time spent in preemption off critical
@@ -150,7 +177,7 @@ config PREEMPT_TRACER
 config SYSPROF_TRACER
 	bool "Sysprof Tracer"
 	depends on X86
-	select TRACING
+	select GENERIC_TRACER
 	select CONTEXT_SWITCH_TRACER
 	help
 	  This tracer provides the trace needed by the 'Sysprof' userspace
@@ -158,40 +185,33 @@ config SYSPROF_TRACER
 
 config SCHED_TRACER
 	bool "Scheduling Latency Tracer"
-	select TRACING
+	select GENERIC_TRACER
 	select CONTEXT_SWITCH_TRACER
 	select TRACER_MAX_TRACE
 	help
 	  This tracer tracks the latency of the highest priority task
 	  to be scheduled in, starting from the point it has woken up.
 
-config CONTEXT_SWITCH_TRACER
-	bool "Trace process context switches"
-	select TRACING
-	select MARKERS
-	help
-	  This tracer gets called from the context switch and records
-	  all switching of tasks.
-
-config EVENT_TRACER
-	bool "Trace various events in the kernel"
+config ENABLE_DEFAULT_TRACERS
+	bool "Trace process context switches and events"
+	depends on !GENERIC_TRACER
 	select TRACING
 	help
 	  This tracer hooks to various trace points in the kernel
 	  allowing the user to pick and choose which trace point they
-	  want to trace.
+	  want to trace. It also includes the sched_switch tracer plugin.
 
 config FTRACE_SYSCALLS
 	bool "Trace syscalls"
 	depends on HAVE_FTRACE_SYSCALLS
-	select TRACING
+	select GENERIC_TRACER
 	select KALLSYMS
 	help
 	  Basic tracer to catch the syscall entry and exit events.
 
 config BOOT_TRACER
 	bool "Trace boot initcalls"
-	select TRACING
+	select GENERIC_TRACER
 	select CONTEXT_SWITCH_TRACER
 	help
 	  This tracer helps developers to optimize boot times: it records
@@ -207,8 +227,36 @@ config BOOT_TRACER
 	  to enable this on bootup.
 
 config TRACE_BRANCH_PROFILING
+	bool
+	select GENERIC_TRACER
+
+choice
+	prompt "Branch Profiling"
+	default BRANCH_PROFILE_NONE
+	help
+	 The branch profiling is a software profiler. It will add hooks
+	 into the C conditionals to test which path a branch takes.
+
+	 The likely/unlikely profiler only looks at the conditions that
+	 are annotated with a likely or unlikely macro.
+
+	 The "all branch" profiler will profile every if statement in the
+	 kernel. This profiler will also enable the likely/unlikely
+	 profiler as well.
+
+	 Either of the above profilers add a bit of overhead to the system.
+	 If unsure choose "No branch profiling".
+
+config BRANCH_PROFILE_NONE
+	bool "No branch profiling"
+	help
+	 No branch profiling. Branch profiling adds a bit of overhead.
+	 Only enable it if you want to analyse the branching behavior.
+	 Otherwise keep it disabled.
+
+config PROFILE_ANNOTATED_BRANCHES
 	bool "Trace likely/unlikely profiler"
-	select TRACING
+	select TRACE_BRANCH_PROFILING
 	help
 	  This tracer profiles all the the likely and unlikely macros
 	  in the kernel. It will display the results in:
@@ -218,11 +266,9 @@ config TRACE_BRANCH_PROFILING
 	  Note: this will add a significant overhead, only turn this
 	  on if you need to profile the system's use of these macros.
 
-	  Say N if unsure.
-
 config PROFILE_ALL_BRANCHES
 	bool "Profile all if conditionals"
-	depends on TRACE_BRANCH_PROFILING
+	select TRACE_BRANCH_PROFILING
 	help
 	  This tracer profiles all branch conditions. Every if ()
 	  taken in the kernel is recorded whether it hit or miss.
@@ -230,11 +276,12 @@ config PROFILE_ALL_BRANCHES
 
 	  /debugfs/tracing/profile_branch
 
+	  This option also enables the likely/unlikely profiler.
+
 	  This configuration, when enabled, will impose a great overhead
 	  on the system. This should only be enabled when the system
 	  is to be analyzed
-
-	  Say N if unsure.
+endchoice
 
 config TRACING_BRANCHES
 	bool
@@ -261,7 +308,7 @@ config BRANCH_TRACER
 config POWER_TRACER
 	bool "Trace power consumption behavior"
 	depends on X86
-	select TRACING
+	select GENERIC_TRACER
 	help
 	  This tracer helps developers to analyze and optimize the kernels
 	  power management decisions, specifically the C-state and P-state
@@ -295,14 +342,14 @@ config STACK_TRACER
 config HW_BRANCH_TRACER
 	depends on HAVE_HW_BRANCH_TRACER
 	bool "Trace hw branches"
-	select TRACING
+	select GENERIC_TRACER
 	help
 	  This tracer records all branches on the system in a circular
 	  buffer giving access to the last N branches for each cpu.
 
 config KMEMTRACE
 	bool "Trace SLAB allocations"
-	select TRACING
+	select GENERIC_TRACER
 	help
 	  kmemtrace provides tracing for slab allocator functions, such as
 	  kmalloc, kfree, kmem_cache_alloc, kmem_cache_free etc.. Collected
@@ -322,7 +369,7 @@ config KMEMTRACE
 
 config WORKQUEUE_TRACER
 	bool "Trace workqueues"
-	select TRACING
+	select GENERIC_TRACER
 	help
 	  The workqueue tracer provides some statistical informations
           about each cpu workqueue thread such as the number of the
@@ -338,7 +385,7 @@ config BLK_DEV_IO_TRACE
 	select RELAY
 	select DEBUG_FS
 	select TRACEPOINTS
-	select TRACING
+	select GENERIC_TRACER
 	select STACKTRACE
 	help
 	  Say Y here if you want to be able to trace the block layer actions
@@ -375,6 +422,20 @@ config DYNAMIC_FTRACE
 	 were made. If so, it runs stop_machine (stops all CPUS)
 	 and modifies the code to jump over the call to ftrace.
 
+config FUNCTION_PROFILER
+	bool "Kernel function profiler"
+	depends on FUNCTION_TRACER
+	default n
+	help
+	 This option enables the kernel function profiler. A file is created
+	 in debugfs called function_profile_enabled which defaults to zero.
+	 When a 1 is echoed into this file profiling begins, and when a
+	 zero is entered, profiling stops. A file in the trace_stats
+	 directory called functions, that show the list of functions that
+	 have been hit and their counters.
+
+	 If in doubt, say N
+
 config FTRACE_MCOUNT_RECORD
 	def_bool y
 	depends on DYNAMIC_FTRACE
@@ -385,7 +446,7 @@ config FTRACE_SELFTEST
 
 config FTRACE_STARTUP_TEST
 	bool "Perform a startup test on ftrace"
-	depends on TRACING
+	depends on GENERIC_TRACER
 	select FTRACE_SELFTEST
 	help
 	  This option performs a series of startup tests on ftrace. On bootup
@@ -396,7 +457,7 @@ config FTRACE_STARTUP_TEST
 config MMIOTRACE
 	bool "Memory mapped IO tracing"
 	depends on HAVE_MMIOTRACE_SUPPORT && PCI
-	select TRACING
+	select GENERIC_TRACER
 	help
 	  Mmiotrace traces Memory Mapped I/O access and is meant for
 	  debugging and reverse engineering. It is called from the ioremap
@@ -416,7 +477,23 @@ config MMIOTRACE_TEST
 
 	  Say N, unless you absolutely know what you are doing.
 
-endmenu
+config RING_BUFFER_BENCHMARK
+	tristate "Ring buffer benchmark stress tester"
+	depends on RING_BUFFER
+	help
+	  This option creates a test to stress the ring buffer and bench mark it.
+	  It creates its own ring buffer such that it will not interfer with
+	  any other users of the ring buffer (such as ftrace). It then creates
+	  a producer and consumer that will run for 10 seconds and sleep for
+	  10 seconds. Each interval it will print out the number of events
+	  it recorded and give a rough estimate of how long each iteration took.
+
+	  It does not disable interrupts or raise its priority, so it may be
+	  affected by processes that are running.
+
+	  If unsure, say N
+
+endif # FTRACE
 
 endif # TRACING_SUPPORT
 
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 2630f51..844164d 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -15,11 +15,17 @@ ifdef CONFIG_TRACING_BRANCHES
 KBUILD_CFLAGS += -DDISABLE_BRANCH_PROFILING
 endif
 
+#
+# Make the trace clocks available generally: it's infrastructure
+# relied on by ptrace for example:
+#
+obj-y += trace_clock.o
+
 obj-$(CONFIG_FUNCTION_TRACER) += libftrace.o
 obj-$(CONFIG_RING_BUFFER) += ring_buffer.o
+obj-$(CONFIG_RING_BUFFER_BENCHMARK) += ring_buffer_benchmark.o
 
 obj-$(CONFIG_TRACING) += trace.o
-obj-$(CONFIG_TRACING) += trace_clock.o
 obj-$(CONFIG_TRACING) += trace_output.o
 obj-$(CONFIG_TRACING) += trace_stat.o
 obj-$(CONFIG_TRACING) += trace_printk.o
@@ -39,12 +45,14 @@ obj-$(CONFIG_HW_BRANCH_TRACER) += trace_hw_branches.o
 obj-$(CONFIG_POWER_TRACER) += trace_power.o
 obj-$(CONFIG_KMEMTRACE) += kmemtrace.o
 obj-$(CONFIG_WORKQUEUE_TRACER) += trace_workqueue.o
-obj-$(CONFIG_BLK_DEV_IO_TRACE)	+= blktrace.o
-obj-$(CONFIG_EVENT_TRACER) += trace_events.o
-obj-$(CONFIG_EVENT_TRACER) += events.o
-obj-$(CONFIG_EVENT_TRACER) += trace_export.o
+obj-$(CONFIG_BLK_DEV_IO_TRACE) += blktrace.o
+ifeq ($(CONFIG_BLOCK),y)
+obj-$(CONFIG_EVENT_TRACING) += blktrace.o
+endif
+obj-$(CONFIG_EVENT_TRACING) += trace_events.o
+obj-$(CONFIG_EVENT_TRACING) += trace_export.o
 obj-$(CONFIG_FTRACE_SYSCALLS) += trace_syscalls.o
 obj-$(CONFIG_EVENT_PROFILE) += trace_event_profile.o
-obj-$(CONFIG_EVENT_TRACER) += trace_events_filter.o
+obj-$(CONFIG_EVENT_TRACING) += trace_events_filter.o
 
 libftrace-y := ftrace.o
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 921ef5d..7bd6a98 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -23,10 +23,14 @@
 #include <linux/mutex.h>
 #include <linux/debugfs.h>
 #include <linux/time.h>
-#include <trace/block.h>
 #include <linux/uaccess.h>
+
+#include <trace/events/block.h>
+
 #include "trace_output.h"
 
+#ifdef CONFIG_BLK_DEV_IO_TRACE
+
 static unsigned int blktrace_seq __read_mostly = 1;
 
 static struct trace_array *blk_tr;
@@ -147,7 +151,7 @@ static int act_log_check(struct blk_trace *bt, u32 what, sector_t sector,
 {
 	if (((bt->act_mask << BLK_TC_SHIFT) & what) == 0)
 		return 1;
-	if (sector < bt->start_lba || sector > bt->end_lba)
+	if (sector && (sector < bt->start_lba || sector > bt->end_lba))
 		return 1;
 	if (bt->pid && pid != bt->pid)
 		return 1;
@@ -192,7 +196,7 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
 	what |= MASK_TC_BIT(rw, DISCARD);
 
 	pid = tsk->pid;
-	if (unlikely(act_log_check(bt, what, sector, pid)))
+	if (act_log_check(bt, what, sector, pid))
 		return;
 	cpu = raw_smp_processor_id();
 
@@ -262,6 +266,7 @@ static void blk_trace_free(struct blk_trace *bt)
 {
 	debugfs_remove(bt->msg_file);
 	debugfs_remove(bt->dropped_file);
+	debugfs_remove(bt->dir);
 	relay_close(bt->rchan);
 	free_percpu(bt->sequence);
 	free_percpu(bt->msg_data);
@@ -403,11 +408,29 @@ static struct rchan_callbacks blk_relay_callbacks = {
 	.remove_buf_file	= blk_remove_buf_file_callback,
 };
 
+static void blk_trace_setup_lba(struct blk_trace *bt,
+				struct block_device *bdev)
+{
+	struct hd_struct *part = NULL;
+
+	if (bdev)
+		part = bdev->bd_part;
+
+	if (part) {
+		bt->start_lba = part->start_sect;
+		bt->end_lba = part->start_sect + part->nr_sects;
+	} else {
+		bt->start_lba = 0;
+		bt->end_lba = -1ULL;
+	}
+}
+
 /*
  * Setup everything required to start tracing
  */
 int do_blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
-			struct blk_user_trace_setup *buts)
+		       struct block_device *bdev,
+		       struct blk_user_trace_setup *buts)
 {
 	struct blk_trace *old_bt, *bt = NULL;
 	struct dentry *dir = NULL;
@@ -480,10 +503,13 @@ int do_blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 	if (!bt->act_mask)
 		bt->act_mask = (u16) -1;
 
-	bt->start_lba = buts->start_lba;
-	bt->end_lba = buts->end_lba;
-	if (!bt->end_lba)
-		bt->end_lba = -1ULL;
+	blk_trace_setup_lba(bt, bdev);
+
+	/* overwrite with user settings */
+	if (buts->start_lba)
+		bt->start_lba = buts->start_lba;
+	if (buts->end_lba)
+		bt->end_lba = buts->end_lba;
 
 	bt->pid = buts->pid;
 	bt->trace_state = Blktrace_setup;
@@ -505,6 +531,7 @@ err:
 }
 
 int blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
+		    struct block_device *bdev,
 		    char __user *arg)
 {
 	struct blk_user_trace_setup buts;
@@ -514,7 +541,7 @@ int blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 	if (ret)
 		return -EFAULT;
 
-	ret = do_blk_trace_setup(q, name, dev, &buts);
+	ret = do_blk_trace_setup(q, name, dev, bdev, &buts);
 	if (ret)
 		return ret;
 
@@ -582,7 +609,7 @@ int blk_trace_ioctl(struct block_device *bdev, unsigned cmd, char __user *arg)
 	switch (cmd) {
 	case BLKTRACESETUP:
 		bdevname(bdev, b);
-		ret = blk_trace_setup(q, b, bdev->bd_dev, arg);
+		ret = blk_trace_setup(q, b, bdev->bd_dev, bdev, arg);
 		break;
 	case BLKTRACESTART:
 		start = 1;
@@ -809,7 +836,6 @@ static void blk_add_trace_split(struct request_queue *q, struct bio *bio,
  * @bio:	the source bio
  * @dev:	target device
  * @from:	source sector
- * @to:		target sector
  *
  * Description:
  *     Device mapper or raid target sometimes need to split a bio because
@@ -817,7 +843,7 @@ static void blk_add_trace_split(struct request_queue *q, struct bio *bio,
  *
  **/
 static void blk_add_trace_remap(struct request_queue *q, struct bio *bio,
-				       dev_t dev, sector_t from, sector_t to)
+				       dev_t dev, sector_t from)
 {
 	struct blk_trace *bt = q->blk_trace;
 	struct blk_io_trace_remap r;
@@ -825,12 +851,13 @@ static void blk_add_trace_remap(struct request_queue *q, struct bio *bio,
 	if (likely(!bt))
 		return;
 
-	r.device = cpu_to_be32(dev);
-	r.device_from = cpu_to_be32(bio->bi_bdev->bd_dev);
-	r.sector = cpu_to_be64(to);
+	r.device_from = cpu_to_be32(dev);
+	r.device_to   = cpu_to_be32(bio->bi_bdev->bd_dev);
+	r.sector_from = cpu_to_be64(from);
 
-	__blk_add_trace(bt, from, bio->bi_size, bio->bi_rw, BLK_TA_REMAP,
-			!bio_flagged(bio, BIO_UPTODATE), sizeof(r), &r);
+	__blk_add_trace(bt, bio->bi_sector, bio->bi_size, bio->bi_rw,
+			BLK_TA_REMAP, !bio_flagged(bio, BIO_UPTODATE),
+			sizeof(r), &r);
 }
 
 /**
@@ -971,6 +998,16 @@ static inline const void *pdu_start(const struct trace_entry *ent)
 	return te_blk_io_trace(ent) + 1;
 }
 
+static inline u32 t_action(const struct trace_entry *ent)
+{
+	return te_blk_io_trace(ent)->action;
+}
+
+static inline u32 t_bytes(const struct trace_entry *ent)
+{
+	return te_blk_io_trace(ent)->bytes;
+}
+
 static inline u32 t_sec(const struct trace_entry *ent)
 {
 	return te_blk_io_trace(ent)->bytes >> 9;
@@ -996,11 +1033,11 @@ static void get_pdu_remap(const struct trace_entry *ent,
 			  struct blk_io_trace_remap *r)
 {
 	const struct blk_io_trace_remap *__r = pdu_start(ent);
-	__u64 sector = __r->sector;
+	__u64 sector_from = __r->sector_from;
 
-	r->device = be32_to_cpu(__r->device);
 	r->device_from = be32_to_cpu(__r->device_from);
-	r->sector = be64_to_cpu(sector);
+	r->device_to   = be32_to_cpu(__r->device_to);
+	r->sector_from = be64_to_cpu(sector_from);
 }
 
 typedef int (blk_log_action_t) (struct trace_iterator *iter, const char *act);
@@ -1031,36 +1068,98 @@ static int blk_log_action(struct trace_iterator *iter, const char *act)
 				MAJOR(t->device), MINOR(t->device), act, rwbs);
 }
 
+static int blk_log_dump_pdu(struct trace_seq *s, const struct trace_entry *ent)
+{
+	const unsigned char *pdu_buf;
+	int pdu_len;
+	int i, end, ret;
+
+	pdu_buf = pdu_start(ent);
+	pdu_len = te_blk_io_trace(ent)->pdu_len;
+
+	if (!pdu_len)
+		return 1;
+
+	/* find the last zero that needs to be printed */
+	for (end = pdu_len - 1; end >= 0; end--)
+		if (pdu_buf[end])
+			break;
+	end++;
+
+	if (!trace_seq_putc(s, '('))
+		return 0;
+
+	for (i = 0; i < pdu_len; i++) {
+
+		ret = trace_seq_printf(s, "%s%02x",
+				       i == 0 ? "" : " ", pdu_buf[i]);
+		if (!ret)
+			return ret;
+
+		/*
+		 * stop when the rest is just zeroes and indicate so
+		 * with a ".." appended
+		 */
+		if (i == end && end != pdu_len - 1)
+			return trace_seq_puts(s, " ..) ");
+	}
+
+	return trace_seq_puts(s, ") ");
+}
+
 static int blk_log_generic(struct trace_seq *s, const struct trace_entry *ent)
 {
 	char cmd[TASK_COMM_LEN];
 
 	trace_find_cmdline(ent->pid, cmd);
 
-	if (t_sec(ent))
-		return trace_seq_printf(s, "%llu + %u [%s]\n",
-					t_sector(ent), t_sec(ent), cmd);
-	return trace_seq_printf(s, "[%s]\n", cmd);
+	if (t_action(ent) & BLK_TC_ACT(BLK_TC_PC)) {
+		int ret;
+
+		ret = trace_seq_printf(s, "%u ", t_bytes(ent));
+		if (!ret)
+			return 0;
+		ret = blk_log_dump_pdu(s, ent);
+		if (!ret)
+			return 0;
+		return trace_seq_printf(s, "[%s]\n", cmd);
+	} else {
+		if (t_sec(ent))
+			return trace_seq_printf(s, "%llu + %u [%s]\n",
+						t_sector(ent), t_sec(ent), cmd);
+		return trace_seq_printf(s, "[%s]\n", cmd);
+	}
 }
 
 static int blk_log_with_error(struct trace_seq *s,
 			      const struct trace_entry *ent)
 {
-	if (t_sec(ent))
-		return trace_seq_printf(s, "%llu + %u [%d]\n", t_sector(ent),
-					t_sec(ent), t_error(ent));
-	return trace_seq_printf(s, "%llu [%d]\n", t_sector(ent), t_error(ent));
+	if (t_action(ent) & BLK_TC_ACT(BLK_TC_PC)) {
+		int ret;
+
+		ret = blk_log_dump_pdu(s, ent);
+		if (ret)
+			return trace_seq_printf(s, "[%d]\n", t_error(ent));
+		return 0;
+	} else {
+		if (t_sec(ent))
+			return trace_seq_printf(s, "%llu + %u [%d]\n",
+						t_sector(ent),
+						t_sec(ent), t_error(ent));
+		return trace_seq_printf(s, "%llu [%d]\n",
+					t_sector(ent), t_error(ent));
+	}
 }
 
 static int blk_log_remap(struct trace_seq *s, const struct trace_entry *ent)
 {
-	struct blk_io_trace_remap r = { .device = 0, };
+	struct blk_io_trace_remap r = { .device_from = 0, };
 
 	get_pdu_remap(ent, &r);
 	return trace_seq_printf(s, "%llu + %u <- (%d,%d) %llu\n",
-			       t_sector(ent),
-			       t_sec(ent), MAJOR(r.device), MINOR(r.device),
-			       (unsigned long long)r.sector);
+				t_sector(ent), t_sec(ent),
+				MAJOR(r.device_from), MINOR(r.device_from),
+				(unsigned long long)r.sector_from);
 }
 
 static int blk_log_plug(struct trace_seq *s, const struct trace_entry *ent)
@@ -1117,7 +1216,6 @@ static void blk_tracer_print_header(struct seq_file *m)
 static void blk_tracer_start(struct trace_array *tr)
 {
 	blk_tracer_enabled = true;
-	trace_flags &= ~TRACE_ITER_CONTEXT_INFO;
 }
 
 static int blk_tracer_init(struct trace_array *tr)
@@ -1130,7 +1228,6 @@ static int blk_tracer_init(struct trace_array *tr)
 static void blk_tracer_stop(struct trace_array *tr)
 {
 	blk_tracer_enabled = false;
-	trace_flags |= TRACE_ITER_CONTEXT_INFO;
 }
 
 static void blk_tracer_reset(struct trace_array *tr)
@@ -1182,7 +1279,7 @@ static enum print_line_t print_one_line(struct trace_iterator *iter,
 	}
 
 	if (unlikely(what == 0 || what >= ARRAY_SIZE(what2act)))
-		ret = trace_seq_printf(s, "Bad pc action %x\n", what);
+		ret = trace_seq_printf(s, "Unknown action %x\n", what);
 	else {
 		ret = log_action(iter, what2act[what].act[long_act]);
 		if (ret)
@@ -1195,9 +1292,6 @@ out:
 static enum print_line_t blk_trace_event_print(struct trace_iterator *iter,
 					       int flags)
 {
-	if (!trace_print_context(iter))
-		return TRACE_TYPE_PARTIAL_LINE;
-
 	return print_one_line(iter, false);
 }
 
@@ -1232,6 +1326,18 @@ static enum print_line_t blk_tracer_print_line(struct trace_iterator *iter)
 	return print_one_line(iter, true);
 }
 
+static int blk_tracer_set_flag(u32 old_flags, u32 bit, int set)
+{
+	/* don't output context-info for blk_classic output */
+	if (bit == TRACE_BLK_OPT_CLASSIC) {
+		if (set)
+			trace_flags &= ~TRACE_ITER_CONTEXT_INFO;
+		else
+			trace_flags |= TRACE_ITER_CONTEXT_INFO;
+	}
+	return 0;
+}
+
 static struct tracer blk_tracer __read_mostly = {
 	.name		= "blk",
 	.init		= blk_tracer_init,
@@ -1241,6 +1347,7 @@ static struct tracer blk_tracer __read_mostly = {
 	.print_header	= blk_tracer_print_header,
 	.print_line	= blk_tracer_print_line,
 	.flags		= &blk_tracer_flags,
+	.set_flag	= blk_tracer_set_flag,
 };
 
 static struct trace_event trace_blk_event = {
@@ -1285,7 +1392,8 @@ static int blk_trace_remove_queue(struct request_queue *q)
 /*
  * Setup everything required to start tracing
  */
-static int blk_trace_setup_queue(struct request_queue *q, dev_t dev)
+static int blk_trace_setup_queue(struct request_queue *q,
+				 struct block_device *bdev)
 {
 	struct blk_trace *old_bt, *bt = NULL;
 	int ret = -ENOMEM;
@@ -1298,9 +1406,10 @@ static int blk_trace_setup_queue(struct request_queue *q, dev_t dev)
 	if (!bt->msg_data)
 		goto free_bt;
 
-	bt->dev = dev;
+	bt->dev = bdev->bd_dev;
 	bt->act_mask = (u16)-1;
-	bt->end_lba = -1ULL;
+
+	blk_trace_setup_lba(bt, bdev);
 
 	old_bt = xchg(&q->blk_trace, bt);
 	if (old_bt != NULL) {
@@ -1517,7 +1626,7 @@ static ssize_t sysfs_blk_trace_attr_store(struct device *dev,
 
 	if (attr == &dev_attr_enable) {
 		if (value)
-			ret = blk_trace_setup_queue(q, bdev->bd_dev);
+			ret = blk_trace_setup_queue(q, bdev);
 		else
 			ret = blk_trace_remove_queue(q);
 		goto out_unlock_bdev;
@@ -1525,7 +1634,7 @@ static ssize_t sysfs_blk_trace_attr_store(struct device *dev,
 
 	ret = 0;
 	if (q->blk_trace == NULL)
-		ret = blk_trace_setup_queue(q, bdev->bd_dev);
+		ret = blk_trace_setup_queue(q, bdev);
 
 	if (ret == 0) {
 		if (attr == &dev_attr_act_mask)
@@ -1548,3 +1657,80 @@ out:
 	return ret ? ret : count;
 }
 
+int blk_trace_init_sysfs(struct device *dev)
+{
+	return sysfs_create_group(&dev->kobj, &blk_trace_attr_group);
+}
+
+#endif /* CONFIG_BLK_DEV_IO_TRACE */
+
+#ifdef CONFIG_EVENT_TRACING
+
+void blk_dump_cmd(char *buf, struct request *rq)
+{
+	int i, end;
+	int len = rq->cmd_len;
+	unsigned char *cmd = rq->cmd;
+
+	if (!blk_pc_request(rq)) {
+		buf[0] = '\0';
+		return;
+	}
+
+	for (end = len - 1; end >= 0; end--)
+		if (cmd[end])
+			break;
+	end++;
+
+	for (i = 0; i < len; i++) {
+		buf += sprintf(buf, "%s%02x", i == 0 ? "" : " ", cmd[i]);
+		if (i == end && end != len - 1) {
+			sprintf(buf, " ..");
+			break;
+		}
+	}
+}
+
+void blk_fill_rwbs(char *rwbs, u32 rw, int bytes)
+{
+	int i = 0;
+
+	if (rw & WRITE)
+		rwbs[i++] = 'W';
+	else if (rw & 1 << BIO_RW_DISCARD)
+		rwbs[i++] = 'D';
+	else if (bytes)
+		rwbs[i++] = 'R';
+	else
+		rwbs[i++] = 'N';
+
+	if (rw & 1 << BIO_RW_AHEAD)
+		rwbs[i++] = 'A';
+	if (rw & 1 << BIO_RW_BARRIER)
+		rwbs[i++] = 'B';
+	if (rw & 1 << BIO_RW_SYNCIO)
+		rwbs[i++] = 'S';
+	if (rw & 1 << BIO_RW_META)
+		rwbs[i++] = 'M';
+
+	rwbs[i] = '\0';
+}
+
+void blk_fill_rwbs_rq(char *rwbs, struct request *rq)
+{
+	int rw = rq->cmd_flags & 0x03;
+	int bytes;
+
+	if (blk_discard_rq(rq))
+		rw |= (1 << BIO_RW_DISCARD);
+
+	if (blk_pc_request(rq))
+		bytes = rq->data_len;
+	else
+		bytes = rq->hard_nr_sectors << 9;
+
+	blk_fill_rwbs(rwbs, rw, bytes);
+}
+
+#endif /* CONFIG_EVENT_TRACING */
+
diff --git a/kernel/trace/events.c b/kernel/trace/events.c
deleted file mode 100644
index 246f2aa..0000000
--- a/kernel/trace/events.c
+++ /dev/null
@@ -1,14 +0,0 @@
-/*
- * This is the place to register all trace points as events.
- */
-
-#include <linux/stringify.h>
-
-#include <trace/trace_events.h>
-
-#include "trace_output.h"
-
-#include "trace_events_stage_1.h"
-#include "trace_events_stage_2.h"
-#include "trace_events_stage_3.h"
-
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index f1ed080..d6973df 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -29,11 +29,13 @@
 #include <linux/list.h>
 #include <linux/hash.h>
 
-#include <trace/sched.h>
+#include <trace/events/sched.h>
 
 #include <asm/ftrace.h>
+#include <asm/setup.h>
 
-#include "trace.h"
+#include "trace_output.h"
+#include "trace_stat.h"
 
 #define FTRACE_WARN_ON(cond)			\
 	do {					\
@@ -68,7 +70,7 @@ static DEFINE_MUTEX(ftrace_lock);
 
 static struct ftrace_ops ftrace_list_end __read_mostly =
 {
-	.func = ftrace_stub,
+	.func		= ftrace_stub,
 };
 
 static struct ftrace_ops *ftrace_list __read_mostly = &ftrace_list_end;
@@ -240,6 +242,580 @@ static void ftrace_update_pid_func(void)
 #endif
 }
 
+#ifdef CONFIG_FUNCTION_PROFILER
+struct ftrace_profile {
+	struct hlist_node		node;
+	unsigned long			ip;
+	unsigned long			counter;
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	unsigned long long		time;
+#endif
+};
+
+struct ftrace_profile_page {
+	struct ftrace_profile_page	*next;
+	unsigned long			index;
+	struct ftrace_profile		records[];
+};
+
+struct ftrace_profile_stat {
+	atomic_t			disabled;
+	struct hlist_head		*hash;
+	struct ftrace_profile_page	*pages;
+	struct ftrace_profile_page	*start;
+	struct tracer_stat		stat;
+};
+
+#define PROFILE_RECORDS_SIZE						\
+	(PAGE_SIZE - offsetof(struct ftrace_profile_page, records))
+
+#define PROFILES_PER_PAGE					\
+	(PROFILE_RECORDS_SIZE / sizeof(struct ftrace_profile))
+
+static int ftrace_profile_bits __read_mostly;
+static int ftrace_profile_enabled __read_mostly;
+
+/* ftrace_profile_lock - synchronize the enable and disable of the profiler */
+static DEFINE_MUTEX(ftrace_profile_lock);
+
+static DEFINE_PER_CPU(struct ftrace_profile_stat, ftrace_profile_stats);
+
+#define FTRACE_PROFILE_HASH_SIZE 1024 /* must be power of 2 */
+
+static void *
+function_stat_next(void *v, int idx)
+{
+	struct ftrace_profile *rec = v;
+	struct ftrace_profile_page *pg;
+
+	pg = (struct ftrace_profile_page *)((unsigned long)rec & PAGE_MASK);
+
+ again:
+	rec++;
+	if ((void *)rec >= (void *)&pg->records[pg->index]) {
+		pg = pg->next;
+		if (!pg)
+			return NULL;
+		rec = &pg->records[0];
+		if (!rec->counter)
+			goto again;
+	}
+
+	return rec;
+}
+
+static void *function_stat_start(struct tracer_stat *trace)
+{
+	struct ftrace_profile_stat *stat =
+		container_of(trace, struct ftrace_profile_stat, stat);
+
+	if (!stat || !stat->start)
+		return NULL;
+
+	return function_stat_next(&stat->start->records[0], 0);
+}
+
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+/* function graph compares on total time */
+static int function_stat_cmp(void *p1, void *p2)
+{
+	struct ftrace_profile *a = p1;
+	struct ftrace_profile *b = p2;
+
+	if (a->time < b->time)
+		return -1;
+	if (a->time > b->time)
+		return 1;
+	else
+		return 0;
+}
+#else
+/* not function graph compares against hits */
+static int function_stat_cmp(void *p1, void *p2)
+{
+	struct ftrace_profile *a = p1;
+	struct ftrace_profile *b = p2;
+
+	if (a->counter < b->counter)
+		return -1;
+	if (a->counter > b->counter)
+		return 1;
+	else
+		return 0;
+}
+#endif
+
+static int function_stat_headers(struct seq_file *m)
+{
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	seq_printf(m, "  Function                               "
+		   "Hit    Time            Avg\n"
+		      "  --------                               "
+		   "---    ----            ---\n");
+#else
+	seq_printf(m, "  Function                               Hit\n"
+		      "  --------                               ---\n");
+#endif
+	return 0;
+}
+
+static int function_stat_show(struct seq_file *m, void *v)
+{
+	struct ftrace_profile *rec = v;
+	char str[KSYM_SYMBOL_LEN];
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	static DEFINE_MUTEX(mutex);
+	static struct trace_seq s;
+	unsigned long long avg;
+#endif
+
+	kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
+	seq_printf(m, "  %-30.30s  %10lu", str, rec->counter);
+
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	seq_printf(m, "    ");
+	avg = rec->time;
+	do_div(avg, rec->counter);
+
+	mutex_lock(&mutex);
+	trace_seq_init(&s);
+	trace_print_graph_duration(rec->time, &s);
+	trace_seq_puts(&s, "    ");
+	trace_print_graph_duration(avg, &s);
+	trace_print_seq(m, &s);
+	mutex_unlock(&mutex);
+#endif
+	seq_putc(m, '\n');
+
+	return 0;
+}
+
+static void ftrace_profile_reset(struct ftrace_profile_stat *stat)
+{
+	struct ftrace_profile_page *pg;
+
+	pg = stat->pages = stat->start;
+
+	while (pg) {
+		memset(pg->records, 0, PROFILE_RECORDS_SIZE);
+		pg->index = 0;
+		pg = pg->next;
+	}
+
+	memset(stat->hash, 0,
+	       FTRACE_PROFILE_HASH_SIZE * sizeof(struct hlist_head));
+}
+
+int ftrace_profile_pages_init(struct ftrace_profile_stat *stat)
+{
+	struct ftrace_profile_page *pg;
+	int functions;
+	int pages;
+	int i;
+
+	/* If we already allocated, do nothing */
+	if (stat->pages)
+		return 0;
+
+	stat->pages = (void *)get_zeroed_page(GFP_KERNEL);
+	if (!stat->pages)
+		return -ENOMEM;
+
+#ifdef CONFIG_DYNAMIC_FTRACE
+	functions = ftrace_update_tot_cnt;
+#else
+	/*
+	 * We do not know the number of functions that exist because
+	 * dynamic tracing is what counts them. With past experience
+	 * we have around 20K functions. That should be more than enough.
+	 * It is highly unlikely we will execute every function in
+	 * the kernel.
+	 */
+	functions = 20000;
+#endif
+
+	pg = stat->start = stat->pages;
+
+	pages = DIV_ROUND_UP(functions, PROFILES_PER_PAGE);
+
+	for (i = 0; i < pages; i++) {
+		pg->next = (void *)get_zeroed_page(GFP_KERNEL);
+		if (!pg->next)
+			goto out_free;
+		pg = pg->next;
+	}
+
+	return 0;
+
+ out_free:
+	pg = stat->start;
+	while (pg) {
+		unsigned long tmp = (unsigned long)pg;
+
+		pg = pg->next;
+		free_page(tmp);
+	}
+
+	free_page((unsigned long)stat->pages);
+	stat->pages = NULL;
+	stat->start = NULL;
+
+	return -ENOMEM;
+}
+
+static int ftrace_profile_init_cpu(int cpu)
+{
+	struct ftrace_profile_stat *stat;
+	int size;
+
+	stat = &per_cpu(ftrace_profile_stats, cpu);
+
+	if (stat->hash) {
+		/* If the profile is already created, simply reset it */
+		ftrace_profile_reset(stat);
+		return 0;
+	}
+
+	/*
+	 * We are profiling all functions, but usually only a few thousand
+	 * functions are hit. We'll make a hash of 1024 items.
+	 */
+	size = FTRACE_PROFILE_HASH_SIZE;
+
+	stat->hash = kzalloc(sizeof(struct hlist_head) * size, GFP_KERNEL);
+
+	if (!stat->hash)
+		return -ENOMEM;
+
+	if (!ftrace_profile_bits) {
+		size--;
+
+		for (; size; size >>= 1)
+			ftrace_profile_bits++;
+	}
+
+	/* Preallocate the function profiling pages */
+	if (ftrace_profile_pages_init(stat) < 0) {
+		kfree(stat->hash);
+		stat->hash = NULL;
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static int ftrace_profile_init(void)
+{
+	int cpu;
+	int ret = 0;
+
+	for_each_online_cpu(cpu) {
+		ret = ftrace_profile_init_cpu(cpu);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+
+/* interrupts must be disabled */
+static struct ftrace_profile *
+ftrace_find_profiled_func(struct ftrace_profile_stat *stat, unsigned long ip)
+{
+	struct ftrace_profile *rec;
+	struct hlist_head *hhd;
+	struct hlist_node *n;
+	unsigned long key;
+
+	key = hash_long(ip, ftrace_profile_bits);
+	hhd = &stat->hash[key];
+
+	if (hlist_empty(hhd))
+		return NULL;
+
+	hlist_for_each_entry_rcu(rec, n, hhd, node) {
+		if (rec->ip == ip)
+			return rec;
+	}
+
+	return NULL;
+}
+
+static void ftrace_add_profile(struct ftrace_profile_stat *stat,
+			       struct ftrace_profile *rec)
+{
+	unsigned long key;
+
+	key = hash_long(rec->ip, ftrace_profile_bits);
+	hlist_add_head_rcu(&rec->node, &stat->hash[key]);
+}
+
+/*
+ * The memory is already allocated, this simply finds a new record to use.
+ */
+static struct ftrace_profile *
+ftrace_profile_alloc(struct ftrace_profile_stat *stat, unsigned long ip)
+{
+	struct ftrace_profile *rec = NULL;
+
+	/* prevent recursion (from NMIs) */
+	if (atomic_inc_return(&stat->disabled) != 1)
+		goto out;
+
+	/*
+	 * Try to find the function again since an NMI
+	 * could have added it
+	 */
+	rec = ftrace_find_profiled_func(stat, ip);
+	if (rec)
+		goto out;
+
+	if (stat->pages->index == PROFILES_PER_PAGE) {
+		if (!stat->pages->next)
+			goto out;
+		stat->pages = stat->pages->next;
+	}
+
+	rec = &stat->pages->records[stat->pages->index++];
+	rec->ip = ip;
+	ftrace_add_profile(stat, rec);
+
+ out:
+	atomic_dec(&stat->disabled);
+
+	return rec;
+}
+
+static void
+function_profile_call(unsigned long ip, unsigned long parent_ip)
+{
+	struct ftrace_profile_stat *stat;
+	struct ftrace_profile *rec;
+	unsigned long flags;
+
+	if (!ftrace_profile_enabled)
+		return;
+
+	local_irq_save(flags);
+
+	stat = &__get_cpu_var(ftrace_profile_stats);
+	if (!stat->hash || !ftrace_profile_enabled)
+		goto out;
+
+	rec = ftrace_find_profiled_func(stat, ip);
+	if (!rec) {
+		rec = ftrace_profile_alloc(stat, ip);
+		if (!rec)
+			goto out;
+	}
+
+	rec->counter++;
+ out:
+	local_irq_restore(flags);
+}
+
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+static int profile_graph_entry(struct ftrace_graph_ent *trace)
+{
+	function_profile_call(trace->func, 0);
+	return 1;
+}
+
+static void profile_graph_return(struct ftrace_graph_ret *trace)
+{
+	struct ftrace_profile_stat *stat;
+	unsigned long long calltime;
+	struct ftrace_profile *rec;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	stat = &__get_cpu_var(ftrace_profile_stats);
+	if (!stat->hash || !ftrace_profile_enabled)
+		goto out;
+
+	calltime = trace->rettime - trace->calltime;
+
+	if (!(trace_flags & TRACE_ITER_GRAPH_TIME)) {
+		int index;
+
+		index = trace->depth;
+
+		/* Append this call time to the parent time to subtract */
+		if (index)
+			current->ret_stack[index - 1].subtime += calltime;
+
+		if (current->ret_stack[index].subtime < calltime)
+			calltime -= current->ret_stack[index].subtime;
+		else
+			calltime = 0;
+	}
+
+	rec = ftrace_find_profiled_func(stat, trace->func);
+	if (rec)
+		rec->time += calltime;
+
+ out:
+	local_irq_restore(flags);
+}
+
+static int register_ftrace_profiler(void)
+{
+	return register_ftrace_graph(&profile_graph_return,
+				     &profile_graph_entry);
+}
+
+static void unregister_ftrace_profiler(void)
+{
+	unregister_ftrace_graph();
+}
+#else
+static struct ftrace_ops ftrace_profile_ops __read_mostly =
+{
+	.func		= function_profile_call,
+};
+
+static int register_ftrace_profiler(void)
+{
+	return register_ftrace_function(&ftrace_profile_ops);
+}
+
+static void unregister_ftrace_profiler(void)
+{
+	unregister_ftrace_function(&ftrace_profile_ops);
+}
+#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
+
+static ssize_t
+ftrace_profile_write(struct file *filp, const char __user *ubuf,
+		     size_t cnt, loff_t *ppos)
+{
+	unsigned long val;
+	char buf[64];		/* big enough to hold a number */
+	int ret;
+
+	if (cnt >= sizeof(buf))
+		return -EINVAL;
+
+	if (copy_from_user(&buf, ubuf, cnt))
+		return -EFAULT;
+
+	buf[cnt] = 0;
+
+	ret = strict_strtoul(buf, 10, &val);
+	if (ret < 0)
+		return ret;
+
+	val = !!val;
+
+	mutex_lock(&ftrace_profile_lock);
+	if (ftrace_profile_enabled ^ val) {
+		if (val) {
+			ret = ftrace_profile_init();
+			if (ret < 0) {
+				cnt = ret;
+				goto out;
+			}
+
+			ret = register_ftrace_profiler();
+			if (ret < 0) {
+				cnt = ret;
+				goto out;
+			}
+			ftrace_profile_enabled = 1;
+		} else {
+			ftrace_profile_enabled = 0;
+			/*
+			 * unregister_ftrace_profiler calls stop_machine
+			 * so this acts like an synchronize_sched.
+			 */
+			unregister_ftrace_profiler();
+		}
+	}
+ out:
+	mutex_unlock(&ftrace_profile_lock);
+
+	filp->f_pos += cnt;
+
+	return cnt;
+}
+
+static ssize_t
+ftrace_profile_read(struct file *filp, char __user *ubuf,
+		     size_t cnt, loff_t *ppos)
+{
+	char buf[64];		/* big enough to hold a number */
+	int r;
+
+	r = sprintf(buf, "%u\n", ftrace_profile_enabled);
+	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
+}
+
+static const struct file_operations ftrace_profile_fops = {
+	.open		= tracing_open_generic,
+	.read		= ftrace_profile_read,
+	.write		= ftrace_profile_write,
+};
+
+/* used to initialize the real stat files */
+static struct tracer_stat function_stats __initdata = {
+	.name		= "functions",
+	.stat_start	= function_stat_start,
+	.stat_next	= function_stat_next,
+	.stat_cmp	= function_stat_cmp,
+	.stat_headers	= function_stat_headers,
+	.stat_show	= function_stat_show
+};
+
+static void ftrace_profile_debugfs(struct dentry *d_tracer)
+{
+	struct ftrace_profile_stat *stat;
+	struct dentry *entry;
+	char *name;
+	int ret;
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		stat = &per_cpu(ftrace_profile_stats, cpu);
+
+		/* allocate enough for function name + cpu number */
+		name = kmalloc(32, GFP_KERNEL);
+		if (!name) {
+			/*
+			 * The files created are permanent, if something happens
+			 * we still do not free memory.
+			 */
+			kfree(stat);
+			WARN(1,
+			     "Could not allocate stat file for cpu %d\n",
+			     cpu);
+			return;
+		}
+		stat->stat = function_stats;
+		snprintf(name, 32, "function%d", cpu);
+		stat->stat.name = name;
+		ret = register_stat_tracer(&stat->stat);
+		if (ret) {
+			WARN(1,
+			     "Could not register function stat for cpu %d\n",
+			     cpu);
+			kfree(name);
+			return;
+		}
+	}
+
+	entry = debugfs_create_file("function_profile_enabled", 0644,
+				    d_tracer, NULL, &ftrace_profile_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs "
+			   "'function_profile_enabled' entry\n");
+}
+
+#else /* CONFIG_FUNCTION_PROFILER */
+static void ftrace_profile_debugfs(struct dentry *d_tracer)
+{
+}
+#endif /* CONFIG_FUNCTION_PROFILER */
+
 /* set when tracing only a pid */
 struct pid *ftrace_pid_trace;
 static struct pid * const ftrace_swapper_pid = &init_struct_pid;
@@ -261,7 +837,6 @@ struct ftrace_func_probe {
 	struct rcu_head		rcu;
 };
 
-
 enum {
 	FTRACE_ENABLE_CALLS		= (1 << 0),
 	FTRACE_DISABLE_CALLS		= (1 << 1),
@@ -346,30 +921,6 @@ static void ftrace_free_rec(struct dyn_ftrace *rec)
 	rec->flags |= FTRACE_FL_FREE;
 }
 
-void ftrace_release(void *start, unsigned long size)
-{
-	struct dyn_ftrace *rec;
-	struct ftrace_page *pg;
-	unsigned long s = (unsigned long)start;
-	unsigned long e = s + size;
-
-	if (ftrace_disabled || !start)
-		return;
-
-	mutex_lock(&ftrace_lock);
-	do_for_each_ftrace_rec(pg, rec) {
-		if ((rec->ip >= s) && (rec->ip < e)) {
-			/*
-			 * rec->ip is changed in ftrace_free_rec()
-			 * It should not between s and e if record was freed.
-			 */
-			FTRACE_WARN_ON(rec->flags & FTRACE_FL_FREE);
-			ftrace_free_rec(rec);
-		}
-	} while_for_each_ftrace_rec();
-	mutex_unlock(&ftrace_lock);
-}
-
 static struct dyn_ftrace *ftrace_alloc_dyn_node(unsigned long ip)
 {
 	struct dyn_ftrace *rec;
@@ -1408,7 +1959,7 @@ function_trace_probe_call(unsigned long ip, unsigned long parent_ip)
 
 static struct ftrace_ops trace_probe_ops __read_mostly =
 {
-	.func = function_trace_probe_call,
+	.func		= function_trace_probe_call,
 };
 
 static int ftrace_probe_registered;
@@ -1823,6 +2374,45 @@ void ftrace_set_notrace(unsigned char *buf, int len, int reset)
 	ftrace_set_regex(buf, len, reset, 0);
 }
 
+/*
+ * command line interface to allow users to set filters on boot up.
+ */
+#define FTRACE_FILTER_SIZE		COMMAND_LINE_SIZE
+static char ftrace_notrace_buf[FTRACE_FILTER_SIZE] __initdata;
+static char ftrace_filter_buf[FTRACE_FILTER_SIZE] __initdata;
+
+static int __init set_ftrace_notrace(char *str)
+{
+	strncpy(ftrace_notrace_buf, str, FTRACE_FILTER_SIZE);
+	return 1;
+}
+__setup("ftrace_notrace=", set_ftrace_notrace);
+
+static int __init set_ftrace_filter(char *str)
+{
+	strncpy(ftrace_filter_buf, str, FTRACE_FILTER_SIZE);
+	return 1;
+}
+__setup("ftrace_filter=", set_ftrace_filter);
+
+static void __init set_ftrace_early_filter(char *buf, int enable)
+{
+	char *func;
+
+	while (buf) {
+		func = strsep(&buf, ",");
+		ftrace_set_regex(func, strlen(func), 0, enable);
+	}
+}
+
+static void __init set_ftrace_early_filters(void)
+{
+	if (ftrace_filter_buf[0])
+		set_ftrace_early_filter(ftrace_filter_buf, 1);
+	if (ftrace_notrace_buf[0])
+		set_ftrace_early_filter(ftrace_notrace_buf, 0);
+}
+
 static int
 ftrace_regex_release(struct inode *inode, struct file *file, int enable)
 {
@@ -2128,38 +2718,23 @@ static const struct file_operations ftrace_graph_fops = {
 
 static __init int ftrace_init_dyn_debugfs(struct dentry *d_tracer)
 {
-	struct dentry *entry;
 
-	entry = debugfs_create_file("available_filter_functions", 0444,
-				    d_tracer, NULL, &ftrace_avail_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs "
-			   "'available_filter_functions' entry\n");
+	trace_create_file("available_filter_functions", 0444,
+			d_tracer, NULL, &ftrace_avail_fops);
 
-	entry = debugfs_create_file("failures", 0444,
-				    d_tracer, NULL, &ftrace_failures_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs 'failures' entry\n");
+	trace_create_file("failures", 0444,
+			d_tracer, NULL, &ftrace_failures_fops);
 
-	entry = debugfs_create_file("set_ftrace_filter", 0644, d_tracer,
-				    NULL, &ftrace_filter_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs "
-			   "'set_ftrace_filter' entry\n");
+	trace_create_file("set_ftrace_filter", 0644, d_tracer,
+			NULL, &ftrace_filter_fops);
 
-	entry = debugfs_create_file("set_ftrace_notrace", 0644, d_tracer,
+	trace_create_file("set_ftrace_notrace", 0644, d_tracer,
 				    NULL, &ftrace_notrace_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs "
-			   "'set_ftrace_notrace' entry\n");
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-	entry = debugfs_create_file("set_graph_function", 0444, d_tracer,
+	trace_create_file("set_graph_function", 0444, d_tracer,
 				    NULL,
 				    &ftrace_graph_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs "
-			   "'set_graph_function' entry\n");
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 
 	return 0;
@@ -2197,14 +2772,72 @@ static int ftrace_convert_nops(struct module *mod,
 	return 0;
 }
 
-void ftrace_init_module(struct module *mod,
-			unsigned long *start, unsigned long *end)
+#ifdef CONFIG_MODULES
+void ftrace_release(void *start, void *end)
+{
+	struct dyn_ftrace *rec;
+	struct ftrace_page *pg;
+	unsigned long s = (unsigned long)start;
+	unsigned long e = (unsigned long)end;
+
+	if (ftrace_disabled || !start || start == end)
+		return;
+
+	mutex_lock(&ftrace_lock);
+	do_for_each_ftrace_rec(pg, rec) {
+		if ((rec->ip >= s) && (rec->ip < e)) {
+			/*
+			 * rec->ip is changed in ftrace_free_rec()
+			 * It should not between s and e if record was freed.
+			 */
+			FTRACE_WARN_ON(rec->flags & FTRACE_FL_FREE);
+			ftrace_free_rec(rec);
+		}
+	} while_for_each_ftrace_rec();
+	mutex_unlock(&ftrace_lock);
+}
+
+static void ftrace_init_module(struct module *mod,
+			       unsigned long *start, unsigned long *end)
 {
 	if (ftrace_disabled || start == end)
 		return;
 	ftrace_convert_nops(mod, start, end);
 }
 
+static int ftrace_module_notify(struct notifier_block *self,
+				unsigned long val, void *data)
+{
+	struct module *mod = data;
+
+	switch (val) {
+	case MODULE_STATE_COMING:
+		ftrace_init_module(mod, mod->ftrace_callsites,
+				   mod->ftrace_callsites +
+				   mod->num_ftrace_callsites);
+		break;
+	case MODULE_STATE_GOING:
+		ftrace_release(mod->ftrace_callsites,
+			       mod->ftrace_callsites +
+			       mod->num_ftrace_callsites);
+		break;
+	}
+
+	return 0;
+}
+#else
+static int ftrace_module_notify(struct notifier_block *self,
+				unsigned long val, void *data)
+{
+	return 0;
+}
+#endif /* CONFIG_MODULES */
+
+struct notifier_block ftrace_module_nb = {
+	.notifier_call = ftrace_module_notify,
+	.priority = 0,
+};
+
 extern unsigned long __start_mcount_loc[];
 extern unsigned long __stop_mcount_loc[];
 
@@ -2236,6 +2869,12 @@ void __init ftrace_init(void)
 				  __start_mcount_loc,
 				  __stop_mcount_loc);
 
+	ret = register_module_notifier(&ftrace_module_nb);
+	if (ret)
+		pr_warning("Failed to register trace ftrace module notifier\n");
+
+	set_ftrace_early_filters();
+
 	return;
  failed:
 	ftrace_disabled = 1;
@@ -2417,7 +3056,6 @@ static const struct file_operations ftrace_pid_fops = {
 static __init int ftrace_init_debugfs(void)
 {
 	struct dentry *d_tracer;
-	struct dentry *entry;
 
 	d_tracer = tracing_init_dentry();
 	if (!d_tracer)
@@ -2425,11 +3063,11 @@ static __init int ftrace_init_debugfs(void)
 
 	ftrace_init_dyn_debugfs(d_tracer);
 
-	entry = debugfs_create_file("set_ftrace_pid", 0644, d_tracer,
-				    NULL, &ftrace_pid_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs "
-			   "'set_ftrace_pid' entry\n");
+	trace_create_file("set_ftrace_pid", 0644, d_tracer,
+			    NULL, &ftrace_pid_fops);
+
+	ftrace_profile_debugfs(d_tracer);
+
 	return 0;
 }
 fs_initcall(ftrace_init_debugfs);
@@ -2538,7 +3176,7 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 
-static atomic_t ftrace_graph_active;
+static int ftrace_graph_active;
 static struct notifier_block ftrace_suspend_notifier;
 
 int ftrace_graph_entry_stub(struct ftrace_graph_ent *trace)
@@ -2690,7 +3328,7 @@ int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 	mutex_lock(&ftrace_lock);
 
 	/* we currently allow only one tracer registered at a time */
-	if (atomic_read(&ftrace_graph_active)) {
+	if (ftrace_graph_active) {
 		ret = -EBUSY;
 		goto out;
 	}
@@ -2698,10 +3336,10 @@ int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 	ftrace_suspend_notifier.notifier_call = ftrace_suspend_notifier_call;
 	register_pm_notifier(&ftrace_suspend_notifier);
 
-	atomic_inc(&ftrace_graph_active);
+	ftrace_graph_active++;
 	ret = start_graph_tracing();
 	if (ret) {
-		atomic_dec(&ftrace_graph_active);
+		ftrace_graph_active--;
 		goto out;
 	}
 
@@ -2719,10 +3357,10 @@ void unregister_ftrace_graph(void)
 {
 	mutex_lock(&ftrace_lock);
 
-	if (!unlikely(atomic_read(&ftrace_graph_active)))
+	if (unlikely(!ftrace_graph_active))
 		goto out;
 
-	atomic_dec(&ftrace_graph_active);
+	ftrace_graph_active--;
 	unregister_trace_sched_switch(ftrace_graph_probe_sched_switch);
 	ftrace_graph_return = (trace_func_graph_ret_t)ftrace_stub;
 	ftrace_graph_entry = ftrace_graph_entry_stub;
@@ -2736,7 +3374,7 @@ void unregister_ftrace_graph(void)
 /* Allocate a return stack for newly created task */
 void ftrace_graph_init_task(struct task_struct *t)
 {
-	if (atomic_read(&ftrace_graph_active)) {
+	if (ftrace_graph_active) {
 		t->ret_stack = kmalloc(FTRACE_RETFUNC_DEPTH
 				* sizeof(struct ftrace_ret_stack),
 				GFP_KERNEL);
diff --git a/kernel/trace/kmemtrace.c b/kernel/trace/kmemtrace.c
index 5011f4d..86cdf67 100644
--- a/kernel/trace/kmemtrace.c
+++ b/kernel/trace/kmemtrace.c
@@ -12,7 +12,7 @@
 #include <linux/dcache.h>
 #include <linux/fs.h>
 
-#include <trace/kmemtrace.h>
+#include <linux/kmemtrace.h>
 
 #include "trace_output.h"
 #include "trace.h"
@@ -42,6 +42,7 @@ static inline void kmemtrace_alloc(enum kmemtrace_type_id type_id,
 				   gfp_t gfp_flags,
 				   int node)
 {
+	struct ftrace_event_call *call = &event_kmem_alloc;
 	struct trace_array *tr = kmemtrace_array;
 	struct kmemtrace_alloc_entry *entry;
 	struct ring_buffer_event *event;
@@ -62,7 +63,8 @@ static inline void kmemtrace_alloc(enum kmemtrace_type_id type_id,
 	entry->gfp_flags	= gfp_flags;
 	entry->node		= node;
 
-	ring_buffer_unlock_commit(tr->buffer, event);
+	if (!filter_check_discard(call, entry, tr->buffer, event))
+		ring_buffer_unlock_commit(tr->buffer, event);
 
 	trace_wake_up();
 }
@@ -71,6 +73,7 @@ static inline void kmemtrace_free(enum kmemtrace_type_id type_id,
 				  unsigned long call_site,
 				  const void *ptr)
 {
+	struct ftrace_event_call *call = &event_kmem_free;
 	struct trace_array *tr = kmemtrace_array;
 	struct kmemtrace_free_entry *entry;
 	struct ring_buffer_event *event;
@@ -86,7 +89,8 @@ static inline void kmemtrace_free(enum kmemtrace_type_id type_id,
 	entry->call_site	= call_site;
 	entry->ptr		= ptr;
 
-	ring_buffer_unlock_commit(tr->buffer, event);
+	if (!filter_check_discard(call, entry, tr->buffer, event))
+		ring_buffer_unlock_commit(tr->buffer, event);
 
 	trace_wake_up();
 }
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 960cbf4..2e642b2 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -22,6 +22,28 @@
 #include "trace.h"
 
 /*
+ * The ring buffer header is special. We must manually up keep it.
+ */
+int ring_buffer_print_entry_header(struct trace_seq *s)
+{
+	int ret;
+
+	ret = trace_seq_printf(s, "# compressed entry header\n");
+	ret = trace_seq_printf(s, "\ttype_len    :    5 bits\n");
+	ret = trace_seq_printf(s, "\ttime_delta  :   27 bits\n");
+	ret = trace_seq_printf(s, "\tarray       :   32 bits\n");
+	ret = trace_seq_printf(s, "\n");
+	ret = trace_seq_printf(s, "\tpadding     : type == %d\n",
+			       RINGBUF_TYPE_PADDING);
+	ret = trace_seq_printf(s, "\ttime_extend : type == %d\n",
+			       RINGBUF_TYPE_TIME_EXTEND);
+	ret = trace_seq_printf(s, "\tdata max type_len  == %d\n",
+			       RINGBUF_TYPE_DATA_TYPE_LEN_MAX);
+
+	return ret;
+}
+
+/*
  * The ring buffer is made up of a list of pages. A separate list of pages is
  * allocated for each CPU. A writer may only write to a buffer that is
  * associated with the CPU it is currently executing on.  A reader may read
@@ -182,7 +204,10 @@ EXPORT_SYMBOL_GPL(tracing_is_on);
 
 #define RB_EVNT_HDR_SIZE (offsetof(struct ring_buffer_event, array))
 #define RB_ALIGNMENT		4U
-#define RB_MAX_SMALL_DATA	28
+#define RB_MAX_SMALL_DATA	(RB_ALIGNMENT * RINGBUF_TYPE_DATA_TYPE_LEN_MAX)
+
+/* define RINGBUF_TYPE_DATA for 'case RINGBUF_TYPE_DATA:' */
+#define RINGBUF_TYPE_DATA 0 ... RINGBUF_TYPE_DATA_TYPE_LEN_MAX
 
 enum {
 	RB_LEN_TIME_EXTEND = 8,
@@ -191,48 +216,28 @@ enum {
 
 static inline int rb_null_event(struct ring_buffer_event *event)
 {
-	return event->type == RINGBUF_TYPE_PADDING && event->time_delta == 0;
+	return event->type_len == RINGBUF_TYPE_PADDING
+			&& event->time_delta == 0;
 }
 
 static inline int rb_discarded_event(struct ring_buffer_event *event)
 {
-	return event->type == RINGBUF_TYPE_PADDING && event->time_delta;
+	return event->type_len == RINGBUF_TYPE_PADDING && event->time_delta;
 }
 
 static void rb_event_set_padding(struct ring_buffer_event *event)
 {
-	event->type = RINGBUF_TYPE_PADDING;
+	event->type_len = RINGBUF_TYPE_PADDING;
 	event->time_delta = 0;
 }
 
-/**
- * ring_buffer_event_discard - discard an event in the ring buffer
- * @buffer: the ring buffer
- * @event: the event to discard
- *
- * Sometimes a event that is in the ring buffer needs to be ignored.
- * This function lets the user discard an event in the ring buffer
- * and then that event will not be read later.
- *
- * Note, it is up to the user to be careful with this, and protect
- * against races. If the user discards an event that has been consumed
- * it is possible that it could corrupt the ring buffer.
- */
-void ring_buffer_event_discard(struct ring_buffer_event *event)
-{
-	event->type = RINGBUF_TYPE_PADDING;
-	/* time delta must be non zero */
-	if (!event->time_delta)
-		event->time_delta = 1;
-}
-
 static unsigned
 rb_event_data_length(struct ring_buffer_event *event)
 {
 	unsigned length;
 
-	if (event->len)
-		length = event->len * RB_ALIGNMENT;
+	if (event->type_len)
+		length = event->type_len * RB_ALIGNMENT;
 	else
 		length = event->array[0];
 	return length + RB_EVNT_HDR_SIZE;
@@ -242,12 +247,12 @@ rb_event_data_length(struct ring_buffer_event *event)
 static unsigned
 rb_event_length(struct ring_buffer_event *event)
 {
-	switch (event->type) {
+	switch (event->type_len) {
 	case RINGBUF_TYPE_PADDING:
 		if (rb_null_event(event))
 			/* undefined */
 			return -1;
-		return rb_event_data_length(event);
+		return  event->array[0] + RB_EVNT_HDR_SIZE;
 
 	case RINGBUF_TYPE_TIME_EXTEND:
 		return RB_LEN_TIME_EXTEND;
@@ -271,7 +276,7 @@ rb_event_length(struct ring_buffer_event *event)
 unsigned ring_buffer_event_length(struct ring_buffer_event *event)
 {
 	unsigned length = rb_event_length(event);
-	if (event->type != RINGBUF_TYPE_DATA)
+	if (event->type_len > RINGBUF_TYPE_DATA_TYPE_LEN_MAX)
 		return length;
 	length -= RB_EVNT_HDR_SIZE;
 	if (length > RB_MAX_SMALL_DATA + sizeof(event->array[0]))
@@ -284,9 +289,9 @@ EXPORT_SYMBOL_GPL(ring_buffer_event_length);
 static void *
 rb_event_data(struct ring_buffer_event *event)
 {
-	BUG_ON(event->type != RINGBUF_TYPE_DATA);
+	BUG_ON(event->type_len > RINGBUF_TYPE_DATA_TYPE_LEN_MAX);
 	/* If length is in len field, then array[0] has the data */
-	if (event->len)
+	if (event->type_len)
 		return (void *)&event->array[0];
 	/* Otherwise length is in array[0] and array[1] has the data */
 	return (void *)&event->array[1];
@@ -316,9 +321,10 @@ struct buffer_data_page {
 };
 
 struct buffer_page {
+	struct list_head list;		/* list of buffer pages */
 	local_t		 write;		/* index for next write */
 	unsigned	 read;		/* index for next read */
-	struct list_head list;		/* list of free pages */
+	local_t		 entries;	/* entries on this page */
 	struct buffer_data_page *page;	/* Actual data page */
 };
 
@@ -361,6 +367,34 @@ static inline int test_time_stamp(u64 delta)
 
 #define BUF_PAGE_SIZE (PAGE_SIZE - BUF_PAGE_HDR_SIZE)
 
+/* Max payload is BUF_PAGE_SIZE - header (8bytes) */
+#define BUF_MAX_DATA_SIZE (BUF_PAGE_SIZE - (sizeof(u32) * 2))
+
+/* Max number of timestamps that can fit on a page */
+#define RB_TIMESTAMPS_PER_PAGE	(BUF_PAGE_SIZE / RB_LEN_TIME_STAMP)
+
+int ring_buffer_print_page_header(struct trace_seq *s)
+{
+	struct buffer_data_page field;
+	int ret;
+
+	ret = trace_seq_printf(s, "\tfield: u64 timestamp;\t"
+			       "offset:0;\tsize:%u;\n",
+			       (unsigned int)sizeof(field.time_stamp));
+
+	ret = trace_seq_printf(s, "\tfield: local_t commit;\t"
+			       "offset:%u;\tsize:%u;\n",
+			       (unsigned int)offsetof(typeof(field), commit),
+			       (unsigned int)sizeof(field.commit));
+
+	ret = trace_seq_printf(s, "\tfield: char data;\t"
+			       "offset:%u;\tsize:%u;\n",
+			       (unsigned int)offsetof(typeof(field), data),
+			       (unsigned int)BUF_PAGE_SIZE);
+
+	return ret;
+}
+
 /*
  * head_page == tail_page && head == tail then buffer is empty.
  */
@@ -375,8 +409,11 @@ struct ring_buffer_per_cpu {
 	struct buffer_page		*tail_page;	/* write to tail */
 	struct buffer_page		*commit_page;	/* committed pages */
 	struct buffer_page		*reader_page;
+	unsigned long			nmi_dropped;
+	unsigned long			commit_overrun;
 	unsigned long			overrun;
-	unsigned long			entries;
+	unsigned long			read;
+	local_t				entries;
 	u64				write_stamp;
 	u64				read_stamp;
 	atomic_t			record_disabled;
@@ -389,6 +426,8 @@ struct ring_buffer {
 	atomic_t			record_disabled;
 	cpumask_var_t			cpumask;
 
+	struct lock_class_key		*reader_lock_key;
+
 	struct mutex			mutex;
 
 	struct ring_buffer_per_cpu	**buffers;
@@ -420,13 +459,18 @@ struct ring_buffer_iter {
 /* Up this if you want to test the TIME_EXTENTS and normalization */
 #define DEBUG_SHIFT 0
 
+static inline u64 rb_time_stamp(struct ring_buffer *buffer, int cpu)
+{
+	/* shift to debug/test normalization and TIME_EXTENTS */
+	return buffer->clock() << DEBUG_SHIFT;
+}
+
 u64 ring_buffer_time_stamp(struct ring_buffer *buffer, int cpu)
 {
 	u64 time;
 
 	preempt_disable_notrace();
-	/* shift to debug/test normalization and TIME_EXTENTS */
-	time = buffer->clock() << DEBUG_SHIFT;
+	time = rb_time_stamp(buffer, cpu);
 	preempt_enable_no_resched_notrace();
 
 	return time;
@@ -523,6 +567,7 @@ rb_allocate_cpu_buffer(struct ring_buffer *buffer, int cpu)
 	cpu_buffer->cpu = cpu;
 	cpu_buffer->buffer = buffer;
 	spin_lock_init(&cpu_buffer->reader_lock);
+	lockdep_set_class(&cpu_buffer->reader_lock, buffer->reader_lock_key);
 	cpu_buffer->lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
 	INIT_LIST_HEAD(&cpu_buffer->pages);
 
@@ -593,7 +638,8 @@ static int rb_cpu_notify(struct notifier_block *self,
  * when the buffer wraps. If this flag is not set, the buffer will
  * drop data when the tail hits the head.
  */
-struct ring_buffer *ring_buffer_alloc(unsigned long size, unsigned flags)
+struct ring_buffer *__ring_buffer_alloc(unsigned long size, unsigned flags,
+					struct lock_class_key *key)
 {
 	struct ring_buffer *buffer;
 	int bsize;
@@ -616,6 +662,7 @@ struct ring_buffer *ring_buffer_alloc(unsigned long size, unsigned flags)
 	buffer->pages = DIV_ROUND_UP(size, BUF_PAGE_SIZE);
 	buffer->flags = flags;
 	buffer->clock = trace_clock_local;
+	buffer->reader_lock_key = key;
 
 	/* need at least two pages */
 	if (buffer->pages == 1)
@@ -673,7 +720,7 @@ struct ring_buffer *ring_buffer_alloc(unsigned long size, unsigned flags)
 	kfree(buffer);
 	return NULL;
 }
-EXPORT_SYMBOL_GPL(ring_buffer_alloc);
+EXPORT_SYMBOL_GPL(__ring_buffer_alloc);
 
 /**
  * ring_buffer_free - free a ring buffer.
@@ -947,31 +994,6 @@ static inline unsigned rb_head_size(struct ring_buffer_per_cpu *cpu_buffer)
 	return rb_page_commit(cpu_buffer->head_page);
 }
 
-/*
- * When the tail hits the head and the buffer is in overwrite mode,
- * the head jumps to the next page and all content on the previous
- * page is discarded. But before doing so, we update the overrun
- * variable of the buffer.
- */
-static void rb_update_overflow(struct ring_buffer_per_cpu *cpu_buffer)
-{
-	struct ring_buffer_event *event;
-	unsigned long head;
-
-	for (head = 0; head < rb_head_size(cpu_buffer);
-	     head += rb_event_length(event)) {
-
-		event = __rb_page_index(cpu_buffer->head_page, head);
-		if (RB_WARN_ON(cpu_buffer, rb_null_event(event)))
-			return;
-		/* Only count data entries */
-		if (event->type != RINGBUF_TYPE_DATA)
-			continue;
-		cpu_buffer->overrun++;
-		cpu_buffer->entries--;
-	}
-}
-
 static inline void rb_inc_page(struct ring_buffer_per_cpu *cpu_buffer,
 			       struct buffer_page **bpage)
 {
@@ -991,7 +1013,7 @@ rb_event_index(struct ring_buffer_event *event)
 	return (addr & ~PAGE_MASK) - (PAGE_SIZE - BUF_PAGE_SIZE);
 }
 
-static int
+static inline int
 rb_is_commit(struct ring_buffer_per_cpu *cpu_buffer,
 	     struct ring_buffer_event *event)
 {
@@ -1110,28 +1132,21 @@ static void
 rb_update_event(struct ring_buffer_event *event,
 			 unsigned type, unsigned length)
 {
-	event->type = type;
+	event->type_len = type;
 
 	switch (type) {
 
 	case RINGBUF_TYPE_PADDING:
-		break;
-
 	case RINGBUF_TYPE_TIME_EXTEND:
-		event->len = DIV_ROUND_UP(RB_LEN_TIME_EXTEND, RB_ALIGNMENT);
-		break;
-
 	case RINGBUF_TYPE_TIME_STAMP:
-		event->len = DIV_ROUND_UP(RB_LEN_TIME_STAMP, RB_ALIGNMENT);
 		break;
 
-	case RINGBUF_TYPE_DATA:
+	case 0:
 		length -= RB_EVNT_HDR_SIZE;
-		if (length > RB_MAX_SMALL_DATA) {
-			event->len = 0;
+		if (length > RB_MAX_SMALL_DATA)
 			event->array[0] = length;
-		} else
-			event->len = DIV_ROUND_UP(length, RB_ALIGNMENT);
+		else
+			event->type_len = DIV_ROUND_UP(length, RB_ALIGNMENT);
 		break;
 	default:
 		BUG();
@@ -1155,131 +1170,156 @@ static unsigned rb_calculate_event_length(unsigned length)
 	return length;
 }
 
+
 static struct ring_buffer_event *
-__rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
-		  unsigned type, unsigned long length, u64 *ts)
+rb_move_tail(struct ring_buffer_per_cpu *cpu_buffer,
+	     unsigned long length, unsigned long tail,
+	     struct buffer_page *commit_page,
+	     struct buffer_page *tail_page, u64 *ts)
 {
-	struct buffer_page *tail_page, *head_page, *reader_page, *commit_page;
-	unsigned long tail, write;
+	struct buffer_page *next_page, *head_page, *reader_page;
 	struct ring_buffer *buffer = cpu_buffer->buffer;
 	struct ring_buffer_event *event;
-	unsigned long flags;
 	bool lock_taken = false;
+	unsigned long flags;
 
-	commit_page = cpu_buffer->commit_page;
-	/* we just need to protect against interrupts */
-	barrier();
-	tail_page = cpu_buffer->tail_page;
-	write = local_add_return(length, &tail_page->write);
-	tail = write - length;
+	next_page = tail_page;
 
-	/* See if we shot pass the end of this buffer page */
-	if (write > BUF_PAGE_SIZE) {
-		struct buffer_page *next_page = tail_page;
+	local_irq_save(flags);
+	/*
+	 * Since the write to the buffer is still not
+	 * fully lockless, we must be careful with NMIs.
+	 * The locks in the writers are taken when a write
+	 * crosses to a new page. The locks protect against
+	 * races with the readers (this will soon be fixed
+	 * with a lockless solution).
+	 *
+	 * Because we can not protect against NMIs, and we
+	 * want to keep traces reentrant, we need to manage
+	 * what happens when we are in an NMI.
+	 *
+	 * NMIs can happen after we take the lock.
+	 * If we are in an NMI, only take the lock
+	 * if it is not already taken. Otherwise
+	 * simply fail.
+	 */
+	if (unlikely(in_nmi())) {
+		if (!__raw_spin_trylock(&cpu_buffer->lock)) {
+			cpu_buffer->nmi_dropped++;
+			goto out_reset;
+		}
+	} else
+		__raw_spin_lock(&cpu_buffer->lock);
 
-		local_irq_save(flags);
-		/*
-		 * Since the write to the buffer is still not
-		 * fully lockless, we must be careful with NMIs.
-		 * The locks in the writers are taken when a write
-		 * crosses to a new page. The locks protect against
-		 * races with the readers (this will soon be fixed
-		 * with a lockless solution).
-		 *
-		 * Because we can not protect against NMIs, and we
-		 * want to keep traces reentrant, we need to manage
-		 * what happens when we are in an NMI.
-		 *
-		 * NMIs can happen after we take the lock.
-		 * If we are in an NMI, only take the lock
-		 * if it is not already taken. Otherwise
-		 * simply fail.
-		 */
-		if (unlikely(in_nmi())) {
-			if (!__raw_spin_trylock(&cpu_buffer->lock))
-				goto out_reset;
-		} else
-			__raw_spin_lock(&cpu_buffer->lock);
+	lock_taken = true;
 
-		lock_taken = true;
+	rb_inc_page(cpu_buffer, &next_page);
 
-		rb_inc_page(cpu_buffer, &next_page);
+	head_page = cpu_buffer->head_page;
+	reader_page = cpu_buffer->reader_page;
 
-		head_page = cpu_buffer->head_page;
-		reader_page = cpu_buffer->reader_page;
+	/* we grabbed the lock before incrementing */
+	if (RB_WARN_ON(cpu_buffer, next_page == reader_page))
+		goto out_reset;
 
-		/* we grabbed the lock before incrementing */
-		if (RB_WARN_ON(cpu_buffer, next_page == reader_page))
-			goto out_reset;
+	/*
+	 * If for some reason, we had an interrupt storm that made
+	 * it all the way around the buffer, bail, and warn
+	 * about it.
+	 */
+	if (unlikely(next_page == commit_page)) {
+		cpu_buffer->commit_overrun++;
+		goto out_reset;
+	}
 
-		/*
-		 * If for some reason, we had an interrupt storm that made
-		 * it all the way around the buffer, bail, and warn
-		 * about it.
-		 */
-		if (unlikely(next_page == commit_page)) {
-			WARN_ON_ONCE(1);
+	if (next_page == head_page) {
+		if (!(buffer->flags & RB_FL_OVERWRITE))
 			goto out_reset;
-		}
 
-		if (next_page == head_page) {
-			if (!(buffer->flags & RB_FL_OVERWRITE))
-				goto out_reset;
-
-			/* tail_page has not moved yet? */
-			if (tail_page == cpu_buffer->tail_page) {
-				/* count overflows */
-				rb_update_overflow(cpu_buffer);
+		/* tail_page has not moved yet? */
+		if (tail_page == cpu_buffer->tail_page) {
+			/* count overflows */
+			cpu_buffer->overrun +=
+				local_read(&head_page->entries);
 
-				rb_inc_page(cpu_buffer, &head_page);
-				cpu_buffer->head_page = head_page;
-				cpu_buffer->head_page->read = 0;
-			}
+			rb_inc_page(cpu_buffer, &head_page);
+			cpu_buffer->head_page = head_page;
+			cpu_buffer->head_page->read = 0;
 		}
+	}
 
-		/*
-		 * If the tail page is still the same as what we think
-		 * it is, then it is up to us to update the tail
-		 * pointer.
-		 */
-		if (tail_page == cpu_buffer->tail_page) {
-			local_set(&next_page->write, 0);
-			local_set(&next_page->page->commit, 0);
-			cpu_buffer->tail_page = next_page;
+	/*
+	 * If the tail page is still the same as what we think
+	 * it is, then it is up to us to update the tail
+	 * pointer.
+	 */
+	if (tail_page == cpu_buffer->tail_page) {
+		local_set(&next_page->write, 0);
+		local_set(&next_page->entries, 0);
+		local_set(&next_page->page->commit, 0);
+		cpu_buffer->tail_page = next_page;
+
+		/* reread the time stamp */
+		*ts = rb_time_stamp(buffer, cpu_buffer->cpu);
+		cpu_buffer->tail_page->page->time_stamp = *ts;
+	}
 
-			/* reread the time stamp */
-			*ts = ring_buffer_time_stamp(buffer, cpu_buffer->cpu);
-			cpu_buffer->tail_page->page->time_stamp = *ts;
-		}
+	/*
+	 * The actual tail page has moved forward.
+	 */
+	if (tail < BUF_PAGE_SIZE) {
+		/* Mark the rest of the page with padding */
+		event = __rb_page_index(tail_page, tail);
+		rb_event_set_padding(event);
+	}
 
-		/*
-		 * The actual tail page has moved forward.
-		 */
-		if (tail < BUF_PAGE_SIZE) {
-			/* Mark the rest of the page with padding */
-			event = __rb_page_index(tail_page, tail);
-			rb_event_set_padding(event);
-		}
+	/* Set the write back to the previous setting */
+	local_sub(length, &tail_page->write);
 
-		if (tail <= BUF_PAGE_SIZE)
-			/* Set the write back to the previous setting */
-			local_set(&tail_page->write, tail);
+	/*
+	 * If this was a commit entry that failed,
+	 * increment that too
+	 */
+	if (tail_page == cpu_buffer->commit_page &&
+	    tail == rb_commit_index(cpu_buffer)) {
+		rb_set_commit_to_write(cpu_buffer);
+	}
 
-		/*
-		 * If this was a commit entry that failed,
-		 * increment that too
-		 */
-		if (tail_page == cpu_buffer->commit_page &&
-		    tail == rb_commit_index(cpu_buffer)) {
-			rb_set_commit_to_write(cpu_buffer);
-		}
+	__raw_spin_unlock(&cpu_buffer->lock);
+	local_irq_restore(flags);
+
+	/* fail and let the caller try again */
+	return ERR_PTR(-EAGAIN);
+
+ out_reset:
+	/* reset write */
+	local_sub(length, &tail_page->write);
 
+	if (likely(lock_taken))
 		__raw_spin_unlock(&cpu_buffer->lock);
-		local_irq_restore(flags);
+	local_irq_restore(flags);
+	return NULL;
+}
 
-		/* fail and let the caller try again */
-		return ERR_PTR(-EAGAIN);
-	}
+static struct ring_buffer_event *
+__rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
+		  unsigned type, unsigned long length, u64 *ts)
+{
+	struct buffer_page *tail_page, *commit_page;
+	struct ring_buffer_event *event;
+	unsigned long tail, write;
+
+	commit_page = cpu_buffer->commit_page;
+	/* we just need to protect against interrupts */
+	barrier();
+	tail_page = cpu_buffer->tail_page;
+	write = local_add_return(length, &tail_page->write);
+	tail = write - length;
+
+	/* See if we shot pass the end of this buffer page */
+	if (write > BUF_PAGE_SIZE)
+		return rb_move_tail(cpu_buffer, length, tail,
+				    commit_page, tail_page, ts);
 
 	/* We reserved something on the buffer */
 
@@ -1289,6 +1329,10 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 	event = __rb_page_index(tail_page, tail);
 	rb_update_event(event, type, length);
 
+	/* The passed in type is zero for DATA */
+	if (likely(!type))
+		local_inc(&tail_page->entries);
+
 	/*
 	 * If this is a commit and the tail is zero, then update
 	 * this page's time stamp.
@@ -1297,16 +1341,38 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 		cpu_buffer->commit_page->page->time_stamp = *ts;
 
 	return event;
+}
 
- out_reset:
-	/* reset write */
-	if (tail <= BUF_PAGE_SIZE)
-		local_set(&tail_page->write, tail);
+static inline int
+rb_try_to_discard(struct ring_buffer_per_cpu *cpu_buffer,
+		  struct ring_buffer_event *event)
+{
+	unsigned long new_index, old_index;
+	struct buffer_page *bpage;
+	unsigned long index;
+	unsigned long addr;
 
-	if (likely(lock_taken))
-		__raw_spin_unlock(&cpu_buffer->lock);
-	local_irq_restore(flags);
-	return NULL;
+	new_index = rb_event_index(event);
+	old_index = new_index + rb_event_length(event);
+	addr = (unsigned long)event;
+	addr &= PAGE_MASK;
+
+	bpage = cpu_buffer->tail_page;
+
+	if (bpage->page == (void *)addr && rb_page_write(bpage) == old_index) {
+		/*
+		 * This is on the tail page. It is possible that
+		 * a write could come in and move the tail page
+		 * and write to the next page. That is fine
+		 * because we just shorten what is on this page.
+		 */
+		index = local_cmpxchg(&bpage->write, old_index, new_index);
+		if (index == old_index)
+			return 1;
+	}
+
+	/* could not discard */
+	return 0;
 }
 
 static int
@@ -1351,16 +1417,23 @@ rb_add_time_stamp(struct ring_buffer_per_cpu *cpu_buffer,
 			event->array[0] = *delta >> TS_SHIFT;
 		} else {
 			cpu_buffer->commit_page->page->time_stamp = *ts;
-			event->time_delta = 0;
-			event->array[0] = 0;
+			/* try to discard, since we do not need this */
+			if (!rb_try_to_discard(cpu_buffer, event)) {
+				/* nope, just zero it */
+				event->time_delta = 0;
+				event->array[0] = 0;
+			}
 		}
 		cpu_buffer->write_stamp = *ts;
 		/* let the caller know this was the commit */
 		ret = 1;
 	} else {
-		/* Darn, this is just wasted space */
-		event->time_delta = 0;
-		event->array[0] = 0;
+		/* Try to discard the event */
+		if (!rb_try_to_discard(cpu_buffer, event)) {
+			/* Darn, this is just wasted space */
+			event->time_delta = 0;
+			event->array[0] = 0;
+		}
 		ret = 0;
 	}
 
@@ -1371,13 +1444,14 @@ rb_add_time_stamp(struct ring_buffer_per_cpu *cpu_buffer,
 
 static struct ring_buffer_event *
 rb_reserve_next_event(struct ring_buffer_per_cpu *cpu_buffer,
-		      unsigned type, unsigned long length)
+		      unsigned long length)
 {
 	struct ring_buffer_event *event;
-	u64 ts, delta;
+	u64 ts, delta = 0;
 	int commit = 0;
 	int nr_loops = 0;
 
+	length = rb_calculate_event_length(length);
  again:
 	/*
 	 * We allow for interrupts to reenter here and do a trace.
@@ -1391,7 +1465,7 @@ rb_reserve_next_event(struct ring_buffer_per_cpu *cpu_buffer,
 	if (RB_WARN_ON(cpu_buffer, ++nr_loops > 1000))
 		return NULL;
 
-	ts = ring_buffer_time_stamp(cpu_buffer->buffer, cpu_buffer->cpu);
+	ts = rb_time_stamp(cpu_buffer->buffer, cpu_buffer->cpu);
 
 	/*
 	 * Only the first commit can update the timestamp.
@@ -1401,23 +1475,24 @@ rb_reserve_next_event(struct ring_buffer_per_cpu *cpu_buffer,
 	 * also be made. But only the entry that did the actual
 	 * commit will be something other than zero.
 	 */
-	if (cpu_buffer->tail_page == cpu_buffer->commit_page &&
-	    rb_page_write(cpu_buffer->tail_page) ==
-	    rb_commit_index(cpu_buffer)) {
+	if (likely(cpu_buffer->tail_page == cpu_buffer->commit_page &&
+		   rb_page_write(cpu_buffer->tail_page) ==
+		   rb_commit_index(cpu_buffer))) {
+		u64 diff;
 
-		delta = ts - cpu_buffer->write_stamp;
+		diff = ts - cpu_buffer->write_stamp;
 
-		/* make sure this delta is calculated here */
+		/* make sure this diff is calculated here */
 		barrier();
 
 		/* Did the write stamp get updated already? */
 		if (unlikely(ts < cpu_buffer->write_stamp))
-			delta = 0;
+			goto get_event;
 
-		if (test_time_stamp(delta)) {
+		delta = diff;
+		if (unlikely(test_time_stamp(delta))) {
 
 			commit = rb_add_time_stamp(cpu_buffer, &ts, &delta);
-
 			if (commit == -EBUSY)
 				return NULL;
 
@@ -1426,12 +1501,11 @@ rb_reserve_next_event(struct ring_buffer_per_cpu *cpu_buffer,
 
 			RB_WARN_ON(cpu_buffer, commit < 0);
 		}
-	} else
-		/* Non commits have zero deltas */
-		delta = 0;
+	}
 
-	event = __rb_reserve_next(cpu_buffer, type, length, &ts);
-	if (PTR_ERR(event) == -EAGAIN)
+ get_event:
+	event = __rb_reserve_next(cpu_buffer, 0, length, &ts);
+	if (unlikely(PTR_ERR(event) == -EAGAIN))
 		goto again;
 
 	if (!event) {
@@ -1448,7 +1522,7 @@ rb_reserve_next_event(struct ring_buffer_per_cpu *cpu_buffer,
 	 * If the timestamp was commited, make the commit our entry
 	 * now so that we will update it when needed.
 	 */
-	if (commit)
+	if (unlikely(commit))
 		rb_set_commit_event(cpu_buffer, event);
 	else if (!rb_is_commit(cpu_buffer, event))
 		delta = 0;
@@ -1458,6 +1532,36 @@ rb_reserve_next_event(struct ring_buffer_per_cpu *cpu_buffer,
 	return event;
 }
 
+#define TRACE_RECURSIVE_DEPTH 16
+
+static int trace_recursive_lock(void)
+{
+	current->trace_recursion++;
+
+	if (likely(current->trace_recursion < TRACE_RECURSIVE_DEPTH))
+		return 0;
+
+	/* Disable all tracing before we do anything else */
+	tracing_off_permanent();
+
+	printk_once(KERN_WARNING "Tracing recursion: depth[%ld]:"
+		    "HC[%lu]:SC[%lu]:NMI[%lu]\n",
+		    current->trace_recursion,
+		    hardirq_count() >> HARDIRQ_SHIFT,
+		    softirq_count() >> SOFTIRQ_SHIFT,
+		    in_nmi());
+
+	WARN_ON_ONCE(1);
+	return -1;
+}
+
+static void trace_recursive_unlock(void)
+{
+	WARN_ON_ONCE(!current->trace_recursion);
+
+	current->trace_recursion--;
+}
+
 static DEFINE_PER_CPU(int, rb_need_resched);
 
 /**
@@ -1491,6 +1595,9 @@ ring_buffer_lock_reserve(struct ring_buffer *buffer, unsigned long length)
 	/* If we are tracing schedule, we don't want to recurse */
 	resched = ftrace_preempt_disable();
 
+	if (trace_recursive_lock())
+		goto out_nocheck;
+
 	cpu = raw_smp_processor_id();
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
@@ -1501,11 +1608,10 @@ ring_buffer_lock_reserve(struct ring_buffer *buffer, unsigned long length)
 	if (atomic_read(&cpu_buffer->record_disabled))
 		goto out;
 
-	length = rb_calculate_event_length(length);
-	if (length > BUF_PAGE_SIZE)
+	if (length > BUF_MAX_DATA_SIZE)
 		goto out;
 
-	event = rb_reserve_next_event(cpu_buffer, RINGBUF_TYPE_DATA, length);
+	event = rb_reserve_next_event(cpu_buffer, length);
 	if (!event)
 		goto out;
 
@@ -1520,6 +1626,9 @@ ring_buffer_lock_reserve(struct ring_buffer *buffer, unsigned long length)
 	return event;
 
  out:
+	trace_recursive_unlock();
+
+ out_nocheck:
 	ftrace_preempt_enable(resched);
 	return NULL;
 }
@@ -1528,7 +1637,7 @@ EXPORT_SYMBOL_GPL(ring_buffer_lock_reserve);
 static void rb_commit(struct ring_buffer_per_cpu *cpu_buffer,
 		      struct ring_buffer_event *event)
 {
-	cpu_buffer->entries++;
+	local_inc(&cpu_buffer->entries);
 
 	/* Only process further if we own the commit */
 	if (!rb_is_commit(cpu_buffer, event))
@@ -1558,6 +1667,8 @@ int ring_buffer_unlock_commit(struct ring_buffer *buffer,
 
 	rb_commit(cpu_buffer, event);
 
+	trace_recursive_unlock();
+
 	/*
 	 * Only the last preempt count needs to restore preemption.
 	 */
@@ -1570,6 +1681,99 @@ int ring_buffer_unlock_commit(struct ring_buffer *buffer,
 }
 EXPORT_SYMBOL_GPL(ring_buffer_unlock_commit);
 
+static inline void rb_event_discard(struct ring_buffer_event *event)
+{
+	/* array[0] holds the actual length for the discarded event */
+	event->array[0] = rb_event_data_length(event) - RB_EVNT_HDR_SIZE;
+	event->type_len = RINGBUF_TYPE_PADDING;
+	/* time delta must be non zero */
+	if (!event->time_delta)
+		event->time_delta = 1;
+}
+
+/**
+ * ring_buffer_event_discard - discard any event in the ring buffer
+ * @event: the event to discard
+ *
+ * Sometimes a event that is in the ring buffer needs to be ignored.
+ * This function lets the user discard an event in the ring buffer
+ * and then that event will not be read later.
+ *
+ * Note, it is up to the user to be careful with this, and protect
+ * against races. If the user discards an event that has been consumed
+ * it is possible that it could corrupt the ring buffer.
+ */
+void ring_buffer_event_discard(struct ring_buffer_event *event)
+{
+	rb_event_discard(event);
+}
+EXPORT_SYMBOL_GPL(ring_buffer_event_discard);
+
+/**
+ * ring_buffer_commit_discard - discard an event that has not been committed
+ * @buffer: the ring buffer
+ * @event: non committed event to discard
+ *
+ * This is similar to ring_buffer_event_discard but must only be
+ * performed on an event that has not been committed yet. The difference
+ * is that this will also try to free the event from the ring buffer
+ * if another event has not been added behind it.
+ *
+ * If another event has been added behind it, it will set the event
+ * up as discarded, and perform the commit.
+ *
+ * If this function is called, do not call ring_buffer_unlock_commit on
+ * the event.
+ */
+void ring_buffer_discard_commit(struct ring_buffer *buffer,
+				struct ring_buffer_event *event)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	int cpu;
+
+	/* The event is discarded regardless */
+	rb_event_discard(event);
+
+	/*
+	 * This must only be called if the event has not been
+	 * committed yet. Thus we can assume that preemption
+	 * is still disabled.
+	 */
+	RB_WARN_ON(buffer, preemptible());
+
+	cpu = smp_processor_id();
+	cpu_buffer = buffer->buffers[cpu];
+
+	if (!rb_try_to_discard(cpu_buffer, event))
+		goto out;
+
+	/*
+	 * The commit is still visible by the reader, so we
+	 * must increment entries.
+	 */
+	local_inc(&cpu_buffer->entries);
+ out:
+	/*
+	 * If a write came in and pushed the tail page
+	 * we still need to update the commit pointer
+	 * if we were the commit.
+	 */
+	if (rb_is_commit(cpu_buffer, event))
+		rb_set_commit_to_write(cpu_buffer);
+
+	trace_recursive_unlock();
+
+	/*
+	 * Only the last preempt count needs to restore preemption.
+	 */
+	if (preempt_count() == 1)
+		ftrace_preempt_enable(per_cpu(rb_need_resched, cpu));
+	else
+		preempt_enable_no_resched_notrace();
+
+}
+EXPORT_SYMBOL_GPL(ring_buffer_discard_commit);
+
 /**
  * ring_buffer_write - write data to the buffer without reserving
  * @buffer: The ring buffer to write to.
@@ -1589,7 +1793,6 @@ int ring_buffer_write(struct ring_buffer *buffer,
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct ring_buffer_event *event;
-	unsigned long event_length;
 	void *body;
 	int ret = -EBUSY;
 	int cpu, resched;
@@ -1612,9 +1815,10 @@ int ring_buffer_write(struct ring_buffer *buffer,
 	if (atomic_read(&cpu_buffer->record_disabled))
 		goto out;
 
-	event_length = rb_calculate_event_length(length);
-	event = rb_reserve_next_event(cpu_buffer,
-				      RINGBUF_TYPE_DATA, event_length);
+	if (length > BUF_MAX_DATA_SIZE)
+		goto out;
+
+	event = rb_reserve_next_event(cpu_buffer, length);
 	if (!event)
 		goto out;
 
@@ -1728,7 +1932,8 @@ unsigned long ring_buffer_entries_cpu(struct ring_buffer *buffer, int cpu)
 		return 0;
 
 	cpu_buffer = buffer->buffers[cpu];
-	ret = cpu_buffer->entries;
+	ret = (local_read(&cpu_buffer->entries) - cpu_buffer->overrun)
+		- cpu_buffer->read;
 
 	return ret;
 }
@@ -1755,6 +1960,47 @@ unsigned long ring_buffer_overrun_cpu(struct ring_buffer *buffer, int cpu)
 EXPORT_SYMBOL_GPL(ring_buffer_overrun_cpu);
 
 /**
+ * ring_buffer_nmi_dropped_cpu - get the number of nmis that were dropped
+ * @buffer: The ring buffer
+ * @cpu: The per CPU buffer to get the number of overruns from
+ */
+unsigned long ring_buffer_nmi_dropped_cpu(struct ring_buffer *buffer, int cpu)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	unsigned long ret;
+
+	if (!cpumask_test_cpu(cpu, buffer->cpumask))
+		return 0;
+
+	cpu_buffer = buffer->buffers[cpu];
+	ret = cpu_buffer->nmi_dropped;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ring_buffer_nmi_dropped_cpu);
+
+/**
+ * ring_buffer_commit_overrun_cpu - get the number of overruns caused by commits
+ * @buffer: The ring buffer
+ * @cpu: The per CPU buffer to get the number of overruns from
+ */
+unsigned long
+ring_buffer_commit_overrun_cpu(struct ring_buffer *buffer, int cpu)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	unsigned long ret;
+
+	if (!cpumask_test_cpu(cpu, buffer->cpumask))
+		return 0;
+
+	cpu_buffer = buffer->buffers[cpu];
+	ret = cpu_buffer->commit_overrun;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ring_buffer_commit_overrun_cpu);
+
+/**
  * ring_buffer_entries - get the number of entries in a buffer
  * @buffer: The ring buffer
  *
@@ -1770,7 +2016,8 @@ unsigned long ring_buffer_entries(struct ring_buffer *buffer)
 	/* if you care about this being correct, lock the buffer */
 	for_each_buffer_cpu(buffer, cpu) {
 		cpu_buffer = buffer->buffers[cpu];
-		entries += cpu_buffer->entries;
+		entries += (local_read(&cpu_buffer->entries) -
+			    cpu_buffer->overrun) - cpu_buffer->read;
 	}
 
 	return entries;
@@ -1862,7 +2109,7 @@ rb_update_read_stamp(struct ring_buffer_per_cpu *cpu_buffer,
 {
 	u64 delta;
 
-	switch (event->type) {
+	switch (event->type_len) {
 	case RINGBUF_TYPE_PADDING:
 		return;
 
@@ -1893,7 +2140,7 @@ rb_update_iter_read_stamp(struct ring_buffer_iter *iter,
 {
 	u64 delta;
 
-	switch (event->type) {
+	switch (event->type_len) {
 	case RINGBUF_TYPE_PADDING:
 		return;
 
@@ -1966,6 +2213,7 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 	cpu_buffer->reader_page->list.prev = reader->list.prev;
 
 	local_set(&cpu_buffer->reader_page->write, 0);
+	local_set(&cpu_buffer->reader_page->entries, 0);
 	local_set(&cpu_buffer->reader_page->page->commit, 0);
 
 	/* Make the reader page now replace the head */
@@ -2008,8 +2256,9 @@ static void rb_advance_reader(struct ring_buffer_per_cpu *cpu_buffer)
 
 	event = rb_reader_event(cpu_buffer);
 
-	if (event->type == RINGBUF_TYPE_DATA || rb_discarded_event(event))
-		cpu_buffer->entries--;
+	if (event->type_len <= RINGBUF_TYPE_DATA_TYPE_LEN_MAX
+			|| rb_discarded_event(event))
+		cpu_buffer->read++;
 
 	rb_update_read_stamp(cpu_buffer, event);
 
@@ -2031,8 +2280,8 @@ static void rb_advance_iter(struct ring_buffer_iter *iter)
 	 * Check if we are at the end of the buffer.
 	 */
 	if (iter->head >= rb_page_size(iter->head_page)) {
-		if (RB_WARN_ON(buffer,
-			       iter->head_page == cpu_buffer->commit_page))
+		/* discarded commits can make the page empty */
+		if (iter->head_page == cpu_buffer->commit_page)
 			return;
 		rb_inc_iter(iter);
 		return;
@@ -2075,12 +2324,10 @@ rb_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
 	/*
 	 * We repeat when a timestamp is encountered. It is possible
 	 * to get multiple timestamps from an interrupt entering just
-	 * as one timestamp is about to be written. The max times
-	 * that this can happen is the number of nested interrupts we
-	 * can have.  Nesting 10 deep of interrupts is clearly
-	 * an anomaly.
+	 * as one timestamp is about to be written, or from discarded
+	 * commits. The most that we can have is the number on a single page.
 	 */
-	if (RB_WARN_ON(cpu_buffer, ++nr_loops > 10))
+	if (RB_WARN_ON(cpu_buffer, ++nr_loops > RB_TIMESTAMPS_PER_PAGE))
 		return NULL;
 
 	reader = rb_get_reader_page(cpu_buffer);
@@ -2089,7 +2336,7 @@ rb_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
 
 	event = rb_reader_event(cpu_buffer);
 
-	switch (event->type) {
+	switch (event->type_len) {
 	case RINGBUF_TYPE_PADDING:
 		if (rb_null_event(event))
 			RB_WARN_ON(cpu_buffer, 1);
@@ -2146,14 +2393,14 @@ rb_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
 
  again:
 	/*
-	 * We repeat when a timestamp is encountered. It is possible
-	 * to get multiple timestamps from an interrupt entering just
-	 * as one timestamp is about to be written. The max times
-	 * that this can happen is the number of nested interrupts we
-	 * can have. Nesting 10 deep of interrupts is clearly
-	 * an anomaly.
+	 * We repeat when a timestamp is encountered.
+	 * We can get multiple timestamps by nested interrupts or also
+	 * if filtering is on (discarding commits). Since discarding
+	 * commits can be frequent we can get a lot of timestamps.
+	 * But we limit them by not adding timestamps if they begin
+	 * at the start of a page.
 	 */
-	if (RB_WARN_ON(cpu_buffer, ++nr_loops > 10))
+	if (RB_WARN_ON(cpu_buffer, ++nr_loops > RB_TIMESTAMPS_PER_PAGE))
 		return NULL;
 
 	if (rb_per_cpu_empty(cpu_buffer))
@@ -2161,7 +2408,7 @@ rb_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
 
 	event = rb_iter_head_event(iter);
 
-	switch (event->type) {
+	switch (event->type_len) {
 	case RINGBUF_TYPE_PADDING:
 		if (rb_null_event(event)) {
 			rb_inc_iter(iter);
@@ -2220,7 +2467,7 @@ ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
 	event = rb_buffer_peek(buffer, cpu, ts);
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
-	if (event && event->type == RINGBUF_TYPE_PADDING) {
+	if (event && event->type_len == RINGBUF_TYPE_PADDING) {
 		cpu_relax();
 		goto again;
 	}
@@ -2248,7 +2495,7 @@ ring_buffer_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
 	event = rb_iter_peek(iter, ts);
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
-	if (event && event->type == RINGBUF_TYPE_PADDING) {
+	if (event && event->type_len == RINGBUF_TYPE_PADDING) {
 		cpu_relax();
 		goto again;
 	}
@@ -2293,7 +2540,7 @@ ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts)
  out:
 	preempt_enable();
 
-	if (event && event->type == RINGBUF_TYPE_PADDING) {
+	if (event && event->type_len == RINGBUF_TYPE_PADDING) {
 		cpu_relax();
 		goto again;
 	}
@@ -2386,7 +2633,7 @@ ring_buffer_read(struct ring_buffer_iter *iter, u64 *ts)
  out:
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
-	if (event && event->type == RINGBUF_TYPE_PADDING) {
+	if (event && event->type_len == RINGBUF_TYPE_PADDING) {
 		cpu_relax();
 		goto again;
 	}
@@ -2411,6 +2658,7 @@ rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
 	cpu_buffer->head_page
 		= list_entry(cpu_buffer->pages.next, struct buffer_page, list);
 	local_set(&cpu_buffer->head_page->write, 0);
+	local_set(&cpu_buffer->head_page->entries, 0);
 	local_set(&cpu_buffer->head_page->page->commit, 0);
 
 	cpu_buffer->head_page->read = 0;
@@ -2420,11 +2668,15 @@ rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
 
 	INIT_LIST_HEAD(&cpu_buffer->reader_page->list);
 	local_set(&cpu_buffer->reader_page->write, 0);
+	local_set(&cpu_buffer->reader_page->entries, 0);
 	local_set(&cpu_buffer->reader_page->page->commit, 0);
 	cpu_buffer->reader_page->read = 0;
 
+	cpu_buffer->nmi_dropped = 0;
+	cpu_buffer->commit_overrun = 0;
 	cpu_buffer->overrun = 0;
-	cpu_buffer->entries = 0;
+	cpu_buffer->read = 0;
+	local_set(&cpu_buffer->entries, 0);
 
 	cpu_buffer->write_stamp = 0;
 	cpu_buffer->read_stamp = 0;
@@ -2443,6 +2695,8 @@ void ring_buffer_reset_cpu(struct ring_buffer *buffer, int cpu)
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return;
 
+	atomic_inc(&cpu_buffer->record_disabled);
+
 	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 
 	__raw_spin_lock(&cpu_buffer->lock);
@@ -2452,6 +2706,8 @@ void ring_buffer_reset_cpu(struct ring_buffer *buffer, int cpu)
 	__raw_spin_unlock(&cpu_buffer->lock);
 
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+
+	atomic_dec(&cpu_buffer->record_disabled);
 }
 EXPORT_SYMBOL_GPL(ring_buffer_reset_cpu);
 
@@ -2578,28 +2834,6 @@ out:
 }
 EXPORT_SYMBOL_GPL(ring_buffer_swap_cpu);
 
-static void rb_remove_entries(struct ring_buffer_per_cpu *cpu_buffer,
-			      struct buffer_data_page *bpage,
-			      unsigned int offset)
-{
-	struct ring_buffer_event *event;
-	unsigned long head;
-
-	__raw_spin_lock(&cpu_buffer->lock);
-	for (head = offset; head < local_read(&bpage->commit);
-	     head += rb_event_length(event)) {
-
-		event = __rb_data_page_index(bpage, head);
-		if (RB_WARN_ON(cpu_buffer, rb_null_event(event)))
-			return;
-		/* Only count data entries */
-		if (event->type != RINGBUF_TYPE_DATA)
-			continue;
-		cpu_buffer->entries--;
-	}
-	__raw_spin_unlock(&cpu_buffer->lock);
-}
-
 /**
  * ring_buffer_alloc_read_page - allocate a page to read from buffer
  * @buffer: the buffer to allocate for.
@@ -2630,6 +2864,7 @@ void *ring_buffer_alloc_read_page(struct ring_buffer *buffer)
 
 	return bpage;
 }
+EXPORT_SYMBOL_GPL(ring_buffer_alloc_read_page);
 
 /**
  * ring_buffer_free_read_page - free an allocated read page
@@ -2642,6 +2877,7 @@ void ring_buffer_free_read_page(struct ring_buffer *buffer, void *data)
 {
 	free_page((unsigned long)data);
 }
+EXPORT_SYMBOL_GPL(ring_buffer_free_read_page);
 
 /**
  * ring_buffer_read_page - extract a page from the ring buffer
@@ -2768,16 +3004,17 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 		/* we copied everything to the beginning */
 		read = 0;
 	} else {
+		/* update the entry counter */
+		cpu_buffer->read += local_read(&reader->entries);
+
 		/* swap the pages */
 		rb_init_page(bpage);
 		bpage = reader->page;
 		reader->page = *data_page;
 		local_set(&reader->write, 0);
+		local_set(&reader->entries, 0);
 		reader->read = 0;
 		*data_page = bpage;
-
-		/* update the entry counter */
-		rb_remove_entries(cpu_buffer, bpage, read);
 	}
 	ret = read;
 
@@ -2787,6 +3024,7 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
  out:
 	return ret;
 }
+EXPORT_SYMBOL_GPL(ring_buffer_read_page);
 
 static ssize_t
 rb_simple_read(struct file *filp, char __user *ubuf,
@@ -2845,14 +3083,11 @@ static const struct file_operations rb_simple_fops = {
 static __init int rb_init_debugfs(void)
 {
 	struct dentry *d_tracer;
-	struct dentry *entry;
 
 	d_tracer = tracing_init_dentry();
 
-	entry = debugfs_create_file("tracing_on", 0644, d_tracer,
-				    &ring_buffer_flags, &rb_simple_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs 'tracing_on' entry\n");
+	trace_create_file("tracing_on", 0644, d_tracer,
+			    &ring_buffer_flags, &rb_simple_fops);
 
 	return 0;
 }
diff --git a/kernel/trace/ring_buffer_benchmark.c b/kernel/trace/ring_buffer_benchmark.c
new file mode 100644
index 0000000..8d68e14
--- /dev/null
+++ b/kernel/trace/ring_buffer_benchmark.c
@@ -0,0 +1,416 @@
+/*
+ * ring buffer tester and benchmark
+ *
+ * Copyright (C) 2009 Steven Rostedt <srostedt@redhat.com>
+ */
+#include <linux/ring_buffer.h>
+#include <linux/completion.h>
+#include <linux/kthread.h>
+#include <linux/module.h>
+#include <linux/time.h>
+
+struct rb_page {
+	u64		ts;
+	local_t		commit;
+	char		data[4080];
+};
+
+/* run time and sleep time in seconds */
+#define RUN_TIME	10
+#define SLEEP_TIME	10
+
+/* number of events for writer to wake up the reader */
+static int wakeup_interval = 100;
+
+static int reader_finish;
+static struct completion read_start;
+static struct completion read_done;
+
+static struct ring_buffer *buffer;
+static struct task_struct *producer;
+static struct task_struct *consumer;
+static unsigned long read;
+
+static int disable_reader;
+module_param(disable_reader, uint, 0644);
+MODULE_PARM_DESC(disable_reader, "only run producer");
+
+static int read_events;
+
+static int kill_test;
+
+#define KILL_TEST()				\
+	do {					\
+		if (!kill_test) {		\
+			kill_test = 1;		\
+			WARN_ON(1);		\
+		}				\
+	} while (0)
+
+enum event_status {
+	EVENT_FOUND,
+	EVENT_DROPPED,
+};
+
+static enum event_status read_event(int cpu)
+{
+	struct ring_buffer_event *event;
+	int *entry;
+	u64 ts;
+
+	event = ring_buffer_consume(buffer, cpu, &ts);
+	if (!event)
+		return EVENT_DROPPED;
+
+	entry = ring_buffer_event_data(event);
+	if (*entry != cpu) {
+		KILL_TEST();
+		return EVENT_DROPPED;
+	}
+
+	read++;
+	return EVENT_FOUND;
+}
+
+static enum event_status read_page(int cpu)
+{
+	struct ring_buffer_event *event;
+	struct rb_page *rpage;
+	unsigned long commit;
+	void *bpage;
+	int *entry;
+	int ret;
+	int inc;
+	int i;
+
+	bpage = ring_buffer_alloc_read_page(buffer);
+	if (!bpage)
+		return EVENT_DROPPED;
+
+	ret = ring_buffer_read_page(buffer, &bpage, PAGE_SIZE, cpu, 1);
+	if (ret >= 0) {
+		rpage = bpage;
+		commit = local_read(&rpage->commit);
+		for (i = 0; i < commit && !kill_test; i += inc) {
+
+			if (i >= (PAGE_SIZE - offsetof(struct rb_page, data))) {
+				KILL_TEST();
+				break;
+			}
+
+			inc = -1;
+			event = (void *)&rpage->data[i];
+			switch (event->type_len) {
+			case RINGBUF_TYPE_PADDING:
+				/* We don't expect any padding */
+				KILL_TEST();
+				break;
+			case RINGBUF_TYPE_TIME_EXTEND:
+				inc = 8;
+				break;
+			case 0:
+				entry = ring_buffer_event_data(event);
+				if (*entry != cpu) {
+					KILL_TEST();
+					break;
+				}
+				read++;
+				if (!event->array[0]) {
+					KILL_TEST();
+					break;
+				}
+				inc = event->array[0];
+				break;
+			default:
+				entry = ring_buffer_event_data(event);
+				if (*entry != cpu) {
+					KILL_TEST();
+					break;
+				}
+				read++;
+				inc = ((event->type_len + 1) * 4);
+			}
+			if (kill_test)
+				break;
+
+			if (inc <= 0) {
+				KILL_TEST();
+				break;
+			}
+		}
+	}
+	ring_buffer_free_read_page(buffer, bpage);
+
+	if (ret < 0)
+		return EVENT_DROPPED;
+	return EVENT_FOUND;
+}
+
+static void ring_buffer_consumer(void)
+{
+	/* toggle between reading pages and events */
+	read_events ^= 1;
+
+	read = 0;
+	while (!reader_finish && !kill_test) {
+		int found;
+
+		do {
+			int cpu;
+
+			found = 0;
+			for_each_online_cpu(cpu) {
+				enum event_status stat;
+
+				if (read_events)
+					stat = read_event(cpu);
+				else
+					stat = read_page(cpu);
+
+				if (kill_test)
+					break;
+				if (stat == EVENT_FOUND)
+					found = 1;
+			}
+		} while (found && !kill_test);
+
+		set_current_state(TASK_INTERRUPTIBLE);
+		if (reader_finish)
+			break;
+
+		schedule();
+		__set_current_state(TASK_RUNNING);
+	}
+	reader_finish = 0;
+	complete(&read_done);
+}
+
+static void ring_buffer_producer(void)
+{
+	struct timeval start_tv;
+	struct timeval end_tv;
+	unsigned long long time;
+	unsigned long long entries;
+	unsigned long long overruns;
+	unsigned long missed = 0;
+	unsigned long hit = 0;
+	unsigned long avg;
+	int cnt = 0;
+
+	/*
+	 * Hammer the buffer for 10 secs (this may
+	 * make the system stall)
+	 */
+	pr_info("Starting ring buffer hammer\n");
+	do_gettimeofday(&start_tv);
+	do {
+		struct ring_buffer_event *event;
+		int *entry;
+
+		event = ring_buffer_lock_reserve(buffer, 10);
+		if (!event) {
+			missed++;
+		} else {
+			hit++;
+			entry = ring_buffer_event_data(event);
+			*entry = smp_processor_id();
+			ring_buffer_unlock_commit(buffer, event);
+		}
+		do_gettimeofday(&end_tv);
+
+		cnt++;
+		if (consumer && !(cnt % wakeup_interval))
+			wake_up_process(consumer);
+
+#ifndef CONFIG_PREEMPT
+		/*
+		 * If we are a non preempt kernel, the 10 second run will
+		 * stop everything while it runs. Instead, we will call
+		 * cond_resched and also add any time that was lost by a
+		 * rescedule.
+		 *
+		 * Do a cond resched at the same frequency we would wake up
+		 * the reader.
+		 */
+		if (cnt % wakeup_interval)
+			cond_resched();
+#endif
+
+	} while (end_tv.tv_sec < (start_tv.tv_sec + RUN_TIME) && !kill_test);
+	pr_info("End ring buffer hammer\n");
+
+	if (consumer) {
+		/* Init both completions here to avoid races */
+		init_completion(&read_start);
+		init_completion(&read_done);
+		/* the completions must be visible before the finish var */
+		smp_wmb();
+		reader_finish = 1;
+		/* finish var visible before waking up the consumer */
+		smp_wmb();
+		wake_up_process(consumer);
+		wait_for_completion(&read_done);
+	}
+
+	time = end_tv.tv_sec - start_tv.tv_sec;
+	time *= USEC_PER_SEC;
+	time += (long long)((long)end_tv.tv_usec - (long)start_tv.tv_usec);
+
+	entries = ring_buffer_entries(buffer);
+	overruns = ring_buffer_overruns(buffer);
+
+	if (kill_test)
+		pr_info("ERROR!\n");
+	pr_info("Time:     %lld (usecs)\n", time);
+	pr_info("Overruns: %lld\n", overruns);
+	if (disable_reader)
+		pr_info("Read:     (reader disabled)\n");
+	else
+		pr_info("Read:     %ld  (by %s)\n", read,
+			read_events ? "events" : "pages");
+	pr_info("Entries:  %lld\n", entries);
+	pr_info("Total:    %lld\n", entries + overruns + read);
+	pr_info("Missed:   %ld\n", missed);
+	pr_info("Hit:      %ld\n", hit);
+
+	/* Convert time from usecs to millisecs */
+	do_div(time, USEC_PER_MSEC);
+	if (time)
+		hit /= (long)time;
+	else
+		pr_info("TIME IS ZERO??\n");
+
+	pr_info("Entries per millisec: %ld\n", hit);
+
+	if (hit) {
+		/* Calculate the average time in nanosecs */
+		avg = NSEC_PER_MSEC / hit;
+		pr_info("%ld ns per entry\n", avg);
+	}
+
+	if (missed) {
+		if (time)
+			missed /= (long)time;
+
+		pr_info("Total iterations per millisec: %ld\n", hit + missed);
+
+		/* it is possible that hit + missed will overflow and be zero */
+		if (!(hit + missed)) {
+			pr_info("hit + missed overflowed and totalled zero!\n");
+			hit--; /* make it non zero */
+		}
+
+		/* Caculate the average time in nanosecs */
+		avg = NSEC_PER_MSEC / (hit + missed);
+		pr_info("%ld ns per entry\n", avg);
+	}
+}
+
+static void wait_to_die(void)
+{
+	set_current_state(TASK_INTERRUPTIBLE);
+	while (!kthread_should_stop()) {
+		schedule();
+		set_current_state(TASK_INTERRUPTIBLE);
+	}
+	__set_current_state(TASK_RUNNING);
+}
+
+static int ring_buffer_consumer_thread(void *arg)
+{
+	while (!kthread_should_stop() && !kill_test) {
+		complete(&read_start);
+
+		ring_buffer_consumer();
+
+		set_current_state(TASK_INTERRUPTIBLE);
+		if (kthread_should_stop() || kill_test)
+			break;
+
+		schedule();
+		__set_current_state(TASK_RUNNING);
+	}
+	__set_current_state(TASK_RUNNING);
+
+	if (kill_test)
+		wait_to_die();
+
+	return 0;
+}
+
+static int ring_buffer_producer_thread(void *arg)
+{
+	init_completion(&read_start);
+
+	while (!kthread_should_stop() && !kill_test) {
+		ring_buffer_reset(buffer);
+
+		if (consumer) {
+			smp_wmb();
+			wake_up_process(consumer);
+			wait_for_completion(&read_start);
+		}
+
+		ring_buffer_producer();
+
+		pr_info("Sleeping for 10 secs\n");
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule_timeout(HZ * SLEEP_TIME);
+		__set_current_state(TASK_RUNNING);
+	}
+
+	if (kill_test)
+		wait_to_die();
+
+	return 0;
+}
+
+static int __init ring_buffer_benchmark_init(void)
+{
+	int ret;
+
+	/* make a one meg buffer in overwite mode */
+	buffer = ring_buffer_alloc(1000000, RB_FL_OVERWRITE);
+	if (!buffer)
+		return -ENOMEM;
+
+	if (!disable_reader) {
+		consumer = kthread_create(ring_buffer_consumer_thread,
+					  NULL, "rb_consumer");
+		ret = PTR_ERR(consumer);
+		if (IS_ERR(consumer))
+			goto out_fail;
+	}
+
+	producer = kthread_run(ring_buffer_producer_thread,
+			       NULL, "rb_producer");
+	ret = PTR_ERR(producer);
+
+	if (IS_ERR(producer))
+		goto out_kill;
+
+	return 0;
+
+ out_kill:
+	if (consumer)
+		kthread_stop(consumer);
+
+ out_fail:
+	ring_buffer_free(buffer);
+	return ret;
+}
+
+static void __exit ring_buffer_benchmark_exit(void)
+{
+	kthread_stop(producer);
+	if (consumer)
+		kthread_stop(consumer);
+	ring_buffer_free(buffer);
+}
+
+module_init(ring_buffer_benchmark_init);
+module_exit(ring_buffer_benchmark_exit);
+
+MODULE_AUTHOR("Steven Rostedt");
+MODULE_DESCRIPTION("ring_buffer_benchmark");
+MODULE_LICENSE("GPL");
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index a884c09..cae34c6 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -171,6 +171,13 @@ static struct trace_array	global_trace;
 
 static DEFINE_PER_CPU(struct trace_array_cpu, global_trace_cpu);
 
+int filter_current_check_discard(struct ftrace_event_call *call, void *rec,
+				 struct ring_buffer_event *event)
+{
+	return filter_check_discard(call, rec, global_trace.buffer, event);
+}
+EXPORT_SYMBOL_GPL(filter_current_check_discard);
+
 cycle_t ftrace_now(int cpu)
 {
 	u64 ts;
@@ -255,7 +262,8 @@ static DECLARE_WAIT_QUEUE_HEAD(trace_wait);
 
 /* trace_flags holds trace_options default values */
 unsigned long trace_flags = TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK |
-	TRACE_ITER_ANNOTATE | TRACE_ITER_CONTEXT_INFO | TRACE_ITER_SLEEP_TIME;
+	TRACE_ITER_ANNOTATE | TRACE_ITER_CONTEXT_INFO | TRACE_ITER_SLEEP_TIME |
+	TRACE_ITER_GRAPH_TIME;
 
 /**
  * trace_wake_up - wake up tasks waiting for trace input
@@ -317,6 +325,7 @@ static const char *trace_options[] = {
 	"latency-format",
 	"global-clock",
 	"sleep-time",
+	"graph-time",
 	NULL
 };
 
@@ -402,17 +411,6 @@ static ssize_t trace_seq_to_buffer(struct trace_seq *s, void *buf, size_t cnt)
 	return cnt;
 }
 
-static void
-trace_print_seq(struct seq_file *m, struct trace_seq *s)
-{
-	int len = s->len >= PAGE_SIZE ? PAGE_SIZE - 1 : s->len;
-
-	s->buffer[len] = 0;
-	seq_puts(m, s->buffer);
-
-	trace_seq_init(s);
-}
-
 /**
  * update_max_tr - snapshot all trace buffers from global_trace to max_tr
  * @tr: tracer
@@ -641,6 +639,16 @@ void tracing_reset_online_cpus(struct trace_array *tr)
 		tracing_reset(tr, cpu);
 }
 
+void tracing_reset_current(int cpu)
+{
+	tracing_reset(&global_trace, cpu);
+}
+
+void tracing_reset_current_online_cpus(void)
+{
+	tracing_reset_online_cpus(&global_trace);
+}
+
 #define SAVED_CMDLINES 128
 #define NO_CMDLINE_MAP UINT_MAX
 static unsigned map_pid_to_cmdline[PID_MAX_DEFAULT+1];
@@ -800,6 +808,7 @@ void trace_find_cmdline(int pid, char comm[])
 		return;
 	}
 
+	preempt_disable();
 	__raw_spin_lock(&trace_cmdline_lock);
 	map = map_pid_to_cmdline[pid];
 	if (map != NO_CMDLINE_MAP)
@@ -808,6 +817,7 @@ void trace_find_cmdline(int pid, char comm[])
 		strcpy(comm, "<...>");
 
 	__raw_spin_unlock(&trace_cmdline_lock);
+	preempt_enable();
 }
 
 void tracing_record_cmdline(struct task_struct *tsk)
@@ -840,7 +850,7 @@ tracing_generic_entry_update(struct trace_entry *entry, unsigned long flags,
 }
 
 struct ring_buffer_event *trace_buffer_lock_reserve(struct trace_array *tr,
-						    unsigned char type,
+						    int type,
 						    unsigned long len,
 						    unsigned long flags, int pc)
 {
@@ -883,30 +893,40 @@ void trace_buffer_unlock_commit(struct trace_array *tr,
 }
 
 struct ring_buffer_event *
-trace_current_buffer_lock_reserve(unsigned char type, unsigned long len,
+trace_current_buffer_lock_reserve(int type, unsigned long len,
 				  unsigned long flags, int pc)
 {
 	return trace_buffer_lock_reserve(&global_trace,
 					 type, len, flags, pc);
 }
+EXPORT_SYMBOL_GPL(trace_current_buffer_lock_reserve);
 
 void trace_current_buffer_unlock_commit(struct ring_buffer_event *event,
 					unsigned long flags, int pc)
 {
-	return __trace_buffer_unlock_commit(&global_trace, event, flags, pc, 1);
+	__trace_buffer_unlock_commit(&global_trace, event, flags, pc, 1);
 }
+EXPORT_SYMBOL_GPL(trace_current_buffer_unlock_commit);
 
 void trace_nowake_buffer_unlock_commit(struct ring_buffer_event *event,
 					unsigned long flags, int pc)
 {
-	return __trace_buffer_unlock_commit(&global_trace, event, flags, pc, 0);
+	__trace_buffer_unlock_commit(&global_trace, event, flags, pc, 0);
+}
+EXPORT_SYMBOL_GPL(trace_nowake_buffer_unlock_commit);
+
+void trace_current_buffer_discard_commit(struct ring_buffer_event *event)
+{
+	ring_buffer_discard_commit(global_trace.buffer, event);
 }
+EXPORT_SYMBOL_GPL(trace_current_buffer_discard_commit);
 
 void
 trace_function(struct trace_array *tr,
 	       unsigned long ip, unsigned long parent_ip, unsigned long flags,
 	       int pc)
 {
+	struct ftrace_event_call *call = &event_function;
 	struct ring_buffer_event *event;
 	struct ftrace_entry *entry;
 
@@ -921,7 +941,9 @@ trace_function(struct trace_array *tr,
 	entry	= ring_buffer_event_data(event);
 	entry->ip			= ip;
 	entry->parent_ip		= parent_ip;
-	ring_buffer_unlock_commit(tr->buffer, event);
+
+	if (!filter_check_discard(call, entry, tr->buffer, event))
+		ring_buffer_unlock_commit(tr->buffer, event);
 }
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
@@ -930,6 +952,7 @@ static int __trace_graph_entry(struct trace_array *tr,
 				unsigned long flags,
 				int pc)
 {
+	struct ftrace_event_call *call = &event_funcgraph_entry;
 	struct ring_buffer_event *event;
 	struct ftrace_graph_ent_entry *entry;
 
@@ -942,7 +965,8 @@ static int __trace_graph_entry(struct trace_array *tr,
 		return 0;
 	entry	= ring_buffer_event_data(event);
 	entry->graph_ent			= *trace;
-	ring_buffer_unlock_commit(global_trace.buffer, event);
+	if (!filter_current_check_discard(call, entry, event))
+		ring_buffer_unlock_commit(global_trace.buffer, event);
 
 	return 1;
 }
@@ -952,6 +976,7 @@ static void __trace_graph_return(struct trace_array *tr,
 				unsigned long flags,
 				int pc)
 {
+	struct ftrace_event_call *call = &event_funcgraph_exit;
 	struct ring_buffer_event *event;
 	struct ftrace_graph_ret_entry *entry;
 
@@ -964,7 +989,8 @@ static void __trace_graph_return(struct trace_array *tr,
 		return;
 	entry	= ring_buffer_event_data(event);
 	entry->ret				= *trace;
-	ring_buffer_unlock_commit(global_trace.buffer, event);
+	if (!filter_current_check_discard(call, entry, event))
+		ring_buffer_unlock_commit(global_trace.buffer, event);
 }
 #endif
 
@@ -982,6 +1008,7 @@ static void __ftrace_trace_stack(struct trace_array *tr,
 				 int skip, int pc)
 {
 #ifdef CONFIG_STACKTRACE
+	struct ftrace_event_call *call = &event_kernel_stack;
 	struct ring_buffer_event *event;
 	struct stack_entry *entry;
 	struct stack_trace trace;
@@ -999,7 +1026,8 @@ static void __ftrace_trace_stack(struct trace_array *tr,
 	trace.entries		= entry->caller;
 
 	save_stack_trace(&trace);
-	ring_buffer_unlock_commit(tr->buffer, event);
+	if (!filter_check_discard(call, entry, tr->buffer, event))
+		ring_buffer_unlock_commit(tr->buffer, event);
 #endif
 }
 
@@ -1024,6 +1052,7 @@ static void ftrace_trace_userstack(struct trace_array *tr,
 				   unsigned long flags, int pc)
 {
 #ifdef CONFIG_STACKTRACE
+	struct ftrace_event_call *call = &event_user_stack;
 	struct ring_buffer_event *event;
 	struct userstack_entry *entry;
 	struct stack_trace trace;
@@ -1045,7 +1074,8 @@ static void ftrace_trace_userstack(struct trace_array *tr,
 	trace.entries		= entry->caller;
 
 	save_stack_trace_user(&trace);
-	ring_buffer_unlock_commit(tr->buffer, event);
+	if (!filter_check_discard(call, entry, tr->buffer, event))
+		ring_buffer_unlock_commit(tr->buffer, event);
 #endif
 }
 
@@ -1089,6 +1119,7 @@ tracing_sched_switch_trace(struct trace_array *tr,
 			   struct task_struct *next,
 			   unsigned long flags, int pc)
 {
+	struct ftrace_event_call *call = &event_context_switch;
 	struct ring_buffer_event *event;
 	struct ctx_switch_entry *entry;
 
@@ -1104,7 +1135,9 @@ tracing_sched_switch_trace(struct trace_array *tr,
 	entry->next_prio		= next->prio;
 	entry->next_state		= next->state;
 	entry->next_cpu	= task_cpu(next);
-	trace_buffer_unlock_commit(tr, event, flags, pc);
+
+	if (!filter_check_discard(call, entry, tr->buffer, event))
+		trace_buffer_unlock_commit(tr, event, flags, pc);
 }
 
 void
@@ -1113,6 +1146,7 @@ tracing_sched_wakeup_trace(struct trace_array *tr,
 			   struct task_struct *curr,
 			   unsigned long flags, int pc)
 {
+	struct ftrace_event_call *call = &event_wakeup;
 	struct ring_buffer_event *event;
 	struct ctx_switch_entry *entry;
 
@@ -1129,7 +1163,8 @@ tracing_sched_wakeup_trace(struct trace_array *tr,
 	entry->next_state		= wakee->state;
 	entry->next_cpu			= task_cpu(wakee);
 
-	ring_buffer_unlock_commit(tr->buffer, event);
+	if (!filter_check_discard(call, entry, tr->buffer, event))
+		ring_buffer_unlock_commit(tr->buffer, event);
 	ftrace_trace_stack(tr, flags, 6, pc);
 	ftrace_trace_userstack(tr, flags, pc);
 }
@@ -1230,11 +1265,13 @@ int trace_vbprintk(unsigned long ip, const char *fmt, va_list args)
 		(raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
 	static u32 trace_buf[TRACE_BUF_SIZE];
 
+	struct ftrace_event_call *call = &event_bprint;
 	struct ring_buffer_event *event;
 	struct trace_array *tr = &global_trace;
 	struct trace_array_cpu *data;
 	struct bprint_entry *entry;
 	unsigned long flags;
+	int disable;
 	int resched;
 	int cpu, len = 0, size, pc;
 
@@ -1249,7 +1286,8 @@ int trace_vbprintk(unsigned long ip, const char *fmt, va_list args)
 	cpu = raw_smp_processor_id();
 	data = tr->data[cpu];
 
-	if (unlikely(atomic_read(&data->disabled)))
+	disable = atomic_inc_return(&data->disabled);
+	if (unlikely(disable != 1))
 		goto out;
 
 	/* Lockdep uses trace_printk for lock tracing */
@@ -1269,13 +1307,15 @@ int trace_vbprintk(unsigned long ip, const char *fmt, va_list args)
 	entry->fmt			= fmt;
 
 	memcpy(entry->buf, trace_buf, sizeof(u32) * len);
-	ring_buffer_unlock_commit(tr->buffer, event);
+	if (!filter_check_discard(call, entry, tr->buffer, event))
+		ring_buffer_unlock_commit(tr->buffer, event);
 
 out_unlock:
 	__raw_spin_unlock(&trace_buf_lock);
 	local_irq_restore(flags);
 
 out:
+	atomic_dec_return(&data->disabled);
 	ftrace_preempt_enable(resched);
 	unpause_graph_tracing();
 
@@ -1288,12 +1328,14 @@ int trace_vprintk(unsigned long ip, const char *fmt, va_list args)
 	static raw_spinlock_t trace_buf_lock = __RAW_SPIN_LOCK_UNLOCKED;
 	static char trace_buf[TRACE_BUF_SIZE];
 
+	struct ftrace_event_call *call = &event_print;
 	struct ring_buffer_event *event;
 	struct trace_array *tr = &global_trace;
 	struct trace_array_cpu *data;
 	int cpu, len = 0, size, pc;
 	struct print_entry *entry;
 	unsigned long irq_flags;
+	int disable;
 
 	if (tracing_disabled || tracing_selftest_running)
 		return 0;
@@ -1303,7 +1345,8 @@ int trace_vprintk(unsigned long ip, const char *fmt, va_list args)
 	cpu = raw_smp_processor_id();
 	data = tr->data[cpu];
 
-	if (unlikely(atomic_read(&data->disabled)))
+	disable = atomic_inc_return(&data->disabled);
+	if (unlikely(disable != 1))
 		goto out;
 
 	pause_graph_tracing();
@@ -1323,13 +1366,15 @@ int trace_vprintk(unsigned long ip, const char *fmt, va_list args)
 
 	memcpy(&entry->buf, trace_buf, len);
 	entry->buf[len] = 0;
-	ring_buffer_unlock_commit(tr->buffer, event);
+	if (!filter_check_discard(call, entry, tr->buffer, event))
+		ring_buffer_unlock_commit(tr->buffer, event);
 
  out_unlock:
 	__raw_spin_unlock(&trace_buf_lock);
 	raw_local_irq_restore(irq_flags);
 	unpause_graph_tracing();
  out:
+	atomic_dec_return(&data->disabled);
 	preempt_enable_notrace();
 
 	return len;
@@ -1526,12 +1571,14 @@ static void *s_start(struct seq_file *m, loff_t *pos)
 		p = s_next(m, p, &l);
 	}
 
+	trace_event_read_lock();
 	return p;
 }
 
 static void s_stop(struct seq_file *m, void *p)
 {
 	atomic_dec(&trace_record_cmdline_disabled);
+	trace_event_read_unlock();
 }
 
 static void print_lat_help_header(struct seq_file *m)
@@ -1774,6 +1821,7 @@ static int trace_empty(struct trace_iterator *iter)
 	return 1;
 }
 
+/*  Called with trace_event_read_lock() held. */
 static enum print_line_t print_trace_line(struct trace_iterator *iter)
 {
 	enum print_line_t ret;
@@ -2397,6 +2445,56 @@ static const struct file_operations tracing_readme_fops = {
 };
 
 static ssize_t
+tracing_saved_cmdlines_read(struct file *file, char __user *ubuf,
+				size_t cnt, loff_t *ppos)
+{
+	char *buf_comm;
+	char *file_buf;
+	char *buf;
+	int len = 0;
+	int pid;
+	int i;
+
+	file_buf = kmalloc(SAVED_CMDLINES*(16+TASK_COMM_LEN), GFP_KERNEL);
+	if (!file_buf)
+		return -ENOMEM;
+
+	buf_comm = kmalloc(TASK_COMM_LEN, GFP_KERNEL);
+	if (!buf_comm) {
+		kfree(file_buf);
+		return -ENOMEM;
+	}
+
+	buf = file_buf;
+
+	for (i = 0; i < SAVED_CMDLINES; i++) {
+		int r;
+
+		pid = map_cmdline_to_pid[i];
+		if (pid == -1 || pid == NO_CMDLINE_MAP)
+			continue;
+
+		trace_find_cmdline(pid, buf_comm);
+		r = sprintf(buf, "%d %s\n", pid, buf_comm);
+		buf += r;
+		len += r;
+	}
+
+	len = simple_read_from_buffer(ubuf, cnt, ppos,
+				      file_buf, len);
+
+	kfree(file_buf);
+	kfree(buf_comm);
+
+	return len;
+}
+
+static const struct file_operations tracing_saved_cmdlines_fops = {
+    .open       = tracing_open_generic,
+    .read       = tracing_saved_cmdlines_read,
+};
+
+static ssize_t
 tracing_ctrl_read(struct file *filp, char __user *ubuf,
 		  size_t cnt, loff_t *ppos)
 {
@@ -2728,6 +2826,9 @@ static int tracing_open_pipe(struct inode *inode, struct file *filp)
 	/* trace pipe does not show start of buffer */
 	cpumask_setall(iter->started);
 
+	if (trace_flags & TRACE_ITER_LATENCY_FMT)
+		iter->iter_flags |= TRACE_FILE_LAT_FMT;
+
 	iter->cpu_file = cpu_file;
 	iter->tr = &global_trace;
 	mutex_init(&iter->mutex);
@@ -2915,6 +3016,7 @@ waitagain:
 	       offsetof(struct trace_iterator, seq));
 	iter->pos = -1;
 
+	trace_event_read_lock();
 	while (find_next_entry_inc(iter) != NULL) {
 		enum print_line_t ret;
 		int len = iter->seq.len;
@@ -2931,6 +3033,7 @@ waitagain:
 		if (iter->seq.len >= cnt)
 			break;
 	}
+	trace_event_read_unlock();
 
 	/* Now copy what we have to the user */
 	sret = trace_seq_to_user(&iter->seq, ubuf, cnt);
@@ -3053,6 +3156,8 @@ static ssize_t tracing_splice_read_pipe(struct file *filp,
 		goto out_err;
 	}
 
+	trace_event_read_lock();
+
 	/* Fill as many pages as possible. */
 	for (i = 0, rem = len; i < PIPE_BUFFERS && rem; i++) {
 		pages[i] = alloc_page(GFP_KERNEL);
@@ -3075,6 +3180,7 @@ static ssize_t tracing_splice_read_pipe(struct file *filp,
 		trace_seq_init(&iter->seq);
 	}
 
+	trace_event_read_unlock();
 	mutex_unlock(&iter->mutex);
 
 	spd.nr_pages = i;
@@ -3425,7 +3531,7 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 		.spd_release	= buffer_spd_release,
 	};
 	struct buffer_ref *ref;
-	int size, i;
+	int entries, size, i;
 	size_t ret;
 
 	if (*ppos & (PAGE_SIZE - 1)) {
@@ -3440,7 +3546,9 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 		len &= PAGE_MASK;
 	}
 
-	for (i = 0; i < PIPE_BUFFERS && len; i++, len -= PAGE_SIZE) {
+	entries = ring_buffer_entries_cpu(info->tr->buffer, info->cpu);
+
+	for (i = 0; i < PIPE_BUFFERS && len && entries; i++, len -= PAGE_SIZE) {
 		struct page *page;
 		int r;
 
@@ -3457,7 +3565,7 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 		}
 
 		r = ring_buffer_read_page(ref->buffer, &ref->page,
-					  len, info->cpu, 0);
+					  len, info->cpu, 1);
 		if (r < 0) {
 			ring_buffer_free_read_page(ref->buffer,
 						   ref->page);
@@ -3481,6 +3589,8 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 		spd.partial[i].private = (unsigned long)ref;
 		spd.nr_pages++;
 		*ppos += PAGE_SIZE;
+
+		entries = ring_buffer_entries_cpu(info->tr->buffer, info->cpu);
 	}
 
 	spd.nr_pages = i;
@@ -3508,6 +3618,45 @@ static const struct file_operations tracing_buffers_fops = {
 	.llseek		= no_llseek,
 };
 
+static ssize_t
+tracing_stats_read(struct file *filp, char __user *ubuf,
+		   size_t count, loff_t *ppos)
+{
+	unsigned long cpu = (unsigned long)filp->private_data;
+	struct trace_array *tr = &global_trace;
+	struct trace_seq *s;
+	unsigned long cnt;
+
+	s = kmalloc(sizeof(*s), GFP_ATOMIC);
+	if (!s)
+		return ENOMEM;
+
+	trace_seq_init(s);
+
+	cnt = ring_buffer_entries_cpu(tr->buffer, cpu);
+	trace_seq_printf(s, "entries: %ld\n", cnt);
+
+	cnt = ring_buffer_overrun_cpu(tr->buffer, cpu);
+	trace_seq_printf(s, "overrun: %ld\n", cnt);
+
+	cnt = ring_buffer_commit_overrun_cpu(tr->buffer, cpu);
+	trace_seq_printf(s, "commit overrun: %ld\n", cnt);
+
+	cnt = ring_buffer_nmi_dropped_cpu(tr->buffer, cpu);
+	trace_seq_printf(s, "nmi dropped: %ld\n", cnt);
+
+	count = simple_read_from_buffer(ubuf, count, ppos, s->buffer, s->len);
+
+	kfree(s);
+
+	return count;
+}
+
+static const struct file_operations tracing_stats_fops = {
+	.open		= tracing_open_generic,
+	.read		= tracing_stats_read,
+};
+
 #ifdef CONFIG_DYNAMIC_FTRACE
 
 int __weak ftrace_arch_read_dyn_info(char *buf, int size)
@@ -3597,7 +3746,7 @@ struct dentry *tracing_dentry_percpu(void)
 static void tracing_init_debugfs_percpu(long cpu)
 {
 	struct dentry *d_percpu = tracing_dentry_percpu();
-	struct dentry *entry, *d_cpu;
+	struct dentry *d_cpu;
 	/* strlen(cpu) + MAX(log10(cpu)) + '\0' */
 	char cpu_dir[7];
 
@@ -3612,21 +3761,18 @@ static void tracing_init_debugfs_percpu(long cpu)
 	}
 
 	/* per cpu trace_pipe */
-	entry = debugfs_create_file("trace_pipe", 0444, d_cpu,
-				(void *) cpu, &tracing_pipe_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs 'trace_pipe' entry\n");
+	trace_create_file("trace_pipe", 0444, d_cpu,
+			(void *) cpu, &tracing_pipe_fops);
 
 	/* per cpu trace */
-	entry = debugfs_create_file("trace", 0644, d_cpu,
-				(void *) cpu, &tracing_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs 'trace' entry\n");
+	trace_create_file("trace", 0644, d_cpu,
+			(void *) cpu, &tracing_fops);
+
+	trace_create_file("trace_pipe_raw", 0444, d_cpu,
+			(void *) cpu, &tracing_buffers_fops);
 
-	entry = debugfs_create_file("trace_pipe_raw", 0444, d_cpu,
-				    (void *) cpu, &tracing_buffers_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs 'trace_pipe_raw' entry\n");
+	trace_create_file("stats", 0444, d_cpu,
+			(void *) cpu, &tracing_stats_fops);
 }
 
 #ifdef CONFIG_FTRACE_SELFTEST
@@ -3782,6 +3928,22 @@ static const struct file_operations trace_options_core_fops = {
 	.write = trace_options_core_write,
 };
 
+struct dentry *trace_create_file(const char *name,
+				 mode_t mode,
+				 struct dentry *parent,
+				 void *data,
+				 const struct file_operations *fops)
+{
+	struct dentry *ret;
+
+	ret = debugfs_create_file(name, mode, parent, data, fops);
+	if (!ret)
+		pr_warning("Could not create debugfs '%s' entry\n", name);
+
+	return ret;
+}
+
+
 static struct dentry *trace_options_init_dentry(void)
 {
 	struct dentry *d_tracer;
@@ -3809,7 +3971,6 @@ create_trace_option_file(struct trace_option_dentry *topt,
 			 struct tracer_opt *opt)
 {
 	struct dentry *t_options;
-	struct dentry *entry;
 
 	t_options = trace_options_init_dentry();
 	if (!t_options)
@@ -3818,11 +3979,9 @@ create_trace_option_file(struct trace_option_dentry *topt,
 	topt->flags = flags;
 	topt->opt = opt;
 
-	entry = debugfs_create_file(opt->name, 0644, t_options, topt,
+	topt->entry = trace_create_file(opt->name, 0644, t_options, topt,
 				    &trace_options_fops);
 
-	topt->entry = entry;
-
 }
 
 static struct trace_option_dentry *
@@ -3877,123 +4036,84 @@ static struct dentry *
 create_trace_option_core_file(const char *option, long index)
 {
 	struct dentry *t_options;
-	struct dentry *entry;
 
 	t_options = trace_options_init_dentry();
 	if (!t_options)
 		return NULL;
 
-	entry = debugfs_create_file(option, 0644, t_options, (void *)index,
+	return trace_create_file(option, 0644, t_options, (void *)index,
 				    &trace_options_core_fops);
-
-	return entry;
 }
 
 static __init void create_trace_options_dir(void)
 {
 	struct dentry *t_options;
-	struct dentry *entry;
 	int i;
 
 	t_options = trace_options_init_dentry();
 	if (!t_options)
 		return;
 
-	for (i = 0; trace_options[i]; i++) {
-		entry = create_trace_option_core_file(trace_options[i], i);
-		if (!entry)
-			pr_warning("Could not create debugfs %s entry\n",
-				   trace_options[i]);
-	}
+	for (i = 0; trace_options[i]; i++)
+		create_trace_option_core_file(trace_options[i], i);
 }
 
 static __init int tracer_init_debugfs(void)
 {
 	struct dentry *d_tracer;
-	struct dentry *entry;
 	int cpu;
 
 	d_tracer = tracing_init_dentry();
 
-	entry = debugfs_create_file("tracing_enabled", 0644, d_tracer,
-				    &global_trace, &tracing_ctrl_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs 'tracing_enabled' entry\n");
+	trace_create_file("tracing_enabled", 0644, d_tracer,
+			&global_trace, &tracing_ctrl_fops);
 
-	entry = debugfs_create_file("trace_options", 0644, d_tracer,
-				    NULL, &tracing_iter_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs 'trace_options' entry\n");
+	trace_create_file("trace_options", 0644, d_tracer,
+			NULL, &tracing_iter_fops);
 
-	create_trace_options_dir();
+	trace_create_file("tracing_cpumask", 0644, d_tracer,
+			NULL, &tracing_cpumask_fops);
+
+	trace_create_file("trace", 0644, d_tracer,
+			(void *) TRACE_PIPE_ALL_CPU, &tracing_fops);
 
-	entry = debugfs_create_file("tracing_cpumask", 0644, d_tracer,
-				    NULL, &tracing_cpumask_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs 'tracing_cpumask' entry\n");
-
-	entry = debugfs_create_file("trace", 0644, d_tracer,
-				 (void *) TRACE_PIPE_ALL_CPU, &tracing_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs 'trace' entry\n");
-
-	entry = debugfs_create_file("available_tracers", 0444, d_tracer,
-				    &global_trace, &show_traces_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs 'available_tracers' entry\n");
-
-	entry = debugfs_create_file("current_tracer", 0444, d_tracer,
-				    &global_trace, &set_tracer_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs 'current_tracer' entry\n");
-
-	entry = debugfs_create_file("tracing_max_latency", 0644, d_tracer,
-				    &tracing_max_latency,
-				    &tracing_max_lat_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs "
-			   "'tracing_max_latency' entry\n");
-
-	entry = debugfs_create_file("tracing_thresh", 0644, d_tracer,
-				    &tracing_thresh, &tracing_max_lat_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs "
-			   "'tracing_thresh' entry\n");
-	entry = debugfs_create_file("README", 0644, d_tracer,
-				    NULL, &tracing_readme_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs 'README' entry\n");
-
-	entry = debugfs_create_file("trace_pipe", 0444, d_tracer,
+	trace_create_file("available_tracers", 0444, d_tracer,
+			&global_trace, &show_traces_fops);
+
+	trace_create_file("current_tracer", 0644, d_tracer,
+			&global_trace, &set_tracer_fops);
+
+	trace_create_file("tracing_max_latency", 0644, d_tracer,
+			&tracing_max_latency, &tracing_max_lat_fops);
+
+	trace_create_file("tracing_thresh", 0644, d_tracer,
+			&tracing_thresh, &tracing_max_lat_fops);
+
+	trace_create_file("README", 0444, d_tracer,
+			NULL, &tracing_readme_fops);
+
+	trace_create_file("trace_pipe", 0444, d_tracer,
 			(void *) TRACE_PIPE_ALL_CPU, &tracing_pipe_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs "
-			   "'trace_pipe' entry\n");
-
-	entry = debugfs_create_file("buffer_size_kb", 0644, d_tracer,
-				    &global_trace, &tracing_entries_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs "
-			   "'buffer_size_kb' entry\n");
-
-	entry = debugfs_create_file("trace_marker", 0220, d_tracer,
-				    NULL, &tracing_mark_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs "
-			   "'trace_marker' entry\n");
+
+	trace_create_file("buffer_size_kb", 0644, d_tracer,
+			&global_trace, &tracing_entries_fops);
+
+	trace_create_file("trace_marker", 0220, d_tracer,
+			NULL, &tracing_mark_fops);
+
+	trace_create_file("saved_cmdlines", 0444, d_tracer,
+			NULL, &tracing_saved_cmdlines_fops);
 
 #ifdef CONFIG_DYNAMIC_FTRACE
-	entry = debugfs_create_file("dyn_ftrace_total_info", 0444, d_tracer,
-				    &ftrace_update_tot_cnt,
-				    &tracing_dyn_info_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs "
-			   "'dyn_ftrace_total_info' entry\n");
+	trace_create_file("dyn_ftrace_total_info", 0444, d_tracer,
+			&ftrace_update_tot_cnt, &tracing_dyn_info_fops);
 #endif
 #ifdef CONFIG_SYSPROF_TRACER
 	init_tracer_sysprof_debugfs(d_tracer);
 #endif
 
+	create_trace_options_dir();
+
 	for_each_tracing_cpu(cpu)
 		tracing_init_debugfs_percpu(cpu);
 
@@ -4064,7 +4184,8 @@ trace_printk_seq(struct trace_seq *s)
 
 static void __ftrace_dump(bool disable_tracing)
 {
-	static DEFINE_SPINLOCK(ftrace_dump_lock);
+	static raw_spinlock_t ftrace_dump_lock =
+		(raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
 	/* use static because iter can be a bit big for the stack */
 	static struct trace_iterator iter;
 	unsigned int old_userobj;
@@ -4073,7 +4194,8 @@ static void __ftrace_dump(bool disable_tracing)
 	int cnt = 0, cpu;
 
 	/* only one dump */
-	spin_lock_irqsave(&ftrace_dump_lock, flags);
+	local_irq_save(flags);
+	__raw_spin_lock(&ftrace_dump_lock);
 	if (dump_ran)
 		goto out;
 
@@ -4145,7 +4267,8 @@ static void __ftrace_dump(bool disable_tracing)
 	}
 
  out:
-	spin_unlock_irqrestore(&ftrace_dump_lock, flags);
+	__raw_spin_unlock(&ftrace_dump_lock);
+	local_irq_restore(flags);
 }
 
 /* By default: disable tracing after the dump */
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index e685ac2..6e735d4 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -9,9 +9,12 @@
 #include <linux/mmiotrace.h>
 #include <linux/ftrace.h>
 #include <trace/boot.h>
-#include <trace/kmemtrace.h>
+#include <linux/kmemtrace.h>
 #include <trace/power.h>
 
+#include <linux/trace_seq.h>
+#include <linux/ftrace_event.h>
+
 enum trace_type {
 	__TRACE_FIRST_TYPE = 0,
 
@@ -42,20 +45,6 @@ enum trace_type {
 };
 
 /*
- * The trace entry - the most basic unit of tracing. This is what
- * is printed in the end as a single line in the trace output, such as:
- *
- *     bash-15816 [01]   235.197585: idle_cpu <- irq_enter
- */
-struct trace_entry {
-	unsigned char		type;
-	unsigned char		flags;
-	unsigned char		preempt_count;
-	int			pid;
-	int			tgid;
-};
-
-/*
  * Function trace entry - function address and parent function addres:
  */
 struct ftrace_entry {
@@ -263,8 +252,6 @@ struct trace_array_cpu {
 	char			comm[TASK_COMM_LEN];
 };
 
-struct trace_iterator;
-
 /*
  * The trace array - an array of per-CPU trace arrays. This is the
  * highest level data structure that individual tracers deal with.
@@ -339,15 +326,6 @@ extern void __ftrace_bad_type(void);
 		__ftrace_bad_type();					\
 	} while (0)
 
-/* Return values for print_line callback */
-enum print_line_t {
-	TRACE_TYPE_PARTIAL_LINE	= 0,	/* Retry after flushing the seq */
-	TRACE_TYPE_HANDLED	= 1,
-	TRACE_TYPE_UNHANDLED	= 2,	/* Relay to other output functions */
-	TRACE_TYPE_NO_CONSUME	= 3	/* Handled but ask to not consume */
-};
-
-
 /*
  * An option specific to a tracer. This is a boolean value.
  * The bit is the bit index that sets its value on the
@@ -423,60 +401,30 @@ struct tracer {
 	struct tracer_stat	*stats;
 };
 
-struct trace_seq {
-	unsigned char		buffer[PAGE_SIZE];
-	unsigned int		len;
-	unsigned int		readpos;
-};
-
-static inline void
-trace_seq_init(struct trace_seq *s)
-{
-	s->len = 0;
-	s->readpos = 0;
-}
-
 
 #define TRACE_PIPE_ALL_CPU	-1
 
-/*
- * Trace iterator - used by printout routines who present trace
- * results to users and which routines might sleep, etc:
- */
-struct trace_iterator {
-	struct trace_array	*tr;
-	struct tracer		*trace;
-	void			*private;
-	int			cpu_file;
-	struct mutex		mutex;
-	struct ring_buffer_iter	*buffer_iter[NR_CPUS];
-
-	/* The below is zeroed out in pipe_read */
-	struct trace_seq	seq;
-	struct trace_entry	*ent;
-	int			cpu;
-	u64			ts;
-
-	unsigned long		iter_flags;
-	loff_t			pos;
-	long			idx;
-
-	cpumask_var_t		started;
-};
-
 int tracer_init(struct tracer *t, struct trace_array *tr);
 int tracing_is_enabled(void);
 void trace_wake_up(void);
 void tracing_reset(struct trace_array *tr, int cpu);
 void tracing_reset_online_cpus(struct trace_array *tr);
+void tracing_reset_current(int cpu);
+void tracing_reset_current_online_cpus(void);
 int tracing_open_generic(struct inode *inode, struct file *filp);
+struct dentry *trace_create_file(const char *name,
+				 mode_t mode,
+				 struct dentry *parent,
+				 void *data,
+				 const struct file_operations *fops);
+
 struct dentry *tracing_init_dentry(void);
 void init_tracer_sysprof_debugfs(struct dentry *d_tracer);
 
 struct ring_buffer_event;
 
 struct ring_buffer_event *trace_buffer_lock_reserve(struct trace_array *tr,
-						    unsigned char type,
+						    int type,
 						    unsigned long len,
 						    unsigned long flags,
 						    int pc);
@@ -484,14 +432,6 @@ void trace_buffer_unlock_commit(struct trace_array *tr,
 				struct ring_buffer_event *event,
 				unsigned long flags, int pc);
 
-struct ring_buffer_event *
-trace_current_buffer_lock_reserve(unsigned char type, unsigned long len,
-				  unsigned long flags, int pc);
-void trace_current_buffer_unlock_commit(struct ring_buffer_event *event,
-					unsigned long flags, int pc);
-void trace_nowake_buffer_unlock_commit(struct ring_buffer_event *event,
-					unsigned long flags, int pc);
-
 struct trace_entry *tracing_get_trace_entry(struct trace_array *tr,
 						struct trace_array_cpu *data);
 
@@ -514,7 +454,6 @@ void tracing_sched_switch_trace(struct trace_array *tr,
 				struct task_struct *prev,
 				struct task_struct *next,
 				unsigned long flags, int pc);
-void tracing_record_cmdline(struct task_struct *tsk);
 
 void tracing_sched_wakeup_trace(struct trace_array *tr,
 				struct task_struct *wakee,
@@ -599,6 +538,8 @@ extern int trace_selftest_startup_sysprof(struct tracer *trace,
 					       struct trace_array *tr);
 extern int trace_selftest_startup_branch(struct tracer *trace,
 					 struct trace_array *tr);
+extern int trace_selftest_startup_hw_branches(struct tracer *trace,
+					      struct trace_array *tr);
 #endif /* CONFIG_FTRACE_STARTUP_TEST */
 
 extern void *head_page(struct trace_array_cpu *data);
@@ -613,6 +554,8 @@ extern unsigned long trace_flags;
 /* Standard output formatting function used for function return traces */
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 extern enum print_line_t print_graph_function(struct trace_iterator *iter);
+extern enum print_line_t
+trace_print_graph_duration(unsigned long long duration, struct trace_seq *s);
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 /* TODO: make this variable */
@@ -644,7 +587,6 @@ static inline int ftrace_graph_addr(unsigned long addr)
 	return 1;
 }
 #endif /* CONFIG_DYNAMIC_FTRACE */
-
 #else /* CONFIG_FUNCTION_GRAPH_TRACER */
 static inline enum print_line_t
 print_graph_function(struct trace_iterator *iter)
@@ -692,6 +634,7 @@ enum trace_iterator_flags {
 	TRACE_ITER_LATENCY_FMT		= 0x40000,
 	TRACE_ITER_GLOBAL_CLK		= 0x80000,
 	TRACE_ITER_SLEEP_TIME		= 0x100000,
+	TRACE_ITER_GRAPH_TIME		= 0x200000,
 };
 
 /*
@@ -790,103 +733,113 @@ struct ftrace_event_field {
 	char			*type;
 	int			offset;
 	int			size;
+	int			is_signed;
 };
 
-struct ftrace_event_call {
-	char			*name;
-	char			*system;
-	struct dentry		*dir;
-	int			enabled;
-	int			(*regfunc)(void);
-	void			(*unregfunc)(void);
-	int			id;
-	int			(*raw_init)(void);
-	int			(*show_format)(struct trace_seq *s);
-	int			(*define_fields)(void);
-	struct list_head	fields;
+struct event_filter {
+	int			n_preds;
 	struct filter_pred	**preds;
-
-#ifdef CONFIG_EVENT_PROFILE
-	atomic_t	profile_count;
-	int		(*profile_enable)(struct ftrace_event_call *);
-	void		(*profile_disable)(struct ftrace_event_call *);
-#endif
+	char			*filter_string;
 };
 
 struct event_subsystem {
 	struct list_head	list;
 	const char		*name;
 	struct dentry		*entry;
-	struct filter_pred	**preds;
+	void			*filter;
 };
 
-#define events_for_each(event)						\
-	for (event = __start_ftrace_events;				\
-	     (unsigned long)event < (unsigned long)__stop_ftrace_events; \
-	     event++)
-
-#define MAX_FILTER_PRED 8
-
 struct filter_pred;
 
-typedef int (*filter_pred_fn_t) (struct filter_pred *pred, void *event);
+typedef int (*filter_pred_fn_t) (struct filter_pred *pred, void *event,
+				 int val1, int val2);
 
 struct filter_pred {
 	filter_pred_fn_t fn;
 	u64 val;
-	char *str_val;
+	char str_val[MAX_FILTER_STR_VAL];
 	int str_len;
 	char *field_name;
 	int offset;
 	int not;
-	int or;
-	int compound;
-	int clear;
+	int op;
+	int pop_n;
 };
 
-int trace_define_field(struct ftrace_event_call *call, char *type,
-		       char *name, int offset, int size);
-extern void filter_free_pred(struct filter_pred *pred);
-extern void filter_print_preds(struct filter_pred **preds,
+extern void print_event_filter(struct ftrace_event_call *call,
 			       struct trace_seq *s);
-extern int filter_parse(char **pbuf, struct filter_pred *pred);
-extern int filter_add_pred(struct ftrace_event_call *call,
-			   struct filter_pred *pred);
-extern void filter_free_preds(struct ftrace_event_call *call);
-extern int filter_match_preds(struct ftrace_event_call *call, void *rec);
-extern void filter_free_subsystem_preds(struct event_subsystem *system);
-extern int filter_add_subsystem_pred(struct event_subsystem *system,
-				     struct filter_pred *pred);
-
-void event_trace_printk(unsigned long ip, const char *fmt, ...);
-extern struct ftrace_event_call __start_ftrace_events[];
-extern struct ftrace_event_call __stop_ftrace_events[];
-
-#define for_each_event(event)						\
-	for (event = __start_ftrace_events;				\
-	     (unsigned long)event < (unsigned long)__stop_ftrace_events; \
-	     event++)
+extern int apply_event_filter(struct ftrace_event_call *call,
+			      char *filter_string);
+extern int apply_subsystem_event_filter(struct event_subsystem *system,
+					char *filter_string);
+extern void print_subsystem_event_filter(struct event_subsystem *system,
+					 struct trace_seq *s);
+
+static inline int
+filter_check_discard(struct ftrace_event_call *call, void *rec,
+		     struct ring_buffer *buffer,
+		     struct ring_buffer_event *event)
+{
+	if (unlikely(call->filter_active) && !filter_match_preds(call, rec)) {
+		ring_buffer_discard_commit(buffer, event);
+		return 1;
+	}
+
+	return 0;
+}
+
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
+extern struct mutex event_mutex;
+extern struct list_head ftrace_events;
 
 extern const char *__start___trace_bprintk_fmt[];
 extern const char *__stop___trace_bprintk_fmt[];
 
-/*
- * The double __builtin_constant_p is because gcc will give us an error
- * if we try to allocate the static variable to fmt if it is not a
- * constant. Even with the outer if statement optimizing out.
- */
-#define event_trace_printk(ip, fmt, args...)				\
-do {									\
-	__trace_printk_check_format(fmt, ##args);			\
-	tracing_record_cmdline(current);				\
-	if (__builtin_constant_p(fmt)) {				\
-		static const char *trace_printk_fmt			\
-		  __attribute__((section("__trace_printk_fmt"))) =	\
-			__builtin_constant_p(fmt) ? fmt : NULL;		\
-									\
-		__trace_bprintk(ip, trace_printk_fmt, ##args);		\
-	} else								\
-		__trace_printk(ip, fmt, ##args);			\
-} while (0)
+#undef TRACE_EVENT_FORMAT
+#define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
+	extern struct ftrace_event_call event_##call;
+#undef TRACE_EVENT_FORMAT_NOFILTER
+#define TRACE_EVENT_FORMAT_NOFILTER(call, proto, args, fmt, tstruct, tpfmt)
+#include "trace_event_types.h"
 
 #endif /* _LINUX_KERNEL_TRACE_H */
diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
index 7a30fc4..a29ef23 100644
--- a/kernel/trace/trace_boot.c
+++ b/kernel/trace/trace_boot.c
@@ -9,6 +9,7 @@
 #include <linux/debugfs.h>
 #include <linux/ftrace.h>
 #include <linux/kallsyms.h>
+#include <linux/time.h>
 
 #include "trace.h"
 #include "trace_output.h"
@@ -67,7 +68,7 @@ initcall_call_print_line(struct trace_iterator *iter)
 	trace_assign_type(field, entry);
 	call = &field->boot_call;
 	ts = iter->ts;
-	nsec_rem = do_div(ts, 1000000000);
+	nsec_rem = do_div(ts, NSEC_PER_SEC);
 
 	ret = trace_seq_printf(s, "[%5ld.%09ld] calling  %s @ %i\n",
 			(unsigned long)ts, nsec_rem, call->func, call->caller);
@@ -92,7 +93,7 @@ initcall_ret_print_line(struct trace_iterator *iter)
 	trace_assign_type(field, entry);
 	init_ret = &field->boot_ret;
 	ts = iter->ts;
-	nsec_rem = do_div(ts, 1000000000);
+	nsec_rem = do_div(ts, NSEC_PER_SEC);
 
 	ret = trace_seq_printf(s, "[%5ld.%09ld] initcall %s "
 			"returned %d after %llu msecs\n",
diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index 8333715..7a7a9fd 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -30,6 +30,7 @@ static struct trace_array *branch_tracer;
 static void
 probe_likely_condition(struct ftrace_branch_data *f, int val, int expect)
 {
+	struct ftrace_event_call *call = &event_branch;
 	struct trace_array *tr = branch_tracer;
 	struct ring_buffer_event *event;
 	struct trace_branch *entry;
@@ -73,7 +74,8 @@ probe_likely_condition(struct ftrace_branch_data *f, int val, int expect)
 	entry->line = f->line;
 	entry->correct = val == expect;
 
-	ring_buffer_unlock_commit(tr->buffer, event);
+	if (!filter_check_discard(call, entry, tr->buffer, event))
+		ring_buffer_unlock_commit(tr->buffer, event);
 
  out:
 	atomic_dec(&tr->data[cpu]->disabled);
@@ -271,7 +273,7 @@ static int branch_stat_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static void *annotated_branch_stat_start(void)
+static void *annotated_branch_stat_start(struct tracer_stat *trace)
 {
 	return __start_annotated_branch_profile;
 }
@@ -346,7 +348,7 @@ static int all_branch_stat_headers(struct seq_file *m)
 	return 0;
 }
 
-static void *all_branch_stat_start(void)
+static void *all_branch_stat_start(struct tracer_stat *trace)
 {
 	return __start_branch_profile;
 }
diff --git a/kernel/trace/trace_event_profile.c b/kernel/trace/trace_event_profile.c
index 22cba99..5b5895a 100644
--- a/kernel/trace/trace_event_profile.c
+++ b/kernel/trace/trace_event_profile.c
@@ -10,22 +10,30 @@
 int ftrace_profile_enable(int event_id)
 {
 	struct ftrace_event_call *event;
+	int ret = -EINVAL;
 
-	for_each_event(event) {
-		if (event->id == event_id)
-			return event->profile_enable(event);
+	mutex_lock(&event_mutex);
+	list_for_each_entry(event, &ftrace_events, list) {
+		if (event->id == event_id) {
+			ret = event->profile_enable(event);
+			break;
+		}
 	}
+	mutex_unlock(&event_mutex);
 
-	return -EINVAL;
+	return ret;
 }
 
 void ftrace_profile_disable(int event_id)
 {
 	struct ftrace_event_call *event;
 
-	for_each_event(event) {
-		if (event->id == event_id)
-			return event->profile_disable(event);
+	mutex_lock(&event_mutex);
+	list_for_each_entry(event, &ftrace_events, list) {
+		if (event->id == event_id) {
+			event->profile_disable(event);
+			break;
+		}
 	}
+	mutex_unlock(&event_mutex);
 }
-
diff --git a/kernel/trace/trace_event_types.h b/kernel/trace/trace_event_types.h
index fd78bee..5e32e37 100644
--- a/kernel/trace/trace_event_types.h
+++ b/kernel/trace/trace_event_types.h
@@ -57,7 +57,7 @@ TRACE_EVENT_FORMAT(context_switch, TRACE_CTX, ctx_switch_entry, ignore,
 	TP_RAW_FMT("%u:%u:%u  ==+ %u:%u:%u [%03u]")
 );
 
-TRACE_EVENT_FORMAT(special, TRACE_SPECIAL, special_entry, ignore,
+TRACE_EVENT_FORMAT_NOFILTER(special, TRACE_SPECIAL, special_entry, ignore,
 	TRACE_STRUCT(
 		TRACE_FIELD(unsigned long, arg1, arg1)
 		TRACE_FIELD(unsigned long, arg2, arg2)
@@ -122,8 +122,10 @@ TRACE_EVENT_FORMAT(print, TRACE_PRINT, print_entry, ignore,
 TRACE_EVENT_FORMAT(branch, TRACE_BRANCH, trace_branch, ignore,
 	TRACE_STRUCT(
 		TRACE_FIELD(unsigned int, line, line)
-		TRACE_FIELD_SPECIAL(char func[TRACE_FUNC_SIZE+1], func, func)
-		TRACE_FIELD_SPECIAL(char file[TRACE_FUNC_SIZE+1], file, file)
+		TRACE_FIELD_SPECIAL(char func[TRACE_FUNC_SIZE+1], func,
+				    TRACE_FUNC_SIZE+1, func)
+		TRACE_FIELD_SPECIAL(char file[TRACE_FUNC_SIZE+1], file,
+				    TRACE_FUNC_SIZE+1, file)
 		TRACE_FIELD(char, correct, correct)
 	),
 	TP_RAW_FMT("%u:%s:%s (%u)")
@@ -139,8 +141,8 @@ TRACE_EVENT_FORMAT(hw_branch, TRACE_HW_BRANCHES, hw_branch_entry, ignore,
 
 TRACE_EVENT_FORMAT(power, TRACE_POWER, trace_power, ignore,
 	TRACE_STRUCT(
-		TRACE_FIELD(ktime_t, state_data.stamp, stamp)
-		TRACE_FIELD(ktime_t, state_data.end, end)
+		TRACE_FIELD_SIGN(ktime_t, state_data.stamp, stamp, 1)
+		TRACE_FIELD_SIGN(ktime_t, state_data.end, end, 1)
 		TRACE_FIELD(int, state_data.type, type)
 		TRACE_FIELD(int, state_data.state, state)
 	),
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 576f4fa..aa08be6 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -8,19 +8,25 @@
  *
  */
 
+#include <linux/workqueue.h>
+#include <linux/spinlock.h>
+#include <linux/kthread.h>
 #include <linux/debugfs.h>
 #include <linux/uaccess.h>
 #include <linux/module.h>
 #include <linux/ctype.h>
+#include <linux/delay.h>
 
 #include "trace_output.h"
 
 #define TRACE_SYSTEM "TRACE_SYSTEM"
 
-static DEFINE_MUTEX(event_mutex);
+DEFINE_MUTEX(event_mutex);
+
+LIST_HEAD(ftrace_events);
 
 int trace_define_field(struct ftrace_event_call *call, char *type,
-		       char *name, int offset, int size)
+		       char *name, int offset, int size, int is_signed)
 {
 	struct ftrace_event_field *field;
 
@@ -38,6 +44,7 @@ int trace_define_field(struct ftrace_event_call *call, char *type,
 
 	field->offset = offset;
 	field->size = size;
+	field->is_signed = is_signed;
 	list_add(&field->link, &call->fields);
 
 	return 0;
@@ -51,47 +58,94 @@ err:
 
 	return -ENOMEM;
 }
+EXPORT_SYMBOL_GPL(trace_define_field);
 
-static void ftrace_clear_events(void)
-{
-	struct ftrace_event_call *call = (void *)__start_ftrace_events;
-
+#ifdef CONFIG_MODULES
 
-	while ((unsigned long)call < (unsigned long)__stop_ftrace_events) {
+static void trace_destroy_fields(struct ftrace_event_call *call)
+{
+	struct ftrace_event_field *field, *next;
 
-		if (call->enabled) {
-			call->enabled = 0;
-			call->unregfunc();
-		}
-		call++;
+	list_for_each_entry_safe(field, next, &call->fields, link) {
+		list_del(&field->link);
+		kfree(field->type);
+		kfree(field->name);
+		kfree(field);
 	}
 }
 
+#endif /* CONFIG_MODULES */
+
 static void ftrace_event_enable_disable(struct ftrace_event_call *call,
 					int enable)
 {
-
 	switch (enable) {
 	case 0:
 		if (call->enabled) {
 			call->enabled = 0;
+			tracing_stop_cmdline_record();
 			call->unregfunc();
 		}
 		break;
 	case 1:
 		if (!call->enabled) {
 			call->enabled = 1;
+			tracing_start_cmdline_record();
 			call->regfunc();
 		}
 		break;
 	}
 }
 
+static void ftrace_clear_events(void)
+{
+	struct ftrace_event_call *call;
+
+	mutex_lock(&event_mutex);
+	list_for_each_entry(call, &ftrace_events, list) {
+		ftrace_event_enable_disable(call, 0);
+	}
+	mutex_unlock(&event_mutex);
+}
+
+/*
+ * __ftrace_set_clr_event(NULL, NULL, NULL, set) will set/unset all events.
+ */
+static int __ftrace_set_clr_event(const char *match, const char *sub,
+				  const char *event, int set)
+{
+	struct ftrace_event_call *call;
+	int ret = -EINVAL;
+
+	mutex_lock(&event_mutex);
+	list_for_each_entry(call, &ftrace_events, list) {
+
+		if (!call->name || !call->regfunc)
+			continue;
+
+		if (match &&
+		    strcmp(match, call->name) != 0 &&
+		    strcmp(match, call->system) != 0)
+			continue;
+
+		if (sub && strcmp(sub, call->system) != 0)
+			continue;
+
+		if (event && strcmp(event, call->name) != 0)
+			continue;
+
+		ftrace_event_enable_disable(call, set);
+
+		ret = 0;
+	}
+	mutex_unlock(&event_mutex);
+
+	return ret;
+}
+
 static int ftrace_set_clr_event(char *buf, int set)
 {
-	struct ftrace_event_call *call = __start_ftrace_events;
 	char *event = NULL, *sub = NULL, *match;
-	int ret = -EINVAL;
 
 	/*
 	 * The buf format can be <subsystem>:<event-name>
@@ -117,30 +171,24 @@ static int ftrace_set_clr_event(char *buf, int set)
 			event = NULL;
 	}
 
-	mutex_lock(&event_mutex);
-	for_each_event(call) {
-
-		if (!call->name || !call->regfunc)
-			continue;
-
-		if (match &&
-		    strcmp(match, call->name) != 0 &&
-		    strcmp(match, call->system) != 0)
-			continue;
-
-		if (sub && strcmp(sub, call->system) != 0)
-			continue;
-
-		if (event && strcmp(event, call->name) != 0)
-			continue;
-
-		ftrace_event_enable_disable(call, set);
-
-		ret = 0;
-	}
-	mutex_unlock(&event_mutex);
+	return __ftrace_set_clr_event(match, sub, event, set);
+}
 
-	return ret;
+/**
+ * trace_set_clr_event - enable or disable an event
+ * @system: system name to match (NULL for any system)
+ * @event: event name to match (NULL for all events, within system)
+ * @set: 1 to enable, 0 to disable
+ *
+ * This is a way for other parts of the kernel to enable or disable
+ * event recording.
+ *
+ * Returns 0 on success, -EINVAL if the parameters do not match any
+ * registered events.
+ */
+int trace_set_clr_event(const char *system, const char *event, int set)
+{
+	return __ftrace_set_clr_event(NULL, system, event, set);
 }
 
 /* 128 should be much more than enough */
@@ -224,15 +272,17 @@ ftrace_event_write(struct file *file, const char __user *ubuf,
 static void *
 t_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	struct ftrace_event_call *call = m->private;
-	struct ftrace_event_call *next = call;
+	struct list_head *list = m->private;
+	struct ftrace_event_call *call;
 
 	(*pos)++;
 
 	for (;;) {
-		if ((unsigned long)call >= (unsigned long)__stop_ftrace_events)
+		if (list == &ftrace_events)
 			return NULL;
 
+		call = list_entry(list, struct ftrace_event_call, list);
+
 		/*
 		 * The ftrace subsystem is for showing formats only.
 		 * They can not be enabled or disabled via the event files.
@@ -240,45 +290,51 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 		if (call->regfunc)
 			break;
 
-		call++;
-		next = call;
+		list = list->next;
 	}
 
-	m->private = ++next;
+	m->private = list->next;
 
 	return call;
 }
 
 static void *t_start(struct seq_file *m, loff_t *pos)
 {
+	mutex_lock(&event_mutex);
+	if (*pos == 0)
+		m->private = ftrace_events.next;
 	return t_next(m, NULL, pos);
 }
 
 static void *
 s_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	struct ftrace_event_call *call = m->private;
-	struct ftrace_event_call *next;
+	struct list_head *list = m->private;
+	struct ftrace_event_call *call;
 
 	(*pos)++;
 
  retry:
-	if ((unsigned long)call >= (unsigned long)__stop_ftrace_events)
+	if (list == &ftrace_events)
 		return NULL;
 
+	call = list_entry(list, struct ftrace_event_call, list);
+
 	if (!call->enabled) {
-		call++;
+		list = list->next;
 		goto retry;
 	}
 
-	next = call;
-	m->private = ++next;
+	m->private = list->next;
 
 	return call;
 }
 
 static void *s_start(struct seq_file *m, loff_t *pos)
 {
+	mutex_lock(&event_mutex);
+	if (*pos == 0)
+		m->private = ftrace_events.next;
 	return s_next(m, NULL, pos);
 }
 
@@ -295,12 +351,12 @@ static int t_show(struct seq_file *m, void *v)
 
 static void t_stop(struct seq_file *m, void *p)
 {
+	mutex_unlock(&event_mutex);
 }
 
 static int
 ftrace_event_seq_open(struct inode *inode, struct file *file)
 {
-	int ret;
 	const struct seq_operations *seq_ops;
 
 	if ((file->f_mode & FMODE_WRITE) &&
@@ -308,13 +364,7 @@ ftrace_event_seq_open(struct inode *inode, struct file *file)
 		ftrace_clear_events();
 
 	seq_ops = inode->i_private;
-	ret = seq_open(file, seq_ops);
-	if (!ret) {
-		struct seq_file *m = file->private_data;
-
-		m->private = __start_ftrace_events;
-	}
-	return ret;
+	return seq_open(file, seq_ops);
 }
 
 static ssize_t
@@ -374,8 +424,93 @@ event_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	return cnt;
 }
 
+static ssize_t
+system_enable_read(struct file *filp, char __user *ubuf, size_t cnt,
+		   loff_t *ppos)
+{
+	const char set_to_char[4] = { '?', '0', '1', 'X' };
+	const char *system = filp->private_data;
+	struct ftrace_event_call *call;
+	char buf[2];
+	int set = 0;
+	int ret;
+
+	mutex_lock(&event_mutex);
+	list_for_each_entry(call, &ftrace_events, list) {
+		if (!call->name || !call->regfunc)
+			continue;
+
+		if (system && strcmp(call->system, system) != 0)
+			continue;
+
+		/*
+		 * We need to find out if all the events are set
+		 * or if all events or cleared, or if we have
+		 * a mixture.
+		 */
+		set |= (1 << !!call->enabled);
+
+		/*
+		 * If we have a mixture, no need to look further.
+		 */
+		if (set == 3)
+			break;
+	}
+	mutex_unlock(&event_mutex);
+
+	buf[0] = set_to_char[set];
+	buf[1] = '\n';
+
+	ret = simple_read_from_buffer(ubuf, cnt, ppos, buf, 2);
+
+	return ret;
+}
+
+static ssize_t
+system_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
+		    loff_t *ppos)
+{
+	const char *system = filp->private_data;
+	unsigned long val;
+	char buf[64];
+	ssize_t ret;
+
+	if (cnt >= sizeof(buf))
+		return -EINVAL;
+
+	if (copy_from_user(&buf, ubuf, cnt))
+		return -EFAULT;
+
+	buf[cnt] = 0;
+
+	ret = strict_strtoul(buf, 10, &val);
+	if (ret < 0)
+		return ret;
+
+	ret = tracing_update_buffers();
+	if (ret < 0)
+		return ret;
+
+	if (val != 0 && val != 1)
+		return -EINVAL;
+
+	ret = __ftrace_set_clr_event(NULL, system, NULL, val);
+	if (ret)
+		goto out;
+
+	ret = cnt;
+
+out:
+	*ppos += cnt;
+
+	return ret;
+}
+
+extern char *__bad_type_size(void);
+
 #undef FIELD
 #define FIELD(type, name)						\
+	sizeof(type) != sizeof(field.name) ? __bad_type_size() :	\
 	#type, "common_" #name, offsetof(typeof(field), name),		\
 		sizeof(field.name)
 
@@ -391,7 +526,7 @@ static int trace_write_header(struct trace_seq *s)
 				"\tfield:%s %s;\toffset:%zu;\tsize:%zu;\n"
 				"\tfield:%s %s;\toffset:%zu;\tsize:%zu;\n"
 				"\n",
-				FIELD(unsigned char, type),
+				FIELD(unsigned short, type),
 				FIELD(unsigned char, flags),
 				FIELD(unsigned char, preempt_count),
 				FIELD(int, pid),
@@ -481,7 +616,7 @@ event_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
 
 	trace_seq_init(s);
 
-	filter_print_preds(call->preds, s);
+	print_event_filter(call, s);
 	r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->len);
 
 	kfree(s);
@@ -494,38 +629,26 @@ event_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
 		   loff_t *ppos)
 {
 	struct ftrace_event_call *call = filp->private_data;
-	char buf[64], *pbuf = buf;
-	struct filter_pred *pred;
+	char *buf;
 	int err;
 
-	if (cnt >= sizeof(buf))
+	if (cnt >= PAGE_SIZE)
 		return -EINVAL;
 
-	if (copy_from_user(&buf, ubuf, cnt))
-		return -EFAULT;
-	buf[cnt] = '\0';
-
-	pred = kzalloc(sizeof(*pred), GFP_KERNEL);
-	if (!pred)
+	buf = (char *)__get_free_page(GFP_TEMPORARY);
+	if (!buf)
 		return -ENOMEM;
 
-	err = filter_parse(&pbuf, pred);
-	if (err < 0) {
-		filter_free_pred(pred);
-		return err;
-	}
-
-	if (pred->clear) {
-		filter_free_preds(call);
-		filter_free_pred(pred);
-		return cnt;
+	if (copy_from_user(buf, ubuf, cnt)) {
+		free_page((unsigned long) buf);
+		return -EFAULT;
 	}
+	buf[cnt] = '\0';
 
-	err = filter_add_pred(call, pred);
-	if (err < 0) {
-		filter_free_pred(pred);
+	err = apply_event_filter(call, buf);
+	free_page((unsigned long) buf);
+	if (err < 0)
 		return err;
-	}
 
 	*ppos += cnt;
 
@@ -549,7 +672,7 @@ subsystem_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
 
 	trace_seq_init(s);
 
-	filter_print_preds(system->preds, s);
+	print_subsystem_event_filter(system, s);
 	r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->len);
 
 	kfree(s);
@@ -562,45 +685,56 @@ subsystem_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
 		       loff_t *ppos)
 {
 	struct event_subsystem *system = filp->private_data;
-	char buf[64], *pbuf = buf;
-	struct filter_pred *pred;
+	char *buf;
 	int err;
 
-	if (cnt >= sizeof(buf))
+	if (cnt >= PAGE_SIZE)
 		return -EINVAL;
 
-	if (copy_from_user(&buf, ubuf, cnt))
-		return -EFAULT;
-	buf[cnt] = '\0';
-
-	pred = kzalloc(sizeof(*pred), GFP_KERNEL);
-	if (!pred)
+	buf = (char *)__get_free_page(GFP_TEMPORARY);
+	if (!buf)
 		return -ENOMEM;
 
-	err = filter_parse(&pbuf, pred);
-	if (err < 0) {
-		filter_free_pred(pred);
-		return err;
-	}
-
-	if (pred->clear) {
-		filter_free_subsystem_preds(system);
-		filter_free_pred(pred);
-		return cnt;
+	if (copy_from_user(buf, ubuf, cnt)) {
+		free_page((unsigned long) buf);
+		return -EFAULT;
 	}
+	buf[cnt] = '\0';
 
-	err = filter_add_subsystem_pred(system, pred);
-	if (err < 0) {
-		filter_free_subsystem_preds(system);
-		filter_free_pred(pred);
+	err = apply_subsystem_event_filter(system, buf);
+	free_page((unsigned long) buf);
+	if (err < 0)
 		return err;
-	}
 
 	*ppos += cnt;
 
 	return cnt;
 }
 
+static ssize_t
+show_header(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
+{
+	int (*func)(struct trace_seq *s) = filp->private_data;
+	struct trace_seq *s;
+	int r;
+
+	if (*ppos)
+		return 0;
+
+	s = kmalloc(sizeof(*s), GFP_KERNEL);
+	if (!s)
+		return -ENOMEM;
+
+	trace_seq_init(s);
+
+	func(s);
+	r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->len);
+
+	kfree(s);
+
+	return r;
+}
+
 static const struct seq_operations show_event_seq_ops = {
 	.start = t_start,
 	.next = t_next,
@@ -658,6 +792,17 @@ static const struct file_operations ftrace_subsystem_filter_fops = {
 	.write = subsystem_filter_write,
 };
 
+static const struct file_operations ftrace_system_enable_fops = {
+	.open = tracing_open_generic,
+	.read = system_enable_read,
+	.write = system_enable_write,
+};
+
+static const struct file_operations ftrace_show_header_fops = {
+	.open = tracing_open_generic,
+	.read = show_header,
+};
+
 static struct dentry *event_trace_events_dir(void)
 {
 	static struct dentry *d_tracer;
@@ -684,6 +829,7 @@ static struct dentry *
 event_subsystem_dir(const char *name, struct dentry *d_events)
 {
 	struct event_subsystem *system;
+	struct dentry *entry;
 
 	/* First see if we did not already create this dir */
 	list_for_each_entry(system, &event_subsystems, list) {
@@ -707,16 +853,46 @@ event_subsystem_dir(const char *name, struct dentry *d_events)
 		return d_events;
 	}
 
-	system->name = name;
+	system->name = kstrdup(name, GFP_KERNEL);
+	if (!system->name) {
+		debugfs_remove(system->entry);
+		kfree(system);
+		return d_events;
+	}
+
 	list_add(&system->list, &event_subsystems);
 
-	system->preds = NULL;
+	system->filter = NULL;
+
+	system->filter = kzalloc(sizeof(struct event_filter), GFP_KERNEL);
+	if (!system->filter) {
+		pr_warning("Could not allocate filter for subsystem "
+			   "'%s'\n", name);
+		return system->entry;
+	}
+
+	entry = debugfs_create_file("filter", 0644, system->entry, system,
+				    &ftrace_subsystem_filter_fops);
+	if (!entry) {
+		kfree(system->filter);
+		system->filter = NULL;
+		pr_warning("Could not create debugfs "
+			   "'%s/filter' entry\n", name);
+	}
+
+	entry = trace_create_file("enable", 0644, system->entry,
+				  (void *)system->name,
+				  &ftrace_system_enable_fops);
 
 	return system->entry;
 }
 
 static int
-event_create_dir(struct ftrace_event_call *call, struct dentry *d_events)
+event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
+		 const struct file_operations *id,
+		 const struct file_operations *enable,
+		 const struct file_operations *filter,
+		 const struct file_operations *format)
 {
 	struct dentry *entry;
 	int ret;
@@ -725,7 +901,7 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events)
 	 * If the trace point header did not define TRACE_SYSTEM
 	 * then the system would be called "TRACE_SYSTEM".
 	 */
-	if (strcmp(call->system, "TRACE_SYSTEM") != 0)
+	if (strcmp(call->system, TRACE_SYSTEM) != 0)
 		d_events = event_subsystem_dir(call->system, d_events);
 
 	if (call->raw_init) {
@@ -744,21 +920,13 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events)
 		return -1;
 	}
 
-	if (call->regfunc) {
-		entry = debugfs_create_file("enable", 0644, call->dir, call,
-					    &ftrace_enable_fops);
-		if (!entry)
-			pr_warning("Could not create debugfs "
-				   "'%s/enable' entry\n", call->name);
-	}
+	if (call->regfunc)
+		entry = trace_create_file("enable", 0644, call->dir, call,
+					  enable);
 
-	if (call->id) {
-		entry = debugfs_create_file("id", 0444, call->dir, call,
-				&ftrace_event_id_fops);
-		if (!entry)
-			pr_warning("Could not create debugfs '%s/id' entry\n",
-					call->name);
-	}
+	if (call->id)
+		entry = trace_create_file("id", 0444, call->dir, call,
+					  id);
 
 	if (call->define_fields) {
 		ret = call->define_fields();
@@ -767,32 +935,195 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events)
 				   " events/%s\n", call->name);
 			return ret;
 		}
-		entry = debugfs_create_file("filter", 0644, call->dir, call,
-					    &ftrace_event_filter_fops);
-		if (!entry)
-			pr_warning("Could not create debugfs "
-				   "'%s/filter' entry\n", call->name);
+		entry = trace_create_file("filter", 0644, call->dir, call,
+					  filter);
 	}
 
 	/* A trace may not want to export its format */
 	if (!call->show_format)
 		return 0;
 
-	entry = debugfs_create_file("format", 0444, call->dir, call,
-				    &ftrace_event_format_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs "
-			   "'%s/format' entry\n", call->name);
+	entry = trace_create_file("format", 0444, call->dir, call,
+				  format);
+
+	return 0;
+}
+
+#define for_each_event(event, start, end)			\
+	for (event = start;					\
+	     (unsigned long)event < (unsigned long)end;		\
+	     event++)
+
+#ifdef CONFIG_MODULES
+
+static LIST_HEAD(ftrace_module_file_list);
+
+/*
+ * Modules must own their file_operations to keep up with
+ * reference counting.
+ */
+struct ftrace_module_file_ops {
+	struct list_head		list;
+	struct module			*mod;
+	struct file_operations		id;
+	struct file_operations		enable;
+	struct file_operations		format;
+	struct file_operations		filter;
+};
+
+static struct ftrace_module_file_ops *
+trace_create_file_ops(struct module *mod)
+{
+	struct ftrace_module_file_ops *file_ops;
+
+	/*
+	 * This is a bit of a PITA. To allow for correct reference
+	 * counting, modules must "own" their file_operations.
+	 * To do this, we allocate the file operations that will be
+	 * used in the event directory.
+	 */
+
+	file_ops = kmalloc(sizeof(*file_ops), GFP_KERNEL);
+	if (!file_ops)
+		return NULL;
+
+	file_ops->mod = mod;
+
+	file_ops->id = ftrace_event_id_fops;
+	file_ops->id.owner = mod;
+
+	file_ops->enable = ftrace_enable_fops;
+	file_ops->enable.owner = mod;
+
+	file_ops->filter = ftrace_event_filter_fops;
+	file_ops->filter.owner = mod;
+
+	file_ops->format = ftrace_event_format_fops;
+	file_ops->format.owner = mod;
+
+	list_add(&file_ops->list, &ftrace_module_file_list);
+
+	return file_ops;
+}
+
+static void trace_module_add_events(struct module *mod)
+{
+	struct ftrace_module_file_ops *file_ops = NULL;
+	struct ftrace_event_call *call, *start, *end;
+	struct dentry *d_events;
+
+	start = mod->trace_events;
+	end = mod->trace_events + mod->num_trace_events;
+
+	if (start == end)
+		return;
+
+	d_events = event_trace_events_dir();
+	if (!d_events)
+		return;
+
+	for_each_event(call, start, end) {
+		/* The linker may leave blanks */
+		if (!call->name)
+			continue;
+
+		/*
+		 * This module has events, create file ops for this module
+		 * if not already done.
+		 */
+		if (!file_ops) {
+			file_ops = trace_create_file_ops(mod);
+			if (!file_ops)
+				return;
+		}
+		call->mod = mod;
+		list_add(&call->list, &ftrace_events);
+		event_create_dir(call, d_events,
+				 &file_ops->id, &file_ops->enable,
+				 &file_ops->filter, &file_ops->format);
+	}
+}
+
+static void trace_module_remove_events(struct module *mod)
+{
+	struct ftrace_module_file_ops *file_ops;
+	struct ftrace_event_call *call, *p;
+	bool found = false;
+
+	down_write(&trace_event_mutex);
+	list_for_each_entry_safe(call, p, &ftrace_events, list) {
+		if (call->mod == mod) {
+			found = true;
+			ftrace_event_enable_disable(call, 0);
+			if (call->event)
+				__unregister_ftrace_event(call->event);
+			debugfs_remove_recursive(call->dir);
+			list_del(&call->list);
+			trace_destroy_fields(call);
+			destroy_preds(call);
+		}
+	}
+
+	/* Now free the file_operations */
+	list_for_each_entry(file_ops, &ftrace_module_file_list, list) {
+		if (file_ops->mod == mod)
+			break;
+	}
+	if (&file_ops->list != &ftrace_module_file_list) {
+		list_del(&file_ops->list);
+		kfree(file_ops);
+	}
+
+	/*
+	 * It is safest to reset the ring buffer if the module being unloaded
+	 * registered any events.
+	 */
+	if (found)
+		tracing_reset_current_online_cpus();
+	up_write(&trace_event_mutex);
+}
+
+static int trace_module_notify(struct notifier_block *self,
+			       unsigned long val, void *data)
+{
+	struct module *mod = data;
+
+	mutex_lock(&event_mutex);
+	switch (val) {
+	case MODULE_STATE_COMING:
+		trace_module_add_events(mod);
+		break;
+	case MODULE_STATE_GOING:
+		trace_module_remove_events(mod);
+		break;
+	}
+	mutex_unlock(&event_mutex);
 
 	return 0;
 }
+#else
+static int trace_module_notify(struct notifier_block *self,
+			       unsigned long val, void *data)
+{
+	return 0;
+}
+#endif /* CONFIG_MODULES */
+
+struct notifier_block trace_module_nb = {
+	.notifier_call = trace_module_notify,
+	.priority = 0,
+};
+
+extern struct ftrace_event_call __start_ftrace_events[];
+extern struct ftrace_event_call __stop_ftrace_events[];
 
 static __init int event_trace_init(void)
 {
-	struct ftrace_event_call *call = __start_ftrace_events;
+	struct ftrace_event_call *call;
 	struct dentry *d_tracer;
 	struct dentry *entry;
 	struct dentry *d_events;
+	int ret;
 
 	d_tracer = tracing_init_dentry();
 	if (!d_tracer)
@@ -816,13 +1147,243 @@ static __init int event_trace_init(void)
 	if (!d_events)
 		return 0;
 
-	for_each_event(call) {
+	/* ring buffer internal formats */
+	trace_create_file("header_page", 0444, d_events,
+			  ring_buffer_print_page_header,
+			  &ftrace_show_header_fops);
+
+	trace_create_file("header_event", 0444, d_events,
+			  ring_buffer_print_entry_header,
+			  &ftrace_show_header_fops);
+
+	trace_create_file("enable", 0644, d_events,
+			  NULL, &ftrace_system_enable_fops);
+
+	for_each_event(call, __start_ftrace_events, __stop_ftrace_events) {
 		/* The linker may leave blanks */
 		if (!call->name)
 			continue;
-		event_create_dir(call, d_events);
+		list_add(&call->list, &ftrace_events);
+		event_create_dir(call, d_events, &ftrace_event_id_fops,
+				 &ftrace_enable_fops, &ftrace_event_filter_fops,
+				 &ftrace_event_format_fops);
 	}
 
+	ret = register_module_notifier(&trace_module_nb);
+	if (ret)
+		pr_warning("Failed to register trace events module notifier\n");
+
 	return 0;
 }
 fs_initcall(event_trace_init);
+
+#ifdef CONFIG_FTRACE_STARTUP_TEST
+
+static DEFINE_SPINLOCK(test_spinlock);
+static DEFINE_SPINLOCK(test_spinlock_irq);
+static DEFINE_MUTEX(test_mutex);
+
+static __init void test_work(struct work_struct *dummy)
+{
+	spin_lock(&test_spinlock);
+	spin_lock_irq(&test_spinlock_irq);
+	udelay(1);
+	spin_unlock_irq(&test_spinlock_irq);
+	spin_unlock(&test_spinlock);
+
+	mutex_lock(&test_mutex);
+	msleep(1);
+	mutex_unlock(&test_mutex);
+}
+
+static __init int event_test_thread(void *unused)
+{
+	void *test_malloc;
+
+	test_malloc = kmalloc(1234, GFP_KERNEL);
+	if (!test_malloc)
+		pr_info("failed to kmalloc\n");
+
+	schedule_on_each_cpu(test_work);
+
+	kfree(test_malloc);
+
+	set_current_state(TASK_INTERRUPTIBLE);
+	while (!kthread_should_stop())
+		schedule();
+
+	return 0;
+}
+
+/*
+ * Do various things that may trigger events.
+ */
+static __init void event_test_stuff(void)
+{
+	struct task_struct *test_thread;
+
+	test_thread = kthread_run(event_test_thread, NULL, "test-events");
+	msleep(1);
+	kthread_stop(test_thread);
+}
+
+/*
+ * For every trace event defined, we will test each trace point separately,
+ * and then by groups, and finally all trace points.
+ */
+static __init void event_trace_self_tests(void)
+{
+	struct ftrace_event_call *call;
+	struct event_subsystem *system;
+	int ret;
+
+	pr_info("Running tests on trace events:\n");
+
+	list_for_each_entry(call, &ftrace_events, list) {
+
+		/* Only test those that have a regfunc */
+		if (!call->regfunc)
+			continue;
+
+		pr_info("Testing event %s: ", call->name);
+
+		/*
+		 * If an event is already enabled, someone is using
+		 * it and the self test should not be on.
+		 */
+		if (call->enabled) {
+			pr_warning("Enabled event during self test!\n");
+			WARN_ON_ONCE(1);
+			continue;
+		}
+
+		ftrace_event_enable_disable(call, 1);
+		event_test_stuff();
+		ftrace_event_enable_disable(call, 0);
+
+		pr_cont("OK\n");
+	}
+
+	/* Now test at the sub system level */
+
+	pr_info("Running tests on trace event systems:\n");
+
+	list_for_each_entry(system, &event_subsystems, list) {
+
+		/* the ftrace system is special, skip it */
+		if (strcmp(system->name, "ftrace") == 0)
+			continue;
+
+		pr_info("Testing event system %s: ", system->name);
+
+		ret = __ftrace_set_clr_event(NULL, system->name, NULL, 1);
+		if (WARN_ON_ONCE(ret)) {
+			pr_warning("error enabling system %s\n",
+				   system->name);
+			continue;
+		}
+
+		event_test_stuff();
+
+		ret = __ftrace_set_clr_event(NULL, system->name, NULL, 0);
+		if (WARN_ON_ONCE(ret))
+			pr_warning("error disabling system %s\n",
+				   system->name);
+
+		pr_cont("OK\n");
+	}
+
+	/* Test with all events enabled */
+
+	pr_info("Running tests on all trace events:\n");
+	pr_info("Testing all events: ");
+
+	ret = __ftrace_set_clr_event(NULL, NULL, NULL, 1);
+	if (WARN_ON_ONCE(ret)) {
+		pr_warning("error enabling all events\n");
+		return;
+	}
+
+	event_test_stuff();
+
+	/* reset sysname */
+	ret = __ftrace_set_clr_event(NULL, NULL, NULL, 0);
+	if (WARN_ON_ONCE(ret)) {
+		pr_warning("error disabling all events\n");
+		return;
+	}
+
+	pr_cont("OK\n");
+}
+
+#ifdef CONFIG_FUNCTION_TRACER
+
+static DEFINE_PER_CPU(atomic_t, test_event_disable);
+
+static void
+function_test_events_call(unsigned long ip, unsigned long parent_ip)
+{
+	struct ring_buffer_event *event;
+	struct ftrace_entry *entry;
+	unsigned long flags;
+	long disabled;
+	int resched;
+	int cpu;
+	int pc;
+
+	pc = preempt_count();
+	resched = ftrace_preempt_disable();
+	cpu = raw_smp_processor_id();
+	disabled = atomic_inc_return(&per_cpu(test_event_disable, cpu));
+
+	if (disabled != 1)
+		goto out;
+
+	local_save_flags(flags);
+
+	event = trace_current_buffer_lock_reserve(TRACE_FN, sizeof(*entry),
+						  flags, pc);
+	if (!event)
+		goto out;
+	entry	= ring_buffer_event_data(event);
+	entry->ip			= ip;
+	entry->parent_ip		= parent_ip;
+
+	trace_nowake_buffer_unlock_commit(event, flags, pc);
+
+ out:
+	atomic_dec(&per_cpu(test_event_disable, cpu));
+	ftrace_preempt_enable(resched);
+}
+
+static struct ftrace_ops trace_ops __initdata  =
+{
+	.func = function_test_events_call,
+};
+
+static __init void event_trace_self_test_with_function(void)
+{
+	register_ftrace_function(&trace_ops);
+	pr_info("Running tests again, along with the function tracer\n");
+	event_trace_self_tests();
+	unregister_ftrace_function(&trace_ops);
+}
+#else
+static __init void event_trace_self_test_with_function(void)
+{
+}
+#endif
+
+static __init int event_trace_self_tests_init(void)
+{
+
+	event_trace_self_tests();
+
+	event_trace_self_test_with_function();
+
+	return 0;
+}
+
+late_initcall(event_trace_self_tests_init);
+
+#endif
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index e03cbf1..db6e54b 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -22,119 +22,297 @@
 #include <linux/uaccess.h>
 #include <linux/module.h>
 #include <linux/ctype.h>
+#include <linux/mutex.h>
 
 #include "trace.h"
 #include "trace_output.h"
 
-static int filter_pred_64(struct filter_pred *pred, void *event)
+static DEFINE_MUTEX(filter_mutex);
+
+enum filter_op_ids
+{
+	OP_OR,
+	OP_AND,
+	OP_NE,
+	OP_EQ,
+	OP_LT,
+	OP_LE,
+	OP_GT,
+	OP_GE,
+	OP_NONE,
+	OP_OPEN_PAREN,
+};
+
+struct filter_op {
+	int id;
+	char *string;
+	int precedence;
+};
+
+static struct filter_op filter_ops[] = {
+	{ OP_OR, "||", 1 },
+	{ OP_AND, "&&", 2 },
+	{ OP_NE, "!=", 4 },
+	{ OP_EQ, "==", 4 },
+	{ OP_LT, "<", 5 },
+	{ OP_LE, "<=", 5 },
+	{ OP_GT, ">", 5 },
+	{ OP_GE, ">=", 5 },
+	{ OP_NONE, "OP_NONE", 0 },
+	{ OP_OPEN_PAREN, "(", 0 },
+};
+
+enum {
+	FILT_ERR_NONE,
+	FILT_ERR_INVALID_OP,
+	FILT_ERR_UNBALANCED_PAREN,
+	FILT_ERR_TOO_MANY_OPERANDS,
+	FILT_ERR_OPERAND_TOO_LONG,
+	FILT_ERR_FIELD_NOT_FOUND,
+	FILT_ERR_ILLEGAL_FIELD_OP,
+	FILT_ERR_ILLEGAL_INTVAL,
+	FILT_ERR_BAD_SUBSYS_FILTER,
+	FILT_ERR_TOO_MANY_PREDS,
+	FILT_ERR_MISSING_FIELD,
+	FILT_ERR_INVALID_FILTER,
+};
+
+static char *err_text[] = {
+	"No error",
+	"Invalid operator",
+	"Unbalanced parens",
+	"Too many operands",
+	"Operand too long",
+	"Field not found",
+	"Illegal operation for field type",
+	"Illegal integer value",
+	"Couldn't find or set field in one of a subsystem's events",
+	"Too many terms in predicate expression",
+	"Missing field name and/or value",
+	"Meaningless filter expression",
+};
+
+struct opstack_op {
+	int op;
+	struct list_head list;
+};
+
+struct postfix_elt {
+	int op;
+	char *operand;
+	struct list_head list;
+};
+
+struct filter_parse_state {
+	struct filter_op *ops;
+	struct list_head opstack;
+	struct list_head postfix;
+	int lasterr;
+	int lasterr_pos;
+
+	struct {
+		char *string;
+		unsigned int cnt;
+		unsigned int tail;
+	} infix;
+
+	struct {
+		char string[MAX_FILTER_STR_VAL];
+		int pos;
+		unsigned int tail;
+	} operand;
+};
+
+DEFINE_COMPARISON_PRED(s64);
+DEFINE_COMPARISON_PRED(u64);
+DEFINE_COMPARISON_PRED(s32);
+DEFINE_COMPARISON_PRED(u32);
+DEFINE_COMPARISON_PRED(s16);
+DEFINE_COMPARISON_PRED(u16);
+DEFINE_COMPARISON_PRED(s8);
+DEFINE_COMPARISON_PRED(u8);
+
+DEFINE_EQUALITY_PRED(64);
+DEFINE_EQUALITY_PRED(32);
+DEFINE_EQUALITY_PRED(16);
+DEFINE_EQUALITY_PRED(8);
+
+static int filter_pred_and(struct filter_pred *pred __attribute((unused)),
+			   void *event __attribute((unused)),
+			   int val1, int val2)
+{
+	return val1 && val2;
+}
+
+static int filter_pred_or(struct filter_pred *pred __attribute((unused)),
+			  void *event __attribute((unused)),
+			  int val1, int val2)
+{
+	return val1 || val2;
+}
+
+/* Filter predicate for fixed sized arrays of characters */
+static int filter_pred_string(struct filter_pred *pred, void *event,
+			      int val1, int val2)
 {
-	u64 *addr = (u64 *)(event + pred->offset);
-	u64 val = (u64)pred->val;
-	int match;
+	char *addr = (char *)(event + pred->offset);
+	int cmp, match;
+
+	cmp = strncmp(addr, pred->str_val, pred->str_len);
 
-	match = (val == *addr) ^ pred->not;
+	match = (!cmp) ^ pred->not;
 
 	return match;
 }
 
-static int filter_pred_32(struct filter_pred *pred, void *event)
+/*
+ * Filter predicate for dynamic sized arrays of characters.
+ * These are implemented through a list of strings at the end
+ * of the entry.
+ * Also each of these strings have a field in the entry which
+ * contains its offset from the beginning of the entry.
+ * We have then first to get this field, dereference it
+ * and add it to the address of the entry, and at last we have
+ * the address of the string.
+ */
+static int filter_pred_strloc(struct filter_pred *pred, void *event,
+			      int val1, int val2)
 {
-	u32 *addr = (u32 *)(event + pred->offset);
-	u32 val = (u32)pred->val;
-	int match;
+	int str_loc = *(int *)(event + pred->offset);
+	char *addr = (char *)(event + str_loc);
+	int cmp, match;
+
+	cmp = strncmp(addr, pred->str_val, pred->str_len);
 
-	match = (val == *addr) ^ pred->not;
+	match = (!cmp) ^ pred->not;
 
 	return match;
 }
 
-static int filter_pred_16(struct filter_pred *pred, void *event)
+static int filter_pred_none(struct filter_pred *pred, void *event,
+			    int val1, int val2)
+{
+	return 0;
+}
+
+/* return 1 if event matches, 0 otherwise (discard) */
+int filter_match_preds(struct ftrace_event_call *call, void *rec)
 {
-	u16 *addr = (u16 *)(event + pred->offset);
-	u16 val = (u16)pred->val;
-	int match;
+	struct event_filter *filter = call->filter;
+	int match, top = 0, val1 = 0, val2 = 0;
+	int stack[MAX_FILTER_PRED];
+	struct filter_pred *pred;
+	int i;
+
+	for (i = 0; i < filter->n_preds; i++) {
+		pred = filter->preds[i];
+		if (!pred->pop_n) {
+			match = pred->fn(pred, rec, val1, val2);
+			stack[top++] = match;
+			continue;
+		}
+		if (pred->pop_n > top) {
+			WARN_ON_ONCE(1);
+			return 0;
+		}
+		val1 = stack[--top];
+		val2 = stack[--top];
+		match = pred->fn(pred, rec, val1, val2);
+		stack[top++] = match;
+	}
 
-	match = (val == *addr) ^ pred->not;
+	return stack[--top];
+}
+EXPORT_SYMBOL_GPL(filter_match_preds);
 
-	return match;
+static void parse_error(struct filter_parse_state *ps, int err, int pos)
+{
+	ps->lasterr = err;
+	ps->lasterr_pos = pos;
 }
 
-static int filter_pred_8(struct filter_pred *pred, void *event)
+static void remove_filter_string(struct event_filter *filter)
 {
-	u8 *addr = (u8 *)(event + pred->offset);
-	u8 val = (u8)pred->val;
-	int match;
+	kfree(filter->filter_string);
+	filter->filter_string = NULL;
+}
 
-	match = (val == *addr) ^ pred->not;
+static int replace_filter_string(struct event_filter *filter,
+				 char *filter_string)
+{
+	kfree(filter->filter_string);
+	filter->filter_string = kstrdup(filter_string, GFP_KERNEL);
+	if (!filter->filter_string)
+		return -ENOMEM;
 
-	return match;
+	return 0;
 }
 
-static int filter_pred_string(struct filter_pred *pred, void *event)
+static int append_filter_string(struct event_filter *filter,
+				char *string)
 {
-	char *addr = (char *)(event + pred->offset);
-	int cmp, match;
+	int newlen;
+	char *new_filter_string;
 
-	cmp = strncmp(addr, pred->str_val, pred->str_len);
+	BUG_ON(!filter->filter_string);
+	newlen = strlen(filter->filter_string) + strlen(string) + 1;
+	new_filter_string = kmalloc(newlen, GFP_KERNEL);
+	if (!new_filter_string)
+		return -ENOMEM;
 
-	match = (!cmp) ^ pred->not;
+	strcpy(new_filter_string, filter->filter_string);
+	strcat(new_filter_string, string);
+	kfree(filter->filter_string);
+	filter->filter_string = new_filter_string;
 
-	return match;
+	return 0;
 }
 
-/* return 1 if event matches, 0 otherwise (discard) */
-int filter_match_preds(struct ftrace_event_call *call, void *rec)
+static void append_filter_err(struct filter_parse_state *ps,
+			      struct event_filter *filter)
 {
-	int i, matched, and_failed = 0;
-	struct filter_pred *pred;
+	int pos = ps->lasterr_pos;
+	char *buf, *pbuf;
 
-	for (i = 0; i < MAX_FILTER_PRED; i++) {
-		if (call->preds[i]) {
-			pred = call->preds[i];
-			if (and_failed && !pred->or)
-				continue;
-			matched = pred->fn(pred, rec);
-			if (!matched && !pred->or) {
-				and_failed = 1;
-				continue;
-			} else if (matched && pred->or)
-				return 1;
-		} else
-			break;
-	}
+	buf = (char *)__get_free_page(GFP_TEMPORARY);
+	if (!buf)
+		return;
 
-	if (and_failed)
-		return 0;
+	append_filter_string(filter, "\n");
+	memset(buf, ' ', PAGE_SIZE);
+	if (pos > PAGE_SIZE - 128)
+		pos = 0;
+	buf[pos] = '^';
+	pbuf = &buf[pos] + 1;
 
-	return 1;
+	sprintf(pbuf, "\nparse_error: %s\n", err_text[ps->lasterr]);
+	append_filter_string(filter, buf);
+	free_page((unsigned long) buf);
 }
 
-void filter_print_preds(struct filter_pred **preds, struct trace_seq *s)
+void print_event_filter(struct ftrace_event_call *call, struct trace_seq *s)
 {
-	char *field_name;
-	struct filter_pred *pred;
-	int i;
+	struct event_filter *filter = call->filter;
 
-	if (!preds) {
+	mutex_lock(&filter_mutex);
+	if (filter->filter_string)
+		trace_seq_printf(s, "%s\n", filter->filter_string);
+	else
 		trace_seq_printf(s, "none\n");
-		return;
-	}
+	mutex_unlock(&filter_mutex);
+}
 
-	for (i = 0; i < MAX_FILTER_PRED; i++) {
-		if (preds[i]) {
-			pred = preds[i];
-			field_name = pred->field_name;
-			if (i)
-				trace_seq_printf(s, pred->or ? "|| " : "&& ");
-			trace_seq_printf(s, "%s ", field_name);
-			trace_seq_printf(s, pred->not ? "!= " : "== ");
-			if (pred->str_val)
-				trace_seq_printf(s, "%s\n", pred->str_val);
-			else
-				trace_seq_printf(s, "%llu\n", pred->val);
-		} else
-			break;
-	}
+void print_subsystem_event_filter(struct event_subsystem *system,
+				  struct trace_seq *s)
+{
+	struct event_filter *filter = system->filter;
+
+	mutex_lock(&filter_mutex);
+	if (filter->filter_string)
+		trace_seq_printf(s, "%s\n", filter->filter_string);
+	else
+		trace_seq_printf(s, "none\n");
+	mutex_unlock(&filter_mutex);
 }
 
 static struct ftrace_event_field *
@@ -150,284 +328,828 @@ find_event_field(struct ftrace_event_call *call, char *name)
 	return NULL;
 }
 
-void filter_free_pred(struct filter_pred *pred)
+static void filter_free_pred(struct filter_pred *pred)
 {
 	if (!pred)
 		return;
 
 	kfree(pred->field_name);
-	kfree(pred->str_val);
 	kfree(pred);
 }
 
-void filter_free_preds(struct ftrace_event_call *call)
+static void filter_clear_pred(struct filter_pred *pred)
 {
-	int i;
+	kfree(pred->field_name);
+	pred->field_name = NULL;
+	pred->str_len = 0;
+}
 
-	if (call->preds) {
-		for (i = 0; i < MAX_FILTER_PRED; i++)
-			filter_free_pred(call->preds[i]);
-		kfree(call->preds);
-		call->preds = NULL;
+static int filter_set_pred(struct filter_pred *dest,
+			   struct filter_pred *src,
+			   filter_pred_fn_t fn)
+{
+	*dest = *src;
+	if (src->field_name) {
+		dest->field_name = kstrdup(src->field_name, GFP_KERNEL);
+		if (!dest->field_name)
+			return -ENOMEM;
 	}
+	dest->fn = fn;
+
+	return 0;
 }
 
-void filter_free_subsystem_preds(struct event_subsystem *system)
+static void filter_disable_preds(struct ftrace_event_call *call)
 {
-	struct ftrace_event_call *call = __start_ftrace_events;
+	struct event_filter *filter = call->filter;
 	int i;
 
-	if (system->preds) {
-		for (i = 0; i < MAX_FILTER_PRED; i++)
-			filter_free_pred(system->preds[i]);
-		kfree(system->preds);
-		system->preds = NULL;
-	}
+	call->filter_active = 0;
+	filter->n_preds = 0;
 
-	events_for_each(call) {
-		if (!call->name || !call->regfunc)
-			continue;
+	for (i = 0; i < MAX_FILTER_PRED; i++)
+		filter->preds[i]->fn = filter_pred_none;
+}
+
+void destroy_preds(struct ftrace_event_call *call)
+{
+	struct event_filter *filter = call->filter;
+	int i;
 
-		if (!strcmp(call->system, system->name))
-			filter_free_preds(call);
+	for (i = 0; i < MAX_FILTER_PRED; i++) {
+		if (filter->preds[i])
+			filter_free_pred(filter->preds[i]);
 	}
+	kfree(filter->preds);
+	kfree(filter);
+	call->filter = NULL;
 }
 
-static int __filter_add_pred(struct ftrace_event_call *call,
-			     struct filter_pred *pred)
+int init_preds(struct ftrace_event_call *call)
 {
+	struct event_filter *filter;
+	struct filter_pred *pred;
 	int i;
 
-	if (call->preds && !pred->compound)
-		filter_free_preds(call);
+	filter = call->filter = kzalloc(sizeof(*filter), GFP_KERNEL);
+	if (!call->filter)
+		return -ENOMEM;
 
-	if (!call->preds) {
-		call->preds = kzalloc(MAX_FILTER_PRED * sizeof(pred),
-				      GFP_KERNEL);
-		if (!call->preds)
-			return -ENOMEM;
-	}
+	call->filter_active = 0;
+	filter->n_preds = 0;
+
+	filter->preds = kzalloc(MAX_FILTER_PRED * sizeof(pred), GFP_KERNEL);
+	if (!filter->preds)
+		goto oom;
 
 	for (i = 0; i < MAX_FILTER_PRED; i++) {
-		if (!call->preds[i]) {
-			call->preds[i] = pred;
-			return 0;
+		pred = kzalloc(sizeof(*pred), GFP_KERNEL);
+		if (!pred)
+			goto oom;
+		pred->fn = filter_pred_none;
+		filter->preds[i] = pred;
+	}
+
+	return 0;
+
+oom:
+	destroy_preds(call);
+
+	return -ENOMEM;
+}
+EXPORT_SYMBOL_GPL(init_preds);
+
+static void filter_free_subsystem_preds(struct event_subsystem *system)
+{
+	struct event_filter *filter = system->filter;
+	struct ftrace_event_call *call;
+	int i;
+
+	if (filter->n_preds) {
+		for (i = 0; i < filter->n_preds; i++)
+			filter_free_pred(filter->preds[i]);
+		kfree(filter->preds);
+		filter->preds = NULL;
+		filter->n_preds = 0;
+	}
+
+	mutex_lock(&event_mutex);
+	list_for_each_entry(call, &ftrace_events, list) {
+		if (!call->define_fields)
+			continue;
+
+		if (!strcmp(call->system, system->name)) {
+			filter_disable_preds(call);
+			remove_filter_string(call->filter);
 		}
 	}
+	mutex_unlock(&event_mutex);
+}
+
+static int filter_add_pred_fn(struct filter_parse_state *ps,
+			      struct ftrace_event_call *call,
+			      struct filter_pred *pred,
+			      filter_pred_fn_t fn)
+{
+	struct event_filter *filter = call->filter;
+	int idx, err;
+
+	if (filter->n_preds == MAX_FILTER_PRED) {
+		parse_error(ps, FILT_ERR_TOO_MANY_PREDS, 0);
+		return -ENOSPC;
+	}
+
+	idx = filter->n_preds;
+	filter_clear_pred(filter->preds[idx]);
+	err = filter_set_pred(filter->preds[idx], pred, fn);
+	if (err)
+		return err;
 
-	return -ENOSPC;
+	filter->n_preds++;
+	call->filter_active = 1;
+
+	return 0;
 }
 
+enum {
+	FILTER_STATIC_STRING = 1,
+	FILTER_DYN_STRING
+};
+
 static int is_string_field(const char *type)
 {
+	if (strstr(type, "__data_loc") && strstr(type, "char"))
+		return FILTER_DYN_STRING;
+
 	if (strchr(type, '[') && strstr(type, "char"))
-		return 1;
+		return FILTER_STATIC_STRING;
 
 	return 0;
 }
 
-int filter_add_pred(struct ftrace_event_call *call, struct filter_pred *pred)
+static int is_legal_op(struct ftrace_event_field *field, int op)
 {
-	struct ftrace_event_field *field;
-
-	field = find_event_field(call, pred->field_name);
-	if (!field)
-		return -EINVAL;
+	if (is_string_field(field->type) && (op != OP_EQ && op != OP_NE))
+		return 0;
 
-	pred->offset = field->offset;
+	return 1;
+}
 
-	if (is_string_field(field->type)) {
-		if (!pred->str_val)
-			return -EINVAL;
-		pred->fn = filter_pred_string;
-		pred->str_len = field->size;
-		return __filter_add_pred(call, pred);
-	} else {
-		if (pred->str_val)
-			return -EINVAL;
-	}
+static filter_pred_fn_t select_comparison_fn(int op, int field_size,
+					     int field_is_signed)
+{
+	filter_pred_fn_t fn = NULL;
 
-	switch (field->size) {
+	switch (field_size) {
 	case 8:
-		pred->fn = filter_pred_64;
+		if (op == OP_EQ || op == OP_NE)
+			fn = filter_pred_64;
+		else if (field_is_signed)
+			fn = filter_pred_s64;
+		else
+			fn = filter_pred_u64;
 		break;
 	case 4:
-		pred->fn = filter_pred_32;
+		if (op == OP_EQ || op == OP_NE)
+			fn = filter_pred_32;
+		else if (field_is_signed)
+			fn = filter_pred_s32;
+		else
+			fn = filter_pred_u32;
 		break;
 	case 2:
-		pred->fn = filter_pred_16;
+		if (op == OP_EQ || op == OP_NE)
+			fn = filter_pred_16;
+		else if (field_is_signed)
+			fn = filter_pred_s16;
+		else
+			fn = filter_pred_u16;
 		break;
 	case 1:
-		pred->fn = filter_pred_8;
+		if (op == OP_EQ || op == OP_NE)
+			fn = filter_pred_8;
+		else if (field_is_signed)
+			fn = filter_pred_s8;
+		else
+			fn = filter_pred_u8;
 		break;
-	default:
-		return -EINVAL;
 	}
 
-	return __filter_add_pred(call, pred);
+	return fn;
 }
 
-static struct filter_pred *copy_pred(struct filter_pred *pred)
+static int filter_add_pred(struct filter_parse_state *ps,
+			   struct ftrace_event_call *call,
+			   struct filter_pred *pred)
 {
-	struct filter_pred *new_pred = kmalloc(sizeof(*pred), GFP_KERNEL);
-	if (!new_pred)
-		return NULL;
+	struct ftrace_event_field *field;
+	filter_pred_fn_t fn;
+	unsigned long long val;
+	int string_type;
+
+	pred->fn = filter_pred_none;
+
+	if (pred->op == OP_AND) {
+		pred->pop_n = 2;
+		return filter_add_pred_fn(ps, call, pred, filter_pred_and);
+	} else if (pred->op == OP_OR) {
+		pred->pop_n = 2;
+		return filter_add_pred_fn(ps, call, pred, filter_pred_or);
+	}
+
+	field = find_event_field(call, pred->field_name);
+	if (!field) {
+		parse_error(ps, FILT_ERR_FIELD_NOT_FOUND, 0);
+		return -EINVAL;
+	}
 
-	memcpy(new_pred, pred, sizeof(*pred));
+	pred->offset = field->offset;
 
-	if (pred->field_name) {
-		new_pred->field_name = kstrdup(pred->field_name, GFP_KERNEL);
-		if (!new_pred->field_name) {
-			kfree(new_pred);
-			return NULL;
-		}
+	if (!is_legal_op(field, pred->op)) {
+		parse_error(ps, FILT_ERR_ILLEGAL_FIELD_OP, 0);
+		return -EINVAL;
 	}
 
-	if (pred->str_val) {
-		new_pred->str_val = kstrdup(pred->str_val, GFP_KERNEL);
-		if (!new_pred->str_val) {
-			filter_free_pred(new_pred);
-			return NULL;
+	string_type = is_string_field(field->type);
+	if (string_type) {
+		if (string_type == FILTER_STATIC_STRING)
+			fn = filter_pred_string;
+		else
+			fn = filter_pred_strloc;
+		pred->str_len = field->size;
+		if (pred->op == OP_NE)
+			pred->not = 1;
+		return filter_add_pred_fn(ps, call, pred, fn);
+	} else {
+		if (strict_strtoull(pred->str_val, 0, &val)) {
+			parse_error(ps, FILT_ERR_ILLEGAL_INTVAL, 0);
+			return -EINVAL;
 		}
+		pred->val = val;
+	}
+
+	fn = select_comparison_fn(pred->op, field->size, field->is_signed);
+	if (!fn) {
+		parse_error(ps, FILT_ERR_INVALID_OP, 0);
+		return -EINVAL;
 	}
 
-	return new_pred;
+	if (pred->op == OP_NE)
+		pred->not = 1;
+
+	return filter_add_pred_fn(ps, call, pred, fn);
 }
 
-int filter_add_subsystem_pred(struct event_subsystem *system,
-			      struct filter_pred *pred)
+static int filter_add_subsystem_pred(struct filter_parse_state *ps,
+				     struct event_subsystem *system,
+				     struct filter_pred *pred,
+				     char *filter_string)
 {
-	struct ftrace_event_call *call = __start_ftrace_events;
-	struct filter_pred *event_pred;
-	int i;
-
-	if (system->preds && !pred->compound)
-		filter_free_subsystem_preds(system);
+	struct event_filter *filter = system->filter;
+	struct ftrace_event_call *call;
+	int err = 0;
 
-	if (!system->preds) {
-		system->preds = kzalloc(MAX_FILTER_PRED * sizeof(pred),
+	if (!filter->preds) {
+		filter->preds = kzalloc(MAX_FILTER_PRED * sizeof(pred),
 					GFP_KERNEL);
-		if (!system->preds)
+
+		if (!filter->preds)
 			return -ENOMEM;
 	}
 
-	for (i = 0; i < MAX_FILTER_PRED; i++) {
-		if (!system->preds[i]) {
-			system->preds[i] = pred;
-			break;
-		}
+	if (filter->n_preds == MAX_FILTER_PRED) {
+		parse_error(ps, FILT_ERR_TOO_MANY_PREDS, 0);
+		return -ENOSPC;
 	}
 
-	if (i == MAX_FILTER_PRED)
-		return -ENOSPC;
+	filter->preds[filter->n_preds] = pred;
+	filter->n_preds++;
 
-	events_for_each(call) {
-		int err;
+	mutex_lock(&event_mutex);
+	list_for_each_entry(call, &ftrace_events, list) {
 
-		if (!call->name || !call->regfunc)
+		if (!call->define_fields)
 			continue;
 
 		if (strcmp(call->system, system->name))
 			continue;
 
-		if (!find_event_field(call, pred->field_name))
-			continue;
+		err = filter_add_pred(ps, call, pred);
+		if (err) {
+			mutex_unlock(&event_mutex);
+			filter_free_subsystem_preds(system);
+			parse_error(ps, FILT_ERR_BAD_SUBSYS_FILTER, 0);
+			goto out;
+		}
+		replace_filter_string(call->filter, filter_string);
+	}
+	mutex_unlock(&event_mutex);
+out:
+	return err;
+}
 
-		event_pred = copy_pred(pred);
-		if (!event_pred)
-			goto oom;
+static void parse_init(struct filter_parse_state *ps,
+		       struct filter_op *ops,
+		       char *infix_string)
+{
+	memset(ps, '\0', sizeof(*ps));
 
-		err = filter_add_pred(call, event_pred);
-		if (err)
-			filter_free_pred(event_pred);
-		if (err == -ENOMEM)
-			goto oom;
+	ps->infix.string = infix_string;
+	ps->infix.cnt = strlen(infix_string);
+	ps->ops = ops;
+
+	INIT_LIST_HEAD(&ps->opstack);
+	INIT_LIST_HEAD(&ps->postfix);
+}
+
+static char infix_next(struct filter_parse_state *ps)
+{
+	ps->infix.cnt--;
+
+	return ps->infix.string[ps->infix.tail++];
+}
+
+static char infix_peek(struct filter_parse_state *ps)
+{
+	if (ps->infix.tail == strlen(ps->infix.string))
+		return 0;
+
+	return ps->infix.string[ps->infix.tail];
+}
+
+static void infix_advance(struct filter_parse_state *ps)
+{
+	ps->infix.cnt--;
+	ps->infix.tail++;
+}
+
+static inline int is_precedence_lower(struct filter_parse_state *ps,
+				      int a, int b)
+{
+	return ps->ops[a].precedence < ps->ops[b].precedence;
+}
+
+static inline int is_op_char(struct filter_parse_state *ps, char c)
+{
+	int i;
+
+	for (i = 0; strcmp(ps->ops[i].string, "OP_NONE"); i++) {
+		if (ps->ops[i].string[0] == c)
+			return 1;
 	}
 
 	return 0;
+}
 
-oom:
-	system->preds[i] = NULL;
-	return -ENOMEM;
+static int infix_get_op(struct filter_parse_state *ps, char firstc)
+{
+	char nextc = infix_peek(ps);
+	char opstr[3];
+	int i;
+
+	opstr[0] = firstc;
+	opstr[1] = nextc;
+	opstr[2] = '\0';
+
+	for (i = 0; strcmp(ps->ops[i].string, "OP_NONE"); i++) {
+		if (!strcmp(opstr, ps->ops[i].string)) {
+			infix_advance(ps);
+			return ps->ops[i].id;
+		}
+	}
+
+	opstr[1] = '\0';
+
+	for (i = 0; strcmp(ps->ops[i].string, "OP_NONE"); i++) {
+		if (!strcmp(opstr, ps->ops[i].string))
+			return ps->ops[i].id;
+	}
+
+	return OP_NONE;
 }
 
-int filter_parse(char **pbuf, struct filter_pred *pred)
+static inline void clear_operand_string(struct filter_parse_state *ps)
 {
-	char *tmp, *tok, *val_str = NULL;
-	int tok_n = 0;
+	memset(ps->operand.string, '\0', MAX_FILTER_STR_VAL);
+	ps->operand.tail = 0;
+}
 
-	/* field ==/!= number, or/and field ==/!= number, number */
-	while ((tok = strsep(pbuf, " \n"))) {
-		if (tok_n == 0) {
-			if (!strcmp(tok, "0")) {
-				pred->clear = 1;
-				return 0;
-			} else if (!strcmp(tok, "&&")) {
-				pred->or = 0;
-				pred->compound = 1;
-			} else if (!strcmp(tok, "||")) {
-				pred->or = 1;
-				pred->compound = 1;
-			} else
-				pred->field_name = tok;
-			tok_n = 1;
+static inline int append_operand_char(struct filter_parse_state *ps, char c)
+{
+	if (ps->operand.tail == MAX_FILTER_STR_VAL - 1)
+		return -EINVAL;
+
+	ps->operand.string[ps->operand.tail++] = c;
+
+	return 0;
+}
+
+static int filter_opstack_push(struct filter_parse_state *ps, int op)
+{
+	struct opstack_op *opstack_op;
+
+	opstack_op = kmalloc(sizeof(*opstack_op), GFP_KERNEL);
+	if (!opstack_op)
+		return -ENOMEM;
+
+	opstack_op->op = op;
+	list_add(&opstack_op->list, &ps->opstack);
+
+	return 0;
+}
+
+static int filter_opstack_empty(struct filter_parse_state *ps)
+{
+	return list_empty(&ps->opstack);
+}
+
+static int filter_opstack_top(struct filter_parse_state *ps)
+{
+	struct opstack_op *opstack_op;
+
+	if (filter_opstack_empty(ps))
+		return OP_NONE;
+
+	opstack_op = list_first_entry(&ps->opstack, struct opstack_op, list);
+
+	return opstack_op->op;
+}
+
+static int filter_opstack_pop(struct filter_parse_state *ps)
+{
+	struct opstack_op *opstack_op;
+	int op;
+
+	if (filter_opstack_empty(ps))
+		return OP_NONE;
+
+	opstack_op = list_first_entry(&ps->opstack, struct opstack_op, list);
+	op = opstack_op->op;
+	list_del(&opstack_op->list);
+
+	kfree(opstack_op);
+
+	return op;
+}
+
+static void filter_opstack_clear(struct filter_parse_state *ps)
+{
+	while (!filter_opstack_empty(ps))
+		filter_opstack_pop(ps);
+}
+
+static char *curr_operand(struct filter_parse_state *ps)
+{
+	return ps->operand.string;
+}
+
+static int postfix_append_operand(struct filter_parse_state *ps, char *operand)
+{
+	struct postfix_elt *elt;
+
+	elt = kmalloc(sizeof(*elt), GFP_KERNEL);
+	if (!elt)
+		return -ENOMEM;
+
+	elt->op = OP_NONE;
+	elt->operand = kstrdup(operand, GFP_KERNEL);
+	if (!elt->operand) {
+		kfree(elt);
+		return -ENOMEM;
+	}
+
+	list_add_tail(&elt->list, &ps->postfix);
+
+	return 0;
+}
+
+static int postfix_append_op(struct filter_parse_state *ps, int op)
+{
+	struct postfix_elt *elt;
+
+	elt = kmalloc(sizeof(*elt), GFP_KERNEL);
+	if (!elt)
+		return -ENOMEM;
+
+	elt->op = op;
+	elt->operand = NULL;
+
+	list_add_tail(&elt->list, &ps->postfix);
+
+	return 0;
+}
+
+static void postfix_clear(struct filter_parse_state *ps)
+{
+	struct postfix_elt *elt;
+
+	while (!list_empty(&ps->postfix)) {
+		elt = list_first_entry(&ps->postfix, struct postfix_elt, list);
+		kfree(elt->operand);
+		list_del(&elt->list);
+	}
+}
+
+static int filter_parse(struct filter_parse_state *ps)
+{
+	int in_string = 0;
+	int op, top_op;
+	char ch;
+
+	while ((ch = infix_next(ps))) {
+		if (ch == '"') {
+			in_string ^= 1;
 			continue;
 		}
-		if (tok_n == 1) {
-			if (!pred->field_name)
-				pred->field_name = tok;
-			else if (!strcmp(tok, "!="))
-				pred->not = 1;
-			else if (!strcmp(tok, "=="))
-				pred->not = 0;
-			else {
-				pred->field_name = NULL;
+
+		if (in_string)
+			goto parse_operand;
+
+		if (isspace(ch))
+			continue;
+
+		if (is_op_char(ps, ch)) {
+			op = infix_get_op(ps, ch);
+			if (op == OP_NONE) {
+				parse_error(ps, FILT_ERR_INVALID_OP, 0);
 				return -EINVAL;
 			}
-			tok_n = 2;
+
+			if (strlen(curr_operand(ps))) {
+				postfix_append_operand(ps, curr_operand(ps));
+				clear_operand_string(ps);
+			}
+
+			while (!filter_opstack_empty(ps)) {
+				top_op = filter_opstack_top(ps);
+				if (!is_precedence_lower(ps, top_op, op)) {
+					top_op = filter_opstack_pop(ps);
+					postfix_append_op(ps, top_op);
+					continue;
+				}
+				break;
+			}
+
+			filter_opstack_push(ps, op);
 			continue;
 		}
-		if (tok_n == 2) {
-			if (pred->compound) {
-				if (!strcmp(tok, "!="))
-					pred->not = 1;
-				else if (!strcmp(tok, "=="))
-					pred->not = 0;
-				else {
-					pred->field_name = NULL;
-					return -EINVAL;
-				}
-			} else {
-				val_str = tok;
-				break; /* done */
+
+		if (ch == '(') {
+			filter_opstack_push(ps, OP_OPEN_PAREN);
+			continue;
+		}
+
+		if (ch == ')') {
+			if (strlen(curr_operand(ps))) {
+				postfix_append_operand(ps, curr_operand(ps));
+				clear_operand_string(ps);
+			}
+
+			top_op = filter_opstack_pop(ps);
+			while (top_op != OP_NONE) {
+				if (top_op == OP_OPEN_PAREN)
+					break;
+				postfix_append_op(ps, top_op);
+				top_op = filter_opstack_pop(ps);
+			}
+			if (top_op == OP_NONE) {
+				parse_error(ps, FILT_ERR_UNBALANCED_PAREN, 0);
+				return -EINVAL;
 			}
-			tok_n = 3;
 			continue;
 		}
-		if (tok_n == 3) {
-			val_str = tok;
-			break; /* done */
+parse_operand:
+		if (append_operand_char(ps, ch)) {
+			parse_error(ps, FILT_ERR_OPERAND_TOO_LONG, 0);
+			return -EINVAL;
 		}
 	}
 
-	if (!val_str) {
-		pred->field_name = NULL;
-		return -EINVAL;
+	if (strlen(curr_operand(ps)))
+		postfix_append_operand(ps, curr_operand(ps));
+
+	while (!filter_opstack_empty(ps)) {
+		top_op = filter_opstack_pop(ps);
+		if (top_op == OP_NONE)
+			break;
+		if (top_op == OP_OPEN_PAREN) {
+			parse_error(ps, FILT_ERR_UNBALANCED_PAREN, 0);
+			return -EINVAL;
+		}
+		postfix_append_op(ps, top_op);
 	}
 
-	pred->field_name = kstrdup(pred->field_name, GFP_KERNEL);
-	if (!pred->field_name)
-		return -ENOMEM;
+	return 0;
+}
 
-	pred->val = simple_strtoull(val_str, &tmp, 0);
-	if (tmp == val_str) {
-		pred->str_val = kstrdup(val_str, GFP_KERNEL);
-		if (!pred->str_val)
-			return -ENOMEM;
-	} else if (*tmp != '\0')
+static struct filter_pred *create_pred(int op, char *operand1, char *operand2)
+{
+	struct filter_pred *pred;
+
+	pred = kzalloc(sizeof(*pred), GFP_KERNEL);
+	if (!pred)
+		return NULL;
+
+	pred->field_name = kstrdup(operand1, GFP_KERNEL);
+	if (!pred->field_name) {
+		kfree(pred);
+		return NULL;
+	}
+
+	strcpy(pred->str_val, operand2);
+	pred->str_len = strlen(operand2);
+
+	pred->op = op;
+
+	return pred;
+}
+
+static struct filter_pred *create_logical_pred(int op)
+{
+	struct filter_pred *pred;
+
+	pred = kzalloc(sizeof(*pred), GFP_KERNEL);
+	if (!pred)
+		return NULL;
+
+	pred->op = op;
+
+	return pred;
+}
+
+static int check_preds(struct filter_parse_state *ps)
+{
+	int n_normal_preds = 0, n_logical_preds = 0;
+	struct postfix_elt *elt;
+
+	list_for_each_entry(elt, &ps->postfix, list) {
+		if (elt->op == OP_NONE)
+			continue;
+
+		if (elt->op == OP_AND || elt->op == OP_OR) {
+			n_logical_preds++;
+			continue;
+		}
+		n_normal_preds++;
+	}
+
+	if (!n_normal_preds || n_logical_preds >= n_normal_preds) {
+		parse_error(ps, FILT_ERR_INVALID_FILTER, 0);
 		return -EINVAL;
+	}
 
 	return 0;
 }
 
+static int replace_preds(struct event_subsystem *system,
+			 struct ftrace_event_call *call,
+			 struct filter_parse_state *ps,
+			 char *filter_string)
+{
+	char *operand1 = NULL, *operand2 = NULL;
+	struct filter_pred *pred;
+	struct postfix_elt *elt;
+	int err;
+
+	err = check_preds(ps);
+	if (err)
+		return err;
+
+	list_for_each_entry(elt, &ps->postfix, list) {
+		if (elt->op == OP_NONE) {
+			if (!operand1)
+				operand1 = elt->operand;
+			else if (!operand2)
+				operand2 = elt->operand;
+			else {
+				parse_error(ps, FILT_ERR_TOO_MANY_OPERANDS, 0);
+				return -EINVAL;
+			}
+			continue;
+		}
+
+		if (elt->op == OP_AND || elt->op == OP_OR) {
+			pred = create_logical_pred(elt->op);
+			if (call) {
+				err = filter_add_pred(ps, call, pred);
+				filter_free_pred(pred);
+			} else
+				err = filter_add_subsystem_pred(ps, system,
+							pred, filter_string);
+			if (err)
+				return err;
+
+			operand1 = operand2 = NULL;
+			continue;
+		}
+
+		if (!operand1 || !operand2) {
+			parse_error(ps, FILT_ERR_MISSING_FIELD, 0);
+			return -EINVAL;
+		}
+
+		pred = create_pred(elt->op, operand1, operand2);
+		if (call) {
+			err = filter_add_pred(ps, call, pred);
+			filter_free_pred(pred);
+		} else
+			err = filter_add_subsystem_pred(ps, system, pred,
+							filter_string);
+		if (err)
+			return err;
+
+		operand1 = operand2 = NULL;
+	}
+
+	return 0;
+}
+
+int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
+{
+	int err;
+
+	struct filter_parse_state *ps;
+
+	mutex_lock(&filter_mutex);
+
+	if (!strcmp(strstrip(filter_string), "0")) {
+		filter_disable_preds(call);
+		remove_filter_string(call->filter);
+		mutex_unlock(&filter_mutex);
+		return 0;
+	}
+
+	err = -ENOMEM;
+	ps = kzalloc(sizeof(*ps), GFP_KERNEL);
+	if (!ps)
+		goto out_unlock;
+
+	filter_disable_preds(call);
+	replace_filter_string(call->filter, filter_string);
+
+	parse_init(ps, filter_ops, filter_string);
+	err = filter_parse(ps);
+	if (err) {
+		append_filter_err(ps, call->filter);
+		goto out;
+	}
+
+	err = replace_preds(NULL, call, ps, filter_string);
+	if (err)
+		append_filter_err(ps, call->filter);
+
+out:
+	filter_opstack_clear(ps);
+	postfix_clear(ps);
+	kfree(ps);
+out_unlock:
+	mutex_unlock(&filter_mutex);
+
+	return err;
+}
+
+int apply_subsystem_event_filter(struct event_subsystem *system,
+				 char *filter_string)
+{
+	int err;
+
+	struct filter_parse_state *ps;
+
+	mutex_lock(&filter_mutex);
+
+	if (!strcmp(strstrip(filter_string), "0")) {
+		filter_free_subsystem_preds(system);
+		remove_filter_string(system->filter);
+		mutex_unlock(&filter_mutex);
+		return 0;
+	}
+
+	err = -ENOMEM;
+	ps = kzalloc(sizeof(*ps), GFP_KERNEL);
+	if (!ps)
+		goto out_unlock;
+
+	filter_free_subsystem_preds(system);
+	replace_filter_string(system->filter, filter_string);
+
+	parse_init(ps, filter_ops, filter_string);
+	err = filter_parse(ps);
+	if (err) {
+		append_filter_err(ps, system->filter);
+		goto out;
+	}
+
+	err = replace_preds(system, NULL, ps, filter_string);
+	if (err)
+		append_filter_err(ps, system->filter);
+
+out:
+	filter_opstack_clear(ps);
+	postfix_clear(ps);
+	kfree(ps);
+out_unlock:
+	mutex_unlock(&filter_mutex);
+
+	return err;
+}
 
diff --git a/kernel/trace/trace_events_stage_1.h b/kernel/trace/trace_events_stage_1.h
deleted file mode 100644
index 38985f9..0000000
--- a/kernel/trace/trace_events_stage_1.h
+++ /dev/null
@@ -1,39 +0,0 @@
-/*
- * Stage 1 of the trace events.
- *
- * Override the macros in <trace/trace_event_types.h> to include the following:
- *
- * struct ftrace_raw_<call> {
- *	struct trace_entry		ent;
- *	<type>				<item>;
- *	<type2>				<item2>[<len>];
- *	[...]
- * };
- *
- * The <type> <item> is created by the __field(type, item) macro or
- * the __array(type2, item2, len) macro.
- * We simply do "type item;", and that will create the fields
- * in the structure.
- */
-
-#undef TRACE_FORMAT
-#define TRACE_FORMAT(call, proto, args, fmt)
-
-#undef __array
-#define __array(type, item, len)	type	item[len];
-
-#undef __field
-#define __field(type, item)		type	item;
-
-#undef TP_STRUCT__entry
-#define TP_STRUCT__entry(args...) args
-
-#undef TRACE_EVENT
-#define TRACE_EVENT(name, proto, args, tstruct, assign, print)	\
-	struct ftrace_raw_##name {				\
-		struct trace_entry	ent;			\
-		tstruct						\
-	};							\
-	static struct ftrace_event_call event_##name
-
-#include <trace/trace_event_types.h>
diff --git a/kernel/trace/trace_events_stage_2.h b/kernel/trace/trace_events_stage_2.h
deleted file mode 100644
index d363c66..0000000
--- a/kernel/trace/trace_events_stage_2.h
+++ /dev/null
@@ -1,176 +0,0 @@
-/*
- * Stage 2 of the trace events.
- *
- * Override the macros in <trace/trace_event_types.h> to include the following:
- *
- * enum print_line_t
- * ftrace_raw_output_<call>(struct trace_iterator *iter, int flags)
- * {
- *	struct trace_seq *s = &iter->seq;
- *	struct ftrace_raw_<call> *field; <-- defined in stage 1
- *	struct trace_entry *entry;
- *	int ret;
- *
- *	entry = iter->ent;
- *
- *	if (entry->type != event_<call>.id) {
- *		WARN_ON_ONCE(1);
- *		return TRACE_TYPE_UNHANDLED;
- *	}
- *
- *	field = (typeof(field))entry;
- *
- *	ret = trace_seq_printf(s, <TP_printk> "\n");
- *	if (!ret)
- *		return TRACE_TYPE_PARTIAL_LINE;
- *
- *	return TRACE_TYPE_HANDLED;
- * }
- *
- * This is the method used to print the raw event to the trace
- * output format. Note, this is not needed if the data is read
- * in binary.
- */
-
-#undef __entry
-#define __entry field
-
-#undef TP_printk
-#define TP_printk(fmt, args...) fmt "\n", args
-
-#undef TRACE_EVENT
-#define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
-enum print_line_t							\
-ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
-{									\
-	struct trace_seq *s = &iter->seq;				\
-	struct ftrace_raw_##call *field;				\
-	struct trace_entry *entry;					\
-	int ret;							\
-									\
-	entry = iter->ent;						\
-									\
-	if (entry->type != event_##call.id) {				\
-		WARN_ON_ONCE(1);					\
-		return TRACE_TYPE_UNHANDLED;				\
-	}								\
-									\
-	field = (typeof(field))entry;					\
-									\
-	ret = trace_seq_printf(s, #call ": " print);			\
-	if (!ret)							\
-		return TRACE_TYPE_PARTIAL_LINE;				\
-									\
-	return TRACE_TYPE_HANDLED;					\
-}
-	
-#include <trace/trace_event_types.h>
-
-/*
- * Setup the showing format of trace point.
- *
- * int
- * ftrace_format_##call(struct trace_seq *s)
- * {
- *	struct ftrace_raw_##call field;
- *	int ret;
- *
- *	ret = trace_seq_printf(s, #type " " #item ";"
- *			       " offset:%u; size:%u;\n",
- *			       offsetof(struct ftrace_raw_##call, item),
- *			       sizeof(field.type));
- *
- * }
- */
-
-#undef TP_STRUCT__entry
-#define TP_STRUCT__entry(args...) args
-
-#undef __field
-#define __field(type, item)					\
-	ret = trace_seq_printf(s, "\tfield:" #type " " #item ";\t"	\
-			       "offset:%u;\tsize:%u;\n",		\
-			       (unsigned int)offsetof(typeof(field), item), \
-			       (unsigned int)sizeof(field.item));	\
-	if (!ret)							\
-		return 0;
-
-#undef __array
-#define __array(type, item, len)						\
-	ret = trace_seq_printf(s, "\tfield:" #type " " #item "[" #len "];\t"	\
-			       "offset:%u;\tsize:%u;\n",		\
-			       (unsigned int)offsetof(typeof(field), item), \
-			       (unsigned int)sizeof(field.item));	\
-	if (!ret)							\
-		return 0;
-
-#undef __entry
-#define __entry REC
-
-#undef TP_printk
-#define TP_printk(fmt, args...) "%s, %s\n", #fmt, __stringify(args)
-
-#undef TP_fast_assign
-#define TP_fast_assign(args...) args
-
-#undef TRACE_EVENT
-#define TRACE_EVENT(call, proto, args, tstruct, func, print)		\
-static int								\
-ftrace_format_##call(struct trace_seq *s)				\
-{									\
-	struct ftrace_raw_##call field;					\
-	int ret;							\
-									\
-	tstruct;							\
-									\
-	trace_seq_printf(s, "\nprint fmt: " print);			\
-									\
-	return ret;							\
-}
-
-#include <trace/trace_event_types.h>
-
-#undef __field
-#define __field(type, item)						\
-	ret = trace_define_field(event_call, #type, #item,		\
-				 offsetof(typeof(field), item),		\
-				 sizeof(field.item));			\
-	if (ret)							\
-		return ret;
-
-#undef __array
-#define __array(type, item, len)					\
-	ret = trace_define_field(event_call, #type "[" #len "]", #item,	\
-				 offsetof(typeof(field), item),		\
-				 sizeof(field.item));			\
-	if (ret)							\
-		return ret;
-
-#define __common_field(type, item)					\
-	ret = trace_define_field(event_call, #type, "common_" #item,	\
-				 offsetof(typeof(field.ent), item),	\
-				 sizeof(field.ent.item));		\
-	if (ret)							\
-		return ret;
-
-#undef TRACE_EVENT
-#define TRACE_EVENT(call, proto, args, tstruct, func, print)		\
-int									\
-ftrace_define_fields_##call(void)					\
-{									\
-	struct ftrace_raw_##call field;					\
-	struct ftrace_event_call *event_call = &event_##call;		\
-	int ret;							\
-									\
-	__common_field(unsigned char, type);				\
-	__common_field(unsigned char, flags);				\
-	__common_field(unsigned char, preempt_count);			\
-	__common_field(int, pid);					\
-	__common_field(int, tgid);					\
-									\
-	tstruct;							\
-									\
-	return ret;							\
-}
-
-#include <trace/trace_event_types.h>
diff --git a/kernel/trace/trace_events_stage_3.h b/kernel/trace/trace_events_stage_3.h
deleted file mode 100644
index 9d2fa78..0000000
--- a/kernel/trace/trace_events_stage_3.h
+++ /dev/null
@@ -1,281 +0,0 @@
-/*
- * Stage 3 of the trace events.
- *
- * Override the macros in <trace/trace_event_types.h> to include the following:
- *
- * static void ftrace_event_<call>(proto)
- * {
- *	event_trace_printk(_RET_IP_, "<call>: " <fmt>);
- * }
- *
- * static int ftrace_reg_event_<call>(void)
- * {
- *	int ret;
- *
- *	ret = register_trace_<call>(ftrace_event_<call>);
- *	if (!ret)
- *		pr_info("event trace: Could not activate trace point "
- *			"probe to  <call>");
- *	return ret;
- * }
- *
- * static void ftrace_unreg_event_<call>(void)
- * {
- *	unregister_trace_<call>(ftrace_event_<call>);
- * }
- *
- * For those macros defined with TRACE_FORMAT:
- *
- * static struct ftrace_event_call __used
- * __attribute__((__aligned__(4)))
- * __attribute__((section("_ftrace_events"))) event_<call> = {
- *	.name			= "<call>",
- *	.regfunc		= ftrace_reg_event_<call>,
- *	.unregfunc		= ftrace_unreg_event_<call>,
- * }
- *
- *
- * For those macros defined with TRACE_EVENT:
- *
- * static struct ftrace_event_call event_<call>;
- *
- * static void ftrace_raw_event_<call>(proto)
- * {
- *	struct ring_buffer_event *event;
- *	struct ftrace_raw_<call> *entry; <-- defined in stage 1
- *	unsigned long irq_flags;
- *	int pc;
- *
- *	local_save_flags(irq_flags);
- *	pc = preempt_count();
- *
- *	event = trace_current_buffer_lock_reserve(event_<call>.id,
- *				  sizeof(struct ftrace_raw_<call>),
- *				  irq_flags, pc);
- *	if (!event)
- *		return;
- *	entry	= ring_buffer_event_data(event);
- *
- *	<assign>;  <-- Here we assign the entries by the __field and
- *			__array macros.
- *
- *	trace_current_buffer_unlock_commit(event, irq_flags, pc);
- * }
- *
- * static int ftrace_raw_reg_event_<call>(void)
- * {
- *	int ret;
- *
- *	ret = register_trace_<call>(ftrace_raw_event_<call>);
- *	if (!ret)
- *		pr_info("event trace: Could not activate trace point "
- *			"probe to <call>");
- *	return ret;
- * }
- *
- * static void ftrace_unreg_event_<call>(void)
- * {
- *	unregister_trace_<call>(ftrace_raw_event_<call>);
- * }
- *
- * static struct trace_event ftrace_event_type_<call> = {
- *	.trace			= ftrace_raw_output_<call>, <-- stage 2
- * };
- *
- * static int ftrace_raw_init_event_<call>(void)
- * {
- *	int id;
- *
- *	id = register_ftrace_event(&ftrace_event_type_<call>);
- *	if (!id)
- *		return -ENODEV;
- *	event_<call>.id = id;
- *	return 0;
- * }
- *
- * static struct ftrace_event_call __used
- * __attribute__((__aligned__(4)))
- * __attribute__((section("_ftrace_events"))) event_<call> = {
- *	.name			= "<call>",
- *	.system			= "<system>",
- *	.raw_init		= ftrace_raw_init_event_<call>,
- *	.regfunc		= ftrace_reg_event_<call>,
- *	.unregfunc		= ftrace_unreg_event_<call>,
- *	.show_format		= ftrace_format_<call>,
- * }
- *
- */
-
-#undef TP_FMT
-#define TP_FMT(fmt, args...)	fmt "\n", ##args
-
-#ifdef CONFIG_EVENT_PROFILE
-#define _TRACE_PROFILE(call, proto, args)				\
-static void ftrace_profile_##call(proto)				\
-{									\
-	extern void perf_tpcounter_event(int);				\
-	perf_tpcounter_event(event_##call.id);				\
-}									\
-									\
-static int ftrace_profile_enable_##call(struct ftrace_event_call *call) \
-{									\
-	int ret = 0;							\
-									\
-	if (!atomic_inc_return(&call->profile_count))			\
-		ret = register_trace_##call(ftrace_profile_##call);	\
-									\
-	return ret;							\
-}									\
-									\
-static void ftrace_profile_disable_##call(struct ftrace_event_call *call) \
-{									\
-	if (atomic_add_negative(-1, &call->profile_count))		\
-		unregister_trace_##call(ftrace_profile_##call);		\
-}
-
-#define _TRACE_PROFILE_INIT(call)					\
-	.profile_count = ATOMIC_INIT(-1),				\
-	.profile_enable = ftrace_profile_enable_##call,			\
-	.profile_disable = ftrace_profile_disable_##call,
-
-#else
-#define _TRACE_PROFILE(call, proto, args)
-#define _TRACE_PROFILE_INIT(call)
-#endif
-
-#define _TRACE_FORMAT(call, proto, args, fmt)				\
-static void ftrace_event_##call(proto)					\
-{									\
-	event_trace_printk(_RET_IP_, #call ": " fmt);			\
-}									\
-									\
-static int ftrace_reg_event_##call(void)				\
-{									\
-	int ret;							\
-									\
-	ret = register_trace_##call(ftrace_event_##call);		\
-	if (ret)							\
-		pr_info("event trace: Could not activate trace point "	\
-			"probe to " #call "\n");			\
-	return ret;							\
-}									\
-									\
-static void ftrace_unreg_event_##call(void)				\
-{									\
-	unregister_trace_##call(ftrace_event_##call);			\
-}									\
-									\
-static struct ftrace_event_call event_##call;				\
-									\
-static int ftrace_init_event_##call(void)				\
-{									\
-	int id;								\
-									\
-	id = register_ftrace_event(NULL);				\
-	if (!id)							\
-		return -ENODEV;						\
-	event_##call.id = id;						\
-	return 0;							\
-}
-
-#undef TRACE_FORMAT
-#define TRACE_FORMAT(call, proto, args, fmt)				\
-_TRACE_FORMAT(call, PARAMS(proto), PARAMS(args), PARAMS(fmt))		\
-_TRACE_PROFILE(call, PARAMS(proto), PARAMS(args))			\
-static struct ftrace_event_call __used					\
-__attribute__((__aligned__(4)))						\
-__attribute__((section("_ftrace_events"))) event_##call = {		\
-	.name			= #call,				\
-	.system			= __stringify(TRACE_SYSTEM),		\
-	.raw_init		= ftrace_init_event_##call,		\
-	.regfunc		= ftrace_reg_event_##call,		\
-	.unregfunc		= ftrace_unreg_event_##call,		\
-	_TRACE_PROFILE_INIT(call)					\
-}
-
-#undef __entry
-#define __entry entry
-
-#undef TRACE_EVENT
-#define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
-_TRACE_PROFILE(call, PARAMS(proto), PARAMS(args))			\
-									\
-static struct ftrace_event_call event_##call;				\
-									\
-static void ftrace_raw_event_##call(proto)				\
-{									\
-	struct ftrace_event_call *call = &event_##call;			\
-	struct ring_buffer_event *event;				\
-	struct ftrace_raw_##call *entry;				\
-	unsigned long irq_flags;					\
-	int pc;								\
-									\
-	local_save_flags(irq_flags);					\
-	pc = preempt_count();						\
-									\
-	event = trace_current_buffer_lock_reserve(event_##call.id,	\
-				  sizeof(struct ftrace_raw_##call),	\
-				  irq_flags, pc);			\
-	if (!event)							\
-		return;							\
-	entry	= ring_buffer_event_data(event);			\
-									\
-	assign;								\
-									\
-	if (call->preds && !filter_match_preds(call, entry))		\
-		ring_buffer_event_discard(event);			\
-									\
-	trace_nowake_buffer_unlock_commit(event, irq_flags, pc);	\
-									\
-}									\
-									\
-static int ftrace_raw_reg_event_##call(void)				\
-{									\
-	int ret;							\
-									\
-	ret = register_trace_##call(ftrace_raw_event_##call);		\
-	if (ret)							\
-		pr_info("event trace: Could not activate trace point "	\
-			"probe to " #call "\n");			\
-	return ret;							\
-}									\
-									\
-static void ftrace_raw_unreg_event_##call(void)				\
-{									\
-	unregister_trace_##call(ftrace_raw_event_##call);		\
-}									\
-									\
-static struct trace_event ftrace_event_type_##call = {			\
-	.trace			= ftrace_raw_output_##call,		\
-};									\
-									\
-static int ftrace_raw_init_event_##call(void)				\
-{									\
-	int id;								\
-									\
-	id = register_ftrace_event(&ftrace_event_type_##call);		\
-	if (!id)							\
-		return -ENODEV;						\
-	event_##call.id = id;						\
-	INIT_LIST_HEAD(&event_##call.fields);				\
-	return 0;							\
-}									\
-									\
-static struct ftrace_event_call __used					\
-__attribute__((__aligned__(4)))						\
-__attribute__((section("_ftrace_events"))) event_##call = {		\
-	.name			= #call,				\
-	.system			= __stringify(TRACE_SYSTEM),		\
-	.raw_init		= ftrace_raw_init_event_##call,		\
-	.regfunc		= ftrace_raw_reg_event_##call,		\
-	.unregfunc		= ftrace_raw_unreg_event_##call,	\
-	.show_format		= ftrace_format_##call,			\
-	.define_fields		= ftrace_define_fields_##call,		\
-	_TRACE_PROFILE_INIT(call)					\
-}
-
-#include <trace/trace_event_types.h>
-
-#undef _TRACE_PROFILE
-#undef _TRACE_PROFILE_INIT
-
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index 07a22c3..d06cf89 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -19,8 +19,12 @@
 #undef TRACE_STRUCT
 #define TRACE_STRUCT(args...) args
 
+extern void __bad_type_size(void);
+
 #undef TRACE_FIELD
 #define TRACE_FIELD(type, item, assign)					\
+	if (sizeof(type) != sizeof(field.item))				\
+		__bad_type_size();					\
 	ret = trace_seq_printf(s, "\tfield:" #type " " #item ";\t"	\
 			       "offset:%u;\tsize:%u;\n",		\
 			       (unsigned int)offsetof(typeof(field), item), \
@@ -30,7 +34,7 @@
 
 
 #undef TRACE_FIELD_SPECIAL
-#define TRACE_FIELD_SPECIAL(type_item, item, cmd)			\
+#define TRACE_FIELD_SPECIAL(type_item, item, len, cmd)			\
 	ret = trace_seq_printf(s, "\tfield special:" #type_item ";\t"	\
 			       "offset:%u;\tsize:%u;\n",		\
 			       (unsigned int)offsetof(typeof(field), item), \
@@ -46,6 +50,9 @@
 	if (!ret)							\
 		return 0;
 
+#undef TRACE_FIELD_SIGN
+#define TRACE_FIELD_SIGN(type, item, assign, is_signed)	\
+	TRACE_FIELD(type, item, assign)
 
 #undef TP_RAW_FMT
 #define TP_RAW_FMT(args...) args
@@ -65,6 +72,22 @@ ftrace_format_##call(struct trace_seq *s)				\
 	return ret;							\
 }
 
+#undef TRACE_EVENT_FORMAT_NOFILTER
+#define TRACE_EVENT_FORMAT_NOFILTER(call, proto, args, fmt, tstruct,	\
+				    tpfmt)				\
+static int								\
+ftrace_format_##call(struct trace_seq *s)				\
+{									\
+	struct args field;						\
+	int ret;							\
+									\
+	tstruct;							\
+									\
+	trace_seq_printf(s, "\nprint fmt: \"%s\"\n", tpfmt);		\
+									\
+	return ret;							\
+}
+
 #include "trace_event_types.h"
 
 #undef TRACE_ZERO_CHAR
@@ -78,6 +101,10 @@ ftrace_format_##call(struct trace_seq *s)				\
 #define TRACE_FIELD(type, item, assign)\
 	entry->item = assign;
 
+#undef TRACE_FIELD_SIGN
+#define TRACE_FIELD_SIGN(type, item, assign, is_signed)	\
+	TRACE_FIELD(type, item, assign)
+
 #undef TP_CMD
 #define TP_CMD(cmd...)	cmd
 
@@ -85,18 +112,95 @@ ftrace_format_##call(struct trace_seq *s)				\
 #define TRACE_ENTRY	entry
 
 #undef TRACE_FIELD_SPECIAL
-#define TRACE_FIELD_SPECIAL(type_item, item, cmd) \
+#define TRACE_FIELD_SPECIAL(type_item, item, len, cmd)	\
 	cmd;
 
 #undef TRACE_EVENT_FORMAT
 #define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
+int ftrace_define_fields_##call(void);					\
+static int ftrace_raw_init_event_##call(void);				\
+									\
+struct ftrace_event_call __used						\
+__attribute__((__aligned__(4)))						\
+__attribute__((section("_ftrace_events"))) event_##call = {		\
+	.name			= #call,				\
+	.id			= proto,				\
+	.system			= __stringify(TRACE_SYSTEM),		\
+	.raw_init		= ftrace_raw_init_event_##call,		\
+	.show_format		= ftrace_format_##call,			\
+	.define_fields		= ftrace_define_fields_##call,		\
+};									\
+static int ftrace_raw_init_event_##call(void)				\
+{									\
+	INIT_LIST_HEAD(&event_##call.fields);				\
+	init_preds(&event_##call);					\
+	return 0;							\
+}									\
+
+#undef TRACE_EVENT_FORMAT_NOFILTER
+#define TRACE_EVENT_FORMAT_NOFILTER(call, proto, args, fmt, tstruct,	\
+				    tpfmt)				\
 									\
-static struct ftrace_event_call __used					\
+struct ftrace_event_call __used						\
 __attribute__((__aligned__(4)))						\
 __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.name			= #call,				\
 	.id			= proto,				\
 	.system			= __stringify(TRACE_SYSTEM),		\
 	.show_format		= ftrace_format_##call,			\
+};
+
+#include "trace_event_types.h"
+
+#undef TRACE_FIELD
+#define TRACE_FIELD(type, item, assign)					\
+	ret = trace_define_field(event_call, #type, #item,		\
+				 offsetof(typeof(field), item),		\
+				 sizeof(field.item), is_signed_type(type));	\
+	if (ret)							\
+		return ret;
+
+#undef TRACE_FIELD_SPECIAL
+#define TRACE_FIELD_SPECIAL(type, item, len, cmd)			\
+	ret = trace_define_field(event_call, #type "[" #len "]", #item,	\
+				 offsetof(typeof(field), item),		\
+				 sizeof(field.item), 0);		\
+	if (ret)							\
+		return ret;
+
+#undef TRACE_FIELD_SIGN
+#define TRACE_FIELD_SIGN(type, item, assign, is_signed)			\
+	ret = trace_define_field(event_call, #type, #item,		\
+				 offsetof(typeof(field), item),		\
+				 sizeof(field.item), is_signed);	\
+	if (ret)							\
+		return ret;
+
+#undef TRACE_FIELD_ZERO_CHAR
+#define TRACE_FIELD_ZERO_CHAR(item)
+
+#undef TRACE_EVENT_FORMAT
+#define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
+int									\
+ftrace_define_fields_##call(void)					\
+{									\
+	struct ftrace_event_call *event_call = &event_##call;		\
+	struct args field;						\
+	int ret;							\
+									\
+	__common_field(unsigned char, type, 0);				\
+	__common_field(unsigned char, flags, 0);			\
+	__common_field(unsigned char, preempt_count, 0);		\
+	__common_field(int, pid, 1);					\
+	__common_field(int, tgid, 1);					\
+									\
+	tstruct;							\
+									\
+	return ret;							\
 }
+
+#undef TRACE_EVENT_FORMAT_NOFILTER
+#define TRACE_EVENT_FORMAT_NOFILTER(call, proto, args, fmt, tstruct,	\
+				    tpfmt)
+
 #include "trace_event_types.h"
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index d28687e..10f6ad7 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -78,13 +78,14 @@ ftrace_push_return_trace(unsigned long ret, unsigned long func, int *depth)
 	current->ret_stack[index].ret = ret;
 	current->ret_stack[index].func = func;
 	current->ret_stack[index].calltime = calltime;
+	current->ret_stack[index].subtime = 0;
 	*depth = index;
 
 	return 0;
 }
 
 /* Retrieve a function return address to the trace stack on thread info.*/
-void
+static void
 ftrace_pop_return_trace(struct ftrace_graph_ret *trace, unsigned long *ret)
 {
 	int index;
@@ -104,9 +105,6 @@ ftrace_pop_return_trace(struct ftrace_graph_ret *trace, unsigned long *ret)
 	trace->calltime = current->ret_stack[index].calltime;
 	trace->overrun = atomic_read(&current->trace_overrun);
 	trace->depth = index;
-	barrier();
-	current->curr_ret_stack--;
-
 }
 
 /*
@@ -121,6 +119,8 @@ unsigned long ftrace_return_to_handler(void)
 	ftrace_pop_return_trace(&trace, &ret);
 	trace.rettime = trace_clock_local();
 	ftrace_graph_return(&trace);
+	barrier();
+	current->curr_ret_stack--;
 
 	if (unlikely(!ret)) {
 		ftrace_graph_stop();
@@ -426,8 +426,8 @@ print_graph_irq(struct trace_iterator *iter, unsigned long addr,
 	return TRACE_TYPE_HANDLED;
 }
 
-static enum print_line_t
-print_graph_duration(unsigned long long duration, struct trace_seq *s)
+enum print_line_t
+trace_print_graph_duration(unsigned long long duration, struct trace_seq *s)
 {
 	unsigned long nsecs_rem = do_div(duration, 1000);
 	/* log10(ULONG_MAX) + '\0' */
@@ -464,12 +464,23 @@ print_graph_duration(unsigned long long duration, struct trace_seq *s)
 		if (!ret)
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
+	return TRACE_TYPE_HANDLED;
+}
+
+static enum print_line_t
+print_graph_duration(unsigned long long duration, struct trace_seq *s)
+{
+	int ret;
+
+	ret = trace_print_graph_duration(duration, s);
+	if (ret != TRACE_TYPE_HANDLED)
+		return ret;
 
 	ret = trace_seq_printf(s, "|  ");
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
-	return TRACE_TYPE_HANDLED;
 
+	return TRACE_TYPE_HANDLED;
 }
 
 /* Case of a leaf function on its call entry */
diff --git a/kernel/trace/trace_hw_branches.c b/kernel/trace/trace_hw_branches.c
index 7bfdf4c..ca7d7c4 100644
--- a/kernel/trace/trace_hw_branches.c
+++ b/kernel/trace/trace_hw_branches.c
@@ -1,10 +1,9 @@
 /*
- * h/w branch tracer for x86 based on bts
+ * h/w branch tracer for x86 based on BTS
  *
  * Copyright (C) 2008-2009 Intel Corporation.
  * Markus Metzger <markus.t.metzger@gmail.com>, 2008-2009
  */
-#include <linux/spinlock.h>
 #include <linux/kallsyms.h>
 #include <linux/debugfs.h>
 #include <linux/ftrace.h>
@@ -15,110 +14,119 @@
 
 #include <asm/ds.h>
 
-#include "trace.h"
 #include "trace_output.h"
+#include "trace.h"
 
 
-#define SIZEOF_BTS (1 << 13)
+#define BTS_BUFFER_SIZE (1 << 13)
 
-/*
- * The tracer lock protects the below per-cpu tracer array.
- * It needs to be held to:
- * - start tracing on all cpus
- * - stop tracing on all cpus
- * - start tracing on a single hotplug cpu
- * - stop tracing on a single hotplug cpu
- * - read the trace from all cpus
- * - read the trace from a single cpu
- */
-static DEFINE_SPINLOCK(bts_tracer_lock);
 static DEFINE_PER_CPU(struct bts_tracer *, tracer);
-static DEFINE_PER_CPU(unsigned char[SIZEOF_BTS], buffer);
+static DEFINE_PER_CPU(unsigned char[BTS_BUFFER_SIZE], buffer);
 
 #define this_tracer per_cpu(tracer, smp_processor_id())
-#define this_buffer per_cpu(buffer, smp_processor_id())
 
-static int __read_mostly trace_hw_branches_enabled;
+static int trace_hw_branches_enabled __read_mostly;
+static int trace_hw_branches_suspended __read_mostly;
 static struct trace_array *hw_branch_trace __read_mostly;
 
 
-/*
- * Start tracing on the current cpu.
- * The argument is ignored.
- *
- * pre: bts_tracer_lock must be locked.
- */
-static void bts_trace_start_cpu(void *arg)
+static void bts_trace_init_cpu(int cpu)
 {
-	if (this_tracer)
-		ds_release_bts(this_tracer);
-
-	this_tracer =
-		ds_request_bts(/* task = */ NULL, this_buffer, SIZEOF_BTS,
-			       /* ovfl = */ NULL, /* th = */ (size_t)-1,
-			       BTS_KERNEL);
-	if (IS_ERR(this_tracer)) {
-		this_tracer = NULL;
-		return;
-	}
+	per_cpu(tracer, cpu) =
+		ds_request_bts_cpu(cpu, per_cpu(buffer, cpu), BTS_BUFFER_SIZE,
+				   NULL, (size_t)-1, BTS_KERNEL);
+
+	if (IS_ERR(per_cpu(tracer, cpu)))
+		per_cpu(tracer, cpu) = NULL;
 }
 
-static void bts_trace_start(struct trace_array *tr)
+static int bts_trace_init(struct trace_array *tr)
 {
-	spin_lock(&bts_tracer_lock);
+	int cpu;
+
+	hw_branch_trace = tr;
+	trace_hw_branches_enabled = 0;
 
-	on_each_cpu(bts_trace_start_cpu, NULL, 1);
-	trace_hw_branches_enabled = 1;
+	get_online_cpus();
+	for_each_online_cpu(cpu) {
+		bts_trace_init_cpu(cpu);
 
-	spin_unlock(&bts_tracer_lock);
+		if (likely(per_cpu(tracer, cpu)))
+			trace_hw_branches_enabled = 1;
+	}
+	trace_hw_branches_suspended = 0;
+	put_online_cpus();
+
+	/* If we could not enable tracing on a single cpu, we fail. */
+	return trace_hw_branches_enabled ? 0 : -EOPNOTSUPP;
 }
 
-/*
- * Stop tracing on the current cpu.
- * The argument is ignored.
- *
- * pre: bts_tracer_lock must be locked.
- */
-static void bts_trace_stop_cpu(void *arg)
+static void bts_trace_reset(struct trace_array *tr)
 {
-	if (this_tracer) {
-		ds_release_bts(this_tracer);
-		this_tracer = NULL;
+	int cpu;
+
+	get_online_cpus();
+	for_each_online_cpu(cpu) {
+		if (likely(per_cpu(tracer, cpu))) {
+			ds_release_bts(per_cpu(tracer, cpu));
+			per_cpu(tracer, cpu) = NULL;
+		}
 	}
+	trace_hw_branches_enabled = 0;
+	trace_hw_branches_suspended = 0;
+	put_online_cpus();
 }
 
-static void bts_trace_stop(struct trace_array *tr)
+static void bts_trace_start(struct trace_array *tr)
 {
-	spin_lock(&bts_tracer_lock);
+	int cpu;
 
-	trace_hw_branches_enabled = 0;
-	on_each_cpu(bts_trace_stop_cpu, NULL, 1);
+	get_online_cpus();
+	for_each_online_cpu(cpu)
+		if (likely(per_cpu(tracer, cpu)))
+			ds_resume_bts(per_cpu(tracer, cpu));
+	trace_hw_branches_suspended = 0;
+	put_online_cpus();
+}
 
-	spin_unlock(&bts_tracer_lock);
+static void bts_trace_stop(struct trace_array *tr)
+{
+	int cpu;
+
+	get_online_cpus();
+	for_each_online_cpu(cpu)
+		if (likely(per_cpu(tracer, cpu)))
+			ds_suspend_bts(per_cpu(tracer, cpu));
+	trace_hw_branches_suspended = 1;
+	put_online_cpus();
 }
 
 static int __cpuinit bts_hotcpu_handler(struct notifier_block *nfb,
 				     unsigned long action, void *hcpu)
 {
-	unsigned int cpu = (unsigned long)hcpu;
-
-	spin_lock(&bts_tracer_lock);
-
-	if (!trace_hw_branches_enabled)
-		goto out;
+	int cpu = (long)hcpu;
 
 	switch (action) {
 	case CPU_ONLINE:
 	case CPU_DOWN_FAILED:
-		smp_call_function_single(cpu, bts_trace_start_cpu, NULL, 1);
+		/* The notification is sent with interrupts enabled. */
+		if (trace_hw_branches_enabled) {
+			bts_trace_init_cpu(cpu);
+
+			if (trace_hw_branches_suspended &&
+			    likely(per_cpu(tracer, cpu)))
+				ds_suspend_bts(per_cpu(tracer, cpu));
+		}
 		break;
+
 	case CPU_DOWN_PREPARE:
-		smp_call_function_single(cpu, bts_trace_stop_cpu, NULL, 1);
-		break;
+		/* The notification is sent with interrupts enabled. */
+		if (likely(per_cpu(tracer, cpu))) {
+			ds_release_bts(per_cpu(tracer, cpu));
+			per_cpu(tracer, cpu) = NULL;
+		}
 	}
 
- out:
-	spin_unlock(&bts_tracer_lock);
 	return NOTIFY_DONE;
 }
 
@@ -126,20 +134,6 @@ static struct notifier_block bts_hotcpu_notifier __cpuinitdata = {
 	.notifier_call = bts_hotcpu_handler
 };
 
-static int bts_trace_init(struct trace_array *tr)
-{
-	hw_branch_trace = tr;
-
-	bts_trace_start(tr);
-
-	return 0;
-}
-
-static void bts_trace_reset(struct trace_array *tr)
-{
-	bts_trace_stop(tr);
-}
-
 static void bts_trace_print_header(struct seq_file *m)
 {
 	seq_puts(m, "# CPU#        TO  <-  FROM\n");
@@ -147,10 +141,10 @@ static void bts_trace_print_header(struct seq_file *m)
 
 static enum print_line_t bts_trace_print_line(struct trace_iterator *iter)
 {
+	unsigned long symflags = TRACE_ITER_SYM_OFFSET;
 	struct trace_entry *entry = iter->ent;
 	struct trace_seq *seq = &iter->seq;
 	struct hw_branch_entry *it;
-	unsigned long symflags = TRACE_ITER_SYM_OFFSET;
 
 	trace_assign_type(it, entry);
 
@@ -168,6 +162,7 @@ static enum print_line_t bts_trace_print_line(struct trace_iterator *iter)
 
 void trace_hw_branch(u64 from, u64 to)
 {
+	struct ftrace_event_call *call = &event_hw_branch;
 	struct trace_array *tr = hw_branch_trace;
 	struct ring_buffer_event *event;
 	struct hw_branch_entry *entry;
@@ -194,7 +189,8 @@ void trace_hw_branch(u64 from, u64 to)
 	entry->ent.type = TRACE_HW_BRANCHES;
 	entry->from = from;
 	entry->to   = to;
-	trace_buffer_unlock_commit(tr, event, 0, 0);
+	if (!filter_check_discard(call, entry, tr->buffer, event))
+		trace_buffer_unlock_commit(tr, event, 0, 0);
 
  out:
 	atomic_dec(&tr->data[cpu]->disabled);
@@ -224,11 +220,11 @@ static void trace_bts_at(const struct bts_trace *trace, void *at)
 /*
  * Collect the trace on the current cpu and write it into the ftrace buffer.
  *
- * pre: bts_tracer_lock must be locked
+ * pre: tracing must be suspended on the current cpu
  */
 static void trace_bts_cpu(void *arg)
 {
-	struct trace_array *tr = (struct trace_array *) arg;
+	struct trace_array *tr = (struct trace_array *)arg;
 	const struct bts_trace *trace;
 	unsigned char *at;
 
@@ -241,10 +237,9 @@ static void trace_bts_cpu(void *arg)
 	if (unlikely(!this_tracer))
 		return;
 
-	ds_suspend_bts(this_tracer);
 	trace = ds_read_bts(this_tracer);
 	if (!trace)
-		goto out;
+		return;
 
 	for (at = trace->ds.top; (void *)at < trace->ds.end;
 	     at += trace->ds.size)
@@ -253,18 +248,27 @@ static void trace_bts_cpu(void *arg)
 	for (at = trace->ds.begin; (void *)at < trace->ds.top;
 	     at += trace->ds.size)
 		trace_bts_at(trace, at);
-
-out:
-	ds_resume_bts(this_tracer);
 }
 
 static void trace_bts_prepare(struct trace_iterator *iter)
 {
-	spin_lock(&bts_tracer_lock);
+	int cpu;
 
+	get_online_cpus();
+	for_each_online_cpu(cpu)
+		if (likely(per_cpu(tracer, cpu)))
+			ds_suspend_bts(per_cpu(tracer, cpu));
+	/*
+	 * We need to collect the trace on the respective cpu since ftrace
+	 * implicitly adds the record for the current cpu.
+	 * Once that is more flexible, we could collect the data from any cpu.
+	 */
 	on_each_cpu(trace_bts_cpu, iter->tr, 1);
 
-	spin_unlock(&bts_tracer_lock);
+	for_each_online_cpu(cpu)
+		if (likely(per_cpu(tracer, cpu)))
+			ds_resume_bts(per_cpu(tracer, cpu));
+	put_online_cpus();
 }
 
 static void trace_bts_close(struct trace_iterator *iter)
@@ -274,11 +278,11 @@ static void trace_bts_close(struct trace_iterator *iter)
 
 void trace_hw_branch_oops(void)
 {
-	spin_lock(&bts_tracer_lock);
-
-	trace_bts_cpu(hw_branch_trace);
-
-	spin_unlock(&bts_tracer_lock);
+	if (this_tracer) {
+		ds_suspend_bts_noirq(this_tracer);
+		trace_bts_cpu(hw_branch_trace);
+		ds_resume_bts_noirq(this_tracer);
+	}
 }
 
 struct tracer bts_tracer __read_mostly =
@@ -291,7 +295,10 @@ struct tracer bts_tracer __read_mostly =
 	.start		= bts_trace_start,
 	.stop		= bts_trace_stop,
 	.open		= trace_bts_prepare,
-	.close		= trace_bts_close
+	.close		= trace_bts_close,
+#ifdef CONFIG_FTRACE_SELFTEST
+	.selftest	= trace_selftest_startup_hw_branches,
+#endif /* CONFIG_FTRACE_SELFTEST */
 };
 
 __init static int init_bts_trace(void)
diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index 8e37fcd..d53b45e 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -9,6 +9,8 @@
 #include <linux/kernel.h>
 #include <linux/mmiotrace.h>
 #include <linux/pci.h>
+#include <linux/time.h>
+
 #include <asm/atomic.h>
 
 #include "trace.h"
@@ -174,7 +176,7 @@ static enum print_line_t mmio_print_rw(struct trace_iterator *iter)
 	struct mmiotrace_rw *rw;
 	struct trace_seq *s	= &iter->seq;
 	unsigned long long t	= ns2usecs(iter->ts);
-	unsigned long usec_rem	= do_div(t, 1000000ULL);
+	unsigned long usec_rem	= do_div(t, USEC_PER_SEC);
 	unsigned secs		= (unsigned long)t;
 	int ret = 1;
 
@@ -221,7 +223,7 @@ static enum print_line_t mmio_print_map(struct trace_iterator *iter)
 	struct mmiotrace_map *m;
 	struct trace_seq *s	= &iter->seq;
 	unsigned long long t	= ns2usecs(iter->ts);
-	unsigned long usec_rem	= do_div(t, 1000000ULL);
+	unsigned long usec_rem	= do_div(t, USEC_PER_SEC);
 	unsigned secs		= (unsigned long)t;
 	int ret;
 
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 64b54a5..7938f3a 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -14,11 +14,25 @@
 /* must be a power of 2 */
 #define EVENT_HASHSIZE	128
 
-static DEFINE_MUTEX(trace_event_mutex);
+DECLARE_RWSEM(trace_event_mutex);
+
+DEFINE_PER_CPU(struct trace_seq, ftrace_event_seq);
+EXPORT_PER_CPU_SYMBOL(ftrace_event_seq);
+
 static struct hlist_head event_hash[EVENT_HASHSIZE] __read_mostly;
 
 static int next_event_type = __TRACE_LAST_TYPE + 1;
 
+void trace_print_seq(struct seq_file *m, struct trace_seq *s)
+{
+	int len = s->len >= PAGE_SIZE ? PAGE_SIZE - 1 : s->len;
+
+	s->buffer[len] = 0;
+	seq_puts(m, s->buffer);
+
+	trace_seq_init(s);
+}
+
 enum print_line_t trace_print_bprintk_msg_only(struct trace_iterator *iter)
 {
 	struct trace_seq *s = &iter->seq;
@@ -84,6 +98,39 @@ trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
 
 	return len;
 }
+EXPORT_SYMBOL_GPL(trace_seq_printf);
+
+/**
+ * trace_seq_vprintf - sequence printing of trace information
+ * @s: trace sequence descriptor
+ * @fmt: printf format string
+ *
+ * The tracer may use either sequence operations or its own
+ * copy to user routines. To simplify formating of a trace
+ * trace_seq_printf is used to store strings into a special
+ * buffer (@s). Then the output may be either used by
+ * the sequencer or pulled into another buffer.
+ */
+int
+trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args)
+{
+	int len = (PAGE_SIZE - 1) - s->len;
+	int ret;
+
+	if (!len)
+		return 0;
+
+	ret = vsnprintf(s->buffer + s->len, len, fmt, args);
+
+	/* If we can't write it all, don't bother writing anything */
+	if (ret >= len)
+		return 0;
+
+	s->len += ret;
+
+	return len;
+}
+EXPORT_SYMBOL_GPL(trace_seq_vprintf);
 
 int trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary)
 {
@@ -201,6 +248,67 @@ int trace_seq_path(struct trace_seq *s, struct path *path)
 	return 0;
 }
 
+const char *
+ftrace_print_flags_seq(struct trace_seq *p, const char *delim,
+		       unsigned long flags,
+		       const struct trace_print_flags *flag_array)
+{
+	unsigned long mask;
+	const char *str;
+	const char *ret = p->buffer + p->len;
+	int i;
+
+	for (i = 0;  flag_array[i].name && flags; i++) {
+
+		mask = flag_array[i].mask;
+		if ((flags & mask) != mask)
+			continue;
+
+		str = flag_array[i].name;
+		flags &= ~mask;
+		if (p->len && delim)
+			trace_seq_puts(p, delim);
+		trace_seq_puts(p, str);
+	}
+
+	/* check for left over flags */
+	if (flags) {
+		if (p->len && delim)
+			trace_seq_puts(p, delim);
+		trace_seq_printf(p, "0x%lx", flags);
+	}
+
+	trace_seq_putc(p, 0);
+
+	return ret;
+}
+EXPORT_SYMBOL(ftrace_print_flags_seq);
+
+const char *
+ftrace_print_symbols_seq(struct trace_seq *p, unsigned long val,
+			 const struct trace_print_flags *symbol_array)
+{
+	int i;
+	const char *ret = p->buffer + p->len;
+
+	for (i = 0;  symbol_array[i].name; i++) {
+
+		if (val != symbol_array[i].mask)
+			continue;
+
+		trace_seq_puts(p, symbol_array[i].name);
+		break;
+	}
+
+	if (!p->len)
+		trace_seq_printf(p, "0x%lx", val);
+		
+	trace_seq_putc(p, 0);
+
+	return ret;
+}
+EXPORT_SYMBOL(ftrace_print_symbols_seq);
+
 #ifdef CONFIG_KRETPROBES
 static inline const char *kretprobed(const char *name)
 {
@@ -311,17 +419,20 @@ seq_print_userip_objs(const struct userstack_entry *entry, struct trace_seq *s,
 
 		if (ip == ULONG_MAX || !ret)
 			break;
-		if (i && ret)
-			ret = trace_seq_puts(s, " <- ");
+		if (ret)
+			ret = trace_seq_puts(s, " => ");
 		if (!ip) {
 			if (ret)
 				ret = trace_seq_puts(s, "??");
+			if (ret)
+				ret = trace_seq_puts(s, "\n");
 			continue;
 		}
 		if (!ret)
 			break;
 		if (ret)
 			ret = seq_print_user_ip(s, mm, ip, sym_flags);
+		ret = trace_seq_puts(s, "\n");
 	}
 
 	if (mm)
@@ -455,6 +566,7 @@ static int task_state_char(unsigned long state)
  * @type: the type of event to look for
  *
  * Returns an event of type @type otherwise NULL
+ * Called with trace_event_read_lock() held.
  */
 struct trace_event *ftrace_find_event(int type)
 {
@@ -464,7 +576,7 @@ struct trace_event *ftrace_find_event(int type)
 
 	key = type & (EVENT_HASHSIZE - 1);
 
-	hlist_for_each_entry_rcu(event, n, &event_hash[key], node) {
+	hlist_for_each_entry(event, n, &event_hash[key], node) {
 		if (event->type == type)
 			return event;
 	}
@@ -472,6 +584,46 @@ struct trace_event *ftrace_find_event(int type)
 	return NULL;
 }
 
+static LIST_HEAD(ftrace_event_list);
+
+static int trace_search_list(struct list_head **list)
+{
+	struct trace_event *e;
+	int last = __TRACE_LAST_TYPE;
+
+	if (list_empty(&ftrace_event_list)) {
+		*list = &ftrace_event_list;
+		return last + 1;
+	}
+
+	/*
+	 * We used up all possible max events,
+	 * lets see if somebody freed one.
+	 */
+	list_for_each_entry(e, &ftrace_event_list, list) {
+		if (e->type != last + 1)
+			break;
+		last++;
+	}
+
+	/* Did we used up all 65 thousand events??? */
+	if ((last + 1) > FTRACE_MAX_EVENT)
+		return 0;
+
+	*list = &e->list;
+	return last + 1;
+}
+
+void trace_event_read_lock(void)
+{
+	down_read(&trace_event_mutex);
+}
+
+void trace_event_read_unlock(void)
+{
+	up_read(&trace_event_mutex);
+}
+
 /**
  * register_ftrace_event - register output for an event type
  * @event: the event type to register
@@ -492,22 +644,42 @@ int register_ftrace_event(struct trace_event *event)
 	unsigned key;
 	int ret = 0;
 
-	mutex_lock(&trace_event_mutex);
+	down_write(&trace_event_mutex);
 
-	if (!event) {
-		ret = next_event_type++;
+	if (WARN_ON(!event))
 		goto out;
-	}
 
-	if (!event->type)
-		event->type = next_event_type++;
-	else if (event->type > __TRACE_LAST_TYPE) {
+	INIT_LIST_HEAD(&event->list);
+
+	if (!event->type) {
+		struct list_head *list = NULL;
+
+		if (next_event_type > FTRACE_MAX_EVENT) {
+
+			event->type = trace_search_list(&list);
+			if (!event->type)
+				goto out;
+
+		} else {
+			
+			event->type = next_event_type++;
+			list = &ftrace_event_list;
+		}
+
+		if (WARN_ON(ftrace_find_event(event->type)))
+			goto out;
+
+		list_add_tail(&event->list, list);
+
+	} else if (event->type > __TRACE_LAST_TYPE) {
 		printk(KERN_WARNING "Need to add type to trace.h\n");
 		WARN_ON(1);
-	}
-
-	if (ftrace_find_event(event->type))
 		goto out;
+	} else {
+		/* Is this event already used */
+		if (ftrace_find_event(event->type))
+			goto out;
+	}
 
 	if (event->trace == NULL)
 		event->trace = trace_nop_print;
@@ -520,14 +692,25 @@ int register_ftrace_event(struct trace_event *event)
 
 	key = event->type & (EVENT_HASHSIZE - 1);
 
-	hlist_add_head_rcu(&event->node, &event_hash[key]);
+	hlist_add_head(&event->node, &event_hash[key]);
 
 	ret = event->type;
  out:
-	mutex_unlock(&trace_event_mutex);
+	up_write(&trace_event_mutex);
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(register_ftrace_event);
+
+/*
+ * Used by module code with the trace_event_mutex held for write.
+ */
+int __unregister_ftrace_event(struct trace_event *event)
+{
+	hlist_del(&event->node);
+	list_del(&event->list);
+	return 0;
+}
 
 /**
  * unregister_ftrace_event - remove a no longer used event
@@ -535,12 +718,13 @@ int register_ftrace_event(struct trace_event *event)
  */
 int unregister_ftrace_event(struct trace_event *event)
 {
-	mutex_lock(&trace_event_mutex);
-	hlist_del(&event->node);
-	mutex_unlock(&trace_event_mutex);
+	down_write(&trace_event_mutex);
+	__unregister_ftrace_event(event);
+	up_write(&trace_event_mutex);
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(unregister_ftrace_event);
 
 /*
  * Standard events
@@ -833,14 +1017,16 @@ static enum print_line_t trace_stack_print(struct trace_iterator *iter,
 
 	trace_assign_type(field, iter->ent);
 
+	if (!trace_seq_puts(s, "<stack trace>\n"))
+		goto partial;
 	for (i = 0; i < FTRACE_STACK_ENTRIES; i++) {
-		if (i) {
-			if (!trace_seq_puts(s, " <= "))
-				goto partial;
+		if (!field->caller[i] || (field->caller[i] == ULONG_MAX))
+			break;
+		if (!trace_seq_puts(s, " => "))
+			goto partial;
 
-			if (!seq_print_ip_sym(s, field->caller[i], flags))
-				goto partial;
-		}
+		if (!seq_print_ip_sym(s, field->caller[i], flags))
+			goto partial;
 		if (!trace_seq_puts(s, "\n"))
 			goto partial;
 	}
@@ -868,10 +1054,10 @@ static enum print_line_t trace_user_stack_print(struct trace_iterator *iter,
 
 	trace_assign_type(field, iter->ent);
 
-	if (!seq_print_userip_objs(field, s, flags))
+	if (!trace_seq_puts(s, "<user stack trace>\n"))
 		goto partial;
 
-	if (!trace_seq_putc(s, '\n'))
+	if (!seq_print_userip_objs(field, s, flags))
 		goto partial;
 
 	return TRACE_TYPE_HANDLED;
diff --git a/kernel/trace/trace_output.h b/kernel/trace/trace_output.h
index e0bde39..d38bec4 100644
--- a/kernel/trace/trace_output.h
+++ b/kernel/trace/trace_output.h
@@ -1,41 +1,17 @@
 #ifndef __TRACE_EVENTS_H
 #define __TRACE_EVENTS_H
 
+#include <linux/trace_seq.h>
 #include "trace.h"
 
-typedef enum print_line_t (*trace_print_func)(struct trace_iterator *iter,
-					      int flags);
-
-struct trace_event {
-	struct hlist_node	node;
-	int			type;
-	trace_print_func	trace;
-	trace_print_func	raw;
-	trace_print_func	hex;
-	trace_print_func	binary;
-};
-
 extern enum print_line_t
 trace_print_bprintk_msg_only(struct trace_iterator *iter);
 extern enum print_line_t
 trace_print_printk_msg_only(struct trace_iterator *iter);
 
-extern int trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
-	__attribute__ ((format (printf, 2, 3)));
-extern int
-trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary);
 extern int
 seq_print_ip_sym(struct trace_seq *s, unsigned long ip,
 		unsigned long sym_flags);
-extern ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf,
-				 size_t cnt);
-extern int trace_seq_puts(struct trace_seq *s, const char *str);
-extern int trace_seq_putc(struct trace_seq *s, unsigned char c);
-extern int trace_seq_putmem(struct trace_seq *s, const void *mem, size_t len);
-extern int trace_seq_putmem_hex(struct trace_seq *s, const void *mem,
-				size_t len);
-extern void *trace_seq_reserve(struct trace_seq *s, size_t len);
-extern int trace_seq_path(struct trace_seq *s, struct path *path);
 extern int seq_print_userip_objs(const struct userstack_entry *entry,
 				 struct trace_seq *s, unsigned long sym_flags);
 extern int seq_print_user_ip(struct trace_seq *s, struct mm_struct *mm,
@@ -44,13 +20,17 @@ extern int seq_print_user_ip(struct trace_seq *s, struct mm_struct *mm,
 extern int trace_print_context(struct trace_iterator *iter);
 extern int trace_print_lat_context(struct trace_iterator *iter);
 
+extern void trace_event_read_lock(void);
+extern void trace_event_read_unlock(void);
 extern struct trace_event *ftrace_find_event(int type);
-extern int register_ftrace_event(struct trace_event *event);
-extern int unregister_ftrace_event(struct trace_event *event);
 
 extern enum print_line_t trace_nop_print(struct trace_iterator *iter,
 					 int flags);
 
+/* used by module unregistering */
+extern int __unregister_ftrace_event(struct trace_event *event);
+extern struct rw_semaphore trace_event_mutex;
+
 #define MAX_MEMHEX_BYTES	8
 #define HEX_CHARS		(MAX_MEMHEX_BYTES*2 + 1)
 
diff --git a/kernel/trace/trace_power.c b/kernel/trace/trace_power.c
index 1184397..8a30d98 100644
--- a/kernel/trace/trace_power.c
+++ b/kernel/trace/trace_power.c
@@ -36,6 +36,7 @@ static void probe_power_start(struct power_trace *it, unsigned int type,
 
 static void probe_power_end(struct power_trace *it)
 {
+	struct ftrace_event_call *call = &event_power;
 	struct ring_buffer_event *event;
 	struct trace_power *entry;
 	struct trace_array_cpu *data;
@@ -54,7 +55,8 @@ static void probe_power_end(struct power_trace *it)
 		goto out;
 	entry	= ring_buffer_event_data(event);
 	entry->state_data = *it;
-	trace_buffer_unlock_commit(tr, event, 0, 0);
+	if (!filter_check_discard(call, entry, tr->buffer, event))
+		trace_buffer_unlock_commit(tr, event, 0, 0);
  out:
 	preempt_enable();
 }
@@ -62,6 +64,7 @@ static void probe_power_end(struct power_trace *it)
 static void probe_power_mark(struct power_trace *it, unsigned int type,
 				unsigned int level)
 {
+	struct ftrace_event_call *call = &event_power;
 	struct ring_buffer_event *event;
 	struct trace_power *entry;
 	struct trace_array_cpu *data;
@@ -84,7 +87,8 @@ static void probe_power_mark(struct power_trace *it, unsigned int type,
 		goto out;
 	entry	= ring_buffer_event_data(event);
 	entry->state_data = *it;
-	trace_buffer_unlock_commit(tr, event, 0, 0);
+	if (!filter_check_discard(call, entry, tr->buffer, event))
+		trace_buffer_unlock_commit(tr, event, 0, 0);
  out:
 	preempt_enable();
 }
diff --git a/kernel/trace/trace_printk.c b/kernel/trace/trace_printk.c
index eb81556..9bece96 100644
--- a/kernel/trace/trace_printk.c
+++ b/kernel/trace/trace_printk.c
@@ -245,17 +245,13 @@ static const struct file_operations ftrace_formats_fops = {
 static __init int init_trace_printk_function_export(void)
 {
 	struct dentry *d_tracer;
-	struct dentry *entry;
 
 	d_tracer = tracing_init_dentry();
 	if (!d_tracer)
 		return 0;
 
-	entry = debugfs_create_file("printk_formats", 0444, d_tracer,
+	trace_create_file("printk_formats", 0444, d_tracer,
 				    NULL, &ftrace_formats_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs "
-			   "'printk_formats' entry\n");
 
 	return 0;
 }
diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index 9117cea..a98106d 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -10,7 +10,7 @@
 #include <linux/kallsyms.h>
 #include <linux/uaccess.h>
 #include <linux/ftrace.h>
-#include <trace/sched.h>
+#include <trace/events/sched.h>
 
 #include "trace.h"
 
@@ -29,13 +29,13 @@ probe_sched_switch(struct rq *__rq, struct task_struct *prev,
 	int cpu;
 	int pc;
 
-	if (!sched_ref || sched_stopped)
+	if (unlikely(!sched_ref))
 		return;
 
 	tracing_record_cmdline(prev);
 	tracing_record_cmdline(next);
 
-	if (!tracer_enabled)
+	if (!tracer_enabled || sched_stopped)
 		return;
 
 	pc = preempt_count();
@@ -56,15 +56,15 @@ probe_sched_wakeup(struct rq *__rq, struct task_struct *wakee, int success)
 	unsigned long flags;
 	int cpu, pc;
 
-	if (!likely(tracer_enabled))
+	if (unlikely(!sched_ref))
 		return;
 
-	pc = preempt_count();
 	tracing_record_cmdline(current);
 
-	if (sched_stopped)
+	if (!tracer_enabled || sched_stopped)
 		return;
 
+	pc = preempt_count();
 	local_irq_save(flags);
 	cpu = raw_smp_processor_id();
 	data = ctx_trace->data[cpu];
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 5bc00e8..eacb272 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -15,7 +15,7 @@
 #include <linux/kallsyms.h>
 #include <linux/uaccess.h>
 #include <linux/ftrace.h>
-#include <trace/sched.h>
+#include <trace/events/sched.h>
 
 #include "trace.h"
 
@@ -138,9 +138,6 @@ probe_wakeup_sched_switch(struct rq *rq, struct task_struct *prev,
 
 	pc = preempt_count();
 
-	/* The task we are waiting for is waking up */
-	data = wakeup_trace->data[wakeup_cpu];
-
 	/* disable local data, not wakeup_cpu data */
 	cpu = raw_smp_processor_id();
 	disabled = atomic_inc_return(&wakeup_trace->data[cpu]->disabled);
@@ -154,6 +151,9 @@ probe_wakeup_sched_switch(struct rq *rq, struct task_struct *prev,
 	if (unlikely(!tracer_enabled || next != wakeup_task))
 		goto out_unlock;
 
+	/* The task we are waiting for is waking up */
+	data = wakeup_trace->data[wakeup_cpu];
+
 	trace_function(wakeup_trace, CALLER_ADDR0, CALLER_ADDR1, flags, pc);
 	tracing_sched_switch_trace(wakeup_trace, prev, next, flags, pc);
 
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 08f4eb2..00dd648 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -16,6 +16,7 @@ static inline int trace_valid_entry(struct trace_entry *entry)
 	case TRACE_BRANCH:
 	case TRACE_GRAPH_ENT:
 	case TRACE_GRAPH_RET:
+	case TRACE_HW_BRANCHES:
 		return 1;
 	}
 	return 0;
@@ -188,6 +189,7 @@ int trace_selftest_startup_dynamic_tracing(struct tracer *trace,
 #else
 # define trace_selftest_startup_dynamic_tracing(trace, tr, func) ({ 0; })
 #endif /* CONFIG_DYNAMIC_FTRACE */
+
 /*
  * Simple verification test of ftrace function tracer.
  * Enable ftrace, sleep 1/10 second, and then read the trace
@@ -749,3 +751,59 @@ trace_selftest_startup_branch(struct tracer *trace, struct trace_array *tr)
 	return ret;
 }
 #endif /* CONFIG_BRANCH_TRACER */
+
+#ifdef CONFIG_HW_BRANCH_TRACER
+int
+trace_selftest_startup_hw_branches(struct tracer *trace,
+				   struct trace_array *tr)
+{
+	struct trace_iterator *iter;
+	struct tracer tracer;
+	unsigned long count;
+	int ret;
+
+	if (!trace->open) {
+		printk(KERN_CONT "missing open function...");
+		return -1;
+	}
+
+	ret = tracer_init(trace, tr);
+	if (ret) {
+		warn_failed_init_tracer(trace, ret);
+		return ret;
+	}
+
+	/*
+	 * The hw-branch tracer needs to collect the trace from the various
+	 * cpu trace buffers - before tracing is stopped.
+	 */
+	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
+	if (!iter)
+		return -ENOMEM;
+
+	memcpy(&tracer, trace, sizeof(tracer));
+
+	iter->trace = &tracer;
+	iter->tr = tr;
+	iter->pos = -1;
+	mutex_init(&iter->mutex);
+
+	trace->open(iter);
+
+	mutex_destroy(&iter->mutex);
+	kfree(iter);
+
+	tracing_stop();
+
+	ret = trace_test_buffer(tr, &count);
+	trace->reset(tr);
+	tracing_start();
+
+	if (!ret && !count) {
+		printk(KERN_CONT "no entries found..");
+		ret = -1;
+	}
+
+	return ret;
+}
+#endif /* CONFIG_HW_BRANCH_TRACER */
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index c750f65..2d7aebd 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -265,7 +265,7 @@ static int t_show(struct seq_file *m, void *v)
 		seq_printf(m, "        Depth    Size   Location"
 			   "    (%d entries)\n"
 			   "        -----    ----   --------\n",
-			   max_stack_trace.nr_entries);
+			   max_stack_trace.nr_entries - 1);
 
 		if (!stack_tracer_enabled && !max_stack_size)
 			print_disabled(m);
@@ -352,19 +352,14 @@ __setup("stacktrace", enable_stacktrace);
 static __init int stack_trace_init(void)
 {
 	struct dentry *d_tracer;
-	struct dentry *entry;
 
 	d_tracer = tracing_init_dentry();
 
-	entry = debugfs_create_file("stack_max_size", 0644, d_tracer,
-				    &max_stack_size, &stack_max_size_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs 'stack_max_size' entry\n");
+	trace_create_file("stack_max_size", 0644, d_tracer,
+			&max_stack_size, &stack_max_size_fops);
 
-	entry = debugfs_create_file("stack_trace", 0444, d_tracer,
-				    NULL, &stack_trace_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs 'stack_trace' entry\n");
+	trace_create_file("stack_trace", 0444, d_tracer,
+			NULL, &stack_trace_fops);
 
 	if (stack_tracer_enabled)
 		register_ftrace_function(&trace_ops);
diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
index acdebd7..c006437 100644
--- a/kernel/trace/trace_stat.c
+++ b/kernel/trace/trace_stat.c
@@ -1,7 +1,7 @@
 /*
  * Infrastructure for statistic tracing (histogram output).
  *
- * Copyright (C) 2008 Frederic Weisbecker <fweisbec@gmail.com>
+ * Copyright (C) 2008-2009 Frederic Weisbecker <fweisbec@gmail.com>
  *
  * Based on the code from trace_branch.c which is
  * Copyright (C) 2008 Steven Rostedt <srostedt@redhat.com>
@@ -10,22 +10,27 @@
 
 
 #include <linux/list.h>
+#include <linux/rbtree.h>
 #include <linux/debugfs.h>
 #include "trace_stat.h"
 #include "trace.h"
 
 
-/* List of stat entries from a tracer */
-struct trace_stat_list {
-	struct list_head	list;
+/*
+ * List of stat red-black nodes from a tracer
+ * We use a such tree to sort quickly the stat
+ * entries from the tracer.
+ */
+struct stat_node {
+	struct rb_node		node;
 	void			*stat;
 };
 
 /* A stat session is the stats output in one file */
-struct tracer_stat_session {
+struct stat_session {
 	struct list_head	session_list;
 	struct tracer_stat	*ts;
-	struct list_head	stat_list;
+	struct rb_root		stat_root;
 	struct mutex		stat_mutex;
 	struct dentry		*file;
 };
@@ -37,18 +42,48 @@ static DEFINE_MUTEX(all_stat_sessions_mutex);
 /* The root directory for all stat files */
 static struct dentry		*stat_dir;
 
+/*
+ * Iterate through the rbtree using a post order traversal path
+ * to release the next node.
+ * It won't necessary release one at each iteration
+ * but it will at least advance closer to the next one
+ * to be released.
+ */
+static struct rb_node *release_next(struct rb_node *node)
+{
+	struct stat_node *snode;
+	struct rb_node *parent = rb_parent(node);
+
+	if (node->rb_left)
+		return node->rb_left;
+	else if (node->rb_right)
+		return node->rb_right;
+	else {
+		if (!parent)
+			;
+		else if (parent->rb_left == node)
+			parent->rb_left = NULL;
+		else
+			parent->rb_right = NULL;
+
+		snode = container_of(node, struct stat_node, node);
+		kfree(snode);
+
+		return parent;
+	}
+}
 
-static void reset_stat_session(struct tracer_stat_session *session)
+static void reset_stat_session(struct stat_session *session)
 {
-	struct trace_stat_list *node, *next;
+	struct rb_node *node = session->stat_root.rb_node;
 
-	list_for_each_entry_safe(node, next, &session->stat_list, list)
-		kfree(node);
+	while (node)
+		node = release_next(node);
 
-	INIT_LIST_HEAD(&session->stat_list);
+	session->stat_root = RB_ROOT;
 }
 
-static void destroy_session(struct tracer_stat_session *session)
+static void destroy_session(struct stat_session *session)
 {
 	debugfs_remove(session->file);
 	reset_stat_session(session);
@@ -56,25 +91,60 @@ static void destroy_session(struct tracer_stat_session *session)
 	kfree(session);
 }
 
+typedef int (*cmp_stat_t)(void *, void *);
+
+static int insert_stat(struct rb_root *root, void *stat, cmp_stat_t cmp)
+{
+	struct rb_node **new = &(root->rb_node), *parent = NULL;
+	struct stat_node *data;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+	data->stat = stat;
+
+	/*
+	 * Figure out where to put new node
+	 * This is a descendent sorting
+	 */
+	while (*new) {
+		struct stat_node *this;
+		int result;
+
+		this = container_of(*new, struct stat_node, node);
+		result = cmp(data->stat, this->stat);
+
+		parent = *new;
+		if (result >= 0)
+			new = &((*new)->rb_left);
+		else
+			new = &((*new)->rb_right);
+	}
+
+	rb_link_node(&data->node, parent, new);
+	rb_insert_color(&data->node, root);
+	return 0;
+}
+
 /*
  * For tracers that don't provide a stat_cmp callback.
- * This one will force an immediate insertion on tail of
- * the list.
+ * This one will force an insertion as right-most node
+ * in the rbtree.
  */
 static int dummy_cmp(void *p1, void *p2)
 {
-	return 1;
+	return -1;
 }
 
 /*
- * Initialize the stat list at each trace_stat file opening.
+ * Initialize the stat rbtree at each trace_stat file opening.
  * All of these copies and sorting are required on all opening
  * since the stats could have changed between two file sessions.
  */
-static int stat_seq_init(struct tracer_stat_session *session)
+static int stat_seq_init(struct stat_session *session)
 {
-	struct trace_stat_list *iter_entry, *new_entry;
 	struct tracer_stat *ts = session->ts;
+	struct rb_root *root = &session->stat_root;
 	void *stat;
 	int ret = 0;
 	int i;
@@ -85,29 +155,16 @@ static int stat_seq_init(struct tracer_stat_session *session)
 	if (!ts->stat_cmp)
 		ts->stat_cmp = dummy_cmp;
 
-	stat = ts->stat_start();
+	stat = ts->stat_start(ts);
 	if (!stat)
 		goto exit;
 
-	/*
-	 * The first entry. Actually this is the second, but the first
-	 * one (the stat_list head) is pointless.
-	 */
-	new_entry = kmalloc(sizeof(struct trace_stat_list), GFP_KERNEL);
-	if (!new_entry) {
-		ret = -ENOMEM;
+	ret = insert_stat(root, stat, ts->stat_cmp);
+	if (ret)
 		goto exit;
-	}
-
-	INIT_LIST_HEAD(&new_entry->list);
-
-	list_add(&new_entry->list, &session->stat_list);
-
-	new_entry->stat = stat;
 
 	/*
-	 * Iterate over the tracer stat entries and store them in a sorted
-	 * list.
+	 * Iterate over the tracer stat entries and store them in an rbtree.
 	 */
 	for (i = 1; ; i++) {
 		stat = ts->stat_next(stat, i);
@@ -116,36 +173,16 @@ static int stat_seq_init(struct tracer_stat_session *session)
 		if (!stat)
 			break;
 
-		new_entry = kmalloc(sizeof(struct trace_stat_list), GFP_KERNEL);
-		if (!new_entry) {
-			ret = -ENOMEM;
-			goto exit_free_list;
-		}
-
-		INIT_LIST_HEAD(&new_entry->list);
-		new_entry->stat = stat;
-
-		list_for_each_entry_reverse(iter_entry, &session->stat_list,
-				list) {
-
-			/* Insertion with a descendent sorting */
-			if (ts->stat_cmp(iter_entry->stat,
-					new_entry->stat) >= 0) {
-
-				list_add(&new_entry->list, &iter_entry->list);
-				break;
-			}
-		}
-
-		/* The current larger value */
-		if (list_empty(&new_entry->list))
-			list_add(&new_entry->list, &session->stat_list);
+		ret = insert_stat(root, stat, ts->stat_cmp);
+		if (ret)
+			goto exit_free_rbtree;
 	}
+
 exit:
 	mutex_unlock(&session->stat_mutex);
 	return ret;
 
-exit_free_list:
+exit_free_rbtree:
 	reset_stat_session(session);
 	mutex_unlock(&session->stat_mutex);
 	return ret;
@@ -154,38 +191,51 @@ exit_free_list:
 
 static void *stat_seq_start(struct seq_file *s, loff_t *pos)
 {
-	struct tracer_stat_session *session = s->private;
+	struct stat_session *session = s->private;
+	struct rb_node *node;
+	int i;
 
-	/* Prevent from tracer switch or stat_list modification */
+	/* Prevent from tracer switch or rbtree modification */
 	mutex_lock(&session->stat_mutex);
 
 	/* If we are in the beginning of the file, print the headers */
-	if (!*pos && session->ts->stat_headers)
+	if (!*pos && session->ts->stat_headers) {
+		(*pos)++;
 		return SEQ_START_TOKEN;
+	}
 
-	return seq_list_start(&session->stat_list, *pos);
+	node = rb_first(&session->stat_root);
+	for (i = 0; node && i < *pos; i++)
+		node = rb_next(node);
+
+	(*pos)++;
+
+	return node;
 }
 
 static void *stat_seq_next(struct seq_file *s, void *p, loff_t *pos)
 {
-	struct tracer_stat_session *session = s->private;
+	struct stat_session *session = s->private;
+	struct rb_node *node = p;
+
+	(*pos)++;
 
 	if (p == SEQ_START_TOKEN)
-		return seq_list_start(&session->stat_list, *pos);
+		return rb_first(&session->stat_root);
 
-	return seq_list_next(p, &session->stat_list, pos);
+	return rb_next(node);
 }
 
 static void stat_seq_stop(struct seq_file *s, void *p)
 {
-	struct tracer_stat_session *session = s->private;
+	struct stat_session *session = s->private;
 	mutex_unlock(&session->stat_mutex);
 }
 
 static int stat_seq_show(struct seq_file *s, void *v)
 {
-	struct tracer_stat_session *session = s->private;
-	struct trace_stat_list *l = list_entry(v, struct trace_stat_list, list);
+	struct stat_session *session = s->private;
+	struct stat_node *l = container_of(v, struct stat_node, node);
 
 	if (v == SEQ_START_TOKEN)
 		return session->ts->stat_headers(s);
@@ -205,7 +255,7 @@ static int tracing_stat_open(struct inode *inode, struct file *file)
 {
 	int ret;
 
-	struct tracer_stat_session *session = inode->i_private;
+	struct stat_session *session = inode->i_private;
 
 	ret = seq_open(file, &trace_stat_seq_ops);
 	if (!ret) {
@@ -218,11 +268,11 @@ static int tracing_stat_open(struct inode *inode, struct file *file)
 }
 
 /*
- * Avoid consuming memory with our now useless list.
+ * Avoid consuming memory with our now useless rbtree.
  */
 static int tracing_stat_release(struct inode *i, struct file *f)
 {
-	struct tracer_stat_session *session = i->i_private;
+	struct stat_session *session = i->i_private;
 
 	mutex_lock(&session->stat_mutex);
 	reset_stat_session(session);
@@ -251,7 +301,7 @@ static int tracing_stat_init(void)
 	return 0;
 }
 
-static int init_stat_file(struct tracer_stat_session *session)
+static int init_stat_file(struct stat_session *session)
 {
 	if (!stat_dir && tracing_stat_init())
 		return -ENODEV;
@@ -266,7 +316,7 @@ static int init_stat_file(struct tracer_stat_session *session)
 
 int register_stat_tracer(struct tracer_stat *trace)
 {
-	struct tracer_stat_session *session, *node, *tmp;
+	struct stat_session *session, *node;
 	int ret;
 
 	if (!trace)
@@ -277,7 +327,7 @@ int register_stat_tracer(struct tracer_stat *trace)
 
 	/* Already registered? */
 	mutex_lock(&all_stat_sessions_mutex);
-	list_for_each_entry_safe(node, tmp, &all_stat_sessions, session_list) {
+	list_for_each_entry(node, &all_stat_sessions, session_list) {
 		if (node->ts == trace) {
 			mutex_unlock(&all_stat_sessions_mutex);
 			return -EINVAL;
@@ -286,15 +336,13 @@ int register_stat_tracer(struct tracer_stat *trace)
 	mutex_unlock(&all_stat_sessions_mutex);
 
 	/* Init the session */
-	session = kmalloc(sizeof(struct tracer_stat_session), GFP_KERNEL);
+	session = kzalloc(sizeof(*session), GFP_KERNEL);
 	if (!session)
 		return -ENOMEM;
 
 	session->ts = trace;
 	INIT_LIST_HEAD(&session->session_list);
-	INIT_LIST_HEAD(&session->stat_list);
 	mutex_init(&session->stat_mutex);
-	session->file = NULL;
 
 	ret = init_stat_file(session);
 	if (ret) {
@@ -312,7 +360,7 @@ int register_stat_tracer(struct tracer_stat *trace)
 
 void unregister_stat_tracer(struct tracer_stat *trace)
 {
-	struct tracer_stat_session *node, *tmp;
+	struct stat_session *node, *tmp;
 
 	mutex_lock(&all_stat_sessions_mutex);
 	list_for_each_entry_safe(node, tmp, &all_stat_sessions, session_list) {
diff --git a/kernel/trace/trace_stat.h b/kernel/trace/trace_stat.h
index 202274c..f3546a2 100644
--- a/kernel/trace/trace_stat.h
+++ b/kernel/trace/trace_stat.h
@@ -12,7 +12,7 @@ struct tracer_stat {
 	/* The name of your stat file */
 	const char		*name;
 	/* Iteration over statistic entries */
-	void			*(*stat_start)(void);
+	void			*(*stat_start)(struct tracer_stat *trace);
 	void			*(*stat_next)(void *prev, int idx);
 	/* Compare two entries for stats sorting */
 	int			(*stat_cmp)(void *p1, void *p2);
diff --git a/kernel/trace/trace_sysprof.c b/kernel/trace/trace_sysprof.c
index 91fd19c..e04b76c 100644
--- a/kernel/trace/trace_sysprof.c
+++ b/kernel/trace/trace_sysprof.c
@@ -321,11 +321,7 @@ static const struct file_operations sysprof_sample_fops = {
 
 void init_tracer_sysprof_debugfs(struct dentry *d_tracer)
 {
-	struct dentry *entry;
 
-	entry = debugfs_create_file("sysprof_sample_period", 0644,
+	trace_create_file("sysprof_sample_period", 0644,
 			d_tracer, NULL, &sysprof_sample_fops);
-	if (entry)
-		return;
-	pr_warning("Could not create debugfs 'sysprof_sample_period' entry\n");
 }
diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
index 797201e..97fcea4 100644
--- a/kernel/trace/trace_workqueue.c
+++ b/kernel/trace/trace_workqueue.c
@@ -6,7 +6,7 @@
  */
 
 
-#include <trace/workqueue.h>
+#include <trace/events/workqueue.h>
 #include <linux/list.h>
 #include <linux/percpu.h>
 #include "trace_stat.h"
@@ -16,8 +16,6 @@
 /* A cpu workqueue thread */
 struct cpu_workqueue_stats {
 	struct list_head            list;
-/* Useful to know if we print the cpu headers */
-	bool		            first_entry;
 	int		            cpu;
 	pid_t			    pid;
 /* Can be inserted from interrupt or user context, need to be atomic */
@@ -47,12 +45,11 @@ probe_workqueue_insertion(struct task_struct *wq_thread,
 			  struct work_struct *work)
 {
 	int cpu = cpumask_first(&wq_thread->cpus_allowed);
-	struct cpu_workqueue_stats *node, *next;
+	struct cpu_workqueue_stats *node;
 	unsigned long flags;
 
 	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
-	list_for_each_entry_safe(node, next, &workqueue_cpu_stat(cpu)->list,
-							list) {
+	list_for_each_entry(node, &workqueue_cpu_stat(cpu)->list, list) {
 		if (node->pid == wq_thread->pid) {
 			atomic_inc(&node->inserted);
 			goto found;
@@ -69,12 +66,11 @@ probe_workqueue_execution(struct task_struct *wq_thread,
 			  struct work_struct *work)
 {
 	int cpu = cpumask_first(&wq_thread->cpus_allowed);
-	struct cpu_workqueue_stats *node, *next;
+	struct cpu_workqueue_stats *node;
 	unsigned long flags;
 
 	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
-	list_for_each_entry_safe(node, next, &workqueue_cpu_stat(cpu)->list,
-							list) {
+	list_for_each_entry(node, &workqueue_cpu_stat(cpu)->list, list) {
 		if (node->pid == wq_thread->pid) {
 			node->executed++;
 			goto found;
@@ -105,8 +101,6 @@ static void probe_workqueue_creation(struct task_struct *wq_thread, int cpu)
 	cws->pid = wq_thread->pid;
 
 	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
-	if (list_empty(&workqueue_cpu_stat(cpu)->list))
-		cws->first_entry = true;
 	list_add_tail(&cws->list, &workqueue_cpu_stat(cpu)->list);
 	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
 }
@@ -152,7 +146,7 @@ static struct cpu_workqueue_stats *workqueue_stat_start_cpu(int cpu)
 	return ret;
 }
 
-static void *workqueue_stat_start(void)
+static void *workqueue_stat_start(struct tracer_stat *trace)
 {
 	int cpu;
 	void *ret = NULL;
@@ -191,16 +185,9 @@ static void *workqueue_stat_next(void *prev, int idx)
 static int workqueue_stat_show(struct seq_file *s, void *p)
 {
 	struct cpu_workqueue_stats *cws = p;
-	unsigned long flags;
-	int cpu = cws->cpu;
 	struct pid *pid;
 	struct task_struct *tsk;
 
-	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
-	if (&cws->list == workqueue_cpu_stat(cpu)->list.next)
-		seq_printf(s, "\n");
-	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
-
 	pid = find_get_pid(cws->pid);
 	if (pid) {
 		tsk = get_pid_task(pid, PIDTYPE_PID);
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index f71fb2a..0668795 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -33,7 +33,8 @@
 #include <linux/kallsyms.h>
 #include <linux/debug_locks.h>
 #include <linux/lockdep.h>
-#include <trace/workqueue.h>
+#define CREATE_TRACE_POINTS
+#include <trace/events/workqueue.h>
 
 /*
  * The per-CPU workqueue (if single thread, we always use the first
@@ -124,8 +125,6 @@ struct cpu_workqueue_struct *get_wq_data(struct work_struct *work)
 	return (void *) (atomic_long_read(&work->data) & WORK_STRUCT_WQ_DATA_MASK);
 }
 
-DEFINE_TRACE(workqueue_insertion);
-
 static void insert_work(struct cpu_workqueue_struct *cwq,
 			struct work_struct *work, struct list_head *head)
 {
@@ -262,8 +261,6 @@ int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 }
 EXPORT_SYMBOL_GPL(queue_delayed_work_on);
 
-DEFINE_TRACE(workqueue_execution);
-
 static void run_workqueue(struct cpu_workqueue_struct *cwq)
 {
 	spin_lock_irq(&cwq->lock);
@@ -753,8 +750,6 @@ init_cpu_workqueue(struct workqueue_struct *wq, int cpu)
 	return cwq;
 }
 
-DEFINE_TRACE(workqueue_creation);
-
 static int create_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
 {
 	struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
@@ -860,8 +855,6 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 }
 EXPORT_SYMBOL_GPL(__create_workqueue_key);
 
-DEFINE_TRACE(workqueue_destruction);
-
 static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq)
 {
 	/*
diff --git a/mm/bounce.c b/mm/bounce.c
index e590272..65f5e17 100644
--- a/mm/bounce.c
+++ b/mm/bounce.c
@@ -14,16 +14,15 @@
 #include <linux/hash.h>
 #include <linux/highmem.h>
 #include <linux/blktrace_api.h>
-#include <trace/block.h>
 #include <asm/tlbflush.h>
 
+#include <trace/events/block.h>
+
 #define POOL_SIZE	64
 #define ISA_POOL_SIZE	16
 
 static mempool_t *page_pool, *isa_page_pool;
 
-DEFINE_TRACE(block_bio_bounce);
-
 #ifdef CONFIG_HIGHMEM
 static __init int init_emergency_pool(void)
 {
diff --git a/mm/mlock.c b/mm/mlock.c
index cbe9e05..ac13043 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -629,52 +629,43 @@ void user_shm_unlock(size_t size, struct user_struct *user)
 	free_uid(user);
 }
 
-void *alloc_locked_buffer(size_t size)
+int account_locked_memory(struct mm_struct *mm, struct rlimit *rlim,
+			  size_t size)
 {
-	unsigned long rlim, vm, pgsz;
-	void *buffer = NULL;
+	unsigned long lim, vm, pgsz;
+	int error = -ENOMEM;
 
 	pgsz = PAGE_ALIGN(size) >> PAGE_SHIFT;
 
-	down_write(&current->mm->mmap_sem);
-
-	rlim = current->signal->rlim[RLIMIT_AS].rlim_cur >> PAGE_SHIFT;
-	vm   = current->mm->total_vm + pgsz;
-	if (rlim < vm)
-		goto out;
+	down_write(&mm->mmap_sem);
 
-	rlim = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur >> PAGE_SHIFT;
-	vm   = current->mm->locked_vm + pgsz;
-	if (rlim < vm)
+	lim = rlim[RLIMIT_AS].rlim_cur >> PAGE_SHIFT;
+	vm   = mm->total_vm + pgsz;
+	if (lim < vm)
 		goto out;
 
-	buffer = kzalloc(size, GFP_KERNEL);
-	if (!buffer)
+	lim = rlim[RLIMIT_MEMLOCK].rlim_cur >> PAGE_SHIFT;
+	vm   = mm->locked_vm + pgsz;
+	if (lim < vm)
 		goto out;
 
-	current->mm->total_vm  += pgsz;
-	current->mm->locked_vm += pgsz;
+	mm->total_vm  += pgsz;
+	mm->locked_vm += pgsz;
 
+	error = 0;
  out:
-	up_write(&current->mm->mmap_sem);
-	return buffer;
+	up_write(&mm->mmap_sem);
+	return error;
 }
 
-void release_locked_buffer(void *buffer, size_t size)
+void refund_locked_memory(struct mm_struct *mm, size_t size)
 {
 	unsigned long pgsz = PAGE_ALIGN(size) >> PAGE_SHIFT;
 
-	down_write(&current->mm->mmap_sem);
-
-	current->mm->total_vm  -= pgsz;
-	current->mm->locked_vm -= pgsz;
-
-	up_write(&current->mm->mmap_sem);
-}
+	down_write(&mm->mmap_sem);
 
-void free_locked_buffer(void *buffer, size_t size)
-{
-	release_locked_buffer(buffer, size);
+	mm->total_vm  -= pgsz;
+	mm->locked_vm -= pgsz;
 
-	kfree(buffer);
+	up_write(&mm->mmap_sem);
 }
diff --git a/mm/slab.c b/mm/slab.c
index 9a90b00..f85831d 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -102,7 +102,7 @@
 #include	<linux/cpu.h>
 #include	<linux/sysctl.h>
 #include	<linux/module.h>
-#include	<trace/kmemtrace.h>
+#include	<linux/kmemtrace.h>
 #include	<linux/rcupdate.h>
 #include	<linux/string.h>
 #include	<linux/uaccess.h>
diff --git a/mm/slob.c b/mm/slob.c
index a2d4ab3..494f05f 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -65,7 +65,7 @@
 #include <linux/module.h>
 #include <linux/rcupdate.h>
 #include <linux/list.h>
-#include <trace/kmemtrace.h>
+#include <linux/kmemtrace.h>
 #include <asm/atomic.h>
 
 /*
diff --git a/mm/slub.c b/mm/slub.c
index 7ab54ec..ea9e716 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -16,7 +16,7 @@
 #include <linux/slab.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
-#include <trace/kmemtrace.h>
+#include <linux/kmemtrace.h>
 #include <linux/cpu.h>
 #include <linux/cpuset.h>
 #include <linux/mempolicy.h>
diff --git a/mm/util.c b/mm/util.c
index 55bef16..abc65aa 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -4,9 +4,11 @@
 #include <linux/module.h>
 #include <linux/err.h>
 #include <linux/sched.h>
-#include <linux/tracepoint.h>
 #include <asm/uaccess.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/kmem.h>
+
 /**
  * kstrdup - allocate space for and copy an existing string
  * @s: the string to duplicate
@@ -255,13 +257,6 @@ int __attribute__((weak)) get_user_pages_fast(unsigned long start,
 EXPORT_SYMBOL_GPL(get_user_pages_fast);
 
 /* Tracepoints definitions. */
-DEFINE_TRACE(kmalloc);
-DEFINE_TRACE(kmem_cache_alloc);
-DEFINE_TRACE(kmalloc_node);
-DEFINE_TRACE(kmem_cache_alloc_node);
-DEFINE_TRACE(kfree);
-DEFINE_TRACE(kmem_cache_free);
-
 EXPORT_TRACEPOINT_SYMBOL(kmalloc);
 EXPORT_TRACEPOINT_SYMBOL(kmem_cache_alloc);
 EXPORT_TRACEPOINT_SYMBOL(kmalloc_node);
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 9fd0dc3..b75b6ce 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -23,7 +23,7 @@
 #include <linux/bitops.h>
 #include <net/genetlink.h>
 
-#include <trace/skb.h>
+#include <trace/events/skb.h>
 
 #include <asm/unaligned.h>
 
diff --git a/net/core/net-traces.c b/net/core/net-traces.c
index c8fb456..499a67e 100644
--- a/net/core/net-traces.c
+++ b/net/core/net-traces.c
@@ -19,11 +19,11 @@
 #include <linux/workqueue.h>
 #include <linux/netlink.h>
 #include <linux/net_dropmon.h>
-#include <trace/skb.h>
 
 #include <asm/unaligned.h>
 #include <asm/bitops.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/skb.h>
 
-DEFINE_TRACE(kfree_skb);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kfree_skb);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index d152394..c4906bb 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -65,7 +65,7 @@
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
-#include <trace/skb.h>
+#include <trace/events/skb.h>
 
 #include "kmap_skb.h"
 
diff --git a/samples/Kconfig b/samples/Kconfig
index 4b02f5a..b75d28c 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -19,6 +19,12 @@ config SAMPLE_TRACEPOINTS
 	help
 	  This build tracepoints example modules.
 
+config SAMPLE_TRACE_EVENTS
+	tristate "Build trace_events examples -- loadable modules only"
+	depends on EVENT_TRACING && m
+	help
+	  This build trace event example modules.
+
 config SAMPLE_KOBJECT
 	tristate "Build kobject examples"
 	help
diff --git a/samples/Makefile b/samples/Makefile
index 10eaca8..13e4b47 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -1,3 +1,3 @@
 # Makefile for Linux samples code
 
-obj-$(CONFIG_SAMPLES)	+= markers/ kobject/ kprobes/ tracepoints/
+obj-$(CONFIG_SAMPLES)	+= markers/ kobject/ kprobes/ tracepoints/ trace_events/
diff --git a/samples/trace_events/Makefile b/samples/trace_events/Makefile
new file mode 100644
index 0000000..0d428dc
--- /dev/null
+++ b/samples/trace_events/Makefile
@@ -0,0 +1,6 @@
+# builds the trace events example kernel modules;
+# then to use one (as root):  insmod <module_name.ko>
+
+CFLAGS_trace-events-sample.o := -I$(src)
+
+obj-$(CONFIG_SAMPLE_TRACE_EVENTS) += trace-events-sample.o
diff --git a/samples/trace_events/trace-events-sample.c b/samples/trace_events/trace-events-sample.c
new file mode 100644
index 0000000..aabc4e9
--- /dev/null
+++ b/samples/trace_events/trace-events-sample.c
@@ -0,0 +1,52 @@
+#include <linux/module.h>
+#include <linux/kthread.h>
+
+/*
+ * Any file that uses trace points, must include the header.
+ * But only one file, must include the header by defining
+ * CREATE_TRACE_POINTS first.  This will make the C code that
+ * creates the handles for the trace points.
+ */
+#define CREATE_TRACE_POINTS
+#include "trace-events-sample.h"
+
+
+static void simple_thread_func(int cnt)
+{
+	set_current_state(TASK_INTERRUPTIBLE);
+	schedule_timeout(HZ);
+	trace_foo_bar("hello", cnt);
+}
+
+static int simple_thread(void *arg)
+{
+	int cnt = 0;
+
+	while (!kthread_should_stop())
+		simple_thread_func(cnt++);
+
+	return 0;
+}
+
+static struct task_struct *simple_tsk;
+
+static int __init trace_event_init(void)
+{
+	simple_tsk = kthread_run(simple_thread, NULL, "event-sample");
+	if (IS_ERR(simple_tsk))
+		return -1;
+
+	return 0;
+}
+
+static void __exit trace_event_exit(void)
+{
+	kthread_stop(simple_tsk);
+}
+
+module_init(trace_event_init);
+module_exit(trace_event_exit);
+
+MODULE_AUTHOR("Steven Rostedt");
+MODULE_DESCRIPTION("trace-events-sample");
+MODULE_LICENSE("GPL");
diff --git a/samples/trace_events/trace-events-sample.h b/samples/trace_events/trace-events-sample.h
new file mode 100644
index 0000000..128a897
--- /dev/null
+++ b/samples/trace_events/trace-events-sample.h
@@ -0,0 +1,129 @@
+/*
+ * Notice that this file is not protected like a normal header.
+ * We also must allow for rereading of this file. The
+ *
+ *  || defined(TRACE_HEADER_MULTI_READ)
+ *
+ * serves this purpose.
+ */
+#if !defined(_TRACE_EVENT_SAMPLE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_EVENT_SAMPLE_H
+
+/*
+ * All trace headers should include tracepoint.h, until we finally
+ * make it into a standard header.
+ */
+#include <linux/tracepoint.h>
+
+/*
+ * If TRACE_SYSTEM is defined, that will be the directory created
+ * in the ftrace directory under /debugfs/tracing/events/<system>
+ *
+ * The define_trace.h belowe will also look for a file name of
+ * TRACE_SYSTEM.h where TRACE_SYSTEM is what is defined here.
+ *
+ * If you want a different system than file name, you can override
+ * the header name by defining TRACE_INCLUDE_FILE
+ *
+ * If this file was called, goofy.h, then we would define:
+ *
+ * #define TRACE_INCLUDE_FILE goofy
+ *
+ */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM sample
+
+/*
+ * The TRACE_EVENT macro is broken up into 5 parts.
+ *
+ * name: name of the trace point. This is also how to enable the tracepoint.
+ *   A function called trace_foo_bar() will be created.
+ *
+ * proto: the prototype of the function trace_foo_bar()
+ *   Here it is trace_foo_bar(char *foo, int bar).
+ *
+ * args:  must match the arguments in the prototype.
+ *    Here it is simply "foo, bar".
+ *
+ * struct:  This defines the way the data will be stored in the ring buffer.
+ *    There are currently two types of elements. __field and __array.
+ *    a __field is broken up into (type, name). Where type can be any
+ *    type but an array.
+ *    For an array. there are three fields. (type, name, size). The
+ *    type of elements in the array, the name of the field and the size
+ *    of the array.
+ *
+ *    __array( char, foo, 10) is the same as saying   char foo[10].
+ *
+ * fast_assign: This is a C like function that is used to store the items
+ *    into the ring buffer.
+ *
+ * printk: This is a way to print out the data in pretty print. This is
+ *    useful if the system crashes and you are logging via a serial line,
+ *    the data can be printed to the console using this "printk" method.
+ *
+ * Note, that for both the assign and the printk, __entry is the handler
+ * to the data structure in the ring buffer, and is defined by the
+ * TP_STRUCT__entry.
+ */
+TRACE_EVENT(foo_bar,
+
+	TP_PROTO(char *foo, int bar),
+
+	TP_ARGS(foo, bar),
+
+	TP_STRUCT__entry(
+		__array(	char,	foo,    10		)
+		__field(	int,	bar			)
+	),
+
+	TP_fast_assign(
+		strncpy(__entry->foo, foo, 10);
+		__entry->bar	= bar;
+	),
+
+	TP_printk("foo %s %d", __entry->foo, __entry->bar)
+);
+#endif
+
+/***** NOTICE! The #if protection ends here. *****/
+
+
+/*
+ * There are several ways I could have done this. If I left out the
+ * TRACE_INCLUDE_PATH, then it would default to the kernel source
+ * include/trace/events directory.
+ *
+ * I could specify a path from the define_trace.h file back to this
+ * file.
+ *
+ * #define TRACE_INCLUDE_PATH ../../samples/trace_events
+ *
+ * But I chose to simply make it use the current directory and then in
+ * the Makefile I added:
+ *
+ * CFLAGS_trace-events-sample.o := -I$(PWD)/samples/trace_events/
+ *
+ * This will make sure the current path is part of the include
+ * structure for our file so that we can find it.
+ *
+ * I could have made only the top level directory the include:
+ *
+ * CFLAGS_trace-events-sample.o := -I$(PWD)
+ *
+ * And then let the path to this directory be the TRACE_INCLUDE_PATH:
+ *
+ * #define TRACE_INCLUDE_PATH samples/trace_events
+ *
+ * But then if something defines "samples" or "trace_events" then we
+ * could risk that being converted too, and give us an unexpected
+ * result.
+ */
+#undef TRACE_INCLUDE_PATH
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_PATH .
+/*
+ * TRACE_INCLUDE_FILE is not needed if the filename and TRACE_SYSTEM are equal
+ */
+#define TRACE_INCLUDE_FILE trace-events-sample
+#include <trace/define_trace.h>
diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 3208a3a..acd8c4a 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -1828,6 +1828,25 @@ sub reset_state {
     $state = 0;
 }
 
+sub tracepoint_munge($) {
+	my $file = shift;
+	my $tracepointname = 0;
+	my $tracepointargs = 0;
+
+	if($prototype =~ m/TRACE_EVENT\((.*?),/) {
+		$tracepointname = $1;
+	}
+	if($prototype =~ m/TP_PROTO\((.*?)\)/) {
+		$tracepointargs = $1;
+	}
+	if (($tracepointname eq 0) || ($tracepointargs eq 0)) {
+		print STDERR "Warning(${file}:$.): Unrecognized tracepoint format: \n".
+			     "$prototype\n";
+	} else {
+		$prototype = "static inline void trace_$tracepointname($tracepointargs)";
+	}
+}
+
 sub syscall_munge() {
 	my $void = 0;
 
@@ -1882,6 +1901,9 @@ sub process_state3_function($$) {
 	if ($prototype =~ /SYSCALL_DEFINE/) {
 		syscall_munge();
 	}
+	if ($prototype =~ /TRACE_EVENT/) {
+		tracepoint_munge($file);
+	}
 	dump_function($prototype, $file);
 	reset_state();
     }
diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 409596e..0fae7da 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -26,7 +26,7 @@
 # which will also be the location of that section after final link.
 # e.g.
 #
-#  .section ".text.sched"
+#  .section ".sched.text", "ax"
 #  .globl my_func
 #  my_func:
 #        [...]
@@ -39,7 +39,7 @@
 #        [...]
 #
 # Both relocation offsets for the mcounts in the above example will be
-# offset from .text.sched. If we make another file called tmp.s with:
+# offset from .sched.text. If we make another file called tmp.s with:
 #
 #  .section __mcount_loc
 #  .quad  my_func + 0x5
@@ -51,7 +51,7 @@
 # But this gets hard if my_func is not globl (a static function).
 # In such a case we have:
 #
-#  .section ".text.sched"
+#  .section ".sched.text", "ax"
 #  my_func:
 #        [...]
 #        call mcount  (offset: 0x5)

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755211AbYJHWVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211AbYJHWVM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 18:21:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755008AbYJHWU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 18:20:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40658 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755085AbYJHWU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 18:20:57 -0400
Date: Thu, 9 Oct 2008 00:20:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: What's new in tracing.git for v2.6.28
Message-ID: <20081008222049.GA29092@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The tracing family of trees had 8 topic trees active during the past 3 
months of the v2.6.28 development cycle:

      tracing/fastboot      tracing/ftrace        tracing/markers 
      tracing/mmiotrace     tracing/nmisafe       tracing/pipe 
      tracing/ring-buffer   tracing/stack-tracer

      97 files changed, 6699 insertions(+), 1702 deletions(-)

It contains 146 non-merge commits from 19 authors.

The biggest item is the much talked about tracing ring-buffer 
infrastructure rewrite, but there's a good deal of activity elsewhere as 
well: a new fastboot (initcall) tracer, maximum stack-footprint tracer 
and various updates all around.

	Ingo

------------->
Andrew Morton (1):
      kbuild: ftrace: don't assume that scripts/recordmcount.pl is executable

Arjan van de Ven (17):
      fastboot: create a "asynchronous" initlevel
      fastboot: turn the USB hostcontroller initcalls into async initcalls
      fastboot: convert a few non-critical ACPI drivers to async initcalls
      fastboot: hold the BKL over the async init call sequence
      fastboot: sync the async execution before late_initcall and move level 6s (sync) first
      fastboot: make fastboot a config option
      modules: extend initcall_debug functionality to the module loader
      fastboot: retry mounting the root fs if we can't find init
      fastboot: make the raid autodetect code wait for all devices to init
      fastboot: remove "wait for all devices before mounting root" delay
      fastboot: make the RAID autostart code print a message just before waiting
      fastboot: fix blackfin breakage due to vmlinux.lds change
      Add a script to visualize the kernel boot process / time
      fastboot: fix issues and improve output of bootgraph.pl
      use the fancy new printk flags to print the function pointer
      raid: make RAID autodetect default a KConfig option
      tracing/fastboot: fix printk format typo in boot tracer

Arnaud Patard (1):
      fastboot: Fix bootgraph.pl initcall name regexp

Frederic Weisbecker (9):
      tracing/ftrace: change the type of the print_line callback
      tracing/ftrace: adapt mmiotrace to the new type of print_line
      tracing/ftrace: adapt the boot tracer to the new print_line type
      tracing/ftrace: adapt mmiotrace to the new type of print_line, fix
      tracing/fastboot: change the printing of boot tracer according to bootgraph.pl
      tracing/fastboot: get the initcall name before it disappears
      tracing/fastboot: only trace non-module initcalls
      ftrace: return an error when setting a nonexistent tracer
      tracing/fastboot: fix initcalls disposition in bootgraph.pl

Frédéric Weisbecker (11):
      ftrace: fix some mistakes in error messages
      tracing/ftrace: make nop tracer reset previous entries
      tracing/ftrace: tracing engine depends on Nop Tracer
      tracing/ftrace: replace none tracer by nop tracer
      tracing/ftrace: add the boot tracer
      tracing/ftrace: make tracing suitable to run the boot tracer
      tracing/ftrace: give an entry on the config for boot tracer
      tracing/ftrace: launch boot tracing after pre-smp initcalls
      ftrace/fastboot: disable tracers self-tests when boot tracer is selected
      x86/ftrace: use uaccess in atomic context
      tracing/ftrace: don't consume unhandled entries by boot tracer

Harvey Harrison (1):
      x86: suppress trivial sparse signedness warnings

Huang Ying (1):
      ftrace: fix incorrect comment style of __ftrace_enabled_save()

Ingo Molnar (17):
      sched: sched_clock() improvement: use in_nmi()
      x86, tracing, nmisafe: fix threadinfo_ -> TI_ rename fallout
      tracing: disable tracepoints by default
      sched: clean up tracepoints
      tracing: clean up tracepoints kconfig structure
      ftrace: ignore functions that cannot be kprobe-ed
      ftrace: mark lapic_wd_event() notrace
      fastboot: fix typo in init/Kconfig text
      ftrace: build fix
      ftrace: ftrace_kill_atomic() build fix
      ftrace: scripts/recordmcount.pl cross-build hack
      ftrace: clean up macro usage
      warning: fix init do_mounts_md c
      stack tracer: depends on DEBUG_KERNEL
      ftrace: make it depend on DEBUG_KERNEL
      ring-buffer: fix build error
      tracing/fastboot: build fix

Jeremy Fitzhardinge (1):
      ftrace: fix build problem with CONFIG_FTRACE

Lai Jiangshan (1):
      markers: fix unregister bug and reenter bug

Li, Shaohua (1):
      fastboot: remove duplicate unpack_to_rootfs()

Mathieu Desnoyers (21):
      Stringify support commas
      Change Alpha active count bit
      Change avr32 active count bit
      x86_64 page fault NMI-safe
      x86 NMI-safe INT3 and Page Fault
      rcu: add rcu_read_lock_sched() & rcu_read_unlock_sched() APIs
      tracing: Kernel Tracepoints
      tracing: tracepoints, documentation
      tracing: tracepoints, samples
      tracing, sched: LTTng instrumentation - scheduler
      ftrace: port to tracepoints
      tracepoints: use TABLE_SIZE macro
      tracepoints: use rcu sched
      tracepoints: fix reentrancy
      markers: marker_synchronize_unregister()
      markers: fix unregister bug and reenter bug, cleanup
      markers: probe example, fix teardown
      markers: documentation fix for teardown
      sputrace: use marker_synchronize_unregister()
      markers: re-enable fast batch registration
      markers: turn marker_synchronize_unregister() into an inline

Michael Ellerman (1):
      ftrace: make output nicely spaced for up to 999 cpus

Pekka Paalanen (9):
      x86: fix mmiotrace 8-bit register decoding
      x86 mmiotrace: fix a rare memory leak
      ftrace: move mmiotrace functions out of trace.c
      ftrace: add trace_vprintk()
      x86 mmiotrace: implement mmiotrace_printk()
      mmiotrace: handle TRACE_PRINT entries
      mmiotrace: remove left-over marker cruft
      ftrace: inject markers via trace_marker file
      tracing/ftrace: fix pipe breaking

Peter Zijlstra (2):
      ftrace: make ftrace_printk usable with the other tracers
      ftrace: sched_switch: show the wakee's cpu

Rafael J. Wysocki (1):
      ftrace: disable tracing for hibernation

Stephen Rothwell (1):
      ftrace: fix build failure

Steven Noonan (5):
      init/initramfs.c: unused function when compiling without CONFIG_BLK_DEV_RAM
      ftrace: add nop tracer
      ftrace: mcount_addr defined but not used
      trace: remove pointless ifdefs
      ftrace: ktime.h not included in ftrace.h

Steven Rostedt (46):
      ftrace: do not trace NMI contexts
      ftrace: create __mcount_loc section
      ftrace: mcount call site on boot nops core
      ftrace: enable mcount recording for modules
      ftrace: rebuild everything on change to FTRACE_MCOUNT_RECORD
      ftrace: enable using mcount recording on x86
      ftrace: x86 mcount stub
      ftrace: use only 5 byte nops for x86
      ftrace: do not show freed records in available_filter_functions
      ftrace: move notrace to compiler.h
      ftrace: remove old pointers to mcount
      ftrace: new continue entry - separate out from trace_entry
      ftrace: printk formatting infrastructure
      ftrace: ftrace_printk doc moved
      ftrace: dump out ftrace buffers to console on panic
      ftrace: do not init module on ftrace disabled
      ftrace: add necessary locking for ftrace records
      ftrace: update recordmount.pl arch changes
      ftrace: handle weak symbol functions
      ftrace: x86 use copy to and from user functions
      ftrace: objcopy version test for local symbols
      ftrace: add stack tracer
      ftrace: remove direct reference to mcount in trace code
      ftrace: remove warning of old objcopy and local functions
      ftrace: stack trace add indexes
      ftrace: binary and not logical for continue test
      ftrace: print continue index fix
      ftrace: use ftrace_release for all dynamic ftrace functions
      ftrace: fix unlocking of hash
      ftrace: warn on failure to disable mcount callers
      ftrace: give time for wakeup test to run
      tracing: unified trace buffer
      ring_buffer: add paranoid check for buffer page
      ring_buffer: reset buffer page when freeing
      ftrace: make work with new ring buffer
      ftrace: take advantage of variable length entries
      ring_buffer: remove raw from local_irq_save
      ring_buffer: implement new locking
      ftrace: type cast filter+verifier
      ring_buffer: allocate buffer page pointer
      ftrace: preempt disable over interrupt disable
      ring_buffer: map to cpu not page
      ftrace: move pc counter in irqtrace
      ring-buffer: move page indexes into page headers
      ring-buffer: make reentrant
      ftrace: make some tracers reentrant


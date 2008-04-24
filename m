Return-Path: <linux-kernel-owner+w=401wt.eu-S1755109AbYDXXbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109AbYDXXbt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 19:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbYDXXbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 19:31:38 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:50379 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbYDXXbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 19:31:35 -0400
Date: Thu, 24 Apr 2008 19:31:26 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] KCONFIG: With a simple menuconfig, kernel debugging is
 prettier.
Message-ID: <alpine.LFD.1.10.0804241928340.20003@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Implementing kernel debugging with a menuconfig allows for the removal
of a pile of unnecessary dependencies.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 623ef24..a422e0e 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -114,15 +114,17 @@ config DEBUG_SECTION_MISMATCH
 	  - Enable verbose reporting from modpost to help solving
 	    the section mismatches reported.

-config DEBUG_KERNEL
+menuconfig DEBUG_KERNEL
 	bool "Kernel debugging"
 	help
 	  Say Y here if you are developing drivers or trying to debug and
 	  identify kernel problems.

+if DEBUG_KERNEL
+
 config DEBUG_SHIRQ
 	bool "Debug shared IRQ handlers"
-	depends on DEBUG_KERNEL && GENERIC_HARDIRQS
+	depends on GENERIC_HARDIRQS
 	help
 	  Enable this to generate a spurious interrupt as soon as a shared
 	  interrupt handler is registered, and just before one is deregistered.
@@ -131,7 +133,7 @@ config DEBUG_SHIRQ

 config DETECT_SOFTLOCKUP
 	bool "Detect Soft Lockups"
-	depends on DEBUG_KERNEL && !S390
+	depends on !S390
 	default y
 	help
 	  Say Y here to enable the kernel to detect "soft lockups",
@@ -150,7 +152,7 @@ config DETECT_SOFTLOCKUP

 config SCHED_DEBUG
 	bool "Collect scheduler debugging info"
-	depends on DEBUG_KERNEL && PROC_FS
+	depends on PROC_FS
 	default y
 	help
 	  If you say Y here, the /proc/sched_debug file will be provided
@@ -159,7 +161,7 @@ config SCHED_DEBUG

 config SCHEDSTATS
 	bool "Collect scheduler statistics"
-	depends on DEBUG_KERNEL && PROC_FS
+	depends on PROC_FS
 	help
 	  If you say Y here, additional code will be inserted into the
 	  scheduler and related routines to collect statistics about
@@ -171,7 +173,7 @@ config SCHEDSTATS

 config TIMER_STATS
 	bool "Collect kernel timers statistics"
-	depends on DEBUG_KERNEL && PROC_FS
+	depends on PROC_FS
 	help
 	  If you say Y here, additional code will be inserted into the
 	  timer routines to collect statistics about kernel timers being
@@ -185,7 +187,7 @@ config TIMER_STATS

 config DEBUG_SLAB
 	bool "Debug slab memory allocations"
-	depends on DEBUG_KERNEL && SLAB
+	depends on SLAB
 	help
 	  Say Y here to have the kernel do limited verification on memory
 	  allocation as well as poisoning memory on free to catch use of freed
@@ -195,35 +197,9 @@ config DEBUG_SLAB_LEAK
 	bool "Memory leak debugging"
 	depends on DEBUG_SLAB

-config SLUB_DEBUG_ON
-	bool "SLUB debugging on by default"
-	depends on SLUB && SLUB_DEBUG
-	default n
-	help
-	  Boot with debugging on by default. SLUB boots by default with
-	  the runtime debug capabilities switched off. Enabling this is
-	  equivalent to specifying the "slub_debug" parameter on boot.
-	  There is no support for more fine grained debug control like
-	  possible with slub_debug=xxx. SLUB debugging may be switched
-	  off in a kernel built with CONFIG_SLUB_DEBUG_ON by specifying
-	  "slub_debug=-".
-
-config SLUB_STATS
-	default n
-	bool "Enable SLUB performance statistics"
-	depends on SLUB && SLUB_DEBUG && SYSFS
-	help
-	  SLUB statistics are useful to debug SLUBs allocation behavior in
-	  order find ways to optimize the allocator. This should never be
-	  enabled for production use since keeping statistics slows down
-	  the allocator by a few percentage points. The slabinfo command
-	  supports the determination of the most active slabs to figure
-	  out which slabs are relevant to a particular load.
-	  Try running: slabinfo -DA
-
 config DEBUG_PREEMPT
 	bool "Debug preemptible kernel"
-	depends on DEBUG_KERNEL && PREEMPT && (TRACE_IRQFLAGS_SUPPORT || PPC64)
+	depends on PREEMPT && (TRACE_IRQFLAGS_SUPPORT || PPC64)
 	default y
 	help
 	  If you say Y here then the kernel will use a debug variant of the
@@ -233,7 +209,7 @@ config DEBUG_PREEMPT

 config DEBUG_RT_MUTEXES
 	bool "RT Mutex debugging, deadlock detection"
-	depends on DEBUG_KERNEL && RT_MUTEXES
+	depends on RT_MUTEXES
 	help
 	 This allows rt mutex semantics violations and rt mutex related
 	 deadlocks (lockups) to be detected and reported automatically.
@@ -245,13 +221,12 @@ config DEBUG_PI_LIST

 config RT_MUTEX_TESTER
 	bool "Built-in scriptable tester for rt-mutexes"
-	depends on DEBUG_KERNEL && RT_MUTEXES
+	depends on RT_MUTEXES
 	help
 	  This option enables a rt-mutex tester.

 config DEBUG_SPINLOCK
 	bool "Spinlock and rw-lock debugging: basic checks"
-	depends on DEBUG_KERNEL
 	help
 	  Say Y here and build SMP to catch missing spinlock initialization
 	  and certain other kinds of spinlock errors commonly made.  This is
@@ -260,14 +235,13 @@ config DEBUG_SPINLOCK

 config DEBUG_MUTEXES
 	bool "Mutex debugging: basic checks"
-	depends on DEBUG_KERNEL
 	help
 	 This feature allows mutex semantics violations to be detected and
 	 reported.

 config DEBUG_LOCK_ALLOC
 	bool "Lock debugging: detect incorrect freeing of live locks"
-	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
+	depends on TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
 	select DEBUG_SPINLOCK
 	select DEBUG_MUTEXES
 	select LOCKDEP
@@ -281,7 +255,7 @@ config DEBUG_LOCK_ALLOC

 config PROVE_LOCKING
 	bool "Lock debugging: prove locking correctness"
-	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
+	depends on TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
 	select LOCKDEP
 	select DEBUG_SPINLOCK
 	select DEBUG_MUTEXES
@@ -323,7 +297,7 @@ config PROVE_LOCKING

 config LOCKDEP
 	bool
-	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
+	depends on TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
 	select STACKTRACE
 	select FRAME_POINTER if !X86 && !MIPS
 	select KALLSYMS
@@ -331,7 +305,7 @@ config LOCKDEP

 config LOCK_STAT
 	bool "Lock usage statistics"
-	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
+	depends on TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
 	select LOCKDEP
 	select DEBUG_SPINLOCK
 	select DEBUG_MUTEXES
@@ -344,14 +318,13 @@ config LOCK_STAT

 config DEBUG_LOCKDEP
 	bool "Lock dependency engine debugging"
-	depends on DEBUG_KERNEL && LOCKDEP
+	depends on LOCKDEP
 	help
 	  If you say Y here, the lock dependency engine will do
 	  additional runtime checks to debug itself, at the price
 	  of more runtime overhead.

 config TRACE_IRQFLAGS
-	depends on DEBUG_KERNEL
 	bool
 	default y
 	depends on TRACE_IRQFLAGS_SUPPORT
@@ -359,14 +332,12 @@ config TRACE_IRQFLAGS

 config DEBUG_SPINLOCK_SLEEP
 	bool "Spinlock debugging: sleep-inside-spinlock checking"
-	depends on DEBUG_KERNEL
 	help
 	  If you say Y here, various routines which may sleep will become very
 	  noisy if they are called with a spinlock held.

 config DEBUG_LOCKING_API_SELFTESTS
 	bool "Locking API boot-time self-tests"
-	depends on DEBUG_KERNEL
 	help
 	  Say Y here if you want the kernel to run a short self-test during
 	  bootup. The self-test checks whether common types of locking bugs
@@ -377,25 +348,23 @@ config DEBUG_LOCKING_API_SELFTESTS

 config STACKTRACE
 	bool
-	depends on DEBUG_KERNEL
 	depends on STACKTRACE_SUPPORT

 config DEBUG_KOBJECT
 	bool "kobject debugging"
-	depends on DEBUG_KERNEL
 	help
 	  If you say Y here, some extra kobject debugging messages will be sent
 	  to the syslog.

 config DEBUG_HIGHMEM
 	bool "Highmem debugging"
-	depends on DEBUG_KERNEL && HIGHMEM
+	depends on HIGHMEM
 	help
 	  This options enables addition error checking for high memory systems.
 	  Disable for production systems.

 config DEBUG_BUGVERBOSE
-	bool "Verbose BUG() reporting (adds 70K)" if DEBUG_KERNEL && EMBEDDED
+	bool "Verbose BUG() reporting (adds 70K)" if EMBEDDED
 	depends on BUG
 	depends on ARM || AVR32 || M32R || M68K || SPARC32 || SPARC64 || \
 		   FRV || SUPERH || GENERIC_BUG || BLACKFIN || MN10300
@@ -407,7 +376,6 @@ config DEBUG_BUGVERBOSE

 config DEBUG_INFO
 	bool "Compile the kernel with debug info"
-	depends on DEBUG_KERNEL
 	help
           If you say Y here the resulting kernel image will include
 	  debugging info resulting in a larger kernel image.
@@ -420,7 +388,6 @@ config DEBUG_INFO

 config DEBUG_VM
 	bool "Debug VM"
-	depends on DEBUG_KERNEL
 	help
 	  Enable this to turn on extended checks in the virtual-memory system
           that may impact performance.
@@ -429,7 +396,6 @@ config DEBUG_VM

 config DEBUG_WRITECOUNT
 	bool "Debug filesystem writers count"
-	depends on DEBUG_KERNEL
 	help
 	  Enable this to catch wrong use of the writers count in struct
 	  vfsmount.  This will increase the size of each file struct by
@@ -439,7 +405,6 @@ config DEBUG_WRITECOUNT

 config DEBUG_LIST
 	bool "Debug linked list manipulation"
-	depends on DEBUG_KERNEL
 	help
 	  Enable this to turn on extended checks in the linked-list
 	  walking routines.
@@ -448,7 +413,6 @@ config DEBUG_LIST

 config DEBUG_SG
 	bool "Debug SG table operations"
-	depends on DEBUG_KERNEL
 	help
 	  Enable this to turn on checks on scatter-gather tables. This can
 	  help find problems with drivers that do not properly initialize
@@ -458,8 +422,7 @@ config DEBUG_SG

 config FRAME_POINTER
 	bool "Compile the kernel with frame pointers"
-	depends on DEBUG_KERNEL && \
-		(X86 || CRIS || M68K || M68KNOMMU || FRV || UML || S390 || \
+	depends on (X86 || CRIS || M68K || M68KNOMMU || FRV || UML || S390 || \
 		 AVR32 || SUPERH || BLACKFIN || MN10300)
 	default y if DEBUG_INFO && UML
 	help
@@ -470,7 +433,7 @@ config FRAME_POINTER

 config BOOT_PRINTK_DELAY
 	bool "Delay each boot printk message by N milliseconds"
-	depends on DEBUG_KERNEL && PRINTK && GENERIC_CALIBRATE_DELAY
+	depends on PRINTK && GENERIC_CALIBRATE_DELAY
 	help
 	  This build option allows you to read kernel boot messages
 	  by inserting a short delay after each one.  The delay is
@@ -488,7 +451,6 @@ config BOOT_PRINTK_DELAY

 config RCU_TORTURE_TEST
 	tristate "torture tests for RCU"
-	depends on DEBUG_KERNEL
 	depends on m
 	default n
 	help
@@ -501,7 +463,6 @@ config RCU_TORTURE_TEST

 config KPROBES_SANITY_TEST
 	bool "Kprobes sanity tests"
-	depends on DEBUG_KERNEL
 	depends on KPROBES
 	default n
 	help
@@ -513,7 +474,6 @@ config KPROBES_SANITY_TEST

 config BACKTRACE_SELF_TEST
 	tristate "Self test for the backtrace code"
-	depends on DEBUG_KERNEL
 	default n
 	help
 	  This option provides a kernel module that can be used to test
@@ -525,7 +485,6 @@ config BACKTRACE_SELF_TEST

 config LKDTM
 	tristate "Linux Kernel Dump Test Tool Module"
-	depends on DEBUG_KERNEL
 	depends on KPROBES
 	depends on BLOCK
 	default n
@@ -541,7 +500,6 @@ config LKDTM

 config FAULT_INJECTION
 	bool "Fault-injection framework"
-	depends on DEBUG_KERNEL
 	help
 	  Provide fault-injection framework.
 	  For more details, see Documentation/fault-injection/.
@@ -579,6 +537,34 @@ config FAULT_INJECTION_STACKTRACE_FILTER
 	help
 	  Provide stacktrace filter for fault-injection capabilities

+endif # DEBUG_KERNEL
+
+config SLUB_DEBUG_ON
+	bool "SLUB debugging on by default"
+	depends on SLUB && SLUB_DEBUG
+	default n
+	help
+	  Boot with debugging on by default. SLUB boots by default with
+	  the runtime debug capabilities switched off. Enabling this is
+	  equivalent to specifying the "slub_debug" parameter on boot.
+	  There is no support for more fine grained debug control like
+	  possible with slub_debug=xxx. SLUB debugging may be switched
+	  off in a kernel built with CONFIG_SLUB_DEBUG_ON by specifying
+	  "slub_debug=-".
+
+config SLUB_STATS
+	default n
+	bool "Enable SLUB performance statistics"
+	depends on SLUB && SLUB_DEBUG && SYSFS
+	help
+	  SLUB statistics are useful to debug SLUBs allocation behavior in
+	  order find ways to optimize the allocator. This should never be
+	  enabled for production use since keeping statistics slows down
+	  the allocator by a few percentage points. The slabinfo command
+	  supports the determination of the most active slabs to figure
+	  out which slabs are relevant to a particular load.
+	  Try running: slabinfo -DA
+
 config LATENCYTOP
 	bool "Latency measuring infrastructure"
 	select FRAME_POINTER if !MIPS

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================

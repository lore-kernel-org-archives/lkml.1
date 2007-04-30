Return-Path: <linux-kernel-owner+w=401wt.eu-S1946812AbXD3UiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946812AbXD3UiA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 16:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946810AbXD3Uh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 16:37:59 -0400
Received: from rtr.ca ([64.26.128.89]:3856 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946806AbXD3Uh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 16:37:57 -0400
Message-ID: <463653A3.5040606@rtr.ca>
Date: Mon, 30 Apr 2007 16:37:55 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>, tglx@linutronix.de
Cc: Linus Torvalds <torvalds@osdl.org>
Subject: Re: [BUG] 2.6.21: Kernel won't boot with either/both of CONFIG_NO_HZ,
 CONFIG_HIGH_RES_TIMERS
References: <46364EBC.5050804@rtr.ca> <46364F5A.2030208@rtr.ca>
In-Reply-To: <46364F5A.2030208@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Mark Lord wrote:
>> I have a new notebook (Dell Inspiron 9400) with Core2-Duo T7400 @ 2.1Ghz.
>> When either/both of CONFIG_NO_HZ, CONFIG_HIGH_RES_TIMERS is used,
>> the 2.6.21 kernel hangs on startup just after printing one/both of these:
> ..
> 
> That's a hard hang, by the way.  No magic sysrq key or anything.

I've now built a kernel with the same config, plus all of the kernel debug options,
and this one boots.  I think this means the lockups may be due to a very tight
race condition somewhere, and adding all of the debug goodies was enough
to slow it down and avoid the clash (?)

One thing I notice from the syslog, is that with this kernel
there is only the one "switched to high resolution mode on cpu 0" message,
rather than one per-CPU as on the failed kernel.

Here's the diff for the debug config that works:

--- dot_config.nfg	2007-04-30 16:33:31.000000000 -0400
+++ dot_config.boots	2007-04-30 16:22:48.000000000 -0400
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
 # Linux kernel version: 2.6.21
-# Mon Apr 30 15:42:53 2007
+# Mon Apr 30 16:22:48 2007
 #
 CONFIG_X86_32=y
 CONFIG_GENERIC_TIME=y
@@ -56,7 +56,7 @@
 CONFIG_UID16=y
 CONFIG_SYSCTL_SYSCALL=y
 CONFIG_KALLSYMS=y
-# CONFIG_KALLSYMS_ALL is not set
+CONFIG_KALLSYMS_ALL=y
 # CONFIG_KALLSYMS_EXTRA_PASS is not set
 CONFIG_HOTPLUG=y
 CONFIG_PRINTK=y
@@ -2418,39 +2418,45 @@
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
+CONFIG_DEBUG_SHIRQ=y
 CONFIG_LOG_BUF_SHIFT=16
-# CONFIG_DETECT_SOFTLOCKUP is not set
+CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
-# CONFIG_DEBUG_SLAB is not set
-# CONFIG_DEBUG_PREEMPT is not set
-# CONFIG_DEBUG_RT_MUTEXES is not set
+CONFIG_DEBUG_SLAB=y
+CONFIG_DEBUG_SLAB_LEAK=y
+CONFIG_DEBUG_PREEMPT=y
+CONFIG_DEBUG_RT_MUTEXES=y
+CONFIG_DEBUG_PI_LIST=y
 # CONFIG_RT_MUTEX_TESTER is not set
-# CONFIG_DEBUG_SPINLOCK is not set
-# CONFIG_DEBUG_MUTEXES is not set
-# CONFIG_DEBUG_LOCK_ALLOC is not set
-# CONFIG_PROVE_LOCKING is not set
-# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
-# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
-# CONFIG_DEBUG_KOBJECT is not set
-# CONFIG_DEBUG_HIGHMEM is not set
+CONFIG_DEBUG_SPINLOCK=y
+CONFIG_DEBUG_MUTEXES=y
+CONFIG_DEBUG_LOCK_ALLOC=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_LOCKDEP=y
+# CONFIG_DEBUG_LOCKDEP is not set
+CONFIG_TRACE_IRQFLAGS=y
+CONFIG_DEBUG_SPINLOCK_SLEEP=y
+CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
+CONFIG_STACKTRACE=y
+CONFIG_DEBUG_KOBJECT=y
+CONFIG_DEBUG_HIGHMEM=y
 CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_INFO is not set
-# CONFIG_DEBUG_VM is not set
-# CONFIG_DEBUG_LIST is not set
-# CONFIG_FRAME_POINTER is not set
+CONFIG_DEBUG_VM=y
+CONFIG_DEBUG_LIST=y
+CONFIG_FRAME_POINTER=y
 CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_FAULT_INJECTION is not set
-# CONFIG_EARLY_PRINTK is not set
-# CONFIG_DEBUG_STACKOVERFLOW is not set
+CONFIG_EARLY_PRINTK=y
+CONFIG_DEBUG_STACKOVERFLOW=y
 # CONFIG_DEBUG_STACK_USAGE is not set
 
 #
 # Page alloc debug is incompatible with Software Suspend on i386
 #
-# CONFIG_DEBUG_RODATA is not set
+CONFIG_DEBUG_RODATA=y
 # CONFIG_4KSTACKS is not set
 CONFIG_X86_FIND_SMP_CONFIG=y
 CONFIG_X86_MPPARSE=y

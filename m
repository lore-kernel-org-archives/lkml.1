Return-Path: <linux-kernel-owner+w=401wt.eu-S1753527AbXJWQLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbXJWQLt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 12:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbXJWQLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 12:11:41 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:52817 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299AbXJWQLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 12:11:40 -0400
Message-ID: <471E1D3A.8000705@free.fr>
Date: Tue, 23 Oct 2007 18:11:38 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: How to debug complete kernel lock-ups
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

I have an x86 system with two PCI slots, in which I inserted two
specialized output cards (Dektec DTA-105).

http://www.dektec.com/Products/DTA-105/
(They provide an open source driver.)

My problem is: when I write to the 4 ports (each card has 2 ports) "at 
the same time" (not really "at the same time" because I have a 
uni-processor system, so "within a short time frame" is more accurate) 
the system *completely* locks up.

The manufacturer told me they had seen the problem in their lab. I'm 
just trying to provide some helpful debug output to speed up the process 
of fixing the problem :-)

I've built a debug 2.6.22.1-rt9 kernel, hoping to get the kernel to dump 
something, anything.

+CONFIG_KALLSYMS_ALL=y
+CONFIG_PCI_DEBUG=y
+CONFIG_DEBUG_DRIVER=y
+CONFIG_PRINTK_TIME=y
+CONFIG_MAGIC_SYSRQ=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_DEBUG_SHIRQ=y
+CONFIG_DETECT_SOFTLOCKUP=y
+CONFIG_DEBUG_SLAB=y
+CONFIG_DEBUG_SLAB_LEAK=y
+CONFIG_DEBUG_PREEMPT=y
+CONFIG_DEBUG_RT_MUTEXES=y
+CONFIG_DEBUG_PI_LIST=y
+CONFIG_RT_MUTEX_TESTER=y
+CONFIG_DEBUG_SPINLOCK=y
+CONFIG_DEBUG_MUTEXES=y
+CONFIG_DEBUG_LOCK_ALLOC=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_LOCKDEP=y
+CONFIG_TRACE_IRQFLAGS=y
+CONFIG_DEBUG_SPINLOCK_SLEEP=y
+CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
+CONFIG_STACKTRACE=y
+CONFIG_PREEMPT_TRACE=y
+CONFIG_DEBUG_BUGVERBOSE=y
+CONFIG_DEBUG_INFO=y
+CONFIG_FRAME_POINTER=y
+CONFIG_FORCED_INLINING=y
+CONFIG_DEBUG_STACKOVERFLOW=y
+CONFIG_DEBUG_RODATA=y
+CONFIG_4KSTACKS=y

I've enabled the serial console, and used SysRq to bump the console 
level to 9 (I want everything, even KERN_DEBUG output).

I've enabled the IO-APIC watchdog (nmi_watchdog=1).

Once the system locks up, I get no output, no panic, no oops.
The serial console is frozen, my ssh sessions are frozen.

Suppose the PCI bus "crashes" (whatever that means) or locks up.
Would that make the system completely unresponsive? The I/O does have to 
get to/from the south bridge, through the PCI bus AFAIU. I can imagine 
that a locked PCI bus would be slightly problematic.

Does this mean I need some kind of PCI bus analyzer (i.e. hardware) at 
this point? Is there anything more I can try?

Regards.

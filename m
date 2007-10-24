Return-Path: <linux-kernel-owner+w=401wt.eu-S1757494AbXJXP4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494AbXJXP4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 11:56:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753709AbXJXP4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 11:56:47 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50616 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105AbXJXP4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 11:56:46 -0400
Date: Wed, 24 Oct 2007 08:56:37 -0700
From: Greg KH <greg@kroah.com>
To: John Sigler <linux.kernel@free.fr>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: How to debug complete kernel lock-ups
Message-ID: <20071024155637.GA19062@kroah.com>
References: <471E1D3A.8000705@free.fr> <471F0DB4.1080709@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471F0DB4.1080709@free.fr>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 11:17:40AM +0200, John Sigler wrote:
> John Sigler wrote:
>
>> I have an x86 system with two PCI slots, in which I inserted two
>> specialized output cards (Dektec DTA-105).
>> http://www.dektec.com/Products/DTA-105/
>> (They provide an open source driver.)
>> My problem is: when I write to the 4 ports (each card has 2 ports) "at the 
>> same time" (not really "at the same time" because I have a uni-processor 
>> system, so "within a short time frame" is more accurate) the system 
>> *completely* locks up.
>> The manufacturer told me they had seen the problem in their lab. I'm just 
>> trying to provide some helpful debug output to speed up the process of 
>> fixing the problem :-)
>> I've built a debug 2.6.22.1-rt9 kernel, hoping to get the kernel to dump 
>> something, anything.
>> +CONFIG_KALLSYMS_ALL=y
>> +CONFIG_PCI_DEBUG=y
>> +CONFIG_DEBUG_DRIVER=y
>> +CONFIG_PRINTK_TIME=y
>> +CONFIG_MAGIC_SYSRQ=y
>> +CONFIG_DEBUG_KERNEL=y
>> +CONFIG_DEBUG_SHIRQ=y
>> +CONFIG_DETECT_SOFTLOCKUP=y
>> +CONFIG_DEBUG_SLAB=y
>> +CONFIG_DEBUG_SLAB_LEAK=y
>> +CONFIG_DEBUG_PREEMPT=y
>> +CONFIG_DEBUG_RT_MUTEXES=y
>> +CONFIG_DEBUG_PI_LIST=y
>> +CONFIG_RT_MUTEX_TESTER=y
>> +CONFIG_DEBUG_SPINLOCK=y
>> +CONFIG_DEBUG_MUTEXES=y
>> +CONFIG_DEBUG_LOCK_ALLOC=y
>> +CONFIG_PROVE_LOCKING=y
>> +CONFIG_LOCKDEP=y
>> +CONFIG_TRACE_IRQFLAGS=y
>> +CONFIG_DEBUG_SPINLOCK_SLEEP=y
>> +CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
>> +CONFIG_STACKTRACE=y
>> +CONFIG_PREEMPT_TRACE=y
>> +CONFIG_DEBUG_BUGVERBOSE=y
>> +CONFIG_DEBUG_INFO=y
>> +CONFIG_FRAME_POINTER=y
>> +CONFIG_FORCED_INLINING=y
>> +CONFIG_DEBUG_STACKOVERFLOW=y
>> +CONFIG_DEBUG_RODATA=y
>> +CONFIG_4KSTACKS=y
>> I've enabled the serial console, and used SysRq to bump the console level 
>> to 9 (I want everything, even KERN_DEBUG output).
>> I've enabled the IO-APIC watchdog (nmi_watchdog=1).
>> Once the system locks up, I get no output, no panic, no oops.
>> The serial console is frozen, my ssh sessions are frozen.
>> Suppose the PCI bus "crashes" (whatever that means) or locks up.
>> Would that make the system completely unresponsive? The I/O does have to 
>> get to/from the south bridge, through the PCI bus AFAIU. I can imagine 
>> that a locked PCI bus would be slightly problematic.
>> Does this mean I need some kind of PCI bus analyzer (i.e. hardware) at 
>> this point? Is there anything more I can try?
>
> I've tested with a vanilla 2.6.22.10 kernel (no PREEMPT_RT patch).
> That system also locks up and remains completely unresponsive (I can't open 
> new ssh sessions, the system won't answer ICMP echo requests).
>
> How do driver writers deal with complete kernel hangs?

We slowly go crazy :)

Seriously, try to add debugging messages for where you think things
might be dying and slowly start working from there.  It's not a quick
thing to do at times...

Oh, try using kdb, that sometimes will work for people, depending on
your hardware and problem.

good luck,

greg k-h

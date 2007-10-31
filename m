Return-Path: <linux-kernel-owner+w=401wt.eu-S1756719AbXJaJ0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719AbXJaJ0J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 05:26:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753871AbXJaJZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 05:25:57 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:53955 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653AbXJaJZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 05:25:56 -0400
Message-ID: <47284A21.1070901@free.fr>
Date: Wed, 31 Oct 2007 10:25:53 +0100
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
CC: greg@kroah.com, ray-lk@madrabbit.org, grundler@parisc-linux.org
Subject: Re: How to debug complete kernel lock-ups
References: <471E1D3A.8000705@free.fr> <471F0DB4.1080709@free.fr>
In-Reply-To: <471F0DB4.1080709@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Sigler wrote:

> John Sigler wrote:
> 
>> I have an x86 system with two PCI slots, in which I inserted two
>> specialized output cards (Dektec DTA-105).
>>
>> http://www.dektec.com/Products/DTA-105/
>> (They provide an open source driver.)
>>
>> My problem is: when I write to the 4 ports (each card has 2 ports) "at 
>> the same time" (not really "at the same time" because I have a 
>> uni-processor system, so "within a short time frame" is more accurate) 
>> the system *completely* locks up.
>>
>> The manufacturer told me they had seen the problem in their lab. I'm 
>> just trying to provide some helpful debug output to speed up the 
>> process of fixing the problem :-)
>>
>> I've built a debug 2.6.22.1-rt9 kernel, hoping to get the kernel to 
>> dump something, anything.
>>
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
>>
>> I've enabled the serial console, and used SysRq to bump the console 
>> level to 9 (I want everything, even KERN_DEBUG output).
>>
>> I've enabled the IO-APIC watchdog (nmi_watchdog=1).
>>
>> Once the system locks up, I get no output, no panic, no oops.
>> The serial console is frozen, my ssh sessions are frozen.
>>
>> Suppose the PCI bus "crashes" (whatever that means) or locks up.
>> Would that make the system completely unresponsive? The I/O does have 
>> to get to/from the south bridge, through the PCI bus AFAIU. I can 
>> imagine that a locked PCI bus would be slightly problematic.
>>
>> Does this mean I need some kind of PCI bus analyzer (i.e. hardware) at 
>> this point? Is there anything more I can try?
> 
> I've tested with a vanilla 2.6.22.10 kernel (no PREEMPT_RT patch).
> That system also locks up and remains completely unresponsive (I can't 
> open new ssh sessions, the system won't answer ICMP echo requests).
> 
> How do driver writers deal with complete kernel hangs?

I sent the problematic system to the board manufacturer.
This is what their engineers told me:

"It seems that the PCI clock on this system has a rather large over- and 
undershoot and we suspect that the undershoot (of ~1V) is causing a drop 
in the core voltage of the on-board FPGA which results in lockup of the 
firmware. Both the under- and overshoot are well outside the allowed 
ranges (high=VCC+0.5V and low=-0.5V) of the PCI specification and a 
premature conclusion might be that the system does not comply to the PCI 
spec and that this is the cause of the lockup on this PC."

This is waaay out of my league, as my area is software.

Is it typical for voltage issues to hang hardware?

Is it typical for one PCI board locking up to nail the entire system?

I don't understand why the lockup would only happen when I write to the 
4 ports within a small time frame, and not when I only write to 2 ports 
(either one port on each card, or 2 ports on the same card). I suspected 
some kind of concurrency issue...

I suppose the next logical step is to get the board's engineers
and the system's engineers duke it out? :-)

Regards.

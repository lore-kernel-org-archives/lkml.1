Return-Path: <linux-kernel-owner+w=401wt.eu-S1756417AbZLNEhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417AbZLNEhk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 23:37:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756091AbZLNEhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 23:37:38 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:45663 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756037AbZLNEhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 23:37:37 -0500
Message-ID: <4B25C10B.9040001@in.ibm.com>
Date: Mon, 14 Dec 2009 10:07:31 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-next@vger.kernel.org
Subject: Re: [Next] CPU Hotplug test failures on powerpc
References: <4B2224C7.1020908@in.ibm.com> <1260758933.2217.7.camel@pasglop>
In-Reply-To: <1260758933.2217.7.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> On Fri, 2009-12-11 at 16:23 +0530, Sachin Sant wrote:
>   
>> While executing cpu_hotplug(from autotest) tests against latest
>> next on a power6 box, the machine locks up. A soft reset shows
>> the following trace
>>     
>
> Have you heard anything about that one yet or it's still to be
> debugged ? It probably hit upstream by now.
>   
Haven't received any response yet.

As you mentioned that patch went upstream and so did the problem.

thanks
-Sachin

> Cheers,
> Ben.
>
>   
>> cpu 0x0: Vector: 100 (System Reset) at [c00000000c9333d0]
>>     pc: c0000000003433d8: .find_next_bit+0x54/0xc4
>>     lr: c000000000342f10: .cpumask_next_and+0x4c/0x94
>>     sp: c00000000c933650
>>    msr: 8000000000089032
>>   current = 0xc00000000c173840
>>   paca    = 0xc000000000bc2600
>>     pid   = 2602, comm = hotplug06.top.s
>> enter ? for help
>> [link register   ] c000000000342f10 .cpumask_next_and+0x4c/0x94
>> [c00000000c933650] c0000000000e9f34 .cpuset_cpus_allowed_locked+0x38/0x74 (unreliable)
>> [c00000000c9336e0] c000000000090074 .move_task_off_dead_cpu+0xc4/0x1ac
>> [c00000000c9337a0] c0000000005e4e5c .migration_call+0x304/0x830
>> [c00000000c933880] c0000000005e0880 .notifier_call_chain+0x68/0xe0
>> [c00000000c933920] c00000000012a92c ._cpu_down+0x210/0x34c
>> [c00000000c933a90] c00000000012aad8 .cpu_down+0x70/0xa8
>> [c00000000c933b20] c000000000525940 .store_online+0x54/0x894
>> [c00000000c933bb0] c000000000463430 .sysdev_store+0x3c/0x50
>> [c00000000c933c20] c0000000001f8320 .sysfs_write_file+0x124/0x18c
>> [c00000000c933ce0] c00000000017edac .vfs_write+0xd4/0x1fc
>> [c00000000c933d80] c00000000017efdc .SyS_write+0x58/0xa0
>> [c00000000c933e30] c0000000000085b4 syscall_exit+0x0/0x40
>> --- Exception: c01 (System Call) at 00000fff9fa8a8f8
>> SP (fffe7aef200) is in userspace
>> 0:mon> e
>> cpu 0x0: Vector: 100 (System Reset) at [c00000000c9333d0]
>>     pc: c0000000003433d8: .find_next_bit+0x54/0xc4
>>     lr: c000000000342f10: .cpumask_next_and+0x4c/0x94
>>     sp: c00000000c933650
>>    msr: 8000000000089032
>>   current = 0xc00000000c173840
>>   paca    = 0xc000000000bc2600
>>     pid   = 2602, comm = hotplug06.top.s
>>
>> Last few messages from the dmesg log shows
>>
>> 0:mon> 
>> <4>IRQ 17 affinity broken off cpu 0
>> <4>IRQ 18 affinity broken off cpu 0
>> <4>IRQ 19 affinity broken off cpu 0
>> <4>IRQ 264 affinity broken off cpu 0
>> <4>cpu 0 (hwid 0) Ready to die...
>> <7>clockevent: decrementer mult[83126e97] shift[32] cpu[0]
>> <4>Processor 0 found.
>> <4>IRQ 17 affinity broken off cpu 1
>> <4>IRQ 18 affinity broken off cpu 1
>> <4>IRQ 19 affinity broken off cpu 1
>> <4>IRQ 264 affinity broken off cpu 1
>> <4>cpu 1 (hwid 1) Ready to die...
>> <7>clockevent: decrementer mult[83126e97] shift[32] cpu[1]
>> <4>Processor 1 found.
>> <4>cpu 1 (hwid 1) Ready to die...
>> <7>clockevent: decrementer mult[83126e97] shift[32] cpu[1]
>> <4>Processor 1 found.
>> <4>cpu 1 (hwid 1) Ready to die...
>> <6>process 2423 (bash) no longer affine to cpu1
>> <7>clockevent: decrementer mult[83126e97] shift[32] cpu[1]
>> <4>Processor 1 found.
>> <4>cpu 1 (hwid 1) Ready to die...
>> <7>clockevent: decrementer mult[83126e97] shift[32] cpu[1]
>> <4>Processor 1 found.
>> <4>cpu 1 (hwid 1) Ready to die...
>> <7>clockevent: decrementer mult[83126e97] shift[32] cpu[1]
>> <4>Processor 1 found.
>> <4>cpu 1 (hwid 1) Ready to die...
>> <3>INFO: RCU detected CPU 0 stall (t=1000 jiffies)
>> <3>INFO: RCU detected CPU 0 stall (t=4000 jiffies)
>> 0:mon>
>>
>> After some debugging a possible suspect seems to be commit
>> 6ad4c18.. : sched: Fix balance vs hotplug race
>>
>> If i revert this patch i am able to execute the tests on this
>> power6 without any issues. 
>>
>> But at the same time the above patch is required to solve the
>> cpu hotplug related race on x86_64(as a side note this same
>> x86_64 issue can be recreated against latest Linus git as well)
>> that i reported here :
>>
>> http://marc.info/?l=linux-kernel&m=125802682922299&w=2
>>
>> I will try few more iterations with and without the above
>> patch just to make sure i have the correct results.
>>
>> If someone has a suggestion let me know.
>>
>> Thanks
>> -Sachin
>>
>>
>>     
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-next" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>   


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755504AbYJXQhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504AbYJXQhy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 12:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753091AbYJXQhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 12:37:46 -0400
Received: from gate.crashing.org ([63.228.1.57]:43241 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899AbYJXQhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 12:37:45 -0400
Cc: maxk@qualcomm.com, LinuxPPC-dev list <linuxppc-dev@ozlabs.org>,
       linux-kernel Kernel <linux-kernel@vger.kernel.org>, tglx@linutronix.de
Message-Id: <5967704E-0117-46B8-8505-6A002502C38C@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Chris Snook <csnook@redhat.com>
In-Reply-To: <4901F31E.9040007@redhat.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: default IRQ affinity change in v2.6.27 (breaking several SMP PPC based systems)
Date: Fri, 24 Oct 2008 11:36:42 -0500
References: <4E3CD4D5-FC1B-40BF-A776-C612B95806B8@kernel.crashing.org> <4901E6FB.4070200@redhat.com> <36A821E7-7F37-42AF-9A05-7205FCBF89EE@kernel.crashing.org> <4901F31E.9040007@redhat.com>
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 24, 2008, at 11:09 AM, Chris Snook wrote:

> Kumar Gala wrote:
>> On Oct 24, 2008, at 10:17 AM, Chris Snook wrote:
>>> Kumar Gala wrote:
>>>> It appears the default IRQ affinity changes from being just cpu 0  
>>>> to all cpu's.  This breaks several PPC SMP systems in which only  
>>>> a single processor is allowed to be selected as the destination  
>>>> of the IRQ.
>>>> What is the right answer in fixing this?  Should we:
>>>>   cpumask_t irq_default_affinity = 1;
>>>> instead of
>>>>   cpumask_t irq_default_affinity = CPU_MASK_ALL?
>>>
>>> On those systems, perhaps, but not universally.  There's plenty of  
>>> hardware where the physical topology of the machine is abstracted  
>>> away from the OS, and you need to leave the mask wide open and let  
>>> the APIC figure out where to map the IRQs.  Ideally, we should  
>>> probably make this decision based on the APIC, but if there's no  
>>> PPC hardware that uses this technique, then it would suffice to  
>>> make this arch-specific.
>> What did those systems do before this patch?  Its one thing to  
>> expose a mask in the ability to change the default mask in /proc/ 
>> irq/default_smp_affinity.  Its another (and a regression in my  
>> opinion) to change the mask value itself.
>
> Before the patch they took an extremely long time to boot if they  
> had storage attached to each node of a multi-chassis system,  
> performed poorly unless special irqbalance hackery or manual  
> assignment was used, and imposed artificial restrictions on the  
> granularity of hardware partitioning to ensure that CPU 0 would  
> always be a CPU that could service all interrupts necessary to boot  
> the OS.
>
>> As for making it ARCH specific, that doesn't really help since not  
>> all PPC hw has the limitation I spoke of.  Not even all MPIC (in  
>> our cases) have the limitation.
>
> What did those systems do before this patch? :)
>
> Making it arch-specific is an extremely simple way to solve your  
> problem without making trouble for the people who wanted this patch  
> in the first place.  If PPC needs further refinement to handle  
> particular *PICs, you can implement that without touching any arch- 
> generic code.


So why not just have x86 startup code set irq_default_affinity =  
CPU_MASK_ALL than?

- k

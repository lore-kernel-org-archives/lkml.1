Return-Path: <linux-kernel-owner+w=401wt.eu-S1755185AbYHOBmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185AbYHOBmL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 21:42:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752329AbYHOBl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 21:41:57 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:5271 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbYHOBl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 21:41:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ih2ombx0+tW+B4NjP+MpY4kPWTLzkLyo8h/rVw4hpN0dKR4km8ERa2jpfQIuiLFr0M
         pVeh1z4iYfNHizz7XtssgbLLPUsr+Za9KR45yMvmiaAUCsMM9BzU6z3/XP3bLfPKdRYk
         Vo+qXlrhZ5sQAVAojTOm6M1QILUUH7ov+lCFw=
Message-ID: <86802c440808141841t3ab7e745pc5266dcfaa64d1aa@mail.gmail.com>
Date: Thu, 14 Aug 2008 18:41:55 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 00/53] dyn_array/nr_irqs/sparse_irq support v10
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <m1bpzv851l.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1218705441-21838-1-git-send-email-yhlu.kernel@gmail.com>
	 <20080814132638.GA18743@elte.hu>
	 <86802c440808141201o2c66236cwbc5ce37f9675504d@mail.gmail.com>
	 <m1ljyzcqg4.fsf@frodo.ebiederm.org>
	 <86802c440808141342k6cb0dc59ud067018b0a171232@mail.gmail.com>
	 <86802c440808141424u3284f862gcd81e3cc585ddac4@mail.gmail.com>
	 <m1zlnf87d8.fsf@frodo.ebiederm.org>
	 <86802c440808141749l626d59e6h888b802343916df3@mail.gmail.com>
	 <m1bpzv851l.fsf@frodo.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2008 at 6:01 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
>
>> On Thu, Aug 14, 2008 at 5:11 PM, Eric W. Biederman
>> <ebiederm@xmission.com> wrote:
>>> "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
>>>
>>>> find something interesting:
>>>>
>>>> found new irq_cfg for irq 20
>>>>  0 add_pin_to_irq: irq 20 --> apic 0 pin 20
>>>> assign_irq_vector: irq 20 vector 0x59 cpu  5
>>>> IOAPIC[0]: Set routing entry (0-20 -> 0x59 -> IRQ 20 Mode:1 Active:1)
>>>> found new irq_desc for irq 20
>>>> pci 0000:00:02.1: PCI INT B -> Link[LUS2] -> GSI 20 (level, low) -> IRQ 20
>>>>
>>>> IO APIC #0......
>>>> .... register #00: 00000000
>>>> .......    : physical APIC id: 00
>>>> .......    : Delivery Type: 0
>>>> .......    : LTS          : 0
>>>> .... register #01: 00170011
>>>> .......     : max redirection entries: 0017
>>>> .......     : PRQ implemented: 0
>>>> .......     : IO APIC version: 0011
>>>> .... register #02: 00000000
>>>> .......     : arbitration: 00
>>>> .... IRQ redirection table:
>>>>  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
>>>> ...
>>>>  14 09  1    1    0   1   0    0    0    59
>>>> ...
>>>>
>>>> ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
>>>> do_IRQ: cannot handle IRQ -1 vector 0x59 cpu 0
>>>> ------------[ cut here ]------------
>>>> Kernel BUG at 40206b11 [verbose debug info unavailable]
>>>> invalid opcode: 0000 [#1] SMP
>>>> Modules linked in:
>>>>
>>>> Pid: 70, comm: kasyncinit Not tainted (2.6.27-rc3-tip-00191-g98ccb89-dirty
>> #23)
>>>> EIP: 0060:[<40206b11>] EFLAGS: 00010092 CPU: 0
>>>> EIP is at do_IRQ+0x6b/0xae
>>>> EAX: 00000032 EBX: 00001d28 ECX: 00003434 EDX: 00000046
>>>> ESI: 00000000 EDI: 00000059 EBP: c7a37d3c ESP: c7a37d14
>>>>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
>>>> Process kasyncinit (pid: 70, ti=c7a36000 task=c79c9860 task.ti=c7a36000)
>>>> Stack: 40a74317 40814ea0 ffffffff 00000059 00000000 00000000 ffffffff
>> c421bd20
>>>> c7a37d9c c7a37dac c7a37d7c 4020555f c421bd20 00000000 c421bd20 c7a37d9c
>>>> c7a37dac c7a37d7c 40b717f8 0000007b 0000007b 000000d8 ffffffa6 4080db6c
>>>> Call Trace:
>>>>  [<4020555f>] ? common_interrupt+0x23/0x28
>>>>
>>>>
>>>> it is on 16cores system with 32bit bigsmp, so it is using phy_flat
>>>> cpu 5 has apicid 9, and ioapic reg setting right with Dmod= 0 ( phys)
>>>>
>>>> but io_apic controller deliver that interrupt to cpu0 (with apicid =
>>>> 4) instead of cpu 5 (with apic id = 9)
>>>>
>>>> look at the 64 bit, TARGET_CPUS for phys_flat is cpu_online_map
>>>>
>>>> and 32bit bigsmp TARGET_CPUS is only one cpu set and rotating with online
>> cpu...
>>>>
>>>> Change 32bit bigsmp TARGE_CPUS ?
>>>
>>> Set vector_allocation_domain to CPU_MASK_ALL on 32bit.  That doesn't give us
>>> the benefit of per cpu vectors right now, but in my research there has not
>>> been a 32bit kernel yet that has needed it.  We have never shared vectors
>>> between 2 gsi on 32bit x86, we have only collapsed the irq space.
>>
>> TARGET_CPUS only used by ioapic_xx.c
>
> Target cpus is a hint to tell us what to do if the user has not.
>
>> vector_allocator_domain will return cpumask_of_cpu(cpu)..
>
> Which is a bug for lowest priority delivery mode.  But you said
> phys_flat and not flat.  Which sounds like bigsmp last I read it.
>
>>> On x86_64 before I did the per cpu vectors there were machines that
>>> combined multiple interrupt sources (gsi) into the same irq.  So
>>> x86_64 has needed the per cpu vectors.
>>>
>>> Which means in practice that the irq compression on x86_32 was just a hack to
>>> with not having enough irq_desc entries.  I wish I had realized that last
>>> time we were talking, as we could have unilaterally ripped out all of that
>>> code as completely unnecessary on x86 and just bumped NR_IRQS to 1024 on
>>> the boxes that had more than 256 gsis.
>>
>> now 32bit and 64bit is the same page now... (bigsmp == phys_flat)...
>>
>> will continue to merge io_apic_xx.c
>
> Hmm.  In that case I will ask that you look at all of the pieces of
> irq migration code, and make certain that they have all come from x86_64.

yes, done. now it is same as 64 bit.

YH

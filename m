Return-Path: <linux-kernel-owner+w=401wt.eu-S1757263AbYHDSMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263AbYHDSMp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 14:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755636AbYHDSMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 14:12:30 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:45588 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287AbYHDSM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 14:12:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=u6nGLUcSt1xFBLFoCno4LGwG5UamkXKqZzEEbvztzC5xNmzVHGYVgZ7jay/ZbRsAFh
         VxKMS5VphVUtXRusQ91GJniVhUBo85YjHxzFgMIShsjxVvu0++tERKV4iMNqLEEWO6fA
         0uVyjXTNFnedcvDsEoaQjNz5r72LdMOv20ULg=
Message-ID: <86802c440808041112h29204f5at447b0279e1b6d4eb@mail.gmail.com>
Date: Mon, 4 Aug 2008 11:12:28 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Mike Travis" <travis@sgi.com>
Subject: Re: [PATCH 02/04] x86: add get_irq_cfg in io_apic_64.c
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <48971A1E.5040704@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1217844601-4298-1-git-send-email-yhlu.kernel@gmail.com>
	 <1217844601-4298-2-git-send-email-yhlu.kernel@gmail.com>
	 <1217844601-4298-3-git-send-email-yhlu.kernel@gmail.com>
	 <48971A1E.5040704@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 4, 2008 at 8:02 AM, Mike Travis <travis@sgi.com> wrote:
> Yinghai Lu wrote:
>> preallocate size is 32, and if is not enough, get_irq_cfg will more with alloc_bootmem or kzalloc
>>
>> got:
>> dyn_array irq_2_pin+0x0/0x8 size:0x8 nr:192 align:0x8
>> dyn_array irq_cfgx+0x0/0x8 size:0x118 nr:32 align:0x1000
>> dyn_array irq_desc+0x0/0x8 size:0x180 nr:32 align:0x1000
>> dyn_array irq_2_iommu+0x0/0x8 size:0x10 nr:96 align:0x1000
>> dyn_array irq_timer_state+0x0/0x50 size:0x8 nr:96 align:0x1000
>> dyn_array total_size: 0x8600
>> dyn_array irq_2_pin+0x0/0x8  ==> [0x28028000 - 0x28028600]
>> dyn_array irq_cfgx+0x0/0x8  ==> [0x28029000 - 0x2802b300]
>> dyn_array irq_desc+0x0/0x8  ==> [0x2802c000 - 0x2802f000]
>> dyn_array irq_2_iommu+0x0/0x8  ==> [0x2802f000 - 0x2802f600]
>> dyn_array irq_timer_state+0x0/0x50  ==> [0x28030000 - 0x28030300]
>> ...
>> ENABLING IO-APIC IRQs
>> init IO_APIC IRQs
>>  IO-APIC (apicid-pin) 0-0 not connected.
>> IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
>> IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0)
>> IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0)
>> IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
>> IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:0 Active:0)
>> IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
>> IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
>> IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
>> IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0)
>> IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
>> IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:0 Active:0)
>> IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
>> IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
>> IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
>> IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
>>  IO-APIC (apicid-pin) 0-16, 0-17, 0-18, 0-19, 0-20, 0-21, 0-22, 0-23, 1-0, 1-1, 1-2, 1-3, 1-4, 1-5, 1-6, 1-7, 1-8, 1-9, 1-10, 1-11, 1-12, 1-13, 1-14, 1-15, 1-16, 1-17, 1-18, 1-19, 1-20, 1-21, 1-22, 1-23 not connected.
>> try to get more irq_cfg 32
>> try to get more irq_cfg 32
>> ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
>> ...
>>
>> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>>
>> ---
>>  arch/x86/kernel/io_apic_64.c |  181 +++++++++++++++++++++++++++++++++----------
>>  1 file changed, 141 insertions(+), 40 deletions(-)
>>
>> Index: linux-2.6/arch/x86/kernel/io_apic_64.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/kernel/io_apic_64.c
>> +++ linux-2.6/arch/x86/kernel/io_apic_64.c
>> @@ -57,7 +57,11 @@
>>
>>  #define __apicdebuginit(type) static type __init
>>
>> +struct irq_cfg;
>> +
>>  struct irq_cfg {
>> +     unsigned int irq;
>> +     struct irq_cfg *next;
>>       cpumask_t domain;
>>       cpumask_t old_domain;
>        ^^^^^^^^^
> One thought here... most interrupts cannot be serviced by any cpu in
> the system, but instead need to be serviced by the cpu attached to
> the ioapic or on the local node.  So defining some subset of cpumask_t
> would save a lot of space.  For example:
>
>        nodecpumask_t {
>                int     node;
>                DEFINE_BITMAP(..., MAX_CPUS_PER_NODE);
>        };
>
> And of course, providing some utilities to convert nodecpumask_t <==>
> cpumask_t.
>
> ("node" might not be the proper abstraction... maybe "irqcpumask_t"?)
union irq_cpumask_t {
            int     cpu;
            unsigned long mask;
};

also thinking if we can have dyn_cpumask_t etc if NR_CPU=4096, but
nr_cpus or nr_cpu_ids=32 in running time.
with that distributions could have NR_CPU=4096 as default config...

YH

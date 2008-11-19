Return-Path: <linux-kernel-owner+w=401wt.eu-S1752693AbYKSHjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbYKSHjd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 02:39:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025AbYKSHjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 02:39:23 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:20870 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737AbYKSHjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 02:39:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=fjTzQFh8qS/Vf15JfFIiMUwp8Qy4PUchwgPbZpRRsl4AWbumoNbQZCymJ8Ol/27ohf
         eZ+m24C6W8+DlJfcy/UZptmpO2cYpsk4lgnKNcSA1PQml7SBmh2KhytGLtQUiKqMoK8f
         e2hC7DWF8hOinhAo/gnaP8N33OdtzIqcDVQMQ=
Message-ID: <386072610811182339n54f67624o1595144b4b86d4b8@mail.gmail.com>
Date: Wed, 19 Nov 2008 15:39:20 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/5] Blackfin arch: SMP supporting patchset: BF561 related code
Cc: torvalds@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       "Graf Yang" <graf.yang@analog.com>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-arch@vger.kernel.org
In-Reply-To: <20081118225625.39e660ff.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1226999108-13839-1-git-send-email-cooloney@kernel.org>
	 <1226999108-13839-2-git-send-email-cooloney@kernel.org>
	 <20081118225625.39e660ff.akpm@linux-foundation.org>
X-Google-Sender-Auth: 3e4e06d05110c09a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2008 at 2:56 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 18 Nov 2008 17:05:04 +0800 Bryan Wu <cooloney@kernel.org> wrote:
>
>> From: Graf Yang <graf.yang@analog.com>
>>
>> Blackfin dual core BF561 processor can support SMP like features.
>> https://docs.blackfin.uclinux.org/doku.php?id=linux-kernel:smp-like
>>
>> In this patch, we provide SMP extend to BF561 kernel code
>>
>>
>> ...
>>
>> --- a/arch/blackfin/mach-bf561/include/mach/mem_map.h
>> +++ b/arch/blackfin/mach-bf561/include/mach/mem_map.h
>> @@ -85,4 +85,124 @@
>>  #define L1_SCRATCH_START     COREA_L1_SCRATCH_START
>>  #define L1_SCRATCH_LENGTH    0x1000
>>
>> +#ifndef __ASSEMBLY__
>> +
>> +#ifdef CONFIG_SMP
>> +
>> +#define get_l1_scratch_start_cpu(cpu)                                \
>> +     ({ unsigned long __addr;                                \
>> +        __addr = (cpu) ? COREB_L1_SCRATCH_START : COREA_L1_SCRATCH_START;\
>> +        __addr; })
>> +
>> +#define get_l1_code_start_cpu(cpu)                           \
>> +     ({ unsigned long __addr;                                \
>> +        __addr = (cpu) ? COREB_L1_CODE_START : COREA_L1_CODE_START;  \
>> +        __addr; })
>> +
>> +#define get_l1_data_a_start_cpu(cpu)                         \
>> +     ({ unsigned long __addr;                                \
>> +        __addr = (cpu) ? COREB_L1_DATA_A_START : COREA_L1_DATA_A_START;\
>> +        __addr; })
>> +
>> +#define get_l1_data_b_start_cpu(cpu)                         \
>> +     ({ unsigned long __addr;                                \
>> +        __addr = (cpu) ? COREB_L1_DATA_B_START : COREA_L1_DATA_B_START;\
>> +        __addr; })
>> +
>> +#define get_l1_scratch_start()       get_l1_scratch_start_cpu(blackfin_core_id())
>> +#define get_l1_code_start()  get_l1_code_start_cpu(blackfin_core_id())
>> +#define get_l1_data_a_start()        get_l1_data_a_start_cpu(blackfin_core_id())
>> +#define get_l1_data_b_start()        get_l1_data_b_start_cpu(blackfin_core_id())
>> +
>> +#else /* !CONFIG_SMP */
>> +#define get_l1_scratch_start_cpu(cpu)        L1_SCRATCH_START
>> +#define get_l1_code_start_cpu(cpu)   L1_CODE_START
>> +#define get_l1_data_a_start_cpu(cpu) L1_DATA_A_START
>> +#define get_l1_data_b_start_cpu(cpu) L1_DATA_B_START
>> +#define get_l1_scratch_start()               L1_SCRATCH_START
>> +#define get_l1_code_start()          L1_CODE_START
>> +#define get_l1_data_a_start()                L1_DATA_A_START
>> +#define get_l1_data_b_start()                L1_DATA_B_START
>> +#endif /* !CONFIG_SMP */
>
> grumble.  These didn't need to be implemented as macros and hence
> shouldn't have been.
>
> Example:
>
>        int cpu = smp_processor_id();
>        get_l1_scratch_start_cpu(cpu);
>
> that code should generate unused variable warnings on CONFIG_SMP=n.  If
> it doesn't, you got lucky, because it _should_.
>
> Also
>
>        int cpu = smp_processor_id();
>        get_l1_scratch_start_cpu(pcu);
>
> will happily compile and run with CONFIG_SMP=n.
>
>
> macros=bad,bad,bad.
>

Yes, I also prefer inline functions rather than macros here.
Right, Graf?

>>
>> ...
>>
>> --- /dev/null
>> +++ b/arch/blackfin/mach-bf561/smp.c
>> @@ -0,0 +1,182 @@
>> +/*
>> + * File:         arch/blackfin/mach-bf561/smp.c
>> + * Author:       Philippe Gerum <rpm@xenomai.org>
>> + *
>> + *               Copyright 2007 Analog Devices Inc.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program; if not, see the file COPYING, or write
>> + * to the Free Software Foundation, Inc.,
>> + * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>> + */
>> +
>> +#include <linux/init.h>
>> +#include <linux/kernel.h>
>> +#include <linux/sched.h>
>> +#include <linux/delay.h>
>> +#include <asm/smp.h>
>> +#include <asm/dma.h>
>> +
>> +#define COREB_SRAM_BASE  0xff600000
>> +#define COREB_SRAM_SIZE  0x4000
>> +
>> +extern char coreb_trampoline_start, coreb_trampoline_end;
>
> OK, these are defined in .S and we do often put declarations for such
> things in .c rather than in .h.  But I think it's better to put them in
> .h anyway, to avoid possibly duplicated declarations in the future.
>

Oh, I suggested Graf to run checkpatch.pl to find some issues before I
sent out this patch.
Should this issues be catched by checkpatch.pl?


>> +static DEFINE_SPINLOCK(boot_lock);
>> +
>> +static cpumask_t cpu_callin_map;
>> +
>>
>> ...
>>
>> +void __cpuinit platform_secondary_init(unsigned int cpu)
>> +{
>> +     local_irq_disable();
>> +
>> +     /* Clone setup for peripheral interrupt sources from CoreA. */
>> +     bfin_write_SICB_IMASK0(bfin_read_SICA_IMASK0());
>> +     bfin_write_SICB_IMASK1(bfin_read_SICA_IMASK1());
>> +     SSYNC();
>> +
>> +     /* Clone setup for IARs from CoreA. */
>> +     bfin_write_SICB_IAR0(bfin_read_SICA_IAR0());
>> +     bfin_write_SICB_IAR1(bfin_read_SICA_IAR1());
>> +     bfin_write_SICB_IAR2(bfin_read_SICA_IAR2());
>> +     bfin_write_SICB_IAR3(bfin_read_SICA_IAR3());
>> +     bfin_write_SICB_IAR4(bfin_read_SICA_IAR4());
>> +     bfin_write_SICB_IAR5(bfin_read_SICA_IAR5());
>> +     bfin_write_SICB_IAR6(bfin_read_SICA_IAR6());
>> +     bfin_write_SICB_IAR7(bfin_read_SICA_IAR7());
>> +     SSYNC();
>> +
>> +     local_irq_enable();
>> +
>> +     /* Calibrate loops per jiffy value. */
>> +     calibrate_delay();
>> +
>> +     /* Store CPU-private information to the cpu_data array. */
>> +     bfin_setup_cpudata(cpu);
>> +
>> +     /* We are done with local CPU inits, unblock the boot CPU. */
>> +     cpu_set(cpu, cpu_callin_map);
>> +     spin_lock(&boot_lock);
>> +     spin_unlock(&boot_lock);
>
> Is this spin_lock()+spin_unlock() supposed to block until the secondary
> CPU is running?  If so, I don't think it works.
>

We can remove these 2 line spin_lock+spin_unlock and it also works.
But maybe we will add some operation between spin_lock and spin_unlock
here in the future,
we'd like to keep them.

P.S. also forward this patch to linux-arch

Thanks
-Bryan

>> +}
>> +
>>
>> ...
>>
>
>

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752964AbZAFOCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbZAFOCT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 09:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751619AbZAFOCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 09:02:08 -0500
Received: from relay1.sgi.com ([192.48.179.29]:51968 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751588AbZAFOCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 09:02:07 -0500
Message-ID: <4963645A.1040201@sgi.com>
Date: Tue, 06 Jan 2009 06:02:02 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@infradead.org>
CC: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/11] x86: cleanup remaining cpumask_t ops in smpboot
 code
References: <1231222512.3235.6.camel@jaswinder.satnam> <1231223480.3235.22.camel@jaswinder.satnam>
In-Reply-To: <1231223480.3235.22.camel@jaswinder.satnam>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
> Hello Mike,
> 
> On Sun, Jan 4, 2009 at 6:48 PM, Mike Travis <travis@sgi.com> wrote:
>> ﻿--- linux-2.6-for-ingo.orig/arch/x86/include/asm/smp.h
>> +++ linux-2.6-for-ingo/arch/x86/include/asm/smp.h
>> @@ -18,9 +18,26 @@
>>  #include <asm/pda.h>
>>  #include <asm/thread_info.h>
>>  
>> +#ifdef CONFIG_X86_64
>> +
>> +extern cpumask_var_t cpu_callin_mask;
>> +extern cpumask_var_t cpu_callout_mask;
>> +extern cpumask_var_t cpu_initialized_mask;
>> +extern cpumask_var_t cpu_sibling_setup_mask;
>> +
>> +#else /* CONFIG_X86_32 */
>> +
>> +extern cpumask_t cpu_callin_map;
> 
> 
> I am not able to understand, why you choose asm/smp.h
> 
> You know that asm/smp.h should only be included for CONFIG_SMP

Hi Jaswinder,

I'll look closer but I had assumed that these masks would not be
used for UP configurations (it did not get any compile errors
with the allnoconfig).  In fact, any access to these masks for
UP would be unnecessary since there are no callouts, the boot
cpu is assumed initialized, and it has no siblings.  So the
masks are specific to SMP.

But as I said, I'll verify this.

Thanks,
Mike
> 
> ----- linux/smp.h -----
> #ifdef CONFIG_SMP
> 
> #include <asm/smp.h>
> 
> #endif /* !SMP */
> 
> -----------------------
> 
> If someday this will happen:
> 
> ﻿----- asm/smp.h -----
> #ifndef _ASM_X86_SMP_H
> #define _ASM_X86_SMP_H
> #ifndef __ASSEMBLY__
> #ifdef CONFIG_SMP
> ...
> #else /* CONFIG_SMP */
> #error "Including wrong file, why you need smp.h for uniprocesor"
> #endif /* CONFIG_SMP */
> #endif /* __ASSEMBLY__ */
> #endif /* _ASM_X86_SMP_H */
> 
> -----------------------
> 
> Then ;-)
> 
> Are you planning to make some new file for this or you think some other file will be suitable for this.
> 
> If you have some future plans, please let me know.
> 
> Thanks
> --
> JSR


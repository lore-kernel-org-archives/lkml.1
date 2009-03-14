Return-Path: <linux-kernel-owner+w=401wt.eu-S1755263AbZCNNUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263AbZCNNUm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 09:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754308AbZCNNUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 09:20:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37276 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753454AbZCNNUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 09:20:21 -0400
Date: Sat, 14 Mar 2009 14:20:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: cpu/intel.c cleanup
Message-ID: <20090314132004.GD17727@elte.hu>
References: <1237034492.4546.1.camel@ht.satnam> <20090314131142.GA29582@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090314131142.GA29582@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sam Ravnborg <sam@ravnborg.org> wrote:

> >  
> >  #include <asm/processor.h>
> > +#include <asm/topology.h>
> >  #include <asm/pgtable.h>
> > -#include <asm/msr.h>
> > -#include <asm/uaccess.h>
> > -#include <asm/ds.h>
> > +#ifdef CONFIG_X86_LOCAL_APIC
> > +#include <asm/mpspec.h>
> > +#include <asm/apic.h>
> > +#endif
> 
> If these header files are only relevant for 
> CONFIG_X86_LOCAL_APIC then we should move the ifdef down into 
> the header file, so users do not forget it.

apic.h can be included unconditionally - and the mpspec.h 
inclusion can be removed because it's included by apic.h.

> > +			pr_info("CPU: C0 stepping P4 Xeon detected.\n");
> > +			pr_info("CPU: Disabling hardware prefetching (Errata 037)\n");
> >  			lo |= MSR_IA32_MISC_ENABLE_PREFETCH_DISABLE;
> > -			wrmsr (MSR_IA32_MISC_ENABLE, lo, hi);
> > +			wrmsr(MSR_IA32_MISC_ENABLE, lo, hi);
> >  		}
> >  	}
> >  
> > @@ -217,7 +241,7 @@ static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
> >  	 * integrated APIC (see 11AP erratum in "Pentium Processor
> >  	 * Specification Update").
> >  	 */
> > -	if (cpu_has_apic && (c->x86<<8 | c->x86_model<<4) == 0x520 &&
> > +	if (cpu_has_apic && (c->x86 << 8 | c->x86_model << 4) == 0x520 &&
> >  	    (c->x86_mask < 0x6 || c->x86_mask == 0xb))
> >  		set_cpu_cap(c, X86_FEATURE_11AP);
> >  
> > @@ -245,28 +269,26 @@ static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
> >  #endif
> >  
> >  	intel_smp_check(c);
> > -}
> > -#else
> > -static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
> > -{
> > -}
> >  #endif
> > +}
> 
> To me it is more obvious with the old style.
> Having ifdef's inside the block is less obvious.
> 
> But I have not checked what is the common pattern.

agreed, this one was probably cleaner with the #ifdef block 
outside.

	Ingo

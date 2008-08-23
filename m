Return-Path: <linux-kernel-owner+w=401wt.eu-S1758473AbYHWT64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758473AbYHWT64 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 15:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755959AbYHWTpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 15:45:20 -0400
Received: from qb-out-0506.google.com ([72.14.204.233]:54390 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853AbYHWTpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 15:45:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=S86hyq0A6XgJbRrdXDifL9V2ylpTucStQLPxSiolt/HRHqqj2Ei3HD7YxgoGOS2aqS
         kuENpKQdb9IxclpzG2DA7oTkbYRS966tJmp4wuyIyB5TmxmssUN/qD/qRWJX0B1+hzIb
         fSQw++wUeCZOtuQVGDyxBqS/ymn+IyKBYslrY=
Date: Sat, 23 Aug 2008 23:45:41 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: mingo@elte.hu, macro@linux-mips.org, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] x86: apic - unify hard_smp_processor_id
Message-ID: <20080823194541.GC22089@lenovo>
References: <a02f3dc9088b9b6c0d22fa77839fdd9d5309ec97.1219491572.git.gorcunov@gmail.com> <ad4298d4a7d4eb0bf4611765df4481ac129b5db6.1219491572.git.gorcunov@gmail.com> <86802c440808231213j9a2ffdem548ca91570c981b1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440808231213j9a2ffdem548ca91570c981b1@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Yinghai Lu - Sat, Aug 23, 2008 at 12:13:21PM -0700]
| On Sat, Aug 23, 2008 at 6:01 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| > Move hard_smp_processor_id to apic_32.c.
| > There is no need to keep it in header - we are linked to
| > apic_xx.c code anyway.
| >
| > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
| > ---
| >  arch/x86/kernel/apic_32.c |    5 +++++
| >  include/asm-x86/smp.h     |   10 ----------
| >  2 files changed, 5 insertions(+), 10 deletions(-)
| >
| > diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
| > index ad295cf..c71a77c 100644
| > --- a/arch/x86/kernel/apic_32.c
| > +++ b/arch/x86/kernel/apic_32.c
| > @@ -1569,6 +1569,11 @@ void __cpuinit generic_processor_info(int apicid, int version)
| >        cpu_set(cpu, cpu_present_map);
| >  }
| >
| > +int hard_smp_processor_id(void)
| > +{
| > +       return read_apic_id();
| > +}
| > +
| >  /*
| >  * Power management
| >  */
| > diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
| > index 29324c1..914a73d 100644
| > --- a/include/asm-x86/smp.h
| > +++ b/include/asm-x86/smp.h
| > @@ -185,17 +185,7 @@ static inline unsigned int read_apic_id(void)
| >  }
| >  #endif
| >
| > -
| > -# if defined(APIC_DEFINITION) || defined(CONFIG_X86_64)
| >  extern int hard_smp_processor_id(void);
| > -# else
| > -#include <mach_apicdef.h>
| > -static inline int hard_smp_processor_id(void)
| > -{
| > -       /* we don't want to mark this access volatile - bad code generation */
| > -       return read_apic_id();
| > -}
| > -# endif /* APIC_DEFINITION */
| >
| >  #else /* CONFIG_X86_LOCAL_APIC */
| >
| > --
| > 1.6.0.6.gc667
| >
| >
| 
| this one seems have some problem with 32bit with genericarch
| 
| because we have
| 
| int hard_smp_processor_id(void)
| {
|         return genapic->get_apic_id(*(unsigned long *)(APIC_BASE+APIC_ID));
| }
| 
| arch/x86/mach-generic/probe.c
| 
| updated 64 bit to have MACRO.
| 
| YH
| 

thanks Yinghai, but isn't it called _after_ x86 apic chip
initialized?

		- Cyrill -

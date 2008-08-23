Return-Path: <linux-kernel-owner+w=401wt.eu-S1754444AbYHWTNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444AbYHWTNb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 15:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbYHWTNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 15:13:22 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:55219 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105AbYHWTNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 15:13:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Fz0qSWCQKE8BD80JWq6GS+orqYS4XxT+BEPUfAFrFJwrnwyp/k4x5OFz2Lw/PrWt97
         Tg5TfRsF8Biz21gkc0mXy2kyde9cVIt9DMneXSGEmZz8wUbO3lXUquiaS4s08JfLTsye
         4ruuboVJKToJkMC/vVxgSwUK3fmWpmCakkK0w=
Message-ID: <86802c440808231213j9a2ffdem548ca91570c981b1@mail.gmail.com>
Date: Sat, 23 Aug 2008 12:13:21 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>
Subject: Re: [PATCH 5/8] x86: apic - unify hard_smp_processor_id
Cc: mingo@elte.hu, macro@linux-mips.org, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <ad4298d4a7d4eb0bf4611765df4481ac129b5db6.1219491572.git.gorcunov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a02f3dc9088b9b6c0d22fa77839fdd9d5309ec97.1219491572.git.gorcunov@gmail.com>
	 <ad4298d4a7d4eb0bf4611765df4481ac129b5db6.1219491572.git.gorcunov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 23, 2008 at 6:01 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> Move hard_smp_processor_id to apic_32.c.
> There is no need to keep it in header - we are linked to
> apic_xx.c code anyway.
>
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> ---
>  arch/x86/kernel/apic_32.c |    5 +++++
>  include/asm-x86/smp.h     |   10 ----------
>  2 files changed, 5 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
> index ad295cf..c71a77c 100644
> --- a/arch/x86/kernel/apic_32.c
> +++ b/arch/x86/kernel/apic_32.c
> @@ -1569,6 +1569,11 @@ void __cpuinit generic_processor_info(int apicid, int version)
>        cpu_set(cpu, cpu_present_map);
>  }
>
> +int hard_smp_processor_id(void)
> +{
> +       return read_apic_id();
> +}
> +
>  /*
>  * Power management
>  */
> diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
> index 29324c1..914a73d 100644
> --- a/include/asm-x86/smp.h
> +++ b/include/asm-x86/smp.h
> @@ -185,17 +185,7 @@ static inline unsigned int read_apic_id(void)
>  }
>  #endif
>
> -
> -# if defined(APIC_DEFINITION) || defined(CONFIG_X86_64)
>  extern int hard_smp_processor_id(void);
> -# else
> -#include <mach_apicdef.h>
> -static inline int hard_smp_processor_id(void)
> -{
> -       /* we don't want to mark this access volatile - bad code generation */
> -       return read_apic_id();
> -}
> -# endif /* APIC_DEFINITION */
>
>  #else /* CONFIG_X86_LOCAL_APIC */
>
> --
> 1.6.0.6.gc667
>
>

this one seems have some problem with 32bit with genericarch

because we have

int hard_smp_processor_id(void)
{
        return genapic->get_apic_id(*(unsigned long *)(APIC_BASE+APIC_ID));
}

arch/x86/mach-generic/probe.c

updated 64 bit to have MACRO.

YH

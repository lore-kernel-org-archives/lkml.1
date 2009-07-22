Return-Path: <linux-kernel-owner+w=401wt.eu-S1756499AbZGVDhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499AbZGVDhi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 23:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755933AbZGVDhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 23:37:38 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:43923 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755875AbZGVDhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 23:37:37 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4A668964.5040800@jp.fujitsu.com>
Date: Wed, 22 Jul 2009 12:37:08 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, ak@linux.intel.com,
       linux-kernel@vger.kernel.org,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>,
       Taketoshi Sakuraba <taketoshi.sakuraba.hc@hitachi.com>
Subject: Re: [PATCH] x86, mce: Rename incorrect macro name "CONFIG_X86_THRESHOLD"
References: <4A667FD4.3010509@hitachi.com>
In-Reply-To: <4A667FD4.3010509@hitachi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hidehiro Kawai wrote:
> CONFIG_X86_THRESHOLD used in arch/x86/kernel/irqinit.c is always
> undefined.  Rename it to the correct name "CONFIG_X86_MCE_THRESHOLD".
> 
> Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
> ---
>  arch/x86/kernel/irqinit.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
> index 8a194ad..ccf8ab5 100644
> --- a/arch/x86/kernel/irqinit.c
> +++ b/arch/x86/kernel/irqinit.c
> @@ -187,7 +187,7 @@ static void __init apic_intr_init(void)
>  #ifdef CONFIG_X86_THERMAL_VECTOR
>  	alloc_intr_gate(THERMAL_APIC_VECTOR, thermal_interrupt);
>  #endif
> -#ifdef CONFIG_X86_THRESHOLD
> +#ifdef CONFIG_X86_MCE_THRESHOLD
>  	alloc_intr_gate(THRESHOLD_APIC_VECTOR, threshold_interrupt);
>  #endif
>  #if defined(CONFIG_X86_MCE) && defined(CONFIG_X86_LOCAL_APIC)


It seems that this ifdef was introduced by the following merge commit:

> commit 940010c5a314a7bd9b498593bc6ba1718ac5aec5
> Merge: 8dc8e5e... 991ec02...
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Thu Jun 11 17:55:42 2009 +0200
> 
>     Merge branch 'linus' into perfcounters/core
> 
>     Conflicts:
>         arch/x86/kernel/irqinit.c
>         arch/x86/kernel/irqinit_64.c
>         arch/x86/kernel/traps.c
>         arch/x86/mm/fault.c
>         include/linux/sched.h
>         kernel/exit.c

Thank you for finding it!

Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>


Thanks,
H.Seto


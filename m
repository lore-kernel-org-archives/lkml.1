Return-Path: <linux-kernel-owner+w=401wt.eu-S1753193AbZKLF2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbZKLF2k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 00:28:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752671AbZKLF2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 00:28:39 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42274 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489AbZKLF2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 00:28:38 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AFB9CFE.6010207@jp.fujitsu.com>
Date: Thu, 12 Nov 2009 14:28:30 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Yong Wang <yong.y.wang@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Mark the thermal init functions __init
References: <20091111075125.GA17900@ywang-moblin2.bj.intel.com>
In-Reply-To: <20091111075125.GA17900@ywang-moblin2.bj.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yong Wang wrote:
> Mark the thermal init functions __init so that the init memory can be freed.
> 
> Signed-off-by: Yong Wang <yong.y.wang@intel.com>
> ---
>  arch/x86/kernel/cpu/mcheck/therm_throt.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
> index 7f3cf36..8a73d5c 100644
> --- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
> +++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
> @@ -256,7 +256,7 @@ asmlinkage void smp_thermal_interrupt(struct pt_regs *regs)
>  	ack_APIC_irq();
>  }
>  
> -void mcheck_intel_therm_init(void)
> +void __init mcheck_intel_therm_init(void)
>  {
>  	/*
>  	 * This function is only called on boot CPU. Save the init thermal

It's OK because it is called only on BP.

> @@ -268,7 +268,7 @@ void mcheck_intel_therm_init(void)
>  		lvtthmr_init = apic_read(APIC_LVTTHMR);
>  }
>  
> -void intel_init_thermal(struct cpuinfo_x86 *c)
> +void __init intel_init_thermal(struct cpuinfo_x86 *c)
>  {
>  	unsigned int cpu = smp_processor_id();
>  	int tm2 = 0;

But I think this could be called on hot-plugged AP.
Should be __cpuinit ?

void __cpuinit mcheck_cpu_init(struct cpuinfo_x86 *c)
 ->  static void __mcheck_cpu_init_vendor(struct cpuinfo_x86 *c)
  ->  void mce_intel_feature_init(struct cpuinfo_x86 *c)
   ->  void intel_init_thermal(struct cpuinfo_x86 *c)

Thanks,
H.Seto



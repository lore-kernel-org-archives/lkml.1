Return-Path: <linux-kernel-owner+w=401wt.eu-S1751959AbYKFS5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959AbYKFS5m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 13:57:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751041AbYKFS5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 13:57:25 -0500
Received: from gw.goop.org ([64.81.55.164]:57205 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbYKFS5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 13:57:25 -0500
Message-ID: <49133E11.8050607@goop.org>
Date: Thu, 06 Nov 2008 10:57:21 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Tony Luck <tony.luck@intel.com>, Isaku Yamahata <yamahata@valinux.co.jp>,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] Fix section type conflict in arch/ia64/xen/xen_pv_ops.c
References: <s5h1vxou7gf.wl%tiwai@suse.de>
In-Reply-To: <s5h1vxou7gf.wl%tiwai@suse.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> __initdata and const cannot be always a happy pair, as gcc-4.3.3 gives
> the compile errors like:
>
>   arch/ia64/xen/xen_pv_ops.c:156: error: xen_init_ops causes a section type conflict
>   arch/ia64/xen/xen_pv_ops.c:340: error: xen_iosapic_ops causes a section type conflict
>
> This patch simply removes const from data with __initdata.
>   

Yeah, I've seen these sort of messages before, but I don't see why 
there's an inherent problem with having const __initdata.

Sam?

    J

> Signed-off-by: Takashi Iwai <tiwai@suse.de>
>
> ---
> diff --git a/arch/ia64/xen/xen_pv_ops.c b/arch/ia64/xen/xen_pv_ops.c
> index 04cd123..5d491d9 100644
> --- a/arch/ia64/xen/xen_pv_ops.c
> +++ b/arch/ia64/xen/xen_pv_ops.c
> @@ -153,7 +153,7 @@ xen_post_smp_prepare_boot_cpu(void)
>  	xen_setup_vcpu_info_placement();
>  }
>  
> -static const struct pv_init_ops xen_init_ops __initdata = {
> +static struct pv_init_ops xen_init_ops __initdata = {
>  	.banner = xen_banner,
>  
>  	.reserve_memory = xen_reserve_memory,
> @@ -260,7 +260,7 @@ xen_intrin_local_irq_restore(unsigned long mask)
>  		xen_rsm_i();
>  }
>  
> -static const struct pv_cpu_ops xen_cpu_ops __initdata = {
> +static struct pv_cpu_ops xen_cpu_ops __initdata = {
>  	.fc		= xen_fc,
>  	.thash		= xen_thash,
>  	.get_cpuid	= xen_get_cpuid,
> @@ -337,7 +337,7 @@ xen_iosapic_write(char __iomem *iosapic, unsigned int reg, u32 val)
>  	HYPERVISOR_physdev_op(PHYSDEVOP_apic_write, &apic_op);
>  }
>  
> -static const struct pv_iosapic_ops xen_iosapic_ops __initdata = {
> +static struct pv_iosapic_ops xen_iosapic_ops __initdata = {
>  	.pcat_compat_init = xen_pcat_compat_init,
>  	.__get_irq_chip = xen_iosapic_get_irq_chip,
>  
>   


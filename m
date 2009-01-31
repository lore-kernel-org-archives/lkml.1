Return-Path: <linux-kernel-owner+w=401wt.eu-S1753300AbZAaM6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbZAaM6R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 07:58:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbZAaM6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 07:58:03 -0500
Received: from ozlabs.org ([203.10.76.45]:33669 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbZAaM6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 07:58:01 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH] voyager: fix cpu bootmaps
Date: Sat, 31 Jan 2009 23:27:50 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
References: <1233340317.3248.39.camel@localhost.localdomain>
In-Reply-To: <1233340317.3248.39.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901312327.50684.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 31 January 2009 05:01:57 James Bottomley wrote:
> commit 98a79d6a50181ca1ecf7400eda01d5dc1bc0dbf0
> Author: Rusty Russell <rusty@rustcorp.com.au>
> Date:   Sat Dec 13 21:19:41 2008 +1030
> 
>     cpumask: centralize cpu_online_map and cpu_possible_map
> 
> Broke voyager largely because it currently initialises the
> possible_map by copying, which isn't possible in the new scheme.  Fix
> this by using init_cpu_possible() instead and tidy up other of the
> cpumask declarations which now have global variables.
> 
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> ---
>  arch/x86/mach-voyager/voyager_smp.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
> index 9840b7e..dcc07d5 100644
> --- a/arch/x86/mach-voyager/voyager_smp.c
> +++ b/arch/x86/mach-voyager/voyager_smp.c
> @@ -378,7 +378,7 @@ void __init find_smp_config(void)
>  	cpus_addr(phys_cpu_present_map)[0] |=
>  	    voyager_extended_cmos_read(VOYAGER_PROCESSOR_PRESENT_MASK +
>  				       3) << 24;
> -	cpu_possible_map = phys_cpu_present_map;
> +	init_cpu_possible(&phys_cpu_present_map);
>  	printk("VOYAGER SMP: phys_cpu_present_map = 0x%lx\n",
>  	       cpus_addr(phys_cpu_present_map)[0]);
>  	/* Here we set up the VIC to enable SMP */

Strange, the assignment should still work, even though this new method is
preferred.

How do your patches normally get upstream?  I'd normally just fwd this to
Ingo...

Sorry I broke your platform...
Rusty.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754702AbZLRQDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbZLRQDb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 11:03:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751563AbZLRQDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 11:03:30 -0500
Received: from www.tglx.de ([62.245.132.106]:57231 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbZLRQD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 11:03:29 -0500
Date: Fri, 18 Dec 2009 17:02:35 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
cc: "H. Peter Anvin" <hpa@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86: initialize stack canary in secondary start
In-Reply-To: <43F901BD926A4E43B106BF17856F07559A257B5F@orsmsx508.amr.corp.intel.com>
Message-ID: <alpine.LFD.2.00.0912181701470.2755@localhost.localdomain>
References: <43F901BD926A4E43B106BF17856F07559A257B5F@orsmsx508.amr.corp.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Dec 2009, Pan, Jacob jun wrote:
> >From 06503838368350268a46528e134c1dad9f4f8c93 Mon Sep 17 00:00:00 2001
> From: Jacob Pan <jacob.jun.pan@intel.com>
> Date: Thu, 17 Sep 2009 07:36:43 -0700
> Subject: [PATCH 1/2] x86: initialize stack canary in secondary start
> 
> some secondary clockevent setup code needs to call request_irq, which will
> cause fake stack check failure in schedule() if voluntary preemption
> model is chosen, it is safe to have stack canary initialized here early,
> since start_secondary() does not return.

Where is it initialized now ? Shouldnt the current init be removed ?

Thanks,

	tglx

> Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
> ---
>  arch/x86/kernel/smpboot.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index 678d0b8..56ce974 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -48,6 +48,7 @@
>  #include <linux/err.h>
>  #include <linux/nmi.h>
>  #include <linux/tboot.h>
> +#include <linux/stackprotector.h>
>  
>  #include <asm/acpi.h>
>  #include <asm/desc.h>
> @@ -324,6 +325,9 @@ notrace static void __cpuinit start_secondary(void *unused)
>  	/* enable local interrupts */
>  	local_irq_enable();
>  
> +	/* to prevent fake stack check failure in clock setup */
> +	boot_init_stack_canary();
> +
>  	x86_cpuinit.setup_percpu_clockev();
>  
>  	wmb();
> -- 
> 1.6.5.3
> 
> 

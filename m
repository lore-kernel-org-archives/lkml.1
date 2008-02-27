Return-Path: <linux-kernel-owner+w=401wt.eu-S1760757AbYB0V2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760757AbYB0V2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 16:28:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756249AbYB0V2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 16:28:10 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:49434 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754828AbYB0V2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 16:28:09 -0500
Date: Wed, 27 Feb 2008 23:26:58 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: X86_HT always enable on X86_64 SMP
Message-ID: <20080227212658.GU29269@cs181133002.pp.htv.fi>
References: <47C5D32E.8070308@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <47C5D32E.8070308@ct.jp.nec.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2008 at 01:16:30PM -0800, Hiroshi Shimamoto wrote:
> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> X86_HT is used for hyperthreading or multicore on 32-bit.
> The X86_HT on 64-bit is different from 32-bit, it means hyperthreading only.
> And X86_HT is not used on 64-bit except from cpu/initel_cacheinfo.c.
> 
> Unify X86_HT for hyperthreading or multicore.
> Turn X86_HT on when X86_64 and SMP are enabled.

Please fix it properly instead - fiddling around with it the way you do
only asks for trouble in the future.

What we need are two different variables for:
- hyperthreading and
- multicore

> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> ---
>  arch/x86/Kconfig |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 5bbb385..7168437 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -174,7 +174,7 @@ config X86_64_SMP
>  config X86_HT
>  	bool
>  	depends on SMP
> -	depends on (X86_32 && !(X86_VISWS || X86_VOYAGER)) || (X86_64 && !MK8)
> +	depends on (X86_32 && !(X86_VISWS || X86_VOYAGER)) || X86_64
>  	default y
>  
>  config X86_BIOS_REBOOT
> @@ -516,7 +516,7 @@ config NR_CPUS
>  
>  config SCHED_SMT
>  	bool "SMT (Hyperthreading) scheduler support"
> -	depends on (X86_64 && SMP) || (X86_32 && X86_HT)
> +	depends on X86_HT
>  	help
>  	  SMT scheduler support improves the CPU scheduler's decision making
>  	  when dealing with Intel Pentium 4 chips with HyperThreading at a
> @@ -526,7 +526,7 @@ config SCHED_SMT
>  config SCHED_MC
>  	def_bool y
>  	prompt "Multi-core scheduler support"
> -	depends on (X86_64 && SMP) || (X86_32 && X86_HT)
> +	depends on X86_HT
>  	help
>  	  Multi-core scheduler support improves the CPU scheduler's decision
>  	  making when dealing with multi-core CPU chips at a cost of slightly

And any proper fix should result in SCHED_SMT and SCHED_MC getting 
different dependencies.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


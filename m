Return-Path: <linux-kernel-owner+w=401wt.eu-S1756836AbYJPL4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836AbYJPL4R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 07:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754466AbYJPL4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 07:56:04 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:45312 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191AbYJPL4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 07:56:02 -0400
X-BigFish: VPS-14(zz1432R98dR1805M936fO3117Kzzzz3198u327an5a6ciz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K8TYGZ-01-1U8-01
Date: Thu, 16 Oct 2008 13:55:22 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/early-quirks: fix warning defined but not used
Message-ID: <20081016115522.GD29183@alberich.amd.com>
References: <20081015173406.GB30703@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20081015173406.GB30703@orion>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 16 Oct 2008 11:55:48.0060 (UTC) FILETIME=[20E261C0:01C92F86]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2008 at 09:34:06PM +0400, Alexander Beregalov wrote:
> arch/x86/kernel/early-quirks.c:99: warning: 'ati_ixp4x0_rev' defined but not used
> Compile tested.
> 
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>

There was already another patch that addresses this.
And both are not needed when Ingo applies the following patch
http://marc.info/?l=linux-kernel&m=122406442128207

Regards,

Andreas

> ---
> 
>  arch/x86/kernel/early-quirks.c |   21 ++++++++-------------
>  1 files changed, 8 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
> index 733c4f8..eadfa3d 100644
> --- a/arch/x86/kernel/early-quirks.c
> +++ b/arch/x86/kernel/early-quirks.c
> @@ -57,20 +57,14 @@ static void __init via_bugs(int  num, int slot, int func)
>  #endif
>  }
>  
> -#ifdef CONFIG_ACPI
> -#ifdef CONFIG_X86_IO_APIC
> -
> +#if defined(CONFIG_ACPI) && defined (CONFIG_X86_IO_APIC)
>  static int __init nvidia_hpet_check(struct acpi_table_header *header)
>  {
>  	return 0;
>  }
> -#endif /* CONFIG_X86_IO_APIC */
> -#endif /* CONFIG_ACPI */
>  
>  static void __init nvidia_bugs(int num, int slot, int func)
>  {
> -#ifdef CONFIG_ACPI
> -#ifdef CONFIG_X86_IO_APIC
>  	/*
>  	 * All timer overrides on Nvidia are
>  	 * wrong unless HPET is enabled.
> @@ -89,10 +83,6 @@ static void __init nvidia_bugs(int num, int slot, int func)
>  		printk(KERN_INFO "If you got timer trouble "
>  			"try acpi_use_timer_override\n");
>  	}
> -#endif
> -#endif
> -	/* RED-PEN skip them on mptables too? */
> -
>  }
>  
>  static u32 ati_ixp4x0_rev(int num, int slot, int func)
> @@ -115,7 +105,6 @@ static u32 ati_ixp4x0_rev(int num, int slot, int func)
>  
>  static void __init ati_bugs(int num, int slot, int func)
>  {
> -#if defined(CONFIG_ACPI) && defined (CONFIG_X86_IO_APIC)
>  	u32 d;
>  	u8  b;
>  
> @@ -138,8 +127,14 @@ static void __init ati_bugs(int num, int slot, int func)
>  		printk(KERN_INFO "If you got timer trouble "
>  		       "try acpi_use_timer_override\n");
>  	}
> -#endif
>  }
> +#else
> +static void __init nvidia_bugs(int num, int slot, int func)
> +{
> +/* RED-PEN skip them on mptables too? */
> +}
> +static void __init ati_bugs(int num, int slot, int func) {}
> +#endif /* !(CONFIG_ACPI && CONFIG_X86_IO_APIC)*/
>  
>  #ifdef CONFIG_DMAR
>  static void __init intel_g33_dmar(int num, int slot, int func)
> 

-- 
Operating | AMD Saxony Limited Liability Company & Co. KG,
  System  | Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 Research | Register Court Dresden: HRA 4896, General Partner authorized
  Center  | to represent: AMD Saxony LLC (Wilmington, Delaware, US)
  (OSRC)  | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy



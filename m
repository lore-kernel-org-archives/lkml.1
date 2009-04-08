Return-Path: <linux-kernel-owner+w=401wt.eu-S1760806AbZDHQWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760806AbZDHQWn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 12:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753784AbZDHQWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 12:22:34 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:28589 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729AbZDHQWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 12:22:33 -0400
Date: Wed, 8 Apr 2009 10:23:12 -0600
From: dann frazier <dannf@hp.com>
To: Brian Maly <bmaly@redhat.com>
Cc: "H. Peter Anvin" <h.peter.anvin@intel.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, ying.huang@intel.com
Subject: Re: [PATCH] rtc: add x86 support for rtc-efi
Message-ID: <20090408162311.GC17985@ldl.fc.hp.com>
References: <49DA40B9.2060804@redhat.com> <49DA817E.8040705@intel.com> <49DA8875.5050009@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49DA8875.5050009@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: dann frazier <dannf@hp.com>

On Mon, Apr 06, 2009 at 06:55:49PM -0400, Brian Maly wrote:
> re-post of the patch, both as inline and as an attachment (which  
> hopefully wont cause confusion).
>
>
> --- a/drivers/rtc/Kconfig    2009-03-26 12:39:59.000000000 -0400
> +++ b/drivers/rtc/Kconfig    2009-04-06 18:46:58.000000000 -0400
> @@ -442,7 +442,7 @@ config RTC_DRV_DS1742
>
> config RTC_DRV_EFI
>     tristate "EFI RTC"
> -    depends on IA64
> +   depends on EFI
>     help
>       If you say yes here you will get support for the EFI
>       Real Time Clock.
> --- a/arch/x86/kernel/time_32.c    2009-03-12 22:39:28.000000000 -0400
> +++ b/arch/x86/kernel/time_32.c    2009-03-26 13:06:10.000000000 -0400
> @@ -32,6 +32,7 @@
> #include <linux/interrupt.h>
> #include <linux/time.h>
> #include <linux/mca.h>
> +#include <linux/platform_device.h>
>
> #include <asm/arch_hooks.h>
> #include <asm/hpet.h>
> @@ -135,3 +136,21 @@ void __init time_init(void)
>     tsc_init();
>     late_time_init = choose_time_init();
> }
> +
> +
> +#ifdef CONFIG_RTC_DRV_EFI
> +static struct platform_device rtc_efi_dev = {
> +    .name = "rtc-efi",
> +    .id = -1,
> +};
> +
> +static int __init rtc_init(void)
> +{
> +    if (platform_device_register(&rtc_efi_dev) < 0)
> +        printk(KERN_ERR "unable to register rtc device...\n");
> +
> +    /* not necessarily an error */
> +    return 0;
> +}
> +module_init(rtc_init);
> +#endif
> --- a/arch/x86/kernel/time_64.c    2009-03-12 22:39:28.000000000 -0400
> +++ b/arch/x86/kernel/time_64.c    2009-03-26 13:06:19.000000000 -0400
> @@ -18,6 +18,7 @@
> #include <linux/time.h>
> #include <linux/mca.h>
> #include <linux/nmi.h>
> +#include <linux/platform_device.h>
>
> #include <asm/i8253.h>
> #include <asm/hpet.h>
> @@ -135,3 +136,20 @@ void __init time_init(void)
>
>     late_time_init = choose_time_init();
> }
> +
> +#ifdef CONFIG_RTC_DRV_EFI
> +static struct platform_device rtc_efi_dev = {
> +    .name = "rtc-efi",
> +    .id = -1,
> +};
> +
> +static int __init rtc_init(void)
> +{
> +    if (platform_device_register(&rtc_efi_dev) < 0)
> +        printk(KERN_ERR "unable to register rtc device...\n");
> +
> +    /* not necessarily an error */
> +    return 0;
> +}
> +module_init(rtc_init);
> +#endif
>
> --------------------------------------------------------------------------------------------
>



-- 
dann frazier


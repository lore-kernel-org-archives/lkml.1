Return-Path: <linux-kernel-owner+w=401wt.eu-S1759096AbYD2IbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759096AbYD2IbW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 04:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751592AbYD2IbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 04:31:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:38936 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbYD2IbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 04:31:04 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] ACER_WMI/ASUS_LAPTOP: fix build bug
Date: Tue, 29 Apr 2008 04:30:24 -0400
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Carlos Corbacho <carlos@strangeworlds.co.uk>
References: <20080429082119.GA14597@elte.hu>
In-Reply-To: <20080429082119.GA14597@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804290430.25118.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

applied

thanks,
-len

On Tuesday 29 April 2008, Ingo Molnar wrote:
> 
> randconfig testing in x86.git found the following upstream build bug:
> 
>  drivers/built-in.o: In function `acer_led_exit':
>  acer-wmi.c:(.text+0xdc76e): undefined reference to `led_classdev_unregister'
>  drivers/built-in.o: In function `acer_platform_probe':
>  acer-wmi.c:(.devinit.text+0x63e6): undefined reference to `led_classdev_register'
> 
> which was due to acer-wmi.o only depending on CONFIG_LEDS_CLASS, while 
> also using a symbol offered by CONFIG_NEW_LEDS. Also fix a similar bug 
> in CONFIG_ASUS_LAPTOP.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  drivers/misc/Kconfig |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: linux/drivers/misc/Kconfig
> ===================================================================
> --- linux.orig/drivers/misc/Kconfig
> +++ linux/drivers/misc/Kconfig
> @@ -140,6 +140,7 @@ config ACER_WMI
>  	depends on EXPERIMENTAL
>  	depends on ACPI
>  	depends on LEDS_CLASS
> +	depends on NEW_LEDS
>  	depends on BACKLIGHT_CLASS_DEVICE
>  	depends on SERIO_I8042
>  	select ACPI_WMI
> @@ -160,6 +161,7 @@ config ASUS_LAPTOP
>          depends on ACPI
>  	depends on EXPERIMENTAL && !ACPI_ASUS
>  	depends on LEDS_CLASS
> +	depends on NEW_LEDS
>  	depends on BACKLIGHT_CLASS_DEVICE
>          ---help---
>  	  This is the new Linux driver for Asus laptops. It may also support some
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 



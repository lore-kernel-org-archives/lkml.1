Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbZJUPwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbZJUPwN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 11:52:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754034AbZJUPwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 11:52:12 -0400
Received: from 17.mail-out.ovh.net ([91.121.30.212]:50138 "HELO
	17.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753999AbZJUPwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 11:52:11 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Oct 2009 11:52:11 EDT
Date: Wed, 21 Oct 2009 17:26:53 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, avictor.za@gmail.com,
       akpm@linux-foundation.org, linux-mmc@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] at91: at91sam9g20ek modify dual slot evaluation kit
Message-ID: <20091021152653.GF19714@game.jcrosoft.org>
References: <1256049173-17373-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256049173-17373-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 3317464076251540332
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
X-Ovh-Tracer-Id: 3216696035067931415
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	  that embeds only one SD/MMC slot.
> +
> +config MACH_AT91SAM9G20EK_2MMC
> +	bool "Atmel AT91SAM9G20-EK Evaluation Kit with 2 SD/MMC Slots"
> +	depends on ARCH_AT91SAM9G20
> +	help
> +	  Select this if you are using an Atmel AT91SAM9G20-EK Evaluation Kit
> +	  with 2 SD/MMC Slots. This is the case for AT91SAM9G20-EK rev. C and
> +	  onwards.
>  
>  config MACH_CPU9G20
>  	bool "Eukrea CPU9G20 board"
> @@ -392,7 +394,7 @@ config MTD_AT91_DATAFLASH_CARD
>  
>  config MTD_NAND_ATMEL_BUSWIDTH_16
>  	bool "Enable 16-bit data bus interface to NAND flash"
> -	depends on (MACH_AT91SAM9260EK || MACH_AT91SAM9261EK || MACH_AT91SAM9G10EK || MACH_AT91SAM9263EK || MACH_AT91SAM9G20EK || MACH_AT91SAM9G45EKES || MACH_AT91CAP9ADK)
> +	depends on (MACH_AT91SAM9260EK || MACH_AT91SAM9261EK || MACH_AT91SAM9G10EK || MACH_AT91SAM9263EK || MACH_AT91SAM9G20EK || MACH_AT91SAM9G20EK_2MMC || MACH_AT91SAM9G45EKES || MACH_AT91CAP9ADK)
it's time to replace this by select it at machine config state

> @@ -254,7 +257,11 @@ static void __init ek_board_init(void)
>  	/* Ethernet */
>  	at91_add_device_eth(&ek_macb_data);
>  	/* MMC */
> +#if defined(CONFIG_MMC_ATMELMCI) || defined(CONFIG_MMC_ATMELMCI_MODULE)
>  	at91_add_device_mci(0, &ek_mmc_data);
> +#else
> +	at91_add_device_mmc(0, &ek_mmc_data);
> +#endif
do we really need to do this choice at board level?

Best Regards,
J.

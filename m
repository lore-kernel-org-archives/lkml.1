Return-Path: <linux-kernel-owner+w=401wt.eu-S1754178AbZKCUFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbZKCUFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 15:05:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946AbZKCUFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 15:05:16 -0500
Received: from d1.icnet.pl ([212.160.220.21]:53296 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523AbZKCUFP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 15:05:15 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [RFC] [PATCH v2] OMAP: DMA: Fix omapfb/lcdc on Amstrad Delta broken when PM set
Date: Tue, 3 Nov 2009 21:04:07 +0100
User-Agent: KMail/1.9.10
Cc: linux-omap@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <200911032024.47741.jkrzyszt@tis.icnet.pl>
In-Reply-To: <200911032024.47741.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200911032104.33049.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tuesday 03 November 2009 20:24:38 Janusz Krzysztofik napisał(a):
> If there are still no comments, especially on the bug possible impact on
> other OMAP1510 boards (or even OMAP1610 with internal LCD controller), then
> Tony, please apply it as is. Until it is accepted, I am stuck with new
> ams_delta_defconfig.

Tony,
Sorry, I've not checked for new mail before posting this one and missed your 
acceptance for my idea of fixing all omap1510, not only ams_delta. If there 
are no more comments, I'll submit v3 with cpu_is_omap1510() replacing 
machine_is_ams_delta().

Thanks,
Janusz

> --- linux-2.6.32-rc5/arch/arm/plat-omap/dma.c.orig	2009-10-16
> 02:41:50.000000000 +0200 +++
> linux-2.6.32-rc5/arch/arm/plat-omap/dma.c	2009-11-03 20:15:35.000000000
> +0100 @@ -30,6 +30,7 @@
>  #include <linux/irq.h>
>  #include <linux/io.h>
>
> +#include <asm/mach-types.h>
>  #include <asm/system.h>
>  #include <mach/hardware.h>
>  #include <mach/dma.h>
> @@ -1110,6 +1111,14 @@ int omap_dma_running(void)
>  {
>  	int lch;
>
> +	/*
> +	 * On Amstrad Delta, the OMAP internal LCD controller will start the
> +	 * transfer when it gets enabled, so assume DMA running if LCD enabled.
> +	 */
> +	if (machine_is_ams_delta())
> +		if (omap_readw(0xfffec000 + 0x00) & (1 << 0))
> +			return 1;
> +
>  	/* Check if LCD DMA is running */
>  	if (cpu_is_omap16xx())
>  		if (omap_readw(OMAP1610_DMA_LCD_CCR) & OMAP_DMA_CCR_EN)



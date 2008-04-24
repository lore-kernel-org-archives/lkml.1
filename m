Return-Path: <linux-kernel-owner+w=401wt.eu-S1757669AbYDXL3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757669AbYDXL3X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 07:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbYDXL3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 07:29:15 -0400
Received: from 87-194-8-8.bethere.co.uk ([87.194.8.8]:63960 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751898AbYDXL3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 07:29:14 -0400
Date: Thu, 24 Apr 2008 12:28:58 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Michael Abbott <michael@araneidae.co.uk>
Cc: Daniel Mack <daniel@caiaq.org>, linux-arm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Colibri: Fix support for DM9000 ethernet device.
Message-ID: <20080424112858.GD16284@fluff.org.uk>
References: <20080424095917.Q51356@saturn.araneidae.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080424095917.Q51356@saturn.araneidae.co.uk>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2008 at 10:13:09AM +0000, Michael Abbott wrote:
> From: Michael Abbott <michael.abbott@diamond.ac.uk>
>
> Colibri: Fix support for DM9000 ethernet device.
>
> Two changes are necessary to enable proper operation of the DM9000 device
> with the Colibri PXA 270 board: firstly, the IRQ type needs to be
> configured for rising edge interrupts, and secondly this configuration needs
> to be communicated through to the DM9000.
>
> Signed-off-by: Michael Abbott <michael.abbott@diamond.ac.uk>
> ---
>  arch/arm/mach-pxa/colibri.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> Patch applied against v2.6.25
>
> Proper operation of this device also depends on the DM9000 timer patch  
> submitted separately.
>
> diff --git a/arch/arm/mach-pxa/colibri.c b/arch/arm/mach-pxa/colibri.c
> index 6db54e3..a76f95a 100644
> --- a/arch/arm/mach-pxa/colibri.c
> +++ b/arch/arm/mach-pxa/colibri.c
> @@ -97,7 +97,7 @@ static struct resource dm9000_resources[] = {
>  	[2] = {
>  		.start	= COLIBRI_ETH_IRQ,
>  		.end	= COLIBRI_ETH_IRQ,
> -		.flags	= IORESOURCE_IRQ,
> +		.flags	= IORESOURCE_IRQ | IRQF_TRIGGER_RISING,
>  	},
>  };
>
> @@ -118,7 +118,7 @@ static void __init colibri_init(void)
>  	/* DM9000 LAN */
>  	pxa_gpio_mode(GPIO78_nCS_2_MD);
>  	pxa_gpio_mode(GPIO_DM9000 | GPIO_IN);
> -	set_irq_type(COLIBRI_ETH_IRQ, IRQT_FALLING);
> +	set_irq_type(COLIBRI_ETH_IRQ, IRQT_RISING);

The set_irq_type() call here should be removed.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'

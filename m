Return-Path: <linux-kernel-owner+w=401wt.eu-S1763363AbYJJUz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763363AbYJJUz2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 16:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759671AbYJJUzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 16:55:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51972 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759469AbYJJUzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 16:55:13 -0400
Date: Fri, 10 Oct 2008 13:42:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Gadiyar, Anand" <gadiyar@ti.com>
Cc: johnpol@2ka.mipt.ru, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, madhu.cr@ti.com
Subject: Re: [PATCH 3/5] HDQ: OMAP: Add HDQ Device
Message-Id: <20081010134222.8f29748d.akpm@linux-foundation.org>
In-Reply-To: <5A47E75E594F054BAF48C5E4FC4B92AB02D6107AF4@dbde02.ent.ti.com>
References: <5A47E75E594F054BAF48C5E4FC4B92AB02D6107AF4@dbde02.ent.ti.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Oct 2008 12:53:57 +0530
"Gadiyar, Anand" <gadiyar@ti.com> wrote:

> From: Madhusudhan Chikkature <madhu.cr@ti.com>
> 
> Device registeration for the TI OMAP2430/3430 HDQ driver.
> 
> Signed-off-by: Madhusudhan Chikkature <madhu.cr@ti.com>
> Acked-by: Felipe Balbi <felipe.balbi@nokia.com>
> Acked-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
> ---
>  arch/arm/mach-omap2/devices.c          |   33 +++++++++++++++++++++++++++++++++
>  arch/arm/plat-omap/include/mach/irqs.h |    1 +
>  2 files changed, 34 insertions(+)
> 
> Index: linux-2.6/arch/arm/mach-omap2/devices.c
> ===================================================================
> --- linux-2.6.orig/arch/arm/mach-omap2/devices.c	2008-09-19 13:39:38.000000000 +0530
> +++ linux-2.6/arch/arm/mach-omap2/devices.c	2008-09-30 10:07:51.000000000 +0530
> @@ -201,6 +201,38 @@ static void omap_init_mcspi(void)
>  static inline void omap_init_mcspi(void) {}
>  #endif
>  
> +#if defined(CONFIG_HDQ_MASTER_OMAP) || defined(CONFIG_HDQ_MASTER_OMAP_MODULE)
> +#if defined(CONFIG_ARCH_OMAP2430) || defined(CONFIG_ARCH_OMAP3430)

gad.

> +#define OMAP_HDQ_BASE		0x480B2000
> +#endif
> +static struct resource omap_hdq_resources[] = {
> +	{
> +		.start		= OMAP_HDQ_BASE,
> +		.end		= OMAP_HDQ_BASE + 0x1C,
> +		.flags		= IORESOURCE_MEM,
> +	},
> +	{
> +		.start		= INT_24XX_HDQ_IRQ,
> +		.flags		= IORESOURCE_IRQ,
> +	},
> +};
> +static struct platform_device omap_hdq_dev = {
> +	.name		= "omap_hdq",
> +	.id = 0,
> +	.dev = {
> +		.platform_data = NULL,
> +	},
> +	.num_resources		= ARRAY_SIZE(omap_hdq_resources),
> +	.resource		= omap_hdq_resources,
> +};
> +static inline void omap_hdq_init(void)
> +{
> +	(void) platform_device_register(&omap_hdq_dev);
> +}

The (void) thing is frowned upon.

Failing to check the return value from registration functions is also
frowned upon!



Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730AbZGWWL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbZGWWL4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 18:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754577AbZGWWLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 18:11:55 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:65068 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487AbZGWWLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 18:11:54 -0400
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Muralidharan Karicheri <m-karicheri2@ti.com>,
       Chaithrika U S <chaithrika@ti.com>, Naresh Medisetty <naresh@ti.com>
Subject: Re: linux-next: manual merge of the v4l-dvb tree with the davinci tree
References: <20090723101113.ed6fc12c.sfr@canb.auug.org.au>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Thu, 23 Jul 2009 15:11:51 -0700
In-Reply-To: <20090723101113.ed6fc12c.sfr@canb.auug.org.au> (Stephen Rothwell's message of "Thu\, 23 Jul 2009 10\:11\:13 +1000")
Message-ID: <877hxzhwwo.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi Mauro,
>
> Today's linux-next merge of the v4l-dvb tree got a conflict in
> arch/arm/mach-davinci/dm355.c between commit
> e94c101ce3ef11bc00f8ea5db4b65c4b01874cf8 ("davinci: ASoC: Add the
> platform devices for ASP") from the davinci tree and commit
> 32a01291c576c302d82a985d91db720dcf8c891b ("V4L/DVB: DM355 platform
> changes for vpfe capture driver") from the v4l-dvb tree.
>
> I assume that these are orthogonal changes (though they may not be).  I
> fixed it up (see below) and can carry the fixes as necessary.

I can confirm these are overlapping changes.

Kevin
(davinci platform maintainer)

> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>
> diff --cc arch/arm/mach-davinci/dm355.c
> index 3abeb3e,2696df1..0000000
> --- a/arch/arm/mach-davinci/dm355.c
> +++ b/arch/arm/mach-davinci/dm355.c
> @@@ -628,31 -612,67 +636,92 @@@ static struct platform_device dm355_edm
>   	.resource		= edma_resources,
>   };
>   
>  +static struct resource dm355_asp1_resources[] = {
>  +	{
>  +		.start	= DAVINCI_ASP1_BASE,
>  +		.end	= DAVINCI_ASP1_BASE + SZ_8K - 1,
>  +		.flags	= IORESOURCE_MEM,
>  +	},
>  +	{
>  +		.start	= DAVINCI_DMA_ASP1_TX,
>  +		.end	= DAVINCI_DMA_ASP1_TX,
>  +		.flags	= IORESOURCE_DMA,
>  +	},
>  +	{
>  +		.start	= DAVINCI_DMA_ASP1_RX,
>  +		.end	= DAVINCI_DMA_ASP1_RX,
>  +		.flags	= IORESOURCE_DMA,
>  +	},
>  +};
>  +
>  +static struct platform_device dm355_asp1_device = {
>  +	.name		= "davinci-asp",
>  +	.id		= 1,
>  +	.num_resources	= ARRAY_SIZE(dm355_asp1_resources),
>  +	.resource	= dm355_asp1_resources,
>  +};
>  +
> + static struct resource dm355_vpss_resources[] = {
> + 	{
> + 		/* VPSS BL Base address */
> + 		.name		= "vpss",
> + 		.start          = 0x01c70800,
> + 		.end            = 0x01c70800 + 0xff,
> + 		.flags          = IORESOURCE_MEM,
> + 	},
> + 	{
> + 		/* VPSS CLK Base address */
> + 		.name		= "vpss",
> + 		.start          = 0x01c70000,
> + 		.end            = 0x01c70000 + 0xf,
> + 		.flags          = IORESOURCE_MEM,
> + 	},
> + };
> + 
> + static struct platform_device dm355_vpss_device = {
> + 	.name			= "vpss",
> + 	.id			= -1,
> + 	.dev.platform_data	= "dm355_vpss",
> + 	.num_resources		= ARRAY_SIZE(dm355_vpss_resources),
> + 	.resource		= dm355_vpss_resources,
> + };
> + 
> + static struct resource vpfe_resources[] = {
> + 	{
> + 		.start          = IRQ_VDINT0,
> + 		.end            = IRQ_VDINT0,
> + 		.flags          = IORESOURCE_IRQ,
> + 	},
> + 	{
> + 		.start          = IRQ_VDINT1,
> + 		.end            = IRQ_VDINT1,
> + 		.flags          = IORESOURCE_IRQ,
> + 	},
> + 	/* CCDC Base address */
> + 	{
> + 		.flags          = IORESOURCE_MEM,
> + 		.start          = 0x01c70600,
> + 		.end            = 0x01c70600 + 0x1ff,
> + 	},
> + };
> + 
> + static u64 vpfe_capture_dma_mask = DMA_BIT_MASK(32);
> + static struct platform_device vpfe_capture_dev = {
> + 	.name		= CAPTURE_DRV_NAME,
> + 	.id		= -1,
> + 	.num_resources	= ARRAY_SIZE(vpfe_resources),
> + 	.resource	= vpfe_resources,
> + 	.dev = {
> + 		.dma_mask		= &vpfe_capture_dma_mask,
> + 		.coherent_dma_mask	= DMA_BIT_MASK(32),
> + 	},
> + };
> + 
> + void dm355_set_vpfe_config(struct vpfe_config *cfg)
> + {
> + 	vpfe_capture_dev.dev.platform_data = cfg;
> + }
> + 
>   /*----------------------------------------------------------------------*/
>   
>   static struct map_desc dm355_io_desc[] = {

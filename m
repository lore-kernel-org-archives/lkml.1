Return-Path: <linux-kernel-owner+w=401wt.eu-S1758390AbZE2LSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758390AbZE2LSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 07:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756525AbZE2LS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 07:18:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:63486 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755523AbZE2LS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 07:18:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,271,1241420400"; 
   d="scan'208";a="519870444"
Date: Fri, 29 May 2009 13:20:35 +0200
From: Samuel Ortiz <sameo@openedhand.com>
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ian Molton <spyro@f2s.com>,
       Pierre Ossman <pierre@ossman.eu>
Subject: Re: [PATCH 1/5] MFD,mmc: tmio_mmc: make HCLK configurable
Message-ID: <20090529112035.GA12307@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <1243279681-4233-1-git-send-email-philipp.zabel@gmail.com> <1243279681-4233-2-git-send-email-philipp.zabel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243279681-4233-2-git-send-email-philipp.zabel@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25, 2009 at 09:27:57PM +0200, Philipp Zabel wrote:
> The Toshiba parts all have a 24 MHz HCLK, but HTC ASIC3 has a 24.576 MHz HCLK
> and AMD Imageon w228x's HCLK is 80 MHz. With this patch, the MFD driver
> provides the HCLK frequency to tmio_mmc via mfd_cell->driver_data.
Looks good to me. Ian, are you ok with this one ?

Pierre, are you fine with me pushing the mmc bits of this patch through the
mfd tree ?

Cheers,
Samuel.

 
> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
> Cc: Samuel Ortiz <sameo@openedhand.com>
> Cc: Pierre Ossman <pierre@ossman.eu>
> Cc: Ian Molton <spyro@f2s.com>
> ---
>  drivers/mfd/t7l66xb.c       |    5 +++++
>  drivers/mfd/tc6387xb.c      |    5 +++++
>  drivers/mfd/tc6393xb.c      |    5 +++++
>  drivers/mmc/host/tmio_mmc.c |   22 ++++++++++------------
>  include/linux/mfd/tmio.h    |    7 +++++++
>  5 files changed, 32 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/mfd/t7l66xb.c b/drivers/mfd/t7l66xb.c
> index e9f4323..875f7a8 100644
> --- a/drivers/mfd/t7l66xb.c
> +++ b/drivers/mfd/t7l66xb.c
> @@ -108,6 +108,10 @@ static int t7l66xb_mmc_disable(struct platform_device *mmc)
>  
>  /*--------------------------------------------------------------------------*/
>  
> +static const struct tmio_mmc_data t7166xb_mmc_data = {
> +	.hclk = 24000000,
> +};
> +
>  static const struct resource t7l66xb_mmc_resources[] = {
>  	{
>  		.start = 0x800,
> @@ -149,6 +153,7 @@ static struct mfd_cell t7l66xb_cells[] = {
>  		.name = "tmio-mmc",
>  		.enable = t7l66xb_mmc_enable,
>  		.disable = t7l66xb_mmc_disable,
> +		.driver_data = &t7166xb_mmc_data,
>  		.num_resources = ARRAY_SIZE(t7l66xb_mmc_resources),
>  		.resources = t7l66xb_mmc_resources,
>  	},
> diff --git a/drivers/mfd/tc6387xb.c b/drivers/mfd/tc6387xb.c
> index 43222c1..c3993ac 100644
> --- a/drivers/mfd/tc6387xb.c
> +++ b/drivers/mfd/tc6387xb.c
> @@ -75,6 +75,10 @@ static int tc6387xb_mmc_disable(struct platform_device *mmc)
>  
>  /*--------------------------------------------------------------------------*/
>  
> +const static struct tmio_mmc_data tc6387xb_mmc_data = {
> +	.hclk = 24000000,
> +};
> +
>  static struct resource tc6387xb_mmc_resources[] = {
>  	{
>  		.start = 0x800,
> @@ -98,6 +102,7 @@ static struct mfd_cell tc6387xb_cells[] = {
>  		.name = "tmio-mmc",
>  		.enable = tc6387xb_mmc_enable,
>  		.disable = tc6387xb_mmc_disable,
> +		.driver_data = &tc6387xb_mmc_data,
>  		.num_resources = ARRAY_SIZE(tc6387xb_mmc_resources),
>  		.resources = tc6387xb_mmc_resources,
>  	},
> diff --git a/drivers/mfd/tc6393xb.c b/drivers/mfd/tc6393xb.c
> index 77a12fc..9d2abb5 100644
> --- a/drivers/mfd/tc6393xb.c
> +++ b/drivers/mfd/tc6393xb.c
> @@ -136,6 +136,10 @@ static int tc6393xb_nand_enable(struct platform_device *nand)
>  	return 0;
>  }
>  
> +const static struct tmio_mmc_data tc6393xb_mmc_data = {
> +	.hclk = 24000000,
> +};
> +
>  static struct resource __devinitdata tc6393xb_nand_resources[] = {
>  	{
>  		.start	= 0x1000,
> @@ -351,6 +355,7 @@ static struct mfd_cell __devinitdata tc6393xb_cells[] = {
>  	},
>  	[TC6393XB_CELL_MMC] = {
>  		.name = "tmio-mmc",
> +		.driver_data = &tc6393xb_mmc_data,
>  		.num_resources = ARRAY_SIZE(tc6393xb_mmc_resources),
>  		.resources = tc6393xb_mmc_resources,
>  	},
> diff --git a/drivers/mmc/host/tmio_mmc.c b/drivers/mmc/host/tmio_mmc.c
> index 63fbd5b..9c488a8 100644
> --- a/drivers/mmc/host/tmio_mmc.c
> +++ b/drivers/mmc/host/tmio_mmc.c
> @@ -35,15 +35,6 @@
>  
>  #include "tmio_mmc.h"
>  
> -/*
> - * Fixme - documentation conflicts on what the clock values are for the
> - * various dividers.
> - * One document I have says that its a divisor of a 24MHz clock, another 33.
> - * This probably depends on HCLK for a given platform, so we may need to
> - * require HCLK be passed to us from the MFD core.
> - *
> - */
> -
>  static void tmio_mmc_set_clock(struct tmio_mmc_host *host, int new_clock)
>  {
>  	void __iomem *cnf = host->cnf;
> @@ -51,7 +42,7 @@ static void tmio_mmc_set_clock(struct tmio_mmc_host *host, int new_clock)
>  	u32 clk = 0, clock;
>  
>  	if (new_clock) {
> -		for (clock = 46875, clk = 0x100; new_clock >= (clock<<1); ) {
> +		for (clock = host->mmc->f_min, clk = 0x100; new_clock >= (clock<<1); ) {
>  			clock <<= 1;
>  			clk >>= 1;
>  		}
> @@ -545,6 +536,7 @@ out:
>  static int __devinit tmio_mmc_probe(struct platform_device *dev)
>  {
>  	struct mfd_cell	*cell = (struct mfd_cell *)dev->dev.platform_data;
> +	struct tmio_mmc_data *pdata;
>  	struct resource *res_ctl, *res_cnf;
>  	struct tmio_mmc_host *host;
>  	struct mmc_host *mmc;
> @@ -560,6 +552,12 @@ static int __devinit tmio_mmc_probe(struct platform_device *dev)
>  		goto out;
>  	}
>  
> +	pdata = cell->driver_data;
> +	if (!pdata || !pdata->hclk) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
>  	mmc = mmc_alloc_host(sizeof(struct tmio_mmc_host), &dev->dev);
>  	if (!mmc)
>  		goto out;
> @@ -578,8 +576,8 @@ static int __devinit tmio_mmc_probe(struct platform_device *dev)
>  
>  	mmc->ops = &tmio_mmc_ops;
>  	mmc->caps = MMC_CAP_4_BIT_DATA;
> -	mmc->f_min = 46875; /* 24000000 / 512 */
> -	mmc->f_max = 24000000;
> +	mmc->f_max = pdata->hclk;
> +	mmc->f_min = mmc->f_max / 512;
>  	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
>  
>  	/* Enable the MMC/SD Control registers */
> diff --git a/include/linux/mfd/tmio.h b/include/linux/mfd/tmio.h
> index 516d955..c377118 100644
> --- a/include/linux/mfd/tmio.h
> +++ b/include/linux/mfd/tmio.h
> @@ -19,6 +19,13 @@
>  	} while (0)
>  
>  /*
> + * data for the MMC controller
> + */
> +struct tmio_mmc_data {
> +	unsigned int		hclk;
> +};
> +
> +/*
>   * data for the NAND controller
>   */
>  struct tmio_nand_data {
> -- 
> 1.6.3.1
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

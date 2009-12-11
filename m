Return-Path: <linux-kernel-owner+w=401wt.eu-S1756685AbZLKKOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685AbZLKKOW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 05:14:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756349AbZLKKOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 05:14:16 -0500
Received: from mga05.intel.com ([192.55.52.89]:43373 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754802AbZLKKOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 05:14:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,381,1257148800"; 
   d="scan'208";a="521972414"
Date: Fri, 11 Dec 2009 11:15:56 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Juha Keski-Saari <ext-juha.1.keski-saari@nokia.com>
Cc: lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com,
       dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org,
       peter.de-schrijver@nokia.com, eduardo.valentin@nokia.com
Subject: Re: [PATCHv2 1/1] twl4030-mfd: Add all twl4030 regulators to the
 twl4030 mfd driver
Message-ID: <20091211101555.GA5863@sortiz.org>
References: <1259144042-9662-1-git-send-email-ext-juha.1.keski-saari@nokia.com>
 <1259144042-9662-2-git-send-email-ext-juha.1.keski-saari@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259144042-9662-2-git-send-email-ext-juha.1.keski-saari@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Juha,

On Wed, Nov 25, 2009 at 12:14:02PM +0200, Juha Keski-Saari wrote:
> Add all twl4030 regulators to the twl4030 mfd driver and
> twl4030_platform_data
Patch applied, thanks.

Cheers,
Samuel.


> Signed-off-by: Juha Keski-Saari <ext-juha.1.keski-saari@nokia.com>
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Acked-by: Samuel Ortiz <sameo@linux.intel.com>
> ---
>  drivers/mfd/twl4030-core.c  |   26 ++++++++++++++++++++++++--
>  include/linux/i2c/twl4030.h |    8 ++++++--
>  2 files changed, 30 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/mfd/twl4030-core.c b/drivers/mfd/twl4030-core.c
> index 0ee81e4..2d659e6 100644
> --- a/drivers/mfd/twl4030-core.c
> +++ b/drivers/mfd/twl4030-core.c
> @@ -572,11 +572,21 @@ add_children(struct twl4030_platform_data *pdata, unsigned long features)
>  	}
>  
>  	if (twl_has_regulator()) {
> -		/*
>  		child = add_regulator(TWL4030_REG_VPLL1, pdata->vpll1);
>  		if (IS_ERR(child))
>  			return PTR_ERR(child);
> -		*/
> +
> +		child = add_regulator(TWL4030_REG_VIO, pdata->vio);
> +		if (IS_ERR(child))
> +			return PTR_ERR(child);
> +
> +		child = add_regulator(TWL4030_REG_VDD1, pdata->vdd1);
> +		if (IS_ERR(child))
> +			return PTR_ERR(child);
> +
> +		child = add_regulator(TWL4030_REG_VDD2, pdata->vdd2);
> +		if (IS_ERR(child))
> +			return PTR_ERR(child);
>  
>  		child = add_regulator(TWL4030_REG_VMMC1, pdata->vmmc1);
>  		if (IS_ERR(child))
> @@ -592,6 +602,18 @@ add_children(struct twl4030_platform_data *pdata, unsigned long features)
>  				pdata->vaux2);
>  		if (IS_ERR(child))
>  			return PTR_ERR(child);
> +
> +		child = add_regulator(TWL4030_REG_VINTANA1, pdata->vintana1);
> +		if (IS_ERR(child))
> +			return PTR_ERR(child);
> +
> +		child = add_regulator(TWL4030_REG_VINTANA2, pdata->vintana2);
> +		if (IS_ERR(child))
> +			return PTR_ERR(child);
> +
> +		child = add_regulator(TWL4030_REG_VINTDIG, pdata->vintdig);
> +		if (IS_ERR(child))
> +			return PTR_ERR(child);
>  	}
>  
>  	if (twl_has_regulator() && usb_transceiver) {
> diff --git a/include/linux/i2c/twl4030.h b/include/linux/i2c/twl4030.h
> index c188961..bf143d8 100644
> --- a/include/linux/i2c/twl4030.h
> +++ b/include/linux/i2c/twl4030.h
> @@ -440,8 +440,12 @@ struct twl4030_platform_data {
>  	struct regulator_init_data		*vaux2;
>  	struct regulator_init_data		*vaux3;
>  	struct regulator_init_data		*vaux4;
> -
> -	/* REVISIT more to come ... _nothing_ should be hard-wired */
> +	struct regulator_init_data		*vio;
> +	struct regulator_init_data		*vdd1;
> +	struct regulator_init_data		*vdd2;
> +	struct regulator_init_data		*vintana1;
> +	struct regulator_init_data		*vintana2;
> +	struct regulator_init_data		*vintdig;
>  };
>  
>  /*----------------------------------------------------------------------*/
> -- 
> 1.6.3.3
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

Return-Path: <linux-kernel-owner+w=401wt.eu-S1764071AbZAIBCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764071AbZAIBCZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 20:02:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759057AbZAIBCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 20:02:17 -0500
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:39640 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753661AbZAIBCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 20:02:17 -0500
Date: Fri, 9 Jan 2009 02:04:45 +0100
From: Samuel Ortiz <sameo@openedhand.com>
To: David Brownell <david-b@pacbell.net>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [patch 2.6.28-git] mfd:  dm355 evm MMC/SD card detection
Message-ID: <20090109010444.GA2623@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <200901061234.55826.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901061234.55826.david-b@pacbell.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 12:34:55PM -0800, David Brownell wrote:
> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> Support card detect and writeprotect switches on DM355 EVM.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
> ---
> I'd actually not intended that this driver merge until the
> DM355 platform (and EVM board) support merged ... but since
> it's in mainline already, best that it match the latest
> code in the DaVinci tree (simplifies merge-with-mainline).
Thanks David, patch applied.
I didnt understand you were not expecting the 1st patch to be merged already,
sorry about that.

Cheers,
Samuel.

 
> --- a/drivers/mfd/dm355evm_msp.c
> +++ b/drivers/mfd/dm355evm_msp.c
> @@ -107,6 +107,9 @@ static const u8 msp_gpios[] = {
>  	MSP_GPIO(0, SWITCH1), MSP_GPIO(1, SWITCH1),
>  	MSP_GPIO(2, SWITCH1), MSP_GPIO(3, SWITCH1),
>  	MSP_GPIO(4, SWITCH1),
> +	/* switches on MMC/SD sockets */
> +	MSP_GPIO(1, SDMMC), MSP_GPIO(2, SDMMC),	/* mmc0 WP, nCD */
> +	MSP_GPIO(3, SDMMC), MSP_GPIO(4, SDMMC),	/* mmc1 WP, nCD */
>  };
>  
>  #define MSP_GPIO_REG(offset)	(msp_gpios[(offset)] >> 3)
> @@ -304,6 +307,13 @@ static int add_children(struct i2c_client *client)
>  		gpio_export(gpio, false);
>  	}
>  
> +	/* MMC/SD inputs -- right after the last config input */
> +	if (client->dev.platform_data) {
> +		void (*mmcsd_setup)(unsigned) = client->dev.platform_data;
> +
> +		mmcsd_setup(dm355evm_msp_gpio.base + 8 + 5);
> +	}
> +
>  	/* RTC is a 32 bit counter, no alarm */
>  	if (msp_has_rtc()) {
>  		child = add_child(client, "rtc-dm355evm",

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

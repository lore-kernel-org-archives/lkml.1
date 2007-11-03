Return-Path: <linux-kernel-owner+w=401wt.eu-S1755248AbXKCOOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbXKCOOV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 10:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753999AbXKCOON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 10:14:13 -0400
Received: from smtp-106-saturday.noc.nerim.net ([62.4.17.106]:2003 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753926AbXKCOOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 10:14:12 -0400
Date: Sat, 3 Nov 2007 15:14:10 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Bryan Wu <bryan.wu@analog.com>
Cc: i2c@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] Blackfin I2C/TWI driver: add driver descriptions,
 versions and some module useful information
Message-ID: <20071103151410.7a7ed29e@hyperion.delvare>
In-Reply-To: <1193984664-10609-5-git-send-email-bryan.wu@analog.com>
References: <1193984664-10609-1-git-send-email-bryan.wu@analog.com>
	<1193984664-10609-5-git-send-email-bryan.wu@analog.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  2 Nov 2007 14:24:24 +0800, Bryan Wu wrote:
> Signed-off-by: Bryan Wu <bryan.wu@analog.com>
> ---
>  drivers/i2c/busses/i2c-bfin-twi.c |   19 ++++++++++++-------
>  1 files changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-bfin-twi.c b/drivers/i2c/busses/i2c-bfin-twi.c
> index 727625b..ae41c0b 100644
> --- a/drivers/i2c/busses/i2c-bfin-twi.c
> +++ b/drivers/i2c/busses/i2c-bfin-twi.c
> @@ -37,6 +37,15 @@
>  #include <asm/portmux.h>
>  #include <asm/irq.h>
>  
> +#define DRV_NAME	"i2c-bfin-twi"
> +#define DRV_AUTHOR	"Sonic Zhang, Bryan Wu"

What's the point this define when you're using it only once, a few
lines below?

> +#define DRV_DESC	"Blackfin BF5xx on-chip I2C TWI Contoller Driver"
> +#define DRV_VERSION	"1.8"
> +
> +MODULE_AUTHOR(DRV_AUTHOR);
> +MODULE_DESCRIPTION(DRV_DESC);
> +MODULE_LICENSE("GPL");
> +
>  #define POLL_TIMEOUT       (2 * HZ)
>  
>  /* SMBus mode*/
> @@ -701,8 +710,8 @@ static int i2c_bfin_twi_probe(struct platform_device *pdev)
>  	else
>  		platform_set_drvdata(pdev, iface);
>  
> -	dev_info(&pdev->dev, "Blackfin I2C TWI controller, regs_base@%p\n",
> -		iface->regs_base);
> +	dev_info(&pdev->dev, "%s, Version %s, regs_base@%p\n",
> +		DRV_DESC, DRV_VERSION, iface->regs_base);

You're mixing device and driver here. DRV_DESC describes the driver,
while this dev_info() refers to a specific device. So I don't see more
confusion than benefit with this change. If you want to expose the
driver version, you'd rather user MODULE_VERSION().

>  
>  	return rc;
>  
> @@ -735,7 +744,7 @@ static struct platform_driver i2c_bfin_twi_driver = {
>  	.suspend	= i2c_bfin_twi_suspend,
>  	.resume		= i2c_bfin_twi_resume,
>  	.driver		= {
> -		.name	= "i2c-bfin-twi",
> +		.name	= DRV_NAME,
>  		.owner	= THIS_MODULE,
>  	},
>  };
> @@ -750,9 +759,5 @@ static void __exit i2c_bfin_twi_exit(void)
>  	platform_driver_unregister(&i2c_bfin_twi_driver);
>  }
>  
> -MODULE_AUTHOR("Sonic Zhang <sonic.zhang@analog.com>");
> -MODULE_DESCRIPTION("I2C-Bus adapter routines for Blackfin TWI");
> -MODULE_LICENSE("GPL");
> -
>  module_init(i2c_bfin_twi_init);
>  module_exit(i2c_bfin_twi_exit);


-- 
Jean Delvare

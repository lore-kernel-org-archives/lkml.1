Return-Path: <linux-kernel-owner+w=401wt.eu-S1755703AbYFRVvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703AbYFRVvQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 17:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753970AbYFRVvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 17:51:04 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:56457 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240AbYFRVvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 17:51:03 -0400
Date: Wed, 18 Jun 2008 23:20:36 +0200
From: Samuel Ortiz <sameo@openedhand.com>
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] asic3: move probe functions into __init section
Message-ID: <20080618212035.GD22566@caravaggio>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <1213810349.8144.11.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213810349.8144.11.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

On Wed, Jun 18, 2008 at 07:32:29PM +0200, Philipp Zabel wrote:
> Potentially free some memory by moving the _probe functions into __init.
> 
> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
This one looks good to me, I'll submit push it to -mm as I'd prefer asic3
patches to go through there first.

Cheers,
Samuel.


> ---
>  drivers/mfd/asic3.c |    9 ++++-----
>  1 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
> index ef8a492..7d3488d 100644
> --- a/drivers/mfd/asic3.c
> +++ b/drivers/mfd/asic3.c
> @@ -295,7 +295,7 @@ static struct irq_chip asic3_irq_chip = {
>  	.unmask		= asic3_unmask_irq,
>  };
>  
> -static int asic3_irq_probe(struct platform_device *pdev)
> +static int __init asic3_irq_probe(struct platform_device *pdev)
>  {
>  	struct asic3 *asic = platform_get_drvdata(pdev);
>  	unsigned long clksel = 0;
> @@ -443,7 +443,7 @@ void asic3_gpio_set_value(struct asic3 *asic, unsigned gpio, int val)
>  }
>  EXPORT_SYMBOL(asic3_gpio_set_value);
>  
> -static int asic3_gpio_probe(struct platform_device *pdev)
> +static int __init asic3_gpio_probe(struct platform_device *pdev)
>  {
>  	struct asic3_platform_data *pdata = pdev->dev.platform_data;
>  	struct asic3 *asic = platform_get_drvdata(pdev);
> @@ -482,7 +482,7 @@ static void asic3_gpio_remove(struct platform_device *pdev)
>  
>  
>  /* Core */
> -static int asic3_probe(struct platform_device *pdev)
> +static int __init asic3_probe(struct platform_device *pdev)
>  {
>  	struct asic3_platform_data *pdata = pdev->dev.platform_data;
>  	struct asic3 *asic;
> @@ -573,7 +573,6 @@ static struct platform_driver asic3_device_driver = {
>  	.driver		= {
>  		.name	= "asic3",
>  	},
> -	.probe		= asic3_probe,
>  	.remove		= __devexit_p(asic3_remove),
>  	.shutdown	= asic3_shutdown,
>  };
> @@ -581,7 +580,7 @@ static struct platform_driver asic3_device_driver = {
>  static int __init asic3_init(void)
>  {
>  	int retval = 0;
> -	retval = platform_driver_register(&asic3_device_driver);
> +	retval = platform_driver_probe(&asic3_device_driver, asic3_probe);
>  	return retval;
>  }
>  
> -- 
> 1.5.5.4
> 
> 

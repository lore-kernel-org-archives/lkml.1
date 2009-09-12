Return-Path: <linux-kernel-owner+w=401wt.eu-S1754010AbZILQE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbZILQE3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 12:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbZILQEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 12:04:25 -0400
Received: from poutre.nerim.net ([62.4.16.124]:58010 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752851AbZILQEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 12:04:24 -0400
Date: Sat, 12 Sep 2009 18:04:25 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Vitaly Wool <vitalywool@gmail.com>
Cc: Julia Lawall <julia@diku.dk>, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] drivers/i2c: Correct use of
 request_region/request_mem_region
Message-ID: <20090912180425.6dbf339d@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.64.0908091506160.16252@ask.diku.dk>
References: <Pine.LNX.4.64.0908091506160.16252@ask.diku.dk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Aug 2009 15:06:43 +0200 (CEST), Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> request_mem_region should be used when ioremap is used subsequently.
> release_region is then correspondingly replaced by release_mem_region.
> (...)
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  drivers/i2c/busses/i2c-pnx.c        |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-pnx.c b/drivers/i2c/busses/i2c-pnx.c
> index ec15cff..6ff6c20 100644
> --- a/drivers/i2c/busses/i2c-pnx.c
> +++ b/drivers/i2c/busses/i2c-pnx.c
> @@ -586,7 +586,8 @@ static int __devinit i2c_pnx_probe(struct platform_device *pdev)
>  	alg_data->mif.timer.data = (unsigned long)i2c_pnx->adapter;
>  
>  	/* Register I/O resource */
> -	if (!request_region(alg_data->base, I2C_PNX_REGION_SIZE, pdev->name)) {
> +	if (!request_mem_region(alg_data->base, I2C_PNX_REGION_SIZE,
> +				pdev->name)) {
>  		dev_err(&pdev->dev,
>  		       "I/O region 0x%08x for I2C already in use.\n",
>  		       alg_data->base);
> @@ -650,7 +651,7 @@ out_clock:
>  out_unmap:
>  	iounmap((void *)alg_data->ioaddr);
>  out_release:
> -	release_region(alg_data->base, I2C_PNX_REGION_SIZE);
> +	release_mem_region(alg_data->base, I2C_PNX_REGION_SIZE);
>  out_drvdata:
>  	platform_set_drvdata(pdev, NULL);
>  out:
> @@ -667,7 +668,7 @@ static int __devexit i2c_pnx_remove(struct platform_device *pdev)
>  	i2c_del_adapter(adap);
>  	i2c_pnx->set_clock_stop(pdev);
>  	iounmap((void *)alg_data->ioaddr);
> -	release_region(alg_data->base, I2C_PNX_REGION_SIZE);
> +	release_mem_region(alg_data->base, I2C_PNX_REGION_SIZE);
>  	platform_set_drvdata(pdev, NULL);
>  
>  	return 0;

Vitaly, can you please ack this change?

-- 
Jean Delvare

Return-Path: <linux-kernel-owner+w=401wt.eu-S1761936AbYFDTwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761936AbYFDTwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 15:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759389AbYFDTwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 15:52:00 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:44532 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758977AbYFDTv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 15:51:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=c/VBDQkfAdbSY5fqWGHRj1VTrbs8DTdtRimV0BpNtux8E1Rd7ZuvnX0rcij/oOE24z6xvCHIsjmlOC2y4JYw30i0fRpyUMYkKJsCe3LWnV9p1ki5xX1VbyO0TPczpaGNQrwSyymZwd0w3M7XqXiDtdB8gmFfrtqmJEO7/5HYzcc=  ;
X-YMail-OSG: y_YfagAVM1n4C9oD9bRsuumUVQbL8aTCNueDRD7nMlq4lHaRzy6DShDBABTycXTkZxPftxpXR03wRP7TwB_0raIOevIwn_1YaHJZYRuHAktNnZCxrBwOPfXMRTzDb_x8lTs-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Subject: Re: [PATCH] pxa2xx_spi.c: remove redundant initialization, spelling fix, more verbose error
Date: Wed, 4 Jun 2008 12:32:38 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
References: <Pine.LNX.4.64.0806041645070.32657@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0806041645070.32657@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806041232.39106.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 June 2008, Guennadi Liakhovetski wrote:
> Minor fixes: remove redundant local variable initialization, fix "can not" to
> what I _think_ is a preferred spelling, output IRQ number if requesting it
> failed.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>

> 
> ---
> 
> Nothing urgent, just, please, queue it for 2.6.27. Thanks
> 
> diff --git a/drivers/spi/pxa2xx_spi.c b/drivers/spi/pxa2xx_spi.c
> index 0c452c4..4cf72e9 100644
> --- a/drivers/spi/pxa2xx_spi.c
> +++ b/drivers/spi/pxa2xx_spi.c
> @@ -1342,9 +1342,9 @@ static int __init pxa2xx_spi_probe(struct platform_device *pdev)
>  	struct device *dev = &pdev->dev;
>  	struct pxa2xx_spi_master *platform_info;
>  	struct spi_master *master;
> -	struct driver_data *drv_data = NULL;
> +	struct driver_data *drv_data;
>  	struct ssp_device *ssp;
> -	int status = 0;
> +	int status;
>  
>  	platform_info = dev->platform_data;
>  
> @@ -1357,7 +1357,7 @@ static int __init pxa2xx_spi_probe(struct platform_device *pdev)
>  	/* Allocate master with space for drv_data and null dma buffer */
>  	master = spi_alloc_master(dev, sizeof(struct driver_data) + 16);
>  	if (!master) {
> -		dev_err(&pdev->dev, "can not alloc spi_master\n");
> +		dev_err(&pdev->dev, "cannot alloc spi_master\n");
>  		ssp_free(ssp);
>  		return -ENOMEM;
>  	}
> @@ -1393,7 +1393,7 @@ static int __init pxa2xx_spi_probe(struct platform_device *pdev)
>  
>  	status = request_irq(ssp->irq, ssp_int, 0, dev->bus_id, drv_data);
>  	if (status < 0) {
> -		dev_err(&pdev->dev, "can not get IRQ\n");
> +		dev_err(&pdev->dev, "cannot get IRQ %d\n", ssp->irq);
>  		goto out_error_master_alloc;
>  	}
>  
> 



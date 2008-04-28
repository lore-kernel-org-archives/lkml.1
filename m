Return-Path: <linux-kernel-owner+w=401wt.eu-S935156AbYD1UKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935156AbYD1UKb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 16:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932239AbYD1UKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 16:10:23 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37582 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932233AbYD1UKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 16:10:22 -0400
Date: Mon, 28 Apr 2008 21:09:59 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Roel Kluin <12o3l@tiscali.nl>, Ben Dooks <ben@simtec.co.uk>
Cc: Linux-arm <linux-arm-kernel@lists.arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ARM: ax88796: platform_get_irq() may return signed unnoticed
Message-ID: <20080428200958.GF31100@flint.arm.linux.org.uk>
References: <480FADA3.7030708@tiscali.nl> <480FAED6.7080407@tiscali.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480FAED6.7080407@tiscali.nl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2008 at 11:49:10PM +0200, Roel Kluin wrote:
> similarly,

At the top of the file, it says:

 * Copyright 2005,2007 Simtec Electronics
 *      Ben Dooks <ben@simtec.co.uk>

So adding Ben.

> ---
> dev->irq is unsigned, platform_get_irq() may return signed unnoticed
> 
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ---
> diff --git a/drivers/net/ax88796.c b/drivers/net/ax88796.c
> index 194949a..26a735a 100644
> --- a/drivers/net/ax88796.c
> +++ b/drivers/net/ax88796.c
> @@ -838,10 +838,10 @@ static int ax_probe(struct platform_device *pdev)
>  
>  	/* find the platform resources */
>  
> -	dev->irq  = platform_get_irq(pdev, 0);
> -	if (dev->irq < 0) {
> +	ret  = platform_get_irq(pdev, 0);
> +	dev->irq = ret;
> +	if (ret < 0) {
>  		dev_err(&pdev->dev, "no IRQ specified\n");
> -		ret = -ENXIO;
>  		goto exit_mem;
>  	}
>  
> 
> 
> -------------------------------------------------------------------
> List admin: http://lists.arm.linux.org.uk/mailman/listinfo/linux-arm-kernel
> FAQ:        http://www.arm.linux.org.uk/mailinglists/faq.php
> Etiquette:  http://www.arm.linux.org.uk/mailinglists/etiquette.php

Return-Path: <linux-kernel-owner+w=401wt.eu-S934289AbYEGWrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934289AbYEGWrk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 18:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932172AbYEGWrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 18:47:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54901 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765962AbYEGWrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 18:47:12 -0400
Date: Wed, 7 May 2008 15:46:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: galak@kernel.crashing.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
       spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH 1/2] spi_mpc83xx: test below 0 on unsigned irq in
 mpc83xx_spi_probe()
Message-Id: <20080507154641.83a09a06.akpm@linux-foundation.org>
In-Reply-To: <480FA234.1000601@tiscali.nl>
References: <480FA234.1000601@tiscali.nl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Apr 2008 22:55:16 +0200
Roel Kluin <12o3l@tiscali.nl> wrote:

> mpc83xx_spi->irq is unsigned, so the test fails
> 
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ---
> diff --git a/drivers/spi/spi_mpc83xx.c b/drivers/spi/spi_mpc83xx.c
> index be15a62..033fd51 100644
> --- a/drivers/spi/spi_mpc83xx.c
> +++ b/drivers/spi/spi_mpc83xx.c
> @@ -454,12 +454,12 @@ static int __init mpc83xx_spi_probe(struct platform_device *dev)
>  		goto put_master;
>  	}
>  
> -	mpc83xx_spi->irq = platform_get_irq(dev, 0);
> -
> -	if (mpc83xx_spi->irq < 0) {
> -		ret = -ENXIO;
> +	ret = platform_get_irq(dev, 0);
> +	if (ret < 0)
>  		goto unmap_io;
> -	}
> +
> +	mpc83xx_spi->irq = ret;
> +	ret = 0;
>  
>  	/* Register for SPI Interrupt */
>  	ret = request_irq(mpc83xx_spi->irq, mpc83xx_spi_irq,
> 

In the recently-merged spi_mpc83xx-much-improved-driver.patch, mpc83xx_spi.irq
has type `int' so I don't think we need this fix any more.

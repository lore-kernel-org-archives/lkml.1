Return-Path: <linux-kernel-owner+w=401wt.eu-S1755529AbYDWUj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbYDWUj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 16:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753673AbYDWUjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 16:39:47 -0400
Received: from gate.crashing.org ([63.228.1.57]:54215 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211AbYDWUjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 16:39:47 -0400
Cc: "linuxppc-dev@ozlabs.org list" <linuxppc-dev@ozlabs.org>,
       lkml <linux-kernel@vger.kernel.org>,
       spi-devel-general@lists.sourceforge.net
Message-Id: <7C711FFF-E1C5-4286-93A8-382055C6760C@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Roel Kluin <12o3l@tiscali.nl>
In-Reply-To: <480F99D5.7070300@tiscali.nl>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [PATCH] spi_mpc83xx: test below 0 on unsigned irq in mpc83xx_spi_probe()
Date: Wed, 23 Apr 2008 15:39:32 -0500
References: <480F99D5.7070300@tiscali.nl>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 23, 2008, at 3:19 PM, Roel Kluin wrote:
> mpc83xx_spi->irq is unsigned, so the test fails
>
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>

you should copy the linux-spi list on such patches.

- k

>
> ---
> diff --git a/drivers/spi/spi_mpc83xx.c b/drivers/spi/spi_mpc83xx.c
> index be15a62..033fd51 100644
> --- a/drivers/spi/spi_mpc83xx.c
> +++ b/drivers/spi/spi_mpc83xx.c
> @@ -454,12 +454,12 @@ static int __init mpc83xx_spi_probe(struct  
> platform_device *dev)
> 		goto put_master;
> 	}
>
> -	mpc83xx_spi->irq = platform_get_irq(dev, 0);
> -
> -	if (mpc83xx_spi->irq < 0) {
> -		ret = -ENXIO;
> +	ret = platform_get_irq(dev, 0);
> +	if (ret < 0)
> 		goto unmap_io;
> -	}
> +
> +	mpc83xx_spi->irq = ret;
> +	ret = 0;
>
> 	/* Register for SPI Interrupt */
> 	ret = request_irq(mpc83xx_spi->irq, mpc83xx_spi_irq,


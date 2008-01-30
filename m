Return-Path: <linux-kernel-owner+w=401wt.eu-S1763240AbYAaAKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763240AbYAaAKd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 19:10:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbYAaAKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 19:10:23 -0500
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:38095 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755345AbYAaAKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 19:10:21 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Ku44UN4b9VFttIzMfg3WGQi4pCsJ+LvrPcJ7G3w3iR3qSYGrdaO9U6WdzB1uh+ClHhIrYC2Njh/ccLXzyjBQn4w/eEWsQ21dJjrTB0sSxOyADKYhOYUSQ52+0Xv04OXYUuyONFHmptm9rPKS4dU07f/YF293QKZ9I3zOQi21mOM=  ;
X-YMail-OSG: Xt37OxEVM1miF.SpXpKlsHLdZ1fTyMHkIsFStPPWISon27hm1qFC4ajKRq884uCKxJYhGtHvjw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Bryan Wu <bryan.wu@analog.com>
Subject: Re: [spi-devel-general] [PATCH 2/6] [Blackfin] SPI driver: Use SPI device name to do gpio peripheral request
Date: Wed, 30 Jan 2008 13:48:43 -0800
User-Agent: KMail/1.9.6
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <1201684421-26124-1-git-send-email-bryan.wu@analog.com> <1201684421-26124-3-git-send-email-bryan.wu@analog.com>
In-Reply-To: <1201684421-26124-3-git-send-email-bryan.wu@analog.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801301348.43275.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 January 2008, Bryan Wu wrote:
> When got some gpio conflict, it is easy to know which SPI device driver not just got "bfin-spi"
> 
> Signed-off-by: Bryan Wu <bryan.wu@analog.com>
> ---
>  drivers/spi/spi_bfin5xx.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
> index 8fd1365..c3f9ed4 100644
> --- a/drivers/spi/spi_bfin5xx.c
> +++ b/drivers/spi/spi_bfin5xx.c
> @@ -1176,7 +1176,7 @@ static int setup(struct spi_device *spi)
>  	if ((chip->chip_select_num > 0)
>  		&& (chip->chip_select_num <= spi->master->num_chipselect))
>  		peripheral_request(ssel[spi->master->bus_num]
> -			[chip->chip_select_num-1], DRV_NAME);
> +			[chip->chip_select_num-1], spi->modalias);

Better:  spi->dev.bus_id (always unique) not spi->modalias (isn't) ...

 
>  
>  	cs_deactive(drv_data, chip);
>  
> 

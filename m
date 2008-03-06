Return-Path: <linux-kernel-owner+w=401wt.eu-S934304AbYCFDE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934304AbYCFDE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 22:04:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759340AbYCFDES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 22:04:18 -0500
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:39402 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758990AbYCFDER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 22:04:17 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=JRREGhklw24M3sM+2GfKvvaQdG+FuOhwXtZWMMQtUqWG7RUyI+RKttxB1LfO7hH1a35P/tLsKg/ASaUedNJlW4TJBJuLAPqFWZaAZy/cUK6HN5XQeVmt4C16U9WXGHTEjfmGejbn/T032mZUM009p51V8FqUsVoLKE3CgoIRE7Q=  ;
X-YMail-OSG: PjhD4wcVM1klIjUA0oxzb5AEIbLQgvdVI_GPtv8QcnVWoDHteKE14ASgD.cnAEhY61SfTYyKyw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH 14/16] spi: replace remaining __FUNCTION__ occurrences
Date: Wed, 5 Mar 2008 19:04:11 -0800
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <1204770298.14154.50.camel@brick>
In-Reply-To: <1204770298.14154.50.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803051904.11968.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 March 2008, Harvey Harrison wrote:
> __FUNCTION__ is gcc-specific, use __func__
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>

C99-rUl3z!

> ---
>  drivers/spi/omap_uwire.c  |    4 ++--
>  drivers/spi/spi_bitbang.c |    2 +-
>  drivers/spi/spi_mpc83xx.c |    2 +-
>  drivers/spi/spi_s3c24xx.c |    2 +-
>  drivers/spi/xilinx_spi.c  |    8 ++++----
>  5 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/spi/omap_uwire.c b/drivers/spi/omap_uwire.c
> index 8245b51..ea18077 100644
> --- a/drivers/spi/omap_uwire.c
> +++ b/drivers/spi/omap_uwire.c
> @@ -151,7 +151,7 @@ static int wait_uwire_csr_flag(u16 mask, u16 val, int might_not_catch)
>  		if (time_after(jiffies, max_jiffies)) {
>  			printk(KERN_ERR "%s: timeout. reg=%#06x "
>  					"mask=%#06x val=%#06x\n",
> -			       __FUNCTION__, w, mask, val);
> +			       __func__, w, mask, val);
>  			return -1;
>  		}
>  		c++;
> @@ -437,7 +437,7 @@ static int uwire_setup_transfer(struct spi_device *spi, struct spi_transfer *t)
>  	}
>  	omap_uwire_configure_mode(spi->chip_select, flags);
>  	pr_debug("%s: uwire flags %02x, armxor %lu KHz, SCK %lu KHz\n",
> -			__FUNCTION__, flags,
> +			__func__, flags,
>  			clk_get_rate(uwire->ck) / 1000,
>  			rate / 1000);
>  	status = 0;
> diff --git a/drivers/spi/spi_bitbang.c b/drivers/spi/spi_bitbang.c
> index f7f8580..061e344 100644
> --- a/drivers/spi/spi_bitbang.c
> +++ b/drivers/spi/spi_bitbang.c
> @@ -214,7 +214,7 @@ int spi_bitbang_setup(struct spi_device *spi)
>  		return retval;
>  
>  	dev_dbg(&spi->dev, "%s, mode %d, %u bits/w, %u nsec/bit\n",
> -			__FUNCTION__, spi->mode & (SPI_CPOL | SPI_CPHA),
> +			__func__, spi->mode & (SPI_CPOL | SPI_CPHA),
>  			spi->bits_per_word, 2 * cs->nsecs);
>  
>  	/* NOTE we _need_ to call chipselect() early, ideally with adapter
> diff --git a/drivers/spi/spi_mpc83xx.c b/drivers/spi/spi_mpc83xx.c
> index 04f7cd9..df9f0d4 100644
> --- a/drivers/spi/spi_mpc83xx.c
> +++ b/drivers/spi/spi_mpc83xx.c
> @@ -310,7 +310,7 @@ static int mpc83xx_spi_setup(struct spi_device *spi)
>  		return retval;
>  
>  	dev_dbg(&spi->dev, "%s, mode %d, %u bits/w, %u nsec\n",
> -		__FUNCTION__, spi->mode & (SPI_CPOL | SPI_CPHA),
> +		__func__, spi->mode & (SPI_CPOL | SPI_CPHA),
>  		spi->bits_per_word, 2 * mpc83xx_spi->nsecs);
>  
>  	/* NOTE we _need_ to call chipselect() early, ideally with adapter
> diff --git a/drivers/spi/spi_s3c24xx.c b/drivers/spi/spi_s3c24xx.c
> index 6e834b8..4ad5abb 100644
> --- a/drivers/spi/spi_s3c24xx.c
> +++ b/drivers/spi/spi_s3c24xx.c
> @@ -169,7 +169,7 @@ static int s3c24xx_spi_setup(struct spi_device *spi)
>  	}
>  
>  	dev_dbg(&spi->dev, "%s: mode %d, %u bpw, %d hz\n",
> -		__FUNCTION__, spi->mode, spi->bits_per_word,
> +		__func__, spi->mode, spi->bits_per_word,
>  		spi->max_speed_hz);
>  
>  	return 0;
> diff --git a/drivers/spi/xilinx_spi.c b/drivers/spi/xilinx_spi.c
> index 5d04f52..9ba5741 100644
> --- a/drivers/spi/xilinx_spi.c
> +++ b/drivers/spi/xilinx_spi.c
> @@ -151,13 +151,13 @@ static int xilinx_spi_setup_transfer(struct spi_device *spi,
>  	hz = (t) ? t->speed_hz : spi->max_speed_hz;
>  	if (bits_per_word != 8) {
>  		dev_err(&spi->dev, "%s, unsupported bits_per_word=%d\n",
> -			__FUNCTION__, bits_per_word);
> +			__func__, bits_per_word);
>  		return -EINVAL;
>  	}
>  
>  	if (hz && xspi->speed_hz > hz) {
>  		dev_err(&spi->dev, "%s, unsupported clock rate %uHz\n",
> -			__FUNCTION__, hz);
> +			__func__, hz);
>  		return -EINVAL;
>  	}
>  
> @@ -181,7 +181,7 @@ static int xilinx_spi_setup(struct spi_device *spi)
>  
>  	if (spi->mode & ~MODEBITS) {
>  		dev_err(&spi->dev, "%s, unsupported mode bits %x\n",
> -			__FUNCTION__, spi->mode & ~MODEBITS);
> +			__func__, spi->mode & ~MODEBITS);
>  		return -EINVAL;
>  	}
>  
> @@ -190,7 +190,7 @@ static int xilinx_spi_setup(struct spi_device *spi)
>  		return retval;
>  
>  	dev_dbg(&spi->dev, "%s, mode %d, %u bits/w, %u nsec/bit\n",
> -		__FUNCTION__, spi->mode & MODEBITS, spi->bits_per_word, 0);
> +		__func__, spi->mode & MODEBITS, spi->bits_per_word, 0);
>  
>  	return 0;
>  }
> -- 
> 1.5.4.GIT
> 
> 



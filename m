Return-Path: <linux-kernel-owner+w=401wt.eu-S1759559AbZEKVJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759559AbZEKVJ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 17:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755510AbZEKVJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 17:09:17 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55632 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbZEKVJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 17:09:17 -0400
Date: Mon, 11 May 2009 22:09:11 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: lrg@slimlogic.co.uk, alsa-devel@alsa-project.org,
       lkml <linux-kernel@vger.kernel.org>
Message-ID: <20090511210910.GA4482@sirena.org.uk>
References: <4A088314.1000204@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A088314.1000204@gmail.com>
X-Cookie: Process promptly.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH] soc: remove driver_data direct access of
	struct device
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 09:57:08PM +0200, Roel Kluin wrote:

I've applied this since it's so trivial but please in future:

 - Give a Signed-off-by for your patches.
 - CC maintainers for your patches.

> diff --git a/sound/soc/codecs/wm8400.c b/sound/soc/codecs/wm8400.c
> index 510efa6..e4547de 100644
> --- a/sound/soc/codecs/wm8400.c
> +++ b/sound/soc/codecs/wm8400.c
> @@ -1473,8 +1473,8 @@ static int wm8400_codec_probe(struct platform_device *dev)
>  
>  	codec = &priv->codec;
>  	codec->private_data = priv;
> -	codec->control_data = dev->dev.driver_data;
> -	priv->wm8400 = dev->dev.driver_data;
> +	codec->control_data = dev_get_drvdata(&dev->dev);
> +	priv->wm8400 = dev_get_drvdata(&dev->dev);
>  
>  	ret = regulator_bulk_get(priv->wm8400->dev,
>  				 ARRAY_SIZE(power), &power[0]);
> diff --git a/sound/soc/codecs/wm8731.c b/sound/soc/codecs/wm8731.c
> index e043e3f..7a20587 100644
> --- a/sound/soc/codecs/wm8731.c
> +++ b/sound/soc/codecs/wm8731.c
> @@ -666,14 +666,14 @@ static int __devinit wm8731_spi_probe(struct spi_device *spi)
>  	codec->hw_write = (hw_write_t)wm8731_spi_write;
>  	codec->dev = &spi->dev;
>  
> -	spi->dev.driver_data = wm8731;
> +	dev_set_drvdata(&spi->dev, wm8731);
>  
>  	return wm8731_register(wm8731);
>  }
>  
>  static int __devexit wm8731_spi_remove(struct spi_device *spi)
>  {
> -	struct wm8731_priv *wm8731 = spi->dev.driver_data;
> +	struct wm8731_priv *wm8731 = dev_get_drvdata(&spi->dev);
>  
>  	wm8731_unregister(wm8731);
>  
> diff --git a/sound/soc/codecs/wm8753.c b/sound/soc/codecs/wm8753.c
> index a6e8f3f..d121e58 100644
> --- a/sound/soc/codecs/wm8753.c
> +++ b/sound/soc/codecs/wm8753.c
> @@ -1822,14 +1822,14 @@ static int __devinit wm8753_spi_probe(struct spi_device *spi)
>  	codec->hw_write = (hw_write_t)wm8753_spi_write;
>  	codec->dev = &spi->dev;
>  
> -	spi->dev.driver_data = wm8753;
> +	dev_set_drvdata(&spi->dev, wm8753);
>  
>  	return wm8753_register(wm8753);
>  }
>  
>  static int __devexit wm8753_spi_remove(struct spi_device *spi)
>  {
> -	struct wm8753_priv *wm8753 = spi->dev.driver_data;
> +	struct wm8753_priv *wm8753 = dev_get_drvdata(&spi->dev);
>  	wm8753_unregister(wm8753);
>  	return 0;
>  }
> _______________________________________________
> Alsa-devel mailing list
> Alsa-devel@alsa-project.org
> http://mailman.alsa-project.org/mailman/listinfo/alsa-devel
> 

-- 
"You grabbed my hand and we fell into it, like a daydream - or a fever."

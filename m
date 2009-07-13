Return-Path: <linux-kernel-owner+w=401wt.eu-S1755236AbZGMJoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbZGMJoG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 05:44:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755020AbZGMJoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 05:44:04 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56108 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802AbZGMJoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 05:44:03 -0400
Date: Mon, 13 Jul 2009 10:44:01 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
       Jaroslav Kysela <perex@perex.cz>, Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH 7/9] Sound: remove direct access of driver_data
Message-ID: <20090713094401.GA24783@sirena.org.uk>
References: <20090712223717.GB16600@kroah.com> <1247438766-17266-7-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247438766-17266-7-git-send-email-gregkh@suse.de>
X-Cookie: Everyone is entitled to my opinion.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 12, 2009 at 03:46:04PM -0700, Greg Kroah-Hartman wrote:
> This is the last in-kernel direct usage of driver_data, replace it with
> the proper dev_get/set_drvdata() calls.

Any objections to me applying this to ASoC, and if so do you want it in
2.6.31?

> Cc: Takashi Iwai <tiwai@suse.de>
> Cc: Jaroslav Kysela <perex@perex.cz>
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Liam Girdwood <lrg@slimlogic.co.uk>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  sound/soc/codecs/wm8988.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/sound/soc/codecs/wm8988.c b/sound/soc/codecs/wm8988.c
> index c05f718..8c0fdf8 100644
> --- a/sound/soc/codecs/wm8988.c
> +++ b/sound/soc/codecs/wm8988.c
> @@ -1037,14 +1037,14 @@ static int __devinit wm8988_spi_probe(struct spi_device *spi)
>  	codec->control_data = spi;
>  	codec->dev = &spi->dev;
>  
> -	spi->dev.driver_data = wm8988;
> +	dev_set_drvdata(&spi->dev, wm8988);
>  
>  	return wm8988_register(wm8988);
>  }
>  
>  static int __devexit wm8988_spi_remove(struct spi_device *spi)
>  {
> -	struct wm8988_priv *wm8988 = spi->dev.driver_data;
> +	struct wm8988_priv *wm8988 = dev_get_drvdata(&spi->dev);
>  
>  	wm8988_unregister(wm8988);
>  
> -- 
> 1.6.3.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
"You grabbed my hand and we fell into it, like a daydream - or a fever."

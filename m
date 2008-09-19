Return-Path: <linux-kernel-owner+w=401wt.eu-S1754636AbYISSUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbYISSUt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 14:20:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753405AbYISSUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 14:20:41 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:1742 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbYISSUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 14:20:40 -0400
Date: Fri, 19 Sep 2008 19:20:38 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org,
       alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: Fix at32-pcm build breakage with PM enabled
Message-ID: <20080919182036.GA16316@sirena.org.uk>
Mail-Followup-To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
	lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org,
	alsa-devel@alsa-project.org
References: <1221843045-18093-1-git-send-email-haavard.skinnemoen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221843045-18093-1-git-send-email-haavard.skinnemoen@atmel.com>
X-Cookie: What's so funny?
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2008 at 06:50:45PM +0200, Haavard Skinnemoen wrote:
> s/PDC_PTCR/ATMEL_PDC_PTCR/
> 
> Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Please submit all ALSA patches to alsa-devel (added to the CC).

>  sound/soc/at32/at32-pcm.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/sound/soc/at32/at32-pcm.c b/sound/soc/at32/at32-pcm.c
> index 435f1da..c83584f 100644
> --- a/sound/soc/at32/at32-pcm.c
> +++ b/sound/soc/at32/at32-pcm.c
> @@ -434,7 +434,8 @@ static int at32_pcm_suspend(struct platform_device *pdev,
>  	params = prtd->params;
>  
>  	/* Disable the PDC and save the PDC registers */
> -	ssc_writex(params->ssc->regs, PDC_PTCR, params->mask->pdc_disable);
> +	ssc_writex(params->ssc->regs, ATMEL_PDC_PTCR,
> +		   params->mask->pdc_disable);
>  
>  	prtd->pdc_xpr_save = ssc_readx(params->ssc->regs, params->pdc->xpr);
>  	prtd->pdc_xcr_save = ssc_readx(params->ssc->regs, params->pdc->xcr);
> @@ -464,7 +465,7 @@ static int at32_pcm_resume(struct platform_device *pdev,
>  	ssc_writex(params->ssc->regs, params->pdc->xnpr, prtd->pdc_xnpr_save);
>  	ssc_writex(params->ssc->regs, params->pdc->xncr, prtd->pdc_xncr_save);
>  
> -	ssc_writex(params->ssc->regs, PDC_PTCR, params->mask->pdc_enable);
> +	ssc_writex(params->ssc->regs, ATMEL_PDC_PTCR, params->mask->pdc_enable);
>  	return 0;
>  }
>  #else /* CONFIG_PM */
> -- 
> 1.5.6.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
"You grabbed my hand and we fell into it, like a daydream - or a fever."

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754921AbYJ2V2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbYJ2V2m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 17:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753685AbYJ2V2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 17:28:31 -0400
Received: from www.tglx.de ([62.245.132.106]:41115 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173AbYJ2V2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 17:28:30 -0400
Date: Wed, 29 Oct 2008 22:28:09 +0100
From: "Hans J. Koch" <hjk@linutronix.de>
To: Mike Frysinger <vapier@gentoo.org>
Cc: hjk@linutronix.de, gregkh@suse.de, damm@igel.co.jp,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UIO: uio_pdrv_genirq: allow custom irq_flags
Message-ID: <20081029212809.GD2951@local>
References: <1225301195-21433-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225301195-21433-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2008 at 01:26:35PM -0400, Mike Frysinger wrote:
> I can't think of a reason why the driver prevents people from setting any
> custom bits in their platform device, 

The reason was to prevent people from adding IRQF_SHARED since that
won't work.

> but I can think of some reasons for
> allowing custom flags.  Like setting the IRQF_TRIGGER_... bits.

Sounds OK to me, but then you have to check that IRQF_SHARED is _not_
set in pdev->uioinfo->irq_flags.
Could you send a new patch that does this?

Magnus, any comments?

Thanks,
Hans


> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
>  drivers/uio/uio_pdrv_genirq.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
> index 1f82c83..8695245 100644
> --- a/drivers/uio/uio_pdrv_genirq.c
> +++ b/drivers/uio/uio_pdrv_genirq.c
> @@ -81,7 +81,7 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
>  		goto bad0;
>  	}
>  
> -	if (uioinfo->handler || uioinfo->irqcontrol || uioinfo->irq_flags) {
> +	if (uioinfo->handler || uioinfo->irqcontrol) {
>  		dev_err(&pdev->dev, "interrupt configuration error\n");
>  		goto bad0;
>  	}
> @@ -132,7 +132,7 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
>  	 * Interrupt sharing is not supported.
>  	 */
>  
> -	uioinfo->irq_flags = IRQF_DISABLED;
> +	uioinfo->irq_flags |= IRQF_DISABLED;
>  	uioinfo->handler = uio_pdrv_genirq_handler;
>  	uioinfo->irqcontrol = uio_pdrv_genirq_irqcontrol;
>  	uioinfo->priv = priv;
> -- 
> 1.6.0.2

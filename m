Return-Path: <linux-kernel-owner+w=401wt.eu-S1754450AbYDWXnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450AbYDWXnf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 19:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751174AbYDWXn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 19:43:27 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:42898 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbYDWXn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 19:43:27 -0400
X-Greylist: delayed 1634 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Apr 2008 19:43:27 EDT
Date: Thu, 24 Apr 2008 01:16:09 +0200
From: Samuel Ortiz <sameo@openedhand.com>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: pb@handhelds.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] asic3: platform_get_irq() may return signed unnoticed
Message-ID: <20080423231608.GC18907@caravaggio>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <480FAB05.1040107@tiscali.nl> <480FBA51.8020403@tiscali.nl> <480FBEFA.3030903@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480FBEFA.3030903@tiscali.nl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2008 at 12:58:02AM +0200, Roel Kluin wrote:
> Thanks to Joe Perches for catching an error in my previous
Yep, that makes sense now.

> ---
> asic->irq_nr is unsigned. platform_get_irq() may return signed unnoticed
> 
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Acked-by: Samuel Ortiz <sameo@openedhand.com>

> ---
> diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
> index f6f2d96..abd7ffc 100644
> --- a/drivers/mfd/asic3.c
> +++ b/drivers/mfd/asic3.c
> @@ -300,10 +300,13 @@ static int asic3_irq_probe(struct platform_device *pdev)
>  	struct asic3 *asic = platform_get_drvdata(pdev);
>  	unsigned long clksel = 0;
>  	unsigned int irq, irq_base;
> +	int ret;
> +
> +	ret = platform_get_irq(pdev, 0);
> +	if (ret < 0)
> +		return ret;
>  
> -	asic->irq_nr = platform_get_irq(pdev, 0);
> -	if (asic->irq_nr < 0)
> -		return asic->irq_nr;
> +	asic->irq_nr = ret;
>  
>  	/* turn on clock to IRQ controller */
>  	clksel |= CLOCK_SEL_CX;
> 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753093AbZDTX0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093AbZDTX0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 19:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751347AbZDTX0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 19:26:39 -0400
Received: from relais.videotron.ca ([24.201.245.36]:38781 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbZDTX0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 19:26:38 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Mon, 20 Apr 2009 19:26:32 -0400 (EDT)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Rabin Vincent <rabin@rab.in>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mvsdio: fix CONFIG_PM=y build
In-reply-to: <20090420184454.GA8867@debian>
Message-id: <alpine.LFD.2.00.0904201925580.6741@xanadu.home>
References: <20090420184454.GA8867@debian>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Apr 2009, Rabin Vincent wrote:

> Fix usage of obsolete parameters and functions in the driver's PM
> callbacks.
> 
> Signed-off-by: Rabin Vincent <rabin@rab.in>

Acked-by: Nicolas Pitre <nico@marvell.com>


> ---
>  drivers/mmc/host/mvsdio.c |   11 +++++------
>  1 files changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/mmc/host/mvsdio.c b/drivers/mmc/host/mvsdio.c
> index b5c375d..c643d0f 100644
> --- a/drivers/mmc/host/mvsdio.c
> +++ b/drivers/mmc/host/mvsdio.c
> @@ -825,24 +825,23 @@ static int __exit mvsd_remove(struct platform_device *pdev)
>  }
>  
>  #ifdef CONFIG_PM
> -static int mvsd_suspend(struct platform_device *dev, pm_message_t state,
> -			   u32 level)
> +static int mvsd_suspend(struct platform_device *dev, pm_message_t state)
>  {
>  	struct mmc_host *mmc = platform_get_drvdata(dev);
>  	int ret = 0;
>  
> -	if (mmc && level == SUSPEND_DISABLE)
> +	if (mmc)
>  		ret = mmc_suspend_host(mmc, state);
>  
>  	return ret;
>  }
>  
> -static int mvsd_resume(struct platform_device *dev, u32 level)
> +static int mvsd_resume(struct platform_device *dev)
>  {
> -	struct mmc_host *mmc = platform_dev_get_drvdata(dev);
> +	struct mmc_host *mmc = platform_get_drvdata(dev);
>  	int ret = 0;
>  
> -	if (mmc && level == RESUME_ENABLE)
> +	if (mmc)
>  		ret = mmc_resume_host(mmc);
>  
>  	return ret;
> -- 
> 1.6.2.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

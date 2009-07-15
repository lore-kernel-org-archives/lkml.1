Return-Path: <linux-kernel-owner+w=401wt.eu-S932201AbZGOSgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201AbZGOSgn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 14:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756034AbZGOSgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 14:36:42 -0400
Received: from smtprelay09.ispgateway.de ([80.67.31.32]:46360 "EHLO
	smtprelay09.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031AbZGOSgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 14:36:41 -0400
References: <1247672919-13089-1-git-send-email-petkovbb@gmail.com>
Message-ID: <cone.1247683003.40459.21332.1000@deskpiie>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Borislav Petkov <petkovbb@googlemail.com>
Cc: lenb@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acerhdf: convert to dev_pm_ops
Date: Wed, 15 Jul 2009 20:36:43 +0200
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: 404094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Works fine here, thanks!

Acked-by: Peter Feuerer <peter@piie.net>

Borislav Petkov writes:

> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> ---
>  drivers/platform/x86/acerhdf.c |   14 +++++++++-----
>  1 files changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
> index aa298d6..561b471 100644
> --- a/drivers/platform/x86/acerhdf.c
> +++ b/drivers/platform/x86/acerhdf.c
> @@ -435,7 +435,7 @@ struct thermal_cooling_device_ops acerhdf_cooling_ops = {
>  };
>  
>  /* suspend / resume functionality */
> -static int acerhdf_suspend(struct platform_device *dev, pm_message_t state)
> +static int acerhdf_suspend(struct device *dev)
>  {
>  	if (kernelmode)
>  		acerhdf_change_fanstate(ACERHDF_FAN_AUTO);
> @@ -446,7 +446,7 @@ static int acerhdf_suspend(struct platform_device *dev, pm_message_t state)
>  	return 0;
>  }
>  
> -static int acerhdf_resume(struct platform_device *device)
> +static int acerhdf_resume(struct device *dev)
>  {
>  	if (verbose)
>  		pr_notice("resuming\n");
> @@ -464,15 +464,19 @@ static int acerhdf_remove(struct platform_device *device)
>  	return 0;
>  }
>  
> +static struct dev_pm_ops acerhdf_pm_ops = {
> +	.suspend = acerhdf_suspend,
> +	.resume	 = acerhdf_resume,
> +};
> +
>  static struct platform_driver acerhdf_driver = {
>  	.driver = {
> -		.name = "acerhdf",
> +		.name  = "acerhdf",
>  		.owner = THIS_MODULE,
> +		.pm    = &acerhdf_pm_ops,
>  	},
>  	.probe = acerhdf_probe,
>  	.remove = acerhdf_remove,
> -	.suspend = acerhdf_suspend,
> -	.resume = acerhdf_resume,
>  };
>  
>  
> -- 
> 1.6.3.3
> 

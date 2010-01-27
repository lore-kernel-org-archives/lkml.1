Return-Path: <linux-kernel-owner+w=401wt.eu-S932246Ab0A0Xvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246Ab0A0Xvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 18:51:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754340Ab0A0Xvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 18:51:39 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57001 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754252Ab0A0Xvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 18:51:38 -0500
Date: Wed, 27 Jan 2010 15:48:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
       trivial@kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] imxfb: correct location of callbacks in suspend and
 resume
Message-Id: <20100127154818.de91e255.akpm@linux-foundation.org>
In-Reply-To: <1264433854-878-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1263226881-28008-1-git-send-email-u.kleine-koenig@pengutronix.de>
	<1264433854-878-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jan 2010 16:37:34 +0100
Uwe Kleine-K__nig  <u.kleine-koenig@pengutronix.de> wrote:

> The probe function passes a pointer to a struct fb_info to
> platform_set_drvdata, so don't interpret the return value of
> platform_get_drvdata as a pointer to struct imxfb_info.
> 
> Signed-off-by: Uwe Kleine-K__nig <u.kleine-koenig@pengutronix.de>
> Acked-by: Sascha Hauer <kernel@pengutronix.de>
> Cc: linux-arm-kernel@lists.infradead.org
> ---
>  drivers/video/imxfb.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/video/imxfb.c b/drivers/video/imxfb.c
> index 66358fa..b4b6dec 100644
> --- a/drivers/video/imxfb.c
> +++ b/drivers/video/imxfb.c
> @@ -593,7 +593,8 @@ static int imxfb_activate_var(struct fb_var_screeninfo *var, struct fb_info *inf
>   */
>  static int imxfb_suspend(struct platform_device *dev, pm_message_t state)
>  {
> -	struct imxfb_info *fbi = platform_get_drvdata(dev);
> +	struct fb_info *info = platform_get_drvdata(dev);
> +	struct imxfb_info *fbi = info->par;
>  
>  	pr_debug("%s\n", __func__);
>  
> @@ -603,7 +604,8 @@ static int imxfb_suspend(struct platform_device *dev, pm_message_t state)
>  
>  static int imxfb_resume(struct platform_device *dev)
>  {
> -	struct imxfb_info *fbi = platform_get_drvdata(dev);
> +	struct fb_info *info = platform_get_drvdata(dev);
> +	struct imxfb_info *fbi = info->par;
>  
>  	pr_debug("%s\n", __func__);
>  

What were the runtime effects of this bug?

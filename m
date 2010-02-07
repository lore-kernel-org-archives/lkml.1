Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299Ab0BGX5g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 18:57:36 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51539 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754917Ab0BGX5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 18:57:35 -0500
Date: Sun, 7 Feb 2010 23:57:34 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org,
       kyungmin.park@samsung.com, myungjoo.ham@samsung.com
Subject: Re: [PATCH] mfd: Fix WM8994 error handling
Message-ID: <20100207235733.GB14408@opensource.wolfsonmicro.com>
References: <4B6E145E.9090300@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B6E145E.9090300@samsung.com>
X-Cookie: You will wish you hadn't.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 07, 2010 at 10:16:14AM +0900, Joonyoung Shim wrote:
> This patch fixes wrong goto statement for error handling on probe.
> 
> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>

Good catch, thanks.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

> ---
>  drivers/mfd/wm8994-core.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
> index 299c1af..844e1c1 100644
> --- a/drivers/mfd/wm8994-core.c
> +++ b/drivers/mfd/wm8994-core.c
> @@ -305,14 +305,14 @@ static int wm8994_device_init(struct wm8994 *wm8994, unsigned long id, int irq)
>  				 wm8994->supplies);
>  	if (ret != 0) {
>  		dev_err(wm8994->dev, "Failed to get supplies: %d\n", ret);
> -		goto err_get;
> +		goto err_supplies;
>  	}
>  
>  	ret = regulator_bulk_enable(ARRAY_SIZE(wm8994_main_supplies),
>  				    wm8994->supplies);
>  	if (ret != 0) {
>  		dev_err(wm8994->dev, "Failed to enable supplies: %d\n", ret);
> -		goto err_supplies;
> +		goto err_get;
>  	}
>  
>  	ret = wm8994_reg_read(wm8994, WM8994_SOFTWARE_RESET);
> -- 
> 1.6.3.3

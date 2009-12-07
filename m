Return-Path: <linux-kernel-owner+w=401wt.eu-S1753476AbZLGHIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbZLGHIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 02:08:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756154AbZLGHIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 02:08:41 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:63235 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349AbZLGHIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 02:08:41 -0500
Date: Mon, 7 Dec 2009 08:07:08 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: adx_wdt.c: use resource_size()
Message-ID: <20091207070708.GA8919@avionic-design.de>
References: <BD79186B4FD85F4B8E60E381CAEE190901FB06C8@mi8nycmail19.Mi8.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190901FB06C8@mi8nycmail19.Mi8.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Provags-ID: V01U2FsdGVkX19PsWW7WMkAcqyP0PKwfML5GflZENu6Fiyf3vQ
 aOGj1RJqa8ze/94Gd2qSaXoHB7bO4gg6Yq1PpcOHqOagyRmGex
 R2amXDMY6ekLY83VgKoiQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H Hartley Sweeten wrote:
> Use resource_size().
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Thierry Reding <thierry.reding@avionic-design.de>
> 
> ---
> 
> diff --git a/drivers/watchdog/adx_wdt.c b/drivers/watchdog/adx_wdt.c
> index 77afb0a..ee95758 100644
> --- a/drivers/watchdog/adx_wdt.c
> +++ b/drivers/watchdog/adx_wdt.c
> @@ -242,14 +242,14 @@ static int __devinit adx_wdt_probe(struct platform_device *pdev)
>  	}
>  
>  	res = devm_request_mem_region(&pdev->dev, res->start,
> -			res->end - res->start + 1, res->name);
> +			resource_size(res), res->name);
>  	if (!res) {
>  		dev_err(&pdev->dev, "cannot request I/O memory region\n");
>  		return -ENXIO;
>  	}
>  
>  	wdt->base = devm_ioremap_nocache(&pdev->dev, res->start,
> -			res->end - res->start + 1);
> +			resource_size(res));
>  	if (!wdt->base) {
>  		dev_err(&pdev->dev, "cannot remap I/O memory region\n");
>  		return -ENXIO; 

Acked-by: Thierry Reding <thierry.reding@avionic-design.de>

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758036AbYD2GAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036AbYD2GAO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 02:00:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754197AbYD2F7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 01:59:55 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:53404 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753985AbYD2F7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 01:59:53 -0400
Message-ID: <4816B950.6000606@garzik.org>
Date: Tue, 29 Apr 2008 01:59:44 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Roel Kluin <12o3l@tiscali.nl>
CC: rmk@arm.linux.org.uk, Linux-arm <linux-arm-kernel@lists.arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: am79c961a: platform_get_irq() may return signed
 unnoticed
References: <480FADA3.7030708@tiscali.nl>
In-Reply-To: <480FADA3.7030708@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin wrote:
> dev->irq is unsigned, platform_get_irq() may return signed unnoticed
> 
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ---
> diff --git a/drivers/net/arm/am79c961a.c b/drivers/net/arm/am79c961a.c
> index ba6bd03..a637910 100644
> --- a/drivers/net/arm/am79c961a.c
> +++ b/drivers/net/arm/am79c961a.c
> @@ -693,11 +693,15 @@ static int __init am79c961_probe(struct platform_device *pdev)
>  	 * done by the ether bootp loader.
>  	 */
>  	dev->base_addr = res->start;
> -	dev->irq = platform_get_irq(pdev, 0);
> +	ret = platform_get_irq(pdev, 0);
>  
> -	ret = -ENODEV;
> -	if (dev->irq < 0)
> +	if (ret < 0) {
> +		ret = -ENODEV;
>  		goto nodev;
> +	}
> +	dev->irq = ret;
> +
> +	ret = -ENODEV;
>  	if (!request_region(dev->base_addr, 0x18, dev->name))
>  		goto nodev;

applied



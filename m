Return-Path: <linux-kernel-owner+w=401wt.eu-S932255AbZHCPJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255AbZHCPJz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 11:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755054AbZHCPJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 11:09:54 -0400
Received: from relay.atmel.no ([80.232.32.139]:61383 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755025AbZHCPJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 11:09:54 -0400
Date: Mon, 3 Aug 2009 17:09:47 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: nicolas.ferre@atmel.com, linux@maxim.org.za, linux-kernel@vger.kernel.org,
       Albin Tonnerre <albin.tonnerre@free-electrons.com>
Subject: Re: [PATCH] Switch atmel_serial to dev_pm_ops
Message-ID: <20090803170947.2f199b93@hskinnemoen-d830>
In-Reply-To: <1249310347-22291-1-git-send-email-albin.tonnerre@free-electrons.com>
References: <1249310347-22291-1-git-send-email-albin.tonnerre@free-electrons.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Albin Tonnerre wrote:
> +static struct dev_pm_ops atmel_serial_pm_ops = {
> +	.suspend = atmel_serial_suspend,
> +	.resume = atmel_serial_resume,
> +};
>  #else
> -#define atmel_serial_suspend NULL
> -#define atmel_serial_resume NULL
> +static struct dev_pm_ops atmel_serial_pm_ops;

Why not

#define atmel_serial_pm_ops	NULL

>  #endif
>  
>  static int __devinit atmel_serial_probe(struct platform_device *pdev)
> @@ -1603,11 +1607,10 @@ static int __devexit atmel_serial_remove(struct platform_device *pdev)
>  static struct platform_driver atmel_serial_driver = {
>  	.probe		= atmel_serial_probe,
>  	.remove		= __devexit_p(atmel_serial_remove),
> -	.suspend	= atmel_serial_suspend,
> -	.resume		= atmel_serial_resume,
>  	.driver		= {
>  		.name	= "atmel_usart",
>  		.owner	= THIS_MODULE,
> +		.pm = &atmel_serial_pm_ops,

Please use a TAB instead of space to make everything nice and
consistent.

Other than that,

Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

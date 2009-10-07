Return-Path: <linux-kernel-owner+w=401wt.eu-S933923AbZJGNU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933923AbZJGNU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 09:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933653AbZJGNUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 09:20:55 -0400
Received: from mail.atmel.fr ([81.80.104.162]:61396 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933459AbZJGNUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 09:20:55 -0400
Message-ID: <4ACC94B4.1050600@atmel.com>
Date: Wed, 07 Oct 2009 15:16:36 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
CC: Andrew Victor <avictor.za@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] atmel_serial: Fix bad BUILD_BUG_ON() usage
References: <1254845207-7608-1-git-send-email-haavard.skinnemoen@atmel.com>
In-Reply-To: <1254845207-7608-1-git-send-email-haavard.skinnemoen@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Haavard Skinnemoen :
> is_power_of_2() appears not to be constant enough for BUILD_BUG_ON()
> after the latest rework, so replace it with an open-coded test.
> 
> Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>  drivers/serial/atmel_serial.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
> index 3551c5c..9d948bc 100644
> --- a/drivers/serial/atmel_serial.c
> +++ b/drivers/serial/atmel_serial.c
> @@ -1531,7 +1531,7 @@ static int __devinit atmel_serial_probe(struct platform_device *pdev)
>  	void *data;
>  	int ret;
>  
> -	BUILD_BUG_ON(!is_power_of_2(ATMEL_SERIAL_RINGSIZE));
> +	BUILD_BUG_ON(ATMEL_SERIAL_RINGSIZE & (ATMEL_SERIAL_RINGSIZE - 1));
>  
>  	port = &atmel_ports[pdev->id];
>  	port->backup_imr = 0;


-- 
Nicolas Ferre


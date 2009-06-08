Return-Path: <linux-kernel-owner+w=401wt.eu-S1756372AbZFHOOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372AbZFHOOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 10:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754829AbZFHOOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 10:14:06 -0400
Received: from trinity.fluff.org ([89.16.178.74]:37382 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754518AbZFHOOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 10:14:05 -0400
Date: Mon, 8 Jun 2009 15:13:54 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Peter Korsgaard <jacmet@sunsite.dk>
Cc: ben-linux@fluff.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       wookey@wookware.org
Subject: Re: [PATCH] serial: samsung.c: mark s3c24xx_serial_remove as __devexit
Message-ID: <20090608141354.GB8320@trinity.fluff.org>
References: <1244380035-23717-1-git-send-email-jacmet@sunsite.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244380035-23717-1-git-send-email-jacmet@sunsite.dk>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 07, 2009 at 03:07:15PM +0200, Peter Korsgaard wrote:
> Mark the remove function as __devexit so it gets eliminated in
> CONFIG_HOTPLUG=n builds. Saves ~100 bytes.
> 
> Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
Acked-by: Ben Dooks <ben-linux@fluff.org>
> ---
>  drivers/serial/s3c2400.c |    2 +-
>  drivers/serial/s3c2410.c |    2 +-
>  drivers/serial/s3c2412.c |    2 +-
>  drivers/serial/s3c2440.c |    2 +-
>  drivers/serial/s3c24a0.c |    2 +-
>  drivers/serial/s3c6400.c |    2 +-
>  drivers/serial/samsung.c |    2 +-
>  drivers/serial/samsung.h |    2 +-
>  8 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/serial/s3c2400.c b/drivers/serial/s3c2400.c
> index 4873f29..fb00ed5 100644
> --- a/drivers/serial/s3c2400.c
> +++ b/drivers/serial/s3c2400.c
> @@ -78,7 +78,7 @@ static int s3c2400_serial_probe(struct platform_device *dev)
>  
>  static struct platform_driver s3c2400_serial_drv = {
>  	.probe		= s3c2400_serial_probe,
> -	.remove		= s3c24xx_serial_remove,
> +	.remove		= __devexit_p(s3c24xx_serial_remove),
>  	.driver		= {
>  		.name	= "s3c2400-uart",
>  		.owner	= THIS_MODULE,
> diff --git a/drivers/serial/s3c2410.c b/drivers/serial/s3c2410.c
> index 87c182e..b5d7cbc 100644
> --- a/drivers/serial/s3c2410.c
> +++ b/drivers/serial/s3c2410.c
> @@ -90,7 +90,7 @@ static int s3c2410_serial_probe(struct platform_device *dev)
>  
>  static struct platform_driver s3c2410_serial_drv = {
>  	.probe		= s3c2410_serial_probe,
> -	.remove		= s3c24xx_serial_remove,
> +	.remove		= __devexit_p(s3c24xx_serial_remove),
>  	.driver		= {
>  		.name	= "s3c2410-uart",
>  		.owner	= THIS_MODULE,
> diff --git a/drivers/serial/s3c2412.c b/drivers/serial/s3c2412.c
> index fd017b3..11dcb90 100644
> --- a/drivers/serial/s3c2412.c
> +++ b/drivers/serial/s3c2412.c
> @@ -123,7 +123,7 @@ static int s3c2412_serial_probe(struct platform_device *dev)
>  
>  static struct platform_driver s3c2412_serial_drv = {
>  	.probe		= s3c2412_serial_probe,
> -	.remove		= s3c24xx_serial_remove,
> +	.remove		= __devexit_p(s3c24xx_serial_remove),
>  	.driver		= {
>  		.name	= "s3c2412-uart",
>  		.owner	= THIS_MODULE,
> diff --git a/drivers/serial/s3c2440.c b/drivers/serial/s3c2440.c
> index 29cbb0a..06c5b0c 100644
> --- a/drivers/serial/s3c2440.c
> +++ b/drivers/serial/s3c2440.c
> @@ -153,7 +153,7 @@ static int s3c2440_serial_probe(struct platform_device *dev)
>  
>  static struct platform_driver s3c2440_serial_drv = {
>  	.probe		= s3c2440_serial_probe,
> -	.remove		= s3c24xx_serial_remove,
> +	.remove		= __devexit_p(s3c24xx_serial_remove),
>  	.driver		= {
>  		.name	= "s3c2440-uart",
>  		.owner	= THIS_MODULE,
> diff --git a/drivers/serial/s3c24a0.c b/drivers/serial/s3c24a0.c
> index ebf2fd3..786a067 100644
> --- a/drivers/serial/s3c24a0.c
> +++ b/drivers/serial/s3c24a0.c
> @@ -94,7 +94,7 @@ static int s3c24a0_serial_probe(struct platform_device *dev)
>  
>  static struct platform_driver s3c24a0_serial_drv = {
>  	.probe		= s3c24a0_serial_probe,
> -	.remove		= s3c24xx_serial_remove,
> +	.remove		= __devexit_p(s3c24xx_serial_remove),
>  	.driver		= {
>  		.name	= "s3c24a0-uart",
>  		.owner	= THIS_MODULE,
> diff --git a/drivers/serial/s3c6400.c b/drivers/serial/s3c6400.c
> index 3e37852..48f1a37 100644
> --- a/drivers/serial/s3c6400.c
> +++ b/drivers/serial/s3c6400.c
> @@ -124,7 +124,7 @@ static int s3c6400_serial_probe(struct platform_device *dev)
>  
>  static struct platform_driver s3c6400_serial_drv = {
>  	.probe		= s3c6400_serial_probe,
> -	.remove		= s3c24xx_serial_remove,
> +	.remove		= __devexit_p(s3c24xx_serial_remove),
>  	.driver		= {
>  		.name	= "s3c6400-uart",
>  		.owner	= THIS_MODULE,
> diff --git a/drivers/serial/samsung.c b/drivers/serial/samsung.c
> index 93b5d75..c8851a0 100644
> --- a/drivers/serial/samsung.c
> +++ b/drivers/serial/samsung.c
> @@ -1174,7 +1174,7 @@ int s3c24xx_serial_probe(struct platform_device *dev,
>  
>  EXPORT_SYMBOL_GPL(s3c24xx_serial_probe);
>  
> -int s3c24xx_serial_remove(struct platform_device *dev)
> +int __devexit s3c24xx_serial_remove(struct platform_device *dev)
>  {
>  	struct uart_port *port = s3c24xx_dev_to_port(&dev->dev);
>  
> diff --git a/drivers/serial/samsung.h b/drivers/serial/samsung.h
> index 7afb948..d3fe315 100644
> --- a/drivers/serial/samsung.h
> +++ b/drivers/serial/samsung.h
> @@ -72,7 +72,7 @@ struct s3c24xx_uart_port {
>  extern int s3c24xx_serial_probe(struct platform_device *dev,
>  				struct s3c24xx_uart_info *uart);
>  
> -extern int s3c24xx_serial_remove(struct platform_device *dev);
> +extern int __devexit s3c24xx_serial_remove(struct platform_device *dev);
>  
>  extern int s3c24xx_serial_initconsole(struct platform_driver *drv,
>  				      struct s3c24xx_uart_info *uart);
> -- 
> 1.6.2
> 
> 
> -------------------------------------------------------------------
> List admin: http://lists.arm.linux.org.uk/mailman/listinfo/linux-arm-kernel
> FAQ:        http://www.arm.linux.org.uk/mailinglists/faq.php
> Etiquette:  http://www.arm.linux.org.uk/mailinglists/etiquette.php

-- 
-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1758038AbYCKVMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038AbYCKVMN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 17:12:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754048AbYCKVLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 17:11:43 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:34255 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753024AbYCKVLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 17:11:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=Pv5k9ZY9jZXxrpd9nvLwZz0TyoynJxgb8ruDwtFYED0AxCdAvUDjuFfOyaaegvevsjat3gjJQV7DnHgMMbh66oMLKJoUfYcZtUrNofTUkDDgpMQhWhUgU8q/z51UN048p9Jxx6zUutvIWFPzOyJ8+clkgZl+b685eFhlNVUPlKM=  ;
X-YMail-OSG: MPz10NoVM1nqvjba0xMLIluvIcAHcOKBDxSZ3EAntODt9Yuh9rKAxozC2Skg1navCHIm1WelKA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [PATCH 3/3] gpiolib: add __must_check attribute to the gpiochip_add function
Date: Tue, 11 Mar 2008 13:02:38 -0800
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20080311174129.GC12397@localhost.localdomain>
In-Reply-To: <20080311174129.GC12397@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803111402.38671.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 March 2008, Anton Vorontsov wrote:
> 
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>

I'm curious why you want to change this.   When it fails, a
KERN_ERR message is emitted ... if you're going to insist
that callers handle this -- e.g. platform setup code might
use a "WARN_ON(gpiochip_add(...) < 0)" -- why not take out
that KERN_ERR mechanism too?

NAK unless it comes with a patch to update all callers to do
that checking, so that this isn't just "add build warnings".
But I'm not sure I like these attributes in cases like this.

- Dave



> ---
>  drivers/gpio/gpiolib.c     |    2 +-
>  include/asm-generic/gpio.h |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 2149e0c..851eb4d 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -161,7 +161,7 @@ static int gpiochip_find_base(int ngpio)
>   * because the chip->base is invalid or already associated with a
>   * different chip.  Otherwise it returns zero as a success code.
>   */
> -int gpiochip_add(struct gpio_chip *chip)
> +int __must_check gpiochip_add(struct gpio_chip *chip)
>  {
>  	unsigned long	flags;
>  	int		status = 0;
> diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
> index 20f5d67..51ed230 100644
> --- a/include/asm-generic/gpio.h
> +++ b/include/asm-generic/gpio.h
> @@ -77,7 +77,7 @@ extern const char *gpiochip_is_requested(struct gpio_chip *chip,
>  extern int __must_check gpiochip_reserve(int start, int ngpio);
>  
>  /* add/remove chips */
> -extern int gpiochip_add(struct gpio_chip *chip);
> +extern int __must_check gpiochip_add(struct gpio_chip *chip);
>  extern int __must_check gpiochip_remove(struct gpio_chip *chip);
>  
>  
> -- 
> 1.5.2.2
> 



Return-Path: <linux-kernel-owner+w=401wt.eu-S1765070AbYETS1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765070AbYETS1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 14:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761776AbYETS11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 14:27:27 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:40124 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757533AbYETS10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 14:27:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=rOqAbHfCSXs6imzZyQGUHvl3x7849xCfrG2Km0EBwLtqHSV3UlxKmUaZ3aqApHKnScRR1IdZxloOKmZvLD5PPN3MhAwQJF3A3x5Cdcpqlcj+IKsm3R/2XsEGr2mn5UmT5ONoszbdsAHXQa+Pabrs6/3dMLej++Ryw9rAGhpjTHQ=  ;
X-YMail-OSG: mJpWvDYVM1lm.4JwBzjgoSqzOrRQJJR3W8r3iCKxcaC6PndkkL50kQBmjmushK7Jc5XgmMhmj7xZ8Q13XUB64Ea74jW8SnSUa_TQ7Bqu48mMrrqCw8N450OrcNHFUxk6h4LWUdtSLTc6KOlWLU0nQaPOD19HDqKCSxz19iI3oU.pau2IzII-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: [PATCH] gpiolib: Fix off by one errors
Date: Tue, 20 May 2008 11:23:59 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <1211306284-22469-1-git-send-email-xyzzy@speakeasy.org>
In-Reply-To: <1211306284-22469-1-git-send-email-xyzzy@speakeasy.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805201124.00092.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 May 2008, Trent Piepho wrote:
> The last gpio belonging to a chip is chip->base + chip->ngpios - 1.  Some
> places in the code, but not all, forgot the critical minus one.
> 
> Signed-off-by: Trent Piepho <xyzzy@speakeasy.org>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>

... should make it into 2.6.26-final, but this is evidently
not critical at this point or we'd have had complaints already!


> ---
>  drivers/gpio/gpiolib.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 7f138c6..beaf6b3 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -127,7 +127,7 @@ int __init gpiochip_reserve(int start, int ngpio)
>  	unsigned long flags;
>  	int i;
>  
> -	if (!gpio_is_valid(start) || !gpio_is_valid(start + ngpio))
> +	if (!gpio_is_valid(start) || !gpio_is_valid(start + ngpio - 1))
>  		return -EINVAL;
>  
>  	spin_lock_irqsave(&gpio_lock, flags);
> @@ -170,7 +170,7 @@ int gpiochip_add(struct gpio_chip *chip)
>  	unsigned	id;
>  	int		base = chip->base;
>  
> -	if ((!gpio_is_valid(base) || !gpio_is_valid(base + chip->ngpio))
> +	if ((!gpio_is_valid(base) || !gpio_is_valid(base + chip->ngpio - 1))
>  			&& base >= 0) {
>  		status = -EINVAL;
>  		goto fail;
> @@ -207,7 +207,7 @@ fail:
>  	/* failures here can mean systems won't boot... */
>  	if (status)
>  		pr_err("gpiochip_add: gpios %d..%d (%s) not registered\n",
> -			chip->base, chip->base + chip->ngpio,
> +			chip->base, chip->base + chip->ngpio - 1,
>  			chip->label ? : "generic");
>  	return status;
>  }
> -- 
> 1.5.4.1
> 



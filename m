Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbZBPUAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbZBPUAZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 15:00:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbZBPUAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 15:00:09 -0500
Received: from n6b.bullet.sp1.yahoo.com ([69.147.64.163]:31637 "HELO
	n6b.bullet.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751018AbZBPUAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 15:00:08 -0500
X-yahoo-newman-spamcop: yes
X-Yahoo-Newman-Id: 176541.90152.bm@omp424.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=GLjlwBKWjXqgpU9MXA3UtQmro7v6H7OujVfa9iQtITKoDGcP+66KOR5hV7+TJdT03POWBEJheHkrfebgeJWEhjTvTPytB6Jb16eJgE07dsLpWkkfa7AoszN0WJoKwIpmn0VYQMHXq54CGPrnl+tZHnIBfUcWNff+8LBvRu0rkaQ=  ;
X-YMail-OSG: AI7Q2HoVM1n0VmyPwx7JoC4vAK0VwrSKiItNgBDWQsMwamJVso1OEopC0ReuaB9RUf9aQMa0koXR6LJiV3GNDRwHMjSmjcBRKGb5r4NAIZ_N._u9U4jVad8CFdlHJZ6euJDaHaPsHQdpsl6jb9215mmERTPshtolyrKa.dRXa9_GgTf7ndp1nv9Hi3W2VijtNXvjal6ahlGI8AZHOKBoTr2m1GFJdg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] spi-gpio: Sanitize MISO bitvalue
Date: Mon, 16 Feb 2009 11:58:48 -0800
User-Agent: KMail/1.9.10
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       openwrt-devel@lists.openwrt.org
References: <200902151630.41426.mb@bu3sch.de>
In-Reply-To: <200902151630.41426.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902161158.48890.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 February 2009, Michael Buesch wrote:
> gpio_get_value() returns 0 or nonzero, but getmiso() expects 0 or 1.
> Sanitize the value to a 0/1 boolean.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>


> ---
> 
> Well, we could also change the bitbang helpers in linux/spi/spi_bitbang.h

That would be the main alternate fix to consider, and
it's worth updating the docs there to specify that getmiso()
needs to return 0/1 ... 

> or change the way the gpio_get_value API is defined,

Not an option.  The more instructions thrown in these
inner loops, the harder it is to get even inlined code to
clock over 1 MHz.


> but I personally think 
> this patch is pretty good as is.
> In any case, it fixes a real bug on platforms like the bcm47xx which
> return 0 or nonzero for gpio_get_value.
> 
> Index: linux-2.6/drivers/spi/spi_gpio.c
> ===================================================================
> --- linux-2.6.orig/drivers/spi/spi_gpio.c	2009-02-14 21:37:14.000000000 +0100
> +++ linux-2.6/drivers/spi/spi_gpio.c	2009-02-15 16:27:16.000000000 +0100
> @@ -114,7 +114,7 @@ static inline void setmosi(const struct 
>  
>  static inline int getmiso(const struct spi_device *spi)
>  {
> -	return gpio_get_value(SPI_MISO_GPIO);
> +	return !!gpio_get_value(SPI_MISO_GPIO);
>  }
>  
>  #undef pdata
> 
> -- 
> Greetings, Michael.
> 
> 




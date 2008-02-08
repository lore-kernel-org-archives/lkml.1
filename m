Return-Path: <linux-kernel-owner+w=401wt.eu-S1759691AbYBHXny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759691AbYBHXny (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 18:43:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754587AbYBHXnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 18:43:46 -0500
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:26779 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753503AbYBHXnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 18:43:45 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=i/zjnSqipot0e9pCwW/RJYXApBWB6ND9ilriPHoMqXV0ngdZiK/sUOgTuZc2i7/N5znTl+ifOP7OtPJdGNuxNUFjnsLTl88Df+GvPOTkYFGDNsWVvMgV5ipzzoastilYxCr9cu3d7BCxtrmZ6ycbhjZ9UIOrOi1BKhYgclx3vD8=  ;
X-YMail-OSG: eLOF_dAVM1l1voanDoI8KXHRN.qe1cBjo00Ey_zM2M6P6GxKTFlrIz9vrwMCpcJzil7x4gv_WQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Subject: Re: [PATCH] Define a NO_GPIO macro to compare against and to use as an invalid GPIO
Date: Fri, 8 Feb 2008 15:43:42 -0800
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, i2c@lm-sensors.org
References: <Pine.LNX.4.64.0801311624370.8478@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0801311624370.8478@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802081543.42467.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 January 2008, Guennadi Liakhovetski wrote:
> As discussed on i2c mailing list with David Brownell, and number
> outside of the 0...MAX_INT range is invalid as a GPIO number.
> Define a macro, similar to NO_IRQ, to be used as a deliberate
> invalid GPIO, rather than defining a is_valid_gpio() macro.

Actually I thought that what you needed was an is_valid_gpio();
your motivation was that you needed a predicate.

The problem I have with a #define for a single such invalid GPIO
number is that people will inevitably start to assume it's the
only such number.  In particular "if (gpio == NO_GPIO) ..."
is by definition incorrect.

So I'd really rather see a predicate like is_valid_gpio().

If you want to designate one value for use as an initializer,
then I'd rather see a simple

	#define NO_GPIO	(-EINVAL)

without any option for arch-specific overrides ... along with a
comment that this is only *one* of the numerous values which
will fail is_valid_gpio().

- Dave



> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
> 
> ---
> 
> As gpiolib doesn't seem to have an own mailing list, sending it directly 
> to LKML.
> 
>  include/asm-generic/gpio.h |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
> index f29a502..806b86c 100644
> --- a/include/asm-generic/gpio.h
> +++ b/include/asm-generic/gpio.h
> @@ -16,6 +16,10 @@
>  #define ARCH_NR_GPIOS		256
>  #endif
>  
> +#ifndef NO_GPIO
> +#define NO_GPIO			((unsigned int)-1)
> +#endif
> +
>  struct seq_file;
>  
>  /**
> -- 
> 1.5.3.4
> 



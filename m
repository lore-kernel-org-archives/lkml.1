Return-Path: <linux-kernel-owner+w=401wt.eu-S1760106AbZE0F5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760106AbZE0F5r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 01:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758137AbZE0F5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 01:57:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47131 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756526AbZE0F5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 01:57:35 -0400
Date: Tue, 26 May 2009 22:57:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: ben-linux@fluff.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] S3C: beyond ARRAY_SIZE of s3c_gpios
Message-Id: <20090526225720.a1f47b4e.akpm@linux-foundation.org>
In-Reply-To: <4A1426EB.5080506@gmail.com>
References: <4A1426EB.5080506@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 May 2009 17:51:07 +0200 Roel Kluin <roel.kluin@gmail.com> wrote:

> Do not go beyond ARRAY_SIZE of s3c_gpios
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/arch/arm/plat-s3c/gpio.c b/arch/arm/plat-s3c/gpio.c
> index d71dd6d..29926c1 100644
> --- a/arch/arm/plat-s3c/gpio.c
> +++ b/arch/arm/plat-s3c/gpio.c
> @@ -28,7 +28,7 @@ static __init void s3c_gpiolib_track(struct s3c_gpio_chip *chip)
>  
>  	gpn = chip->chip.base;
>  	for (i = 0; i < chip->chip.ngpio; i++, gpn++) {
> -		BUG_ON(gpn > ARRAY_SIZE(s3c_gpios));
> +		BUG_ON(gpn >= ARRAY_SIZE(s3c_gpios));
>  		s3c_gpios[gpn] = chip;
>  	}
>  }

umm, OK, but the title and changelog are quite inaccurate.

I rewrote the title to

	s3c: fix check of index into s3c_gpios[]

and rewrote the changelog to

	The check of the s3c_gpios[] index had an off-by-one.


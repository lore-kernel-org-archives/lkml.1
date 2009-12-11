Return-Path: <linux-kernel-owner+w=401wt.eu-S933351AbZLKBep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933351AbZLKBep (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 20:34:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933337AbZLKBem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 20:34:42 -0500
Received: from waste.org ([173.11.57.241]:37069 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933333AbZLKBej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 20:34:39 -0500
Subject: Re: [PATCH] timeriomem-rng.c: use resource_size()
From: Matt Mackall <mpm@selenic.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Alexander Clouter <alex@digriz.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190901FB0FBA@mi8nycmail19.Mi8.com>
References: <BD79186B4FD85F4B8E60E381CAEE190901FB0FBA@mi8nycmail19.Mi8.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Dec 2009 19:34:43 -0600
Message-ID: <1260495283.24459.1225.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-10 at 20:16 -0500, H Hartley Sweeten wrote:
> Use resource_size() for ioremap.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Alexander Clouter <alex@digriz.org.uk>

(Generally speaking, it's best to cc: obscure stuff to a maintainer.)

Looks good to me. Herbert?

Signed-off-by: Matt Mackall <mpm@selenic.com>

> ---
> 
> diff --git a/drivers/char/hw_random/timeriomem-rng.c b/drivers/char/hw_random/timeriomem-rng.c
> index a94e930..a8428e6 100644
> --- a/drivers/char/hw_random/timeriomem-rng.c
> +++ b/drivers/char/hw_random/timeriomem-rng.c
> @@ -100,8 +100,7 @@ static int __devinit timeriomem_rng_probe(struct platform_device *pdev)
>  
>  	timeriomem_rng_data = pdev->dev.platform_data;
>  
> -	timeriomem_rng_data->address = ioremap(res->start,
> -						res->end - res->start + 1);
> +	timeriomem_rng_data->address = ioremap(res->start, resource_size(res));
>  	if (!timeriomem_rng_data->address)
>  		return -EIO;
>   
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
http://selenic.com : development and support for Mercurial and Linux



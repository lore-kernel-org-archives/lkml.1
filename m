Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857Ab0BDEGj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 23:06:39 -0500
Received: from mail-yw0-f189.google.com ([209.85.211.189]:64058 "EHLO
	mail-yw0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756407Ab0BDEGi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 23:06:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=O/WjSb1zKn3QzaL0yVwpiW5rsFO8VcOAISP/U+EPlNf8umdZA4CnBSolhkAoAYMYet
         kgeFVUbeHTlcHCR8dYgctJw8jrjTxDq/AGbuljaNziwDcmEYW80j/S4+GMYogemGU9pU
         46UUWn4bW87hjahA9OoHfTDkLnc2xx4d3PD1I=
MIME-Version: 1.0
In-Reply-To: <1265253206-17744-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1265253206-17744-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <1265253206-17744-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Date: Wed, 3 Feb 2010 23:06:37 -0500
Message-ID: <b4198de61002032006t3703baceh9fc9d9f8bd8cc16d@mail.gmail.com>
Subject: Re: [PATCH -mm 3/4] alpha: remove dma_sync_single_range
From: Matt Turner <mattst88@gmail.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 3, 2010 at 10:13 PM, FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp> wrote:
> dma_sync_single_for_cpu/for_device supports a partial sync so there is
> no point to have dma_sync_single_range (also dma_sync_single was
> obsoleted long ago, replaced with dma_sync_single_for_cpu/for_device).
>
> There is no user of dma_sync_single_range() in mainline and only Alpha
> architecture supports dma_sync_single_range(). So it's unlikely that
> someone out of the tree uses it.
>
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Richard Henderson <rth@twiddle.net>
> Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
> Cc: Matt Turner <mattst88@gmail.com>
> ---
>  arch/alpha/include/asm/dma-mapping.h |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/arch/alpha/include/asm/dma-mapping.h b/arch/alpha/include/asm/dma-mapping.h
> index 04eb568..f514ede 100644
> --- a/arch/alpha/include/asm/dma-mapping.h
> +++ b/arch/alpha/include/asm/dma-mapping.h
> @@ -59,7 +59,6 @@ int dma_set_mask(struct device *dev, u64 mask);
>
>  #define dma_sync_single_for_cpu(dev, addr, size, dir)    ((void)0)
>  #define dma_sync_single_for_device(dev, addr, size, dir)  ((void)0)
> -#define dma_sync_single_range(dev, addr, off, size, dir)  ((void)0)
>  #define dma_sync_sg_for_cpu(dev, sg, nents, dir)         ((void)0)
>  #define dma_sync_sg_for_device(dev, sg, nents, dir)      ((void)0)
>  #define dma_cache_sync(dev, va, size, dir)               ((void)0)
> --
> 1.5.6.5

Acked-by: Matt Turner <mattst88@gmail.com>

Should I vacuum this one up, or should it go in the -mm tree? I don't
guess there's much point in sending Linus pull requests for single
patches.

Matt

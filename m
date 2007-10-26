Return-Path: <linux-kernel-owner+w=401wt.eu-S1763047AbXJZD0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763047AbXJZD0x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 23:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758965AbXJZD0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 23:26:45 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:34865 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758778AbXJZD0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 23:26:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WCvTrfji1T81y7QteYIBPmeN7d1cIMk07+fQZpG75pUEh6zkp2zqMsBZ/bMNymMqox/adTRVxw5z9kAMAtYdqc7YpwvodbDjj9QIPCSJl8SnUIVzksl0rQ0Mf3PLJF9ptJqOSFgvM9wNTty6SR40zvgDqpBjTvDwhCqKrk84kWc=
Message-ID: <386072610710252026y6ae38e78i81d35f25ca15ff55@mail.gmail.com>
Date: Fri, 26 Oct 2007 11:26:43 +0800
From: "Bryan Wu" <cooloney.lkml@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [2.6 patch] remove mm_{ptov,vtop}()
Cc: bryan.wu@analog.com, ysato@users.sourceforge.jp, gerg@uclinux.org,
       "Miles Bader" <miles@gnu.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20071024162629.GK30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071024162629.GK30533@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/07, Adrian Bunk <bunk@kernel.org> wrote:
> This patch removes the unused mm_{ptov,vtop}().
>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
>
> ---
>
>  include/asm-blackfin/io.h       |    2 --

Acked-by: Bryan Wu <bryan.wu@analog.com>

Thanks a lot

>  include/asm-h8300/io.h          |    2 --
>  include/asm-h8300/virtconvert.h |    2 --
>  include/asm-m68knommu/io.h      |    2 --
>  include/asm-v850/io.h           |    2 --
>  5 files changed, 10 deletions(-)
>
> c2472eb3a1eaaa4211863e6091817b4078b6a53e
> diff --git a/include/asm-blackfin/io.h b/include/asm-blackfin/io.h
> index d1d2e6b..f3d8126 100644
> --- a/include/asm-blackfin/io.h
> +++ b/include/asm-blackfin/io.h
> @@ -187,8 +187,6 @@ extern void blkfin_inv_cache_all(void);
>  #define page_to_phys(page)      ((page - mem_map) << PAGE_SHIFT)
>  #define page_to_bus(page)       ((page - mem_map) << PAGE_SHIFT)
>
> -#define mm_ptov(vaddr)         ((void *) (vaddr))
> -#define mm_vtop(vaddr)         ((unsigned long) (vaddr))
>  #define phys_to_virt(vaddr)    ((void *) (vaddr))
>  #define virt_to_phys(vaddr)    ((unsigned long) (vaddr))
>
> diff --git a/include/asm-h8300/io.h b/include/asm-h8300/io.h
> index 7543a57..26dc6cc 100644
> --- a/include/asm-h8300/io.h
> +++ b/include/asm-h8300/io.h
> @@ -302,8 +302,6 @@ static __inline__ void ctrl_outl(unsigned long b, unsigned long addr)
>  /*
>   * Macros used for converting between virtual and physical mappings.
>   */
> -#define mm_ptov(vaddr)         ((void *) (vaddr))
> -#define mm_vtop(vaddr)         ((unsigned long) (vaddr))
>  #define phys_to_virt(vaddr)    ((void *) (vaddr))
>  #define virt_to_phys(vaddr)    ((unsigned long) (vaddr))
>
> diff --git a/include/asm-h8300/virtconvert.h b/include/asm-h8300/virtconvert.h
> index ee7d5ea..19cfd62 100644
> --- a/include/asm-h8300/virtconvert.h
> +++ b/include/asm-h8300/virtconvert.h
> @@ -10,8 +10,6 @@
>  #include <asm/setup.h>
>  #include <asm/page.h>
>
> -#define mm_ptov(vaddr)         ((void *) (vaddr))
> -#define mm_vtop(vaddr)         ((unsigned long) (vaddr))
>  #define phys_to_virt(vaddr)    ((void *) (vaddr))
>  #define virt_to_phys(vaddr)    ((unsigned long) (vaddr))
>
> diff --git a/include/asm-m68knommu/io.h b/include/asm-m68knommu/io.h
> index 653d9b2..6adef1e 100644
> --- a/include/asm-m68knommu/io.h
> +++ b/include/asm-m68knommu/io.h
> @@ -172,8 +172,6 @@ extern void iounmap(void *addr);
>  /*
>   * Macros used for converting between virtual and physical mappings.
>   */
> -#define mm_ptov(vaddr)         ((void *) (vaddr))
> -#define mm_vtop(vaddr)         ((unsigned long) (vaddr))
>  #define phys_to_virt(vaddr)    ((void *) (vaddr))
>  #define virt_to_phys(vaddr)    ((unsigned long) (vaddr))
>
> diff --git a/include/asm-v850/io.h b/include/asm-v850/io.h
> index cc364fc..cdad251 100644
> --- a/include/asm-v850/io.h
> +++ b/include/asm-v850/io.h
> @@ -122,8 +122,6 @@ outsl (unsigned long port, const void *src, unsigned long count)
>  #endif
>
>  /* Conversion between virtual and physical mappings.  */
> -#define mm_ptov(addr)          ((void *)__phys_to_virt (addr))
> -#define mm_vtop(addr)          ((unsigned long)__virt_to_phys (addr))
>  #define phys_to_virt(addr)     ((void *)__phys_to_virt (addr))
>  #define virt_to_phys(addr)     ((unsigned long)__virt_to_phys (addr))
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755329AbZIRCcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329AbZIRCcy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 22:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753787AbZIRCcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 22:32:53 -0400
Received: from mail-qy0-f173.google.com ([209.85.221.173]:51023 "EHLO
	mail-qy0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600AbZIRCcw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 22:32:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EU/vduZO6gf6T4IFIKZD8+Ze2qETbphLBAUnCY9Yn6xP7Nf9Ey00HAO+7G1wB3ypFs
         NiHS+HRpZceG+seImxiL9s4HbR4HYPtMC5Axvaut+s+YEPxuJTrOde505aVps+zbwyQs
         JzBrg0QkNRge90qPlyZz68508ZKSA2SR3Anuw=
MIME-Version: 1.0
In-Reply-To: <20090916202512.GA511@basil.fritz.box>
References: <20090916202512.GA511@basil.fritz.box>
Date: Fri, 18 Sep 2009 10:32:56 +0800
Message-ID: <2375c9f90909171932kc73c88xdee802af6d63d7e4@mail.gmail.com>
Subject: Re: [PATCH] Rename D macro in kmap_types.h
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 4:25 AM, Andi Kleen <andi@firstfloor.org> wrote:
> Rename D macro in kmap_types.h
>
> I tend to use a 'D' debugging macro a lot during debugging.
> When I define it before includes I often get conflicts
> with kmap_types.h's use of 'D' too. It's not very nice
> when a global include pollutes the name space like this.
>
> Rename the kmap_types.h D to KMAP_D. It is only used
> temporarily in the header so has no effect on anything else.
>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>


Makes sense.

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

>
> ---
>  include/asm-generic/kmap_types.h |   47 +++++++++++++++++++--------------------
>  1 file changed, 24 insertions(+), 23 deletions(-)
>
> Index: linux-2.6.31-rc3-ak/include/asm-generic/kmap_types.h
> ===================================================================
> --- linux-2.6.31-rc3-ak.orig/include/asm-generic/kmap_types.h
> +++ linux-2.6.31-rc3-ak/include/asm-generic/kmap_types.h
> @@ -2,34 +2,35 @@
>  #define _ASM_GENERIC_KMAP_TYPES_H
>
>  #ifdef __WITH_KM_FENCE
> -# define D(n) __KM_FENCE_##n ,
> +# define KMAP_D(n) __KM_FENCE_##n ,
>  #else
> -# define D(n)
> +# define KMAP_D(n)
>  #endif
>
>  enum km_type {
> -D(0)   KM_BOUNCE_READ,
> -D(1)   KM_SKB_SUNRPC_DATA,
> -D(2)   KM_SKB_DATA_SOFTIRQ,
> -D(3)   KM_USER0,
> -D(4)   KM_USER1,
> -D(5)   KM_BIO_SRC_IRQ,
> -D(6)   KM_BIO_DST_IRQ,
> -D(7)   KM_PTE0,
> -D(8)   KM_PTE1,
> -D(9)   KM_IRQ0,
> -D(10)  KM_IRQ1,
> -D(11)  KM_SOFTIRQ0,
> -D(12)  KM_SOFTIRQ1,
> -D(13)  KM_SYNC_ICACHE,
> -D(14)  KM_SYNC_DCACHE,
> -D(15)  KM_UML_USERCOPY, /* UML specific, for copy_*_user - used in do_op_one_page */
> -D(16)  KM_IRQ_PTE,
> -D(17)  KM_NMI,
> -D(18)  KM_NMI_PTE,
> -D(19)  KM_TYPE_NR
> +KMAP_D(0)      KM_BOUNCE_READ,
> +KMAP_D(1)      KM_SKB_SUNRPC_DATA,
> +KMAP_D(2)      KM_SKB_DATA_SOFTIRQ,
> +KMAP_D(3)      KM_USER0,
> +KMAP_D(4)      KM_USER1,
> +KMAP_D(5)      KM_BIO_SRC_IRQ,
> +KMAP_D(6)      KM_BIO_DST_IRQ,
> +KMAP_D(7)      KM_PTE0,
> +KMAP_D(8)      KM_PTE1,
> +KMAP_D(9)      KM_IRQ0,
> +KMAP_D(10)     KM_IRQ1,
> +KMAP_D(11)     KM_SOFTIRQ0,
> +KMAP_D(12)     KM_SOFTIRQ1,
> +KMAP_D(13)     KM_SYNC_ICACHE,
> +KMAP_D(14)     KM_SYNC_DCACHE,
> +/* UML specific, for copy_*_user - used in do_op_one_page */
> +KMAP_D(15)     KM_UML_USERCOPY,
> +KMAP_D(16)     KM_IRQ_PTE,
> +KMAP_D(17)     KM_NMI,
> +KMAP_D(18)     KM_NMI_PTE,
> +KMAP_D(19)     KM_TYPE_NR
>  };
>
> -#undef D
> +#undef KMAP_D
>
>  #endif
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

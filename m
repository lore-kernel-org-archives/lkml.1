Return-Path: <linux-kernel-owner+w=401wt.eu-S1753132AbYKFR7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbYKFR7I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 12:59:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751166AbYKFR64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 12:58:56 -0500
Received: from atlanta.zankel.net ([69.61.78.146]:1658 "EHLO
	atlanta.zankel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbYKFR6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 12:58:55 -0500
Message-ID: <49133094.6070407@zankel.net>
Date: Thu, 06 Nov 2008 09:59:48 -0800
From: Chris Zankel <chris@zankel.net>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/10] xtensa: use the new byteorder headers
References: <1225910131.5991.230.camel@brick>
In-Reply-To: <1225910131.5991.230.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Harvey,

I have added your patch to the xtensa-next tree on kernel.org and will 
push to Linus soon.

Thanks,
-Chris

Harvey Harrison wrote:
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  include/asm-xtensa/byteorder.h |   32 +++++++++++++++-----------------
>  1 files changed, 15 insertions(+), 17 deletions(-)
> 
> diff --git a/include/asm-xtensa/byteorder.h b/include/asm-xtensa/byteorder.h
> index 765edf1..07d10ad 100644
> --- a/include/asm-xtensa/byteorder.h
> +++ b/include/asm-xtensa/byteorder.h
> @@ -14,7 +14,17 @@
>  #include <asm/types.h>
>  #include <linux/compiler.h>
>  
> -static __inline__ __attribute_const__ __u32 ___arch__swab32(__u32 x)
> +#ifdef __XTENSA_EL__
> +# define __LITTLE_ENDIAN
> +#elif defined(__XTENSA_EB__)
> +# define __BIG_ENDIAN
> +#else
> +# error processor byte order undefined!
> +#endif
> +
> +#define __SWAB_64_THRU_32__
> +
> +static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
>  {
>      __u32 res;
>      /* instruction sequence from Xtensa ISA release 2/2000 */
> @@ -28,8 +38,9 @@ static __inline__ __attribute_const__ __u32 ___arch__swab32(__u32 x)
>  	    );
>      return res;
>  }
> +#define __arch_swab32 __arch_swab32
>  
> -static __inline__ __attribute_const__ __u16 ___arch__swab16(__u16 x)
> +static inline __attribute_const__ __u16 __arch_swab16(__u16 x)
>  {
>      /* Given that 'short' values are signed (i.e., can be negative),
>       * we cannot assume that the upper 16-bits of the register are
> @@ -62,21 +73,8 @@ static __inline__ __attribute_const__ __u16 ___arch__swab16(__u16 x)
>  
>      return res;
>  }
> +#define __arch_swab16 __arch_swab16
>  
> -#define __arch__swab32(x) ___arch__swab32(x)
> -#define __arch__swab16(x) ___arch__swab16(x)
> -
> -#if !defined(__STRICT_ANSI__) || defined(__KERNEL__)
> -#  define __BYTEORDER_HAS_U64__
> -#  define __SWAB_64_THRU_32__
> -#endif
> -
> -#ifdef __XTENSA_EL__
> -# include <linux/byteorder/little_endian.h>
> -#elif defined(__XTENSA_EB__)
> -# include <linux/byteorder/big_endian.h>
> -#else
> -# error processor byte order undefined!
> -#endif
> +#include <linux/byteorder.h>
>  
>  #endif /* _XTENSA_BYTEORDER_H */


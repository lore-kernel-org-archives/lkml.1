Return-Path: <linux-kernel-owner+w=401wt.eu-S1754237AbYHYFri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237AbYHYFri (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 01:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750872AbYHYFra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 01:47:30 -0400
Received: from hosted05.westnet.com.au ([203.10.1.219]:48875 "EHLO
	hosted05.westnet.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbYHYFr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 01:47:29 -0400
Message-ID: <48B24766.8030700@snapgear.com>
Date: Mon, 25 Aug 2008 15:47:18 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Greg Ungerer <gerg@uclinux.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 11/23] m68knommu: use the new byteorder headers
References: <1219106888.17033.64.camel@brick>
In-Reply-To: <1219106888.17033.64.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Branch: TNG-Outgoing
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Harvey,

Harvey Harrison wrote:
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

Looks ok to me.

Acked-by: Greg Ungerer <gerg@uclinux.org>

Regards
Greg


>  arch/m68knommu/include/asm/byteorder.h |   13 +++++--------
>  1 files changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/m68knommu/include/asm/byteorder.h b/arch/m68knommu/include/asm/byteorder.h
> index 20bb442..6d9d3b8 100644
> --- a/arch/m68knommu/include/asm/byteorder.h
> +++ b/arch/m68knommu/include/asm/byteorder.h
> @@ -3,13 +3,11 @@
>  
>  #include <linux/types.h>
>  
> -#if defined(__GNUC__) && !defined(__STRICT_ANSI__) || defined(__KERNEL__)
> -#  define __BYTEORDER_HAS_U64__
> -#  define __SWAB_64_THRU_32__
> -#endif
> +#define __BIG_ENDIAN
> +#define __SWAB_64_THRU_32__
>  
>  #if defined (__mcfisaaplus__) || defined (__mcfisac__)
> -static inline __attribute_const__ __u32 ___arch__swab32(__u32 val)
> +static inline __attribute_const__ __u32 __arch_swab32(__u32 val)
>  {
>  	asm(
>  			"byterev %0"
> @@ -18,10 +16,9 @@ static inline __attribute_const__ __u32 ___arch__swab32(__u32 val)
>  	   );
>  	return val;
>  }
> -
> -#define __arch__swab32(x) ___arch__swab32(x)
> +#define __arch_swab32 __arch_swab32
>  #endif
>  
> -#include <linux/byteorder/big_endian.h>
> +#include <linux/byteorder.h>
>  
>  #endif /* _M68KNOMMU_BYTEORDER_H */


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Chief Software Dude       EMAIL:     gerg@snapgear.com
SnapGear -- a Secure Computing Company      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com

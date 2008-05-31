Return-Path: <linux-kernel-owner+w=401wt.eu-S1756238AbYEaWxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238AbYEaWxO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 18:53:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753759AbYEaWw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 18:52:59 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:42799 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbYEaWw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 18:52:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uJASx+cCGNFBPk74JBOkoZTv5nTS6VY3BXWEaAP4ahZbBSmnWGy4uH27JVkEl/QzeU/m5Gh27BCbeYJlgU35kiTTnTqyuU2Fz3LWTWSSj7uYVe7sb/sMw0zI8Z0/EI7DnEZzyE9y6c0lAeGDUT/R+Xm3ItkNFNfe28Y4N8iRxTE=
Message-ID: <19f34abd0805311552q342cdc9fp9e08fe1e73696a1@mail.gmail.com>
Date: Sun, 1 Jun 2008 00:52:57 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ben Hutchings" <bhutchings@solarflare.com>
Subject: Re: [PATCH 2/2] Use <asm-generic/bitops/le.h> in <asm-powerpc/bitops.h>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20080531223832.GC30769@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f12db478511ce4ff462d1b236724e4fc46470a4d.1212272760.git.bhutchings@solarflare.com>
	 <20080531223419.GA30769@solarflare.com>
	 <20080531223832.GC30769@solarflare.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jun 1, 2008 at 12:38 AM, Ben Hutchings
<bhutchings@solarflare.com> wrote:
> The powerpc little-endian bitops have no arch-specific optimisations.
>
> Remove clashing macros from these headers.
>
> Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
> ---
>  include/asm-generic/bitops/le.h |    1 -
>  include/asm-powerpc/bitops.h    |   34 +---------------------------------
>  2 files changed, 1 insertions(+), 34 deletions(-)
>
> diff --git a/include/asm-generic/bitops/le.h b/include/asm-generic/bitops/le.h
> index a51c4ca..08c5df3 100644
> --- a/include/asm-generic/bitops/le.h
> +++ b/include/asm-generic/bitops/le.h
> @@ -4,7 +4,6 @@
>  #include <asm/types.h>
>  #include <asm/byteorder.h>
>
> -#define BITOP_WORD(nr)         ((nr) / BITS_PER_LONG)
>  #define BITOP_LE_SWIZZLE       ((BITS_PER_LONG-1) & ~0x7)
>
>  #if defined(__LITTLE_ENDIAN)
> diff --git a/include/asm-powerpc/bitops.h b/include/asm-powerpc/bitops.h
> index dcbf9a8..afe2fa3 100644
> --- a/include/asm-powerpc/bitops.h
> +++ b/include/asm-powerpc/bitops.h
> @@ -54,7 +54,6 @@
>
>  #define BITOP_MASK(nr)         (1UL << ((nr) % BITS_PER_LONG))
>  #define BITOP_WORD(nr)         ((nr) / BITS_PER_LONG)
> -#define BITOP_LE_SWIZZLE       ((BITS_PER_LONG-1) & ~0x7)
>
>  static __inline__ void set_bit(int nr, volatile unsigned long *addr)
>  {
> @@ -340,39 +339,8 @@ static __inline__ int fls64(__u64 x)
>
>  /* Little-endian versions */
>
> -static __inline__ int test_le_bit(unsigned long nr,
> -                                 __const__ unsigned long *addr)
> -{
> -       __const__ unsigned char *tmp = (__const__ unsigned char *) addr;
> -       return (tmp[nr >> 3] >> (nr & 7)) & 1;
> -}
> +#include <asm-generic/bitops/le.h>

Is it completely impossible to move this #include to the top of the file?

I know that a lot of the current headers don't do this, and I don't
think it's a written rule with the kernel sources, BUT it's a nice
convention IMHO, and makes headers generally more maintainable. What
do you think?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036

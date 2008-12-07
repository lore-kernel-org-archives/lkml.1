Return-Path: <linux-kernel-owner+w=401wt.eu-S1755319AbYLGVvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbYLGVvT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 16:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752342AbYLGVvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 16:51:08 -0500
Received: from harold.telenet-ops.be ([195.130.133.65]:56718 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbYLGVvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 16:51:06 -0500
Date: Sun, 7 Dec 2008 22:50:59 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: Yet more ARM breakage in linux-next
In-Reply-To: <200812050042.28222.rusty@rustcorp.com.au>
Message-ID: <Pine.LNX.4.64.0812072248430.14941@anakin>
References: <20081203192905.GA12502@flint.arm.linux.org.uk>
 <20081203124109.79f8f15b.akpm@linux-foundation.org> <Pine.LNX.4.64.0812041017470.10635@anakin>
 <200812050042.28222.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Dec 2008, Rusty Russell wrote:
> On Thursday 04 December 2008 19:48:06 Geert Uytterhoeven wrote:
> > Also broke m68k (a bit more hidden due to other build failures).
> 
> And m68knommu has similar issues.
> 
> Here's what I have for m68k for tomorrow's linux-next.  Please steal.
> 
> m68k: define __fls
> 
> Like fls, but can't be handed 0 and returns the bit number.
> 
> (I broke this arch in linux-next by using __fls in generic code).
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> diff --git a/include/asm-m68k/bitops.h b/include/asm-m68k/bitops.h
> --- a/include/asm-m68k/bitops.h
> +++ b/include/asm-m68k/bitops.h
> @@ -315,6 +315,11 @@ static inline int fls(int x)
>  	return 32 - cnt;
>  }
>  
> +static inline int __fls(int x)
                 ^^^       ^^^
Other implementations take `unsigned long' and return `unsigned long'...

> +{
> +	return fls(x) - 1;
> +}
> +

On Thu, 4 Dec 2008, Rusty Russell wrote:
> Like fls, but can't be handed 0 and returns the bit number.
> 
> (I added find_last_bit() to bitmap.h which broke archs which didn't
>  define this)
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  arch/avr32/include/asm/bitops.h |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/avr32/include/asm/bitops.h b/arch/avr32/include/asm/bitops.h
> --- a/arch/avr32/include/asm/bitops.h
> +++ b/arch/avr32/include/asm/bitops.h
> @@ -263,6 +263,11 @@ static inline int fls(unsigned long word
>  	return 32 - result;
>  }
>  
> +static inline int __fls(unsigned long word)
                 ^^^       ^^^^^^^^^^^^^
> +{
> +	return fls(word) - 1;
> +}
> +

... but this one uses mixed types?

What are the official semantics of __fls()?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

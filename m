Return-Path: <linux-kernel-owner+w=401wt.eu-S1757562AbXH1Hhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562AbXH1Hhg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 03:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752255AbXH1HhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 03:37:24 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49527 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752608AbXH1HhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 03:37:22 -0400
Date: Tue, 28 Aug 2007 00:37:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Gabriel C <nix.or.die@googlemail.com>, linux-kernel@vger.kernel.org,
       Olaf Hering <olh@suse.de>, netdev@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [-mm patch] make types.h usable for non-gcc C parsers
Message-Id: <20070828003704.deed71ae.akpm@linux-foundation.org>
In-Reply-To: <20070827212743.GN4121@stusta.de>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
	<46CC3B27.10604@googlemail.com>
	<20070827212743.GN4121@stusta.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Aug 2007 23:27:43 +0200 Adrian Bunk <bunk@kernel.org> wrote:

> On Wed, Aug 22, 2007 at 03:33:27PM +0200, Gabriel C wrote:
> >...
> > WARNING: "div64_64" [net/netfilter/xt_connbytes.ko] has no CRC!
> >...
> 
> Patch below.
> 
> > Regards,
> > 
> > Gabriel
> 
> cu
> Adrian
> 
> 
> <--  snip  -->
> 
> 
> This patch makes the 64bit integers on 32bit architectures usable for
> all C parsers that know about "long long".
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 

Given that this patch (hopefully) fixes a problem in the current net-2.6.24
tree, I'm inclined to slip it into mainline immediately.

But I'd like a better description, please.  Which "non-gcc parser" are we
talking about here?  Something under ./scripts/.  Well, please identify it,
and describe what the problem is, and how the proposed patch will address
it.

Let's cc Sam too, as I guess he's the guy whose code just broke.

Thanks.

(patch retained for cc'ees)

> ---
> 
>  include/asm-arm/types.h      |   10 +++++++---
>  include/asm-avr32/types.h    |   10 +++++++---
>  include/asm-blackfin/types.h |   11 +++++++----
>  include/asm-cris/types.h     |   10 +++++++---
>  include/asm-frv/types.h      |   10 +++++++---
>  include/asm-h8300/types.h    |   10 +++++++---
>  include/asm-i386/types.h     |   10 +++++++---
>  include/asm-m32r/types.h     |   11 ++++++++---
>  include/asm-m68k/types.h     |   10 +++++++---
>  include/asm-mips/types.h     |   10 +++++++---
>  include/asm-parisc/types.h   |   10 +++++++---
>  include/asm-powerpc/types.h  |    9 ++++++---
>  include/asm-s390/types.h     |    9 ++++++---
>  include/asm-sh/types.h       |   10 +++++++---
>  include/asm-sh64/types.h     |   10 +++++++---
>  include/asm-v850/types.h     |   10 +++++++---
>  include/asm-xtensa/types.h   |   10 +++++++---
>  17 files changed, 118 insertions(+), 52 deletions(-)
> 
> 4b6826d7a2f5b54a6a3b1cfa8cd40b1b27621be0 
> diff --git a/include/asm-arm/types.h b/include/asm-arm/types.h
> index 3141451..1dae25b 100644
> --- a/include/asm-arm/types.h
> +++ b/include/asm-arm/types.h
> @@ -19,11 +19,15 @@ typedef unsigned short __u16;
>  typedef __signed__ int __s32;
>  typedef unsigned int __u32;
>  
> -#if defined(__GNUC__)
> -__extension__ typedef __signed__ long long __s64;
> -__extension__ typedef unsigned long long __u64;
> +#if defined(__GNUC__) && defined(__STRICT_ANSI__)
> +#define __extension_long_long __extension__
> +#else
> +#define __extension_long_long
>  #endif
>  
> +__extension_long_long typedef __signed__ long long __s64;
> +__extension_long_long typedef unsigned long long __u64;
> +
>  #endif /* __ASSEMBLY__ */
>  
>  /*
> diff --git a/include/asm-avr32/types.h b/include/asm-avr32/types.h
> index 8999a38..2c14f49 100644
> --- a/include/asm-avr32/types.h
> +++ b/include/asm-avr32/types.h
> @@ -25,11 +25,15 @@ typedef unsigned short __u16;
>  typedef __signed__ int __s32;
>  typedef unsigned int __u32;
>  
> -#if defined(__GNUC__)
> -__extension__ typedef __signed__ long long __s64;
> -__extension__ typedef unsigned long long __u64;
> +#if defined(__GNUC__) && defined(__STRICT_ANSI__)
> +#define __extension_long_long __extension__
> +#else
> +#define __extension_long_long
>  #endif
>  
> +__extension_long_long typedef __signed__ long long __s64;
> +__extension_long_long typedef unsigned long long __u64;
> +
>  #endif /* __ASSEMBLY__ */
>  
>  /*
> diff --git a/include/asm-blackfin/types.h b/include/asm-blackfin/types.h
> index 9785a6d..d0666b9 100644
> --- a/include/asm-blackfin/types.h
> +++ b/include/asm-blackfin/types.h
> @@ -26,12 +26,15 @@ typedef unsigned short __u16;
>  typedef __signed__ int __s32;
>  typedef unsigned int __u32;
>  
> -/* HK0617   -- Changes to unsigned long temporarily */
> -#if defined(__GNUC__)
> -__extension__ typedef __signed__ long long __s64;
> -__extension__ typedef unsigned long long __u64;
> +#if defined(__GNUC__) && defined(__STRICT_ANSI__)
> +#define __extension_long_long __extension__
> +#else
> +#define __extension_long_long
>  #endif
>  
> +__extension_long_long typedef __signed__ long long __s64;
> +__extension_long_long typedef unsigned long long __u64;
> +
>  #endif				/* __ASSEMBLY__ */
>  /*
>   * These aren't exported outside the kernel to avoid name space clashes
> diff --git a/include/asm-cris/types.h b/include/asm-cris/types.h
> index 5a21c42..6c46a90 100644
> --- a/include/asm-cris/types.h
> +++ b/include/asm-cris/types.h
> @@ -19,11 +19,15 @@ typedef unsigned short __u16;
>  typedef __signed__ int __s32;
>  typedef unsigned int __u32;
>  
> -#if defined(__GNUC__)
> -__extension__ typedef __signed__ long long __s64;
> -__extension__ typedef unsigned long long __u64;
> +#if defined(__GNUC__) && defined(__STRICT_ANSI__)
> +#define __extension_long_long __extension__
> +#else
> +#define __extension_long_long
>  #endif
>  
> +__extension_long_long typedef __signed__ long long __s64;
> +__extension_long_long typedef unsigned long long __u64;
> +
>  #endif /* __ASSEMBLY__ */
>  
>  /*
> diff --git a/include/asm-frv/types.h b/include/asm-frv/types.h
> index 767e5ed..728c234 100644
> --- a/include/asm-frv/types.h
> +++ b/include/asm-frv/types.h
> @@ -30,11 +30,15 @@ typedef unsigned short __u16;
>  typedef __signed__ int __s32;
>  typedef unsigned int __u32;
>  
> -#if defined(__GNUC__)
> -__extension__ typedef __signed__ long long __s64;
> -__extension__ typedef unsigned long long __u64;
> +#if defined(__GNUC__) && defined(__STRICT_ANSI__)
> +#define __extension_long_long __extension__
> +#else
> +#define __extension_long_long
>  #endif
>  
> +__extension_long_long typedef __signed__ long long __s64;
> +__extension_long_long typedef unsigned long long __u64;
> +
>  #endif /* __ASSEMBLY__ */
>  
>  /*
> diff --git a/include/asm-h8300/types.h b/include/asm-h8300/types.h
> index 56566e2..1fc2dd9 100644
> --- a/include/asm-h8300/types.h
> +++ b/include/asm-h8300/types.h
> @@ -27,11 +27,15 @@ typedef unsigned short __u16;
>  typedef __signed__ int __s32;
>  typedef unsigned int __u32;
>  
> -#if defined(__GNUC__)
> -__extension__ typedef __signed__ long long __s64;
> -__extension__ typedef unsigned long long __u64;
> +#if defined(__GNUC__) && defined(__STRICT_ANSI__)
> +#define __extension_long_long __extension__
> +#else
> +#define __extension_long_long
>  #endif
>  
> +__extension_long_long typedef __signed__ long long __s64;
> +__extension_long_long typedef unsigned long long __u64;
> +
>  /*
>   * These aren't exported outside the kernel to avoid name space clashes
>   */
> diff --git a/include/asm-i386/types.h b/include/asm-i386/types.h
> index faca192..a2c3b35 100644
> --- a/include/asm-i386/types.h
> +++ b/include/asm-i386/types.h
> @@ -19,11 +19,15 @@ typedef unsigned short __u16;
>  typedef __signed__ int __s32;
>  typedef unsigned int __u32;
>  
> -#if defined(__GNUC__)
> -__extension__ typedef __signed__ long long __s64;
> -__extension__ typedef unsigned long long __u64;
> +#if defined(__GNUC__) && defined(__STRICT_ANSI__)
> +#define __extension_long_long __extension__
> +#else
> +#define __extension_long_long
>  #endif
>  
> +__extension_long_long typedef __signed__ long long __s64;
> +__extension_long_long typedef unsigned long long __u64;
> +
>  #endif /* __ASSEMBLY__ */
>  
>  /*
> diff --git a/include/asm-m32r/types.h b/include/asm-m32r/types.h
> index b64c166..8071e22 100644
> --- a/include/asm-m32r/types.h
> +++ b/include/asm-m32r/types.h
> @@ -19,10 +19,15 @@ typedef unsigned short __u16;
>  typedef __signed__ int __s32;
>  typedef unsigned int __u32;
>  
> -#if defined(__GNUC__)
> -__extension__ typedef __signed__ long long __s64;
> -__extension__ typedef unsigned long long __u64;
> +#if defined(__GNUC__) && defined(__STRICT_ANSI__)
> +#define __extension_long_long __extension__
> +#else
> +#define __extension_long_long
>  #endif
> +
> +__extension_long_long typedef __signed__ long long __s64;
> +__extension_long_long typedef unsigned long long __u64;
> +
>  #endif /* __ASSEMBLY__ */
>  
>  /*
> diff --git a/include/asm-m68k/types.h b/include/asm-m68k/types.h
> index c35c09d..43e0186 100644
> --- a/include/asm-m68k/types.h
> +++ b/include/asm-m68k/types.h
> @@ -27,11 +27,15 @@ typedef unsigned short __u16;
>  typedef __signed__ int __s32;
>  typedef unsigned int __u32;
>  
> -#if defined(__GNUC__)
> -__extension__ typedef __signed__ long long __s64;
> -__extension__ typedef unsigned long long __u64;
> +#if defined(__GNUC__) && defined(__STRICT_ANSI__)
> +#define __extension_long_long __extension__
> +#else
> +#define __extension_long_long
>  #endif
>  
> +__extension_long_long typedef __signed__ long long __s64;
> +__extension_long_long typedef unsigned long long __u64;
> +
>  #endif /* __ASSEMBLY__ */
>  
>  /*
> diff --git a/include/asm-mips/types.h b/include/asm-mips/types.h
> index 2dd147f..fe1eb32 100644
> --- a/include/asm-mips/types.h
> +++ b/include/asm-mips/types.h
> @@ -34,11 +34,15 @@ typedef unsigned long __u64;
>  
>  #else
>  
> -#if defined(__GNUC__)
> -__extension__ typedef __signed__ long long __s64;
> -__extension__ typedef unsigned long long __u64;
> +#if defined(__GNUC__) && defined(__STRICT_ANSI__)
> +#define __extension_long_long __extension__
> +#else
> +#define __extension_long_long
>  #endif
>  
> +__extension_long_long typedef __signed__ long long __s64;
> +__extension_long_long typedef unsigned long long __u64;
> +
>  #endif
>  
>  #endif /* __ASSEMBLY__ */
> diff --git a/include/asm-parisc/types.h b/include/asm-parisc/types.h
> index 56c8480..5df2b11 100644
> --- a/include/asm-parisc/types.h
> +++ b/include/asm-parisc/types.h
> @@ -19,11 +19,15 @@ typedef unsigned short __u16;
>  typedef __signed__ int __s32;
>  typedef unsigned int __u32;
>  
> -#if defined(__GNUC__)
> -__extension__ typedef __signed__ long long __s64;
> -__extension__ typedef unsigned long long __u64;
> +#if defined(__GNUC__) && defined(__STRICT_ANSI__)
> +#define __extension_long_long __extension__
> +#else
> +#define __extension_long_long
>  #endif
>  
> +__extension_long_long typedef __signed__ long long __s64;
> +__extension_long_long typedef unsigned long long __u64;
> +
>  #endif /* __ASSEMBLY__ */
>  
>  /*
> diff --git a/include/asm-powerpc/types.h b/include/asm-powerpc/types.h
> index 695e2ce..2ce1998 100644
> --- a/include/asm-powerpc/types.h
> +++ b/include/asm-powerpc/types.h
> @@ -40,10 +40,13 @@ typedef unsigned int __u32;
>  typedef __signed__ long __s64;
>  typedef unsigned long __u64;
>  #else
> -#if defined(__GNUC__)
> -__extension__ typedef __signed__ long long __s64;
> -__extension__ typedef unsigned long long __u64;
> +#if defined(__GNUC__) && defined(__STRICT_ANSI__)
> +#define __extension_long_long __extension__
> +#else
> +#define __extension_long_long
>  #endif
> +__extension_long_long typedef __signed__ long long __s64;
> +__extension_long_long typedef unsigned long long __u64;
>  #endif /* __powerpc64__ */
>  
>  typedef struct {
> diff --git a/include/asm-s390/types.h b/include/asm-s390/types.h
> index 2c5879a..9590d00 100644
> --- a/include/asm-s390/types.h
> +++ b/include/asm-s390/types.h
> @@ -28,10 +28,13 @@ typedef __signed__ int __s32;
>  typedef unsigned int __u32;
>  
>  #ifndef __s390x__
> -#if defined(__GNUC__)
> -__extension__ typedef __signed__ long long __s64;
> -__extension__ typedef unsigned long long __u64;
> +#if defined(__GNUC__) && defined(__STRICT_ANSI__)
> +#define __extension_long_long __extension__
> +#else
> +#define __extension_long_long
>  #endif
> +__extension_long_long typedef __signed__ long long __s64;
> +__extension_long_long typedef unsigned long long __u64;
>  #else /* __s390x__ */
>  typedef __signed__ long __s64;
>  typedef unsigned long __u64;
> diff --git a/include/asm-sh/types.h b/include/asm-sh/types.h
> index 7ba69d9..d747b87 100644
> --- a/include/asm-sh/types.h
> +++ b/include/asm-sh/types.h
> @@ -19,11 +19,15 @@ typedef unsigned short __u16;
>  typedef __signed__ int __s32;
>  typedef unsigned int __u32;
>  
> -#if defined(__GNUC__)
> -__extension__ typedef __signed__ long long __s64;
> -__extension__ typedef unsigned long long __u64;
> +#if defined(__GNUC__) && defined(__STRICT_ANSI__)
> +#define __extension_long_long __extension__
> +#else
> +#define __extension_long_long
>  #endif
>  
> +__extension_long_long__ typedef __signed__ long long __s64;
> +__extension_long_long__ typedef unsigned long long __u64;
> +
>  #endif /* __ASSEMBLY__ */
>  
>  /*
> diff --git a/include/asm-sh64/types.h b/include/asm-sh64/types.h
> index 2c7ad73..e5e90ff 100644
> --- a/include/asm-sh64/types.h
> +++ b/include/asm-sh64/types.h
> @@ -30,11 +30,15 @@ typedef unsigned short __u16;
>  typedef __signed__ int __s32;
>  typedef unsigned int __u32;
>  
> -#if defined(__GNUC__)
> -__extension__ typedef __signed__ long long __s64;
> -__extension__ typedef unsigned long long __u64;
> +#if defined(__GNUC__) && defined(__STRICT_ANSI__)
> +#define __extension_long_long __extension__
> +#else
> +#define __extension_long_long
>  #endif
>  
> +__extension_long_long typedef __signed__ long long __s64;
> +__extension_long_long typedef unsigned long long __u64;
> +
>  #endif /* __ASSEMBLY__ */
>  
>  /*
> diff --git a/include/asm-v850/types.h b/include/asm-v850/types.h
> index 284bda8..6fac765 100644
> --- a/include/asm-v850/types.h
> +++ b/include/asm-v850/types.h
> @@ -27,11 +27,15 @@ typedef unsigned short __u16;
>  typedef __signed__ int __s32;
>  typedef unsigned int __u32;
>  
> -#if defined(__GNUC__)
> -__extension__ typedef __signed__ long long __s64;
> -__extension__ typedef unsigned long long __u64;
> +#if defined(__GNUC__) && defined(__STRICT_ANSI__)
> +#define __extension_long_long __extension__
> +#else
> +#define __extension_long_long
>  #endif
>  
> +__extension_long_long typedef __signed__ long long __s64;
> +__extension_long_long typedef unsigned long long __u64;
> +
>  #endif /* !__ASSEMBLY__ */
>  
>  /*
> diff --git a/include/asm-xtensa/types.h b/include/asm-xtensa/types.h
> index 958f362..184c058 100644
> --- a/include/asm-xtensa/types.h
> +++ b/include/asm-xtensa/types.h
> @@ -29,11 +29,15 @@ typedef unsigned short __u16;
>  typedef __signed__ int __s32;
>  typedef unsigned int __u32;
>  
> -#if defined(__GNUC__)
> -__extension__ typedef __signed__ long long __s64;
> -__extension__ typedef unsigned long long __u64;
> +#if defined(__GNUC__) && defined(__STRICT_ANSI__)
> +#define __extension_long_long __extension__
> +#else
> +#define __extension_long_long
>  #endif
>  
> +__extension_long_long typedef __signed__ long long __s64;
> +__extension_long_long typedef unsigned long long __u64;
> +
>  /*
>   * These aren't exported outside the kernel to avoid name space clashes
>   */

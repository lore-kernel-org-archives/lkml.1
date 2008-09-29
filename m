Return-Path: <linux-kernel-owner+w=401wt.eu-S1754251AbYI2JIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251AbYI2JIo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 05:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753835AbYI2JIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 05:08:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51860 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbYI2JId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 05:08:33 -0400
Message-ID: <48E09AE9.3090501@zytor.com>
Date: Mon, 29 Sep 2008 02:07:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Krzysztof Helt <krzysztof.h1@wp.pl>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: merge winchip-2 and winchip-2a cpu choices
References: <20080928212815.6ffea9d9.krzysztof.h1@wp.pl>
In-Reply-To: <20080928212815.6ffea9d9.krzysztof.h1@wp.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me.

Acked-by: H. Peter Anvin <hpa@zytor.com>

Krzysztof Helt wrote:
> From: Krzysztof Helt <krzysztof.h1@wp.pl>
> 
> The Winchip-2 and Winchip-2A cpu choices select the
> same options for kernel and compiler. 
> 
> Merge them to save few bytes and reduce confusion.
> 
> Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
> ---
> 
> diff -urp linux-ref/arch/um/defconfig linux-2.6.26/arch/um/defconfig
> --- linux-ref/arch/um/defconfig	2008-09-28 18:58:21.000000000 +0200
> +++ linux-2.6.26/arch/um/defconfig	2008-09-28 18:46:20.000000000 +0200
> @@ -42,7 +42,6 @@ CONFIG_M686=y
>  # CONFIG_MCRUSOE is not set
>  # CONFIG_MEFFICEON is not set
>  # CONFIG_MWINCHIPC6 is not set
> -# CONFIG_MWINCHIP2 is not set
>  # CONFIG_MWINCHIP3D is not set
>  # CONFIG_MGEODEGX1 is not set
>  # CONFIG_MGEODE_LX is not set
> diff -urp linux-ref/arch/x86/Kconfig.cpu linux-2.6.26/arch/x86/Kconfig.cpu
> --- linux-ref/arch/x86/Kconfig.cpu	2008-09-27 23:28:13.000000000 +0200
> +++ linux-2.6.26/arch/x86/Kconfig.cpu	2008-09-28 23:20:00.000000000 +0200
> @@ -38,8 +38,7 @@ config M386
>  	  - "Crusoe" for the Transmeta Crusoe series.
>  	  - "Efficeon" for the Transmeta Efficeon series.
>  	  - "Winchip-C6" for original IDT Winchip.
> -	  - "Winchip-2" for IDT Winchip 2.
> -	  - "Winchip-2A" for IDT Winchips with 3dNow! capabilities.
> +	  - "Winchip-2" for IDT Winchips with 3dNow! capabilities.
>  	  - "GeodeGX1" for Geode GX1 (Cyrix MediaGX).
>  	  - "Geode GX/LX" For AMD Geode GX and LX processors.
>  	  - "CyrixIII/VIA C3" for VIA Cyrix III or VIA C3.
> @@ -194,19 +193,11 @@ config MWINCHIPC6
>  	  treat this chip as a 586TSC with some extended instructions
>  	  and alignment requirements.
>  
> -config MWINCHIP2
> -	bool "Winchip-2"
> -	depends on X86_32
> -	help
> -	  Select this for an IDT Winchip-2.  Linux and GCC
> -	  treat this chip as a 586TSC with some extended instructions
> -	  and alignment requirements.
> -
>  config MWINCHIP3D
> -	bool "Winchip-2A/Winchip-3"
> +	bool "Winchip-2/Winchip-2A/Winchip-3"
>  	depends on X86_32
>  	help
> -	  Select this for an IDT Winchip-2A or 3.  Linux and GCC
> +	  Select this for an IDT Winchip-2, 2A or 3.  Linux and GCC
>  	  treat this chip as a 586TSC with some extended instructions
>  	  and alignment requirements.  Also enable out of order memory
>  	  stores for this CPU, which can increase performance of some
> @@ -318,7 +309,7 @@ config X86_L1_CACHE_SHIFT
>  	int
>  	default "7" if MPENTIUM4 || X86_GENERIC || GENERIC_CPU || MPSC
>  	default "4" if X86_ELAN || M486 || M386 || MGEODEGX1
> -	default "5" if MWINCHIP3D || MWINCHIP2 || MWINCHIPC6 || MCRUSOE || MEFFICEON || MCYRIXIII || MK6 || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || M586 || MVIAC3_2 ||
> MGEODE_LX
> +	default "5" if MWINCHIP3D || MWINCHIPC6 || MCRUSOE || MEFFICEON || MCYRIXIII || MK6 || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || M586 || MVIAC3_2 || MGEODE_LX
>  	default "6" if MK7 || MK8 || MPENTIUMM || MCORE2 || MVIAC7
>  
>  config X86_XADD
> @@ -360,7 +351,7 @@ config X86_POPAD_OK
>  
>  config X86_ALIGNMENT_16
>  	def_bool y
> -	depends on MWINCHIP3D || MWINCHIP2 || MWINCHIPC6 || MCYRIXIII || X86_ELAN || MK6 || M586MMX || M586TSC || M586 || M486 || MVIAC3_2 || MGEODEGX1
> +	depends on MWINCHIP3D || MWINCHIPC6 || MCYRIXIII || X86_ELAN || MK6 || M586MMX || M586TSC || M586 || M486 || MVIAC3_2 || MGEODEGX1
>  
>  config X86_INTEL_USERCOPY
>  	def_bool y
> @@ -368,7 +359,7 @@ config X86_INTEL_USERCOPY
>  
>  config X86_USE_PPRO_CHECKSUM
>  	def_bool y
> -	depends on MWINCHIP3D || MWINCHIP2 || MWINCHIPC6 || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MK8 || MVIAC3_2 || MEFFICEON ||
> MGEODE_LX || MCORE2
> +	depends on MWINCHIP3D || MWINCHIPC6 || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MK8 || MVIAC3_2 || MEFFICEON || MGEODE_LX ||
> MCORE2 
>  config X86_USE_3DNOW
>  	def_bool y
> @@ -376,7 +367,7 @@ config X86_USE_3DNOW
>  
>  config X86_OOSTORE
>  	def_bool y
> -	depends on (MWINCHIP3D || MWINCHIP2 || MWINCHIPC6) && MTRR
> +	depends on (MWINCHIP3D || MWINCHIPC6) && MTRR
>  
>  #
>  # P6_NOPs are a relatively minor optimization that require a family >=
> @@ -396,7 +387,7 @@ config X86_P6_NOP
>  
>  config X86_TSC
>  	def_bool y
> -	depends on ((MWINCHIP3D || MWINCHIP2 || MCRUSOE || MEFFICEON || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC ||
> MK8 || MVIAC3_2 || MVIAC7 || MGEODEGX1 || MGEODE_LX || MCORE2) && !X86_NUMAQ) || X86_64
> +	depends on ((MWINCHIP3D || MCRUSOE || MEFFICEON || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || MK8 || MVIAC3_2
> || MVIAC7 || MGEODEGX1 || MGEODE_LX || MCORE2) && !X86_NUMAQ) || X86_64 
>  config X86_CMPXCHG64
>  	def_bool y
> @@ -417,7 +408,7 @@ config X86_MINIMUM_CPU_FAMILY
>  
>  config X86_DEBUGCTLMSR
>  	def_bool y
> -	depends on !(MK6 || MWINCHIPC6 || MWINCHIP2 || MWINCHIP3D || MCYRIXIII || M586MMX || M586TSC || M586 || M486 || M386)
> +	depends on !(MK6 || MWINCHIPC6 || MWINCHIP3D || MCYRIXIII || M586MMX || M586TSC || M586 || M486 || M386)
>  
>  menuconfig PROCESSOR_SELECT
>  	default y
> diff -urp linux-ref/arch/x86/Makefile_32.cpu linux-2.6.26/arch/x86/Makefile_32.cpu
> --- linux-ref/arch/x86/Makefile_32.cpu	2008-09-27 23:28:13.000000000 +0200
> +++ linux-2.6.26/arch/x86/Makefile_32.cpu	2008-09-28 18:36:55.000000000 +0200
> @@ -28,7 +28,6 @@ cflags-$(CONFIG_MK8)		+= $(call cc-optio
>  cflags-$(CONFIG_MCRUSOE)	+= -march=i686 $(align)-functions=0 $(align)-jumps=0 $(align)-loops=0
>  cflags-$(CONFIG_MEFFICEON)	+= -march=i686 $(call tune,pentium3) $(align)-functions=0 $(align)-jumps=0 $(align)-loops=0
>  cflags-$(CONFIG_MWINCHIPC6)	+= $(call cc-option,-march=winchip-c6,-march=i586)
> -cflags-$(CONFIG_MWINCHIP2)	+= $(call cc-option,-march=winchip2,-march=i586)
>  cflags-$(CONFIG_MWINCHIP3D)	+= $(call cc-option,-march=winchip2,-march=i586)
>  cflags-$(CONFIG_MCYRIXIII)	+= $(call cc-option,-march=c3,-march=i486) $(align)-functions=0 $(align)-jumps=0 $(align)-loops=0
>  cflags-$(CONFIG_MVIAC3_2)	+= $(call cc-option,-march=c3-2,-march=i686)
> diff -urp linux-ref/arch/x86/configs/i386_defconfig linux-2.6.26/arch/x86/configs/i386_defconfig
> --- linux-ref/arch/x86/configs/i386_defconfig	2008-09-27 23:28:14.000000000 +0200
> +++ linux-2.6.26/arch/x86/configs/i386_defconfig	2008-09-28 18:38:16.000000000 +0200
> @@ -213,7 +213,6 @@ CONFIG_M686=y
>  # CONFIG_MCRUSOE is not set
>  # CONFIG_MEFFICEON is not set
>  # CONFIG_MWINCHIPC6 is not set
> -# CONFIG_MWINCHIP2 is not set
>  # CONFIG_MWINCHIP3D is not set
>  # CONFIG_MGEODEGX1 is not set
>  # CONFIG_MGEODE_LX is not set
> diff -urp linux-ref/arch/x86/configs/x86_64_defconfig linux-2.6.26/arch/x86/configs/x86_64_defconfig
> --- linux-ref/arch/x86/configs/x86_64_defconfig	2008-09-27 23:28:14.000000000 +0200
> +++ linux-2.6.26/arch/x86/configs/x86_64_defconfig	2008-09-28 18:38:23.000000000 +0200
> @@ -210,7 +210,6 @@ CONFIG_X86_PC=y
>  # CONFIG_MCRUSOE is not set
>  # CONFIG_MEFFICEON is not set
>  # CONFIG_MWINCHIPC6 is not set
> -# CONFIG_MWINCHIP2 is not set
>  # CONFIG_MWINCHIP3D is not set
>  # CONFIG_MGEODEGX1 is not set
>  # CONFIG_MGEODE_LX is not set
> diff -urp linux-ref/include/asm-x86/module.h linux-2.6.26/include/asm-x86/module.h
> --- linux-ref/include/asm-x86/module.h	2008-09-28 18:54:26.000000000 +0200
> +++ linux-2.6.26/include/asm-x86/module.h	2008-09-28 18:43:33.000000000 +0200
> @@ -52,8 +52,6 @@ struct mod_arch_specific {};
>  #define MODULE_PROC_FAMILY "EFFICEON "
>  #elif defined CONFIG_MWINCHIPC6
>  #define MODULE_PROC_FAMILY "WINCHIPC6 "
> -#elif defined CONFIG_MWINCHIP2
> -#define MODULE_PROC_FAMILY "WINCHIP2 "
>  #elif defined CONFIG_MWINCHIP3D
>  #define MODULE_PROC_FAMILY "WINCHIP3D "
>  #elif defined CONFIG_MCYRIXIII

Return-Path: <linux-kernel-owner+w=401wt.eu-S935225AbXLPSTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935225AbXLPSTS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 13:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763646AbXLPSTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 13:19:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54363 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488AbXLPSTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 13:19:08 -0500
Message-ID: <47656C00.6000501@zytor.com>
Date: Sun, 16 Dec 2007 10:18:40 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/4] x86: Unify local_{32|64}.h
References: <1197806640.3749.42.camel@brick>
In-Reply-To: <1197806640.3749.42.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> Introduce macros to deal with X86_32 using longs and X86_64
> using quads.  Small comment fixes to make files match.
>  
>  #define local_read(l)	atomic_long_read(&(l)->a)
>  #define local_set(l,i)	atomic_long_set(&(l)->a, (i))
> +/*
> + * X86_32 uses longs
> + * X86_64 uses quads
> + */
> +#ifdef CONFIG_X86_32
> +# define ASM_INC incl
> +# define ASM_DEC decl
> +# define ASM_ADD addl
> +# define ASM_SUB subl
> +# define ASM_XADD xaddl
> +#else
> +# define ASM_INC incq
> +# define ASM_DEC decq
> +# define ASM_ADD addq
> +# define ASM_SUB subq
> +# define ASM_XADD xaddq
> +#endif
>  

Please put these in <asm/asm.h> using the _ASM_* namespace and include 
the quotation marks.

>  #ifdef CONFIG_X86_32
>  # include "local_32.h"
> diff --git a/include/asm-x86/local_32.h b/include/asm-x86/local_32.h
> index f3bc4d9..ff6d1d2 100644
> --- a/include/asm-x86/local_32.h
> +++ b/include/asm-x86/local_32.h
> @@ -4,21 +4,21 @@
>  static inline void local_inc(local_t *l)
>  {
>  	__asm__ __volatile__(
> -		"incl %0"
> +		"ASM_INC %0"
>  		:"+m" (l->a.counter));

You're substituting a macro *inside* a string here.

	-hpa

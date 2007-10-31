Return-Path: <linux-kernel-owner+w=401wt.eu-S1753581AbXJaB15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbXJaB15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 21:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbXJaB1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 21:27:49 -0400
Received: from gw.goop.org ([64.81.55.164]:40180 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981AbXJaB1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 21:27:48 -0400
Message-ID: <4727DA13.9080904@goop.org>
Date: Tue, 30 Oct 2007 18:27:47 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH] Add asm-compat.h to x86
References: <20071030145523.GA28026@Krystal>
In-Reply-To: <20071030145523.GA28026@Krystal>
X-Enigmail-Version: 0.95.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> Add asm-compat.h to x86
>
> In assembly code and in gcc inline assembly, we need .long to express a "c long"
> type on i386 and a .quad to express the same on x86_64. Use macros similar to
> powerpc "PPC_LONG" to express those. Name chosen: ASM_LONG. (didn't feel like
> X86_LONG was required).
>
> This is useful in inline assembly within code shared between 32 and 64
> bits architectures in x86.
>
> More compatible assembly macros could be added in this header later when
> needed.
>
> I had to create this to implement a merged optimized immediate values
> header for x86.
>   

Seems sound to me, and this header might be a useful place to put other
things, like macros to emit exceptions, etc...

    J
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: "H. Peter Anvin" <hpa@zytor.com>
> ---
>  include/asm-x86/asm-compat.h |   29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
>
> Index: linux-2.6-lttng/include/asm-x86/asm-compat.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/include/asm-x86/asm-compat.h	2007-10-24 09:41:09.000000000 -0400
> @@ -0,0 +1,29 @@
> +#ifndef _ASM_X86_ASM_COMPAT_H
> +#define _ASM_X86_ASM_COMPAT_H
> +
> +#include <asm/types.h>
> +
> +#ifdef __ASSEMBLY__
> +#  define stringify_in_c(...)	__VA_ARGS__
> +#  define ASM_CONST(x)		x
> +#else
> +/* This version of stringify will deal with commas... */
> +#  define __stringify_in_c(...)	#__VA_ARGS__
> +#  define stringify_in_c(...)	__stringify_in_c(__VA_ARGS__) " "
> +#  define __ASM_CONST(x)	x##UL
> +#  define ASM_CONST(x)		__ASM_CONST(x)
> +#endif
> +
> +#ifdef CONFIG_X86_64
> +
> +/* operations for longs and pointers */
> +#define ASM_LONG	stringify_in_c(.quad)
> +
> +#else /* 32-bit */
> +
> +/* operations for longs and pointers */
> +#define ASM_LONG	stringify_in_c(.long)
> +
> +#endif
> +
> +#endif /* _ASM_X86_ASM_COMPAT_H */
>
>   


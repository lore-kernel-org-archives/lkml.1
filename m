Return-Path: <linux-kernel-owner+w=401wt.eu-S1757720AbZB0HdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720AbZB0HdB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 02:33:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754352AbZB0Hcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 02:32:52 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54431 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276AbZB0Hcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 02:32:51 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Uwe Kleine-Konig <u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH] make CALLER_ADDRx overwriteable
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1235686285-8600-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <alpine.DEB.2.00.0902260857510.26792@gandalf.stny.rr.com> <1235686285-8600-1-git-send-email-u.kleine-koenig@pengutronix.de>
Message-Id: <20090227161302.1551.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Fri, 27 Feb 2009 16:32:45 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The current definition of CALLER_ADDRx isn't suitable for all platforms.
> E.g. for ARM __builtin_return_address(N) doesn't work for N > 0 and
> AFAIK for powerpc there are no frame pointers needed to have a working
> __builtin_return_address.  This patch allows defining the CALLER_ADDRx
> macros in <asm/ftrace.h> and let these take precedence.
> 
> Because now <asm/ftrace.h> is included unconditionally in
> <linux/ftrace.h> all archs that don't already had this include get an
> empty one for free.

AFAIK, ia64 also doesn't work for N > 0.
thanks, good patch.



> -#ifdef CONFIG_FRAME_POINTER
> -/* TODO: need to fix this for ARM */
> -# define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
> -# define CALLER_ADDR1 ((unsigned long)__builtin_return_address(1))
> -# define CALLER_ADDR2 ((unsigned long)__builtin_return_address(2))
> -# define CALLER_ADDR3 ((unsigned long)__builtin_return_address(3))
> -# define CALLER_ADDR4 ((unsigned long)__builtin_return_address(4))
> -# define CALLER_ADDR5 ((unsigned long)__builtin_return_address(5))
> -# define CALLER_ADDR6 ((unsigned long)__builtin_return_address(6))
> -#else
> -# define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
> -# define CALLER_ADDR1 0UL
> -# define CALLER_ADDR2 0UL
> -# define CALLER_ADDR3 0UL
> -# define CALLER_ADDR4 0UL
> -# define CALLER_ADDR5 0UL
> -# define CALLER_ADDR6 0UL
> -#endif
> +#ifndef CALLER_ADDR0

but I think this "#ifndef CALLER_ADDR0" don't explain developer intention at all.
ARCH_HAS_XXXXX macro is better?

I would like to hear another developer opinions.


> +# ifdef CONFIG_FRAME_POINTER
> +#  define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
> +#  define CALLER_ADDR1 ((unsigned long)__builtin_return_address(1))
> +#  define CALLER_ADDR2 ((unsigned long)__builtin_return_address(2))
> +#  define CALLER_ADDR3 ((unsigned long)__builtin_return_address(3))
> +#  define CALLER_ADDR4 ((unsigned long)__builtin_return_address(4))
> +#  define CALLER_ADDR5 ((unsigned long)__builtin_return_address(5))
> +#  define CALLER_ADDR6 ((unsigned long)__builtin_return_address(6))
> +# else
> +#  define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
> +#  define CALLER_ADDR1 0UL
> +#  define CALLER_ADDR2 0UL
> +#  define CALLER_ADDR3 0UL
> +#  define CALLER_ADDR4 0UL
> +#  define CALLER_ADDR5 0UL
> +#  define CALLER_ADDR6 0UL
> +# endif
> +#endif /* ifndef CALLER_ADDR0 */





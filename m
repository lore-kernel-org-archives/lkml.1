Return-Path: <linux-kernel-owner+w=401wt.eu-S1764602AbYD3TEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764602AbYD3TEJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 15:04:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764338AbYD3TDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 15:03:52 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:47921 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764310AbYD3TDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 15:03:51 -0400
Date: Wed, 30 Apr 2008 22:03:07 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch] inlining: do not allow gcc below version 4 to optimize
	inlining
Message-ID: <20080430190307.GC29330@cs181133002.pp.htv.fi>
References: <20080429221530.GA11398@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080429221530.GA11398@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 12:15:31AM +0200, Ingo Molnar wrote:
> 
> fix the condition to match intention: always use the old inlining 
> behavior on all gcc versions below 4.
> 
> this should solve the UML build problem.

You reported this problem.

Does it fix the problem you reported or not?

> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  include/linux/compiler-gcc.h |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> Index: linux-x86.q/include/linux/compiler-gcc.h
> ===================================================================
> --- linux-x86.q.orig/include/linux/compiler-gcc.h
> +++ linux-x86.q/include/linux/compiler-gcc.h
> @@ -29,10 +29,11 @@
>    BUILD_BUG_ON_ZERO(__builtin_types_compatible_p(typeof(a), typeof(&a[0])))
>  
>  /*
> - * Force always-inline if the user requests it so via the .config:
> + * Force always-inline if the user requests it so via the .config,
> + * or if gcc is too old:
>   */
>  #if !defined(CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING) || \
> -    !defined(CONFIG_OPTIMIZE_INLINING) && (__GNUC__ >= 4)

One moment.

Let me try to understand what we currently have in the tree.

This *always* enables the so called "optimized inlining" for the older 
compilers we did *not* wanted to have this for.

Even with CONFIG_OPTIMIZE_INLINING=n .

How was this reviewed and tested?

> +    !defined(CONFIG_OPTIMIZE_INLINING) || (__GNUC__ < 4)
>  # define inline		inline		__attribute__((always_inline))
>  # define __inline__	__inline__	__attribute__((always_inline))
>  # define __inline	__inline	__attribute__((always_inline))

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


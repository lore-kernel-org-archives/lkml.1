Return-Path: <linux-kernel-owner+w=401wt.eu-S1758402AbYB2G56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758402AbYB2G56 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 01:57:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753748AbYB2G5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 01:57:49 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:39093 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753699AbYB2G5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 01:57:49 -0500
Date: Fri, 29 Feb 2008 08:56:30 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Olaf Hering <olaf@aepfle.de>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: undefined references to __udivdi3 on powerpc
Message-ID: <20080229065630.GA16851@cs181133002.pp.htv.fi>
References: <20080228133718.GA8383@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080228133718.GA8383@aepfle.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 02:37:18PM +0100, Olaf Hering wrote:
> 
> While debugging __divdi3 calls in drivers/crypto/hifn_795x.c (due to the
> ndelay() delay call with a s64), I found even more breakage of that
> sort. This is after a allnoconfig with ARCH=powerpc in 2.6.25-rc3,
> plus CONFIG_MODULES=y and CONFIG_CRYPTO_DEV_HIFN_795X=y:
> 
>   LD      .tmp_vmlinux1
>   kernel/built-in.o: In function `update_xtime_cache':
>   (.text+0x221a0): undefined reference to `__umoddi3'
>   kernel/built-in.o: In function `update_xtime_cache':
>   (.text+0x221c0): undefined reference to `__udivdi3'
>   kernel/built-in.o: In function `getnstimeofday':
>   (.text+0x22330): undefined reference to `__umoddi3'
>   kernel/built-in.o: In function `getnstimeofday':
>   (.text+0x22350): undefined reference to `__udivdi3'
>   kernel/built-in.o: In function `timekeeping_resume':
>   timekeeping.c:(.text+0x226a0): undefined reference to `__udivdi3'
>   timekeeping.c:(.text+0x22778): undefined reference to `__umoddi3'
>   timekeeping.c:(.text+0x22798): undefined reference to `__udivdi3'
>   kernel/built-in.o: In function `update_wall_time':
>   (.text+0x22c7c): undefined reference to `__umoddi3'
>   kernel/built-in.o: In function `update_wall_time':
>   (.text+0x22c9c): undefined reference to `__udivdi3'
>   kernel/built-in.o: In function `update_wall_time':
>   (.text+0x230f8): undefined reference to `__umoddi3'
>   kernel/built-in.o: In function `update_wall_time':
>   (.text+0x23118): undefined reference to `__udivdi3'
>   kernel/built-in.o: In function `do_settimeofday':
>   (.text+0x23520): undefined reference to `__udivdi3'
>   kernel/built-in.o: In function `timekeeping_init':
>   (.init.text+0x1870): undefined reference to `__udivdi3'
>   make[1]: *** [.tmp_vmlinux1] Error 1
> 
> But its not a regression, 2.6.24 allnoconfig does not link either on
> powerpc32. 
>...

You didn't mention your gcc version, but you should only get these 
errors when using the not yet released gcc 4.3.

And this issue is known for at about half a year.

> Olaf

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


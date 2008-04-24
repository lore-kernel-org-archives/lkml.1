Return-Path: <linux-kernel-owner+w=401wt.eu-S1762547AbYDXQB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762547AbYDXQB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 12:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757545AbYDXQBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 12:01:48 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:40055 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757024AbYDXQBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 12:01:47 -0400
Date: Thu, 24 Apr 2008 19:01:01 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Joe Perches <joe@perches.com>
Subject: Re: [PATCH] x86: Fix non-kernel use of include/linux/types.h
Message-ID: <20080424160101.GA18854@cs181133002.pp.htv.fi>
References: <200804250114.38971.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200804250114.38971.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2008 at 01:14:38AM +1000, Rusty Russell wrote:
> In file included from ../../include/linux/if_tun.h:21,
>                  from lguest.c:30:
> ../../include/linux/types.h:203: error: expected specifier-qualifier-list before ‘__kernel_daddr_t’
> 
> This reversion was created by e40c0fe6b0b5dd16aec3c0dad311d36b19d78fd9
> 'x86: cleanup duplicate includes' which removed the !__KERNEL__ case from
> asm-x86/posix_types.h.

I'd actually prefer my patch [1] that:
- reverts to the 2.6.24 status quo since we shouldn't leak CONFIG_* to
  userspace at all and
- also fixes the same regression in unistd.h

> CC: Joe Perches <joe@perches.com>
> ---
>  include/asm-x86/posix_types.h |   10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff -r c06e2499a606 include/asm-x86/posix_types.h
> --- a/include/asm-x86/posix_types.h	Tue Apr 22 07:59:24 2008 +1000
> +++ b/include/asm-x86/posix_types.h	Tue Apr 22 08:59:18 2008 +1000
> @@ -1,7 +1,5 @@
> -#ifdef __KERNEL__
> -# if defined(CONFIG_X86_32) || defined(__i386__)
> -#  include "posix_types_32.h"
> -# else
> -#  include "posix_types_64.h"
> -# endif
> +#if defined(CONFIG_X86_32) || defined(__i386__)
> +# include "posix_types_32.h"
> +#else
> +# include "posix_types_64.h"
>  #endif

cu
Adrian

[1] http://lkml.org/lkml/2008/4/20/181

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


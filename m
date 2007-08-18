Return-Path: <linux-kernel-owner+w=401wt.eu-S1757987AbXHRUlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987AbXHRUlU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 16:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbXHRUlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 16:41:10 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:58765 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751877AbXHRUlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 16:41:09 -0400
Date: Sat, 18 Aug 2007 22:40:34 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Christoph Lameter <clameter@sgi.com>, takata@linux-m32r.org,
       linux-m32r@ml.linux-m32r.org
Subject: Re: [patch 11/23] Fix m32r __xchg
Message-ID: <20070818204034.GC32595@stusta.de>
References: <20070812145434.520271946@polymtl.ca> <20070812145838.903282535@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070812145838.903282535@polymtl.ca>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12, 2007 at 10:54:45AM -0400, Mathieu Desnoyers wrote:
> the #endif  /* CONFIG_SMP */ should cover the default condition, or it may cause
> bad parameter to be silently missed.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: takata@linux-m32r.org
> CC: linux-m32r@ml.linux-m32r.org
> ---
>  include/asm-m32r/system.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6-lttng/include/asm-m32r/system.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/asm-m32r/system.h	2007-08-07 14:55:02.000000000 -0400
> +++ linux-2.6-lttng/include/asm-m32r/system.h	2007-08-07 14:57:57.000000000 -0400
> @@ -189,9 +189,9 @@ __xchg(unsigned long x, volatile void * 
>  #endif	/* CONFIG_CHIP_M32700_TS1 */
>  		);
>  		break;
> +#endif  /* CONFIG_SMP */
>  	default:
>  		__xchg_called_with_bad_pointer();
> -#endif  /* CONFIG_SMP */
>  	}
>  
>  	local_irq_restore(flags);


It seems you never checked whether your patch compiles:

<--  snip  -->

...
  CC      init/main.o
In file included from include2/asm/bitops.h:16,
                 from /home/bunk/linux/kernel-2.6/linux-2.6.23-rc2-mm2/include/linux/bitops.h:9,
                 from /home/bunk/linux/kernel-2.6/linux-2.6.23-rc2-mm2/include/linux/kernel.h:15,
                 from include2/asm/processor.h:16,
                 from /home/bunk/linux/kernel-2.6/linux-2.6.23-rc2-mm2/include/linux/prefetch.h:14,
                 from /home/bunk/linux/kernel-2.6/linux-2.6.23-rc2-mm2/include/linux/list.h:8,
                 from /home/bunk/linux/kernel-2.6/linux-2.6.23-rc2-mm2/include/linux/module.h:9,
                 from /home/bunk/linux/kernel-2.6/linux-2.6.23-rc2-mm2/init/main.c:13:
include2/asm/system.h: In function '__xchg':
include2/asm/system.h:191: error: implicit declaration of function '__xchg_called_with_bad_pointer'
make[2]: *** [init/main.o] Error 1

<--  snip  -->


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


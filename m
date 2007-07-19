Return-Path: <linux-kernel-owner+w=401wt.eu-S936422AbXGSFbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936422AbXGSFbn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 01:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933020AbXGSFa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 01:30:56 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46629 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932756AbXGSFay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 01:30:54 -0400
Date: Wed, 18 Jul 2007 22:30:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>
Subject: Re: Powerpc - Include pagemap.h in asm/powerpc/tlb.h
Message-Id: <20070718223034.7388e59f.akpm@linux-foundation.org>
In-Reply-To: <20070714012033.GC31649@Krystal>
References: <20070714012033.GC31649@Krystal>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2007 21:20:33 -0400 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Powerpc - Include pagemap.h in asm/powerpc/tlb.h
> 
> Fixes this powerpc build error in 2.6.22-rc6-mm1 for powerpc 64 :
> 
> In file included from include2/asm/tlb.h:60,
>                  from /home/compudj/git/linux-2.6-lttng/arch/powerpc/mm/init_64.
> c:56:
> /home/compudj/git/linux-2.6-lttng/include/asm-generic/tlb.h: In function 'tlb_fl
> ush_mmu':
> /home/compudj/git/linux-2.6-lttng/include/asm-generic/tlb.h:76: error: implicit 
> declaration of function 'release_pages'
> /home/compudj/git/linux-2.6-lttng/include/asm-generic/tlb.h: In function 'tlb_re
> move_page':
> /home/compudj/git/linux-2.6-lttng/include/asm-generic/tlb.h:105: error: implicit
>  declaration of function 'page_cache_release'

You have some wordwrapping going on there.

> make[2]: *** [arch/powerpc/mm/init_64.o] Error 1
> 
> release_pages is declared in linux/pagemap.h, but cannot be included in
> linux/swap.h because of a sparc related comment:
> 
> /* only sparc can not include linux/pagemap.h in this file
>  * so leave page_cache_release and release_pages undeclared... */
> #define free_page_and_swap_cache(page) \
>         page_cache_release(page)
> #define free_pages_and_swap_cache(pages, nr) \
>         release_pages((pages), (nr), 0);

It's always a worry when this happens.  What change made us need this
inclusion?  How come you're hitting it but I (and test.kernel.org, at least)
did not?  How come so few other architectures include pagemap.h from
asm/tlb.h?  Why do header files get into such a mess?


> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: linuxppc-dev@ozlabs.org
> CC: Paul Mackerras <paulus@samba.org>
> ---
>  include/asm-powerpc/tlb.h |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: linux-2.6-lttng/include/asm-powerpc/tlb.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/asm-powerpc/tlb.h	2007-07-13 11:30:54.000000000 -0400
> +++ linux-2.6-lttng/include/asm-powerpc/tlb.h	2007-07-13 11:31:22.000000000 -0400
> @@ -23,6 +23,8 @@
>  #include <asm/mmu.h>
>  #endif
>  
> +#include <linux/pagemap.h>
> +
>  struct mmu_gather;
>  

Oh well.  I queued it up for someone else to worry over ;)


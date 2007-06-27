Return-Path: <linux-kernel-owner+w=401wt.eu-S1763952AbXF0XJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763952AbXF0XJk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 19:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762567AbXF0XJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 19:09:31 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53263 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753518AbXF0XJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 19:09:30 -0400
Date: Wed, 27 Jun 2007 16:09:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Adrian Bunk <bunk@stusta.de>, paulus@samba.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: mm snapshot broken-out-2007-06-27-03-28.tar.gz uploaded
Message-Id: <20070627160908.fe9052e4.akpm@linux-foundation.org>
In-Reply-To: <200706280057.07481.m.kozlowski@tuxland.pl>
References: <200706271030.l5RAUgKE015163@imap1.linux-foundation.org>
	<200706280057.07481.m.kozlowski@tuxland.pl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2007 00:57:07 +0200
Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:

> Hello,
> 
> 	Build problems on iMac G3.
> 
> 1) allnoconfig results in this:
> 
>  CC      arch/powerpc/mm/tlb_32.o
> In file included from include/asm/tlb.h:60,
>                  from arch/powerpc/mm/tlb_32.c:30:
> include/asm-generic/tlb.h: In function 'tlb_flush_mmu':
> include/asm-generic/tlb.h:76: error: implicit declaration of function 'release_pages'
> include/asm-generic/tlb.h: In function 'tlb_remove_page':
> include/asm-generic/tlb.h:105: error: implicit declaration of function 'page_cache_release'
> make[1]: *** [arch/powerpc/mm/tlb_32.o] Blad 1
> make: *** [arch/powerpc/mm] Blad 2
> 
> 
> The patch below fixes that for me.
> 
> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
> 
>  arch/powerpc/mm/tlb_32.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- linux-2.6.22-rc6-bo-a/arch/powerpc/mm/tlb_32.c	2007-06-27 23:38:49.000000000 +0200
> +++ linux-2.6.22-rc6-bo-b/arch/powerpc/mm/tlb_32.c	2007-06-27 23:18:05.000000000 +0200
> @@ -26,6 +26,8 @@
>  #include <linux/mm.h>
>  #include <linux/init.h>
>  #include <linux/highmem.h>
> +#include <linux/pagemap.h>
> +
>  #include <asm/tlbflush.h>
>  #include <asm/tlb.h>

OK.
  
> 
> 
> 2) These are conflicts introduced by kernel-sys_nic-should-include-linux-syscallsh.patch
> 
>   CC      kernel/sys_ni.o
> kernel/sys_ni.c:16: error: conflicting types for 'sys_nfsservctl'
> include/linux/syscalls.h:497: error: previous declaration of 'sys_nfsservctl' was here
> kernel/sys_ni.c:17: error: conflicting types for 'sys_quotactl'

erk, I suspect that's unfixable, or not worth fixing.

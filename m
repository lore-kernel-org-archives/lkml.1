Return-Path: <linux-kernel-owner+w=401wt.eu-S1754828AbXF3HQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828AbXF3HQv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 03:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754305AbXF3HQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 03:16:41 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:45295 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754269AbXF3HQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 03:16:38 -0400
Date: Sat, 30 Jun 2007 09:17:44 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: git-commits-head@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: Re: [SPARC64]: Add linux/pagemap.h to asm/tlb.h
Message-ID: <20070630071744.GB21610@uranus.ravnborg.org>
References: <200706300459.l5U4xCK2003821@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706300459.l5U4xCK2003821@hera.kernel.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 30, 2007 at 04:59:12AM +0000, Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=9f462a1a5de06503fd247186b91d4205ac1cf1ba
> Commit:     9f462a1a5de06503fd247186b91d4205ac1cf1ba
> Parent:     a357b8f42e7b85e2522c3ad2b29b685bc28743b4
> Author:     Alexey Dobriyan <adobriyan@sw.ru>
> AuthorDate: Thu Jun 28 21:25:31 2007 -0700
> Committer:  David S. Miller <davem@davemloft.net>
> CommitDate: Thu Jun 28 21:25:31 2007 -0700
> 
>     [SPARC64]: Add linux/pagemap.h to asm/tlb.h
>     
>     As seen on sparc64-allnoconfig:
>     
>       CC      arch/sparc64/mm/tlb.o
>     In file included from arch/sparc64/mm/tlb.c:19:
>     include/asm/tlb.h: In function 'tlb_flush_mmu':
>     include/asm/tlb.h:60: warning: implicit declaration of function 'release_pages'
>     include/asm/tlb.h: In function 'tlb_remove_page':
>     include/asm/tlb.h:92: warning: implicit declaration of function 'page_cache_release'
>     
>     Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  include/asm-sparc64/tlb.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/asm-sparc64/tlb.h b/include/asm-sparc64/tlb.h
> index 7af1e11..349d1d3 100644
> --- a/include/asm-sparc64/tlb.h
> +++ b/include/asm-sparc64/tlb.h
> @@ -2,6 +2,7 @@
>  #define _SPARC64_TLB_H
>  
>  #include <linux/swap.h>
> +#include <linux/pagemap.h>
>  #include <asm/pgalloc.h>
>  #include <asm/tlbflush.h>
>  #include <asm/mmu_context.h>


How is the guideline these days?
If a header file exists in both linux/ and asm-$(ARCH)/ then always
include the linux/ veriant??

If this is the guideline then the better fix would be to let tlb.c
include the linux/ variant.

But I dunno - it seems to be a bit inconsistent.

	Sam

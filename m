Return-Path: <linux-kernel-owner+w=401wt.eu-S1757255AbYGZSIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255AbYGZSIL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 14:08:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbYGZSH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 14:07:57 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:44369 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170AbYGZSH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 14:07:57 -0400
Date: Sat, 26 Jul 2008 21:07:24 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] linux/swap.h must #include <linux/pagemap.h>
Message-ID: <20080726180724.GF9301@cs181140183.pp.htv.fi>
References: <1217092685-15267-1-git-send-email-haavard.skinnemoen@atmel.com> <20080726173832.GE9301@cs181140183.pp.htv.fi> <87tzecy1ar.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87tzecy1ar.fsf@saeurebad.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2008 at 07:59:08PM +0200, Johannes Weiner wrote:
> Hi,
> 
> Adrian Bunk <bunk@kernel.org> writes:
> 
> > On Sat, Jul 26, 2008 at 07:18:05PM +0200, Haavard Skinnemoen wrote:
> >> This fixes the following compile error on avr32, introduced by
> >> commit ba92a43dbaee339cf5915ef766d3d3ffbaaf103c
> >> (exec: remove some includes):
> >> 
> >> In file included from include/asm/tlb.h:24,
> >>                  from fs/exec.c:55:
> >> include/asm-generic/tlb.h: In function 'tlb_flush_mmu':
> >> include/asm-generic/tlb.h:76: error: implicit declaration of function 'release_pages'
> >> include/asm-generic/tlb.h: In function 'tlb_remove_page':
> >> include/asm-generic/tlb.h:105: error: implicit declaration of function 'page_cache_release'
> >> make[1]: *** [fs/exec.o] Error 1
> >> 
> >> Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
> >> ---
> >>  include/asm-generic/tlb.h |    1 +
> >>  1 files changed, 1 insertions(+), 0 deletions(-)
> >> 
> >> diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
> >> index f490e43..f85f3a2 100644
> >> --- a/include/asm-generic/tlb.h
> >> +++ b/include/asm-generic/tlb.h
> >> @@ -13,6 +13,7 @@
> >>  #ifndef _ASM_GENERIC__TLB_H
> >>  #define _ASM_GENERIC__TLB_H
> >>  
> >> +#include <linux/pagemap.h>
> >>  #include <linux/swap.h>
> >>  #include <asm/pgalloc.h>
> >>  #include <asm/tlbflush.h>
> >
> > The patch is not the correct fix since the actual problem comes from 
> > free_pages_and_swap_cache() in swap.h
> >
> > Patch is below, but it has not yet gotten enough testing that I'm 100% 
> > confident it doesn't break anything else...
> 
> There is a comment about sparc and linux/pagemap.h in linux/swap.h.

Damn, this trap strikes again.

So Haavard's patch is actually the best available solution.

> Adrian, do you cross-compile for sparc?
>...

Sure, I wouldn't touch generic headers without testing whether it 
breaks any defconfig.

I knew why I was saying "Patch is below, but it has not yet gotten 
enough testing that I'm 100% confident it doesn't break anything 
else..." - I was simply not yet through with the compilations.

> 	Hannes

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


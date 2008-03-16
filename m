Return-Path: <linux-kernel-owner+w=401wt.eu-S1752818AbYCPMrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818AbYCPMrm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 08:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751813AbYCPMrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 08:47:33 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:41331 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754AbYCPMrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 08:47:32 -0400
Date: Sun, 16 Mar 2008 14:47:19 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: sparclinux@vger.kernel.org, Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: only sparc can not include linux/pagemap.h?
Message-ID: <20080316124719.GD4902@cs181133002.pp.htv.fi>
References: <Pine.LNX.4.64.0803161317470.7207@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0803161317470.7207@anakin>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 16, 2008 at 01:22:22PM +0100, Geert Uytterhoeven wrote:
> When trying to compile a m68k kernel with CONFIG_SWAP=n (e.g. allnoconfig), I'm
> bitten by:
> 
>     include/asm-generic/tlb.h: In function 'tlb_flush_mmu':
>     include/asm-generic/tlb.h:76: error: implicit declaration of function 'release_pages'
>     include/asm-generic/tlb.h: In function 'tlb_remove_page':
>     include/asm-generic/tlb.h:105: error: implicit declaration of function 'page_cache_release'
> 
> because include/linux/swap.h defines free_page_and_swap_cache() and
> free_pages_and_swap_cache() to page_cache_release() resp. release_pages()
> without including <linux/pagemap.h>.
> 
> include/linux/swap.h has a comment that says:
> 
>     /* only sparc can not include linux/pagemap.h in this file
>      * so leave page_cache_release and release_pages undeclared... */
>     #define free_page_and_swap_cache(page) \
> 	    page_cache_release(page)
>     #define free_pages_and_swap_cache(pages, nr) \
> 	    release_pages((pages), (nr), 0);
> 
> Is this comment still true?
>...

Yes, see http://lkml.org/lkml/2008/1/31/268

> Thanks!
> 
> Gr{oetje,eeting}s,
> 
> 						Geert

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


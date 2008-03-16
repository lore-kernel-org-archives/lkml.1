Return-Path: <linux-kernel-owner+w=401wt.eu-S1752968AbYCPMWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968AbYCPMWd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 08:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751718AbYCPMW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 08:22:26 -0400
Received: from nelson.telenet-ops.be ([195.130.133.66]:52169 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbYCPMWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 08:22:25 -0400
Date: Sun, 16 Mar 2008 13:22:22 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: sparclinux@vger.kernel.org
cc: Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: only sparc can not include linux/pagemap.h?
Message-ID: <Pine.LNX.4.64.0803161317470.7207@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When trying to compile a m68k kernel with CONFIG_SWAP=n (e.g. allnoconfig), I'm
bitten by:

    include/asm-generic/tlb.h: In function 'tlb_flush_mmu':
    include/asm-generic/tlb.h:76: error: implicit declaration of function 'release_pages'
    include/asm-generic/tlb.h: In function 'tlb_remove_page':
    include/asm-generic/tlb.h:105: error: implicit declaration of function 'page_cache_release'

because include/linux/swap.h defines free_page_and_swap_cache() and
free_pages_and_swap_cache() to page_cache_release() resp. release_pages()
without including <linux/pagemap.h>.

include/linux/swap.h has a comment that says:

    /* only sparc can not include linux/pagemap.h in this file
     * so leave page_cache_release and release_pages undeclared... */
    #define free_page_and_swap_cache(page) \
	    page_cache_release(page)
    #define free_pages_and_swap_cache(pages, nr) \
	    release_pages((pages), (nr), 0);

Is this comment still true?

If not, I'd like to add

    #include <linux/pagemap.h>

to the !CONFIG_SWAP section of include/linux/swap.h.

If yes, would it be acceptible/work to add

    #ifndef CONFIG_SWAP
    #include <linux/pagemap.h>
    #endif

at the top of include/asm-generic/tlb.h?

Thanks!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

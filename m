Return-Path: <linux-kernel-owner+w=401wt.eu-S1758134AbZE0D7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134AbZE0D7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 23:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756297AbZE0D7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 23:59:03 -0400
Received: from sh.osrg.net ([192.16.179.4]:44985 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756476AbZE0D7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 23:59:02 -0400
Date: Wed, 27 May 2009 12:58:46 +0900
To: arnd@arndb.de
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] asm-generic: add a dma-mapping.h file
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <200905261335.41643.arnd@arndb.de>
References: <200905221705.54426.arnd@arndb.de>
	<20090526122423S.fujita.tomonori@lab.ntt.co.jp>
	<200905261335.41643.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090527125801B.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 27 May 2009 12:58:47 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 May 2009 13:35:41 +0100
Arnd Bergmann <arnd@arndb.de> wrote:

> On Tuesday 26 May 2009, FUJITA Tomonori wrote:
> > > dma_get_cache_alignment() is still less generic than
> > > the other functions, as this is still architecture
> > > specific. Should I leave that out as well then?
> > 
> > Yes, I think that only adding generic functions is a better
> > approach. Overriding with #ifdef is really ugly.
> > 
> 
> Ok, will do.
> 
> [trimming Cc list a bit, as the subject has changed]
> 
> Could you be more specific as to why you think the #ifdef
> in this file is ugly? I agree that we should always avoid
> #ifdef in a device driver file or around the usage of an
> API, but we use it everywhere when defining an optional

Seems that people think regard #ifdef in *.c bad, I think.


> API, e.g.
> 
> #ifdef CONFIG_DMA_API_DEBUG
> extern void dma_debug_add_bus(struct bus_type *bus);
> #else
> static inline void dma_debug_add_bus(struct bus_type *bus)
> {
> {
> #endif

This example is inappropriate; a different way to use #ifdef.

This just ensures that dma_debug_add_bus() is available even if
CONFIG_DMA_API_DEBUG is disabled.

It's completely different from a way how you use #ifdef.


> #ifndef clear_user_highpage
> static inline void clear_user_highpage(struct page *page, unsigned long vaddr)
> {
> 	void *addr = kmap_atomic(page, KM_USER0);
> 	clear_user_page(addr, vaddr, page);
> 	kunmap_atomic(addr, KM_USER0);
> }
> #endif

#define clear_user_highpage(page,vaddr)		\
	 __cpu_clear_user_highpage(page, vaddr)

Personally, I don't fancy this style but it's a matter of taste, I
guess.


> This has always made a lot of sense to me when you are defining
> something that you want to become a No-op in certain configurations
> or that only needs special handling in a few cases. IIRC, Linus
> has stated that he prefers the second of the two styles above when
> you have the choice, which is why I started out that way, while
> for the dma_debug stuff, the CONFIG_ symbol clearly makes sense.
> 
> 	Arnd <><
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

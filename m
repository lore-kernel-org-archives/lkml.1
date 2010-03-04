Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017Ab0CDQob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 11:44:31 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53940 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755759Ab0CDQoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 11:44:30 -0500
Date: Thu, 4 Mar 2010 16:44:16 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC PATCH] ARM: Assume new page cache pages have dirty D-cache
Message-ID: <20100304164416.GD13417@n2100.arm.linux.org.uk>
References: <20100302172947.27766.61539.stgit@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100302172947.27766.61539.stgit@e102109-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 02, 2010 at 05:34:29PM +0000, Catalin Marinas wrote:
> There are places in Linux where writes to newly allocated page cache
> pages happen without a subsequent call to flush_dcache_page() (several
> PIO drivers including USB HCD). This patch changes the meaning of
> PG_arch_1 to be PG_dcache_clean and always flush the D-cache for a newly
> mapped page in update_mmu_cache().
> 
> The patch also sets the PG_arch_1 bit in the DMA cache maintenance
> function to avoid additional cache flushing in update_mmu_cache().
...
>  arch/arm/include/asm/cacheflush.h |    6 +++---
>  arch/arm/mm/copypage-v6.c         |    2 +-
>  arch/arm/mm/dma-mapping.c         |    5 +++++
>  arch/arm/mm/fault-armv.c          |    2 +-
>  arch/arm/mm/flush.c               |    2 +-
>  5 files changed, 11 insertions(+), 6 deletions(-)

Could you please send for RFC a fuller patch which covers all places that
PG_dcache_dirty is used and/or mentioned?

$ grep PG_dcache_dirty arch/arm -r
arch/arm/mm/copypage-v6.c:      if (test_and_clear_bit(PG_dcache_dirty, &from->flags))
arch/arm/mm/fault-armv.c: *  1. If PG_dcache_dirty is set for the page, we need to ensure
arch/arm/mm/fault-armv.c:       if (test_and_clear_bit(PG_dcache_dirty, &page->flags))
arch/arm/mm/flush.c:            set_bit(PG_dcache_dirty, &page->flags);
arch/arm/mm/copypage-v4mc.c:    if (test_and_clear_bit(PG_dcache_dirty, &from->flags))
arch/arm/mm/copypage-xscale.c:  if (test_and_clear_bit(PG_dcache_dirty, &from->flags))
arch/arm/include/asm/tlbflush.h: * if PG_dcache_dirty is set for the page, we need to ensure that any
arch/arm/include/asm/cacheflush.h:#define PG_dcache_dirty PG_arch_1

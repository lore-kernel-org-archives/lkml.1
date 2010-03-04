Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab0CDR2L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 12:28:11 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55726 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932149Ab0CDR2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 12:28:09 -0500
Subject: Re: [RFC PATCH] ARM: Assume new page cache pages have dirty D-cache
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <20100304164416.GD13417@n2100.arm.linux.org.uk>
References: <20100302172947.27766.61539.stgit@e102109-lin.cambridge.arm.com>
	 <20100304164416.GD13417@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Thu, 04 Mar 2010 17:27:55 +0000
Message-ID: <1267723675.6526.493.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Mar 2010 17:27:55.0761 (UTC) FILETIME=[06EA3E10:01CABBC0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-04 at 16:44 +0000, Russell King - ARM Linux wrote:
> On Tue, Mar 02, 2010 at 05:34:29PM +0000, Catalin Marinas wrote:
> > There are places in Linux where writes to newly allocated page cache
> > pages happen without a subsequent call to flush_dcache_page() (several
> > PIO drivers including USB HCD). This patch changes the meaning of
> > PG_arch_1 to be PG_dcache_clean and always flush the D-cache for a newly
> > mapped page in update_mmu_cache().
> >
> > The patch also sets the PG_arch_1 bit in the DMA cache maintenance
> > function to avoid additional cache flushing in update_mmu_cache().
> ...
> >  arch/arm/include/asm/cacheflush.h |    6 +++---
> >  arch/arm/mm/copypage-v6.c         |    2 +-
> >  arch/arm/mm/dma-mapping.c         |    5 +++++
> >  arch/arm/mm/fault-armv.c          |    2 +-
> >  arch/arm/mm/flush.c               |    2 +-
> >  5 files changed, 11 insertions(+), 6 deletions(-)
> 
> Could you please send for RFC a fuller patch which covers all places that
> PG_dcache_dirty is used and/or mentioned?

Ah, I thought the compilation would find them but I was wrong. I'll
repost.

-- 
Catalin


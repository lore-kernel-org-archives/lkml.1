Return-Path: <linux-kernel-owner+w=401wt.eu-S1760071AbZE1Hpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760071AbZE1Hpz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 03:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757177AbZE1Hpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 03:45:31 -0400
Received: from sh.osrg.net ([192.16.179.4]:32830 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754354AbZE1Hpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 03:45:30 -0400
Date: Thu, 28 May 2009 16:44:57 +0900
To: akpm@linux-foundation.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tony.luck@intel.com, linux-ia64@vger.kernel.org, arnd@arndb.de,
       joerg.roedel@amd.com
Subject: Re: [PATCH -tip 2/5] x86: use asm-generic/dma-mapping-common.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090528002032.737f3e67.akpm@linux-foundation.org>
References: <1242359705-2117-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1242359705-2117-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<20090528002032.737f3e67.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090528164515P.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 28 May 2009 16:44:58 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 May 2009 00:20:32 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 15 May 2009 12:55:02 +0900 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Acked-by: Joerg Roedel <joerg.roedel@amd.com>
> >
> > ...
> >
> >  /* Make sure we keep the same behaviour */
> >  static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
> >  {
> > @@ -53,178 +55,6 @@ extern int dma_set_mask(struct device *dev, u64 mask);
> >  extern void *dma_generic_alloc_coherent(struct device *dev, size_t size,
> >  					dma_addr_t *dma_addr, gfp_t flag);
> >  
> > -static inline dma_addr_t
> > -dma_map_single(struct device *hwdev, void *ptr, size_t size,
> > -	       enum dma_data_direction dir)
> > -{
> > -	struct dma_map_ops *ops = get_dma_ops(hwdev);
> > -	dma_addr_t addr;
> > -
> > -	kmemcheck_mark_initialized(ptr, size);
> 
> This patch attempts to delete kmemcheck stuff which isn't presently in
> linux-next.

kmemcheck_mark stuff is in the tip tree (this patchset is against the
tip tree).

I rework on this patchset against -mm if you merge all the patches.


> 
> So I went ahead and ported the patch, but it'll break if/when kmemcheck
> returns.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab0CBOGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 09:06:44 -0500
Received: from sh.osrg.net ([192.16.179.4]:46117 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753223Ab0CBOGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 09:06:43 -0500
Date: Tue, 2 Mar 2010 23:06:34 +0900
To: davem@davemloft.net
Cc: arnd@arndb.de, fujita.tomonori@lab.ntt.co.jp, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc: use asm-generic/scatterlist.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100302.055534.115500087.davem@davemloft.net>
References: <20100302224858G.fujita.tomonori@lab.ntt.co.jp>
	<201003021454.12125.arnd@arndb.de>
	<20100302.055534.115500087.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100302230613A.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 02 Mar 2010 23:06:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Mar 2010 05:55:34 -0800 (PST)
David Miller <davem@davemloft.net> wrote:

> From: Arnd Bergmann <arnd@arndb.de>
> Date: Tue, 2 Mar 2010 14:54:11 +0100
> 
> > Broken in the sense that arch/powerpc/Kconfig describes CONFIG_IOMMU_VMERGE:
> > 
> >        Cause IO segments sent to a device for DMA to be merged virtually
> >        by the IOMMU when they happen to have been allocated contiguously.
> >        This doesn't add pressure to the IOMMU allocator. However, some
> >        drivers don't support getting large merged segments coming back
> >        from *_map_sg().
> > 
> >        Most drivers don't have this problem; it is safe to say Y here.
> > 
> > I don't know if this comment still applies to any drivers in the mainline
> > kernel, but it's possible.
> 
> That really has to be out of date these days.

Yeah, I think so.

I added dma_get_max_seg_size() several years ago so that device drives
can tell IOMMU about the maximum segment length that they can
handle. And the default limit (64K) should work for everyone, I think.

I guess that the comment was written when IOMMU was able to merge as
many segments as possible with ignoring the device limitation.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab0CBMZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 07:25:40 -0500
Received: from sh.osrg.net ([192.16.179.4]:55502 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518Ab0CBMZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 07:25:39 -0500
Date: Tue, 2 Mar 2010 21:25:29 +0900
To: arnd@arndb.de
Cc: fujita.tomonori@lab.ntt.co.jp, davem@davemloft.net,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc: use asm-generic/scatterlist.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <201003021303.26064.arnd@arndb.de>
References: <201003011229.51399.arnd@arndb.de>
	<20100302123326H.fujita.tomonori@lab.ntt.co.jp>
	<201003021303.26064.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100302212513N.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 02 Mar 2010 21:25:30 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Mar 2010 13:03:25 +0100
Arnd Bergmann <arnd@arndb.de> wrote:

> On Tuesday 02 March 2010, FUJITA Tomonori wrote:
> > If we go with such approach, then we could use something like the
> > following. There are only two kinds of scatterlist definitions (use
> > dma_length or not) so we can cover all the architectures.
> > 
> > diff --git a/include/asm-generic/scatterlist.h b/include/asm-generic/scatterlist.h
> > index 8b94544..1bf620d 100644
> > --- a/include/asm-generic/scatterlist.h
> > +++ b/include/asm-generic/scatterlist.h
> > @@ -11,7 +11,9 @@ struct scatterlist {
> >         unsigned int    offset;
> >         unsigned int    length;
> >         dma_addr_t      dma_address;
> > +#ifdef CONFIG_NEED_SG_DMA_LENGTH
> >         unsigned int    dma_length;
> > +#endif
> >  };
> 
> Yes, that sounds good. If the only reason to need dma_length is virtual merging,
> a clearer (from the Kconfig perspective, not from the implementation) name 
> might be CONFIG_HAVE_IOMMU_VMERGE, similar to the CONFIG_IOMMU_VMERGE option
> on PPC64 that determines the default for the virtual merging runtime option.

Yeah, but IIRC, Alpha, x86_64 GART, parisc, and IA64 don't have
CONFIG_ option for IOMMU virtual merging. I prefer to avoid to adding
something like CONFIG_HAVE_IOMMU_VMERGE for them. If we add
CONFIG_HAVE_IOMMU_VMERGE to them, it's a bit strange not to add the
feature to disable virtual merging for them (I guess GART already has
the feature though).

Actually, I want to use dma_length on all the architectures (if nobody
complains).

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab0CBNyY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 08:54:24 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:50908 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214Ab0CBNyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 08:54:22 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] sparc: use asm-generic/scatterlist.h
Date: Tue, 2 Mar 2010 14:54:11 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: davem@davemloft.net, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <201003021303.26064.arnd@arndb.de> <201003021438.32144.arnd@arndb.de> <20100302224858G.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100302224858G.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003021454.12125.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18cG1/H/4W/TlEOYlhIDwf+1ENDb5rpQbU28O/
 47QRGUiPZdae43CM4mREJU3IrMhssqTub7e1psRo7gJEGkW/4v
 EX5eiJHJIx6woYKZe7uRQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 March 2010, FUJITA Tomonori wrote:
> On Tue, 2 Mar 2010 14:38:31 +0100
> Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > On Tuesday 02 March 2010, FUJITA Tomonori wrote:
> > > Yeah, but IIRC, Alpha, x86_64 GART, parisc, and IA64 don't have
> > > CONFIG_ option for IOMMU virtual merging. I prefer to avoid to adding
> > > something like CONFIG_HAVE_IOMMU_VMERGE for them. If we add
> > > CONFIG_HAVE_IOMMU_VMERGE to them, it's a bit strange not to add the
> > > feature to disable virtual merging for them (I guess GART already has
> > > the feature though).
> > 
> > While I think the runtime feature (actually a workaround for broken device
> > drivers)
> 
> What does "broken device drivers" mean here?

Broken in the sense that arch/powerpc/Kconfig describes CONFIG_IOMMU_VMERGE:

       Cause IO segments sent to a device for DMA to be merged virtually
       by the IOMMU when they happen to have been allocated contiguously.
       This doesn't add pressure to the IOMMU allocator. However, some
       drivers don't support getting large merged segments coming back
       from *_map_sg().

       Most drivers don't have this problem; it is safe to say Y here.

I don't know if this comment still applies to any drivers in the mainline
kernel, but it's possible.

	Arnd

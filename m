Return-Path: <linux-kernel-owner+w=401wt.eu-S1759467AbYCDJCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759467AbYCDJCn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 04:02:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbYCDJC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 04:02:28 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:44251 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbYCDJC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 04:02:27 -0500
Date: Tue, 4 Mar 2008 09:02:20 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
Subject: Re: drivers/net/wireless/b43legacy/ on mips
Message-ID: <20080304090220.GA2875@linux-mips.org>
References: <20080303233651.82c592a4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080303233651.82c592a4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2008 at 11:36:51PM -0800, Andrew Morton wrote:

> ERROR: "__ucmpdi2" [drivers/net/wireless/b43legacy/b43legacy.ko] undefined!
> ERROR: "__ucmpdi2" [drivers/net/wireless/b43/b43.ko] undefined!
> 
> int b43legacy_dma_init(struct b43legacy_wldev *dev)
> {
>         struct b43legacy_dma *dma = &dev->dma;
>         struct b43legacy_dmaring *ring;
>         int err;
>         u64 dmamask;
>         enum b43legacy_dmatype type;
> 
>         dmamask = supported_dma_mask(dev);
>         switch (dmamask) {
>         default:
>                 B43legacy_WARN_ON(1);
>         case DMA_30BIT_MASK:
>                 type = B43legacy_DMA_30BIT;
>                 break;
>         case DMA_32BIT_MASK:
>                 type = B43legacy_DMA_32BIT;
>                 break;
>         case DMA_64BIT_MASK:
>                 type = B43legacy_DMA_64BIT;
>                 break;
>         }
> 
> because some versions of gcc emit a __ucmpdi2 call for switch statements. 

Was this when optimizing for size btw?  It seems gcc is emitting alot more
calls to libgcc when optimizing for size.

> It might be fixable by switching to an open-coded if/compare/else sequence.

It was just a EXPORT_SYMBOL(__ucmpdi2) missing.

> Or maybe my mips compiler (gcc-3.4.5) is just too old..

I'm trying to keep the tools requirements the same as for x86.  So for
32-bit kernels gcc 3.2 is the minimum but 3.2 is broken beyond recovery
for 64-bit code so there a minimum of 3.3 is required.

In practive it is ages that I've last seen a compiler older than gcc 3.4
being used to build a modern kernel for any architecture and 3.2 and 3.3
are a sufficient special case that maybe we should think about deprecating
3.2 and 3.3?

  Ralf

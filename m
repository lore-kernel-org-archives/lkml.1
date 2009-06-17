Return-Path: <linux-kernel-owner+w=401wt.eu-S1762875AbZFQAVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762875AbZFQAVO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 20:21:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757560AbZFQAVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 20:21:00 -0400
Received: from gate.crashing.org ([63.228.1.57]:43296 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756297AbZFQAVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 20:21:00 -0400
Subject: Re: PowerPC PCI DMA issues (prefetch/coherency?)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Scott Wood <scottwood@freescale.com>,
       Chris Pringle <chris.pringle@oxtel.com>, linuxppc-dev@lists.ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200906162002.12376.arnd@arndb.de>
References: <4A37A503.3030209@oxtel.com> <200906161943.38764.arnd@arndb.de>
	 <4A37DB0F.7060801@freescale.com>  <200906162002.12376.arnd@arndb.de>
Content-Type: text/plain
Date: Wed, 17 Jun 2009 10:18:45 +1000
Message-Id: <1245197925.21602.0.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-16 at 20:02 +0200, Arnd Bergmann wrote:
> On Tuesday 16 June 2009, Scott Wood wrote:
> > > If the
> > > device is the only one, you can also use dma_alloc_noncoherent() and
> > > flush explicitly with dma_cache_sync().
> > 
> > I don't see how that would help -- aren't those also controlled by 
> > CONFIG_NOT_COHERENT_CACHE?
> 
> Ah, yes you are right. PowerPC implements dma_alloc_noncoherent as
> dma_alloc_coherent, so dma_cache_sync() is actually a NOP (or should be).

But we still need to sync the result of dma_map_* when used multiple
times for a single mapping.

Cheers,
Ben.

> Actually there seems to be a bug in here: Since dma_alloc_noncoherent
> gives you a coherent mapping (or NULL) on noncoherent machines,
> dma_cache_sync() is redundant and should not actually flush the
> cache, or we should change dma_alloc_noncoherent to do a simple
> alloc_pages on CONFIG_NON_COHERENT_CACHE and leave dma_cache_sync()
> as it is.
> 
> 	Arnd <><
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev


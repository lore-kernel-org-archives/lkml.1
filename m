Return-Path: <linux-kernel-owner+w=401wt.eu-S1753321AbZFHIXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbZFHIXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 04:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752493AbZFHIXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 04:23:09 -0400
Received: from sh.osrg.net ([192.16.179.4]:35347 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482AbZFHIXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 04:23:09 -0400
Date: Mon, 8 Jun 2009 17:23:04 +0900
To: arnd@arndb.de
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH] asm-generic: add dma-mapping-linear.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <200906081003.59171.arnd@arndb.de>
References: <200906041747.04310.arnd@arndb.de>
	<20090608144921R.fujita.tomonori@lab.ntt.co.jp>
	<200906081003.59171.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090608172200A.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 08 Jun 2009 17:23:04 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Jun 2009 10:03:58 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> On Monday 08 June 2009, FUJITA Tomonori wrote:
> > 
> > > However, I don't think I have the energy to fix this problem, but
> > > I agree that it should be fixed eventually. I can leave out
> > > the declarations of dma_{free,alloc}_coherent from dma-mapping-linear.h
> > > so that the broken code remains in the architecture specific
> > > files, and change all references to dma_cache_sync to something
> > > else. The best I can think of is __dma_cache_sync() with the same
> > > calling conventions as dma_cache_sync(). Does that make sense?
> > 
> > Sorry, but it doesn't make sense to me because __dma_cache_sync() hack
> > is against the goal of dma-mapping-linear.h, having a clean, ideal,
> > unified header file.
> 
> Do you have any other suggestion? The operation that an architecture
> performs to synchronize the DMA buffer after a DMA is just not generic
> and needs to have some name that we can call from the generic file.
> Right now we use one of dma_cache_sync, frv_cache_wback_inv,
> mn10300_dcache_flush_inv or consistent_sync for this and I was just
> looking for a new internal name for this operation.

If you don't clean up them, I think that it's better to leave out
asm-generic/dma-generic-linear.h for
now. asm-generic/dma-generic-linear.h is supposed to clean up the
mess; unify (generalize, or fix) some architecture. It's not supported
to add another temporary hack that should be removed.

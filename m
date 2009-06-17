Return-Path: <linux-kernel-owner+w=401wt.eu-S1761398AbZFQAlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761398AbZFQAlq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 20:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbZFQAlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 20:41:39 -0400
Received: from sh.osrg.net ([192.16.179.4]:32820 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbZFQAli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 20:41:38 -0400
Date: Wed, 17 Jun 2009 09:37:14 +0900
To: benh@kernel.crashing.org
Cc: arnd@arndb.de, scottwood@freescale.com, chris.pringle@oxtel.com,
       linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: PowerPC PCI DMA issues (prefetch/coherency?)
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1245197925.21602.0.camel@pasglop>
References: <4A37DB0F.7060801@freescale.com>
	<200906162002.12376.arnd@arndb.de>
	<1245197925.21602.0.camel@pasglop>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090617093654B.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 17 Jun 2009 09:37:15 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jun 2009 10:18:45 +1000
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Tue, 2009-06-16 at 20:02 +0200, Arnd Bergmann wrote:
> > On Tuesday 16 June 2009, Scott Wood wrote:
> > > > If the
> > > > device is the only one, you can also use dma_alloc_noncoherent() and
> > > > flush explicitly with dma_cache_sync().
> > > 
> > > I don't see how that would help -- aren't those also controlled by 
> > > CONFIG_NOT_COHERENT_CACHE?
> > 
> > Ah, yes you are right. PowerPC implements dma_alloc_noncoherent as
> > dma_alloc_coherent, so dma_cache_sync() is actually a NOP (or should be).
> 
> But we still need to sync the result of dma_map_* when used multiple
> times for a single mapping.

We have dma_sync_{single|sg}_for_{cpu|device} API for the above
purpose.

dma_cache_sync is supposed to be used only with the buffers that
dma_alloc_noncoherent() returns. On architecutures that maps
dma_alloc_noncoherent to dma_alloc_coherent, dma_cache_sync() is
supposed to be NOP.

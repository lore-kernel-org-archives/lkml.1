Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178Ab0CCDsl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 22:48:41 -0500
Received: from sh.osrg.net ([192.16.179.4]:35924 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266Ab0CCDsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 22:48:40 -0500
Date: Wed, 3 Mar 2010 12:47:11 +0900
To: benh@kernel.crashing.org
Cc: catalin.marinas@arm.com, fujita.tomonori@lab.ntt.co.jp,
       mdharm-kernel@one-eyed-alien.net, oliver@neukum.org,
       linux@arm.linux.org.uk, greg@kroah.com, x0082077@ti.com,
       sshtylyov@ru.mvista.com, bigeasy@linutronix.de,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       James.Bottomley@HansenPartnership.com, santosh.shilimkar@ti.com,
       pavel@ucw.cz, tom.leiming@gmail.com,
       linux-arm-kernel@lists.infradead.org
Subject: Re: USB mass storage and ARM cache coherency
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1267572594.2173.25.camel@pasglop>
References: <20100302211049V.fujita.tomonori@lab.ntt.co.jp>
	<1267549527.15401.78.camel@e102109-lin.cambridge.arm.com>
	<1267572594.2173.25.camel@pasglop>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100303124624Z.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 03 Mar 2010 12:47:17 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Mar 2010 10:29:54 +1100
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Tue, 2010-03-02 at 17:05 +0000, Catalin Marinas wrote:
> 
> > The viable solutions so far:
> > 
> >      1. Implement a PIO mapping API similar to the DMA API which takes
> >         care of the D-cache flushing. This means that PIO drivers would
> >         need to be modified to use an API like pio_kmap()/pio_kunmap()
> >         before writing to a page cache page.
> >      2. Invert the meaning of PG_arch_1 to denote a clean page. This
> >         means that by default newly allocated page cache pages are
> >         considered dirty and even if there isn't a call to
> >         flush_dcache_page(), update_mmu_cache() would flush the D-cache.
> >         This is the PowerPC approach.
> 
> I don't see the point of a "PIO" API. I would thus vote for 2 :-) Note

Yeah, as powerpc and ia64 do, arm can flush D cache and invalidate I
cache when inserting a executable page to pte, IIUC. No need for the
new API for I/D consistency.

The ways to improve the approach (introducing PG_arch_2 or marking a
page clean on dma_unmap_* with DMA_FROM_DEVICE like ia64 does) is up
to architectures.

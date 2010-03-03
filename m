Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab0CCKn5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 05:43:57 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:32963 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752809Ab0CCKn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 05:43:56 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Catalin Marinas <catalin.marinas@arm.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: benh@kernel.crashing.org, mdharm-kernel@one-eyed-alien.net,
       oliver@neukum.org, linux@arm.linux.org.uk, greg@kroah.com,
       x0082077@ti.com, sshtylyov@ru.mvista.com, bigeasy@linutronix.de,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       James.Bottomley@HansenPartnership.com, santosh.shilimkar@ti.com,
       pavel@ucw.cz, tom.leiming@gmail.com,
       linux-arm-kernel@lists.infradead.org
In-Reply-To: <20100303124624Z.fujita.tomonori@lab.ntt.co.jp>
References: <20100302211049V.fujita.tomonori@lab.ntt.co.jp>
	 <1267549527.15401.78.camel@e102109-lin.cambridge.arm.com>
	 <1267572594.2173.25.camel@pasglop>
	 <20100303124624Z.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Wed, 03 Mar 2010 10:43:53 +0000
Message-ID: <1267613033.15589.58.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Mar 2010 10:43:54.0761 (UTC) FILETIME=[6BBD6F90:01CABABE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-03 at 03:47 +0000, FUJITA Tomonori wrote:
> On Wed, 03 Mar 2010 10:29:54 +1100
> Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> 
> > On Tue, 2010-03-02 at 17:05 +0000, Catalin Marinas wrote:
> >
> > > The viable solutions so far:
> > >
> > >      1. Implement a PIO mapping API similar to the DMA API which takes
> > >         care of the D-cache flushing. This means that PIO drivers would
> > >         need to be modified to use an API like pio_kmap()/pio_kunmap()
> > >         before writing to a page cache page.
> > >      2. Invert the meaning of PG_arch_1 to denote a clean page. This
> > >         means that by default newly allocated page cache pages are
> > >         considered dirty and even if there isn't a call to
> > >         flush_dcache_page(), update_mmu_cache() would flush the D-cache.
> > >         This is the PowerPC approach.
> >
> > I don't see the point of a "PIO" API. I would thus vote for 2 :-) Note
> 
> Yeah, as powerpc and ia64 do, arm can flush D cache and invalidate I
> cache when inserting a executable page to pte, IIUC. No need for the
> new API for I/D consistency.

I can see that IA-64 uses the PG_arch_1 bit to mark a clean page rather
than dirty (as we did for ARM). The Documentation/cachetlb.txt needs
updating.

Thanks.

-- 
Catalin


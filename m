Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302Ab0CBX3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:29:30 -0500
Received: from gate.crashing.org ([63.228.1.57]:51647 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754183Ab0CBX3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:20 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@HansenPartnership.com, linux@arm.linux.org.uk,
       catalin.marinas@arm.com, mdharm-kernel@one-eyed-alien.net,
       linux-usb@vger.kernel.org, x0082077@ti.com, sshtylyov@ru.mvista.com,
       tom.leiming@gmail.com, bigeasy@linutronix.de, oliver@neukum.org,
       linux-kernel@vger.kernel.org, santosh.shilimkar@ti.com, pavel@ucw.cz,
       greg@kroah.com, linux-arm-kernel@lists.infradead.org
In-Reply-To: <20100302211049V.fujita.tomonori@lab.ntt.co.jp>
References: <20100226210030.GC23933@n2100.arm.linux.org.uk>
	 <1267316072.23523.1842.camel@pasglop>
	 <1267333263.2762.11.camel@mulgrave.site>
	 <20100302211049V.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Mar 2010 10:26:56 +1100
Message-ID: <1267572416.2173.22.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-02 at 21:11 +0900, FUJITA Tomonori wrote:
> 
> > Sorry to be a bit late to the party (on holiday), but I/D coherency
> is
> > supposed to be taken care of using flush_cache_page in the memory
> > mapping routines.
> 
> powerpc does that? To be exact, powerpc doesn't need
> flush_cache_page() and handles I/D coherency in the pte modification
> code. powerpc uses PG_arch_1 to avoid unnecessarily handling I/D
> coherency. Seems that IA64 does the same trick with PG_arch_1.

Right. We set PG_arch_1 to avoid doing it again of a given physical
page. We assume that it's always cleared when a page is recycled by the
page cache and we also clear it in flush_dcache_page() though the need
for that later thing is dubious...

Cheers,
Ben.



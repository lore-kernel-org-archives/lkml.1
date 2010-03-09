Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599Ab0CICaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 21:30:25 -0500
Received: from gate.crashing.org ([63.228.1.57]:48474 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756573Ab0CICaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 21:30:20 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Pavel Machek <pavel@ucw.cz>, Catalin Marinas <catalin.marinas@arm.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       mdharm-kernel@one-eyed-alien.net, linux-usb@vger.kernel.org,
       x0082077@ti.com, sshtylyov@ru.mvista.com, tom.leiming@gmail.com,
       bigeasy@linutronix.de, oliver@neukum.org, linux-kernel@vger.kernel.org,
       santosh.shilimkar@ti.com, greg@kroah.com,
       linux-arm-kernel@lists.infradead.org
In-Reply-To: <1267933038.2812.12.camel@mulgrave.site>
References: <20100226210030.GC23933@n2100.arm.linux.org.uk>
	 <1267316072.23523.1842.camel@pasglop>
	 <1267333263.2762.11.camel@mulgrave.site>
	 <20100302211049V.fujita.tomonori@lab.ntt.co.jp>
	 <1267549527.15401.78.camel@e102109-lin.cambridge.arm.com>
	 <20100303215437.GF2579@ucw.cz>
	 <1267709756.6526.380.camel@e102109-lin.cambridge.arm.com>
	 <20100304135128.GA12191@atrey.karlin.mff.cuni.cz>
	 <1267712512.31654.176.camel@mulgrave.site>
	 <20100304142704.GB6622@n2100.arm.linux.org.uk>
	 <1267872443.8894.1443.camel@mulgrave.site>
	 <1267909429.22204.127.camel@pasglop>
	 <1267933038.2812.12.camel@mulgrave.site>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Mar 2010 13:25:14 +1100
Message-ID: <1268101514.22204.137.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-03-07 at 09:07 +0530, James Bottomley wrote:
> So, assuming full congruence of user space, can't you use the VMA as an
> indicator?  i.e. if we have no user space mappings, we have to flush the
> icache ... if we have one or more, the icache has been flushed and
> placing the same page congruently in a different address space benefits
> from that prior flush, so consequently there's no need to flush again?

the VMA ? Or you mean struct page -> mapping ? That would work I suppose
in the case where we want to flush the icache pages for all pages mapped
into user space. But on processors that support per-page execute
permission, we really only want to flush pages that are executed from
(lazily). In that case, we do need a dedicated bit to keep track of
whether a given page has been flushed already.

> I also think we've established the relevant facts for the I/O thread
> (that we only need to either flush the kernel D cache or mark it as to
> be flushed later on PIO reads).  We're now into deep technicalities of
> how the mm system operates at the architecture level, so perhaps we
> should move this to linux-arch? 

No objection though moving threads after the fact is a recipe for
trouble :-)

Cheers,
Ben.



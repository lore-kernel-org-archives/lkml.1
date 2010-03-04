Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab0CDSHd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 13:07:33 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59478 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751146Ab0CDSHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 13:07:31 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Catalin Marinas <catalin.marinas@arm.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Pavel Machek <pavel@ucw.cz>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       benh@kernel.crashing.org, linux@arm.linux.org.uk,
       mdharm-kernel@one-eyed-alien.net, linux-usb@vger.kernel.org,
       x0082077@ti.com, sshtylyov@ru.mvista.com, tom.leiming@gmail.com,
       bigeasy@linutronix.de, oliver@neukum.org, linux-kernel@vger.kernel.org,
       santosh.shilimkar@ti.com, greg@kroah.com,
       linux-arm-kernel@lists.infradead.org
In-Reply-To: <20100304154103.GA9384@linux-sh.org>
References: <20100226210030.GC23933@n2100.arm.linux.org.uk>
	 <1267316072.23523.1842.camel@pasglop>
	 <1267333263.2762.11.camel@mulgrave.site>
	 <20100302211049V.fujita.tomonori@lab.ntt.co.jp>
	 <1267549527.15401.78.camel@e102109-lin.cambridge.arm.com>
	 <20100303215437.GF2579@ucw.cz>
	 <1267709756.6526.380.camel@e102109-lin.cambridge.arm.com>
	 <20100304135128.GA12191@atrey.karlin.mff.cuni.cz>
	 <1267712512.31654.176.camel@mulgrave.site>
	 <1267716578.6526.483.camel@e102109-lin.cambridge.arm.com>
	 <20100304154103.GA9384@linux-sh.org>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Thu, 04 Mar 2010 18:07:29 +0000
Message-ID: <1267726049.6526.543.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Mar 2010 18:07:30.0449 (UTC) FILETIME=[8E56E010:01CABBC5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-04 at 15:41 +0000, Paul Mundt wrote:
> On Thu, Mar 04, 2010 at 03:29:38PM +0000, Catalin Marinas wrote:
> > On Thu, 2010-03-04 at 14:21 +0000, James Bottomley wrote:
> > > The thing which was discovered in this thread is basically that ARM is
> > > handling deferred flushing (for D/I coherency) in a slightly different
> > > way from everyone else ...
> >
> > Doing a grep for PG_dcache_dirty defined in terms of PG_arch_1 reveals
> > that MIPS, Parisc, Score, SH and SPARC do similar things to ARM. PowerPC
> > and IA-64 use PG_arch_1 as a clean rather than dirty bit.
> 
> SH used to use it as a PG_mapped which was roughly similar to the
> PG_dcache_clean approach, at which point things like flushing for the PIO
> case in the HCD wasn't necessary. It did result in rather aggressive over
> flushing though, which is one of the reasons we elected to switch to
> PG_dcache_dirty.

Are you more in favour if a PIO kmap API than inverting the meaning of
PG_arch_1? 

I'm not familiar with SH but for PIO devices the flushing shouldn't be
more aggressive. For the DMA devices, Russell suggested that we mark the
page as clean (set PG_dcache_clean) in the DMA API to avoid the default
flushing.

> Note that the PG_dcache_dirty semantics are also outlined in
> Documentation/cachetlb.txt for PG_arch_1 usage, so it's hardly esoteric.

Yes, but the flush_dcache_page() semantics outlined in the same file
aren't followed by all the PIO drivers in the kernel.

-- 
Catalin


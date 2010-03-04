Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173Ab0CDPlp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 10:41:45 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:52090 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842Ab0CDPlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 10:41:44 -0500
Date: Fri, 5 Mar 2010 00:41:03 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Pavel Machek <pavel@ucw.cz>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       benh@kernel.crashing.org, linux@arm.linux.org.uk,
       mdharm-kernel@one-eyed-alien.net, linux-usb@vger.kernel.org,
       x0082077@ti.com, sshtylyov@ru.mvista.com, tom.leiming@gmail.com,
       bigeasy@linutronix.de, oliver@neukum.org, linux-kernel@vger.kernel.org,
       santosh.shilimkar@ti.com, greg@kroah.com,
       linux-arm-kernel@lists.infradead.org
Subject: Re: USB mass storage and ARM cache coherency
Message-ID: <20100304154103.GA9384@linux-sh.org>
References: <20100226210030.GC23933@n2100.arm.linux.org.uk> <1267316072.23523.1842.camel@pasglop> <1267333263.2762.11.camel@mulgrave.site> <20100302211049V.fujita.tomonori@lab.ntt.co.jp> <1267549527.15401.78.camel@e102109-lin.cambridge.arm.com> <20100303215437.GF2579@ucw.cz> <1267709756.6526.380.camel@e102109-lin.cambridge.arm.com> <20100304135128.GA12191@atrey.karlin.mff.cuni.cz> <1267712512.31654.176.camel@mulgrave.site> <1267716578.6526.483.camel@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267716578.6526.483.camel@e102109-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 04, 2010 at 03:29:38PM +0000, Catalin Marinas wrote:
> On Thu, 2010-03-04 at 14:21 +0000, James Bottomley wrote:
> > The thing which was discovered in this thread is basically that ARM is
> > handling deferred flushing (for D/I coherency) in a slightly different
> > way from everyone else ... 
> 
> Doing a grep for PG_dcache_dirty defined in terms of PG_arch_1 reveals
> that MIPS, Parisc, Score, SH and SPARC do similar things to ARM. PowerPC
> and IA-64 use PG_arch_1 as a clean rather than dirty bit.
> 
SH used to use it as a PG_mapped which was roughly similar to the
PG_dcache_clean approach, at which point things like flushing for the PIO
case in the HCD wasn't necessary. It did result in rather aggressive over
flushing though, which is one of the reasons we elected to switch to
PG_dcache_dirty.

Note that the PG_dcache_dirty semantics are also outlined in
Documentation/cachetlb.txt for PG_arch_1 usage, so it's hardly esoteric.

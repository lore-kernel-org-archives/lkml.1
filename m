Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab0CDVjp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 16:39:45 -0500
Received: from gate.crashing.org ([63.228.1.57]:36534 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754219Ab0CDVjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 16:39:43 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Paul Mundt <lethal@linux-sh.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Pavel Machek <pavel@ucw.cz>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux@arm.linux.org.uk,
       mdharm-kernel@one-eyed-alien.net, linux-usb@vger.kernel.org,
       x0082077@ti.com, sshtylyov@ru.mvista.com, tom.leiming@gmail.com,
       bigeasy@linutronix.de, oliver@neukum.org, linux-kernel@vger.kernel.org,
       santosh.shilimkar@ti.com, greg@kroah.com,
       linux-arm-kernel@lists.infradead.org
In-Reply-To: <1267726049.6526.543.camel@e102109-lin.cambridge.arm.com>
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
	 <1267726049.6526.543.camel@e102109-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Mar 2010 08:37:40 +1100
Message-ID: <1267738660.22204.77.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-04 at 18:07 +0000, Catalin Marinas wrote:
> 
> Are you more in favour if a PIO kmap API than inverting the meaning of
> PG_arch_1? 

My main worry with this approach is the sheer amount of drivers that
need fixing. I believe inverting PG_arch_1 is a better solution and I
somewhat fail to see how we end up doing too much flushing if we have
per-page execute permission (but maybe SH doesn't ?)

> I'm not familiar with SH but for PIO devices the flushing shouldn't be
> more aggressive. For the DMA devices, Russell suggested that we mark
> the
> page as clean (set PG_dcache_clean) in the DMA API to avoid the
> default
> flushing.

I really like that idea, as I said earlier, but I'm worried about the I$
side of things. IE. What I'm trying to say is that I can't see how to do
that optimisation without ending up with missing I$ invalidations or
doing way too many of them, unless we have a separate bit to track I$
state.

> > Note that the PG_dcache_dirty semantics are also outlined in
> > Documentation/cachetlb.txt for PG_arch_1 usage, so it's hardly
> esoteric.
> 
> Yes, but the flush_dcache_page() semantics outlined in the same file
> aren't followed by all the PIO drivers in the kernel.
> 

Cheers,
Ben.



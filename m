Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab0CDWL7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 17:11:59 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46907 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755435Ab0CDWL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 17:11:58 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Catalin Marinas <catalin.marinas@arm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mundt <lethal@linux-sh.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Pavel Machek <pavel@ucw.cz>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux@arm.linux.org.uk,
       mdharm-kernel@one-eyed-alien.net, linux-usb@vger.kernel.org,
       x0082077@ti.com, sshtylyov@ru.mvista.com, tom.leiming@gmail.com,
       bigeasy@linutronix.de, oliver@neukum.org, linux-kernel@vger.kernel.org,
       santosh.shilimkar@ti.com, greg@kroah.com,
       linux-arm-kernel@lists.infradead.org
In-Reply-To: <1267738660.22204.77.camel@pasglop>
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
	 <1267738660.22204.77.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Thu, 04 Mar 2010 22:11:51 +0000
Message-ID: <1267740711.30572.5.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Mar 2010 22:11:52.0621 (UTC) FILETIME=[B1ACC5D0:01CABBE7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-04 at 21:37 +0000, Benjamin Herrenschmidt wrote:
> On Thu, 2010-03-04 at 18:07 +0000, Catalin Marinas wrote:
> > I'm not familiar with SH but for PIO devices the flushing shouldn't be
> > more aggressive. For the DMA devices, Russell suggested that we mark
> > the page as clean (set PG_dcache_clean) in the DMA API to avoid the
> > default flushing.
> 
> I really like that idea, as I said earlier, but I'm worried about the I$
> side of things. IE. What I'm trying to say is that I can't see how to do
> that optimisation without ending up with missing I$ invalidations or
> doing way too many of them, unless we have a separate bit to track I$
> state.

But does this optimisation really matter? I think with careful checking
in set_pte_at(), you are not going to invalidate the I-cache more than
necessary. If the original page wasn't pte_present() you would need to
do the I-cache invalidation. The other cases where set_pte_at() is
called for LRU (pte_young) or COW (pte_write) we can avoid the extra
invalidation.

-- 
Catalin


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab0CEEgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 23:36:00 -0500
Received: from gate.crashing.org ([63.228.1.57]:42126 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753219Ab0CEEf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 23:35:57 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       mdharm-kernel@one-eyed-alien.net, linux-usb@vger.kernel.org,
       Catalin Marinas <catalin.marinas@arm.com>, x0082077@ti.com,
       sshtylyov@ru.mvista.com, tom.leiming@gmail.com, bigeasy@linutronix.de,
       oliver@neukum.org, linux-kernel@vger.kernel.org,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       santosh.shilimkar@ti.com, Pavel Machek <pavel@ucw.cz>, greg@kroah.com,
       linux-arm-kernel@lists.infradead.org
In-Reply-To: <20100304214030.GI13417@n2100.arm.linux.org.uk>
References: <20100226210030.GC23933@n2100.arm.linux.org.uk>
	 <1267316072.23523.1842.camel@pasglop>
	 <1267333263.2762.11.camel@mulgrave.site>
	 <20100302211049V.fujita.tomonori@lab.ntt.co.jp>
	 <1267549527.15401.78.camel@e102109-lin.cambridge.arm.com>
	 <20100303215437.GF2579@ucw.cz>
	 <1267709756.6526.380.camel@e102109-lin.cambridge.arm.com>
	 <20100304135128.GA12191@atrey.karlin.mff.cuni.cz>
	 <1267712512.31654.176.camel@mulgrave.site>
	 <1267738114.22204.70.camel@pasglop>
	 <20100304214030.GI13417@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Mar 2010 15:31:13 +1100
Message-ID: <1267763473.22204.89.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-04 at 21:40 +0000, Russell King - ARM Linux wrote:
> On Fri, Mar 05, 2010 at 08:28:34AM +1100, Benjamin Herrenschmidt wrote:
> > I don't think there's a core or driver problem in this specific case. As
> > we discussed earlier, I believe the problem is that ARM considers a
> > fresh page out of the page cache as "clean" instead of "dirty", and
> > inverting that like we do on powerpc will fix their problem too.
> 
> The only concern is that it means we treat anonymous pages as dirty
> by default.
>
> That's quite sub-optimal since we take care (eg) on write faults to
> copy the page and take care of the cache issues while we do that -

If you do the cache handling inside your copy_user_highpage() then you
can just set PG_arch_1 stuff there.

> whether that be remapping the page to be coherent with the user
> address, or cleaning each cache line as we copy the data.
> 
> Of course, the simple solution is to also arrange for PG_arch_1 to be
> set in this case.

Right.

Cheers,
Ben.



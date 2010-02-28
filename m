Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030969Ab0B1ATM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 19:19:12 -0500
Received: from gate.crashing.org ([63.228.1.57]:38737 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030952Ab0B1ATL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 19:19:11 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       linux-usb@vger.kernel.org, "Mankad,Maulik Ojas" <x0082077@ti.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>,
       Sebastian Siewior <bigeasy@linutronix.de>,
       Oliver Neukum <oliver@neukum.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Shilimkar,Santosh" <santosh.shilimkar@ti.com>,
       Pavel Machek <pavel@ucw.cz>, Greg KH <greg@kroah.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
In-Reply-To: <20100226210030.GC23933@n2100.arm.linux.org.uk>
References: <1266979632.23523.1668.camel@pasglop>
	 <1267201521.14703.50.camel@e102109-lin.cambridge.arm.com>
	 <20100226210030.GC23933@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 28 Feb 2010 11:14:32 +1100
Message-ID: <1267316072.23523.1842.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-26 at 21:00 +0000, Russell King - ARM Linux wrote:
> On Fri, Feb 26, 2010 at 04:25:21PM +0000, Catalin Marinas wrote:
> > For mmap'ed pages (and present in the page cache), is it guaranteed that
> > the HCD driver won't write to it once it has been mapped into user
> > space? If that's the case, it may solve the problem by just reversing
> > the meaning of PG_arch_1 on ARM and assume that a newly allocated page
> > has dirty D-cache by default.
> 
> I guess we could also set PG_arch_1 in the DMA API as well, to avoid the
> unnecessary D cache flushing when clean pages get mapped into userspace.

That's an interesting thought for us too. When doing I$/D$ coherency, we
have to fist flush the D$ and then invalidate the I$. If we could keep
track of D$ and I$ separately, we could avoid the first step in many
cases, including the DMA API trick you mentioned.

I wonder if it's time to get a PG_arch_2 :-)

Cheers,
Ben.



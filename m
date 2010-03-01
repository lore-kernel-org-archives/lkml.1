Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751119Ab0CAKmi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 05:42:38 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39134 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750767Ab0CAKmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 05:42:36 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Catalin Marinas <catalin.marinas@arm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
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
In-Reply-To: <1267316072.23523.1842.camel@pasglop>
References: <1266979632.23523.1668.camel@pasglop>
	 <1267201521.14703.50.camel@e102109-lin.cambridge.arm.com>
	 <20100226210030.GC23933@n2100.arm.linux.org.uk>
	 <1267316072.23523.1842.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Mon, 01 Mar 2010 10:42:34 +0000
Message-ID: <1267440154.23333.44.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Mar 2010 10:42:35.0361 (UTC) FILETIME=[E7967510:01CAB92B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-02-28 at 00:14 +0000, Benjamin Herrenschmidt wrote:
> On Fri, 2010-02-26 at 21:00 +0000, Russell King - ARM Linux wrote:
> > On Fri, Feb 26, 2010 at 04:25:21PM +0000, Catalin Marinas wrote:
> > > For mmap'ed pages (and present in the page cache), is it guaranteed that
> > > the HCD driver won't write to it once it has been mapped into user
> > > space? If that's the case, it may solve the problem by just reversing
> > > the meaning of PG_arch_1 on ARM and assume that a newly allocated page
> > > has dirty D-cache by default.
> >
> > I guess we could also set PG_arch_1 in the DMA API as well, to avoid the
> > unnecessary D cache flushing when clean pages get mapped into userspace.

That sounds good to me.

> That's an interesting thought for us too. When doing I$/D$ coherency, we
> have to fist flush the D$ and then invalidate the I$. If we could keep
> track of D$ and I$ separately, we could avoid the first step in many
> cases, including the DMA API trick you mentioned.
> 
> I wonder if it's time to get a PG_arch_2 :-)

As an optimisation, I think this would help (rather than always
invalidating the I-cache in update_mmu_cache or set_pte_at).

-- 
Catalin


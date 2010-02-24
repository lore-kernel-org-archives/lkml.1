Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab0BXCty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 21:49:54 -0500
Received: from gate.crashing.org ([63.228.1.57]:44044 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753260Ab0BXCtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 21:49:52 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Greg KH <greg@kroah.com>, "Mankad, Maulik Ojas" <x0082077@ti.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Sebastian Siewior <bigeasy@linutronix.de>, linux-usb@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
       Pavel Machek <pavel@ucw.cz>, Ming Lei <tom.leiming@gmail.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <201002192153.22159.oliver@neukum.org>
References: <1266445892.16346.306.camel@pasglop>
	 <1266599755.32546.38.camel@e102109-lin.cambridge.arm.com>
	 <1266601011.32546.48.camel@e102109-lin.cambridge.arm.com>
	 <201002192153.22159.oliver@neukum.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Feb 2010 13:48:09 +1100
Message-ID: <1266979689.23523.1669.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-19 at 21:53 +0100, Oliver Neukum wrote:
> Am Freitag, 19. Februar 2010 18:36:51 schrieb Catalin Marinas:
> > If a page is already mapped in user space, flush_dcache_page() on ARM
> > does the flushing rather than deferring it to update_mmu_cache(). The
> > PIO HCD drivers, however, don't call flush_dcache_page(). Is it possible
> > that the HCD could transfer data into a page cache page already mapped
> > in user space? My understanding is that the scenario above is possible.
> 
> Yes, video drivers do that. 

In which case it would be up to the video driver to call
flush_dcache_page() (though if it's v4l you are talking about, maybe it
might make sense to push it into the v4l layer itself).

Cheers,
Ben.



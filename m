Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab0BZVFF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 16:05:05 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58641 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814Ab0BZVFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 16:05:02 -0500
Date: Fri, 26 Feb 2010 21:00:30 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
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
Subject: Re: USB mass storage and ARM cache coherency
Message-ID: <20100226210030.GC23933@n2100.arm.linux.org.uk>
References: <1266979632.23523.1668.camel@pasglop> <1267201521.14703.50.camel@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267201521.14703.50.camel@e102109-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 04:25:21PM +0000, Catalin Marinas wrote:
> For mmap'ed pages (and present in the page cache), is it guaranteed that
> the HCD driver won't write to it once it has been mapped into user
> space? If that's the case, it may solve the problem by just reversing
> the meaning of PG_arch_1 on ARM and assume that a newly allocated page
> has dirty D-cache by default.

I guess we could also set PG_arch_1 in the DMA API as well, to avoid the
unnecessary D cache flushing when clean pages get mapped into userspace.

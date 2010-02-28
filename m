Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711Ab0B1XU1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 18:20:27 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:63477 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750994Ab0B1XU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 18:20:26 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       linux-usb@vger.kernel.org, "Mankad, Maulik Ojas" <x0082077@ti.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>,
       Sebastian Siewior <bigeasy@linutronix.de>,
       Oliver Neukum <oliver@neukum.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
       Pavel Machek <pavel@ucw.cz>, Greg KH <greg@kroah.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <20100226220351.GE23933@n2100.arm.linux.org.uk>
References: <1266445892.16346.306.camel@pasglop>
	 <1266599755.32546.38.camel@e102109-lin.cambridge.arm.com>
	 <1266979170.23523.1660.camel@pasglop>
	 <1267202674.14703.70.camel@e102109-lin.cambridge.arm.com>
	 <1267220980.23523.1820.camel@pasglop>
	 <20100226220351.GE23933@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Sun, 28 Feb 2010 23:20:22 +0000
Message-ID: <1267399222.4485.26.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Feb 2010 23:20:24.0710 (UTC) FILETIME=[9B04C260:01CAB8CC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-26 at 22:03 +0000, Russell King - ARM Linux wrote:
> On Sat, Feb 27, 2010 at 08:49:40AM +1100, Benjamin Herrenschmidt wrote:
> > It will deadlock if you use normal IRQs. I don't see a good way around
> > that other than using a higher-level type of IRQs. I though ARM has
> > something like that (FIQs ?). Can you use those guys for IPIs ?
[...]
> The other problem we'd encounter using FIQs for IPIs is that some IPIs
> need to take locks - and in order to make that safe, we'd either need
> another class of locks which disable IRQs and FIQs together, or we'd
> need to disable FIQs everywhere we disable IRQs - at which point FIQs
> become utterly pointless.

You could use the FIQ only for the DMA cache maintenance operations and
not as a generic IPI mechanism. But the hardware needs to be modified.


-- 
Catalin


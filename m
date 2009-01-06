Return-Path: <linux-kernel-owner+w=401wt.eu-S1754868AbZAFJvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbZAFJvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 04:51:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566AbZAFJve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 04:51:34 -0500
Received: from mail.gmx.net ([213.165.64.20]:44732 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751707AbZAFJvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 04:51:33 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/NXEQzaY/NsBmw/MlIyQ5jm6VbsrLhoUeBuYeMAm
	aiawNl/u5ItDlG
Date: Tue, 6 Jan 2009 10:51:37 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@gmail.com, linux-arm-kernel@lists.arm.linux.org.uk,
       Dan Williams <dan.j.williams@intel.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 0/4 v6] i.MX31: dmaengine and framebuffer drivers
In-Reply-To: <20090106090422.GC18861@pengutronix.de>
Message-ID: <Pine.LNX.4.64.0901061021180.5393@axis700.grange>
References: <Pine.LNX.4.64.0812261714290.4895@axis700.grange>
 <20090106090422.GC18861@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sascha

On Tue, 6 Jan 2009, Sascha Hauer wrote:

> Hi Guennadi,
> 
> On Fri, Dec 26, 2008 at 06:11:13PM +0100, Guennadi Liakhovetski wrote:
> > Hi,
> > 
> > This is version 6 of dmaengine and framebuffer drivers for i.MX31.
> > 
> > Changes since version 5: as requested by Sascha Hauer switched to dynamic 
> > IPU IRQ mapping.
> 
> I tried to express that it's really odd that you demux your _internal_
> interrupts as chained handlers.

Your last comment was:

> Preferably a way which does not involve introducing 100+ unused
> interrupts.

which I have done. Now we're back to demux / not demux...

> Consider a network driver which has a
> rx, tx and an error status bit, all of them can trigger an interrupt. A
> you aware of a single driver that uses chained interrupts for this
> case?
> No, they don't have to, because all this happens inside one driver
> and this can easily be dispatched in one interrupt handler. IMHO chained
> interrupts only make sense when you have an interrupt source which
> leaves your driver code and you don't know who might be interested in,
> like the assorted non channel interrupts the IPU also provides.
> 
> I bet you'd never have the idea for such a code design without the
> Freescale code as a sample.

Think about other IPU interrupts. For now I removed the CSI interrupt, but 
it may well be needed at some point. Or any of overflow interrupts? What 
do we do then? Why shall we build in limitations from the beginning, when 
there is an implementation already there, which doesn't have them? Sorry, 
do not understand.

I know you proposed to dispatch all DMA EOF interrupts to one IRQ number 
and (optionally / as required) others to single IRQs. But I like to see 
single DMA sources as separate entries in /proc/interrupts, even if only 
for debugging.

And no, it is not thanks to Freescals code, that I'm doing that, it's more 
contrary to their code - they do not implement an irq_chip API and instead 
add an API of their own.

> Note that arch/arm/plat-mxc/include/mach/mx31.h does not apply anymore
> due to upstream changes.

If we agree on the rest, I'll submit a v7 - updating mx31.h to its current 
state and fixing Kconfig / NR_IRQS.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755243AbYLJNtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbYLJNtW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 08:49:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbYLJNtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 08:49:13 -0500
Received: from mail.gmx.net ([213.165.64.20]:40759 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752947AbYLJNtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 08:49:13 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18YCdUtLU8YWQG2cOv8wgiAqyh1Y07lDJOrEnXq9f
	FdQBz5QM9JMqDD
Date: Wed, 10 Dec 2008 14:49:18 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Dmitry Krivoschekov <dmitry.krivoschekov@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@gmail.com, Sascha Hauer <s.hauer@pengutronix.de>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 2/4 v2] i.MX31: Image Processing Unit DMA and IRQ drivers
In-Reply-To: <493FC389.1010406@gmail.com>
Message-ID: <Pine.LNX.4.64.0812101442110.4578@axis700.grange>
References: <Pine.LNX.4.64.0812101122250.4578@axis700.grange>
 <Pine.LNX.4.64.0812101130400.4578@axis700.grange> <493FC389.1010406@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2008, Dmitry Krivoschekov wrote:

> Hi,
> 
> Guennadi Liakhovetski wrote:
> > From: Guennadi Liakhovetski <lg@denx.de>
> >
> > i.MX3x SoCs contain an Image Processing Unit, consisting of a Control
> > Module (CM), Display Interface (DI), Synchronous Display Controller (SDC),
> > Asynchronous Display Controller (ADC), Image Converter (IC), Post-Filter
> > (PF), Camera Sensor Interface (CSI), and an Image DMA Controller (IDMAC).
> > CM contains, among other blocks, an Interrupt Generator (IG) and a Clock
> > and Reset Control Unit (CRCU). This driver serves IDMAC and IG. They are
> > supported over dmaengine and irq-chip APIs respectively.
> >
> > IDMAC is a specialised DMA controller, its DMA channels cannot be used for
> > general-purpose operations, even though it might be possible to configure
> > a memory-to-memory channel for memcpy operation. This driver will not work
> > with generic dmaengine clients, clients, wishing to use it must use
> > respective wrapper structures, they also must specify which channels they
> > require, as channels are hard-wired to specific IPU functions.
> >
> > Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
> > ---
> >  arch/arm/plat-mxc/include/mach/ipu.h  |  180 ++++
> >  arch/arm/plat-mxc/include/mach/mx31.h |  139 +++-
> >  drivers/mfd/Kconfig                   |   16 +
> >  drivers/mfd/Makefile                  |    4 +-
> >  drivers/mfd/ipu/Makefile              |    5 +
> >  drivers/mfd/ipu/ipu_idmac.c           | 1617 +++++++++++++++++++++++++++++++++
> >  drivers/mfd/ipu/ipu_intern.h          |  172 ++++
> >  drivers/mfd/ipu/ipu_irq.c             |  277 ++++++
> why do you think drivers/mfd is an appropriate location for this driver?
> IPU is on-chip device, but it is not a separate multifunction device so
> it should not be placed in drivers/mfd.
> 
> arch/arm/plat-mxc/ or drivers/video/ipu seem better places for this driver.

I am not sure drivers/mxc is the best place for it, but I am against both 
arch/arm (well, mildly, it is now preferred to put arch-specific drivers 
under drivers/) and drivers/video - I'm going to submit a camera driver 
shortly, which goes under drivers/media/video and will use the ipu driver, 
and should not depend on drivers/video. I was thinking about 
drivers/media/ipu... But eventually decided for mfd as it is 
multifunctional (no, it is not separate, is this a requirement?) - it is 
currently providing an IRQ and a DMA driver. But I don't use the mfd API 
atm. If we decide to keep it there, I can add it, if necessary / if it 
provides any advantages for this case.

In general, I am open to ideas in this respect.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

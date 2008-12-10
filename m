Return-Path: <linux-kernel-owner+w=401wt.eu-S1755740AbYLJN04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740AbYLJN04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 08:26:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbYLJN0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 08:26:46 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:39033 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790AbYLJN0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 08:26:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=TcwlExvVNnZ2MDPbeS+DlUu/Pt/o5nCmZmzOakVptp7aifopul9/HZpstmPBn/f52i
         LKDYXhWgP9RcYh7HPmGXzf9MFW669Gb8T5Xesp6LGdSilIYs8tMGydOUFH/PYAO1ua/C
         TyQwJrRYnMMTiCgkM/Qz6LojYOSj8j7atCHR0=
Message-ID: <493FC389.1010406@gmail.com>
Date: Wed, 10 Dec 2008 16:26:33 +0300
From: Dmitry Krivoschekov <dmitry.krivoschekov@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071114)
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@gmail.com, Sascha Hauer <s.hauer@pengutronix.de>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 2/4 v2] i.MX31: Image Processing Unit DMA and IRQ drivers
References: <Pine.LNX.4.64.0812101122250.4578@axis700.grange> <Pine.LNX.4.64.0812101130400.4578@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0812101130400.4578@axis700.grange>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Guennadi Liakhovetski wrote:
> From: Guennadi Liakhovetski <lg@denx.de>
>
> i.MX3x SoCs contain an Image Processing Unit, consisting of a Control
> Module (CM), Display Interface (DI), Synchronous Display Controller (SDC),
> Asynchronous Display Controller (ADC), Image Converter (IC), Post-Filter
> (PF), Camera Sensor Interface (CSI), and an Image DMA Controller (IDMAC).
> CM contains, among other blocks, an Interrupt Generator (IG) and a Clock
> and Reset Control Unit (CRCU). This driver serves IDMAC and IG. They are
> supported over dmaengine and irq-chip APIs respectively.
>
> IDMAC is a specialised DMA controller, its DMA channels cannot be used for
> general-purpose operations, even though it might be possible to configure
> a memory-to-memory channel for memcpy operation. This driver will not work
> with generic dmaengine clients, clients, wishing to use it must use
> respective wrapper structures, they also must specify which channels they
> require, as channels are hard-wired to specific IPU functions.
>
> Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
> ---
>  arch/arm/plat-mxc/include/mach/ipu.h  |  180 ++++
>  arch/arm/plat-mxc/include/mach/mx31.h |  139 +++-
>  drivers/mfd/Kconfig                   |   16 +
>  drivers/mfd/Makefile                  |    4 +-
>  drivers/mfd/ipu/Makefile              |    5 +
>  drivers/mfd/ipu/ipu_idmac.c           | 1617 +++++++++++++++++++++++++++++++++
>  drivers/mfd/ipu/ipu_intern.h          |  172 ++++
>  drivers/mfd/ipu/ipu_irq.c             |  277 ++++++
why do you think drivers/mfd is an appropriate location for this driver?
IPU is on-chip device, but it is not a separate multifunction device so
it should not be placed in drivers/mfd.

arch/arm/plat-mxc/ or drivers/video/ipu seem better places for this driver.


Dmitry



>  8 files changed, 2408 insertions(+), 2 deletions(-)
>  create mode 100644 arch/arm/plat-mxc/include/mach/ipu.h
>  create mode 100644 drivers/mfd/ipu/Makefile
>  create mode 100644 drivers/mfd/ipu/ipu_idmac.c
>  create mode 100644 drivers/mfd/ipu/ipu_intern.h
>  create mode 100644 drivers/mfd/ipu/ipu_irq.c


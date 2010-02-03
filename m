Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359Ab0BCJpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 04:45:39 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34222 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756820Ab0BCJpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 04:45:34 -0500
Date: Wed, 3 Feb 2010 10:45:32 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Amit Kucheria <amit.kucheria@canonical.com>,
       List Linux Kernel <linux-kernel@vger.kernel.org>,
       linux@arm.linux.org.uk, Dinh.Nguyen@freescale.com,
       grant.likely@secretlab.ca, r.herring@freescale.com,
       linux-arm-kernel@lists.infradead.org, daniel@caiaq.de,
       bryan.wu@canonical.com, valentin.longchamp@epfl.ch
Subject: Re: [PATCHv2 01/11] arm: mxc: TrustZone interrupt controller
	(TZIC) for i.MX5 family
Message-ID: <20100203094532.GM6130@pengutronix.de>
References: <cover.1265173480.git.amit.kucheria@canonical.com> <cover.1265173246.git.amit.kucheria@verdurent.com> <0511204199ab83aed2340e70a4639500c0528dab.1265173480.git.amit.kucheria@canonical.com> <f17812d71002022223jdc0ac5cp5b94928fb45695d6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f17812d71002022223jdc0ac5cp5b94928fb45695d6@mail.gmail.com>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Industrial Linux Solutions Handelsregister:
	Amtsgericht Hildesheim, HRA 2686 Peiner Strasse 6-8, 31137
	Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 10:41:44 up 113 days, 22:30, 55 users,  load average: 3.00, 2.18,
	1.72
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 02, 2010 at 10:23:21PM -0800, Eric Miao wrote:
> Hi Amit,
> 
> Just some nit-picking review comments, see below:
> 
> On Tue, Feb 2, 2010 at 9:16 PM, Amit Kucheria
> <amit.kucheria@canonical.com> wrote:
> > Freescale i.MX51 processor uses a new interrupt controller. Add
> > driver for TrustZone Interrupt Controller
> >
> > Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
> > ---
> >  arch/arm/plat-mxc/Kconfig  |    8 ++
> >  arch/arm/plat-mxc/Makefile |    3 +
> >  arch/arm/plat-mxc/tzic.c   |  182 ++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 193 insertions(+), 0 deletions(-)
> >  create mode 100644 arch/arm/plat-mxc/tzic.c
> >
> > diff --git a/arch/arm/plat-mxc/Kconfig b/arch/arm/plat-mxc/Kconfig
> > index 8b0a1ee..59558c4 100644
> > --- a/arch/arm/plat-mxc/Kconfig
> > +++ b/arch/arm/plat-mxc/Kconfig
> > @@ -62,6 +62,14 @@ config MXC_IRQ_PRIOR
> >          requirements for timing.
> >          Say N here, unless you have a specialized requirement.
> >
> > +config MXC_TZIC
> > +       bool "Enable TrustZone Interrupt Controller"
> > +       depends on ARCH_MX51
> 
> This is the first patch of the base port, yet I cannot find any reference to
> this ARCH_MX51, did you miss something?
> 
> > +       help
> > +         This will be automatically selected for all processors
> > +         containing this interrupt controller.
> > +         Say N here only if you are really sure.
> > +
> >  config MXC_PWM
> >        tristate "Enable PWM driver"
> >        depends on ARCH_MXC
> > diff --git a/arch/arm/plat-mxc/Makefile b/arch/arm/plat-mxc/Makefile
> > index 996cbac..0202ad9 100644
> > --- a/arch/arm/plat-mxc/Makefile
> > +++ b/arch/arm/plat-mxc/Makefile
> > @@ -5,6 +5,9 @@
> >  # Common support
> >  obj-y := irq.o clock.o gpio.o time.o devices.o cpu.o system.o
> >
> > +# MX51 uses the TZIC interrupt controller, older platforms use AVIC (irq.o)
> > +obj-$(CONFIG_MXC_TZIC) += tzic.o
> > +
> >  obj-$(CONFIG_ARCH_MX1) += iomux-mx1-mx2.o dma-mx1-mx2.o
> >  obj-$(CONFIG_ARCH_MX2) += iomux-mx1-mx2.o dma-mx1-mx2.o
> >  obj-$(CONFIG_ARCH_MXC_IOMUX_V3) += iomux-v3.o
> > diff --git a/arch/arm/plat-mxc/tzic.c b/arch/arm/plat-mxc/tzic.c
> > new file mode 100644
> > index 0000000..00cb0ad
> > --- /dev/null
> > +++ b/arch/arm/plat-mxc/tzic.c
> > @@ -0,0 +1,182 @@
> > +/*
> > + * Copyright 2004-2009 Freescale Semiconductor, Inc. All Rights Reserved.
> > + *
> > + * The code contained herein is licensed under the GNU General Public
> > + * License. You may obtain a copy of the GNU General Public License
> > + * Version 2 or later at the following locations:
> > + *
> > + * http://www.opensource.org/licenses/gpl-license.html
> > + * http://www.gnu.org/copyleft/gpl.html
> > + */
> > +
> > +#include <linux/module.h>
> > +#include <linux/moduleparam.h>
> > +#include <linux/init.h>
> > +#include <linux/device.h>
> > +#include <linux/errno.h>
> > +#include <linux/io.h>
> > +
> > +#include <asm/mach/irq.h>
> > +
> > +#include <mach/hardware.h>
> > +
> > +/*
> > + *****************************************
> > + * TZIC Registers                        *
> > + *****************************************
> > + */
> > +
> > +#define TZIC_INTCNTL            0x0000 /* Control register */
> > +#define TZIC_INTTYPE            0x0004 /* Controller Type register */
> > +#define TZIC_IMPID              0x0008 /* Distributor Implementer Identification */
> > +#define TZIC_PRIOMASK           0x000C /* Priority Mask Reg */
> > +#define TZIC_SYNCCTRL           0x0010 /* Synchronizer Control register */
> > +#define TZIC_DSMINT             0x0014 /* DSM interrupt Holdoffregister */
> > +#define TZIC_INTSEC0            0x0080 /* Interrupt Security register 0 */
> > +#define TZIC_ENSET0             0x0100 /* Enable Set Register 0 */
> > +#define TZIC_ENCLEAR0           0x0180 /* Enable Clear Register 0 */
> > +#define TZIC_SRCSET0            0x0200 /* Source Set Register 0 */
> > +#define TZIC_SRCCLAR0           0x0280 /* Source Clear Register 0 */
> > +#define TZIC_PRIORITY0          0x0400 /* Priority Register 0 */
> > +#define TZIC_PND0               0x0D00 /* Pending Register 0 */
> > +#define TZIC_HIPND0             0x0D80 /* High Priority Pending Register */
> > +#define TZIC_WAKEUP0            0x0E00 /* Wakeup Config Register */
> > +#define TZIC_SWINT              0x0F00 /* Software Interrupt Rigger Register */
> > +#define TZIC_ID0                0x0FD0 /* Indentification Register 0 */
> > +
> > +void __iomem *tzic_base;
> 
> This can just be made to 'static' if it's not used elsewhere, and I'm
> wondering if it's neater to define them as:

It is used in entry-macro.S for the irq controller base. We should add a
comment to make this clear.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

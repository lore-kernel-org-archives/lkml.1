Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab0BDRJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:09:22 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:56353 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab0BDRJU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:09:20 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCHv2 01/11] arm: mxc: TrustZone interrupt controller (TZIC) for i.MX5 family
Date: Thu, 4 Feb 2010 10:09:07 -0700
Message-ID: <86A0E76937111F4C92FABEC0A209885104426182@az33exm21>
In-Reply-To: <20100203132404.GC5252@k2>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCHv2 01/11] arm: mxc: TrustZone interrupt controller (TZIC) for i.MX5 family
Thread-Index: Acqk1DGAhUyeYMTuTti7ZjR1/B6SKwA6ER8g
References: <cover.1265173480.git.amit.kucheria@canonical.com> <cover.1265173246.git.amit.kucheria@verdurent.com> <0511204199ab83aed2340e70a4639500c0528dab.1265173480.git.amit.kucheria@canonical.com> <f17812d71002022223jdc0ac5cp5b94928fb45695d6@mail.gmail.com> <20100203132404.GC5252@k2>
From: "Nguyen Dinh-R00091" <R00091@freescale.com>
To: "Amit Kucheria" <amit.kucheria@canonical.com>,
       "Eric Miao" <eric.y.miao@gmail.com>
Cc: "List Linux Kernel" <linux-kernel@vger.kernel.org>,
       <linux@arm.linux.org.uk>, <s.hauer@pengutronix.de>,
       <grant.likely@secretlab.ca>,
       "Herring Robert-RA7055" <RA7055@freescale.com>,
       <linux-arm-kernel@lists.infradead.org>, <daniel@caiaq.de>,
       <bryan.wu@canonical.com>, <valentin.longchamp@epfl.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

-----Original Message-----
From: Amit Kucheria [mailto:amit.kucheria@canonical.com] 
Sent: Wednesday, February 03, 2010 7:24 AM
To: Eric Miao
Cc: List Linux Kernel; linux@arm.linux.org.uk; Nguyen Dinh-R00091; s.hauer@pengutronix.de; grant.likely@secretlab.ca; Herring Robert-RA7055; linux-arm-kernel@lists.infradead.org; daniel@caiaq.de; bryan.wu@canonical.com; valentin.longchamp@epfl.ch
Subject: Re: [PATCHv2 01/11] arm: mxc: TrustZone interrupt controller (TZIC) for i.MX5 family

On 10 Feb 02, Eric Miao wrote:
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
> >  arch/arm/plat-mxc/tzic.c   |  182 
> > ++++++++++++++++++++++++++++++++++++++++++++
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
> This is the first patch of the base port, yet I cannot find any 
> reference to this ARCH_MX51, did you miss something?

ARCH_MX51 is only introduced in the later patches that add the core i.MX5 code. Since TZIC is not inherently dependent on i.MX5 (it's merely the first processor to use it), I thought of splitting it out as a separate patch.

Does this break the sanctity of one self-contained change?

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
> > +# MX51 uses the TZIC interrupt controller, older platforms use AVIC 
> > +(irq.o)
> > +obj-$(CONFIG_MXC_TZIC) += tzic.o
> > +
> >  obj-$(CONFIG_ARCH_MX1) += iomux-mx1-mx2.o dma-mx1-mx2.o
> >  obj-$(CONFIG_ARCH_MX2) += iomux-mx1-mx2.o dma-mx1-mx2.o
> >  obj-$(CONFIG_ARCH_MXC_IOMUX_V3) += iomux-v3.o diff --git 
> > a/arch/arm/plat-mxc/tzic.c b/arch/arm/plat-mxc/tzic.c new file mode 
> > 100644 index 0000000..00cb0ad
> > --- /dev/null
> > +++ b/arch/arm/plat-mxc/tzic.c
> > @@ -0,0 +1,182 @@
> > +/*
> > + * Copyright 2004-2009 Freescale Semiconductor, Inc. All Rights Reserved.
> > + *
> > + * The code contained herein is licensed under the GNU General 
> > +Public
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
> > +#define TZIC_INTTYPE            0x0004 /* Controller Type register 
> > +*/ #define TZIC_IMPID              0x0008 /* Distributor 
> > +Implementer Identification */ #define TZIC_PRIOMASK           
> > +0x000C /* Priority Mask Reg */ #define TZIC_SYNCCTRL           
> > +0x0010 /* Synchronizer Control register */ #define TZIC_DSMINT             
> > +0x0014 /* DSM interrupt Holdoffregister */ #define TZIC_INTSEC0            
> > +0x0080 /* Interrupt Security register 0 */ #define TZIC_ENSET0             
> > +0x0100 /* Enable Set Register 0 */ #define TZIC_ENCLEAR0           
> > +0x0180 /* Enable Clear Register 0 */ #define TZIC_SRCSET0            
> > +0x0200 /* Source Set Register 0 */ #define TZIC_SRCCLAR0           
> > +0x0280 /* Source Clear Register 0 */ #define TZIC_PRIORITY0          
> > +0x0400 /* Priority Register 0 */ #define TZIC_PND0               
> > +0x0D00 /* Pending Register 0 */ #define TZIC_HIPND0             
> > +0x0D80 /* High Priority Pending Register */ #define TZIC_WAKEUP0            
> > +0x0E00 /* Wakeup Config Register */ #define TZIC_SWINT              
> > +0x0F00 /* Software Interrupt Rigger Register */ #define TZIC_ID0                
> > +0x0FD0 /* Indentification Register 0 */
> > +
> > +void __iomem *tzic_base;
> 
> This can just be made to 'static' if it's not used elsewhere, and I'm 
> wondering if it's neater to define them as:
> 
> #define TZIC_INTCNTL		(tzic_base + 0x0000)
> 
> so to make the code below short and handy.

tzic_base is actually used in entry-macro.S in patch 0004. I've tried to follow AVIC's way of doing things.

> > +
> > +/*
> > + * Disable interrupt number "irq" in the TZIC
> 
> I don't think this follows kernel API doc exactly, you may want to 
> have a look into Documentation/kernel-doc-nano-HOWTO.txt.

OK.

> > + *
> > + * @param  irq          interrupt source number  */ static void 
> > +tzic_mask_irq(unsigned int irq) {
> > +       int index, off;
> > +
> > +       index = irq >> 5;
> > +       off = irq & 0x1F;
> > +       __raw_writel(1 << off, tzic_base + TZIC_ENCLEAR0 + (index << 
> > + 2));
> 
> I'll normally define TZIC_ENCLEAR0 then as:
> 
> #define TZIC_ENCLEAR(i)		(0x0180 + ((i) << 2))
> 
> so the above can be written as:
> 
> 	__raw_writel(1 << off, tzic_base + TZIC_ENCLEAR(index));
> 
> or by including tzic_base into TZIC_*, simply as:
> 
> 	__raw_writel(1 << off, TZIC_ENCLEAR(index));

OK.

> > +}
> > +
> > +/*
> > + * Enable interrupt number "irq" in the TZIC
> > + *
> > + * @param  irq          interrupt source number  */ static void 
> > +tzic_unmask_irq(unsigned int irq) {
> > +       int index, off;
> > +
> > +       index = irq >> 5;
> > +       off = irq & 0x1F;
> > +       __raw_writel(1 << off, tzic_base + TZIC_ENSET0 + (index << 
> > +2)); }
> > +
> > +static unsigned int wakeup_intr[4];
> > +
> > +/*
> > + * Set interrupt number "irq" in the TZIC as a wake-up source.
> > + *
> > + * @param  irq          interrupt source number
> > + * @param  enable       enable as wake-up if equal to non-zero
> > + *                     disble as wake-up if equal to zero
> > + *
> > + * @return       This function returns 0 on success.
> > + */
> > +static int tzic_set_wake_irq(unsigned int irq, unsigned int enable) 
> > +{
> > +       unsigned int index, off;
> > +
> > +       index = irq >> 5;
> > +       off = irq & 0x1F;
> > +
> > +       if (index > 3)
> > +               return -EINVAL;
> > +
> > +       if (enable)
> > +               wakeup_intr[index] |= (1 << off);
> > +       else
> > +               wakeup_intr[index] &= ~(1 << off);
> > +
> > +       return 0;
> > +}
> > +
> > +static struct irq_chip mxc_tzic_chip = {
> > +       .name = "MXC_TZIC",
> > +       .ack = tzic_mask_irq,
> > +       .mask = tzic_mask_irq,
> > +       .unmask = tzic_unmask_irq,
> > +       .set_wake = tzic_set_wake_irq, };
> > +
> > +/*
> > + * This function initializes the TZIC hardware and disables all the
> > + * interrupts. It registers the interrupt enable and disable 
> > +functions
> > + * to the kernel for each interrupt source.
> > + */
> > +void __init tzic_init_irq(void __iomem *irqbase) {
> > +       int i;
> > +
> > +       tzic_base = irqbase;
> > +       /* put the TZIC into the reset value with
> > +        * all interrupts disabled
> > +        */
> > +       i = __raw_readl(tzic_base + TZIC_INTCNTL);
> 
> Mixing the use of 'i' as both a signed counter and register value 
> might not be a good idea, provided it's not guaranteed from theory 
> that 'i' as an integer could not be sufficient to hold the value 
> returned from
> __raw_readl()

Fair enough.

> > +
> > +       __raw_writel(0x80010001, tzic_base + TZIC_INTCNTL);
> > +       i = __raw_readl(tzic_base + TZIC_INTCNTL);
> > +       __raw_writel(0x1f, tzic_base + TZIC_PRIOMASK);
> > +       i = __raw_readl(tzic_base + TZIC_PRIOMASK);
> > +       __raw_writel(0x02, tzic_base + TZIC_SYNCCTRL);
> > +       i = __raw_readl(tzic_base + TZIC_SYNCCTRL);
> 
> Are these read-back really necessary? We can start without them and 
> add them later if they do cause issues.

Can anybody from Freescale comment whether the read-back is necessary?

I'll remove it for now to see what happens in my testing.

[Dinh] - This piece of code was taken from our silicon validation code where it was check the values of the read-backs. The read-backs can be removed.

> > +
> > +       for (i = 0; i < 4; i++)
> > +               __raw_writel(0xFFFFFFFF, tzic_base + TZIC_INTSEC0 + 
> > + i * 4);
> > +
> > +       /* disable all interrupts */
> > +       for (i = 0; i < 4; i++)
> > +               __raw_writel(0xFFFFFFFF, tzic_base + TZIC_ENCLEAR0 + 
> > + i * 4);
> > +
> > +       /* all IRQ no FIQ Warning :: No selection */
> > +
> > +       for (i = 0; i < MXC_INTERNAL_IRQS; i++) {
> > +               set_irq_chip(i, &mxc_tzic_chip);
> > +               set_irq_handler(i, handle_level_irq);
> > +               set_irq_flags(i, IRQF_VALID);
> > +       }
> > +
> > +       printk(KERN_INFO "TrustZone Interrupt Controller (TZIC) 
> > + initialized\n");
> 
> You may want to use pr_info() for short.

OK

> > +}
> > +
> > +/*
> > + * enable wakeup interrupt
> > + *
> > + * @param is_idle              1 if called in idle loop (ENSET 
> > +register);
> > + *                             0 to be used when called from low 
> > +power entry
> > + * @return                     0 if successful; non-zero otherwise
> > + *
> > + */
> > +int tzic_enable_wake(int is_idle)
> > +{
> > +       unsigned int i, v;
> > +
> > +       __raw_writel(1, tzic_base + TZIC_DSMINT);
> > +       if (unlikely(__raw_readl(tzic_base + TZIC_DSMINT) == 0))
> > +               return -EAGAIN;
> 
> Looks like an unnecessary read-back provided the silicon is sane enough.

Again, Dinh/Rob can you comment?

[Dinh] - Can be removed.

> > +
> > +       if (likely(is_idle)) {
> > +               for (i = 0; i < 4; i++) {
> > +                       v = __raw_readl(tzic_base + TZIC_ENSET0 + i 
> > + * 4);
> > +                       __raw_writel(v, tzic_base + TZIC_WAKEUP0 + i 
> > + * 4);
> > +               }
> > +       } else {
> > +               for (i = 0; i < 4; i++) {
> > +                       v = wakeup_intr[i];
> > +                       __raw_writel(v, tzic_base + TZIC_WAKEUP0 + i 
> > + * 4);
> > +               }
> > +       }
> 
> Or could be simplified to:
> 
> 	for (i = 0; i < 4; i++) {
> 		v = is_idle ? __raw_readl(TZIC_ENSET(i)) : wakeup_intr[i];
> 		__raw_writel(v, TZIC_WAKEUP(i));
> 	}

OK

> but just nit-picking comments, so it's up to you.
> 
> > +       return 0;
> > +}
> 
> Mmmm.... this being called elsewhere, I'm thinking about making this a 
> sys_device and having this called within sysdev_class.suspend() to 
> make this file rather self-contained.

That is the idea once the base port is upstream.

Thanks for the review.

/Amit
--
----------------------------------------------------------------------
Amit Kucheria, Kernel Engineer || amit.kucheria@canonical.com
----------------------------------------------------------------------


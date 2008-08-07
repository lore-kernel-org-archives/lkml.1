Return-Path: <linux-kernel-owner+w=401wt.eu-S1753475AbYHGNCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbYHGNCX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 09:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbYHGNCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 09:02:15 -0400
Received: from lopsy-lu.misterjones.org ([62.4.18.26]:52474 "EHLO
	young-lust.wild-wind.fr.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750981AbYHGNCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 09:02:14 -0400
Date: Thu, 7 Aug 2008 11:07:20 +0200
From: Marc Zyngier <maz@misterjones.org>
To: "Eric Miao" <eric.y.miao@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       "Amit Walambe" <amit.walambe@eurotech-ltd.co.uk>
Subject: Re: [PATCH 1/5] Basic support for the Arcom/Eurotech Viper SBC.
Message-ID: <20080807110720.1efe0608@not-of-this-earth.wild-wind.fr.eu.org>
In-Reply-To: <f17812d70808062050r2a346b26ie31479b8d008417f@mail.gmail.com>
References: <1218028794-850-1-git-send-email-maz@misterjones.org>
	<37f79c8da83c915c5ecc1d81cad9f4f5ae3c2b4a.1218018636.git.marc.zyngier@altran.com>
	<f17812d70808062050r2a346b26ie31479b8d008417f@mail.gmail.com>
Organization: Metropolis -- Nowhere
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 81.255.32.141
X-SA-Exim-Rcpt-To: eric.y.miao@gmail.com, linux-kernel@vger.kernel.org, amit.walambe@eurotech-ltd.co.uk
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on young-lust.wild-wind.fr.eu.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Aug 2008 11:50:57 +0800
"Eric Miao" <eric.y.miao@gmail.com> wrote:

Eric,

First, thanks for this in-depth review. I strongly agree with most of
your remarks. I just happend to have some questions regarding the
serial stuff:

> > +static struct plat_serial8250_port serial_platform_data[] = {
> > +       /* Internal UARTs */
> > +       {
> > +               .membase        = (void *)&FFUART,
> > +               .mapbase        = __PREG(FFUART),
> > +               .irq            = IRQ_FFUART,
> > +               .uartclk        = 921600 * 16,
> > +               .regshift       = 2,
> > +               .flags          = UPF_BOOT_AUTOCONF | UPF_SKIP_TEST,
> > +               .iotype         = UPIO_MEM,
> > +       },
> > +       {
> > +               .membase        = (void *)&BTUART,
> > +               .mapbase        = __PREG(BTUART),
> > +               .irq            = IRQ_BTUART,
> > +               .uartclk        = 921600 * 16,
> > +               .regshift       = 2,
> > +               .flags          = UPF_BOOT_AUTOCONF | UPF_SKIP_TEST,
> > +               .iotype         = UPIO_MEM,
> > +       },
> > +       {
> > +               .membase        = (void *)&STUART,
> > +               .mapbase        = __PREG(STUART),
> > +               .irq            = IRQ_STUART,
> > +               .uartclk        = 921600 * 16,
> > +               .regshift       = 2,
> > +               .flags          = UPF_BOOT_AUTOCONF | UPF_SKIP_TEST,
> > +               .iotype         = UPIO_MEM,
> > +       },
> > +       /* External UARTs */
> > +       {
> > +               .mapbase        = VIPER_UARTA_PHYS,
> > +               .irq            = VIPER_UARTA_IRQ,
> > +               .uartclk        = 1843200,
> > +               .regshift       = 1,
> > +               .iotype         = UPIO_MEM,
> > +               .flags          = UPF_BOOT_AUTOCONF | UPF_IOREMAP |
> > +                                 UPF_SKIP_TEST,
> > +       },
> > +       {
> > +               .mapbase        = VIPER_UARTB_PHYS,
> > +               .irq            = VIPER_UARTB_IRQ,
> > +               .uartclk        = 1843200,
> > +               .regshift       = 1,
> > +               .iotype         = UPIO_MEM,
> > +               .flags          = UPF_BOOT_AUTOCONF | UPF_IOREMAP |
> > +                                 UPF_SKIP_TEST,
> > +       },
> > +       { },
> > +};
> > +
> > +static struct platform_device serial_device = {
> > +       .name                   = "serial8250",
> > +       .id                     = 0,
> > +       .dev                    = {
> > +               .platform_data  = serial_platform_data,
> > +       },
> > +       .num_resources          =
> > ARRAY_SIZE(viper_serial_resources),
> > +       .resource               = viper_serial_resources,
> > +};
> 
> We now have dedicated pxa serial driver, please use that
> driver for internal UARTs.

- Having both the pxa (for internal UARTs) and 8250 (for external
UARTs) serial drivers have a memory footprint impact. Ok, that's not
much.
- People using their old user-space with a new kernel will see their
serial port names shuffled (going from an all-ttyS? world to a mix of
ttySA? and ttyS?). Is there a way to avoid the confusion?

Thanks again,

	M.
-- 
A rat a day keeps the plague away.

Return-Path: <linux-kernel-owner+w=401wt.eu-S934043AbZJIRrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934043AbZJIRrZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 13:47:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933782AbZJIRrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 13:47:24 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:54624 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933772AbZJIRrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 13:47:22 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+CWTxF8BepWcQk+Ntqf8Cd
Date: Fri, 9 Oct 2009 10:46:36 -0700
From: Tony Lindgren <tony@atomide.com>
To: "G, Manjunath Kondaiah" <manjugk@ti.com>
Cc: Govindraj <govindraj.ti@gmail.com>,
       "Raja, Govindraj" <govindraj.raja@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Subject: Re: [PATCHv1 1/3] OMAP UART: Adds omap-serial driver support.
Message-ID: <20091009174635.GH25892@atomide.com>
References: <65168.192.168.10.89.1253788033.squirrel@dbdmail.itg.ti.com> <20091007215116.GB29320@atomide.com> <d6a0f7aa0910072314h77383e31r2330725b614ba472@mail.gmail.com> <E0D41E29EB0DAC4E9F3FF173962E9E940253C6C560@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E0D41E29EB0DAC4E9F3FF173962E9E940253C6C560@dbde02.ent.ti.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* G, Manjunath Kondaiah <manjugk@ti.com> [091008 00:41]:
> 
> Govind,
> > -----Original Message-----
> > From: linux-omap-owner@vger.kernel.org 
> > [mailto:linux-omap-owner@vger.kernel.org] On Behalf Of Govindraj
> > Sent: Thursday, October 08, 2009 11:44 AM
> > To: Tony Lindgren
> > Cc: Raja, Govindraj; linux-omap@vger.kernel.org; 
> > linux-kernel@vger.kernel.org; linux-serial@vger.kernel.org
> > Subject: Re: [PATCHv1 1/3] OMAP UART: Adds omap-serial driver support.
> > 
> > On Thu, Oct 8, 2009 at 3:21 AM, Tony Lindgren 
> > <tony@atomide.com> wrote:
> > > * Govindraj.R <govindraj.raja@ti.com> [090924 03:29]:
> > >> From: Govindraj R <govindraj.raja@ti.com>
> > >>
> > >> This patch adds support for OMAP3430-HIGH SPEED UART Controller.
> > >>
> > >> Signed-off-by:        Govindraj R <govindraj.raja@ti.com>
> > >> Reviewed-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
> > >> Reviewed-by: Tony Lindgren <tony@atomide.com>
> > >
> > > You should only add Reviewed-by if Alan or me have replied with it.
> > >
> > > So far I've only replied with some comments that have not yet
> > > been fixed, so we're few more steps from being Reviewd-by.
> > >
> > > <snip>
> > >
> > >> diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
> > >> index 6553833..67a7129 100644
> > >> --- a/drivers/serial/Kconfig
> > >> +++ b/drivers/serial/Kconfig
> > >> @@ -1359,6 +1359,53 @@ config SERIAL_OF_PLATFORM
> > >>         Currently, only 8250 compatible ports are supported, but
> > >>         others can easily be added.
> > >>
> > >> +config SERIAL_OMAP
> > >> +     bool "OMAP serial port support"
> > >> +     depends on ARM && ARCH_OMAP
> > >> +     select SERIAL_CORE
> > >> +     help
> > >> +     If you have a machine based on an Texas Instruments 
> > OMAP CPU you
> > >> +     can enable its onboard serial ports by enabling this option.
> > >> +
> > >> +config SERIAL_OMAP_CONSOLE
> > >> +     bool "Console on OMAP serial port"
> > >> +     depends on SERIAL_OMAP
> > >> +     select SERIAL_CORE_CONSOLE
> > >> +     help
> > >> +     If you have enabled the serial port on the Texas 
> > Instruments OMAP
> > >> +     CPU you can make it the console by answering Y to 
> > this option.
> > >> +
> > >> +     Even if you say Y here, the currently visible virtual console
> > >> +     (/dev/tty0) will still be used as the system console 
> > by default, but
> > >> +     you can alter that using a kernel command line option such as
> > >> +     "console=ttyS0". (Try "man bootparam" or see the 
> > documentation of
> > >> +     your boot loader (lilo or loadlin) about how to pass 
> > options to the
> > >> +     kernel at boot time.)
> > >> +
> > >> +config SERIAL_OMAP_DMA_UART1
> > >> +     bool "UART1 DMA support"
> > >> +     depends on SERIAL_OMAP
> > >> +     help
> > >> +     If you have enabled the serial port on the Texas 
> > Instruments OMAP
> > >> +     CPU you can enable the DMA transfer on UART 1 by answering
> > >> +     to this option.
> > >> +
> > >> +config SERIAL_OMAP_DMA_UART2
> > >> +     bool "UART2 DMA support"
> > >> +     depends on SERIAL_OMAP
> > >> +     help
> > >> +     If you have enabled the serial port on the Texas 
> > Instruments OMAP
> > >> +     CPU you can enable the DMA transfer on UART 2 by answering
> > >> +     to this option.
> > >> +
> > >> +config SERIAL_OMAP_DMA_UART3
> > >> +     bool "UART3 DMA support"
> > >> +     depends on SERIAL_OMAP
> > >> +     help
> > >> +     If you have enabled the serial port on the Texas 
> > Instruments OMAP
> > >> +     CPU you can enable the DMA transfer on UART 3 by answering
> > >> +     to this option.
> > >> +
> > >>  config SERIAL_OF_PLATFORM_NWPSERIAL
> > >>       tristate "NWP serial port driver"
> > >>       depends on PPC_OF && PPC_DCR
> > >
> > > There's absolutely no need for having Kconfig options for the DMA
> > > support. Please pass that in platform_data from the board-*.c files.
> > >
> > > This is the third time I'm commenting on the same issue!
> > >
> > > What's the point of posting these patches for review if the issues
> > > don't get solved?
> > 
> > 
> > The omap-serial uart driver is designed to work either in interrupt
> > mode or in DMA mode,
> > We have provided this option so that one can select interrupt mode or
> > DMA mode based on the uart usage, if somebody is using uart as console
> > then interrupt mode will do, else if used with bluetooth which does
> > huge data transfer then DMA mode can be selected.
> > 
> > Don't you think this should be a configurable option using kconfig
> > rather than passing as platform data?

Nope. I think it should be platform_data and should be possible to override
vith a kernel cmdline option. That's because we support compiling in and
booting many boards the same kernel binary.

> > if used as platform data then one has to modify platform data to
> > switch between the interrupt and DMA mode.

How about set some kernel cmdline options if you want to override the
default settings?

> Usage of UART is board dependent. It's usage will not change dynamically for
> a given board. This can be removed from Kconfig and move it to respective 
> board file-> board-*.c

Or can be changed from kernel cmdline if necessary.

Regards,

Tony

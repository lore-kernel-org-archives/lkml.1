Return-Path: <linux-kernel-owner+w=401wt.eu-S1754790AbZJHHmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbZJHHmR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 03:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754606AbZJHHmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 03:42:17 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34965 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248AbZJHHmP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 03:42:15 -0400
From: "G, Manjunath Kondaiah" <manjugk@ti.com>
To: Govindraj <govindraj.ti@gmail.com>, Tony Lindgren <tony@atomide.com>
CC: "Raja, Govindraj" <govindraj.raja@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Date: Thu, 8 Oct 2009 13:11:32 +0530
Subject: RE: [PATCHv1 1/3] OMAP UART: Adds omap-serial driver support.
Thread-Topic: [PATCHv1 1/3] OMAP UART: Adds omap-serial driver support.
Thread-Index: AcpH4Rsc8tmCMfHOTOKPpRvt6g1UEQACObLg
Message-ID: <E0D41E29EB0DAC4E9F3FF173962E9E940253C6C560@dbde02.ent.ti.com>
References: <65168.192.168.10.89.1253788033.squirrel@dbdmail.itg.ti.com>
	 <20091007215116.GB29320@atomide.com>
 <d6a0f7aa0910072314h77383e31r2330725b614ba472@mail.gmail.com>
In-Reply-To: <d6a0f7aa0910072314h77383e31r2330725b614ba472@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Govind,
> -----Original Message-----
> From: linux-omap-owner@vger.kernel.org 
> [mailto:linux-omap-owner@vger.kernel.org] On Behalf Of Govindraj
> Sent: Thursday, October 08, 2009 11:44 AM
> To: Tony Lindgren
> Cc: Raja, Govindraj; linux-omap@vger.kernel.org; 
> linux-kernel@vger.kernel.org; linux-serial@vger.kernel.org
> Subject: Re: [PATCHv1 1/3] OMAP UART: Adds omap-serial driver support.
> 
> On Thu, Oct 8, 2009 at 3:21 AM, Tony Lindgren 
> <tony@atomide.com> wrote:
> > * Govindraj.R <govindraj.raja@ti.com> [090924 03:29]:
> >> From: Govindraj R <govindraj.raja@ti.com>
> >>
> >> This patch adds support for OMAP3430-HIGH SPEED UART Controller.
> >>
> >> Signed-off-by:        Govindraj R <govindraj.raja@ti.com>
> >> Reviewed-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
> >> Reviewed-by: Tony Lindgren <tony@atomide.com>
> >
> > You should only add Reviewed-by if Alan or me have replied with it.
> >
> > So far I've only replied with some comments that have not yet
> > been fixed, so we're few more steps from being Reviewd-by.
> >
> > <snip>
> >
> >> diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
> >> index 6553833..67a7129 100644
> >> --- a/drivers/serial/Kconfig
> >> +++ b/drivers/serial/Kconfig
> >> @@ -1359,6 +1359,53 @@ config SERIAL_OF_PLATFORM
> >>         Currently, only 8250 compatible ports are supported, but
> >>         others can easily be added.
> >>
> >> +config SERIAL_OMAP
> >> +     bool "OMAP serial port support"
> >> +     depends on ARM && ARCH_OMAP
> >> +     select SERIAL_CORE
> >> +     help
> >> +     If you have a machine based on an Texas Instruments 
> OMAP CPU you
> >> +     can enable its onboard serial ports by enabling this option.
> >> +
> >> +config SERIAL_OMAP_CONSOLE
> >> +     bool "Console on OMAP serial port"
> >> +     depends on SERIAL_OMAP
> >> +     select SERIAL_CORE_CONSOLE
> >> +     help
> >> +     If you have enabled the serial port on the Texas 
> Instruments OMAP
> >> +     CPU you can make it the console by answering Y to 
> this option.
> >> +
> >> +     Even if you say Y here, the currently visible virtual console
> >> +     (/dev/tty0) will still be used as the system console 
> by default, but
> >> +     you can alter that using a kernel command line option such as
> >> +     "console=ttyS0". (Try "man bootparam" or see the 
> documentation of
> >> +     your boot loader (lilo or loadlin) about how to pass 
> options to the
> >> +     kernel at boot time.)
> >> +
> >> +config SERIAL_OMAP_DMA_UART1
> >> +     bool "UART1 DMA support"
> >> +     depends on SERIAL_OMAP
> >> +     help
> >> +     If you have enabled the serial port on the Texas 
> Instruments OMAP
> >> +     CPU you can enable the DMA transfer on UART 1 by answering
> >> +     to this option.
> >> +
> >> +config SERIAL_OMAP_DMA_UART2
> >> +     bool "UART2 DMA support"
> >> +     depends on SERIAL_OMAP
> >> +     help
> >> +     If you have enabled the serial port on the Texas 
> Instruments OMAP
> >> +     CPU you can enable the DMA transfer on UART 2 by answering
> >> +     to this option.
> >> +
> >> +config SERIAL_OMAP_DMA_UART3
> >> +     bool "UART3 DMA support"
> >> +     depends on SERIAL_OMAP
> >> +     help
> >> +     If you have enabled the serial port on the Texas 
> Instruments OMAP
> >> +     CPU you can enable the DMA transfer on UART 3 by answering
> >> +     to this option.
> >> +
> >>  config SERIAL_OF_PLATFORM_NWPSERIAL
> >>       tristate "NWP serial port driver"
> >>       depends on PPC_OF && PPC_DCR
> >
> > There's absolutely no need for having Kconfig options for the DMA
> > support. Please pass that in platform_data from the board-*.c files.
> >
> > This is the third time I'm commenting on the same issue!
> >
> > What's the point of posting these patches for review if the issues
> > don't get solved?
> 
> 
> The omap-serial uart driver is designed to work either in interrupt
> mode or in DMA mode,
> We have provided this option so that one can select interrupt mode or
> DMA mode based on the uart usage, if somebody is using uart as console
> then interrupt mode will do, else if used with bluetooth which does
> huge data transfer then DMA mode can be selected.
> 
> Don't you think this should be a configurable option using kconfig
> rather than passing as platform data?
> 
> if used as platform data then one has to modify platform data to
> switch between the interrupt and DMA mode.
> 
> Regards,
> Govindraj.R
> 
> 

Usage of UART is board dependent. It's usage will not change dynamically for
a given board. This can be removed from Kconfig and move it to respective 
board file-> board-*.c

> >
> > Regards,
> >
> > Tony
> > --
> > To unsubscribe from this list: send the line "unsubscribe 
> linux-serial" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
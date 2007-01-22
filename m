Return-Path: <linux-kernel-owner+w=401wt.eu-S932257AbXAVTHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257AbXAVTHi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 14:07:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932342AbXAVTHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 14:07:37 -0500
Received: from father.pmc-sierra.com ([216.241.224.13]:36712 "HELO
	father.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932257AbXAVTHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 14:07:37 -0500
X-Greylist: delayed 336 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Jan 2007 14:07:36 EST
Message-ID: <5C1FD43E5F1B824E83985A74F396286E03AD7635@bby1exm08.pmc_nt.nt.pmc-sierra.bc.ca>
From: Marc St-Jean <Marc_St-Jean@pmc-sierra.com>
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: [PATCH] serial driver PMC MSP71xx, kernel linux-mips.git mast er
Date: Mon, 22 Jan 2007 11:07:26 -0800
MIME-Version: 1.0
X-Mailer: Internet Mail Service (5.5.2657.72)
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

CCing linux-kernel as per AC's suggestion...

> -----Original Message-----
> From: Ralf Baechle [mailto:ralf@linux-mips.org]
> Sent: Friday, January 19, 2007 8:18 AM
> To: Marc St-Jean
> Cc: linux-mips@linux-mips.org; linux-serial@vger.kernel.org
> Subject: Re: [PATCH] serial driver PMC MSP71xx, kernel linux-mips.git 
> master
> 
> On Thu, Jan 18, 2007 at 04:23:01PM -0800, Marc St-Jean wrote:
> 
> > Index: linux_2_6/drivers/serial/8250.c 
> > ===================================================================
> > RCS file: linux_2_6/drivers/serial/8250.c,v retrieving revision
> > 1.1.1.7 retrieving revision 1.9 diff -u -r1.1.1.7 -r1.9
> > --- linux_2_6/drivers/serial/8250.c	19 Oct 2006 21:00:58 
> -0000	1.1.1.7
> > +++ linux_2_6/drivers/serial/8250.c	19 Oct 2006 22:08:15 
> -0000	1.9
> > @@ -44,6 +44,10 @@
> >   #include <asm/io.h>
> >   #include <asm/irq.h>
> > 
> > +#ifdef CONFIG_PMC_MSP
> > +#include <msp_regs.h>
> > +#endif
> 
> CONFIG_PMC_MSP is not defined anywhere.  msp_regs.h does not exist.
> 
>   Ralf
> 

Hi Ralf,

CONFIG_PMC_MSP is defined in the main platform patch (arch/mips/Kconfig). I doesn't apply against the git HEAD yet. I'm still working on it and will post as soon as it does.

msp_regs.h defines the UART0_STATUS_REG and UART1_STATUS_REG SoC addresses for the DesignWare UART. I thought of putting them in include/linux/serial_reg.h but it contains register offsets only, no platform addresses.

That is one of the main issues, how to add MSP71xx specific register mapping without platform tests/includes?

Marc

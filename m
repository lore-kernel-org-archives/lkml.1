Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab0CBN6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 08:58:45 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:57358 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357Ab0CBN6m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 08:58:42 -0500
From: "G, Manjunath Kondaiah" <manjugk@ti.com>
To: "S, Venkatraman" <svenkatr@ti.com>, Tony Lindgren <tony@atomide.com>,
       "Raja, Govindraj" <govindraj.raja@ti.com>, Greg KH <greg@kroah.com>,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Olof Johansson <olof@lixom.net>
Date: Tue, 2 Mar 2010 19:28:34 +0530
Subject: RE: [PATCH] serial: Add OMAP high-speed UART driver.
Thread-Topic: [PATCH] serial: Add OMAP high-speed UART driver.
Thread-Index: Acq6DrzxzzLj/+UaR0CqYftNXskKIAAAL3Rw
Message-ID: <E0D41E29EB0DAC4E9F3FF173962E9E94026ED96358@dbde02.ent.ti.com>
References: <41322.192.168.10.89.1267454612.squirrel@dbdmail.itg.ti.com>
	 <20100301184600.GC3389@atomide.com>
	 <E0D41E29EB0DAC4E9F3FF173962E9E94026ED95FC1@dbde02.ent.ti.com>
	 <20100302060821.GI3389@atomide.com>
	 <E0D41E29EB0DAC4E9F3FF173962E9E94026ED9600D@dbde02.ent.ti.com>
	 <20100302065224.GL3389@atomide.com>
 <618f0c911003020546mb7c8412o2bac4e86a081332b@mail.gmail.com>
In-Reply-To: <618f0c911003020546mb7c8412o2bac4e86a081332b@mail.gmail.com>
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

 

> -----Original Message-----
> From: svenkatr@gmail.com [mailto:svenkatr@gmail.com] On 
> Behalf Of Venkatraman S
> Sent: Tuesday, March 02, 2010 7:16 PM
> To: Tony Lindgren; G, Manjunath Kondaiah; Raja, Govindraj; 
> Greg KH; linux-serial@vger.kernel.org; 
> linux-omap@vger.kernel.org; linux-kernel@vger.kernel.org; 
> Kevin Hilman; Olof Johansson
> Subject: Re: [PATCH] serial: Add OMAP high-speed UART driver.
> 
> On Tue, Mar 2, 2010 at 12:22 PM, Tony Lindgren 
> <tony@atomide.com> wrote:
> > * G, Manjunath Kondaiah <manjugk@ti.com> [100301 22:24]:
> >>
> >>
> >>
> >> > > > > +     up->uart_dma.prev_rx_dma_pos =
> >> > up->uart_dma.rx_buf_dma_phys;
> >> > > > > +     if (cpu_is_omap44xx())
> >> > > > > +             omap_writel(0, OMAP44XX_DMA4_BASE
> >> > > > > +                     +
> >> > OMAP_DMA4_CDAC(up->uart_dma.rx_dma_channel));
> >> > > > > +     else
> >> > > > > +             omap_writel(0, OMAP34XX_DMA4_BASE
> >> > > > > +                     +
> >> > OMAP_DMA4_CDAC(up->uart_dma.rx_dma_channel));
> >> > > >
> >> > > > NAK. Please don't use omap_read/write for for new 
> code. And do not
> >> > > > tinker with the omap hardware registers directly in 
> the driver.
> >> > > >
> >> > > > This needs to be done properly in
> >> > arch/arm/plat-omap/dma.c instead.
> >> > >
> >> > > Thanks for the suggestion.
> >> > >
> >> > > Currently, dma_read/dma_write are #define's in dma.c which
> >> > cannot be
> >> > > accessed outside dma.c. I don't see any API's in dma.c for
> >> > setting required
> >> > > value for this register?
> >> >
> >> > Hmm isn't this the same as omap_get_dma_dst_pos(int 
> lch)? If you're
> >> > trying do something that's not in dma.c, we can add a 
> new function
> >> > for it.
> >>
> >> The omap_get_dma_dst_pos(int lch) is for read operation in 
> CDAC register.
> >> But, We need to write required value into CDAC register. 
> For this, I propose:
> >>
> >> omap_set_dma_dst_pos(int lch, int value) which does not 
> exist in current dma
> >> driver.
> >
> > OK, it that's needed.
> >
> > Tony
> > --
> CDAC is a shadow register used for monitoring the DMA channel.
>  I think it would be a lot
> simpler if omap_start_dma() always resets CDAC to 0, and the 
> UART driver
> just not set it explicitly.

This seems to be better option than exposing CDAC read/write API
to other drivers since user need to write '0' before starting any DMA
transfer which can be be done in omap_start_dma().

I am wondering how other drivers are using DMA transfer API's without 
resetting CDAC to zero. 

-Manjunath



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab0CBG1p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 01:27:45 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:49615 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694Ab0CBG1n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 01:27:43 -0500
From: "G, Manjunath Kondaiah" <manjugk@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: "Raja, Govindraj" <govindraj.raja@ti.com>, Greg KH <greg@kroah.com>,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Olof Johansson <olof@lixom.net>
Date: Tue, 2 Mar 2010 11:57:25 +0530
Subject: RE: [PATCH] serial: Add OMAP high-speed UART driver.
Thread-Topic: [PATCH] serial: Add OMAP high-speed UART driver.
Thread-Index: Acq5zqKtKjtpNFktSOG16JqqufcULgAAhURg
Message-ID: <E0D41E29EB0DAC4E9F3FF173962E9E94026ED9600D@dbde02.ent.ti.com>
References: <41322.192.168.10.89.1267454612.squirrel@dbdmail.itg.ti.com>
 <20100301184600.GC3389@atomide.com>
 <E0D41E29EB0DAC4E9F3FF173962E9E94026ED95FC1@dbde02.ent.ti.com>
 <20100302060821.GI3389@atomide.com>
In-Reply-To: <20100302060821.GI3389@atomide.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




> > > > +	up->uart_dma.prev_rx_dma_pos = 
> up->uart_dma.rx_buf_dma_phys;
> > > > +	if (cpu_is_omap44xx())
> > > > +		omap_writel(0, OMAP44XX_DMA4_BASE
> > > > +			+ 
> OMAP_DMA4_CDAC(up->uart_dma.rx_dma_channel));
> > > > +	else
> > > > +		omap_writel(0, OMAP34XX_DMA4_BASE
> > > > +			+ 
> OMAP_DMA4_CDAC(up->uart_dma.rx_dma_channel));
> > > 
> > > NAK. Please don't use omap_read/write for for new code. And do not
> > > tinker with the omap hardware registers directly in the driver.
> > > 
> > > This needs to be done properly in 
> arch/arm/plat-omap/dma.c instead.
> > 
> > Thanks for the suggestion.
> > 
> > Currently, dma_read/dma_write are #define's in dma.c which 
> cannot be 
> > accessed outside dma.c. I don't see any API's in dma.c for 
> setting required 
> > value for this register?
> 
> Hmm isn't this the same as omap_get_dma_dst_pos(int lch)? If you're
> trying do something that's not in dma.c, we can add a new function
> for it.

The omap_get_dma_dst_pos(int lch) is for read operation in CDAC register. 
But, We need to write required value into CDAC register. For this, I propose:

omap_set_dma_dst_pos(int lch, int value) which does not exist in current dma 
driver.

-Manjunath
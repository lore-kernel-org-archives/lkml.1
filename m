Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab0CBGvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 01:51:21 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:64163 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab0CBGvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 01:51:19 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19mXM6ZCV003qm2UFKhw7D2
Date: Mon, 1 Mar 2010 22:52:24 -0800
From: Tony Lindgren <tony@atomide.com>
To: "G, Manjunath Kondaiah" <manjugk@ti.com>
Cc: "Raja, Govindraj" <govindraj.raja@ti.com>, Greg KH <greg@kroah.com>,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH] serial: Add OMAP high-speed UART driver.
Message-ID: <20100302065224.GL3389@atomide.com>
References: <41322.192.168.10.89.1267454612.squirrel@dbdmail.itg.ti.com>
 <20100301184600.GC3389@atomide.com>
 <E0D41E29EB0DAC4E9F3FF173962E9E94026ED95FC1@dbde02.ent.ti.com>
 <20100302060821.GI3389@atomide.com>
 <E0D41E29EB0DAC4E9F3FF173962E9E94026ED9600D@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E0D41E29EB0DAC4E9F3FF173962E9E94026ED9600D@dbde02.ent.ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* G, Manjunath Kondaiah <manjugk@ti.com> [100301 22:24]:
> 
> 
> 
> > > > > +	up->uart_dma.prev_rx_dma_pos = 
> > up->uart_dma.rx_buf_dma_phys;
> > > > > +	if (cpu_is_omap44xx())
> > > > > +		omap_writel(0, OMAP44XX_DMA4_BASE
> > > > > +			+ 
> > OMAP_DMA4_CDAC(up->uart_dma.rx_dma_channel));
> > > > > +	else
> > > > > +		omap_writel(0, OMAP34XX_DMA4_BASE
> > > > > +			+ 
> > OMAP_DMA4_CDAC(up->uart_dma.rx_dma_channel));
> > > > 
> > > > NAK. Please don't use omap_read/write for for new code. And do not
> > > > tinker with the omap hardware registers directly in the driver.
> > > > 
> > > > This needs to be done properly in 
> > arch/arm/plat-omap/dma.c instead.
> > > 
> > > Thanks for the suggestion.
> > > 
> > > Currently, dma_read/dma_write are #define's in dma.c which 
> > cannot be 
> > > accessed outside dma.c. I don't see any API's in dma.c for 
> > setting required 
> > > value for this register?
> > 
> > Hmm isn't this the same as omap_get_dma_dst_pos(int lch)? If you're
> > trying do something that's not in dma.c, we can add a new function
> > for it.
> 
> The omap_get_dma_dst_pos(int lch) is for read operation in CDAC register. 
> But, We need to write required value into CDAC register. For this, I propose:
> 
> omap_set_dma_dst_pos(int lch, int value) which does not exist in current dma 
> driver.

OK, it that's needed.

Tony

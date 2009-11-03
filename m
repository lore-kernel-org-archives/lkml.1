Return-Path: <linux-kernel-owner+w=401wt.eu-S1754946AbZKCUKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946AbZKCUKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 15:10:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752176AbZKCUKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 15:10:51 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:63738 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbZKCUKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 15:10:50 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX186ykzbRp1uuO8ySiF6hWUc
Date: Tue, 3 Nov 2009 12:10:48 -0800
From: Tony Lindgren <tony@atomide.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: linux-omap@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH v2] OMAP: DMA: Fix omapfb/lcdc on Amstrad Delta
 broken when PM set
Message-ID: <20091103201048.GP8981@atomide.com>
References: <200911032024.47741.jkrzyszt@tis.icnet.pl>
 <200911032104.33049.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200911032104.33049.jkrzyszt@tis.icnet.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [091103 12:05]:
> Tuesday 03 November 2009 20:24:38 Janusz Krzysztofik napisał(a):
> > If there are still no comments, especially on the bug possible impact on
> > other OMAP1510 boards (or even OMAP1610 with internal LCD controller), then
> > Tony, please apply it as is. Until it is accepted, I am stuck with new
> > ams_delta_defconfig.
> 
> Tony,
> Sorry, I've not checked for new mail before posting this one and missed your 
> acceptance for my idea of fixing all omap1510, not only ams_delta. If there 
> are no more comments, I'll submit v3 with cpu_is_omap1510() replacing 
> machine_is_ams_delta().

Sounds good to me.

Tony
 
> Thanks,
> Janusz
> 
> > --- linux-2.6.32-rc5/arch/arm/plat-omap/dma.c.orig	2009-10-16
> > 02:41:50.000000000 +0200 +++
> > linux-2.6.32-rc5/arch/arm/plat-omap/dma.c	2009-11-03 20:15:35.000000000
> > +0100 @@ -30,6 +30,7 @@
> >  #include <linux/irq.h>
> >  #include <linux/io.h>
> >
> > +#include <asm/mach-types.h>
> >  #include <asm/system.h>
> >  #include <mach/hardware.h>
> >  #include <mach/dma.h>
> > @@ -1110,6 +1111,14 @@ int omap_dma_running(void)
> >  {
> >  	int lch;
> >
> > +	/*
> > +	 * On Amstrad Delta, the OMAP internal LCD controller will start the
> > +	 * transfer when it gets enabled, so assume DMA running if LCD enabled.
> > +	 */
> > +	if (machine_is_ams_delta())
> > +		if (omap_readw(0xfffec000 + 0x00) & (1 << 0))
> > +			return 1;
> > +
> >  	/* Check if LCD DMA is running */
> >  	if (cpu_is_omap16xx())
> >  		if (omap_readw(OMAP1610_DMA_LCD_CCR) & OMAP_DMA_CCR_EN)
> 
> 

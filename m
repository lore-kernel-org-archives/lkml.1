Return-Path: <linux-kernel-owner+w=401wt.eu-S1752818AbYLWRPC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818AbYLWRPC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 12:15:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751217AbYLWROv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 12:14:51 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59001 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbYLWROu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 12:14:50 -0500
Date: Tue, 23 Dec 2008 18:14:37 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@gmail.com, linux-arm-kernel@lists.arm.linux.org.uk,
       Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 2/4 v4] i.MX31: Image Processing Unit DMA and IRQ
	drivers
Message-ID: <20081223171437.GK1614@pengutronix.de>
Mail-Followup-To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-kernel@vger.kernel.org,
	linux-fbdev-devel@lists.sourceforge.net, adaplas@gmail.com,
	linux-arm-kernel@lists.arm.linux.org.uk,
	Dan Williams <dan.j.williams@intel.com>
References: <20081222183753.GD1614@pengutronix.de> <Pine.LNX.4.64.0812221942480.7796@axis700.grange> <20081223105006.GE1614@pengutronix.de> <Pine.LNX.4.64.0812231157180.5188@axis700.grange> <20081223125015.GG1614@pengutronix.de> <Pine.LNX.4.64.0812231359030.5188@axis700.grange> <20081223140320.GH1614@pengutronix.de> <Pine.LNX.4.64.0812231529080.5188@axis700.grange> <20081223160942.GJ1614@pengutronix.de> <Pine.LNX.4.64.0812231727460.5188@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0812231727460.5188@axis700.grange>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Peiner Strasse
	6-8, 31137 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 18:10:03 up 9 days, 21:37, 10 users,  load average: 0.00, 0.00,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2008 at 05:33:11PM +0100, Guennadi Liakhovetski wrote:
> 
> These all are just slightly different variations - with this one you'd 
> have to scan dma channels in your dma irq handler, which I currently don't 
> have to do.
> 
> > That said I'm not sure whether we need a chained interrupt handler at all.
> > Looking at the remaining interrupts it seems that for example the
> > CSI_EOF (IPU_INT_STAT3 bit 5) interrupt is redundant to the corresponding
> > channels interrupt. In the camera driver you already realized that it's
> > the dma end event you're interested in, not the CSI_EOF event. Not sure
> > if that holds for the other interrupts though.
> 
> I think the version with a lookup table is optimal - it uses standard 
> mechanisms for irq handling and doesn't waste RAM. The disadvantage - 
> every addition will need driver modification...
> 
> But ok, this is taking way too long. Just tell me which way you'd like to 
> have it and I'll do it.

Preferably a way which does not involve introducing 100+ unused
interrupts.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

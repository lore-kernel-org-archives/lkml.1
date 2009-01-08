Return-Path: <linux-kernel-owner+w=401wt.eu-S1759406AbZAHKvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759406AbZAHKvW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 05:51:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755216AbZAHKuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 05:50:54 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52290 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809AbZAHKuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 05:50:52 -0500
Date: Thu, 8 Jan 2009 11:50:48 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@gmail.com, linux-arm-kernel@lists.arm.linux.org.uk,
       Dan Williams <dan.j.williams@intel.com>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 0/4 v6] i.MX31: dmaengine and framebuffer drivers
Message-ID: <20090108105048.GA8021@pengutronix.de>
Mail-Followup-To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	linux-kernel@vger.kernel.org,
	linux-fbdev-devel@lists.sourceforge.net, adaplas@gmail.com,
	linux-arm-kernel@lists.arm.linux.org.uk,
	Dan Williams <dan.j.williams@intel.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Geert Uytterhoeven <geert@linux-m68k.org>
References: <Pine.LNX.4.64.0812261714290.4895@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0812261714290.4895@axis700.grange>
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
X-Uptime: 10:58:13 up 25 days, 14:25, 17 users,  load average: 1.57, 0.79,
	0.35
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell et al,

I just had some offline discussion with Guennadi about the chained
interrupt issue in the IPU (image processing unit) driver discussed in
this thread. We came up with several solutions but none of them seems
to be ideal. To sum this up we are talking about 142 interrupt sources
which consist of:

96 DMA channel interrupts (32 channels, 3 interrupts each)
46 misc interrupts which are going to be handled by various client
   drivers such as camera interface and framebuffer.

So far our possible solutions are:

1) handle all 142 interrupts in a chained handler. This involves adding
   of 142 struct irq_desc (implemented in -v1)
2) add a pool of chained interrupt sources and create a virtual mapping
   (implemented in -v6)
3) forget about chained interrupt handlers, handle the 96 channel
   interrupts in a normal interrupt handler and create callbacks for the
   rest. This would create a new API instead of using an existing one.

In a normal system most of these interrupts are unused. For example the
framebuffer needs the 3 interrupts for the corresponding DMA channel and
there is a vsync interrupt which is currently unused.

Russell, I would be glad if you could comment on this so that we come up
with a solution acceptable for mainline.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

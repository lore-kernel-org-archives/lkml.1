Return-Path: <linux-kernel-owner+w=401wt.eu-S1753299AbZAFJEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbZAFJEn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 04:04:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750967AbZAFJE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 04:04:28 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56723 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbZAFJE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 04:04:26 -0500
Date: Tue, 6 Jan 2009 10:04:22 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@gmail.com, linux-arm-kernel@lists.arm.linux.org.uk,
       Dan Williams <dan.j.williams@intel.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 0/4 v6] i.MX31: dmaengine and framebuffer drivers
Message-ID: <20090106090422.GC18861@pengutronix.de>
Mail-Followup-To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-kernel@vger.kernel.org,
	linux-fbdev-devel@lists.sourceforge.net, adaplas@gmail.com,
	linux-arm-kernel@lists.arm.linux.org.uk,
	Dan Williams <dan.j.williams@intel.com>,
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
X-Uptime: 09:39:37 up 23 days, 13:06, 26 users,  load average: 0.22, 2.26,
	2.91
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guennadi,

On Fri, Dec 26, 2008 at 06:11:13PM +0100, Guennadi Liakhovetski wrote:
> Hi,
> 
> This is version 6 of dmaengine and framebuffer drivers for i.MX31.
> 
> Changes since version 5: as requested by Sascha Hauer switched to dynamic 
> IPU IRQ mapping.

I tried to express that it's really odd that you demux your _internal_
interrupts as chained handlers. Consider a network driver which has a
rx, tx and an error status bit, all of them can trigger an interrupt. A
you aware of a single driver that uses chained interrupts for this
case?
No, they don't have to, because all this happens inside one driver
and this can easily be dispatched in one interrupt handler. IMHO chained
interrupts only make sense when you have an interrupt source which
leaves your driver code and you don't know who might be interested in,
like the assorted non channel interrupts the IPU also provides.

I bet you'd never have the idea for such a code design without the
Freescale code as a sample.

Note that arch/arm/plat-mxc/include/mach/mx31.h does not apply anymore
due to upstream changes.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

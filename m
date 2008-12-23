Return-Path: <linux-kernel-owner+w=401wt.eu-S1751725AbYLWMNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725AbYLWMNT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 07:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750966AbYLWMNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 07:13:04 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53226 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbYLWMNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 07:13:02 -0500
Date: Tue, 23 Dec 2008 13:13:00 +0100
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@gmail.com, linux-arm-kernel@lists.arm.linux.org.uk,
       Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 2/4 v4] i.MX31: Image Processing Unit DMA and IRQ
	drivers
Message-ID: <20081223121300.GL9472@pengutronix.de>
References: <Pine.LNX.4.64.0812181406000.5510@axis700.grange> <Pine.LNX.4.64.0812181414280.5510@axis700.grange> <20081218225834.GJ20756@pengutronix.de> <Pine.LNX.4.64.0812221240210.5241@axis700.grange> <20081222183753.GD1614@pengutronix.de> <Pine.LNX.4.64.0812221942480.7796@axis700.grange> <20081223105006.GE1614@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20081223105006.GE1614@pengutronix.de>
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
X-Uptime: 13:08:46 up 9 days, 16:31,  5 users,  load average: 0.00, 0.00,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:219:66ff:fe5b:d0e3
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2008 at 11:50:06AM +0100, Sascha Hauer wrote:
> > You mean an output v4l device? I think overlays are handled by framebuffer 
> > drivers... But I'm also not quite sure about it, however, handling overlay 
> > as another framebuffer seems logical to me.
>
> Well the DMA engine seems to suggest that frames should be passed around
> whereas the framebuffer API only has a single frame. That would fit
> better into the v4l API. Also the IPU can do things like colourspace
> conversion and hw scaling which would fit into the V4L API.

Looks like a candidate for gstreamer on the userspace end. Can it be
decoupled enough to make proper plugins out of it?

> BTW is the overlay framebuffer useful in it's current implementation?
> There seems to be no way to adjust the x/y offset or the blending
> modes.

The API Eric Miao just posted for the PXA looks sane to me.

> > If there are no other problems with v5, could we maybe take it as a
> > basis and then I would submit a patch to reduce the number of IRQs?
>
> Please understand my concerns with this driver. It's a quite complex
> beast and experience shows that once a driver is in the kernel it is
> far more complicated to change it than to do it right the first way.

Especially when it comes to userspace visible things.

> You know that I'm also interested in having a MX31 framebuffer (and
> camera) driver in kernel but I want to make sure that it works
> properly and leaves room for feature enhancements without having to
> refactor the whole driver.

Yup, looks like it would be better to cook it another round instead of
trying to bring in a half-tested driver with brute-force.

rsc
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

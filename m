Return-Path: <linux-kernel-owner+w=401wt.eu-S1761682AbZE0XsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761682AbZE0XsR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 19:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760020AbZE0XsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 19:48:06 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46295 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759689AbZE0XsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 19:48:05 -0400
Date: Thu, 28 May 2009 01:48:01 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>,
       Timur Tabi <timur@freescale.com>, Janboe Ye <yuan-bo.ye@motorola.com>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       rmk@arm.linux.org.uk
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Message-ID: <20090527234801.GP6805@pengutronix.de>
References: <1243408083.13460.14.camel@debian-nb> <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com> <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com> <20090527150527.GK6805@pengutronix.de> <fa686aa40905270839m375bbdacqb1acb1be0a2d2da0@mail.gmail.com> <20090527162000.GM6805@pengutronix.de> <fa686aa40905271335o1165419hda2334bef42aa3f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <fa686aa40905271335o1165419hda2334bef42aa3f@mail.gmail.com>
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
X-Uptime: 01:37:45 up 90 days,  9:19,  1 user,  load average: 0.74, 0.20,
	0.07
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:219:66ff:fe5b:d0e3
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 02:35:11PM -0600, Grant Likely wrote:
> > Unfortunately, it is an incomplete data structure regarding to what
> > the kernel needs.
>
> I don't follow your argument. It's a data structure that uniquely
> describes your hardware in a way which encourages the most code reuse
> possible; but is still independent of kernel internal implementation.
> ie. a FDT blob should be usable not just by Linux, but also by BSD or
> any of the other OS options. It is not an attempt to eliminate
> platform specific code; just to reduce it as much as possible. Weird,
> harry, non-standard stuff probably still needs board specific code to
> handle.

The oftree by design wants to be a complete hardware description. As you
mention above, there are cases where you *nevertheless* need ad-hoc
information about things *not* encoded into the device tree.

This renders the whole concept ad absurdum. You need a machine number
again - and if you need that: why not stay with the ARM model, define
everything with platform data and avoid the whole thing?

Regarding the multi OS argument: I consider it impossible that people
agree on all micro details of a hardware decision. Will it really be
possible to get a common agreement about let's say Russell's SMSC
example between all these people? Remember: if we forget (or don't agree
on) one single aspect which a driver developer *needs*, he will have to
work around it -> machine number land.

My impression is that oftree only works in a perfect world. But we don't
have one, so the fundamental design decision is broken.

rsc
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760287AbZE0PFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760287AbZE0PFu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 11:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756344AbZE0PFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 11:05:40 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41507 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756297AbZE0PFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 11:05:39 -0400
Date: Wed, 27 May 2009 17:05:27 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Timur Tabi <timur@freescale.com>
Cc: Janboe Ye <yuan-bo.ye@motorola.com>,
       Grant Likely <grant.likely@secretlab.ca>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       rmk@arm.linux.org.uk
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Message-ID: <20090527150527.GK6805@pengutronix.de>
References: <1243408083.13460.14.camel@debian-nb> <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com> <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com>
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
X-Uptime: 16:46:19 up 90 days, 28 min,  7 users,  load average: 0.07, 0.09,
	0.06
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:219:66ff:fe5b:d0e3
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 09:39:30AM -0500, Timur Tabi wrote:
> > > Signed-off-by: janboe <yuan-bo.ye@motorola.com>
> >
> > Heeheehe, This is Fantastic.
>
> Yes, I agree. Thanks for working on this. I was hoping to work on it
> myself later this year. Freescale develops both ARM-based and
> PowerPC-based SOCs, and some devices are shared between them (e.g. the
> SSI). Lack of device-tree support on ARM has been a real hindrance to
> getting the ARM-based Linux support on par with PowerPC.

Another reason might be this:

rsc@thebe:linux-2.6$ git log --pretty=short arch/arm/mach-mx? \
	arch/arm/plat-mxc/ | grep -e "^Author." | grep freescale | wc -l
1

rsc@thebe:linux-2.6$ git log --pretty=short arch/arm/mach-mx? \
	arch/arm/plat-mxc/ | grep -e "^Author." | grep pengutronix | wc -l
97

rsc@thebe:linux-2.6$ git log --pretty=short arch/arm/mach-mx? \
	arch/arm/plat-mxc/ | grep -e "^Author." | wc -l
195

I'm highly convinced that the existence of oftree-hell in ARM-land would
have been *the* key motivation for FSL to have worked on mainline
instead of inhouse-BSPs back in 2004 when we mainlined i.MX1 and in 2007
when we started the mainline work on MX27 and MX31.

Seriously: oftree in general is a good idea. Just that it doesn't work
in practise. The concept has some serious flaws:

- The whole concept is based on the assumption that bindings are defined
  *once*, then never to be changed again. As this is not true (check
  MPC5200 to find out what I mean), oftree wreckage is *the* main cause
  of new kernels not working on old bootloaders any more. Is there a
  solution of this problem? I have not seen a good idea how to avoid the
  constant change in definitions.

- The oftree layering is fundamentally broken. We already have a sane
  abstraction for arbitrary hardware in the kernel: platform devices.
  Why not instanciate platform devices from a generic oftree core?

- Platform data makes it possible to store function pointers. There
  is no equivalent to this concept in oftree-land.

oftree could be a great tool if these things would be resolved.
Currently they are not, and in result, ARM just works and is easy,
whereas on PowerPC systems people often spend more time working on
binding stuff than on the actual functionality.

rsc
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

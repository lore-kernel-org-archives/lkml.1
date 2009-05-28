Return-Path: <linux-kernel-owner+w=401wt.eu-S1759194AbZE1PEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759194AbZE1PEe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 11:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757068AbZE1PEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 11:04:25 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60772 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbZE1PEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 11:04:23 -0400
Date: Thu, 28 May 2009 17:04:09 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Grant Likely <grant.likely@secretlab.ca>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, Timur Tabi <timur@freescale.com>,
       Scott Wood <scottwood@freescale.com>,
       Janboe Ye <yuan-bo.ye@motorola.com>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Message-ID: <20090528150409.GO22742@pengutronix.de>
Mail-Followup-To: Thomas Gleixner <tglx@linutronix.de>,
	Grant Likely <grant.likely@secretlab.ca>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Russell King <rmk+lkml@arm.linux.org.uk>,
	devicetree-discuss <devicetree-discuss@ozlabs.org>,
	linux-kernel@vger.kernel.org, Timur Tabi <timur@freescale.com>,
	Scott Wood <scottwood@freescale.com>,
	Janboe Ye <yuan-bo.ye@motorola.com>,
	linux-arm-kernel@lists.arm.linux.org.uk
References: <20090527150527.GK6805@pengutronix.de> <87vdnm8sec.fsf@macbook.be.48ers.dk> <4A1D6901.2090508@freescale.com> <20090527175609.GB31861@flint.arm.linux.org.uk> <4A1D8FBA.6040802@freescale.com> <20090527192909.GA32398@flint.arm.linux.org.uk> <20090527205218.GA5591@sirena.org.uk> <fa686aa40905271405pc2f1738gc8dd139f61a0e27@mail.gmail.com> <20090528124307.GN22742@pengutronix.de> <alpine.LFD.2.00.0905281457170.3397@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0905281457170.3397@localhost.localdomain>
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
X-Uptime: 16:32:31 up 17 days,  4:56, 32 users,  load average: 2.96, 3.89,
	2.83
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 03:18:02PM +0200, Thomas Gleixner wrote:
> On Thu, 28 May 2009, Sascha Hauer wrote:
> > > There is the advantage of easy multiplatform support.  I regularly
> > > build a single kernel image which boots on all my MPC5200 boards, and
> > > on my MPC83xx boards.
> > 
> > That is not necessarily an advantage of a device tree. On ARM you can
> > also build a kernel which runs on 20+ PXA platforms at the same time.
> > (And I'm sure it can be done to even support say i.MX and PXA at the
> > same time, but this is another story)
> 
> Well, you can run it on 20+ PXA platforms which have all their own
> machine number, but you have all the little details of each platform
> hardcoded into the kernel.
> 
> That does not help at all when your board has 5 variants just
> different in subtle details which can not be probed or enumerated by
> inspection. That's a common scenario in the embedded world.

We normally hide these subtle details behind a baseboard= kernel
parameter. I agree with you that it's far better to have a standardized
way to specify this. For my taste the oftree is too bloated for this
purpose.

> 
> So you either have 5 board numbers and all the details harcoded again
> or you add some extra magic to deduce on which variant you are running
> on.
> 
> We have seen almost everything in the weirdness range from poking in
> some hardcoded FLASH cells over weird command line parsers up to a XML
> parser which were added to work around the limitations of the machine
> number model.
> 
> With a device tree you can avoid that crap and provide a standardized
> interface for such cases.
> 
> I'm not saying that the device tree will make all those problems go
> away magically, but it's orders of magnitudes better than what people
> do now.
> 
> There is no need to force switch all of ARM to the device tree, but
> adding support for it would be a good move. Nobody wants to enforce it
> and both models can live happily side by side and we'll see which
> variant turns out to be the long term favourite solution.

Having it as an optional feature seems a good idea for the same reasons
you mentioned. I just wonder how optional it can be once a board
maintainer and a person sending patches disagree on whether to use oftree
or not.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

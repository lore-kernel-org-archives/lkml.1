Return-Path: <linux-kernel-owner+w=401wt.eu-S1761537AbZE1MnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761537AbZE1MnY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 08:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755727AbZE1MnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 08:43:17 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48023 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756073AbZE1MnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 08:43:14 -0400
Date: Thu, 28 May 2009 14:43:07 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, Timur Tabi <timur@freescale.com>,
       Scott Wood <scottwood@freescale.com>,
       Janboe Ye <yuan-bo.ye@motorola.com>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Message-ID: <20090528124307.GN22742@pengutronix.de>
Mail-Followup-To: Grant Likely <grant.likely@secretlab.ca>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Russell King <rmk+lkml@arm.linux.org.uk>,
	devicetree-discuss <devicetree-discuss@ozlabs.org>,
	linux-kernel@vger.kernel.org, Timur Tabi <timur@freescale.com>,
	Scott Wood <scottwood@freescale.com>,
	Janboe Ye <yuan-bo.ye@motorola.com>,
	linux-arm-kernel@lists.arm.linux.org.uk
References: <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com> <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com> <20090527150527.GK6805@pengutronix.de> <87vdnm8sec.fsf@macbook.be.48ers.dk> <4A1D6901.2090508@freescale.com> <20090527175609.GB31861@flint.arm.linux.org.uk> <4A1D8FBA.6040802@freescale.com> <20090527192909.GA32398@flint.arm.linux.org.uk> <20090527205218.GA5591@sirena.org.uk> <fa686aa40905271405pc2f1738gc8dd139f61a0e27@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fa686aa40905271405pc2f1738gc8dd139f61a0e27@mail.gmail.com>
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
X-Uptime: 14:39:19 up 17 days,  3:03, 29 users,  load average: 0.15, 0.14,
	0.18
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 03:05:58PM -0600, Grant Likely wrote:
> On Wed, May 27, 2009 at 2:52 PM, Mark Brown
> <broonie@opensource.wolfsonmicro.com> wrote:
> > On Wed, May 27, 2009 at 08:29:10PM +0100, Russell King wrote:
> >> On Wed, May 27, 2009 at 02:08:42PM -0500, Scott Wood wrote:
> >
> >> > I'm not talking about platform specific code, I'm talking about code to
> >> > retrieve information about a device from the device tree.  There would
> >> > not be separate instances of this for "platforms X, Y and Z", just one
> >> > of_platform binding in each driver.  It's no different than having a
> >> > platform bus binding, except in the data structures used.
> >
> >> I really don't see what OF buys us then, apart from additional dependencies
> >> that have to be correct for the kernel to work.  I can only see disadvantages
> >> if all OF is, is a way to pass some file to the kernel to (effectively) tell
> >> it which drivers to use.
> >
> > The main selling points of the device tree AFAICT are that some
> > platforms have to use it it anyway due to the native OS and firmware for
> > the platform use it, the possibility of using the same device tree with
> > more than one OS (modulo unrepresentable holes) and the fact that some
> > people find it more convenient to use than straight data tables
> > (personally I find the two approaches to be much of a muchness there).
> > Perhaps I'm missing something, though?
> 
> Here are some that I've find useful:
> 
> There is the advantage that it decouples the machine description from
> the kernel code, which in turn seems to encourage code reuse.  There
> has been a significant decrease in the amount of platform specific
> code in powerpc since the switch to FDT booting.
> 
> There is the advantage of easy multiplatform support.  I regularly
> build a single kernel image which boots on all my MPC5200 boards, and
> on my MPC83xx boards.

That is not necessarily an advantage of a device tree. On ARM you can
also build a kernel which runs on 20+ PXA platforms at the same time.
(And I'm sure it can be done to even support say i.MX and PXA at the
same time, but this is another story)

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

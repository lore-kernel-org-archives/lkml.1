Return-Path: <linux-kernel-owner+w=401wt.eu-S932268AbZLNRor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268AbZLNRor (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 12:44:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932250AbZLNRoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 12:44:46 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:47445 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932244AbZLNRop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 12:44:45 -0500
From: "Madhusudhan" <madhu.cr@ti.com>
To: "'Daniel Mack'" <daniel@caiaq.de>,
       "'Adrian Hunter'" <adrian.hunter@nokia.com>
Cc: "'Matt Fleming'" <matt@console-pimps.org>,
       "'David Brownell'" <dbrownell@users.sourceforge.net>,
       "'Eric Miao'" <eric.y.miao@gmail.com>,
       "'Linus Walleij'" <linus.walleij@stericsson.com>,
       "'Lavinen Jarkko \(Nokia-D/Helsinki\)'" <jarkko.lavinen@nokia.com>,
       "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
       <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       "'Cliff Brake'" <cbrake@bec-systems.com>,
       "'Russell King'" <rmk+kernel@arm.linux.org.uk>,
       "'Pierre Ossman'" <pierre@ossman.eu>,
       "'Robert Jarzmik'" <robert.jarzmik@free.fr>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       <linux-arm-kernel@lists.infradead.org>,
       "'Liam Girdwood'" <lrg@slimlogic.co.uk>
References: <1259844390-10541-1-git-send-email-daniel@caiaq.de> <4B17CADB.1070406@nokia.com> <20091203192044.GJ14091@buzzloop.caiaq.de> <4B181BB4.1020800@nokia.com> <20091204115805.GS14091@buzzloop.caiaq.de> <20091212005854.GV28375@buzzloop.caiaq.de>
Subject: RE: [PATCH] mmc: move regulator handling to core
Date: Mon, 14 Dec 2009 11:43:34 -0600
Message-ID: <006501ca7ce4$f5b04c80$544ff780@am.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <20091212005854.GV28375@buzzloop.caiaq.de>
Thread-Index: Acp6xk0nB2tUW6IXSs6UjA/YA2YlTACHeQKQ
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Daniel Mack [mailto:daniel@caiaq.de]
> Sent: Friday, December 11, 2009 6:59 PM
> To: Adrian Hunter
> Cc: Matt Fleming; David Brownell; Eric Miao; Linus Walleij; Lavinen Jarkko
> (Nokia-D/Helsinki); Mark Brown; linux-mmc@vger.kernel.org; linux-
> kernel@vger.kernel.org; madhu.cr@ti.com >> Madhusudhan Chikkature; Cliff
> Brake; Russell King; Pierre Ossman; Robert Jarzmik; Andrew Morton; linux-
> arm-kernel@lists.infradead.org; Liam Girdwood
> Subject: Re: [PATCH] mmc: move regulator handling to core
> 
> On Fri, Dec 04, 2009 at 12:58:05PM +0100, Daniel Mack wrote:
> > > >On Thu, Dec 03, 2009 at 04:27:39PM +0200, Adrian Hunter wrote:
> >
> > > >>What about arch/arm/mach-omap2/mmc-twl4030.c ?
> > > >
> > > >Argh, missed that one. And this particular case doesn't fit to my
> > > >modifications. I don't know the code well ...  We would need to
> > > >have a struct mmc_host * in all the functions there calling
> > > >mmc_regulator_{set,get}_ocr. Any idea how to resolve that?
> > > >
> > >
> > > Pass it down from the omap_hsmmc driver.
> >
> > It's not that easy, unfortunately, because this code does not conform to
> > all the other mmc host drivers in tree.
> >
> > I don't understand why things are done the way it is currently
> > implemented. Why isn't there a mmc_host for each slot, and why is a
> > regulator reference acquired for each slot, and not once for the whole
> > device?
> >
> > Even with the default 'vcc' supply factored out to the mmc core, the
> > 'vmmc_aux' regulator would still need some extra attention, but I would
> > also do that from the omap_hsmmc driver rather than in the plaform
> > support code.
> >
> > Moving the regulator handling to the mmc core would require a major
> > cleanup to all this code, but I don't have such hardware to test my
> > modifications. Can anyone help here?

The mmc-twl4030 wrapper is being used by many
platforms(2430sdp,omap3_beagle,LDP,Overo,Omap3EVM,Pandora,3430SDP,Nokia_RX51
,Zoom2,Zoom3,3630SDP,CM_T35,IGEP0020).

I have access only to 3430Sdp, Zoom2 and Zoom3. I can test your changes on
these platforms. Would that help?

Regards,
Madhu
> 
> Can anyone of the OMAP people help sort this out?
> 
> Thanks,
> Daniel


Return-Path: <linux-kernel-owner+w=401wt.eu-S1758156AbXHBMmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156AbXHBMmf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 08:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757534AbXHBMmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 08:42:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37317 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758055AbXHBMmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 08:42:23 -0400
Subject: Re: 2.6.22 regression: thermal trip points
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Adrian =?ISO-8859-1?Q?Schr=F6ter?= <adrian@suse.de>,
       Knut Petersen <Knut_Petersen@t-online.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, pavel@ucw.cz, lenb@kernel.org,
       "Zhang, Rui" <rui.zhang@intel.com>, Jean Delvare <khali@linux-fr.org>,
       Alexey Starikovskiy <aystarik@gmail.com>
In-Reply-To: <20070802115631.GA29735@srcf.ucam.org>
References: <46B1988C.3090302@t-online.de>
	 <1186047747.18821.450.camel@queen.suse.de>
	 <200708021145.09377.adrian@suse.de>
	 <1186048701.18821.459.camel@queen.suse.de>
	 <20070802120221.5474e732@the-village.bc.nu>
	 <20070802111327.GA29002@srcf.ucam.org>
	 <1186055100.18821.494.camel@queen.suse.de>
	 <20070802115631.GA29735@srcf.ucam.org>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Thu, 02 Aug 2007 14:42:19 +0200
Message-Id: <1186058539.18821.523.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-02 at 12:56 +0100, Matthew Garrett wrote:
> On Thu, Aug 02, 2007 at 01:45:00PM +0200, Thomas Renninger wrote:
> > On Thu, 2007-08-02 at 12:13 +0100, Matthew Garrett wrote:
> > > I strongly suspect that the vast majority[1] of hardware that "needs" 
> > > the trip points changing works perfectly well under Windows, so it's 
> > > likely to be papering over bugs in the kernel. It'd be nice if we fixed 
> > > those rather than encouraging people to poke stuff into /proc,
> > Some arguments against that:
> >   - You cannot tell a customer: Wait for the kernel in half a year.
> >     This is the time it at least needs until a laptop got sold, the
> >     problem is found, a patch is written and checked in and finally
> >     hits the distribution.
> 
> We have to do so frequently. New hardware often exposes bugs in the 
> kernel.
And often we can provide a boot param or whatever, that makes it at
least useable.
> 
> >   - You can also not backport fixes as ACPI patches mostly have the
> >     potential to break other machines/BIOSes
> >   - There also exist the policy to not fix up/workaround totally broken
> >     AML BIOS implementations
> 
> The policy has been to attempt to be bug-compatible with Windows 
> whenever possible for some time now.
*whenever possible*
> 
> >   - We do not need to and never will be able to copy or do the same
> >     Windows is doing
> 
> Given that many vendors still only test against Windows, that's exactly 
> what we need to do.
But we cannot (copy all windows (mis-)behavior).
> 
> > > especially when doing so is guaranteed to break in really confusing ways 
> > > with a lot of hardware. The firmware can reset the trip points at 
> > > essentially arbitrary times and is well within its rights to expect the 
> > > OS to actually pay attention to them.
> > What the hell is so wrong with:
> > 
> > Let the user override the trip points. If he does so, ignore
> > thermal trip point updates from BIOS. Don't care for hysteresis
> > BIOS implementations (these are the BIOS trip point updates).
> 
> No, that's not the only reason for notifications. Alteration in hardware 
> state may also force a recalculation of trip point (adding a battery to 
> a bay rather than a DVD drive may require the platform to be kept at a 
> lower temperature)
"I've seen no evidence that this happens...", but I see the point.
> > If user changes them, it's his fault, he doesn't need to...
> > Make sure that trip points can only be lowered, compared to the
> > initially fetched one from BIOS.
> 
> Surely people want this functionality so that they can raise trip 
> points?
For Adrian it would be enough to be able to lower them.
Also being able to define a passive trip point (even if not provided by
BIOS) could help a lot machines.

What about at least:
  - Be able to override passive cooling trip point
  - If BIOS does not provide one, let user be able to define it
This should already make a lot people happy.

    Thomas



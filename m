Return-Path: <linux-kernel-owner+w=401wt.eu-S1757083AbXHBL46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083AbXHBL46 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 07:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754670AbXHBL4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 07:56:51 -0400
Received: from 78-32-9-130.no-dns-yet.enta.net ([78.32.9.130]:38122 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754355AbXHBL4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 07:56:50 -0400
Date: Thu, 2 Aug 2007 12:56:31 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Thomas Renninger <trenn@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Adrian =?iso-8859-1?Q?Schr=F6ter?= <adrian@suse.de>,
       Knut Petersen <Knut_Petersen@t-online.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, pavel@ucw.cz, lenb@kernel.org,
       "Zhang, Rui" <rui.zhang@intel.com>, Jean Delvare <khali@linux-fr.org>,
       Alexey Starikovskiy <aystarik@gmail.com>
Message-ID: <20070802115631.GA29735@srcf.ucam.org>
References: <46B1988C.3090302@t-online.de> <1186047747.18821.450.camel@queen.suse.de> <200708021145.09377.adrian@suse.de> <1186048701.18821.459.camel@queen.suse.de> <20070802120221.5474e732@the-village.bc.nu> <20070802111327.GA29002@srcf.ucam.org> <1186055100.18821.494.camel@queen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186055100.18821.494.camel@queen.suse.de>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: 2.6.22 regression: thermal trip points
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2007 at 01:45:00PM +0200, Thomas Renninger wrote:
> On Thu, 2007-08-02 at 12:13 +0100, Matthew Garrett wrote:
> > I strongly suspect that the vast majority[1] of hardware that "needs" 
> > the trip points changing works perfectly well under Windows, so it's 
> > likely to be papering over bugs in the kernel. It'd be nice if we fixed 
> > those rather than encouraging people to poke stuff into /proc,
> Some arguments against that:
>   - You cannot tell a customer: Wait for the kernel in half a year.
>     This is the time it at least needs until a laptop got sold, the
>     problem is found, a patch is written and checked in and finally
>     hits the distribution.

We have to do so frequently. New hardware often exposes bugs in the 
kernel.

>   - You can also not backport fixes as ACPI patches mostly have the
>     potential to break other machines/BIOSes
>   - There also exist the policy to not fix up/workaround totally broken
>     AML BIOS implementations

The policy has been to attempt to be bug-compatible with Windows 
whenever possible for some time now.

>   - We do not need to and never will be able to copy or do the same
>     Windows is doing

Given that many vendors still only test against Windows, that's exactly 
what we need to do.

> > especially when doing so is guaranteed to break in really confusing ways 
> > with a lot of hardware. The firmware can reset the trip points at 
> > essentially arbitrary times and is well within its rights to expect the 
> > OS to actually pay attention to them.
> What the hell is so wrong with:
> 
> Let the user override the trip points. If he does so, ignore
> thermal trip point updates from BIOS. Don't care for hysteresis
> BIOS implementations (these are the BIOS trip point updates).

No, that's not the only reason for notifications. Alteration in hardware 
state may also force a recalculation of trip point (adding a battery to 
a bay rather than a DVD drive may require the platform to be kept at a 
lower temperature)

> If user changes them, it's his fault, he doesn't need to...
> Make sure that trip points can only be lowered, compared to the
> initially fetched one from BIOS.

Surely people want this functionality so that they can raise trip 
points?

-- 
Matthew Garrett | mjg59@srcf.ucam.org

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755836AbXHBLpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836AbXHBLpS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 07:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753660AbXHBLpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 07:45:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32966 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690AbXHBLpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 07:45:05 -0400
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
In-Reply-To: <20070802111327.GA29002@srcf.ucam.org>
References: <46B1988C.3090302@t-online.de>
	 <1186047747.18821.450.camel@queen.suse.de>
	 <200708021145.09377.adrian@suse.de>
	 <1186048701.18821.459.camel@queen.suse.de>
	 <20070802120221.5474e732@the-village.bc.nu>
	 <20070802111327.GA29002@srcf.ucam.org>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Thu, 02 Aug 2007 13:45:00 +0200
Message-Id: <1186055100.18821.494.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-02 at 12:13 +0100, Matthew Garrett wrote:
> On Thu, Aug 02, 2007 at 12:02:21PM +0100, Alan Cox wrote:
> > > Anyway, only solution/workaround to use these machines with current
> > > kernels is to override trip points, maybe the patch should really just
> > > be reverted...
> > 
> > The question really is whether the vendors will all revert it and carry
> > it as a patch or whether the main tree will accept reality on this one.
> > 
> > Reverting it and adding a taint marker if you do it is much preferable I
> > suspect to having every vendor revert this bogus if well meaning
> > changeset.
> 
> I strongly suspect that the vast majority[1] of hardware that "needs" 
> the trip points changing works perfectly well under Windows, so it's 
> likely to be papering over bugs in the kernel. It'd be nice if we fixed 
> those rather than encouraging people to poke stuff into /proc,
Some arguments against that:
  - You cannot tell a customer: Wait for the kernel in half a year.
    This is the time it at least needs until a laptop got sold, the
    problem is found, a patch is written and checked in and finally
    hits the distribution.
  - You can also not backport fixes as ACPI patches mostly have the
    potential to break other machines/BIOSes
  - There also exist the policy to not fix up/workaround totally broken
    AML BIOS implementations
  - We do not need to and never will be able to copy or do the same
    Windows is doing
  - ...    

> especially when doing so is guaranteed to break in really confusing ways 
> with a lot of hardware. The firmware can reset the trip points at 
> essentially arbitrary times and is well within its rights to expect the 
> OS to actually pay attention to them.
What the hell is so wrong with:

Let the user override the trip points. If he does so, ignore
thermal trip point updates from BIOS. Don't care for hysteresis
BIOS implementations (these are the BIOS trip point updates).
If user changes them, it's his fault, he doesn't need to...
Make sure that trip points can only be lowered, compared to the
initially fetched one from BIOS.

This is neither confusing, nor dangerous in any way (beside the fact
that the critical trip point might get dynamically lowered by BIOS,
which is totally insane).

  Thomas

> 
> [1] Some hardware is simply broken. We don't carry phc just because some 
> vendors put the wrong voltage values in their tables, either



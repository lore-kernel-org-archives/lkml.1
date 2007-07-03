Return-Path: <linux-kernel-owner+w=401wt.eu-S1762328AbXGCVqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762328AbXGCVqB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 17:46:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760022AbXGCVpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 17:45:52 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:43810
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754447AbXGCVpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 17:45:50 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Don't miss the ARM-scsi fix.
Date: Tue, 3 Jul 2007 17:45:45 -0400
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
References: <200707031503.56561.rob@landley.net> <20070703122145.447c7d2c.akpm@linux-foundation.org>
In-Reply-To: <20070703122145.447c7d2c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707031745.45957.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 July 2007 15:21:45 Andrew Morton wrote:
> On Tue, 3 Jul 2007 15:03:56 -0400
>
> Rob Landley <rob@landley.net> wrote:
> > Just making sure this fix winds up in 2.6.23:
>
> 2.6.22?

Er, yes.  (After my six red bulls at the Blackthorn party, I've gone cold 
turkey on caffeine for a bit to detox.  I'm surprised I'm still upright.)

> > http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=4454/1
> >
> > It fixes a regression that occurred between 2.6.20 and 2.6.20-rc1. 
> > Without it, qemu-system-arm can't use emulated SCSI drives.  It wasn't in
> > -rc7, and the attached patch Works For Me (tm).
>
> Should have cc'ed Russell?

I cc'd the arm list, which he's on.  Low enough traffic I expected him to get 
it soonish, but I can cc: him directly if you like.

> > Signed-off-by: Rob Landley <rob@landley.net>
> >
> > Rob
> > --
> > "One of my most productive days was throwing away 1000 lines of code."
> >   - Ken Thompson.
> >
> >
> > [linux-armfix.patch  text/x-diff (1.1KB)]
> > ARM Versatile PCI config reads of one byte width have the lowest two<br
> > /> bits of the address cleared and result in reading from a wrong
> > place<br />
>
> html gunk in changelog

Sorry, that's from my quick grab of the web page above.

I expect this to come through the proper arm channels rather than mine, the 
attach was just to be specific about the patch I was talking about.

> > in the config space.  This change is to use word size accesses like it is
> > done for halfword reads.
> >
> > Byte reads are used for retrieving the IRQ number of a PCI device and the
> > problem was not exposed until 2.6.20 because the value read was discarded
> > in drivers/pci/setup-irq.c (recently fixed).
> >
> > Signed-off-by: Andrzej Zaborowski  &lt;(address hidden)&gt;<br />
> > Acked-by: Paul Brook  &lt;(address hidden)&gt;
>
> more

Sorry.

> > Note 2 submitted by Russell King on 02 Jul 2007 12:39:41 (UTC)
> > Moved to applied
> > Applied to git-curr.
> >
> > diff --git a/arch/arm/mach-versatile/pci.c
> > b/arch/arm/mach-versatile/pci.c index ba58223..ca82901 100644
> > --- a/arch/arm/mach-versatile/pci.c
> > +++ b/arch/arm/mach-versatile/pci.c
> > @@ -117,7 +117,10 @@ static int versatile_read_config(struct pci_bus
> > *bus, unsigned int devfn, int wh } else {
> >  		switch (size) {
> >  		case 1:
> > -			v = __raw_readb(addr);
> > +			v = __raw_readl(addr);
> > +			if (where & 2) v >>= 16;
> > +			if (where & 1) v >>= 8;
>
> Someone's enter key broke?

That's what the patch looked like when I got it. :)

I'm just an intrested party who's been trying to fix this particular problem 
on my own (without success) for a couple months now.  I hadn't been able to 
upgrade Firmware Linux past 2.6.20 because ARM doesn't work on the newer 
stuff, and it still doesn't work on 2.6.22-rc7 without this fix.

I found the fix yesterday, and would really really like it not to miss the 
actual release.  This was my attempt to make puppy eyes at subsystem 
maintainers and add a signed-off-by to a small fix that unblocks a project 
I'm working on. :)

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.

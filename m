Return-Path: <linux-kernel-owner+w=401wt.eu-S1760287AbYF3Kkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760287AbYF3Kkg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 06:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754882AbYF3Kk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 06:40:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49233 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753709AbYF3KkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 06:40:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
Date: Mon, 30 Jun 2008 12:41:56 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Ingo Molnar <mingo@elte.hu>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Andi Kleen <andi-suse@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <200806300106.38414.rjw@sisk.pl> <Pine.LNX.4.55.0806300205180.22548@cliff.in.clinika.pl>
In-Reply-To: <Pine.LNX.4.55.0806300205180.22548@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806301241.57781.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 30 of June 2008, Maciej W. Rozycki wrote:
> On Mon, 30 Jun 2008, Rafael J. Wysocki wrote:
> 
> > > > well as long as we eliminate the bad effects around via DMI exceptions 
> > > > nobody will feel the need to argue whether it's a regression ;-) [this 
> > > > problem could be argued to be a regression, even if it's caused by prior 
> > > > luck/stupidity of Linux. We have to live with the effects of our 
> > > > mistakes.]
> > > 
> > >  Of course -- this is the only reason I can be bothered with the issue in
> > > the first place.  Otherwise, I would have said: 'Get the manufacturer to
> > > fix it, use "noapic" or live with a local patch.'
> > 
> > In that case your patch would surely make it to the regression list.
> 
>  Please be careful -- you seem to contradict yourself.  I wrote to the
> effect of: "If this wasn't a regression, I would have said [...]" and your
> reply is: "In that case your [non-regressing] patch would surely make it
> to the regression list."

Sorry, I didn't parse that paragraph correctly

> > >  This is actually how I have kept one of my old MPS SMP systems up for
> > > years now -- it has a broken MP table which prevents interrupts from
> > > working when too many PCI option cards are present, so I have prepared a
> > > patch for patching the table manually.  I proposed it once, which you may
> > > recall, but it was rejected on the grounds of the syntax being too tough
> > > to comprehend to a poor average user being.  I am sure more systems would
> > > benefit as MP table breakages used to be quite common.
> > > 
> > >  Here the simple workaround was "noapic" too, so everyone else could be
> > > happy and I have been happy to keep the patch and use the capabilities of
> > > the piece of hardware properly despite its broken firmware.
> > 
> > Again.  If there's a configuration that didn't need any manual workarounds
> > before, it's expected to continue to work without any manual workarounds and
> > as a patch submitter, it's _your_ burden to make that happen.
> 
>  That is certainly true for standard hardware.  We have to take
> responsibility for own bugs, sure.  I cannot readily understand why you
> apparently try to imply hardware vendors do not.
> 
> > Otherwise you throw this burden onto users who
> > (1) don't expect things to stop working,
> > (2) may not be able to figure out themselves what the right workaround is,
> > (3) may not be able to make hardware manufacturers do anything.
> > 
> > If there's a configuration that worked before your patch and doesn't work
> > after it, you're hurting the users of that configuration.
> 
>  Honestly?  These poor users who have no clue or time to follow the
> development lists and/or fix bugs themselves should report the problem to
> the supplier of their Linux distribution, who would sort it out by, first,
> providing a temporary workaround till the problem is sorted out correctly,
> second, contacting the hardware vendor through a recognised channel to
> request the problem to be investigated and fixed properly.  I am fairly
> sure all the reputable (responsible?) distribution vendors have service
> agreements already in place with all the major hardware vendors and all
> the minor hardware vendors will be happy to cooperate anyway so as not to
> be minor vendors anymore.  This is why I have asked for points of contact 
> repeatedly in this thread.
> 
>  Of course it leaves hobbyist distributions at a slight disadvantage, but
> their users are sort of expected to be "power users" (otherwise they
> wouldn't have been hobbyists, would they?) and adding an option or a patch
> even should not be a problem for them.  We may try to do our best to help
> them, but not at the price of penalising good hardware.

Well, there are lots of pieces of hardware that are not up to the
specifications, more or less, and I don't think that's a good enough reason
for us to refuse to support them.  The same applies to BIOSes IMO.

Of course, the _default_ should be to follow the spec, but if that doesn't work
on given hardware/BIOS combination and we know what to do to handle it, we
should just handle it instead of asking users to fix their BIOSes.

I have seen enough failed BIOS upgrades to be very cautious about such things.
Certainly, I wouldn't have seriously asked anyone to upgrade the BIOS in a
notebook, because if that had failed, the user would have end up with a piece
of electronic junk.

Thanks,
Rafael

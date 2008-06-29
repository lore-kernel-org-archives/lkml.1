Return-Path: <linux-kernel-owner+w=401wt.eu-S1753961AbYF2XFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbYF2XFc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 19:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbYF2XFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 19:05:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46504 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888AbYF2XFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 19:05:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
Date: Mon, 30 Jun 2008 01:06:37 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Ingo Molnar <mingo@elte.hu>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Andi Kleen <andi-suse@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <20080629200210.GB31633@elte.hu> <Pine.LNX.4.55.0806292104560.22548@cliff.in.clinika.pl>
In-Reply-To: <Pine.LNX.4.55.0806292104560.22548@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806300106.38414.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 29 of June 2008, Maciej W. Rozycki wrote:
> On Sun, 29 Jun 2008, Ingo Molnar wrote:
> 
> > >  You may argue this is a regression, but this is simply the cost paid 
> > > for progress -- the kernel stays within the spec as defined both by 
> > > ACPI and MPS, we have just started using a different configuration now 
> > > and an interrupt source override provided by the manufacturer 
> > > explicitly states INTIN2 is good to use.  In a sense you were simply 
> > > lucky previously the kernel was bad enough with the way it configured 
> > > the timer through the I/O APIC it failed completely avoiding the bug 
> > > in your firmware.  Now the bug has got uncovered.
> > 
> > well as long as we eliminate the bad effects around via DMI exceptions 
> > nobody will feel the need to argue whether it's a regression ;-) [this 
> > problem could be argued to be a regression, even if it's caused by prior 
> > luck/stupidity of Linux. We have to live with the effects of our 
> > mistakes.]
> 
>  Of course -- this is the only reason I can be bothered with the issue in
> the first place.  Otherwise, I would have said: 'Get the manufacturer to
> fix it, use "noapic" or live with a local patch.'

In that case your patch would surely make it to the regression list.

>  This is actually how I have kept one of my old MPS SMP systems up for
> years now -- it has a broken MP table which prevents interrupts from
> working when too many PCI option cards are present, so I have prepared a
> patch for patching the table manually.  I proposed it once, which you may
> recall, but it was rejected on the grounds of the syntax being too tough
> to comprehend to a poor average user being.  I am sure more systems would
> benefit as MP table breakages used to be quite common.
> 
>  Here the simple workaround was "noapic" too, so everyone else could be
> happy and I have been happy to keep the patch and use the capabilities of
> the piece of hardware properly despite its broken firmware.

Again.  If there's a configuration that didn't need any manual workarounds
before, it's expected to continue to work without any manual workarounds and
as a patch submitter, it's _your_ burden to make that happen.

Otherwise you throw this burden onto users who
(1) don't expect things to stop working,
(2) may not be able to figure out themselves what the right workaround is,
(3) may not be able to make hardware manufacturers do anything.

If there's a configuration that worked before your patch and doesn't work
after it, you're hurting the users of that configuration.

Thanks,
Rafael

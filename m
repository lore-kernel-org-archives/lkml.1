Return-Path: <linux-kernel-owner+w=401wt.eu-S932401AbYF2UQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932401AbYF2UQv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 16:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757549AbYF2UQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 16:16:42 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:62500 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756185AbYF2UQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 16:16:41 -0400
Date: Sun, 29 Jun 2008 21:14:35 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Andi Kleen <andi-suse@firstfloor.org>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
In-Reply-To: <20080629200210.GB31633@elte.hu>
Message-ID: <Pine.LNX.4.55.0806292104560.22548@cliff.in.clinika.pl>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <200806291600.29059.rjw@sisk.pl>
 <Pine.LNX.4.55.0806291952590.22548@cliff.in.clinika.pl> <200806292123.16237.rjw@sisk.pl>
 <Pine.LNX.4.55.0806292023320.22548@cliff.in.clinika.pl> <20080629200210.GB31633@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jun 2008, Ingo Molnar wrote:

> >  You may argue this is a regression, but this is simply the cost paid 
> > for progress -- the kernel stays within the spec as defined both by 
> > ACPI and MPS, we have just started using a different configuration now 
> > and an interrupt source override provided by the manufacturer 
> > explicitly states INTIN2 is good to use.  In a sense you were simply 
> > lucky previously the kernel was bad enough with the way it configured 
> > the timer through the I/O APIC it failed completely avoiding the bug 
> > in your firmware.  Now the bug has got uncovered.
> 
> well as long as we eliminate the bad effects around via DMI exceptions 
> nobody will feel the need to argue whether it's a regression ;-) [this 
> problem could be argued to be a regression, even if it's caused by prior 
> luck/stupidity of Linux. We have to live with the effects of our 
> mistakes.]

 Of course -- this is the only reason I can be bothered with the issue in
the first place.  Otherwise, I would have said: 'Get the manufacturer to
fix it, use "noapic" or live with a local patch.'

 This is actually how I have kept one of my old MPS SMP systems up for
years now -- it has a broken MP table which prevents interrupts from
working when too many PCI option cards are present, so I have prepared a
patch for patching the table manually.  I proposed it once, which you may
recall, but it was rejected on the grounds of the syntax being too tough
to comprehend to a poor average user being.  I am sure more systems would
benefit as MP table breakages used to be quite common.

 Here the simple workaround was "noapic" too, so everyone else could be
happy and I have been happy to keep the patch and use the capabilities of
the piece of hardware properly despite its broken firmware.

  Maciej

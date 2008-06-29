Return-Path: <linux-kernel-owner+w=401wt.eu-S1761045AbYF2T5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761045AbYF2T5q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 15:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754961AbYF2T5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 15:57:37 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:62351 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753590AbYF2T5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 15:57:36 -0400
Date: Sun, 29 Jun 2008 20:56:30 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Andi Kleen <andi-suse@firstfloor.org>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
In-Reply-To: <200806292123.16237.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.55.0806292023320.22548@cliff.in.clinika.pl>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <200806291600.29059.rjw@sisk.pl>
 <Pine.LNX.4.55.0806291952590.22548@cliff.in.clinika.pl> <200806292123.16237.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jun 2008, Rafael J. Wysocki wrote:

> >  It is the reverse -- checking the DSDT ID is coarser, matching all the
> > systems that use the broken firmware.
> 
> How can you tell which DSDTs are broken until somebody reports them?

 We know the DSDT matching OEM ID: "HP ", OEM Table ID: "SB400" and OEM
Revision: 10000 is broken, because it has already been reported.  If these
properties are checked, there is no need to for further reports providing
us with DMI IDs of systems using the same DSDT.  The revision can be used
to make sure a good one is not selected inadvertently.

> > With DMI we may face both false positives and false negatives which imply
> > further maintenance actions.   
> 
> With DSDT matching you're likely to end up breaking systems the users of
> which have not reported problems.

 s/breaking/fixing/

 Besides, there is nothing to break here -- the mixed interrupt mode will
be used when the workaround is selected and the mode has to work or pieces
of legacy software, such as DOS, which make use of the 8259A would not
work.

> >  Have you tried to report the issue through the usual manufacturer's
> > support channels, BTW?
> 
> My experience with HP indicates that it would have been a loss of time.

 Well, if you do not report problems, they may never know of their
existence and obviously will have no way to fix them.  They may ignore
your report, but at least you can say you have done your part.  Based on
the experience the next time you may choose another manufacturer when
making a purchase decision.

> Apart from this, I've always been against forcing people to upgrade their
> BIOSes just because we just had a briliant idea that made the kernel stop
> working on their systems.  IMO it's extremely user-unfriendly and plain wrong.

 The BIOS is broken and should be fixed -- it is not our mission to fix up
somebody else's faults.  As a courtesy to users we may try to work around
problems that are hard for them to cope with, but in a sense this is
promoting bad quality of hardware: "Don't bother doing this properly --
they will fix it up somehow in the OS anyway."

 You may argue this is a regression, but this is simply the cost paid for
progress -- the kernel stays within the spec as defined both by ACPI and
MPS, we have just started using a different configuration now and an
interrupt source override provided by the manufacturer explicitly states
INTIN2 is good to use.  In a sense you were simply lucky previously the
kernel was bad enough with the way it configured the timer through the I/O
APIC it failed completely avoiding the bug in your firmware.  Now the bug
has got uncovered.

 And last but not least, you can always specify "noapic" to get away --
that's a perfectly good workaround.

 I'll cook up the part I promised shortly and leave it up to the others to
"wire" it to some breakage detection logic.

  Maciej

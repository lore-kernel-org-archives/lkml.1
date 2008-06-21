Return-Path: <linux-kernel-owner+w=401wt.eu-S1756789AbYFUCnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789AbYFUCnN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 22:43:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753870AbYFUCmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 22:42:55 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64589 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753593AbYFUCmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 22:42:54 -0400
Date: Sat, 21 Jun 2008 03:41:37 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
In-Reply-To: <20080621014047.GA20908@srcf.ucam.org>
Message-ID: <Pine.LNX.4.55.0806210321470.19614@cliff.in.clinika.pl>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <200806201353.59083.rjw@sisk.pl>
 <20080620115714.GC8637@srcf.ucam.org> <200806201422.12659.rjw@sisk.pl>
 <20080620122714.GA9332@srcf.ucam.org> <Pine.LNX.4.55.0806202241120.19614@cliff.in.clinika.pl>
 <20080621014047.GA20908@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jun 2008, Matthew Garrett wrote:

> >  Meanwhile we may consider implementing a workaround.  I think one that 
> > does not hurt competent vendors would be preferable.  The DSDT containing 
> > the rubbish described here is marked with an OEM ID: "HP    " and OEM 
> > Table ID: "SB400".  These keys could be used to remove IRQ0 information
> > from the IRQ tables.  Our code is prepared to handle such a case.  
> > Something easy to do for a seasoned ACPI fiddler, I suppose. ;)
> 
> Something roughly like the following? Entirely untested, my 6125 is in a 

 Maybe, though your code seems to match product IDs rather than the broken
DSDT itself.  I think the latter would be preferable as it would cover all
the pieces of equipment using the broken piece of firmware rather than
ones we have already tracked down.  Perhaps the version could be included
too, but that would only make sense if the breakage ever gets fixed -- the
use of the through-8259A mode for the 8254 timer would allow this piece of
equipment to benefit from the I/O APIC driven NMI watchdog.

> box somewhere. My recollection is that skip_timer_override will disable 
> the IRQ 0->2 mapping, which I believe is what's broken here?

 Not exactly.  The IRQ0->2 mapping is certainly wrong here, but so is the
identity IRQ0->0 one.  Which means it should not be recorded in
mp_config_acpi_legacy_irqs() at all.  I can cook this part if you'd rather
not to, if you do the ACPI part.  If you think there is no easy way to
match the DSDT rather than the product ID -- we are trying to cope with
outright breakage here after all, so any amount of effort is too much ;)  
-- I can update your proposal with what I have in mind.

 One point to note -- perhaps it would be better to avoid these #ifdef
clauses -- even though it's a workaround, I think the amount of resources
consumed does not justify the clutter introduced.

 Thanks for your submission.

  Maciej

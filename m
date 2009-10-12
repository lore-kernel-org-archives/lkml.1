Return-Path: <linux-kernel-owner+w=401wt.eu-S1757197AbZJLRUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197AbZJLRUQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 13:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756257AbZJLRUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 13:20:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47034 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756033AbZJLRUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 13:20:13 -0400
Date: Mon, 12 Oct 2009 19:19:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Ricardo Jorge da Fonseca Marques Ferreira 
	<storm@sys49152.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Yannick Roehlly <yannick.roehlly@free.fr>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, x86@kernel.org
Subject: Re: [PATCH] pci: increase alignment to make more space for hidden
	code
Message-ID: <20091012171915.GB9596@elte.hu>
References: <200908072333.24631.storm@sys49152.net> <4ACAC8F1.1050706@kernel.org> <4AD24B5C.4050905@kernel.org> <200910121059.10366.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910121059.10366.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> On Sunday 11 October 2009 03:17:16 pm Yinghai Lu wrote:
> > for
> > 
> > http://bugzilla.kernel.org/show_bug.cgi?id=13940
> > 
> > some system when acpi are enabled, acpi clears some BAR for some devices without
> > reason, and kernel will need to allocate devices for them.
> 
> "ACPI clears some BARs"?  I'm dubious.  The handoff state is the same
> whether we boot with "acpi=off" or not, so the BIOS can't be clearing
> them.  I really don't think the ACPI code in Linux clears BARs.  The
> Linux PCI code might be clearing BARs, but it sure would be nice to
> know exactly why.  Did you ever figure that out?
> 
> > try to increase alignment to get more safe range for unassigned devices.
> > 
> > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> > 
> > ---
> >  arch/x86/kernel/e820.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > Index: linux-2.6/arch/x86/kernel/e820.c
> > ===================================================================
> > --- linux-2.6.orig/arch/x86/kernel/e820.c
> > +++ linux-2.6/arch/x86/kernel/e820.c
> > @@ -1378,8 +1378,8 @@ static unsigned long ram_alignment(resou
> >  	if (mb < 16)
> >  		return 1024*1024;
> >  
> > -	/* To 32MB for anything above that */
> > -	return 32*1024*1024;
> > +	/* To 64MB for anything above that */
> > +	return 64*1024*1024;
> 
> How do we know 64MB is the correct alignment?
> 
> This feels like a hack that accidentally covers up the problem.  I 
> don't think we understand what's happening well enough.

Perhaps hidden chipset BARs getting protected by the larger granularity? 
Do we know the before/after allocation layout?

	Ingo

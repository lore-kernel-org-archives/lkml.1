Return-Path: <linux-kernel-owner+w=401wt.eu-S1757337AbZA2OLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337AbZA2OLh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 09:11:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbZA2OL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 09:11:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36252 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692AbZA2OL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 09:11:27 -0500
Date: Thu, 29 Jan 2009 15:11:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frans Pop <elendil@planet.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <greg@kroah.com>,
       jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken
	on Toshiba R500 (bisected)
Message-ID: <20090129141111.GN24391@elte.hu>
References: <200812020320.31876.rjw@sisk.pl> <alpine.LFD.2.00.0812041037250.3543@nehalem.linux-foundation.org> <alpine.LFD.2.00.0812051312160.3386@nehalem.linux-foundation.org> <200901281300.40171.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901281300.40171.elendil@planet.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frans Pop <elendil@planet.nl> wrote:

> On Friday 05 December 2008, Linus Torvalds wrote:
> > On Thu, 4 Dec 2008, Linus Torvalds wrote:
> > > The third thing that worries me is the _very_ early occurrence of
> > >
> > > 	ACPI: Waking up from system sleep state S3
> > > 	APIC error on CPU1: 00(40)
> > > 	ACPI: EC: non-query interrupt received, switching to interrupt mode
> > >
> > > Now, that "APIC error" thing is worrisome. It's worrisome for
> > > multiple reasons:
> > >
> > >  - errors are never good (0x40 means "received illegal vector",
> > > whatever caused _that_)
> > >
> > >  - more importantly, it seems to imply that interrupts are enabled on
> > >    CPU1, and they sure as hell shouldn't be enabled at this stage!
> > >
> > >    Do we perhaps have a SMP resume bug where we resume the other
> > > CPU's with interrupts enabled?
> > >
> > >  - the "ACPI: EC: non-query interrupt received, switching to
> > > interrupt mode" thing is from ACPI, and _also_ implies that
> > > interrupts are on.
> > >
> > > Why are interrupts enabled that early? I really don't like seeing
> > > interrupts enabled before we've even done the basic PCI resume.
> 
> Quick revival of this old thread with good news.
> The "APIC error on CPU1" message is now gone!

that was an old mystery!

So enabling interrupts too early (possibly before the lapic, the hpet or 
both are initialized properly?) can generate an APIC error message?

> With current git head I get:
>    ACPI: Waking up from system sleep state S3
>    ACPI: EC: non-query interrupt received, switching to interrupt mode

i started getting those messages too - but earlier in the cycle, during 
one of the ACPI merges i think.

	Ingo

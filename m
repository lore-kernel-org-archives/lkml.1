Return-Path: <linux-kernel-owner+w=401wt.eu-S1758835AbZA2Oti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758835AbZA2Oti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 09:49:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753880AbZA2Ot2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 09:49:28 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43337 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863AbZA2Ot1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 09:49:27 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>, Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken on Toshiba R500 (bisected)
Date: Thu, 29 Jan 2009 15:48:35 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: Frans Pop <elendil@planet.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200901281300.40171.elendil@planet.nl> <20090129141111.GN24391@elte.hu>
In-Reply-To: <20090129141111.GN24391@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901291548.36575.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 January 2009, Ingo Molnar wrote:
> 
> * Frans Pop <elendil@planet.nl> wrote:
> 
> > On Friday 05 December 2008, Linus Torvalds wrote:
> > > On Thu, 4 Dec 2008, Linus Torvalds wrote:
> > > > The third thing that worries me is the _very_ early occurrence of
> > > >
> > > > 	ACPI: Waking up from system sleep state S3
> > > > 	APIC error on CPU1: 00(40)
> > > > 	ACPI: EC: non-query interrupt received, switching to interrupt mode
> > > >
> > > > Now, that "APIC error" thing is worrisome. It's worrisome for
> > > > multiple reasons:
> > > >
> > > >  - errors are never good (0x40 means "received illegal vector",
> > > > whatever caused _that_)
> > > >
> > > >  - more importantly, it seems to imply that interrupts are enabled on
> > > >    CPU1, and they sure as hell shouldn't be enabled at this stage!
> > > >
> > > >    Do we perhaps have a SMP resume bug where we resume the other
> > > > CPU's with interrupts enabled?
> > > >
> > > >  - the "ACPI: EC: non-query interrupt received, switching to
> > > > interrupt mode" thing is from ACPI, and _also_ implies that
> > > > interrupts are on.
> > > >
> > > > Why are interrupts enabled that early? I really don't like seeing
> > > > interrupts enabled before we've even done the basic PCI resume.
> > 
> > Quick revival of this old thread with good news.
> > The "APIC error on CPU1" message is now gone!
> 
> that was an old mystery!
> 
> So enabling interrupts too early (possibly before the lapic, the hpet or 
> both are initialized properly?) can generate an APIC error message?

Hmm, I think that's something different, because the APIC error was on CPU1.
Perhaps the restoration of all standard PCI config spaces before bringing CPU1
up helped here.

> > With current git head I get:
> >    ACPI: Waking up from system sleep state S3
> >    ACPI: EC: non-query interrupt received, switching to interrupt mode
> 
> i started getting those messages too - but earlier in the cycle, during 
> one of the ACPI merges i think.

AFAICS, the last message only means that the ACPI EC code is now going to use
interrupts instead of polling, which generally is good.

Alex, is that correct?

Thanks,
Rafael

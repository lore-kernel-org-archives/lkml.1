Return-Path: <linux-kernel-owner+w=401wt.eu-S1755721AbYJFRzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721AbYJFRzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 13:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755441AbYJFRzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 13:55:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49264 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755427AbYJFRzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 13:55:32 -0400
Date: Mon, 6 Oct 2008 19:54:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jason Vas Dias <jason.vas.dias@gmail.com>
Subject: Re: [PATCH] x86 ACPI: Blacklist two HP machines with buggy BIOSes
	(Re: 2.6.27-rc8+ - first impressions)
Message-ID: <20081006175456.GA24480@elte.hu>
References: <20081005183603.GA3263@amd.corenet.prv> <200810060029.42471.rjw@sisk.pl> <20081006062235.GA2808@amd.corenet.prv> <200810061159.30103.rjw@sisk.pl> <alpine.LFD.2.00.0810060749570.3208@nehalem.linux-foundation.org> <20081006150055.GA16930@elte.hu> <alpine.LFD.1.10.0810061815060.10470@ftp.linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0810061815060.10470@ftp.linux-mips.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Maciej W. Rozycki <macro@linux-mips.org> wrote:

> On Mon, 6 Oct 2008, Ingo Molnar wrote:
> 
> > i think it was caused by this stream of IO-APIC changes:
> > 
> >  49a66a0: x86: I/O APIC: Always report how the timer has been set up
> >  17c4469: x86: I/O APIC: Include <asm/i8259.h> required by some code
> >  593f4a7: x86: APIC: remove apic_write_around(); use alternatives
> >  ce8b06b: x86: I/O APIC: remove an IRQ2-mask hack
> >  af17478: x86: I/O APIC: Never configure IRQ2
> >  c88ac1d: x86: L-APIC: Always fully configure IRQ0
> >  1baea6e: x86: L-APIC: Set IRQ0 as edge-triggered
> > 
> > Rafael/Maciej, which of these is causing it? ce8b06b ("x86: I/O APIC: 
> > remove an IRQ2-mask hack")?
> 
>  None of the above.  This:
> 
> 691874f: x86: I/O APIC: timer through 8259A second-chance
> 
> This change has fixed a problem with the timer for a lot of systems 
> and permitted the removal of a bunch of horrible hacks we used to have 
> in our I/O-APIC/timer code, including a command-line override 
> parameter, needed so that some systems would boot at all.
> 
>  This single instance of a piece of some HP gear being twisted beyond 
> belief is IMO a minor annoyance and price to pay compared to the gain.  
> Please note that apart from the DSDT being buggy on this machine, it 
> has an incorrect IRQ 0 override in the ACPI table pointing to the pin 
> #2 of the I/O APIC, which is in fact routed to the output of the 
> master 8259A.  Additionally the pin #0 of the I/O APIC which is indeed 
> routed to the output of the 8254 does not receive any interrupts, 
> presumably because of some misconfiguration during BIOS 
> initialisation.  So in fact this machine suffers from three 
> configuration problems at once of which all add up to the end result 
> we can observe.

okay. Perhaps we can find some better DMI filter for affected 
HP+AMD+Turion laptops - how futile that might be. No chance to have some 
automated non-DMI check?

	Ingo

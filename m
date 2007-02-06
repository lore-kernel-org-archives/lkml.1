Return-Path: <linux-kernel-owner+w=401wt.eu-S965511AbXBFWJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965511AbXBFWJG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 17:09:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965477AbXBFWJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 17:09:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48405 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965511AbXBFWJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 17:09:04 -0500
Date: Tue, 6 Feb 2007 23:08:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-rc6-mm3
Message-ID: <20070206220855.GB5109@elte.hu>
References: <1170788870.3785.9.camel@chaos> <1170791739.3455.3.camel@dwalker1> <1170793206.3785.16.camel@chaos> <1170794437.3455.20.camel@dwalker1> <20070206205231.GA25430@elte.hu> <1170795378.3455.31.camel@dwalker1> <20070206210959.GC25430@elte.hu> <1170796999.3455.43.camel@dwalker1> <20070206214131.GA1176@elte.hu> <1170798879.3455.58.camel@dwalker1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170798879.3455.58.camel@dwalker1>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.3 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4987]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> > > If we change the current "timer" entry to be listed as 
> > > "lapic-timer" and not "IO-APIC-edge" (or one of the other names) 
> > > and replace it with the count from LOC
[...]
> > But, as per the previous mails, the new behavior is just fine, 
> > because /proc/interrupts just reflects reality. And the way the 
> > kernel utilizes the hardware has just changed - for the better.
> > 
> > The same happens when say a network driver implements NAPI: the IRQ 
> > count goes way, way down. Or if a driver starts supporing MSI - the 
> > IRQ line even moves to another one. Do we try to fix those counts up 
> > to match the 'previous behavior'? Of course not. What you are 
> > suggesting makes no sense, is against current kernel practices - as 
> > we pointed it out to you 7 mails ago.
> 
> I'm not saying we should "fake" anything .. [...]

sorry but that's precisely what your suggestion above results in:

> > > If we change the current "timer" entry to be listed as 
> > > "lapic-timer" and not "IO-APIC-edge" (or one of the other names) 
> > > and replace it with the count from LOC

"replace the timer entry with lapic-timer and put the LOC count there" 
is faking something that does not reflect reality. The 'timer' count is 
for IRQ#0, not for the local apic timer.

> [...] I'm saying list what's really happening .. In a human readable 
> way .

we list precisely what is happening: the number of IRQ#0 interrupts and 
the number of local APIC timer interrupts. Precisely where their 
traditional place is.

i think you might be confused by the generic name that says 'timer'. You 
should notice the other bits that are there too:

           CPU0       CPU1
  0:        495          0   IO-APIC-edge      timer

the '0' means IRQ#0. That makes it clear that this is the PIT timer. 
Clearer now?

	Ingo

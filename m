Return-Path: <linux-kernel-owner+w=401wt.eu-S965591AbXBFXup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965591AbXBFXup (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 18:50:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965598AbXBFXup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 18:50:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34792 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965591AbXBFXul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 18:50:41 -0500
Date: Wed, 7 Feb 2007 00:51:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-rc6-mm3
Message-ID: <20070206235102.GC21969@elte.hu>
References: <20070206214131.GA1176@elte.hu> <1170798879.3455.58.camel@dwalker1> <20070206220855.GB5109@elte.hu> <1170801742.3455.87.camel@dwalker1> <20070206225650.GA14853@elte.hu> <1170803070.3455.93.camel@dwalker1> <20070206231421.GA18654@elte.hu> <1170804177.3455.109.camel@dwalker1> <20070206232828.GA21969@elte.hu> <1170804903.3455.121.camel@dwalker1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170804903.3455.121.camel@dwalker1>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -5.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-5.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> > | If we change the current "timer" entry to be listed as 
> > | "lapic-timer" and not "IO-APIC-edge" (or one of the other names) 
> > | and replace it with the count from LOC
> > 
> > this is a pretty clear sentence, i dont think i misunderstood 
> > anything about it. If i did, please point it out specifically.
> 
> Geez , man I've corrected this statement already .. [...]

i'm sorry, but where did you "correct this statement already"? You 
havent replied to your mail to correct it explicitly, and there's no 
later statement of yours that says anything near to "let me correct this 
via X" or "i was wrong here, i meant Y".

the only subsequent reference of yours seems to be:

| I'm not saying we should "fake" anything .. I'm saying list what's 
| really happening .. In a human readable way .

what you write here does not read as a 'correction', this disputes my 
characterisation, suggesting that your original point is still intact. 
How should i have known that you meant this to be a 'correction' of your 
original point, and that this (whatever it means precisely) replaces it?

if you concede a point or correct a statement then /please/ make it 
clear. There's nothing bad about being wrong or being stupid 
occasionally, it happens to all of us.

> Last and final correction. I'm saying drop the timer entry, which 
> means drop the call to request_irq() for irq0 . Add lines for 
> lapic-timer which take the place of LOC..

it's not a request_irq() but a setup_irq().

dropping the IRQ#0 line would be fatally wrong: /proc/interrupt lists 
all active interrupt lines. There can (and often is) a count in IRQ#0. 
Why should it be hidden?

furthermore, as i pointed it out earlier: what you suggest is bad for 
compatibility: removing/changing the non-count portions of the LOC or 
the IRQ#0 entry /will/ break scripts.

	Ingo

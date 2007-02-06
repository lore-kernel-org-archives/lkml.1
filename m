Return-Path: <linux-kernel-owner+w=401wt.eu-S933289AbXBFVlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933289AbXBFVlL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 16:41:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933252AbXBFVlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 16:41:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60073 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933289AbXBFVlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 16:41:10 -0500
Date: Tue, 6 Feb 2007 22:41:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-rc6-mm3
Message-ID: <20070206214131.GA1176@elte.hu>
References: <1170786992.3785.0.camel@chaos> <1170787543.9781.362.camel@imap.mvista.com> <1170788870.3785.9.camel@chaos> <1170791739.3455.3.camel@dwalker1> <1170793206.3785.16.camel@chaos> <1170794437.3455.20.camel@dwalker1> <20070206205231.GA25430@elte.hu> <1170795378.3455.31.camel@dwalker1> <20070206210959.GC25430@elte.hu> <1170796999.3455.43.camel@dwalker1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170796999.3455.43.camel@dwalker1>
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

> > we could make this clearer by renaming 'LOC' (which stands for 
> > 'LOCal timer interupts' and was added [and misnamed] by yours truly 
> > many moons ago) to 'apic-timer' and 'timer' to 'PIT-timer' but 
> > /that/ would be more of a userspace visible change than the change 
> > in the counter rates.
> 
> If we change the current "timer" entry to be listed as "lapic-timer" 
> and not "IO-APIC-edge" (or one of the other names) and replace it with 
> the count from LOC , [...]

doing that would not fake the old behavior (which is your suggestion), 
LOC is per CPU, while the PIT timer irq that was there is global.

But, as per the previous mails, the new behavior is just fine, because 
/proc/interrupts just reflects reality. And the way the kernel utilizes 
the hardware has just changed - for the better.

The same happens when say a network driver implements NAPI: the IRQ 
count goes way, way down. Or if a driver starts supporing MSI - the IRQ 
line even moves to another one. Do we try to fix those counts up to 
match the 'previous behavior'? Of course not. What you are suggesting 
makes no sense, is against current kernel practices - as we pointed it 
out to you 7 mails ago.

> [...] that would make sense cause that field already changes depending 
> if you have a io-apic or not ..

(that is something else: it's different because a different irq-chip is 
behind it.)

	Ingo

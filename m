Return-Path: <linux-kernel-owner+w=401wt.eu-S1030234AbXBFW4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030234AbXBFW4b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 17:56:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030238AbXBFW4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 17:56:31 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:32932 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030234AbXBFW43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 17:56:29 -0500
Date: Tue, 6 Feb 2007 23:56:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-rc6-mm3
Message-ID: <20070206225650.GA14853@elte.hu>
References: <1170793206.3785.16.camel@chaos> <1170794437.3455.20.camel@dwalker1> <20070206205231.GA25430@elte.hu> <1170795378.3455.31.camel@dwalker1> <20070206210959.GC25430@elte.hu> <1170796999.3455.43.camel@dwalker1> <20070206214131.GA1176@elte.hu> <1170798879.3455.58.camel@dwalker1> <20070206220855.GB5109@elte.hu> <1170801742.3455.87.camel@dwalker1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170801742.3455.87.camel@dwalker1>
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

> On Tue, 2007-02-06 at 23:08 +0100, Ingo Molnar wrote:
> 
> > sorry but that's precisely what your suggestion above results in:
> 
> I'm not trying to suggest we "fake" anything. Your just 
> misunderstanding me.. [...]

as i pointed it out in the previous mail, the problem is that what you 
suggested results in preisely that - a count in the wrong place:

> If we change the current "timer" entry to be listed as "lapic-timer" 
> and not "IO-APIC-edge" (or one of the other names) and replace it with 
> the count from LOC

changing the current 'timer' entry (which is line 2 of /proc/interrupts) 
to be 'listed as lapic-timer' and to 'replace it with the count from 
LOC' is faking a count in a line where nothing like that should be.

the kernel simply displays reality: IRQ#0 isnt increasing because it's 
not used, and LOC (local apic timers) is increasing.

	Ingo

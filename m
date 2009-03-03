Return-Path: <linux-kernel-owner+w=401wt.eu-S1755657AbZCCKtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657AbZCCKtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 05:49:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbZCCKtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 05:49:11 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56164 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711AbZCCKtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 05:49:10 -0500
Date: Tue, 3 Mar 2009 11:48:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, dmitry.torokhov@gmail.com, sameo@openedhand.com,
       tglx@linutronix.de
Subject: Re: lockdep and threaded IRQs (was: ...)
Message-ID: <20090303104836.GA11532@elte.hu>
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <200903021633.08736.david-b@pacbell.net> <20090303004427.GA8638@elte.hu> <200903021837.08635.david-b@pacbell.net> <1236072446.18955.44.camel@twins> <20090303094743.030b2507@lxorguk.ukuu.org.uk> <20090303100329.GA5050@elte.hu> <20090303103041.0ba4aebd@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090303103041.0ba4aebd@lxorguk.ukuu.org.uk>
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


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > _without_ IRQF_ENABLED: where an IRQ handler can take a long 
> > time to execute, the handler can be converted to a threaded 
> > IRQ handler - where it's fine to enable IRQs as there are no 
> > stack nesting issues.
> 
> Only if you can mask the interrupt on the APIC without losing 
> it or having the APIC throw a fit.

Hm, that reads like the boot IRQ erratas of certain chipsets - 
the APIC could throw a fit essentially locking up the system. 
FYI, we have fixes for that upstream already.

Do you have any description about that problem, which hardware 
it affects, whether it's manufactured today and any (ballpark 
figure) estimation about the Linux installed base on it? Can 
they live with the quirk flag?

> > So there's no real technical problem here.
> 
> In the long term no - but forcing people to make sudden 
> changes to critical I/O drivers isn't the right way to do it.

i think you severely over-estimate the importance and ratio of 
drivers that enable irqs within irq handlers. (Nor does anyone 
want to break them really - we want to have a sane default and 
we want to flag the broken cases as broken.)

The thing is, while you seem to spend precious resources on 
weird legacy cases, we have a _lot_ of everyday systems in 
bugzilla that do not boot or do not work for one reason or 
another. Most of that is not in the weird-hardware category at 
all.

You might also have noticed that over the past 2-3 years the 
term "hard lockup" in regression reports has gone down by about 
an order of magnitude - and much of that can be attributed to 
the lockdep coverage we have in place. So in terms of real 
everyday quality impact on Linux Peter is very, very, very 
efficient.

And frankly, while Peter's patch here needs modifications, as a 
maintainer i prefer Peter as a contributor so much not only 
because he is fantastically productive in terms of fixing 
locking crap all over the kernel, but also because he 
concentrates on the big picture and on the common case and on 
the net effect on Linux instead of just stubbornly concentrating 
on an extreme-0.01% of the hardware space.

So your attack on him is quite misguided and unfair:

>> [..] You can talk about forcing things all you like but 
>> "force" used that way generally means "new maintainer 
>> required" [...]

Btw., Peter submitted a genirq patch and FYI he does not 
maintain the genirq subsystem and never maintained it.

	Ingo

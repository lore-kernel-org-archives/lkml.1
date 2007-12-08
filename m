Return-Path: <linux-kernel-owner+w=401wt.eu-S1755276AbXLHPPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276AbXLHPPT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 10:15:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbXLHPPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 10:15:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41076 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278AbXLHPPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 10:15:03 -0500
Date: Sat, 8 Dec 2007 16:13:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mark Lord <lkml@rtr.ca>
Cc: Guillaume Chazarain <guichaz@yahoo.fr>, stefano.brivio@polimi.it,
       Nick Piggin <nickpiggin@yahoo.com.au>, Robert Love <rml@tech9.net>,
       linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Michael Buesch <mb@bu3sch.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] scheduler: fix x86 regression in native_sched_clock
Message-ID: <20071208151341.GA25413@elte.hu>
References: <20071207084559.GA11162@elte.hu> <200712072213.06530.nickpiggin@yahoo.com.au> <20071207122310.maqkoxlb4gsg4ggc@webmail.polimi.it> <20071207122516.GA25115@elte.hu> <20071207123509.GA28676@elte.hu> <20071207124034.GA30052@elte.hu> <20071207145418.GA22277@elte.hu> <20071207174649.39c9198d@inria.fr> <20071207175754.GB19173@elte.hu> <475AB2FD.30600@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475AB2FD.30600@rtr.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Mark Lord <lkml@rtr.ca> wrote:

> Ingo Molnar wrote:
>> ...
>> thanks. I do get the impression that most of this can/should wait until 
>> 2.6.25. The patches look quite dangerous.
> ..
>
> I confess to not really trying hard to understand everything in this 
> thread, but the implication seems to be that this bug might affect 
> udelay() and possibly jiffies ?

no, it cannot affect jiffies. (jiffies was a red herring all along)

udelay() cannot be affected either - sched_clock() has no effect on 
udelay(). _But_, when there are TSC problems then tsc based udelay() 
suffers too so the phenomenons may _seem_ related.

> If so, then fixing it has to be a *must* for 2.6.24, as otherwise 
> we'll get all sorts of one-in-while odd driver bugs.. like maybe these 
> two for starters:
>
> [Bug 9492] 2.6.24:  false double-clicks from USB mouse
> [Bug 9489] 20000+ wake-ups/second in 2.6.24

iirc these high rate wakeups happened on 2.6.22 too.

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S965687AbXCLL3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965687AbXCLL3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 07:29:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965537AbXCLL3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 07:29:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36303 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965687AbXCLL3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 07:29:06 -0400
Date: Mon, 12 Mar 2007 12:28:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Roland McGrath <roland@redhat.com>,
       akpm@linux-foundation.org, mm-commits@vger.kernel.org, npiggin@suse.de,
       drepper@redhat.com, oleg@tv-sign.ru, sebastien.dugue@bull.net,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] change futex_wait() to hrtimers
Message-ID: <20070312112824.GA16093@elte.hu>
References: <200703110814.l2B8EaI1007615@shell0.pdx.osdl.net> <20070312011259.3834A1801C4@magilla.sf.frob.com> <20070312091006.GF21024@elte.hu> <p73bqiyaehp.fsf@bingen.suse.de> <1173697220.13341.84.camel@localhost.localdomain> <20070312105826.GB11864@one.firstfloor.org> <20070312110417.GA12308@elte.hu> <20070312112045.GC11864@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070312112045.GC11864@one.firstfloor.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> > if HIGH_RES_TIMERS is disabled then that is what happens. But 
> > frankly,
> 
> disabled? I would expect it (= more wakeups) when hrtimers are 
> enabled.

i mean the groupping of timer expiries happens automatically when 
high-res is disabled. When high-res is asked for then, duh, it's enabled 
and you get precise timeouts ;-)

> > most futex waits are without timeouts - if an application cares 
> > about micro-effects like that then you are much better off not using 
> > a per-futex timeout anywa
> 
> That sounds like you're arguing for not using hrtimers here because 
> the applications shouldn't depend on precise timeouts here anyways?!?

I was talking about the "micro-effect" of grouping timer expiries.

> Anyways when you convert more kernel timeouts to hrtimers you should 
> probably add some kind of batching facility that can be globally 
> configured with a sysctl or similar. Then at least laptops (and 
> possibly servers) can opt for more power saving again. For the futexes 
> alone it probably won't matter too much agreed, but I see a trend to 
> more hr.

yeah, we had that in earlier versions, it's trivial - nobody used it. So 
i'll wait for the actual measurements and a patch (or i can do the patch 
too, if someone comes up with the measurements). I've added 
/proc/timer_stats and /proc/timer_info for exactly such reasons.

( note that we've added the facility for even more imprecise sleeps to 
  the timer_list APIs - but for hrtimers it's a lot less clear-cut case. )

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754301AbYJFGVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301AbYJFGVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 02:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752690AbYJFGVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 02:21:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35031 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577AbYJFGVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 02:21:36 -0400
Date: Mon, 6 Oct 2008 08:21:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Steven Noonan <steven@uplinklabs.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: drivers/pci/probe.c compile warnings on -tip
Message-ID: <20081006062106.GC14945@elte.hu>
References: <f488382f0810010102y551f4a3bs64524fa70ef04ca3@mail.gmail.com> <18659.21853.41967.715062@harpo.it.uu.se> <200810010851.15969.jbarnes@virtuousgeek.org> <f488382f0810042055o68778028t1bb0754126d6bb0@mail.gmail.com> <20081005101801.GI29909@elte.hu> <86802c440810051106l6d58076cnb4a29ddd282e4ac@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440810051106l6d58076cnb4a29ddd282e4ac@mail.gmail.com>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> On Sun, Oct 5, 2008 at 3:18 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Steven Noonan <steven@uplinklabs.net> wrote:
> >
> >> > AFAICT, these are fixed in Linus' tree, maybe the x86 tree needs an
> >> > update?
> >> >
> >>
> >> Hey Ingo, these warnings are still showing up on the latest -tip. Any
> >> idea why?
> >
> > yes, they got reintroduced via:
> >
> > | From ca81beb4a340ee690803fcb1498f863d0e68843f Mon Sep 17 00:00:00 2001
> > | From: Yinghai Lu <yhlu.kernel@gmail.com>
> > | Date: Thu, 4 Sep 2008 20:57:15 +0200
> > | Subject: [PATCH] pci: fix BAR print out
> >
> > which spread into a few topic branches:
> >
> > # irq/sparseirq: ca81beb: pci: fix BAR print out
> > # irq/sparseirq: f430d990: Merge branch 'linus' into irq/sparseirq
> > # timers/hpet-percpu: ca81beb: pci: fix BAR print out
> > # x86/uv: ca81beb: pci: fix BAR print out
> > # x86/uv: f430d990: Merge branch 'linus' into irq/sparseirq
> >
> > i suspect f430d990 is where the in-linus fix collided with the
> > in-irq/sparseirq fix. I'm inclined to revert it. Yinghai?
> >
> 
> please. it should be reverted from irq/sparseirq etc branch...because
> updated one is already in linus tree.

ok, reverted it in irq/sparseirq and propagated that to the 
sparseirq-derived topic trees as well.

	Ingo

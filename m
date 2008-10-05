Return-Path: <linux-kernel-owner+w=401wt.eu-S1755513AbYJEKSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbYJEKSb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 06:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbYJEKSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 06:18:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53262 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240AbYJEKSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 06:18:23 -0400
Date: Sun, 5 Oct 2008 12:18:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Noonan <steven@uplinklabs.net>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: drivers/pci/probe.c compile warnings on -tip
Message-ID: <20081005101801.GI29909@elte.hu>
References: <f488382f0810010102y551f4a3bs64524fa70ef04ca3@mail.gmail.com> <18659.21853.41967.715062@harpo.it.uu.se> <200810010851.15969.jbarnes@virtuousgeek.org> <f488382f0810042055o68778028t1bb0754126d6bb0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f488382f0810042055o68778028t1bb0754126d6bb0@mail.gmail.com>
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


* Steven Noonan <steven@uplinklabs.net> wrote:

> > AFAICT, these are fixed in Linus' tree, maybe the x86 tree needs an 
> > update?
> >
> 
> Hey Ingo, these warnings are still showing up on the latest -tip. Any 
> idea why?

yes, they got reintroduced via:

| From ca81beb4a340ee690803fcb1498f863d0e68843f Mon Sep 17 00:00:00 2001
| From: Yinghai Lu <yhlu.kernel@gmail.com>
| Date: Thu, 4 Sep 2008 20:57:15 +0200
| Subject: [PATCH] pci: fix BAR print out

which spread into a few topic branches:

# irq/sparseirq: ca81beb: pci: fix BAR print out
# irq/sparseirq: f430d990: Merge branch 'linus' into irq/sparseirq
# timers/hpet-percpu: ca81beb: pci: fix BAR print out
# x86/uv: ca81beb: pci: fix BAR print out
# x86/uv: f430d990: Merge branch 'linus' into irq/sparseirq

i suspect f430d990 is where the in-linus fix collided with the 
in-irq/sparseirq fix. I'm inclined to revert it. Yinghai?

	Ingo

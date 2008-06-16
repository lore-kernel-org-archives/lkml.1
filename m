Return-Path: <linux-kernel-owner+w=401wt.eu-S1760532AbYFPHKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760532AbYFPHKc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 03:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754301AbYFPHKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 03:10:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56492 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753697AbYFPHKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 03:10:23 -0400
Date: Mon, 16 Jun 2008 09:10:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] kmemcheck: divide and conquer
Message-ID: <20080616071000.GA9320@elte.hu>
References: <20080613140057.GA25833@damson.getinternet.no> <20080614063114.GA24188@elte.hu> <19f34abd0806140139i70a5056ehbd8a6f5df81549e4@mail.gmail.com> <20080614090023.GA13798@elte.hu> <19f34abd0806140217x1ea73a8k1cae18a12128a2b1@mail.gmail.com> <20080616051504.GA3492@elte.hu> <19f34abd0806152355h65876c54r1ae0aa156e839db2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0806152355h65876c54r1ae0aa156e839db2@mail.gmail.com>
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


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> For some reason, there is no <asm/irq_vectors.h> in my repository, so 
> I assume the change came from another branch. In fact, I should have 
> included <asm/hw_irq.h>, but that doesn't contain the right 
> definitions in the tip/auto-test branch.
> 
> Yep, seems to be
> 
> commit 9b7dc567d03d74a1fbae84e88949b6a60d922d82
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Fri May 2 20:10:09 2008 +0200
> 
>     x86: unify interrupt vector defines
> 
> I also can't seem to get the redefined warnings, so I assume that's
> also just an indirect conflict with other -tip changes.
> 
> Right now, I am reluctant to apply your fix because it means that 
> kmemcheck tree won't build as it is. In general, what's the way to 
> resolve these things? Do you have another branch, *-fixes, where these 
> fixlets can go until either of the conflicting changesets are merged 
> upstream? If so, it seems that that would be the right place for this 
> patch. Do you agree or do you have another solution? :-)

yes, i solved it the following "Git way": i did a --no-commit merge of 
the tip/x86/irq tree into the tip/kmemcheck2 branch and then 
"git-cherry-pick --no-commit"-ed the fix and thus made it a part of that 
merge commit. This way the build failure is never visible during 
bisection either.

tip/kmemcheck2 is a temporary topic tree: it contains the pull from your 
tree and i'm testing it at the moment. It will be renamed to 
tip/kmemcheck once it has passed testing.

btw., due to kmemcheck not being rebased anymore, this will work out 
just fine in the future: i can pull fixes from your tree into 
tip/kmemcheck and it will just all get sorted out by Git, despite the 
cross-merge to tip/x86/irq.

If you rebased kmemcheck i'd have to do rather difficult (and 
error-prone and harder to trust) manual merges every time you put a 
kmemcheck fix into your tree, and any breakages introduced by new 
kmemcheck fixes would not be easily bisectable either.

	Ingo

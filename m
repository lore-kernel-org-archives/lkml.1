Return-Path: <linux-kernel-owner+w=401wt.eu-S932212AbZHYWDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212AbZHYWDl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 18:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756048AbZHYWDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 18:03:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40468 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755614AbZHYWDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 18:03:40 -0400
Date: Wed, 26 Aug 2009 00:03:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Theodore Tso <tytso@mit.edu>, Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, dwalker@fifo99.com,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/core] timekeeping: Increase granularity of
	read_persistent_clock()
Message-ID: <20090825220303.GA31615@elte.hu>
References: <20090823084740.GA7651@elte.hu> <19090.1800.521794.839576@cargo.ozlabs.ibm.com> <20090824082318.GD2424@elte.hu> <19091.24374.210127.155521@drongo.ozlabs.ibm.com> <20090825082612.GA17692@elte.hu> <19091.46451.893720.573893@cargo.ozlabs.ibm.com> <20090825101742.GA26801@elte.hu> <19091.52205.222449.441072@cargo.ozlabs.ibm.com> <20090825135017.GA31340@elte.hu> <20090825213337.GX17684@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090825213337.GX17684@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Theodore Tso <tytso@mit.edu> wrote:

> On Tue, Aug 25, 2009 at 03:50:17PM +0200, Ingo Molnar wrote:
> > > [...]  It's like making changes inside #ifdef CONFIG_FOO but never 
> > > testing with CONFIG_FOO turned on.  You'd complain, and rightly, 
> > > if someone did that.
> > 
> > You again seem to ignore the very valid case i pointed out: if i 
> > change generic code (or an include, an inline function or a 
> > define) which somehow affects an architecture, by your logic i'd 
> > be compelled to test it on that architecture - because it 
> > affects it. That's not reasonable overhead.
> 
> Paul, Ingo, it seems like the two of you are talking past each 
> other. He's said he's OK with generic code which somehow affects 
> an architecture only being tested on one architecture, so what 
> you're proposing is a straw man.  What he has requested it would 
> be nice that each line of code be compile-tested on at least *one* 
> architecture. If it's generic code, then by definition when you 
> compile on x86, it's met the criterion he has proposed.
> 
> On the other hand, your claim that it would slow down development 
> too much is based on the assumption that if you make a change in 
> generic code that breaks architecture-specific code, it's good 
> manners to at least *attempt* to fix up the architecture-specific 
> code, as opposed to leaving it broken. [...]

That's (of course!) what happened here.

In fact, more than just an attempt happened, the thread started by 
_me_ finding this build breakage to begin with:

> > > FYI, -tip arch-testing found that this commit broke the PowerPC 
> > > build:
> > > 
> > > /home/mingo/tip/arch/powerpc/kernel/time.c: In function 'read_persistent_clock':
> > > /home/mingo/tip/arch/powerpc/kernel/time.c:788: error: 'return' with a value, in function returning void

and i applied the fix from Martin very quickly as well.

So i think this is much ado about nothing. Testing was done, the fix 
was applied immediately and no kitten was hurt in the process.

	Ingo

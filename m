Return-Path: <linux-kernel-owner+w=401wt.eu-S1754357AbZHYDzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357AbZHYDzx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 23:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754206AbZHYDzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 23:55:52 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:37159 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754201AbZHYDzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 23:55:52 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19091.24374.210127.155521@drongo.ozlabs.ibm.com>
Date: Tue, 25 Aug 2009 13:49:10 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, dwalker@fifo99.com,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/core] timekeeping: Increase granularity of
	read_persistent_clock()
In-Reply-To: <20090824082318.GD2424@elte.hu>
References: <20090814134811.013873340@de.ibm.com>
	<tip-d4f587c67fc39e0030ddd718675e252e208da4d7@git.kernel.org>
	<20090822103252.GA32369@elte.hu>
	<20090822171540.1220f50d@skybase>
	<20090822153346.GA3313@elte.hu>
	<19088.47213.327897.703458@cargo.ozlabs.ibm.com>
	<20090823084740.GA7651@elte.hu>
	<19090.1800.521794.839576@cargo.ozlabs.ibm.com>
	<20090824082318.GD2424@elte.hu>
X-Mailer: VM 8.0.12 under 22.3.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> * Paul Mackerras <paulus@samba.org> wrote:

> > In a stable, non-rebasing branch, sure.  But putting untested 
> > patches into such a branch would be a bit silly, so I assumed you 
> > hadn't done that. :)
> 
> You have not answered my primary question though AFAICS. There's 
> _more_ build breakages in Linus's tree (in a volume-scaled form), so 
> why dont you request rebases there?

Well, I don't see a lot of build breakages in Linus' tree, in fact.

What goes into Linus' tree is supposed to have been tested by
subsystem maintainers first, and if there is stuff that goes across
several architectures, it should have been posted to linux-arch
first.  In other words, with Linus' tree the focus is on filtering out
at least the more obvious problems before they get into Linus' tree.
Sometimes that doesn't work, and then we yell at the person
responsible for a bit and then move on.

On the other hand, subsystem and architecture maintainers (such as
yourself) should be doing a reasonable amount of testing before
committing patches to any non-rebasing branch.  Some maintainers use
quilt for this, others use testing branches that explicitly get
reconstructed frequently and are not for others to build on.

> If you requested them you'd have a snowball's chance in hell, Linus 
> has never rebased the upstream tree, ever. Once pushed out for 
> others to pull it's cast into stone. Yes, sometimes the build 
> breaks, especially on rarely used architectures. We fix them.

Yet I see you pulling patches out of tip quite frequently.  When I
update my local copy of your tip/perfcounters branches, maybe one time
in three I see a forced update of at least one of those branches.

You don't seem to have separate testing and non-rebasing branches.
Instead you seem to treat the more recent commits as testing and the
older ones as non-rebasing.  I would suggest that that way of
operating isn't as clear and predictable for your downstream users as
it would be if you used separate branches.

> The more frequently an architecture is tested, the more it is used 
> in practice, the more a driver and an architecture matters the 
> shorter the bisection breakage window becomes. The upstream kernel 
> is a self-tuning process of quality, even without rebases and 
> backmerges.
> 
> (DaveM does something quite similar to Linus too AFAICS, he too 
> never rebases the networking tree.)

I don't follow the networking tree, but I do know that DaveM doesn't
publish commits until a reasonable period of time has passed since
committed them and he has done some basic testing of them.

Your way seems to be to push commits into tip very quickly and publish
them, and then do testing, then revert recent commits if they cause
problems.

> I'm thinking about starting to do the same for all -tip trees too: i 
> do reasonable testing before pushing it out, on the most common 
> architecture and driver selection, and once pushed out it's cast 
> into stone Git-wise.

I think that's an excellent idea.  If you want to let people help you
with the testing you could also publish the commits you're testing on
a testing branch.  I would also advise a minimum latency for patches
to move from testing to the cast-in-stone branch of (say) one day
unless there is a very good reason for pushing them out more quickly.
If you have separate branches then it's clear to downstream users that
they should base their work on your cast-in-stone branch not your
testing branch.

I assume your "reasonable testing" includes building at least one
powerpc config, since you found the breakage on powerpc yourself.

> I actually start regretting that i do rebases too frequently - some 
> people (not you really, but you gave me the perfect example to reply 
> to) want more and seem to think they are _entitled_ to rebases and 
> are entitled to backmerges. The thing is, rebases are not free. They 
> are risky and error-prone, and they destroy Git history.

To be honest, I didn't think I was asking for a rebase of something
which was already cast in stone, since I didn't think you would have
cast a commit in stone before doing a build test on powerpc.

Paul.

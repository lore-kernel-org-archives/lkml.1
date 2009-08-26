Return-Path: <linux-kernel-owner+w=401wt.eu-S1756572AbZHZAYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572AbZHZAYq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 20:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753820AbZHZAYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 20:24:45 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:35243 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbZHZAYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 20:24:44 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19092.32844.283719.302357@cargo.ozlabs.ibm.com>
Date: Wed, 26 Aug 2009 10:22:36 +1000
From: Paul Mackerras <paulus@samba.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Ingo Molnar <mingo@elte.hu>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       dwalker@fifo99.com, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, johnstul@us.ibm.com, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/core] timekeeping: Increase granularity of
	read_persistent_clock()
In-Reply-To: <20090825213337.GX17684@mit.edu>
References: <19088.47213.327897.703458@cargo.ozlabs.ibm.com>
	<20090823084740.GA7651@elte.hu>
	<19090.1800.521794.839576@cargo.ozlabs.ibm.com>
	<20090824082318.GD2424@elte.hu>
	<19091.24374.210127.155521@drongo.ozlabs.ibm.com>
	<20090825082612.GA17692@elte.hu>
	<19091.46451.893720.573893@cargo.ozlabs.ibm.com>
	<20090825101742.GA26801@elte.hu>
	<19091.52205.222449.441072@cargo.ozlabs.ibm.com>
	<20090825135017.GA31340@elte.hu>
	<20090825213337.GX17684@mit.edu>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso writes:

> Paul, Ingo, it seems like the two of you are talking past each other.
> He's said he's OK with generic code which somehow affects an
> architecture only being tested on one architecture, so what you're
> proposing is a straw man.  What he has requested it would be nice that
> each line of code be compile-tested on at least *one* architecture.
> If it's generic code, then by definition when you compile on x86, it's
> met the criterion he has proposed.
> 
> On the other hand, your claim that it would slow down development too
> much is based on the assumption that if you make a change in generic
> code that breaks architecture-specific code, it's good manners to at
> least *attempt* to fix up the architecture-specific code, as opposed
> to leaving it broken.  So you could meet Paul's request of "not
> committing code that hasn't been compile-tested" by simply leaving
> that particular architecture broken when you change generic code.
> 
> Personally, I think that would be worse, since that exchanges the risk
> that a generic change might break the PowerPC architecture, with the
> *certainty* that the PowerPC architecture would be broken by said
> change.  :-)  So it may very well be that you are doing the right
> thing.

Upon reflection, I think that a large part of the problem in this
particular instance is that while an attempt was made to fix up the
powerpc architecture code, it was never cc'd to any powerpc developer
or mailing list, and as far as I can tell it wasn't sent to linux-arch
either.

> I will note, by the way, that in the file system space, where we have
> almost 70 filesystems, I doubt very much that every single generic
> change in the core VM or FS code that might have a potential to affect
> every single filesystem gets compile-tested using allyesconfig.  Maybe

I think Stephen Rothwell does an x86 allyesconfig build of the
linux-next tree every day, so if the generic changes are in linux-next
they will in fact get tested against every filesystem.

> In the case of architecture code where compile-testing on every single
> architecture would require keeping very large number of
> cross-compilers, and a non-trivial amount of time, it's much less
> reasonable.  Doing a full test on all architectures before pushing to
> Linus (as opposed to publication in a -tip git branch) may be the best
> that can be expected.

Well, it used to be that if you had a patch that affected several
architectures, you'd post it to Andrew Morton and linux-arch, and
collect acks from as many architecture maintainers as you could in a
reasonable time.  And if you could cross-compile your patch yourself,
that was a good thing to do as well.

Ingo seems to be bypassing that step in order to speed up development
on x86.  Now, I can imagine a value system where that is a logical
thing to do, but it is not my value system. :)  I think this is why
several architecture maintainers have got unhappy with Ingo recently.

Paul.

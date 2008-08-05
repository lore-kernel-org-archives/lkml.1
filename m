Return-Path: <linux-kernel-owner+w=401wt.eu-S1763694AbYHEArk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763694AbYHEArk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 20:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763350AbYHEAr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 20:47:26 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:53505
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029AbYHEArZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 20:47:25 -0400
Date: Tue, 5 Aug 2008 02:47:19 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Dave Jones <davej@redhat.com>,
       Roland Dreier <rdreier@cisco.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, jeremy@goop.org, hugh@veritas.com,
       mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workaround minor lockdep bug triggered by
	mm_take_all_locks
Message-ID: <20080805004719.GH12464@duo.random>
References: <20080804175730.GL11476@duo.random> <1217875739.3589.56.camel@twins> <20080804201514.GB12464@duo.random> <1217882242.3589.90.camel@twins> <20080804210954.GC12464@duo.random> <84144f020808041414x2c1c8b82n5939b82e9a2ca99d@mail.gmail.com> <20080804213018.GD12464@duo.random> <20080804144228.5f0c29c3@infradead.org> <20080804223011.GG12464@duo.random> <20080804163816.75fa63ba@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080804163816.75fa63ba@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2008 at 04:38:16PM -0700, Arjan van de Ven wrote:
> interesting; lockdep has been working for the last.. 2 1/2 years at
> least, and I don't remember seeing bugreports against it from you that
> would describe it as totally non-functional.

I reported it to Peter. If you see David's email, I guess it can be
implied that I wasn't the only one aware that prove-locking made
certain systems non functional, I thought it was widespread knowledge
maybe not.

It's amazing that things seem to have improved on that side, it surely
gives me more confidence in prove-locking!

> Oh well.. seems you're rather preoccupied about it; that's ok, you're
> entitled to your opinion even if I don't agree with it ;-)

So let me understand better: your opinion is that all of lockdep is
useful, not just the AB BA detection?

By reading the source again after 11 months to me it still looks
check_deadlock() only has knowledge of the current context. It loops
over the task struct checking all the locks of the current task!
Combine the great feature that check_deadlock provides, with crashing
at boot, and I hope that better explains my feeling about
lockdep-prove-locking.

This check_deadlock() thing is the real core of my dislike of
prove-locking! The check_noncircular part I totally agree it's useful
now that I see it works differently than check_deadlock (when I read
it last time I thought it worked the same as check_deadlock).

check_noncircular being useful doesn't automatically make
check_deadlock useful.

And incidentally it's exactly this check_deadlock part that is
trapping on my code and that is now requiring silly changes to the
common code (the ones I did) or to make the common code even more
complex (what Peter is planning I guess).

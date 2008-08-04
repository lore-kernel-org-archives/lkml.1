Return-Path: <linux-kernel-owner+w=401wt.eu-S1759509AbYHDWd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759509AbYHDWd2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 18:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756487AbYHDWaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 18:30:19 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:41721
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbYHDWaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 18:30:17 -0400
Date: Tue, 5 Aug 2008 00:30:11 +0200
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
Message-ID: <20080804223011.GG12464@duo.random>
References: <20080804172728.GJ11476@duo.random> <20080804174659.GK11476@duo.random> <20080804175730.GL11476@duo.random> <1217875739.3589.56.camel@twins> <20080804201514.GB12464@duo.random> <1217882242.3589.90.camel@twins> <20080804210954.GC12464@duo.random> <84144f020808041414x2c1c8b82n5939b82e9a2ca99d@mail.gmail.com> <20080804213018.GD12464@duo.random> <20080804144228.5f0c29c3@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080804144228.5f0c29c3@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2008 at 02:42:28PM -0700, Arjan van de Ven wrote:
> yes lockdep will only complain WHEN you take them in the wrong order
> 
> But you claimed you would for sure be in a deadlock at that point which
> is generally not correct.

I already said I didn't know about that despite having spent a fair
amount of time trying to understand why lockdep crashes systems at
boot about an year ago. I admit I didn't understand much about it and
reducing its computation time didn't look feasible, perhaps my fault,
and I'm glad if Peter found a way to make it boot after 1 year.

> this comment totally puzzles me... rather than calling you naive...
> where was this said or even implied????

It was just a logical conclusion of the statement that lockdep will
warn of the following classes of locking bugs: "lock inversion
scenarios"... There's no warning anywhere that it might not find them
at all. Or point me to where it is warned you still have to read the
code and verify it yourself, or you still risk to AB BA in
production. If it was warned I wouldn't have mentioned it, people seem
to talk like if lockdep is a checker doing static analyses of all
paths when it can't.

Partly of what I said before is true, even if I didn't understand the
actual details of the AB BA memory it has by reading the code: the BA
may happen only when system is OOM etc... so even lockdep memory may
never find it. So my warning that code might AB BA deadlock even if
lockdep doesn't warn sounds fair enough and without it I'm still
afraid it can lead to developers think everything is ok with regard to
AB BA. In any case (even if everyone already understand lockdep better
than I did before this discussion), even if I'm wrong a sign of
warning that lockdep isn't enough, can't hurt.

Return-Path: <linux-kernel-owner+w=401wt.eu-S932840AbXD2IPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932840AbXD2IPU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 04:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932929AbXD2IPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 04:15:20 -0400
Received: from 1wt.eu ([62.212.114.60]:2390 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932840AbXD2IPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 04:15:09 -0400
Date: Sun, 29 Apr 2007 10:13:17 +0200
From: Willy Tarreau <w@1wt.eu>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Ingo Molnar <mingo@elte.hu>, Kasper Sandberg <lkml@metanurb.dk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v6
Message-ID: <20070429081317.GG23638@1wt.eu>
References: <200704261041.04838.gene.heskett@gmail.com> <1177618164.14496.5.camel@localhost> <20070427115344.GA30706@elte.hu> <20070427115526.GA7699@elte.hu> <1177774551.21279.8.camel@localhost> <1177809512.9756.10.camel@localhost> <20070429053022.GB23638@1wt.eu> <20070429065900.GB32281@elte.hu> <20070429071627.GC23638@1wt.eu> <20070429075436.GZ31925@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070429075436.GZ31925@holomorphy.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2007 at 12:54:36AM -0700, William Lee Irwin III wrote:
> On Sun, Apr 29, 2007 at 09:16:27AM +0200, Willy Tarreau wrote:
> > In fact, what I'd like to see in 2.6.22 is something better for everybody
> > and with *no* regression, even if it's not perfect. I had the feeling
> > that SD matched that goal right now, except for Mike who has not tested
> > recent versions. Don't get me wrong, I still think that CFS is a more
> > interesting long-term target. But it may require more time to satisfy
> > everyone. At least with one of them in 2.6.22, we won't waste time
> > comparing to current mainline.
> 
> I think it'd be a good idea to merge scheduler classes before changing
> over the policy so future changes to policy have smaller code impact.
> Basically, get scheduler classes going with the mainline scheduler.
> 
> There are other pieces that can be merged earlier, too, for instance,
> the correction to the comment in init/main.c. Directed yields can
> probably also go in as nops or -ENOSYS returns if not fully implemented,
> though I suspect there shouldn't be much in the way of implementing them.
> p->array vs. p->on_rq can be merged early too.

I agree that merging some framework is a good way to proceed.

> Common code for rbtree-based priority queues can be factored out of
> cfq, cfs, and hrtimers.

In my experience, rbtrees are painfully slow. Yesterday, I spent the
day replacing them in haproxy with other trees I developped a few
years ago, which look like radix trees. They are about 2-3 times as
fast to insert 64-bit data, and you walk through them in O(1). I have
many changes to apply to them before they could be used in kernel, but
at least I think we already have code available for other types of trees.

> There are extensive /proc/ reporting changes, large chunks of which
> could go in before the policy as well.
> 
> I'm camping in this weekend, so I'll see what I can eke out.

good luck !

Willy


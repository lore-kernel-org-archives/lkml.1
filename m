Return-Path: <linux-kernel-owner+w=401wt.eu-S1756364AbXD2LRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364AbXD2LRA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 07:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756363AbXD2LRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 07:17:00 -0400
Received: from 1wt.eu ([62.212.114.60]:2405 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755143AbXD2LQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 07:16:57 -0400
Date: Sun, 29 Apr 2007 13:11:59 +0200
From: Willy Tarreau <w@1wt.eu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, Kasper Sandberg <lkml@metanurb.dk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>, caglar@pardus.org.tr,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v6
Message-ID: <20070429111159.GH23638@1wt.eu>
References: <200704261041.04838.gene.heskett@gmail.com> <1177618164.14496.5.camel@localhost> <20070427115344.GA30706@elte.hu> <20070427115526.GA7699@elte.hu> <1177774551.21279.8.camel@localhost> <1177809512.9756.10.camel@localhost> <20070429053022.GB23638@1wt.eu> <20070429065900.GB32281@elte.hu> <20070429071627.GC23638@1wt.eu> <1177842654.5791.85.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177842654.5791.85.camel@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2007 at 12:30:54PM +0200, Thomas Gleixner wrote:
> Willy,
> 
> On Sun, 2007-04-29 at 09:16 +0200, Willy Tarreau wrote:
> > In fact, what I'd like to see in 2.6.22 is something better for everybody
> > and with *no* regression, even if it's not perfect. I had the feeling
> > that SD matched that goal right now, except for Mike who has not tested
> > recent versions. Don't get me wrong, I still think that CFS is a more
> > interesting long-term target. But it may require more time to satisfy
> > everyone. At least with one of them in 2.6.22, we won't waste time
> > comparing to current mainline.
> 
> Oh no, we really do _NOT_ want to throw SD or anything else at mainline
> in a hurry just for not wasting time on comparing to the current
> scheduler.

It is not about doing it in a hurry. I see SD as a small yet efficient
update to current scheduler. It's not perfect, probably not much extensible
but the risks of breaking anything are small given the fact that it does
not change much of the code or behaviour.

IMHO, it is something which can provide users with a useful update while
leaving us with some more time to carefully implement the features of CFS
one at a time, and if it requires 5 versions, it's not a problem.

> I agree that CFS is the more interesting target and I prefer to push the
> more interesting one even if it takes a release cycle longer. The main
> reason for me is the design of CFS. Even if it is not really modular
> right now, it is not rocket science to make it fully modular.
> 
> Looking at the areas where people work on, e.g. containers, resource
> management, cpu isolation, fully tickless systems ...., we really need
> to go into that direction, when we want to avoid permanent tinkering in
> the core scheduler code for the next five years.
> 
> As a sidenote: I really wonder if anybody noticed yet, that the whole
> CFS / SD comparison is so ridiculous, that it is not even funny anymore.

Contrarily to most people, I don't see them as competitors. I see SD as
a first step with a low risk of regression, and CFS as an ultimate
solution relying on a more solid framework.

> CFS modifies the scheduler and nothing else, SD fiddles all over the
> kernel in interesting ways. 

Hmmm I guess you confused both of them this time. CFS touches many places,
which is why I think the testing coverage is still very low. SD can be
tested faster. My real concern is : are there still people observing
regressions with it ? If yes, they should be fixed before even being
merged. If no, why not merge it as a fix for the many known corner cases
of current scheduler ? After all, it's already in -mm.

Willy


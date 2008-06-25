Return-Path: <linux-kernel-owner+w=401wt.eu-S1758253AbYFYQry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758253AbYFYQry (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 12:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbYFYQrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 12:47:46 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:1286 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbYFYQrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 12:47:46 -0400
Subject: Re: [PATCH 6/6] futex: fix miss ordered wakeups
From: Daniel Walker <dwalker@mvista.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1214410654.24356.22.camel@lappy.programming.kicks-ass.net>
References: <20080624232018.817822790@mvista.com>
	 <20080624232020.505470899@mvista.com>  <1214371767.16881.5.camel@twins>
	 <1214404611.21035.20.camel@localhost.localdomain>
	 <1214406451.24356.13.camel@lappy.programming.kicks-ass.net>
	 <1214407507.21035.32.camel@localhost.localdomain>
	 <1214410654.24356.22.camel@lappy.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Date: Wed, 25 Jun 2008 09:47:43 -0700
Message-Id: <1214412463.21035.57.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-06-25 at 18:17 +0200, Peter Zijlstra wrote:

> You're not the maintainer, and you fail to respect their opinion - so
> what makes you think your patches are going anywhere but /dev/null?

It may not be going anyplace. I'm not submitting it to anyone but LKML,
at this point anyway.

> Also, the main point was about mixing user and kernel space state, you
> still do so by including the futex waiter in the same union. That's a
> fundamental fugly - no matter if you can make it work.

I don't think it's ugly at all, but I'm open to suggestion for alternate
methods of implementing it .. I don't need to unify the blocked_on
structures, but it does allow for some nice things like reducing the
size of the task struct, and potentially later doing PI across different
API's.

> > > > in fact the problem is
> > > > whether or not the changes are needed (not weather their broken).. I
> > > > gave justification in the last thread, and I'm not sure why it's unclear
> > > > to you..
> > > 
> > > You failed to convince, also justification goes in the changelog, not in
> > > random lkml threads.
> > 
> > It boils down to POSIX compliance which was discussed in the last
> > thread. POSIX requires the waiters to be sorts for 5-10 different API's
> > which ultimately use the futex (most of which aren't at all related to
> > PI).
> 
> I'm unconvinced, my reading of the spec doesn't say that at all. It says
> its up to how things get scheduled.

Any way you read it there is an ordering that isn't random or FIFO or
un-ordered, which is what we end up with now depending on the order the
syscalls are used.

We already go to the trouble of sorting the waiters, which I think
speaks for itself .. 

> Also, you have failed to say what real world use cases care about this
> behaviour. This was asked multiple times - you never answered any of
> those queries.﻿

At this point it all seems academic .. We all know how the code works
now, and the issue I'm addressing .. There's no crash associated with
this ..

I don't have access to code where this causes a devastating problem, all
I have is people asking me about the lack of determinism in this
interface.

Daniel


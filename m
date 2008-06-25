Return-Path: <linux-kernel-owner+w=401wt.eu-S1758708AbYFYQRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758708AbYFYQRy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 12:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbYFYQRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 12:17:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46001 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbYFYQRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 12:17:46 -0400
Subject: Re: [PATCH 6/6] futex: fix miss ordered wakeups
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1214407507.21035.32.camel@localhost.localdomain>
References: <20080624232018.817822790@mvista.com>
	 <20080624232020.505470899@mvista.com>  <1214371767.16881.5.camel@twins>
	 <1214404611.21035.20.camel@localhost.localdomain>
	 <1214406451.24356.13.camel@lappy.programming.kicks-ass.net>
	 <1214407507.21035.32.camel@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Date: Wed, 25 Jun 2008 18:17:33 +0200
Message-Id: <1214410654.24356.22.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-25 at 08:25 -0700, Daniel Walker wrote:
> On Wed, 2008-06-25 at 17:07 +0200, Peter Zijlstra wrote:
> > On Wed, 2008-06-25 at 07:36 -0700, Daniel Walker wrote:
> > > On Wed, 2008-06-25 at 07:29 +0200, Peter Zijlstra wrote:
> > > 
> > > > Daniel, I'm not sure what to think,.. you were told how broken this
> > > > approach was, you were told to give proper justification for this
> > > > change. You did neither and just reposted the same old broken shite
> > > > again.
> > > 
> > > Broken approach ? Never heard that before, 
> > 
> > I suggest you re-read some of Thomas' emails from last time...
> > 
> >   http://lkml.org/lkml/2008/6/12/275
> 
> Most of what he's saying there is that it breaks real time, and I
> provided a real time fix in this set of patches. I don't have a problem
> with the state mixing, since 99.9% of the time we're dealing operations
> that don't interact (and it's perfectly ok when they do interact).

You're not the maintainer, and you fail to respect their opinion - so
what makes you think your patches are going anywhere but /dev/null?

Also, the main point was about mixing user and kernel space state, you
still do so by including the futex waiter in the same union. That's a
fundamental fugly - no matter if you can make it work.

> > > in fact the problem is
> > > whether or not the changes are needed (not weather their broken).. I
> > > gave justification in the last thread, and I'm not sure why it's unclear
> > > to you..
> > 
> > You failed to convince, also justification goes in the changelog, not in
> > random lkml threads.
> 
> It boils down to POSIX compliance which was discussed in the last
> thread. POSIX requires the waiters to be sorts for 5-10 different API's
> which ultimately use the futex (most of which aren't at all related to
> PI).

I'm unconvinced, my reading of the spec doesn't say that at all. It says
its up to how things get scheduled.

Also, you have failed to say what real world use cases care about this
behaviour. This was asked multiple times - you never answered any of
those queries.﻿

> And yes I can add it to the headers, before it goes up stream.

Don't bother, at this rate that will be never.


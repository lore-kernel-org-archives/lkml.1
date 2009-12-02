Return-Path: <linux-kernel-owner+w=401wt.eu-S1755017AbZLBAq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017AbZLBAq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 19:46:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755005AbZLBAqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 19:46:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755003AbZLBAqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 19:46:54 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/utrace
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com
Subject: Re: [RFC,PATCH 0/14] utrace/ptrace
In-Reply-To: Oleg Nesterov's message of  Thursday, 26 November 2009 15:27:45 +0100 <20091126142745.GA4382@redhat.com>
References: <20091124200127.GA5751@redhat.com>
	<20091125214818.GA4916@infradead.org>
	<20091126091052.GF1389@elte.hu>
	<20091126104722.GA8316@infradead.org>
	<20091126142745.GA4382@redhat.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20091202004643.C9B26258B@magilla.sf.frob.com>
Date: Tue,  1 Dec 2009 16:46:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note to all: I'm on the road this week (having had a holiday last week)
and will be somewhat slow in replying on these threads, but I will be
sure to get to them all.

> Yes, nobody likes 2 implementations. I guess Roland and me hate
> CONFIG_UTRACE much more than anybody else.

:-) We both hate maintaining the old ptrace implementation, that is true!
The other thing we hate is having our work delayed arbitrarily again and
again to wait for the arch maintainers of arch's we don't use ourselves.

Oleg and I have been trying to follow the advice we get on how to get this
work merged in.  When multiple gate-keepers give conflicting advice, we
really don't know what to do next.  Our interest is in whatever path
smooths the merging of our work.  We'd greatly prefer to spend our time
hacking on our new code to make it better or different in cool and useful
ways than to spend more time guessing what order of patches and rejuggling
of the work will fit the changing whims of the next round of review.

We don't want to rush anyone, like uninterested arch maintainers.  We don't
want to break anyone who doesn't care about our work (we do test for ptrace
regressions but of course new code will always have new bugs so some
instances of instability in the transition to a new ptrace implementation
have to be expected no matter how hard we try).  We just don't want to keep
working out of tree.

The advantage of making the new code optional is, obviously, that you can
turn it off.  That is, lagging arch's won't be broken, just unable to turn
it on.  And, anyone who doesn't want to try anything new yet can just turn
it off and not be exposed to new code.

The advantage of making the new code nonoptional is, obviously, that you
can't turn it off.  The old implementation will be gone and we won't have
to maintain it any more (outside some -stable streams for a while).  The
kernel source will be cleaner with no optional old cruft code duplicating
functionality.  All ptrace users will be testing the new code, and so we'll
find its bugs and gain confidence that it works solidly.

Like I've said, we want to do whatever the people want.  My concern about
what Christoph has suggested is that it really seems like an open-ended
delay depending on some arch people who are not even in the conversation.
For anyone either who likes utrace or who is concerned about its details,
the sooner we are working in-tree the sooner we can really hash it out
thoroughly and get to having merged code that works well.  As long as there
is anything unfinished like arch work that we've decided is a gating event,
then the review and hashing out of the new code itself does not seem to get
very serious.  (To wit, this thread is still talking about merge order and
such, another long thread was about incidental trivia, and we've only just
started to see a tiny bit of actual code review today.)


Thanks,
Roland

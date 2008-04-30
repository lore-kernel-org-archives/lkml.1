Return-Path: <linux-kernel-owner+w=401wt.eu-S1765774AbYD3XNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765774AbYD3XNT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 19:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758904AbYD3XNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 19:13:10 -0400
Received: from 1wt.eu ([62.212.114.60]:3644 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758963AbYD3XNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 19:13:09 -0400
Date: Thu, 1 May 2008 01:12:21 +0200
From: Willy Tarreau <w@1wt.eu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: David Miller <davem@davemloft.net>, mingo@elte.hu,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: Slow DOWN, please!!!
Message-ID: <20080430231221.GP8474@1wt.eu>
References: <20080430135405.ddc42075.akpm@linux-foundation.org> <20080430221936.GA27292@elte.hu> <20080430.152227.23100100.davem@davemloft.net> <200805010039.02451.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805010039.02451.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 12:39:01AM +0200, Rafael J. Wysocki wrote:
> On Thursday, 1 of May 2008, David Miller wrote:
> > From: Ingo Molnar <mingo@elte.hu>
> > Date: Thu, 1 May 2008 00:19:36 +0200
> > 
> > > The same goes in the other direction as well - you were just hit by 
> > > scheduler tree related regressions that were only triggered on your 
> > > 128-way sparc64, but not on our 64way x86 and smaller boxes.
> > 
> > You keep saying this over and over again, but the powerpc folks hit
> > this stuff too.
> 
> Well, I think that some changes need some wider testing anyway.
> 
> They may be correct from the author's point of view and even from the knowledge
> and point of view of the maintainer who takes them into his tree.  That's
> because no one knows everything and it'll always be like this.
> 
> Still, with the current process such "suspicious" changes go in as parts of
> large series of commits and need to be "rediscovered" by the affected testers
> with the help of bisection.  Moreover, many changes of this kind may go in from
> many different sources at the same time and that's really problematic.

That's very true IMHO and is the thing which has been progressively
appearing since we merge large amounts of code at once. In the "good
old days", something did not work, the first one to discover it could
quickly report it on LKML : "hey, my 128-way sparc64 does not boot
anymore, anybody has any clue", and another one immediately found
this mail (better signal/noise ratio on LKML at this time) and say
"oops, I suspect that change, try to revert it".

Now, it's close to impossible. Maintainers frequently ask for bisection,
in part because nobody knows what code is merged, and they have to pull
Linus' tree to know when their changes have been pulled. That may be
part of the "fun" aspect that Davem is seeing going away in exchange
for more administrative relations. But if we agree that nobody knows
all the changes, we must agree that we need tools to track them, and
tools are fundamentally incompatible with smart human relations.

> In fact, so many changes go in at a time during a merge window, that we often
> can't really say which of them causes the breakage observed by testers and
> bisection, that IMO should really be a last-resort tool, is used on the main
> debugging techinque.

Maybe we could slightly improve the process by releasing more often, but
based on topics. Small sets of minimally-overlapping topics would get
merged in each release, and other topics would only be allowed to pull
fixes. That way everybody still gets some work merged, everybody tests
and problems are more easily spotted.

I know this is in part what Andrew tries to do when proposing to
integrate trees, but maybe some approximate rules should be proposed
in order for developers to organize their works. This would begin
with announcing topics to be considered for next branch very early.
This would also make it more natural for developers to have creation
and bug-tracking phases.

Willy


Return-Path: <linux-kernel-owner+w=401wt.eu-S933147AbYD3Wv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933147AbYD3Wv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757279AbYD3Wvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:51:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33926
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757101AbYD3Wvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:51:50 -0400
Date: Wed, 30 Apr 2008 15:51:49 -0700 (PDT)
Message-Id: <20080430.155149.210532797.davem@davemloft.net>
To: mingo@elte.hu
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com, tglx@linutronix.de
Subject: Re: Slow DOWN, please!!!
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080430223509.GA31547@elte.hu>
References: <20080430.142137.236846072.davem@davemloft.net>
	<20080430221936.GA27292@elte.hu>
	<20080430223509.GA31547@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 1 May 2008 00:35:09 +0200

> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > What we need is not 'negative reinforcement'. That is just nasty, open 
> > warfare between isolated parties, expressed in a politically correct 
> > way.
> 
> in more detail: any "negative reinforcement" should be on the 
> _technical_ level, i.e. when changes are handled - not at the broad tree 
> level.

Sure, and I'll provide some right here.

Ingo, let me know what I need to do to change your behavior in
situations like the one I'm about to describe, ok?

Today, you merged in this bogus "regression fix".

commit ae3a0064e6d69068b1c9fd075095da062430bda9
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed Apr 30 00:15:31 2008 +0200

    inlining: do not allow gcc below version 4 to optimize inlining
    
    fix the condition to match intention: always use the old inlining
    behavior on all gcc versions below 4.
    
    this should solve the UML build problem.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Did you actually read the UML build failure report?

Adrian Bunk specifically stated that the UML build failure regression
occurs with GCC version 4.3

Next, did you test this regression fix?

Next, if you could not test this regression fix, did you wait
patiently for the bug reporter to validate your fix?  Adrian
responded that it didn't fix the problem, but that was after
you queued this up to Linus already.

This proves my main beef with you Ingo.  You're way too trigger happy,
you merge things in too quickly, without checks and without
verifications.

To an arbitrary person reading the commit logs, the above
looks like you fixed something, when you actually didn't fix
anything.

And let's address this specific inlining optimization and all the
fallout it's generating.  You said you merged this thing in because
you didn't want to "wait a year for such a useful feature."  In
hindsight, that's exactly what we should have done, waited until we
could sort out all of these issues.  Yes, even if it would take a
year.

Now we're forced to sort it out somehow, unless you can get beyond
your pride and revert the original change.

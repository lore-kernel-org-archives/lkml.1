Return-Path: <linux-kernel-owner+w=401wt.eu-S1752534AbXLHUIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534AbXLHUIp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 15:08:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbXLHUIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 15:08:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57899 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010AbXLHUIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 15:08:36 -0500
Date: Sat, 8 Dec 2007 21:08:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Remy Bohmer <linux@bohmer.net>
Cc: Peter Zijlstra <peterz@infradead.org>, Daniel Walker <dwalker@mvista.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, Dave Chinner <dgc@sgi.com>
Subject: Re: lockdep problem conversion semaphore->mutex (dev->sem)
Message-ID: <20071208200801.GC579@elte.hu>
References: <3efb10970712071502p4db9c58ck623c377172ead4b2@mail.gmail.com> <1197116185.31440.1.camel@twins> <1197132792.1568.162.camel@jnielson-xp.ddns.mvista.com> <1197133910.6353.33.camel@lappy> <1197133577.1568.166.camel@jnielson-xp.ddns.mvista.com> <1197135413.6353.36.camel@lappy> <3efb10970712081152o2d4abcfbo634a8d2445c09699@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3efb10970712081152o2d4abcfbo634a8d2445c09699@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Remy Bohmer <linux@bohmer.net> wrote:

> But... now we do not transfer the dev->sem to a mutex, because lockdep 
> will start generating false positives, and thus we mask the lockdep 
> error, by not converting the dev->sem to what it really is...

no, you are wrong. If you want to do complex locking, you can still do 
it: take a look at the dev->sem conversion patches from Peter which 
correctly do this. Lockdep has all the facilities for that. (you just 
dont know about them) Currently there are 4459 critical sections in the 
kernel that use mutexes and which work fine with lockdep.

the general policy message here is: do not implement complex locking. It 
hurts. It's hard to maintain. It's easy to mess up and leads to bugs. 
Lockdep just makes that plain obvious.

Your mail and your frustration shows this general concept in happy 
action: judging from your comments you have little clue about dev->sem 
locking and its implications and you'd happily go along and pollute the 
kernel with complex and hard to maintain nested locking constructs.

Lockdep prevents you from doing it mindlessly, it _forces_ you to first 
understand the data structures, their locking and their relationship 
with each other. Then you can implement complexity, if you still want 
it.

That, Sir, is a Good Thing (tm).

	Ingo

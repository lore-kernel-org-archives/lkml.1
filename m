Return-Path: <linux-kernel-owner+w=401wt.eu-S1759699AbXH1QqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759699AbXH1QqL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 12:46:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759106AbXH1QpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 12:45:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50954 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758937AbXH1QpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 12:45:19 -0400
Date: Tue, 28 Aug 2007 18:45:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Boldi <a1426z@gawab.com>, Peter Zijlstra <peterz@infradead.org>,
       Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
Message-ID: <20070828164507.GA2969@elte.hu>
References: <200708111344.42934.a1426z@gawab.com> <200708280737.53439.a1426z@gawab.com> <alpine.LFD.0.999.0708272153530.25853@woody.linux-foundation.org> <200708280823.53663.a1426z@gawab.com> <alpine.LFD.0.999.0708280929000.25853@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0708280929000.25853@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, 28 Aug 2007, Al Boldi wrote:
> > 
> > I like your analysis, but how do you explain that these stalls 
> > vanish when __update_curr is disabled?
> 
> It's entirely possible that what happens is that the X scheduling is 
> just a slightly unstable system - which effectively would turn a small 
> scheduling difference into a *huge* visible difference.

i think it's because disabling __update_curr() in essence removes the 
ability of scheduler to preempt tasks - that hack in essence results in 
a non-scheduler. Hence the gears + X pair of tasks becomes a synchronous 
pair of tasks in essence - and thus gears cannot "overload" X.

Normally gears + X is an asynchronous pair of tasks, with gears (or 
xperf, or devel versions of firefox, etc.) not being throttled at all 
and thus being able to overload/spam the X server with requests. (And we 
generally want to _reward_ asynchronity and want to allow tasks to 
overlap each other and we want each task to go as fast and as parallel 
as it can.)

Eventually X's built-in "bad, abusive client" throttling code kicks in, 
which, AFAIK is pretty crude and might yield to such artifacts. But ... 
it would be nice for an X person to confirm - and in any case i'll try 
Al's workload - i thought i had a reproducer but i barked up the wrong 
tree :-) My laptop doesnt run with the vesa driver, so i have no easy 
reproducer for now.

( also, it would be nice if Al could try rc4 plus my latest scheduler
  tree as well - just on the odd chance that something got fixed
  meanwhile. In particular Mike's sleeper-bonus-limit fix could be
  related. )

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758046AbYC1Una@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046AbYC1Una (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 16:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753471AbYC1UnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 16:43:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50050 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754704AbYC1UnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 16:43:21 -0400
Date: Fri, 28 Mar 2008 21:42:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Adrian Bunk <bunk@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc7-git2: Reported regressions from 2.6.24
Message-ID: <20080328204256.GA7159@elte.hu>
References: <200803272353.51901.rjw@sisk.pl> <alpine.LFD.1.00.0803281215120.3781@apollo.tec.linutronix.de> <20080328113112.GE32200@cs181133002.pp.htv.fi> <200803281717.17962.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803281717.17962.rjw@sisk.pl>
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


> Subject		: 2.6.24-git15 Keyboard Issue?

Rafael, we can close this bug i think. The group scheduler related 
interactivity problems in early .25-rc were resolved via:

| commit 62fb185130e4d420f71a30ff59d8b16b74ef5d2b
| Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
| Date:   Mon Feb 25 17:34:02 2008 +0100
|
|     sched: revert load_balance_monitor() changes
[...]
|    Namely:
|     - very frequent wakeups on SMP, reported by PowerTop users.
|     - cacheline trashing on (large) SMP
|     - some latencies larger than 500ms

that includes Xorg's fragility to certain types of delays. It should be 
resolved by now and i havent seen it resurface.

we are now back to the 2.6.24 state of things. Which isnt as perfectly 
interactive as the non-group-scheduler 2.6.24, but which is still more 
interactive than say 2.6.22.

Peter is working on improving it even more, but that's 2.6.26 material.

	Ingo

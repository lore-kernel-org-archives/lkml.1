Return-Path: <linux-kernel-owner+w=401wt.eu-S1760290AbXERK13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760290AbXERK13 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 06:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754726AbXERK1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 06:27:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51138 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754856AbXERK1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 06:27:21 -0400
Date: Fri, 18 May 2007 12:26:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Anant Nitya <kernel@prachanda.info>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] CFS scheduler, -v13
Message-ID: <20070518102607.GA23151@elte.hu>
References: <20070517174533.GA538@elte.hu> <200705180317.06014.kernel@prachanda.hub>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705180317.06014.kernel@prachanda.hub>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.7
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.7 required=5.9 tests=BAYES_00,INFO_TLD autolearn=no SpamAssassin version=3.1.7
	1.3 INFO_TLD               URI: Contains an URL in the INFO top-level domain
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Anant Nitya <kernel@prachanda.info> wrote:

> Hi
>
> Been testing this version of CFS from last an hour or so and still 
> facing same lag problems while browsing sites with heavy JS and or 
> flash usage. Mouse movement is pathetic and audio starts to skip. I 
> haven't face this behavior with CFS till v11.

i have just tried 5 different versions of the Flash plugin and i cannot 
reproduce this (flash games are still smooth and acceptable even with 
the system significantly overloaded with 5 infite loops or with a kernel 
build), so it would be nice if you could help me debug this problem.

The last version that worked for you was v11, correct? The biggest v11 
-> v12 change was the yield workaround, and while testing your workload 
i also noticed that all Flash versions except the latest one (9.0 r31) 
use sys_sched_yield() quite frequently. So it would be nice to know 
which plugin version you are using (and which Firefox version): you can 
check that by typing about:plugins into firefox. Furthermore, could you 
also try the following tune:

   echo 0 > /proc/sys/kernel/sched_yield_bug_workaround

and this:

   echo 2 > /proc/sys/kernel/sched_yield_bug_workaround

if none of this changes behavior then please send me the output of the 
following:

  strace -ttt -TTT -o strace.txt -f -p `pidof firefox-bin`
  < reproduce the lag in firefox >
  < Ctrl-C the strace >
  
and send me the strace.txt file (off-line, it's going to be large). 
Thanks,

	Ingo

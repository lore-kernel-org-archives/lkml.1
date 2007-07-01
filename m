Return-Path: <linux-kernel-owner+w=401wt.eu-S1756252AbXGAIb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252AbXGAIb4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 04:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754801AbXGAIbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 04:31:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34001 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754303AbXGAIbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 04:31:46 -0400
Date: Sun, 1 Jul 2007 10:31:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [patch] CFS scheduler, -v18
Message-ID: <20070701083102.GA4499@elte.hu>
References: <20070622220202.GA16872@elte.hu> <20070630210649.GA13186@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070630210649.GA13186@1wt.eu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Willy Tarreau <w@1wt.eu> wrote:

> Ingo,
> 
> I've accidentally discovered a problem with -v18.
> 
> Some time ago, I wrote a small program to prevent my laptop from 
> entering low-power mode, and noticed that after upgrading my laptop's 
> kernel from 2.4.20.9+cfs-v6 to 2.4.20.14+cfs-v18, it completely 
> freezes if I run this program.
> 
> The program is trivial, it just sets its prio to nice +20 and forks a 
> busy loop. I've added the ability to stop the loop after a 
> user-definable number of iterations, and I can confirm that it 
> unfreezes when the loop ends. I'm not even root when I run it.

hm, i tried your test-app and it causes no problems here. (which is not 
a surprise - your app starts a nice +19 busy loop, which is one of the 
common tests i do here too.)

To further debug this, could you try to create a 'high priority shell' 
on a text console (i.e. not under X) that is SCHED_FIFO prio 98? 
Something like:

  chrt -f -p 98 $$

should do the trick. And then run this script:

  http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh

before the test, during the test and after the test, from the high-prio 
shell session. (the shell runs at SCHED_FIFO, so the expectation would 
be for that it will be able to run during the test too) Then please send 
me the resulting 3 debug files. Thanks,

	Ingo

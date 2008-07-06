Return-Path: <linux-kernel-owner+w=401wt.eu-S1758350AbYGFQ7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758350AbYGFQ7o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 12:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756862AbYGFQ7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 12:59:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53177 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754865AbYGFQ7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 12:59:34 -0400
Date: Sun, 6 Jul 2008 18:58:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maximilian Engelhardt <maxi@daemonizer.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: 2.6.26-rc9: Reported regressions from 2.6.25
Message-ID: <20080706165810.GA16189@elte.hu>
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik> <alpine.LFD.1.10.0807060816070.3016@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807060816070.3016@woody.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10815
> > Subject		: 2.6.26-rc4: RIP find_pid_ns+0x6b/0xa0
> > Submitter	: Alexey Dobriyan <adobriyan@gmail.com>
> > Date		: 2008-05-27 09:23 (41 days old)
> > References	: http://lkml.org/lkml/2008/5/27/9
> > 		  http://lkml.org/lkml/2008/6/14/87
> > Handled-By	: Oleg Nesterov <oleg@tv-sign.ru>
> > 		  Linus Torvalds <torvalds@linux-foundation.org>
> > 		  Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Patch		: http://lkml.org/lkml/2008/5/28/16
> 
> This one is the same thing that is reported as unresolved, and no, I 
> don't think that existing patch was ever really tested to fix 
> anything. Paul?
> 
> I suspect SRCU will need to be simply marked BROKEN for now, because 
> nobody knows what the problem Alexey sees is. Apparently it's been 
> seen by a few other people too.

I'm not sure it's directly related to SRCU - it can change timings and 
freeing patterns enough to tickle other bugs. Since Alexey Dobriyan has 
reported it - are perhaps namespaces in use during this stress-test? 
Maybe it's some namespaces related bug that is more easily reproduced 
under SRCU - namespaces is not a commonly tested feature.

Also, i've been running rcutorture stress-tests on a number of 
test-systems ever since this got reported (and they are running 
currently as well) and cannot see it - neither could Paul reproduce it.

( and Paul is very good in producing RCU related problems - he's
  triggered and fixed many RCU related problems that no-one else saw
  before. )

	Ingo

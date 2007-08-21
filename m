Return-Path: <linux-kernel-owner+w=401wt.eu-S1757271AbXHUInR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbXHUInR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 04:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbXHUInG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 04:43:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37639 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262AbXHUInF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 04:43:05 -0400
Date: Tue, 21 Aug 2007 10:42:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Jan Glauber <jang@linux.vnet.ibm.com>, heiko.carstens@de.ibm.com,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [accounting regression since rc1]  scheduler updates
Message-ID: <20070821084243.GB1144@elte.hu>
References: <20070812163225.GA11996@elte.hu> <200708141037.48001.borntraeger@de.ibm.com> <20070820154529.GA300@elte.hu> <200708211017.02998.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708211017.02998.borntraeger@de.ibm.com>
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


* Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> Am Montag, 20. August 2007 schrieb Ingo Molnar:
> > could you send that precise sched_clock() patch? It should be an order 
> > of magnitude simpler than the high-precision stime/utime tracking you 
> > already do, and it's needed for quality scheduling anyway.
> 
> I have a question about that. I just played with sched_clock, and even 
> when I intentionally slow down sched_clock by a factor of 2, my cpu 
> bound process gets 100 % in top. If this is intentional, I dont 
> understand how a virtualized sched_clock would fix the accounting 
> change?

hm, does on s390 scheduler_tick() get driven in virtual time or in real 
time? The very latest scheduler code will enforce a minimum rate of 
sched_clock() across two scheduler_tick() calls (in rc3 and later 
kernels). If sched_clock() "slows down" but scheduler_tick() still has a 
real-time frequency then that impacts the quality of scheduling. So 
scheduler_tick() and sched_clock() must really have the same behavior 
(either both are virtual or both are real), so that scheduling becomes 
invariant to steal-time.

	Ingo

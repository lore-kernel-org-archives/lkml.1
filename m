Return-Path: <linux-kernel-owner+w=401wt.eu-S1758433AbXHULa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758433AbXHULa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 07:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754159AbXHULav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 07:30:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50081 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394AbXHULav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 07:30:51 -0400
Date: Tue, 21 Aug 2007 13:30:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jan Glauber <jang@linux.vnet.ibm.com>, heiko.carstens@de.ibm.com,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [accounting regression since rc1]  scheduler updates
Message-ID: <20070821113037.GA2390@elte.hu>
References: <20070812163225.GA11996@elte.hu> <200708211243.15223.borntraeger@de.ibm.com> <20070821111544.GA32064@elte.hu> <200708211324.13442.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708211324.13442.borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.0.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4806]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> Am Dienstag, 21. August 2007 schrieb Ingo Molnar:
> > you mean to revert b27f03d4bd? I'd really like to see this fixed for 
> > real for s390 + CONFIG_VIRT_CPU_ACCOUNTING=y. (which seems to be the 
> > only case affected)
> 
> Not a complete revert, but an ifdef-workaround. I wrote this patch last week 
> and you were on cc:
> http://marc.info/?l=linux-mm-commits&m=118737949222362&w=2
> 
> This patch should fix s390 and let everybody else use your new code. 
> If you are conviced that we get a better solution before 2.6.23 hits 
> the street, thats fine with me.

what do you think about the rq_clock() #ifdef i did in the previous mail 
plus you making sched_clock() virtual? That way you can keep 
scheduler_tick() driven by real-time, although that generally will cause 
artifacts with SMP load-balancing too. (that was true in the past too)

but i dont mind your patch either - it's really the architecture's 
choice how visible it wants to make external load to the task stats of 
its virtual machines. I think it is more logical to say that 100% CPU 
time displayed in 'top' means that the task got all the CPU time it 
asked for from the virtual machine. (and if you are curious about how 
much time was stolen from the virtual box altogether you look at the 
stolen-time stats in isolation.)

	Ingo

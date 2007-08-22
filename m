Return-Path: <linux-kernel-owner+w=401wt.eu-S1755932AbXHVH7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbXHVH7j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 03:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755759AbXHVH7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 03:59:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56714 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755552AbXHVH7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 03:59:30 -0400
Date: Wed, 22 Aug 2007 09:59:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Jan Glauber <jang@linux.vnet.ibm.com>, heiko.carstens@de.ibm.com,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [accounting regression since rc1]  scheduler updates
Message-ID: <20070822075912.GA7411@elte.hu>
References: <20070812163225.GA11996@elte.hu> <200708211017.02998.borntraeger@de.ibm.com> <20070821112529.GB648@elte.hu> <200708220950.35044.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708220950.35044.borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.0.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4973]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> Am Dienstag, 21. August 2007 schrieben Sie:
> > could you try the patch below, does it work any better?
> 
> I looked again at the scheduler code and things are getting better 
> when I run the patch below on top of your patch and with our 
> sched_clock prototype. I guess there is a reason why you want 
> rq->clock advanced by at least one tick?

yeah - on PCs if for whatever reason the TSC misbehaves (and that's 
quite frequent) then this code sets a minimum boundary for behavior. If 
sched_clock() is totally random or does not advance at all or goes 
backwards all the time then rq_clock() still functions and falls back to 
jiffies-granularity behavior in essence.

> We discussed calling scheduler_tick with virtual time as well.
> Would it have the same result?
> What would be the impact on latency?

if you call scheduler_tick() with virtual time then the "safety" 
measures in rq_clock() do not kick in and sched_clock() behaves 
correctly as far as the scheduler is concerned. (if everything is in 
virtual time then the scheduler has no way to observe/notice that in 
reality this is a virtual machine.)

> After looking at the current s390 timer code, it seems that this kind of 
> change is not trivial enough to be rc3+ ready. 
> I personally think, that for 2.6.23 we should use the patch against 
> fs/proc/array.c and everything else for 2.6.24?

yes, that has the least impact for .23 - i have added your array.c patch 
to my queue.

	Ingo

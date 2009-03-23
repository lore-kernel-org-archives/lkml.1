Return-Path: <linux-kernel-owner+w=401wt.eu-S1759304AbZCWQQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759304AbZCWQQS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 12:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754936AbZCWQQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 12:16:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57029 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754140AbZCWQQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 12:16:00 -0400
Date: Mon, 23 Mar 2009 17:13:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
       peterz@infradead.org, roland@redhat.com, efault@gmx.de, rjw@sisk.pl,
       jdike@addtoit.com, user-mode-linux-devel@lists.sourceforge.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       stable@kernel.org
Subject: Re: [patch] fix ptrace slowness
Message-ID: <20090323161358.GB24940@elte.hu>
References: <E1LllkK-0000zF-1h@pomaz-ex.szeredi.hu> <20090323151954.GC21267@elte.hu> <20090323155303.GA5528@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090323155303.GA5528@redhat.com>
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


* Oleg Nesterov <oleg@redhat.com> wrote:

> On 03/23, Ingo Molnar wrote:
> >
> > There's an alternative patch
> > below. Would you mind to give it a test? Chances are that it will
> > make UML even faster than your fix.
> >
> > 	Ingo
> >
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index 3e827b8..2d60f23 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -2119,7 +2119,8 @@ unsigned long wait_task_inactive(struct task_struct *p, long match_state)
> >  		 * yield - it could be a while.
> >  		 */
> >  		if (unlikely(on_rq)) {
> > -			schedule_timeout_uninterruptible(1);
> > +			cpu_relax();
> > +			cond_resched();
> 
> What if the caller is a realtime task? We can spin "forever", no?

hm, yes. I sure should have noticed _that_ ;-)

	Ingo

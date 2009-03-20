Return-Path: <linux-kernel-owner+w=401wt.eu-S1757624AbZCTLk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624AbZCTLk5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 07:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752179AbZCTLks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 07:40:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38807 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731AbZCTLkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 07:40:47 -0400
Date: Fri, 20 Mar 2009 12:39:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: peterz@infradead.org, roland@redhat.com, efault@gmx.de, rjw@sisk.pl,
       jdike@addtoit.com, user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org
Subject: Re: [patch] don't preempt not TASK_RUNNING tasks
Message-ID: <20090320113943.GC11751@elte.hu>
References: <E1LkbGe-00039U-Hc@pomaz-ex.szeredi.hu> <1237543392.24626.49.camel@twins> <E1Lkc6U-0003II-W1@pomaz-ex.szeredi.hu> <20090320105306.GG6256@elte.hu> <E1LkcrP-0003Np-T2@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1LkcrP-0003Np-T2@pomaz-ex.szeredi.hu>
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


* Miklos Szeredi <miklos@szeredi.hu> wrote:

> On Fri, 20 Mar 2009, Ingo Molnar wrote:
> > > > The first line of attack for this problem is making 
> > > > wait_task_inactive() sucks less, which shouldn't be too hard, 
> > > > that unconditional 1 jiffy sleep is simply retarded.
> > > 
> > > I completely agree.  However, I'd like to have a non-invasive 
> > > solution that can go into current and stable kernels so UML users 
> > > don't need to suffer any more.
> > 
> > Agreed. task_unlock_no_resched() should do that i think.
> 
> I don't see how that would help.

it more clearly expresses the need there, and we already have 
_no_resched API variants (we add them on an as-needed basis).

Doing:

 preempt_disable();
 read_lock();
 ...
 read_unlock();
 preempt_enable_no_resched();

Really just open-codes read_unlock_no_resched() and uglifies the 
code.

> ptrace_stop() specifically would need read_unlock_no_resched().  
> But I'm reluctant to add more spinlock functions with all their 
> variants...

if you worry about backportability, we can certainly add the easy 
fix too, if it's followed by the more involved fix(es).

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S932724AbXJQOww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932724AbXJQOww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 10:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757693AbXJQOwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 10:52:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41071 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754988AbXJQOwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 10:52:39 -0400
Date: Wed, 17 Oct 2007 16:52:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Mike Galbraith <efault@gmx.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [BUG] 2.6.23-git8 kernel oops at __rb_rotate_left+0x7/0x70
Message-ID: <20071017145226.GA21676@elte.hu>
References: <47144B4F.3050108@linux.vnet.ibm.com> <20071017142140.GA8634@elte.hu> <20071017150056.GA28135@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017150056.GA28135@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:

> On Wed, Oct 17, 2007 at 04:21:40PM +0200, Ingo Molnar wrote:
> > * Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> > 
> > > While running kernbench with the 2.6.23-git8 following oops is 
> > > produced
> > 
> > Dmitry found something that might explain the crash: could you check 
> > whether the patch below fixes it?
> 
> > this should fix the put_prev_task crashes that were reported,
> > Dmitry Adamushko noticed that it's not valid to call into
> > task_new_fair() if this_cpu != task_cpu(p).
> 
> I don't see a fundamental reason why it would be invalid to call 
> task_new_fair() when this_cpu != task_cpu(p). Besides, calling 
> activate_task->enqueue_task->enqueue_task_fair() on a new born task 
> (as is being done in the patch you have sent) is slightly buggy in the 
> sense that its p->se.vruntime is not properly calculated (because we 
> set wakeup argument as 0).

yes - i pointed this out in a separate mail.

> We (myself, Kamalesh and Dhaval) have tested the patch below, w/o 
> being able to recreate the problem. The patch allows for 
> task_new_fair() to be called even for the case when child is being 
> added to another cpu's runqueue.

yes, and your fix is the better one, it goes into the next batch of 
fixes.

	Ingo

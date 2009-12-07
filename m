Return-Path: <linux-kernel-owner+w=401wt.eu-S934807AbZLGIus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934807AbZLGIus (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 03:50:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934779AbZLGIuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 03:50:46 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52213 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934711AbZLGIun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 03:50:43 -0500
Subject: Re: [PATCH 7/7] sched: implement try_to_wake_up_local()
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: tglx@linutronix.de, mingo@elte.hu, avi@redhat.com, efault@gmx.de,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
In-Reply-To: <4B1C75F3.9080808@kernel.org>
References: <1259726212-30259-1-git-send-email-tj@kernel.org>
	 <1259726212-30259-8-git-send-email-tj@kernel.org>
	 <1259923487.3977.1940.camel@laptop>  <4B1C75F3.9080808@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Dec 2009 09:50:03 +0100
Message-ID: <1260175804.8223.1217.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-07 at 12:26 +0900, Tejun Heo wrote:
> Hello,
> 
> On 12/04/2009 07:44 PM, Peter Zijlstra wrote:
> > On Wed, 2009-12-02 at 12:56 +0900, Tejun Heo wrote:
> > 
> >> +++ b/kernel/sched.c
> >> @@ -2410,6 +2410,10 @@ static inline void ttwu_woken_up(struct task_struct *p, struct rq *rq,
> >>  		rq->idle_stamp = 0;
> >>  	}
> >>  #endif
> >> +	/*
> >> +	 * Wake up is complete, fire wake up notifier.  This allows
> >> +	 * try_to_wake_up_local() to be called from wake up notifiers.
> >> +	 */
> >>  	if (success)
> >>  		fire_sched_notifiers(p, wakeup);
> >>  }
> > 
> >> @@ -5437,6 +5488,11 @@ need_resched_nonpreemptible:
> >>  		if (unlikely(signal_pending_state(prev->state, prev))) {
> >>  			prev->state = TASK_RUNNING;
> >>  		} else {
> >> +			/*
> >> +			 * Fire sleep notifier before changing any scheduler
> >> +			 * state.  This allows try_to_wake_up_local() to be
> >> +			 * called from sleep notifiers.
> >> +			 */
> >>  			fire_sched_notifiers(prev, sleep);
> >>  			deactivate_task(rq, prev, 1);
> >>  		}
> > 
> > These two hunks seem to belong to patch 6
> 
> Hmmm... it was intentional as, before this patch, there's no
> try_to_wake_up_local() so it was strange to mention it in the comment.
> I can move the comments but I don't think it's particularly better
> that way.

/me reads the comments and goes ah!

OK, maybe you've got a point there ;-)


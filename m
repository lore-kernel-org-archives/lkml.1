Return-Path: <linux-kernel-owner+w=401wt.eu-S1764142AbXFFL3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764142AbXFFL3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 07:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751019AbXFFL3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 07:29:08 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:46918 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813AbXFFL3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 07:29:07 -0400
Date: Wed, 6 Jun 2007 17:07:33 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
Cc: "Balbir Singh" <balbir@linux.vnet.ibm.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [patch] CFS scheduler, -v15
Message-ID: <20070606113733.GD3274@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070531150908.GA23538@elte.hu> <20070606064228.GA22443@in.ibm.com> <20070606070143.GA7375@elte.hu> <20070606074317.GB3274@in.ibm.com> <b647ffbd0706060208i5666f57eoe96215b636617622@mail.gmail.com> <46668E4D.8060206@linux.vnet.ibm.com> <20070606105950.GA32729@in.ibm.com> <b647ffbd0706060419v1ed81e15w312f44aad8975d5b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b647ffbd0706060419v1ed81e15w312f44aad8975d5b@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 01:19:01PM +0200, Dmitry Adamushko wrote:
> >Yes this is the approach I prefer, because we burden the fast/normal
> >path less that way (RT->NORMAL transition is not common).
> 
> I don't think that rt_sched_class :: dequeue_task_rt() is in any of
> such "fast pathes" that we should really care about an additional
> math. operation.
> 
> If this approach is ok, logically-wise (no side effects from a short
> 'delta_exec', esp. on RT -> NORMAL).. I think it's better as it keeps
> the 'sched_class' interface simpler.

I can see your point, given that we just update exec_start in
dequeue_task_rt(). However the situation is slightly more complex in my
patch stack, as I need to update other things during group change. Perhaps
we can postpone this discussion until I post that patch stack.

> >That's why I
> >was considering a set_curr_task() method in fair_sched_class which will
> >be invoked in __setscheduler() if the new policy of currently running
> >task happens to be SCHED_NORMAL/BATCH. Alternately if the new policy of
> >currently running task happens to be SCHED_FIFO (and its old policy was
> >SCHED_NORMAL) we need to invoke put_prev_task() method (so that
> >fair_clock etc is updated based on outgoing task's execution time in
> >SCHED_NORMAL class).
> 
> rt_sched_class :: put_prev_task() from __setscheduler() ?

No, fair_sched_class :: put_prev_task() if we are transitioning from
NORMAL->RT. That will update the fair_clock based on execution time
of current task in fair_sched class?

> But it's not
> supposed to be called from here, logically-wise. You just rely on its
> current behavior (which is only about updating 'exec_start' and
> 'exec_sum') -- that's just bad. Maybe I misunderatood your intention
> though..

-- 
Regards,
vatsa

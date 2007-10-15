Return-Path: <linux-kernel-owner+w=401wt.eu-S933162AbXJORsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933162AbXJORsZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 13:48:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762515AbXJORsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 13:48:06 -0400
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:61633 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761777AbXJORsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 13:48:02 -0400
Date: Mon, 15 Oct 2007 13:47:33 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Gregory Haskins <ghaskins@novell.com>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 4/7] RT: Add support for updating push-rt priority under
 PI boost
In-Reply-To: <20071013001554.7444.3543.stgit@novell1.haskins.net>
Message-ID: <Pine.LNX.4.58.0710151347161.26495@gandalf.stny.rr.com>
References: <20071013001052.7444.8363.stgit@novell1.haskins.net>
 <20071013001554.7444.3543.stgit@novell1.haskins.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 12 Oct 2007, Gregory Haskins wrote:

Again no description.

-- Steve

> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> ---
>
>  kernel/sched.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 50c88e8..62f9f0b 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -4663,6 +4663,7 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
>  		 * this runqueue and our priority is higher than the current's
>  		 */
>  		if (task_running(rq, p)) {
> +			set_rq_prio(rq, p->prio);
>  			if (p->prio > oldprio)
>  				resched_task(rq->curr);
>  		} else {
> @@ -4722,6 +4723,9 @@ void set_user_nice(struct task_struct *p, long nice)
>  		 */
>  		if (delta < 0 || (delta > 0 && task_running(rq, p)))
>  			resched_task(rq->curr);
> +
> +		if (delta && task_running(rq, p))
> +			set_rq_prio(rq, p->prio);
>  	}
>  out_unlock:
>  	task_rq_unlock(rq, &flags);
>
>
>

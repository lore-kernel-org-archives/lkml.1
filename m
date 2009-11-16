Return-Path: <linux-kernel-owner+w=401wt.eu-S1753417AbZKPSk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417AbZKPSk4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 13:40:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbZKPSkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 13:40:55 -0500
Received: from casper.infradead.org ([85.118.1.10]:34660 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbZKPSkz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 13:40:55 -0500
Subject: Re: [PATCH 04/21] sched: implement scheduler notifiers
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       torvalds@linux-foundation.org, avi@redhat.com, andi@firstfloor.org,
       fweisbec@gmail.com
In-Reply-To: <1258391726-30264-5-git-send-email-tj@kernel.org>
References: <1258391726-30264-1-git-send-email-tj@kernel.org>
	 <1258391726-30264-5-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 16 Nov 2009 19:41:04 +0100
Message-ID: <1258396864.4372.55.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-17 at 02:15 +0900, Tejun Heo wrote:
> @@ -1939,6 +1953,8 @@ static int effective_prio(struct task_struct *p)
>   */
>  static void activate_task(struct rq *rq, struct task_struct *p, int wakeup)
>  {
> +       sched_notifier_call(p, SCHED_NOTIFIER_ACTIVATED, activated, wakeup);
> +
>         if (task_contributes_to_load(p))
>                 rq->nr_uninterruptible--;
>  
> @@ -1951,6 +1967,8 @@ static void activate_task(struct rq *rq, struct task_struct *p, int wakeup)
>   */
>  static void deactivate_task(struct rq *rq, struct task_struct *p, int sleep)
>  {
> +       sched_notifier_call(p, SCHED_NOTIFIER_DEACTIVATED, deactivated, sleep);
> +
>         if (task_contributes_to_load(p))
>                 rq->nr_uninterruptible++;
> 

I really hate exposing activate/deactivate.

You say:

> Activated and deactivated are called
> when a task's readiness to run changes.

How is that not clear from the out hook? It would seem to me that when
you get scheduled out with a p->state != TASK_RUNNING you're not ready.

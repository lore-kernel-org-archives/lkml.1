Return-Path: <linux-kernel-owner+w=401wt.eu-S1752052AbXFNL5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbXFNL5v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 07:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbXFNL5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 07:57:44 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:35702 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbXFNL5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 07:57:43 -0400
Date: Thu, 14 Jun 2007 17:36:05 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       containers@lists.osdl.org, ckrm-tech@lists.sourceforge.net
Subject: Re: [RFC][PATCH 5/6] core changes for group fairness
Message-ID: <20070614120605.GA30965@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20070611154724.GA32435@in.ibm.com> <20070611155608.GE2109@in.ibm.com> <b647ffbd0706131356q344af13as3744c151b4a4f680@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b647ffbd0706131356q344af13as3744c151b4a4f680@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2007 at 10:56:06PM +0200, Dmitry Adamushko wrote:
> >+static int balance_tasks(struct rq *this_rq, int this_cpu, struct rq 
> >*busiest,
> >+                     unsigned long max_nr_move, unsigned long 
> >max_load_move,
> >+                     struct sched_domain *sd, enum idle_type idle,
> >+                     int *all_pinned, unsigned long *load_moved,
> >+                     int this_best_prio, int best_prio, int 
> >best_prio_seen,
> >+                     void *iterator_arg,
> >+                     struct task_struct *(*iterator_start)(void *arg),
> >+                     struct task_struct *(*iterator_next)(void *arg));
> 
> IMHO, it looks a bit frightening :) 

I agree :) It is taking (ooops) 15 args (8 perhaps was the previous record
in sched.c (move_tasks)!

> maybe it would be possible to
> create a structure that combines some relevant argumens .. at least,
> the last 3 ones.

How does this look?

struct balance_tasks_args {
	struct rq *this_rq, struct rq *busiest;
	unsigned long max_nr_move, unsigned long max_load_move;
	struct sched_domain *sd, enum idle_type idle;
	int this_best_prio, best_prio, best_prio_seen;
	int *all_pinned;
	unsigned long *load_moved;
	void *iterator_arg;
	struct task_struct *(*iterator_start)(void *arg);
	struct task_struct *(*iterator_next)(void *arg));
};

static int balance_tasks(struct balance_tasks_args *arg);

[ down to one argument now! ]

?

I will try this in my next iteration ..


> >-static int move_tasks(struct rq *this_rq, int this_cpu, struct rq 
> >*busiest,
> >+static int balance_tasks(struct rq *this_rq, int this_cpu, struct rq 
> >*busiest,
> >                      unsigned long max_nr_move, unsigned long 
> >                      max_load_move,
> >                      struct sched_domain *sd, enum idle_type idle,
> >-                     int *all_pinned)
> >+                     int *all_pinned, unsigned long *load_moved,
> >+                     int this_best_prio, int best_prio, int 
> >best_prio_seen,
> >+                     void *iterator_arg,
> >+                     struct task_struct *(*iterator_start)(void *arg),
> >+                     struct task_struct *(*iterator_next)(void *arg))
> 
> I think, there is a possible problem here. If I'm not complete wrong,
> this function (move_tasks() in the current mainline) can move more
> 'load' than specified by the 'max_load_move'..

Yes I think you are right. I will tackle this in next iteration.

Thanks for all your review so far!

-- 
Regards,
vatsa

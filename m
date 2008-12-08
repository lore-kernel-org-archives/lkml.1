Return-Path: <linux-kernel-owner+w=401wt.eu-S1754456AbYLHOdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456AbYLHOdD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 09:33:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbYLHOcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 09:32:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50005 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752915AbYLHOcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 09:32:41 -0500
Date: Mon, 8 Dec 2008 15:32:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] RT scheduler updates for tip
Message-ID: <20081208143228.GF14856@elte.hu>
References: <493939B1.40506@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <493939B1.40506@novell.com>
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


* Gregory Haskins <ghaskins@novell.com> wrote:

> Hi Ingo,
>   FWIW, I have placed all my latest upstream-able scheduler patches into
> a branch in my git tree (against tip/master).
>  
>  
> git://git.kernel.org/pub/scm/linux/kernel/git/ghaskins/linux-2.6-hacks.git
> sched/latest
> 
> Gregory Haskins (11):
>       sched: cleanup inc/dec_rt_tasks
>       sched: track the next-highest priority on each runqueue
>       sched: use highest_prio.curr for pull threshold
>       sched: use highest_prio.next to optimize pull operations
>       sched: only try to push a task on wakeup if it is migratable
>       sched: pull only one task during NEWIDLE balancing to limit
> critical section
>       sched: make double-lock-balance fair
>       sched: add sched_class->needs_post_schedule() member
>       plist: fix PLIST_NODE_INIT to work with debug enabled
>       sched: create "pushable_tasks" list to limit pushing to one attempt
>       RT: fix push_rt_task() to handle dequeue_pushable properly
> 
>  include/linux/init_task.h |    1 +
>  include/linux/plist.h     |    9 +-
>  include/linux/sched.h     |    2 +
>  kernel/sched.c            |   89 +++++++++++--
>  kernel/sched_rt.c         |  324
> +++++++++++++++++++++++++++++++--------------
>  5 files changed, 312 insertions(+), 113 deletions(-)
> 
> These are built/booted on my quad-core/x86_64 and look good to me.
> 
> 1) the first four are the "next-highest" v3 patches that I submitted 
> yesterday 2) the last seven are patches that Steven has carried in 
> 26-rt that have not yet been pulled in to tip
> 
> I assume there is an implicit ACK from Steven on (2) since he pulled 
> them into -rt.  We still await comment from Peter re: (1).

pulled into tip/cpus4096, thanks Gregory!

(It goes into the cpumask tree because it already changed a few areas 
that you relied on.)

	Ingo

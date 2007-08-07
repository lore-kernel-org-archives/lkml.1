Return-Path: <linux-kernel-owner+w=401wt.eu-S1756123AbXHGHLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123AbXHGHLs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 03:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753885AbXHGHLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 03:11:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38362 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837AbXHGHLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 03:11:39 -0400
Date: Tue, 7 Aug 2007 09:11:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: Nick Piggin <npiggin@suse.de>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: Fix bug in balance_tasks()
Message-ID: <20070807071128.GD19745@elte.hu>
References: <46B7F568.3040901@bigpond.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B7F568.3040901@bigpond.net.au>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Williams <pwil3058@bigpond.net.au> wrote:

> There are two problems with balance_tasks() and how it used:
> 
> 1. The variables best_prio and best_prio_seen (inherited from the old 
> move_tasks()) were only required to handle problems caused by the 
> active/expired arrays, the order in which they were processed and the 
> possibility that the task with the highest priority could be on 
> either. These issues are no longer present and the extra overhead 
> associated with their use is unnecessary (and possibly wrong).

indeed.

> 2. In the absence of CONFIG_FAIR_GROUP_SCHED being set, the same 
> this_best_prio variable needs to be used by all scheduling classes or 
> there is a risk of moving too much load.  E.g. if the highest priority 
> task on this at the beginning is a fairly low priority task and the rt 
> class migrates a task (during its turn) then that moved task becomes the 
> new highest priority task on this_rq but when the sched_fair class 
> initializes its copy of this_best_prio it will get the priority of the 
> original highest priority task as, due to the run queue locks being 
> held, the reschedule triggered by pull_task() will not have taken place. 
>  This could result in inappropriate overriding of skip_for_load and 
> excessive load being moved.

looks good to me - i've applied your fixes to my tree. (I'll give it a 
good workout to see if there's any negative impact on the quality 
balancing.)

	Ingo

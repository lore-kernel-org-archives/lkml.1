Return-Path: <linux-kernel-owner+w=401wt.eu-S1758546AbXISViS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758546AbXISViS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 17:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbXISViF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 17:38:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45301 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536AbXISViE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 17:38:04 -0400
Date: Wed, 19 Sep 2007 23:37:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] sched: fix to use invalid sched_class
Message-ID: <20070919213715.GA14086@elte.hu>
References: <46F19148.4090404@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F19148.4090404@ct.jp.nec.com>
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


* Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> Hi Ingo,
> 
> I found an issue about the scheduler.
> If you need a test case, please let me know.
> Here is a patch.
> 
> When using rt_mutex, a NULL pointer dereference is occurred at
> enqueue_task_rt. Here is a scenario;
> 1) there are two threads, the thread A is fair_sched_class and
>    thread B is rt_sched_class.
> 2) Thread A is boosted up to rt_sched_class, because the thread A
>    has a rt_mutex lock and the thread B is waiting the lock.
> 3) At this time, when thread A create a new thread C, the thread
>    C has a rt_sched_class.
> 4) When doing wake_up_new_task() for the thread C, the priority
>    of the thread C is out of the RT priority range, because the
>    normal priority of thread A is not the RT priority. It makes
>    data corruption by overflowing the rt_prio_array.
> The new thread C should be fair_sched_class.
> 
> The new thread should be valid scheduler class before queuing.
> This patch fixes to set the suitable scheduler class.

Nice fix! It's a 2.6.23 must-have fix - i'll push it out into the 
scheduler tree. Thanks!

	Ingo

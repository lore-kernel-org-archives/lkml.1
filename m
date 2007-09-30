Return-Path: <linux-kernel-owner+w=401wt.eu-S1758343AbXI3PX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758343AbXI3PX0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 11:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757193AbXI3PXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 11:23:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59110 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755030AbXI3PXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 11:23:18 -0400
Date: Sun, 30 Sep 2007 17:23:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Uninline scheduler
Message-ID: <20070930152307.GA24077@elte.hu>
References: <20070928110253.GA6756@localhost.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070928110253.GA6756@localhost.sw.ru>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.1.7-deb
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2549]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexey Dobriyan <adobriyan@sw.ru> wrote:

> * save ~300 bytes
> * activate_idle_task() was moved to avoid a warning
> 
> bloat-o-meter output:
> 
> add/remove: 6/0 grow/shrink: 0/16 up/down: 438/-733 (-295)		<===
> function                                     old     new   delta
> __enqueue_entity                               -     165    +165
> finish_task_switch                             -     110    +110
> update_curr_rt                                 -      79     +79
> __load_balance_iterator                        -      32     +32
> __task_rq_unlock                               -      28     +28
> find_process_by_pid                            -      24     +24
> do_sched_setscheduler                        133     123     -10
> sys_sched_rr_get_interval                    176     165     -11
> sys_sched_getparam                           156     145     -11
> normalize_rt_tasks                           482     470     -12
> sched_getaffinity                            112      99     -13
> sys_sched_getscheduler                        86      72     -14
> sched_setaffinity                            226     212     -14
> sched_setscheduler                           666     642     -24
> load_balance_start_fair                       33       9     -24
> load_balance_next_fair                        33       9     -24
> dequeue_task_rt                              133      67     -66
> put_prev_task_rt                              97      28     -69
> schedule_tail                                133      50     -83
> schedule                                     682     594     -88
> enqueue_entity                               499     366    -133
> task_new_fair                                317     180    -137

thanks! I have queued up your patch for v2.6.24 merging.

	Ingo

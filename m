Return-Path: <linux-kernel-owner+w=401wt.eu-S1753113AbZKEJbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113AbZKEJbF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 04:31:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752978AbZKEJbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 04:31:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49650 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920AbZKEJbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 04:31:02 -0500
Date: Thu, 5 Nov 2009 10:30:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
       arjan@infradead.org, stable@kernel.org, tglx@linutronix.de
Subject: Re: [tip:sched/core] sched: Check for an idle shared cache in
	select_task_rq_fair()
Message-ID: <20091105093016.GA18892@elte.hu>
References: <1256654138.17752.7.camel@marge.simson.net> <tip-a1f84a3ab8e002159498814eaa7e48c33752b04b@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-a1f84a3ab8e002159498814eaa7e48c33752b04b@git.kernel.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for Mike Galbraith <efault@gmx.de> wrote:

> Commit-ID:  a1f84a3ab8e002159498814eaa7e48c33752b04b
> Gitweb:     http://git.kernel.org/tip/a1f84a3ab8e002159498814eaa7e48c33752b04b
> Author:     Mike Galbraith <efault@gmx.de>
> AuthorDate: Tue, 27 Oct 2009 15:35:38 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Wed, 4 Nov 2009 18:46:22 +0100
> 
> sched: Check for an idle shared cache in select_task_rq_fair()

-tip testing found that this causes problems:

[   26.804000] BUG: using smp_processor_id() in preemptible [00000000] code: events/1/10
[   26.808000] caller is vmstat_update+0x26/0x70
[   26.812000] Pid: 10, comm: events/1 Not tainted 2.6.32-rc5 #6887
[   26.816000] Call Trace:
[   26.820000]  [<c1924a24>] ? printk+0x28/0x3c
[   26.824000]  [<c13258a0>] debug_smp_processor_id+0xf0/0x110
[   26.824000] mount used greatest stack depth: 1464 bytes left
[   26.828000]  [<c111d086>] vmstat_update+0x26/0x70
[   26.832000]  [<c1086418>] worker_thread+0x188/0x310
[   26.836000]  [<c10863b7>] ? worker_thread+0x127/0x310
[   26.840000]  [<c108d310>] ? autoremove_wake_function+0x0/0x60
[   26.844000]  [<c1086290>] ? worker_thread+0x0/0x310
[   26.848000]  [<c108cf0c>] kthread+0x7c/0x90
[   26.852000]  [<c108ce90>] ? kthread+0x0/0x90
[   26.856000]  [<c100c0a7>] kernel_thread_helper+0x7/0x10
[   26.860000] BUG: using smp_processor_id() in preemptible [00000000] code: events/1/10
[   26.864000] caller is vmstat_update+0x3c/0x70

oh ... doesnt it break cpus_allowed?

	Ingo

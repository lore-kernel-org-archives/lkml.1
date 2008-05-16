Return-Path: <linux-kernel-owner+w=401wt.eu-S1757336AbYEPL5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336AbYEPL5g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 07:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbYEPL51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 07:57:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42282 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688AbYEPL50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 07:57:26 -0400
Date: Fri, 16 May 2008 13:57:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org, matthew@wil.cx,
       "Carlos R. Mafra" <crmafra2@gmail.com>
Subject: Re: [PATCH] Remove argument from open_softirq which is always NULL
Message-ID: <20080516115708.GA11718@elte.hu>
References: <20080515141537.GA22826@beyonder.ift.unesp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080515141537.GA22826@beyonder.ift.unesp.br>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Carlos R. Mafra <crmafra2@gmail.com> wrote:

> Subject: [PATCH] Remove argument from open_softirq which is always 
> NULL
> 
> As git-grep shows, open_softirq() is always called with the last 
> argument being NULL
> 
> block/blk-core.c:       open_softirq(BLOCK_SOFTIRQ, blk_done_softirq, NULL);
> kernel/hrtimer.c:       open_softirq(HRTIMER_SOFTIRQ, run_hrtimer_softirq, NULL);
> kernel/rcuclassic.c:    open_softirq(RCU_SOFTIRQ, rcu_process_callbacks, NULL);
> kernel/rcupreempt.c:    open_softirq(RCU_SOFTIRQ, rcu_process_callbacks, NULL);
> kernel/sched.c: open_softirq(SCHED_SOFTIRQ, run_rebalance_domains, NULL);
> kernel/softirq.c:       open_softirq(TASKLET_SOFTIRQ, tasklet_action, NULL);
> kernel/softirq.c:       open_softirq(HI_SOFTIRQ, tasklet_hi_action, NULL);
> kernel/timer.c: open_softirq(TIMER_SOFTIRQ, run_timer_softirq, NULL);
> net/core/dev.c: open_softirq(NET_TX_SOFTIRQ, net_tx_action, NULL);
> net/core/dev.c: open_softirq(NET_RX_SOFTIRQ, net_rx_action, NULL);
> 
> This observation has already been made by Matthew Wilcox in June 2002
> (http://www.cs.helsinki.fi/linux/linux-kernel/2002-25/0687.html)
> 
> "I notice that none of the current softirq routines use the data element
> passed to them."
> 
> and the situation hasn't changed since them. So it appears we can 
> safely remove that extra argument to save 128 (54) bytes of kernel 
> data (text).

applied to -tip, thanks Carlos. Nice find!

	Ingo

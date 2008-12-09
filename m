Return-Path: <linux-kernel-owner+w=401wt.eu-S1754871AbYLIS1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbYLIS1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 13:27:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754115AbYLIS1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 13:27:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43515 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753483AbYLIS1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 13:27:43 -0500
Date: Tue, 9 Dec 2008 19:27:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Brian King <brking@linux.vnet.ibm.com>
Cc: a.p.zijlstra@chello.nl, efault@gmx.de, vatsa@in.ibm.com,
       balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] sched: CPU remove deadlock fix
Message-ID: <20081209182724.GB21698@elte.hu>
References: <200812091548.mB9Fm0sm011959@d01av04.pok.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812091548.mB9Fm0sm011959@d01av04.pok.ibm.com>
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


* Brian King <brking@linux.vnet.ibm.com> wrote:

> This patch fixes a possible deadlock scenario in the CPU remove path. 
> migration_call grabs rq->lock, then wakes up everything on 
> rq->migration_queue with the lock held. Then one of the tasks on the 
> migration queue ends up calling tg_shares_up which then also tries to 
> acquire the same rq->lock.
> 
> [c000000058eab2e0] c000000000502078 ._spin_lock_irqsave+0x98/0xf0
> [c000000058eab370] c00000000008011c .tg_shares_up+0x10c/0x20c
> [c000000058eab430] c00000000007867c .walk_tg_tree+0xc4/0xfc
> [c000000058eab4d0] c0000000000840c8 .try_to_wake_up+0xb0/0x3c4
> [c000000058eab590] c0000000000799a0 .__wake_up_common+0x6c/0xe0
> [c000000058eab640] c00000000007ada4 .complete+0x54/0x80
> [c000000058eab6e0] c000000000509fa8 .migration_call+0x5fc/0x6f8
> [c000000058eab7c0] c000000000504074 .notifier_call_chain+0x68/0xe0
> [c000000058eab860] c000000000506568 ._cpu_down+0x2b0/0x3f4
> [c000000058eaba60] c000000000506750 .cpu_down+0xa4/0x108
> [c000000058eabb10] c000000000507e54 .store_online+0x44/0xa8
> [c000000058eabba0] c000000000396260 .sysdev_store+0x3c/0x50
> [c000000058eabc10] c0000000001a39b8 .sysfs_write_file+0x124/0x18c
> [c000000058eabcd0] c00000000013061c .vfs_write+0xd0/0x1bc
> [c000000058eabd70] c0000000001308a4 .sys_write+0x68/0x114
> [c000000058eabe30] c0000000000086b4 syscall_exit+0x0/0x40
> 
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
> ---
> 
>  kernel/sched.c |    2 ++
>  1 file changed, 2 insertions(+)

good catch - applied to tip/sched/urgent, thanks Brian!

	Ingo

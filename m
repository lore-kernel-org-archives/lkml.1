Return-Path: <linux-kernel-owner+w=401wt.eu-S1753408AbYKFHGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbYKFHGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 02:06:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbYKFHGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 02:06:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34922 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456AbYKFHGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 02:06:46 -0500
Date: Thu, 6 Nov 2008 08:06:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, suresh.b.siddha@intel.com,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH] sched: fix a bug in sched domain degenerate
Message-ID: <20081106070636.GG15731@elte.hu>
References: <49124C2C.9080300@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49124C2C.9080300@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> (1) on i386 with SCHED_SMT and SCHED_MC enabled
> 	# mount -t cgroup -o cpuset xxx /mnt
> 	# echo 0 > /mnt/cpuset.sched_load_balance
> 	# mkdir /mnt/0
> 	# echo 0 > /mnt/0/cpuset.cpus
> 	# dmesg
> 	CPU0 attaching sched-domain:
> 	 domain 0: span 0 level CPU
> 	  groups: 0
> 
> (2) on i386 with SCHED_MC enabled but SCHED_SMT disabled
> 	# same with (1)
> 	# dmesg
> 	CPU0 attaching NULL sched-domain.
> 
> The bug is some sched domains may be skipped unintentionally when
> doing sched domain degenerating.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/sched.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)

applied to tip/sched/urgent, thanks!

	Ingo

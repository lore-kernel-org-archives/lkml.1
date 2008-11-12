Return-Path: <linux-kernel-owner+w=401wt.eu-S1752701AbYKLLfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701AbYKLLfe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 06:35:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751640AbYKLLf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 06:35:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58418 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525AbYKLLf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 06:35:26 -0500
Date: Wed, 12 Nov 2008 12:35:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Vaidyanathan S <svaidyan@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: Re: [PATCH][mmotm] Sched fix stale value in average load per task
Message-ID: <20081112113514.GB6372@elte.hu>
References: <20081112104900.GA13896@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081112104900.GA13896@balbir.in.ibm.com>
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


* Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> cpu_avg_load_per_task() returns a stale value when nr_running is 0. 
> It returns an older stale (caculated when nr_running was non zero) 
> value. This patch returns and sets rq->avg_load_per_task to zero 
> when nr_running is 0.
> 
> Compile and boot tested on a x86_64 box.
> 
> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> ---
> 
>  kernel/sched.c |    2 ++
>  1 file changed, 2 insertions(+)

applied to tip/sched/urgent, thanks Balbir!

i'm wondering, have you observed load-balancer misbehavior due to this 
load-average imprecision bug, on some workload? (or have you found 
this via code review)

	Ingo

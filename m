Return-Path: <linux-kernel-owner+w=401wt.eu-S1753946AbZCKJsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbZCKJsR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 05:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbZCKJsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 05:48:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36834 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676AbZCKJsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 05:48:00 -0400
Date: Wed, 11 Mar 2009 10:47:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Menage <menage@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpuacct: reduce one NULL check in fast-path
Message-ID: <20090311094744.GB13543@elte.hu>
References: <49B71EB5.1030608@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B71EB5.1030608@cn.fujitsu.com>
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


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> In cpuacct_charge(), task_ca() will never return NULL, so change
> for(...) to do{}while(...) to save one NULL check.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/sched.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 9bb6d24..bc8a91e 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -9768,10 +9768,11 @@ static void cpuacct_charge(struct task_struct *tsk, u64 cputime)
>  	cpu = task_cpu(tsk);
>  	ca = task_ca(tsk);
>  
> -	for (; ca; ca = ca->parent) {
> +	do {
>  		u64 *cpuusage = percpu_ptr(ca->cpuusage, cpu);
>  		*cpuusage += cputime;
> -	}
> +		ca = ca->parent;
> +	} while (ca);

This patch does not apply cleanly to the latest scheduler tree:

 http://people.redhat.com/mingo/tip.git/README

	Ingo

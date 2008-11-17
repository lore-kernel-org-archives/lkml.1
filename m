Return-Path: <linux-kernel-owner+w=401wt.eu-S1752827AbYKQPzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbYKQPzR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 10:55:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751980AbYKQPzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 10:55:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41304 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbYKQPzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 10:55:03 -0500
Date: Mon, 17 Nov 2008 16:54:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, Doug Chapman <doug.chapman@hp.com>,
       Frank Mayhar <fmayhar@google.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] account_steal_time: kill the unneeded
	account_group_system_time()
Message-ID: <20081117155425.GB12081@elte.hu>
References: <20081117143952.GA5367@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081117143952.GA5367@redhat.com>
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


* Oleg Nesterov <oleg@redhat.com> wrote:

> I don't actually understand account_steal_time() and I failed to find the
> commit which added account_group_system_time(), but this looks bogus.
> In any case rq->idle must be single-threaded, so it can't have ->totals.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> 
> --- K-28/kernel/sched.c~ACCT_STEAL_KILL_GACCT	2008-11-10 13:05:09.000000000 +0100
> +++ K-28/kernel/sched.c	2008-11-16 23:40:05.000000000 +0100
> @@ -4198,7 +4198,6 @@ void account_steal_time(struct task_stru
>  
>  	if (p == rq->idle) {
>  		p->stime = cputime_add(p->stime, steal);
> -		account_group_system_time(p, steal);
>  		if (atomic_read(&rq->nr_iowait) > 0)
>  			cpustat->iowait = cputime64_add(cpustat->iowait, tmp);

could be a typo - is there no similar construct nearby?

Makes sense in any case, applied to tip/core/signal - thanks Oleg.

	Ingo

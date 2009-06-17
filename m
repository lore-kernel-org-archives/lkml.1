Return-Path: <linux-kernel-owner+w=401wt.eu-S1758341AbZFQQbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758341AbZFQQbo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 12:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757503AbZFQQbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 12:31:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39596 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754619AbZFQQbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 12:31:23 -0400
Date: Wed, 17 Jun 2009 18:31:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       mitake@dcl.info.waseda.ac.jp, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/urgent] sched: Hide runqueues from direct refer at
	source code level
Message-ID: <20090617163111.GA16128@elte.hu>
References: <20090617.222055.374768827975756908.mitake@dcl.info.waseda.ac.jp> <tip-d11ad9b3631b942b0d2e5b754a6c62158efb799f@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-d11ad9b3631b942b0d2e5b754a6c62158efb799f@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0037]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:

> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -6630,7 +6630,7 @@ EXPORT_SYMBOL(yield);
>   */
>  void __sched io_schedule(void)
>  {
> -	struct rq *rq = &__raw_get_cpu_var(runqueues);
> +	struct rq *rq = this_rq();
>  
>  	delayacct_blkio_start();
>  	atomic_inc(&rq->nr_iowait);
> @@ -6642,7 +6642,7 @@ EXPORT_SYMBOL(io_schedule);
>  
>  long __sched io_schedule_timeout(long timeout)
>  {
> -	struct rq *rq = &__raw_get_cpu_var(runqueues);
> +	struct rq *rq = this_rq();
>  	long ret;

I removed these two changes. Did you notice the __raw prefix?

	Ingo

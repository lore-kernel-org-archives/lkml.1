Return-Path: <linux-kernel-owner+w=401wt.eu-S1753069AbYKSHxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069AbYKSHxl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 02:53:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751210AbYKSHxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 02:53:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41519 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbYKSHxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 02:53:31 -0500
Date: Wed, 19 Nov 2008 08:53:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ken Chen <kenchen@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] sched: add locking when update the task_group's
	cfs_rq[] array.
Message-ID: <20081119075319.GA1078@elte.hu>
References: <b040c32a0811182248s1174c82avf44c720ae2d14804@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b040c32a0811182248s1174c82avf44c720ae2d14804@mail.gmail.com>
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


* Ken Chen <kenchen@google.com> wrote:

> @@ -1513,8 +1513,12 @@ static int tg_shares_up
>  	unsigned long weight, rq_weight = 0;
>  	unsigned long shares = 0;
>  	struct sched_domain *sd = data;
> +	unsigned long flags;
>  	int i;
> 
> +	if (!spin_trylock_irqsave(&tg->tg_lock, flags))
> +		return 0;

hm, why trylock?

	Ingo

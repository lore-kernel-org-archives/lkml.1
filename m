Return-Path: <linux-kernel-owner+w=401wt.eu-S1752216AbZKHLxD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216AbZKHLxD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 06:53:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbZKHLxC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 06:53:02 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47446 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470AbZKHLxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 06:53:01 -0500
Date: Sun, 8 Nov 2009 12:52:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ralf R??sch <ralf.roesch@rw-gmbh.de>
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org, hpa@zytor.com,
       mingo@redhat.com, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: sched: fix for non SMP systems in sched.h
Message-ID: <20091108115256.GR11372@elte.hu>
References: <4AEAF987.2080809@rw-gmbh.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AEAF987.2080809@rw-gmbh.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Ralf R??sch <ralf.roesch@rw-gmbh.de> wrote:

> commit d65d153bc23b84e4709a49137a9a03ae139d51a0 introduced
> two new prototypes: default_scale_freq_power and default_scale_smt_power.
> Both of them use struct sched_domain which is not defined on non SMP
> systems.
> Just moved the prototypes to the correct place.
> 
> Signed-off-by: Ralf Roesch <ralf.roesch@rw-gmbh.de>
> ---
> include/linux/sched.h |    7 +++----
> 1 files changed, 3 insertions(+), 4 deletions(-)
> mode change 100644 => 100755 include/linux/sched.h
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> old mode 100644
> new mode 100755
> index c231a24..b633308
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1036,6 +1036,9 @@ static inline int test_sd_parent(struct
> sched_domain *sd, int flag)
>     return 0;
> }
> 
> +unsigned long default_scale_freq_power(struct sched_domain *sd, int cpu);
> +unsigned long default_scale_smt_power(struct sched_domain *sd, int cpu);
> +
> #else /* CONFIG_SMP */
> 
> struct sched_domain_attr;
> @@ -1047,10 +1050,6 @@ partition_sched_domains(int ndoms_new, struct
> cpumask *doms_new,
> }
> #endif    /* !CONFIG_SMP */
> 
> -
> -unsigned long default_scale_freq_power(struct sched_domain *sd, int cpu);
> -unsigned long default_scale_smt_power(struct sched_domain *sd, int cpu);
> -
> struct io_context;            /* See blkdev.h */

FYI, your patch has tabs converted to spaces (and line-wrap problems), 
so it wont apply cleanly.

See Documentation/email-clients.txt about how to send patches without
such problems.

Thanks,

	Ingo

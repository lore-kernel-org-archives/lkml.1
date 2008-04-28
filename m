Return-Path: <linux-kernel-owner+w=401wt.eu-S932431AbYD1HZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431AbYD1HZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 03:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765220AbYD1HZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 03:25:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37373 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763654AbYD1HZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 03:25:18 -0400
Date: Mon, 28 Apr 2008 09:24:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>, Paul Jackson <pj@sgi.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] sched: missing locking in sched_domains code
Message-ID: <20080428072456.GA26944@elte.hu>
References: <20080427211224.GA21830@osiris.boeblingen.de.ibm.com> <20080427183926.acb66fff.akpm@linux-foundation.org> <20080428070946.GA4507@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428070946.GA4507@osiris.boeblingen.de.ibm.com>
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


* Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

>  
>  /*
> + * Protects against concurrent calls to detach_destroy_domains
> + * and arch_init_sched_domains.
> + */
> +static DEFINE_MUTEX(sched_domains_mutex);
> +
> +/*
>   * Partition sched domains as specified by the 'ndoms_new'
>   * cpumasks in the array doms_new[] of cpumasks. This compares
>   * doms_new[] to the current sched domain partitioning, doms_cur[].
> @@ -7756,7 +7762,8 @@ void partition_sched_domains(int ndoms_n
>  	int i, j;
>  
>  	lock_doms_cur();
> -
> +	mutex_lock(&sched_domains_mutex);

i might be missing something but why not make doms_cur_mutex locking 
unconditional and extend it to detach_destroy_domains() as well?

	Ingo

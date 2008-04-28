Return-Path: <linux-kernel-owner+w=401wt.eu-S932639AbYD1Icv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932639AbYD1Icv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 04:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765924AbYD1Icn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 04:32:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44836 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765860AbYD1Icn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 04:32:43 -0400
Date: Mon, 28 Apr 2008 10:32:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>, Paul Jackson <pj@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: missing locking in sched_domains code
Message-ID: <20080428083222.GA16963@elte.hu>
References: <20080427211224.GA21830@osiris.boeblingen.de.ibm.com> <20080427183926.acb66fff.akpm@linux-foundation.org> <20080428070946.GA4507@osiris.boeblingen.de.ibm.com> <20080428002853.1693e7fd.akpm@linux-foundation.org> <20080428075253.GB4507@osiris.boeblingen.de.ibm.com> <20080428081129.GC4507@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428081129.GC4507@osiris.boeblingen.de.ibm.com>
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

>  /* doms_cur_mutex serializes access to doms_cur[] array */
>  static DEFINE_MUTEX(doms_cur_mutex);
>  
> +static inline void lock_doms_cur(void)
> +{
> +	mutex_lock(&doms_cur_mutex);
> +}

> @@ -7813,8 +7811,10 @@ int arch_reinit_sched_domains(void)
>  	int err;
>  
>  	get_online_cpus();
> +	lock_doms_cur();

thanks, that looks a lot more clean already. May i ask for another 
thing, if you are hacking on this anyway? Please get rid of the 
lock_doms_cur() complication now that it's not conditional - an open 
coded mutex_lock(&sched_doms_mutex) looks more readable - it gives a 
clear idea about what's happening. Also, please rename sched_doms_mutex 
to something less tongue-twisting - such as sched_domains_mutex. Hm?

	Ingo

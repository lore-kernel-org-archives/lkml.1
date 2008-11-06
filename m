Return-Path: <linux-kernel-owner+w=401wt.eu-S1754599AbYKFG6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbYKFG6c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 01:58:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753408AbYKFG6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 01:58:16 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49997 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753364AbYKFG6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 01:58:15 -0500
Date: Thu, 6 Nov 2008 07:57:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcupdate: move synchronize_sched() back to rcupdate.c
	V2
Message-ID: <20081106065751.GD15731@elte.hu>
References: <49129310.5000903@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49129310.5000903@cn.fujitsu.com>
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


* Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> this fix remove ugly macro, and increase readability for rcupdate codes

looks good to me, if Paul acks the concept too.

Two small details:

> +++ b/include/linux/rcuclassic.h
> @@ -32,6 +32,7 @@
>  
>  #ifndef __LINUX_RCUCLASSIC_H
>  #define __LINUX_RCUCLASSIC_H
> +#define HAVE_SPECIAL_RCU_BH

please use def_bool to define CONFIG_RCU_HAVE_SPECIAL_RCU_BH

and:

> +#else
> +#define rcu_bh_qsctr_inc(cpu)
> +#define rcu_read_lock_bh()	{ rcu_read_lock(); local_bh_disable(); }
> +#define rcu_read_unlock_bh()	{ local_bh_enable(); rcu_read_unlock(); }
> +#endif /* HAVE_SPECIAL_RCU_BH */

use inline functions please. CPP defines should never be used in new 
code. (use inlines instead of macros and enums/const instead of 
constant #define's)

	Ingo

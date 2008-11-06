Return-Path: <linux-kernel-owner+w=401wt.eu-S1753834AbYKFIBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbYKFIBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 03:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752963AbYKFIBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 03:01:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54313 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbYKFIBC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 03:01:02 -0500
Date: Thu, 6 Nov 2008 09:00:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: rewrite SCHED_CPUMASK_ALLOC
Message-ID: <20081106080057.GF8459@elte.hu>
References: <4911341C.7020207@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4911341C.7020207@cn.fujitsu.com>
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

>  #if	NR_CPUS > 128
> -#define	SCHED_CPUMASK_ALLOC		1
> -#define	SCHED_CPUMASK_FREE(v)		kfree(v)
> -#define	SCHED_CPUMASK_DECLARE(v)	struct allmasks *v
> +#define SCHED_CPUMASK_DECLARE(v)	struct allmasks *v
> +#define SCHED_CPUMASK_ALLOC(v)		v = kmalloc(sizeof(*v), GFP_KERNEL)
> +#define SCHED_CPUMASK_FREE(v)		kfree(v)
>  #else
> -#define	SCHED_CPUMASK_ALLOC		0
> -#define	SCHED_CPUMASK_FREE(v)
> -#define	SCHED_CPUMASK_DECLARE(v)	struct allmasks _v, *v = &_v
> +#define SCHED_CPUMASK_DECLARE(v)	struct allmasks _v, *v = &_v
> +#define SCHED_CPUMASK_ALLOC(v)
> +#define SCHED_CPUMASK_FREE(v)
>  #endif

ok, the #ifdef removal is nice, but we can make it even cleaner: 
please just change it to a sched_cpumask_alloc() inline. That way 
SCHED_CPUMASK_DECLARE() can go away as well: just declare the 
variable, it will be unused in the <128 CPUs case.

	Ingo

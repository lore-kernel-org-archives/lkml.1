Return-Path: <linux-kernel-owner+w=401wt.eu-S1757251AbXKAI6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251AbXKAI6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 04:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbXKAI6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 04:58:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51041 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753347AbXKAI6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 04:58:37 -0400
Date: Thu, 1 Nov 2007 09:58:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: aim7 -30% regression in 2.6.24-rc1
Message-ID: <20071101085824.GA12721@elte.hu>
References: <1193391787.3019.174.camel@ymzhang> <20071026112307.GA30406@elte.hu> <1193624538.3019.189.camel@ymzhang> <1193650626.3019.198.camel@ymzhang> <1193710325.3019.203.camel@ymzhang> <20071030072658.GB20372@elte.hu> <1193733390.3019.210.camel@ymzhang> <1193824668.3019.236.camel@ymzhang> <1193826639.27652.113.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193826639.27652.113.camel@twins>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

>  static int one_hundred = 100;
> +static int int_max = INT_MAX;
>  
>  /* this is needed for the proc_dointvec_minmax for [fs_]overflow UID and GID */
>  static int maxolduid = 65535;
> @@ -239,7 +240,10 @@ static struct ctl_table kern_table[] = {
>  		.data		= &sysctl_sched_nr_latency,
>  		.maxlen		= sizeof(unsigned int),
>  		.mode		= 0644,
> -		.proc_handler	= &proc_dointvec,
> +		.proc_handler	= &proc_dointvec_minmax,
> +		.strategy	= &sysctl_intvec,
> +		.extra1		= &one,
> +		.extra2		= &int_max,

could we instead justmake sched_nr_latency non-tunable, and recalculate 
it from the sysctl handler whenever sched_latency or 
sched_min_granularity changes? That would avoid not only the division by 
zero bug but also other out-of-spec tunings.

	Ingo

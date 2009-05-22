Return-Path: <linux-kernel-owner+w=401wt.eu-S1758267AbZEVTZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267AbZEVTZg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 15:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756760AbZEVTZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 15:25:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50685 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755165AbZEVTZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 15:25:28 -0400
Date: Fri, 22 May 2009 21:25:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>
Subject: Re: [PATCH] perf_counter: do not create perf counter mlock sysctl
	when CONFIG_PERF_COUNTERS=n
Message-ID: <20090522192510.GB18651@elte.hu>
References: <1242985373.22654.225.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242985373.22654.225.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Ian Campbell <Ian.Campbell@citrix.com> wrote:

> Building tip from 82811bee3 without CONFIG_PERF_COUNTERS results in:
> 
>   CC      kernel/sysctl.o
> kernel/sysctl.c:928: error: 'sysctl_perf_counter_mlock' undeclared here (not in a function)
> 
> This is due to c5078f78b "perf_counter: provide an mlock threshold"
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 44ebd90..c2a4467 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -922,6 +922,7 @@ static struct ctl_table kern_table[] = {
>  		.child		= slow_work_sysctls,
>  	},
>  #endif
> +#ifdef CONFIG_PERF_COUNTERS
>  	{
>  		.ctl_name	= CTL_UNNUMBERED,
>  		.procname	= "perf_counter_mlock_kb",
> @@ -930,6 +931,7 @@ static struct ctl_table kern_table[] = {
>  		.mode		= 0644,
>  		.proc_handler	= &proc_dointvec,
>  	},
> +#endif
>  /*
>   * NOTE: do not add new entries to this table unless you have read
>   * Documentation/sysctl/ctl_unnumbered.txt

Hm, is this still needed? It doesnt apply here and i'm not seeing 
build failures.

Thanks,

	Ingo

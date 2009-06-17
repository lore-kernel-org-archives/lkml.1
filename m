Return-Path: <linux-kernel-owner+w=401wt.eu-S1755095AbZFQOyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095AbZFQOyO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 10:54:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752310AbZFQOx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 10:53:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58981 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796AbZFQOxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 10:53:55 -0400
Date: Wed, 17 Jun 2009 16:53:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, Li Zefan <lizf@cn.fujitsu.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH RFC] softirq: fix ksoftirq starved
Message-ID: <20090617145333.GD6846@elte.hu>
References: <20090511151353.GA14391@Krystal> <4A094677.5090900@cn.fujitsu.com> <4A0BF82A.2070208@cn.fujitsu.com> <20090514124013.GC21241@Krystal> <alpine.DEB.2.00.0905140926010.30591@gandalf.stny.rr.com> <4A0CCB2E.10202@cn.fujitsu.com> <6A70E08D65F749FA92475F8BA1F9510D@zhaoleiwin> <20090519082435.GB15286@elte.hu> <4A31BF1D.1050400@cn.fujitsu.com> <4A32251C.8060001@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A32251C.8060001@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -5307,6 +5307,7 @@ need_resched:
>  	release_kernel_lock(prev);
>  need_resched_nonpreemptible:
>  
> +	schedule_softirq_check();
>  	schedule_debug(prev);

hm, this slows down the scheduler fast-path ...

	Ingo

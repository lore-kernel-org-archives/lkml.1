Return-Path: <linux-kernel-owner+w=401wt.eu-S1755149AbZELK1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbZELK1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 06:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbZELK1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 06:27:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50899 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbZELK1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 06:27:44 -0400
Date: Tue, 12 May 2009 12:27:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
       balajirrao@gmail.com, dhaval@linux.vnet.ibm.com,
       balbir@linux.vnet.ibm.com, bharata@linux.vnet.ibm.com,
       tglx@linutronix.de, kamezawa.hiroyu@jp.fujitsu.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched: cpuacct: Use bigger percpu counter
	batch values for stats counters
Message-ID: <20090512102722.GA11714@elte.hu>
References: <1242122579.11251.325.camel@twins> <20090512190346.D638.A69D9226@jp.fujitsu.com> <20090512191650.D63E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090512191650.D63E.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > > On Tue, 2009-05-12 at 19:01 +0900, KOSAKI Motohiro wrote:
> > > > +#ifdef CONFIGCONFIG_SMP
> > > 
> > > typo ?
> > 
> > yes, this week is my memorial stupid one ;)
> 
> ok, assemble list indicate current patch have no typo ;)
> 
> ffffffff814ae920:       48 c7 40 30 10 eb 2a    movq   $0xffffffff812aeb10,0x30(%rax)
> ffffffff814ae927:       81
> ffffffff814ae928:       c7 05 3e 37 fe ff 01    movl   $0x1,-0x1c8c2(%rip)        # ffffffff81492070 <scheduler_running>
> ffffffff814ae92f:       00 00 00
> ffffffff814ae932:       8b 05 28 52 fe ff       mov    -0x1add8(%rip),%eax        # ffffffff81493b60 <percpu_counter_batch>
> ffffffff814ae938:       89 05 36 37 fe ff       mov    %eax,-0x1c8ca(%rip)        # ffffffff81492074 <cpuacct_batch>
> ffffffff814ae93e:       41 5c                   pop    %r12
> 
> 
> 
> ---------------------------------------------------------
> Subject: [PATCH] cpuacct: Use bigger percpu counter batch values for stats counters on archs that have VIRT_CPU_ACCOUNTING=y
> 
> percpu counters used to accumulate statistics in cpuacct controller use
> the default batch value [max(2*nr_cpus, 32)] which can be too small for
> archs that define VIRT_CPU_ACCOUNTING. In such archs, a tick could result in
> cputime updates in the range of thousands. As a result, cpuacct_update_stats()
> would end up acquiring the percpu counter spinlock on every tick which
> is not good for performance.
> 
> Let those architectures to have a bigger batch threshold so that percpu counter
> spinlock isn't taken on every tick. This change doesn't affect the archs which
> don't define VIRT_CPU_ACCOUNTING and they continue to have the default
> percpu counter batch value.
> 
> Cc: Balaji Rao <balajirrao@gmail.com>
> Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  kernel/sched.c |    9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)

Please reuse the commit log formatting fixes i did when i applied 
your patch. (you should still have that commit notification email)

	Ingo

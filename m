Return-Path: <linux-kernel-owner+w=401wt.eu-S1759944AbXGZHfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759944AbXGZHfs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 03:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756579AbXGZHfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 03:35:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57043 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753826AbXGZHfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 03:35:38 -0400
Date: Thu, 26 Jul 2007 09:35:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ankita Garg <ankita@in.ibm.com>
Cc: Arjan van de Ven <arjan@infradead.org>, linux@bohmer.net,
       LKML <linux-kernel@vger.kernel.org>,
       RT-Users <linux-rt-users@vger.kernel.org>, mathieu.desnoyers@polymtl.ca
Subject: Re: [Question] Hooks for scheduler tracing (CFS)
Message-ID: <20070726073520.GA12206@elte.hu>
References: <3efb10970707161246se06ab22i32872cfe6fa4f2f6@mail.gmail.com> <1184615557.2698.3.camel@laptopd505.fenrus.org> <20070726072858.GC13061@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070726072858.GC13061@in.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ankita Garg <ankita@in.ibm.com> wrote:

> The probe point did get triggered, and soon after that I had the 
> following in dmesg, leading to system hang...
> 
> BUG: scheduling while atomic: softirq-rcu/3/0x00000004/52, CPU#3
> 
> Call Trace:
>  <#DB>  [<ffffffff81033555>] __schedule_bug+0x4b/0x4f
>  [<ffffffff8128b414>] __sched_text_start+0xcc/0xaaa
>  [<ffffffff8100b574>] dump_trace+0x248/0x25d
>  [<ffffffff81068334>] print_traces+0x9/0xb
>  [<ffffffff8100b5e5>] show_trace+0x5c/0x64
>  [<ffffffff8128c1c2>] schedule+0xe4/0x104
>  [<ffffffff8128d10c>] rt_spin_lock_slowlock+0xfc/0x19e
>  [<ffffffff8128d9de>] __rt_spin_lock+0x1f/0x21
>  [<ffffffff8128d9e9>] rt_spin_lock+0x9/0xb
>  [<ffffffff88387dcc>]
> :stap_c1a10b1292b5f87a563f56d89ddfc765_606:_stp_print_flush+0x5f/0xdf
>  [<ffffffff88389e41>]
> :stap_c1a10b1292b5f87a563f56d89ddfc765_606:probe_1493+0x1f6/0x257
>  [<ffffffff8838bdc3>]

I'd suggest to not put a probe into a preempt-off section - put it to 
the beginning and to the end of schedule() to capture context-switches. 
_stp_print_flush() is in the systemtap-generated module, right? Maybe 
the problem is resolved by changing that spinlock to use raw_spinlock_t 
/ DEFINE_RAW_SPIN_LOCK.


	Ingo

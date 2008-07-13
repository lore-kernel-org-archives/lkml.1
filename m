Return-Path: <linux-kernel-owner+w=401wt.eu-S1755541AbYGMVEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541AbYGMVEp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 17:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755957AbYGMVE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 17:04:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33211 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755887AbYGMVE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 17:04:28 -0400
Date: Sun, 13 Jul 2008 23:04:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Mike Travis <travis@sgi.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: per-cpu related?
Message-ID: <20080713210413.GB12362@elte.hu>
References: <86802c440807130116u3b850485jec220bc15892873e@mail.gmail.com> <19f34abd0807130455w516d73cfi80161c345564464@mail.gmail.com> <86802c440807131134i351f967dh3a2b94d687c767ee@mail.gmail.com> <20080713185502.GA17644@elte.hu> <86802c440807131401o21d016d0i37e6e4f9cad6bc2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807131401o21d016d0i37e6e4f9cad6bc2@mail.gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> On Sun, Jul 13, 2008 at 11:55 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> >
> >> thanks
> >>
> >> could be caused by max_low_pfn_mapped patch...because hpet still use
> >> fixmap address that is cleared by others.
> 
> still got
> 
> calling  __stack_chk_test+0x0/0x89
> Testing -fstack-protector-all feature
> -fstack-protector-all test failed
> ------------[ cut here ]------------
> WARNING: at kernel/panic.c:393 __stack_chk_test+0x61/0x89()
> Modules linked in:
> Pid: 1, comm: swapper Not tainted 2.6.26-rc9-tip-01873-ga9827e7-dirty #359
> 
> Call Trace:
>  [<ffffffff8026615e>] warn_on_slowpath+0x6c/0xa7
>  [<ffffffff80266199>] ? __stack_chk_test+0x0/0x89
>  [<ffffffff80266199>] ? __stack_chk_test+0x0/0x89
>  [<ffffffff8022a4f4>] ? mcount_call+0x5/0x31
>  [<ffffffff80266199>] ? __stack_chk_test+0x0/0x89
>  [<ffffffff802661fa>] __stack_chk_test+0x61/0x89
>  [<ffffffff80e729e4>] kernel_init+0x1de/0x346
>  [<ffffffff8022a4f4>] ? mcount_call+0x5/0x31
>  [<ffffffff80262df7>] ? finish_task_switch+0x14/0xe3
>  [<ffffffff8022b589>] child_rip+0xa/0x11
>  [<ffffffff80e72806>] ? kernel_init+0x0/0x346
>  [<ffffffff8022b57f>] ? child_rip+0x0/0x11
> 
> ---[ end trace 0f276ea63a4e83de ]---

please try latest tip/master - the self-test had to be removed. (gcc 
will treat the stackprotector-failure function as ((noreturn)) attribute 
and will optimize out the return path, making a reliable self-test 
impossible in the way we tried to)

	Ingo

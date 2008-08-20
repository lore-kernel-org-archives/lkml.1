Return-Path: <linux-kernel-owner+w=401wt.eu-S1756437AbYHTMnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437AbYHTMnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 08:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbYHTMnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 08:43:07 -0400
Received: from viefep31-int.chello.at ([62.179.121.49]:58674 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468AbYHTMnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 08:43:06 -0400
Subject: Re: [PATCH] printk: robustify printk
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, tglx@linutronix.de,
       marcin.slusarz@gmail.com, linux-kernel@vger.kernel.org,
       davem@davemloft.net, rostedt@goodmis.org, paulmck@linux.vnet.ibm.com
In-Reply-To: <Pine.LNX.4.64.0808201438490.18947@twin.jikos.cz>
References: <1218215454.8625.133.camel@twins>
	 <alpine.LFD.1.10.0808081014240.3462@nehalem.linux-foundation.org>
	 <1218217257.29098.2.camel@lappy.programming.kicks-ass.net>
	 <alpine.LFD.1.10.0808081043160.3462@nehalem.linux-foundation.org>
	 <1218219269.29098.5.camel@lappy.programming.kicks-ass.net>
	 <20080808121428.646a8b3c.akpm@linux-foundation.org>
	 <1218223269.29098.12.camel@lappy.programming.kicks-ass.net>
	 <1218224829.29098.19.camel@lappy.programming.kicks-ass.net>
	 <20080811104526.GA15186@elte.hu> <1218452640.10800.58.camel@twins>
	 <20080811115109.GB23529@elte.hu>
	 <Pine.LNX.4.64.0808201438490.18947@twin.jikos.cz>
Content-Type: text/plain
Date: Wed, 20 Aug 2008 14:43:01 +0200
Message-Id: <1219236181.8651.46.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-20 at 14:40 +0200, Jiri Kosina wrote:
> On Mon, 11 Aug 2008, Ingo Molnar wrote:
> 
> > ----------------->
> > >From b845b517b5e3706a3729f6ea83b88ab85f0725b0 Mon Sep 17 00:00:00 2001
> > From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Date: Fri, 8 Aug 2008 21:47:09 +0200
> > Subject: [PATCH] printk: robustify printk
> > 
> > Avoid deadlocks against rq->lock and xtime_lock by deferring the klogd
> > wakeup by polling from the timer tick.
> > 
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> Then I think we also want the patch below on top of that, right?

Indeed, Thanks!

> 
> From: Jiri Kosina <jkosina@suse.cz>
> printk: robustify printk, fix #3
> 
> Remove the comment describing the possibility of printk() deadlocking on 
> runqueue lock.
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> --- 
> 
>  kernel/printk.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/printk.c b/kernel/printk.c
> index b51b156..9fbf391 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -577,9 +577,6 @@ static int have_callable_console(void)
>   * @fmt: format string
>   *
>   * This is printk().  It can be called from any context.  We want it to work.
> - * Be aware of the fact that if oops_in_progress is not set, we might try to
> - * wake klogd up which could deadlock on runqueue lock if printk() is called
> - * from scheduler code.
>   *
>   * We try to grab the console_sem.  If we succeed, it's easy - we log the output and
>   * call the console drivers.  If we fail to get the semaphore we place the output


Return-Path: <linux-kernel-owner+w=401wt.eu-S1760684AbXEWFlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760684AbXEWFlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 01:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759985AbXEWFl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 01:41:27 -0400
Received: from d061844a.dreamhost.com ([208.97.132.74]:49770 "EHLO
	spaceymail-a4.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756275AbXEWFl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 01:41:26 -0400
From: Anant Nitya <kernel@prachanda.info>
Organization: Prachanda Hub
To: linux-kernel@vger.kernel.org
Subject: Re: bad networking related lag in v2.6.22-rc2
Date: Wed, 23 May 2007 11:10:43 +0530
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>, Patrick McHardy <kaber@trash.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "David S. Miller" <davem@davemloft.net>
References: <20070517174533.GA538@elte.hu> <200705221147.56571.kernel@prachanda.hub> <20070522062233.GA20002@elte.hu>
In-Reply-To: <20070522062233.GA20002@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705231110.44526.kernel@prachanda.hub>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 May 2007 11:52:33 Ingo Molnar wrote:
> * Anant Nitya <kernel@prachanda.info> wrote:
> > > I think I already found the bug, please try if this patch helps.
> >
> > Sorry, but this patch is not helping here. I recompiled the kernel
> > with this patch but same load pattern still make system to crawl.
> >
> > Here is the link for script I use to shape traffic.
> >
> > http://cybertek.info/taitai/adslbwopt.sh
>
> could you also apply the fix for the softirq problem below, to make sure
> it does not interact?
>
> 	Ingo
>
> Index: linux/kernel/sched.c
> ===================================================================
> --- linux.orig/kernel/sched.c
> +++ linux/kernel/sched.c
> @@ -4212,9 +4212,7 @@ int __sched cond_resched_softirq(void)
>  	BUG_ON(!in_softirq());
>
>  	if (need_resched() && system_state == SYSTEM_RUNNING) {
> -		raw_local_irq_disable();
> -		_local_bh_enable();
> -		raw_local_irq_enable();
> +		local_bh_enable();
>  		__cond_resched();
>  		local_bh_disable();
>  		return 1;

Hi Ingo
Above patch does solve __ soft_irq_pending __ problem. I am running this patch 
with kernel 2.6.21.1 since last day doing all kinda things but haven't 
encountered any __ NOHZ: local_softirq_pending __. But network lag that I am 
seeing since 2.6.22-rc1 is still there even with this patch applied. If you 
need any more information please do ask. Meanwhile I will do gitbisect as 
suggested by linus to find out the specific commit that introduced this 
problem and will inform once I find it. Its good to see system running 
without any __ local_softirq_problem __ :)

Regards
Ananitya

-- 
Out of many thousands, one may endeavor for perfection, and of
those who have achieved perfection, hardly one knows Me in truth.
				-- Gita Sutra Of Mysticism

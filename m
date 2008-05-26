Return-Path: <linux-kernel-owner+w=401wt.eu-S1756012AbYEZXEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbYEZXEu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 19:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755507AbYEZXEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 19:04:41 -0400
Received: from simmts12-qfe0.srvr.bell.ca ([206.47.199.141]:59549 "EHLO
	simmts12-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753914AbYEZXEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 19:04:40 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AugAAA/aOkicIsYN/2dsb2JhbAAIiw6hSQ
Message-ID: <483B4205.1030302@gmail.com>
Date: Mon, 26 May 2008 20:04:37 -0300
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Latest Linus git: kernel/sched.c:1216: warning: ?init_hrtick?
 defined but not used
References: <48278762.1080508@gmail.com> <20080513132328.GB5809@elte.hu>
In-Reply-To: <20080513132328.GB5809@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Kevin Winchester <kjwinchester@gmail.com> wrote:
> 
>> Hi Ingo,
>>
>> I got the above warning in my latest build.  I assume it is because 
>> init_hrtick() is only called from CONFIG_SMP sched_init_smp(), and I 
>> have a HRT-enabled UP box.
>>
>> I could write up the simple patch to put #ifdef CONFIG_SMP around 
>> init_hrtick(), but with all of the #ifdefs in that file, I figure it 
>> is probably a little more complicated than that.
> 
> the fix seems simple - see below. The #ifdef jungle ... less so.
> 
> 	Ingo
> 
> --------------->
> Subject: sched: fix defined-but-unused warning
> From: Rabin Vincent <rabin@rab.in>
> Date: Sun, 11 May 2008 05:55:33 +0530
> 
> Fix this warning, which appears with !CONFIG_SMP:
> kernel/sched.c:1216: warning: `init_hrtick' defined but not used
> 
> Signed-off-by: Rabin Vincent <rabin@rab.in>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/sched.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: linux/kernel/sched.c
> ===================================================================
> --- linux.orig/kernel/sched.c
> +++ linux/kernel/sched.c
> @@ -1130,6 +1130,7 @@ static enum hrtimer_restart hrtick(struc
>  	return HRTIMER_NORESTART;
>  }
>  
> +#ifdef CONFIG_SMP
>  static void hotplug_hrtick_disable(int cpu)
>  {
>  	struct rq *rq = cpu_rq(cpu);
> @@ -1185,6 +1186,7 @@ static void init_hrtick(void)
>  {
>  	hotcpu_notifier(hotplug_hrtick, 0);
>  }
> +#endif /* CONFIG_SMP */
>  
>  static void init_rq_hrtick(struct rq *rq)
>  {

Did this ever make it to a pull request?  I still see the warning with 
latest git.

-- 
Kevin Winchester

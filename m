Return-Path: <linux-kernel-owner+w=401wt.eu-S1759598AbYCAOj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759598AbYCAOj1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 09:39:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753857AbYCAOjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 09:39:20 -0500
Received: from mail001.aei.ca ([206.123.6.130]:54560 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753033AbYCAOjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 09:39:19 -0500
/m: spam: 3.2.1
From: Ed Tomlinson <edt@aei.ca>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Panic 2.6.24-3 NMI Watchdog detected LOCKUP on CPU 0
Date: Sat, 1 Mar 2008 09:38:57 -0500
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200803010911.04569.edt@aei.ca> <alpine.LFD.1.00.0803011527410.11084@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.00.0803011527410.11084@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="ansi_x3.4-1968"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803010939.00229.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On March 1, 2008, Thomas Gleixner wrote:
> On Sat, 1 Mar 2008, Ed Tomlinson wrote:
> > Hi,
> > 
> > I have been seeing these since I installed .24 kernels.  It does not seem to matter if I change the clocksource from tsc
> > to apci_pm.  Its happened with all .24 kernels I have tried starting with stock 2.6.24 upto 2.6.24-gentoo-r2 + 2.6.24-3
> > 
> > Ideas?
> 
> Questions first. Is there a particular reason to use idle=poll ?

For another issue Ingo suggested using 'nmi_watchdog=2 idle=poll' to get the nmi_watchdog working.  I can remove it
if you think it will help.

> Idea: does the patch below help ?

I'm rebuilding any will let you know.  It may take a while to trigger.

Thanks for the prompt response!
Ed

> Thanks,
> 	tglx
> 
> ---
> 
>  arch/x86/kernel/process_64.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> Index: linux-2.6.24/arch/x86/kernel/process_64.c
> ===================================================================
> --- linux-2.6.24.orig/arch/x86/kernel/process_64.c
> +++ linux-2.6.24/arch/x86/kernel/process_64.c
> @@ -212,14 +212,13 @@ void cpu_idle (void)
>  	current_thread_info()->status |= TS_POLLING;
>  	/* endless idle loop with no priority at all */
>  	while (1) {
> +		tick_nohz_stop_sched_tick();
>  		while (!need_resched()) {
>  			void (*idle)(void);
>  
>  			if (__get_cpu_var(cpu_idle_state))
>  				__get_cpu_var(cpu_idle_state) = 0;
>  
> -			tick_nohz_stop_sched_tick();
> -
>  			rmb();
>  			idle = pm_idle;
>  			if (!idle)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 



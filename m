Return-Path: <linux-kernel-owner+w=401wt.eu-S1757789AbYJIHeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789AbYJIHeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 03:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755943AbYJIHeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 03:34:07 -0400
Received: from www.tglx.de ([62.245.132.106]:58423 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755635AbYJIHeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 03:34:05 -0400
Date: Thu, 9 Oct 2008 09:24:51 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, rjw@sisk.pl, dipankar@in.ibm.com
Subject: Re: RCU hang on cpu re-hotplug with 2.6.27rc8
In-Reply-To: <20081009045646.GB24560@one.firstfloor.org>
Message-ID: <alpine.LFD.2.00.0810090921320.3237@apollo>
References: <20081006141220.GA14160@basil.nowhere.org> <20081006232837.GA1157@basil.nowhere.org> <20081007030822.GC6820@linux.vnet.ibm.com> <20081007071544.GC20740@one.firstfloor.org> <20081007152629.GH6384@linux.vnet.ibm.com> <20081007154939.GN20740@one.firstfloor.org>
 <20081007163401.GJ6384@linux.vnet.ibm.com> <20081007210947.GP20740@one.firstfloor.org> <20081007212215.GN6384@linux.vnet.ibm.com> <20081009013321.GA11291@linux.vnet.ibm.com> <20081009045646.GB24560@one.firstfloor.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Oct 2008, Andi Kleen wrote:
> It actually does. The stall detector makes the online echo return after three seconds,
> although it's not 100% clear to me why.
> 
> here's the backtrace
> 
> RCU detected CPU 14 stall (t=4295149800/5928 jiffies)
> Pid: 0, comm: swapper Not tainted 2.6.27-rc9 #5
> 
> Call Trace:
>  <IRQ>  [<ffffffff8025d188>] __rcu_pending+0x6e/0x1d9
>  [<ffffffff8025d329>] rcu_pending+0x36/0x6e
>  [<ffffffff8023b480>] update_process_times+0x37/0x5b
>  [<ffffffff8024be72>] tick_periodic+0x68/0x74
>  [<ffffffff8024be9f>] tick_handle_periodic+0x21/0x66
>  [<ffffffff8021bcd2>] smp_apic_timer_interrupt+0x8a/0xa8
>  [<ffffffff8020bfe6>] apic_timer_interrupt+0x66/0x70
>  <EOI>  [<ffffffff803adb39>] ? acpi_safe_halt+0x2b/0x3e
>  [<ffffffff803adbfa>] ? acpi_idle_enter_c1+0xae/0x102
>  [<ffffffff804ffdd6>] ? cpuidle_idle_call+0x70/0xa2
>  [<ffffffff8020a097>] ? cpu_idle+0x7e/0x9c
>  [<ffffffff805bef4a>] ? start_secondary+0x157/0x15c
> 
> Timer issue?

Hmm, this is periodic mode so rather unlikely, but who knows. Does
this happen with nohz and/or highres as well ?

Thanks,

	tglx

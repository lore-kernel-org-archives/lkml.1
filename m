Return-Path: <linux-kernel-owner+w=401wt.eu-S1760656AbYJIEwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760656AbYJIEwl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 00:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759471AbYJIEuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 00:50:35 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35479 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758391AbYJIEud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 00:50:33 -0400
Date: Thu, 9 Oct 2008 06:56:46 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, rjw@sisk.pl, dipankar@in.ibm.com,
       tglx@linutronix.de
Subject: Re: RCU hang on cpu re-hotplug with 2.6.27rc8
Message-ID: <20081009045646.GB24560@one.firstfloor.org>
References: <20081006141220.GA14160@basil.nowhere.org> <20081006232837.GA1157@basil.nowhere.org> <20081007030822.GC6820@linux.vnet.ibm.com> <20081007071544.GC20740@one.firstfloor.org> <20081007152629.GH6384@linux.vnet.ibm.com> <20081007154939.GN20740@one.firstfloor.org> <20081007163401.GJ6384@linux.vnet.ibm.com> <20081007210947.GP20740@one.firstfloor.org> <20081007212215.GN6384@linux.vnet.ibm.com> <20081009013321.GA11291@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081009013321.GA11291@linux.vnet.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[fix up Thomas' address to not bounce]

On Wed, Oct 08, 2008 at 06:33:21PM -0700, Paul E. McKenney wrote:
> The attached patch (similar to one in -tip, but set up for mainline and
> tweaked to make stall-checking on by default) should get you a stack
> trace of any CPUs holding up RCU grace periods for more than about
> three seconds.
> 
> On the off-chance that this helps.

It actually does. The stall detector makes the online echo return after three seconds,
although it's not 100% clear to me why.

here's the backtrace

RCU detected CPU 14 stall (t=4295149800/5928 jiffies)
Pid: 0, comm: swapper Not tainted 2.6.27-rc9 #5

Call Trace:
 <IRQ>  [<ffffffff8025d188>] __rcu_pending+0x6e/0x1d9
 [<ffffffff8025d329>] rcu_pending+0x36/0x6e
 [<ffffffff8023b480>] update_process_times+0x37/0x5b
 [<ffffffff8024be72>] tick_periodic+0x68/0x74
 [<ffffffff8024be9f>] tick_handle_periodic+0x21/0x66
 [<ffffffff8021bcd2>] smp_apic_timer_interrupt+0x8a/0xa8
 [<ffffffff8020bfe6>] apic_timer_interrupt+0x66/0x70
 <EOI>  [<ffffffff803adb39>] ? acpi_safe_halt+0x2b/0x3e
 [<ffffffff803adbfa>] ? acpi_idle_enter_c1+0xae/0x102
 [<ffffffff804ffdd6>] ? cpuidle_idle_call+0x70/0xa2
 [<ffffffff8020a097>] ? cpu_idle+0x7e/0x9c
 [<ffffffff805bef4a>] ? start_secondary+0x157/0x15c

Timer issue?


-Andi

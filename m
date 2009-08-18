Return-Path: <linux-kernel-owner+w=401wt.eu-S1752247AbZHRVEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247AbZHRVEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 17:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbZHRVEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 17:04:44 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:55096 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755AbZHRVEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 17:04:41 -0400
Subject: Re: [ANNOUNCE] 2.6.31-rc6-rt2
From: Will Schmidt <will_schmidt@vnet.ibm.com>
Reply-To: will_schmidt@vnet.ibm.com
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
       Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>
In-Reply-To: <alpine.LFD.2.00.0908162207370.2782@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <alpine.LFD.2.00.0904092046440.21577@localhost.localdomain>
	 <alpine.LFD.2.00.0904110003370.21577@localhost.localdomain>
	 <alpine.LFD.2.00.0904181204420.21577@localhost.localdomain>
	 <alpine.LFD.2.00.0904251500150.4529@localhost.localdomain>
	 <alpine.LFD.2.00.0904290036500.4529@localhost.localdomain>
	 <alpine.LFD.2.00.0905012348200.3375@localhost.localdomain>
	 <alpine.LFD.2.00.0905130122250.3561@localhost.localdomain>
	 <alpine.LFD.2.00.0905221459030.3570@localhost.localdomain>
	 <alpine.LFD.2.00.0906101803210.3367@localhost.localdomain>
	 <alpine.LFD.2.00.0906121800590.3369@localhost.localdomain>
	 <alpine.LFD.2.00.0906151117440.2800@localhost.localdomain>
	 <alpine.LFD.2.00.0906170903370.2800@localhost.localdomain>
	 <alpine.LFD.2.00.0906231418500.2767@localhost.localdomain>
	 <alpine.LFD.2.00.0907092020410.2768@localhost.localdomain>
	 <alpine.LFD.2.00.0907300006250.2936@localhost.localdomain>
	 <alpine.LFD.2.00.0908162207370.2782@localhost.localdomain>
Content-Type: text/plain
Organization: IBM
Date: Tue, 18 Aug 2009 16:04:38 -0500
Message-Id: <1250629478.516.249.camel@lexx>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-08-16 at 22:41 +0200, Thomas Gleixner wrote:
> We are pleased to announce the next update to our new preempt-rt
> series.
> 
>     - update to 2.6.31-rc6
> 
>     - ARM updates (Uwe Kleine-Koenig)
> 
>     - OF fixes
> 
>     - threaded interrupt crash fix (Linus)
> 
>     - locking build fix
> 
>     - minor fixes all over the place
> 
> There is a known boot problem on PSeries machines which is still
> investigated by Will. If you have access to such a beast please help
> to get this decoded.

Some of the data and insight I've gleamed out of my pSeries system. I
don't really have answers, but perhaps a hint that will help someone
else identify the cause, or point me in a particular direction.  :-)


Booting the system seems mostly OK with maxcpus=1, though this INFO
message appears on the console.  (This does repeat after a while..) :

 INFO: task irq/16-IPI:3 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
Call Trace:
[c00000006a3a7a50] [c00000006a3a2b78] 0xc00000006a3a2b78 (unreliable)
[c00000006a3a7c20] [c0000000000123e8] .__switch_to+0x1d4/0x278
[c00000006a3a7cc0] [c000000000470fe8] .__schedule+0x860/0x938
[c00000006a3a7db0] [c0000000004713d4] .schedule+0x2c/0x60
[c00000006a3a7e30] [c000000000092820] .kthread+0x78/0xb4
[c00000006a3a7f90] [c00000000002a618] .kernel_thread+0x54/0x70
INFO: lockdep is turned off.
INFO: task irq/18-RAS_EPOW:155 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
Call Trace:
[c000000068203a50] [c00000006a44ed78] 0xc00000006a44ed78 (unreliable)
[c000000068203c20] [c0000000000123e8] .__switch_to+0x1d4/0x278
[c000000068203cc0] [c000000000470fe8] .__schedule+0x860/0x938
[c000000068203db0] [c0000000004713d4] .schedule+0x2c/0x60
[c000000068203e30] [c000000000092820] .kthread+0x78/0xb4
[c000000068203f90] [c00000000002a618] .kernel_thread+0x54/0x70
INFO: lockdep is turned off.

***************
Then, when I try to online another processor via "echo 1
> /sys/devices/system/cpu/cpu1/online", I get this:

Processor 1 found.
BUG: using smp_processor_id() in preemptible [00000000] code: irq/16-IPI/3
caller is .xics_ipi_action_lpar+0x14/0x68
Call Trace:
[c00000006a3a7bc0] [c00000000001182c] .show_stack+0x70/0x184 (unreliable)
[c00000006a3a7c70] [c00000000029a210] .debug_smp_processor_id+0x1c8/0x250
[c00000006a3a7d10] [c0000000000502cc] .xics_ipi_action_lpar+0x14/0x68
[c00000006a3a7d90] [c0000000000ce0c0] .irq_thread+0x110/0x250
[c00000006a3a7e30] [c000000000092850] .kthread+0xa8/0xb4
[c00000006a3a7f90] [c00000000002a618] .kernel_thread+0x54/0x70
BUG: using smp_processor_id() in preemptible [00000000] code: irq/16-IPI/3
caller is .xics_ipi_action_lpar+0x14/0x68

at which point the system becomes a doorstop with blinkey lights. 

Invoking xmon via system reset reveals:
1:mon> e
cpu 0x1: Vector: 100 (System Reset) at [c00000000fff3c00]
    pc: c00000000004b818: .plpar_hcall_norets+0x10/0x1c
    lr: c000000000050794: .xics_eoi_lpar+0x38/0x68
    sp: c00000000fff3e80
   msr: 8000000000081032
  current = 0xc00000006a3a8140
  paca    = 0xc000000000817400
    pid   = 0, comm = swapper
1:mon> t
[link register   ] c000000000050794 .xics_eoi_lpar+0x38/0x68
[c00000000fff3e80] 0000000000000000 (unreliable)
[c00000000fff3f00] c0000000000cf35c .handle_percpu_irq+0xe0/0x104
[c00000000fff3f90] c00000000002a3b0 .call_handle_irq+0x1c/0x2c
[c0000000e9403aa0] c00000000000e070 .do_IRQ+0x17c/0x224
[c0000000e9403b50] c000000000004814 hardware_interrupt_entry+0x1c/0x20
--- Exception: 501 (Hardware Interrupt) at c00000000000dc70 .raw_local_irq_restore+0x70/0x80
[c0000000e9403e40] c00000000001436c .cpu_idle+0x12c/0x220 (unreliable)
[c0000000e9403ed0] c00000000047e538 .start_secondary+0x370/0x3b0
[c0000000e9403f90] c0000000000082d4 .start_secondary_prolog+0x10/0x14
1:mon> 
1:mon> c0
0:mon> e
cpu 0x0: Vector: 100 (System Reset) at [c00000000fffba70]
    pc: c0000000000a9530: .lock_release+0x274/0x27c
    lr: c0000000000a950c: .lock_release+0x250/0x27c
    sp: c00000000fffbcf0
   msr: 8000000000081032
  current = 0xc00000006a3c85c0
  paca    = 0xc000000000817200
    pid   = 6, comm = sirq-timer/0
0:mon> t
[c00000000fffbcf0] c000000000473e28 ._atomic_spin_unlock_irqrestore+0x2c/0xac (unreliable)
[c00000000fffbd80] c00000000006c020 .try_to_wake_up+0x2d8/0x310
[c00000000fffbe40] c0000000000cc7ec .handle_IRQ_event+0x1ec/0x250
[c00000000fffbf00] c0000000000cf308 .handle_percpu_irq+0x8c/0x104
[c00000000fffbf90] c00000000002a3b0 .call_handle_irq+0x1c/0x2c
[c00000006a3cf510] c00000000000e070 .do_IRQ+0x17c/0x224
[c00000006a3cf5c0] c000000000004814 hardware_interrupt_entry+0x1c/0x20
--- Exception: 501 (Hardware Interrupt) at c00000000000dc70 .raw_local_irq_restore+0x70/0x80
[c00000006a3cf8b0] c000000000473e68 ._atomic_spin_unlock_irqrestore+0x6c/0xac (unreliable)
[c00000006a3cf940] c00000000006c020 .try_to_wake_up+0x2d8/0x310
[c00000006a3cfa00] c0000000000929a0 .autoremove_wake_function+0x18/0x54
[c00000006a3cfa80] c00000000005b6ac .__wake_up_common+0x6c/0xe8
[c00000006a3cfb30] c000000000063700 .__wake_up+0x4c/0x78
[c00000006a3cfbd0] c0000000000731a8 .printk_tick+0x74/0x94
[c00000006a3cfc60] c000000000081fa8 .run_timer_softirq+0x58/0x338
[c00000006a3cfd40] c00000000007b708 .ksoftirqd+0x214/0x3a0
[c00000006a3cfe30] c000000000092850 .kthread+0xa8/0xb4
[c00000006a3cff90] c00000000002a618 .kernel_thread+0x54/0x70
0:mon> 


**********************
Booting with maxcpus=2 (or just booting by default) hangs momentarily after
the "Processor 1 found.  Brought up 2 CPUs" message gets posted.  Cpu0 appears
to get stuck in csd_lock_wait, but it is actually waiting for the completion
of "on_each_cpu(snapshot_tb_and_purr, NULL, 1);".  The state of cpu1 after
punching reset to invoke xmon is:
1:mon> e
cpu 0x1: Vector: 100 (System Reset) at [c0000000e9403780]
    pc: c00000000004b850: .plpar_hcall+0x2c/0x4c
    lr: c0000000000506c8: .xics_get_irq_lpar+0x20/0xb4
    sp: c0000000e9403a00
   msr: 8000000000081032
  current = 0xc00000006a3a8140
  paca    = 0xc000000000817400
    pid   = 0, comm = swapper
1:mon> t
[link register   ] c0000000000506c8 .xics_get_irq_lpar+0x20/0xb4
[c0000000e9403a00] c00000000075a960 klist_remove_waiters+0x8978/0x28158 (unreliable)
[c0000000e9403aa0] c00000000000df98 .do_IRQ+0xa4/0x224
[c0000000e9403b50] c000000000004814 hardware_interrupt_entry+0x1c/0x20
--- Exception: 501 (Hardware Interrupt) at c00000000000dc70 .raw_local_irq_restore+0x70/0x80
[c0000000e9403e40] c00000000001436c .cpu_idle+0x12c/0x220 (unreliable)
[c0000000e9403ed0] c00000000047e538 .start_secondary+0x370/0x3b0
[c0000000e9403f90] c0000000000082d4 .start_secondary_prolog+0x10/0x14
1:mon> 


Adding some debug/instrumentation to raw_local_irq_restore is next on my list.. 

Thanks, 
-Will




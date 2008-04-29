Return-Path: <linux-kernel-owner+w=401wt.eu-S1759170AbYD2Gwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759170AbYD2Gwa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 02:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169AbYD2GwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 02:52:22 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:34709 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbYD2GwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 02:52:20 -0400
Date: Tue, 29 Apr 2008 12:22:11 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: [BUG-REPORT] hrtick_start_fair and CPU-Hotplug
Message-ID: <20080429065211.GB7859@in.ibm.com>
Reply-To: ego@in.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

While running the usual CPU-Hotplug stress tests on linux-2.6.25,
I noticed the following in the console logs.

This is a wee bit difficult to reproduce. In the past 10 runs I hit this
only once.

------------[ cut here ]------------

WARNING: at kernel/sched.c:962 hrtick+0x2e/0x65()

Modules linked in: usbhid

Pid: 15, comm: events/0 Not tainted 2.6.25 #3

 [<c0122230>] warn_on_slowpath+0x40/0x65

 [<c0130035>] schedule_on_each_cpu+0x74/0xbc

 [<c0119de3>] hrtick+0x0/0x65

 [<c013e095>] __lock_acquire+0xbe8/0xbf7

 [<c013e095>] __lock_acquire+0xbe8/0xbf7

 [<c0134bc1>] __run_hrtimer+0x42/0x79

 [<c0119e11>] hrtick+0x2e/0x65

 [<c0119de3>] hrtick+0x0/0x65

 [<c0134bc5>] __run_hrtimer+0x46/0x79

 [<c0135526>] hrtimer_interrupt+0x100/0x173

 [<c0111bc7>] smp_apic_timer_interrupt+0x68/0x77

 [<c01053b7>] apic_timer_interrupt+0x33/0x38

 [<c0108a3e>] native_read_tsc+0xe/0xf

 [<c0291dc9>] delay_tsc+0x12/0x1d

 [<c0291d5f>] __const_udelay+0x29/0x2a

 [<c04ed960>] do_boot_cpu+0x2f0/0x473

 [<c04edaf4>] do_warm_boot_cpu+0x11/0x1a

 [<c012f72a>] run_workqueue+0xd1/0x1a5

 [<c012f6ea>] run_workqueue+0x91/0x1a5

 [<c04edae3>] do_warm_boot_cpu+0x0/0x1a

 [<c012f8b4>] worker_thread+0xb6/0xc2

 [<c013256a>] autoremove_wake_function+0x0/0x2d

 [<c012f7fe>] worker_thread+0x0/0xc2

 [<c013231a>] kthread+0x38/0x5d

 [<c01322e2>] kthread+0x0/0x5d

 [<c010554f>] kernel_thread_helper+0x7/0x10

 =======================

---[ end trace 9ccf64fec08bb0d7 ]---

------------[ cut here ]------------

WARNING: at kernel/sched.c:514 __update_rq_clock+0x69/0x12b()

Modules linked in: usbhid

Pid: 15, comm: events/0 Not tainted 2.6.25 #3

 [<c0122230>] warn_on_slowpath+0x40/0x65

 [<c0130035>] schedule_on_each_cpu+0x74/0xbc

 [<c013e095>] __lock_acquire+0xbe8/0xbf7

 [<c0108740>] native_sched_clock+0x91/0xa2

 [<c0118683>] __update_rq_clock+0x69/0x12b

 [<c0119e29>] hrtick+0x46/0x65

 [<c0119de3>] hrtick+0x0/0x65

 [<c0134bc5>] __run_hrtimer+0x46/0x79

 [<c0135526>] hrtimer_interrupt+0x100/0x173

 [<c0111bc7>] smp_apic_timer_interrupt+0x68/0x77

 [<c01053b7>] apic_timer_interrupt+0x33/0x38

 [<c0108a3e>] native_read_tsc+0xe/0xf

 [<c0291dc9>] delay_tsc+0x12/0x1d

 [<c0291d5f>] __const_udelay+0x29/0x2a

 [<c04ed960>] do_boot_cpu+0x2f0/0x473

 [<c04edaf4>] do_warm_boot_cpu+0x11/0x1a

 [<c012f72a>] run_workqueue+0xd1/0x1a5

 [<c012f6ea>] run_workqueue+0x91/0x1a5

 [<c04edae3>] do_warm_boot_cpu+0x0/0x1a

 [<c012f8b4>] worker_thread+0xb6/0xc2

 [<c013256a>] autoremove_wake_function+0x0/0x2d

 [<c012f7fe>] worker_thread+0x0/0xc2

 [<c013231a>] kthread+0x38/0x5d

 [<c01322e2>] kthread+0x0/0x5d

 [<c010554f>] kernel_thread_helper+0x7/0x10

 =======================

---[ end trace 9ccf64fec08bb0d7 ]---

Calibrating delay using timer specific routine.. 186544.67 BogoMIPS (lpj=373089344)

CPU: L1 I cache: 32K, L1 D cache: 32K

CPU: L2 cache: 4096K

CPU: Physical Processor ID: 3

CPU: Processor Core ID: 1

Intel machine check architecture supported.

Intel machine check reporting enabled on CPU#3.

CPU3: Intel(R) Xeon(R) CPU            5160  @ 3.00GHz stepping 06

checking TSC synchronization [CPU#0 -> CPU#3]: passed.

lockdep: fixing up alternatives.

Booting processor 1/1 ip 4000

Initializing CPU#1

Calibrating delay using timer specific routine.. 5985.62 BogoMIPS (lpj=11971248)

CPU: L1 I cache: 32K, L1 D cache: 32K

CPU: L2 cache: 4096K

CPU: Physical Processor ID: 0

CPU: Processor Core ID: 1

Intel machine check architecture supported.

.
.
.
.
.
After some half hour,

BUG: unable to handle kernel NULL pointer dereference at 00000000

IP: [<c011845c>] hrtick_start_fair+0x57/0x156

*pde = 00000000 

Oops: 0000 [#1] SMP 

Modules linked in: usbhid



Pid: 3316, comm: bash Not tainted (2.6.25 #3)

EIP: 0060:[<c011845c>] EFLAGS: 00010002 CPU: 1

EIP is at hrtick_start_fair+0x57/0x156

EAX: 00000000 EBX: c04ffc88 ECX: 00000001 EDX: 00000003

ESI: f35a1020 EDI: f31a90e0 EBP: cc84fe00 ESP: f60e7e80

 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068

Process bash (pid: 3316, ti=f60e6000 task=f78dc020 task.ti=f60e6000)

Stack: 00b873a6 c011c4b9 f31a90e0 cc84cb80 cc84fe00 c04ffc88 f35a1020 cc84fe00 

       00000001 c011715d cc84fe00 f35a1020 cc84fe00 c0117183 f35a1020 00000001 

       c011c961 00000000 0000000f 00000003 00000282 c06c7d7c 00000003 00000000 

Call Trace:

 [<c011c4b9>] task_rq_lock+0x2d/0x53

 [<c011715d>] enqueue_task+0x49/0x54

 [<c0117183>] activate_task+0x1b/0x2e

 [<c011c961>] try_to_wake_up+0x15e/0x1a1

 [<c04ef325>] cpu_callback+0xb2/0x12a

 [<c0154b00>] writeback_set_ratelimit+0x11/0x43

 [<c04f4881>] notifier_call_chain+0x2a/0x47

 [<c0135bc2>] raw_notifier_call_chain+0x9/0xc

 [<c04ef1c1>] _cpu_up+0xa8/0xd6

 [<c04ef237>] cpu_up+0x48/0x59

 [<c02f13da>] store_online+0x3a/0x56

 [<c02f13a0>] store_online+0x0/0x56

 [<c02ee5ee>] sysdev_store+0x1e/0x22

 [<c01a1ccf>] sysfs_write_file+0xb5/0xe2

 [<c01a1c1a>] sysfs_write_file+0x0/0xe2

 [<c016f45e>] vfs_write+0x84/0xf7

 [<c016f569>] sys_write+0x3c/0x63

 [<c010483e>] sysenter_past_esp+0x5f/0xa5

 =======================

Code: 95 00 43 6d c0 39 c5 74 0f ba 2d 03 00 00 b8 76 a7 5c c0 e8 a7 9d 00 00 f6 05 50 4a 6d c0 08 0f 84 fd 00 00 00 8b 85 84 04 00 00 <8b> 00 83 b8 9c 00 00 00 00 0f 84 e8 00 00 00 8b 44 24 0c 8b 58 

EIP: [<c011845c>] hrtick_start_fair+0x57/0x156 SS:ESP 0068:f60e7e80

---[ end trace 9ccf64fec08bb0d7 ]---


++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Disassembly of hrtick_start_fair + 0x57 is as follows:

00001abd <hrtick_start_fair>:
hrtick_start_fair():
.
.
.
.
/home/ego/kernels/linux-2.6.25/kernel/sched_fair.c:815
    1b0e:	8b 85 84 04 00 00    	mov    0x484(%ebp),%eax
    ------------------------------------------------------------
    1b14:	8b 00                	mov    (%eax),%eax
    -------------------------------------------------------------
    1b16:	83 b8 9c 00 00 00 00 	cmpl   $0x0,0x9c(%eax)
    1b1d:	0f 84 e8 00 00 00    	je     1c0b <hrtick_start_fair+0x14e>
    1b23:	8b 44 24 0c          	mov    0xc(%esp),%eax
    1b27:	8b 58 08             	mov    0x8(%eax),%ebx
    1b2a:	83 fb 01             	cmp    $0x1,%ebx
    1b2d:	0f 86 d8 00 00 00    	jbe    1c0b <hrtick_start_fair+0x14e>


I am not well versed with this part of the code, so just wondering if we
are doing a good job at handling the cancellation of any per-cpu
scheduler timers during CPU-Hotplug.

--
Thanks and Regards
gautham

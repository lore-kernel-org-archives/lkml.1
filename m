Return-Path: <linux-kernel-owner+w=401wt.eu-S1757406AbYDUPHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406AbYDUPHk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 11:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbYDUPHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 11:07:31 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:37335 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257AbYDUPHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 11:07:30 -0400
Date: Mon, 21 Apr 2008 18:06:56 +0300
From: Adrian Bunk <bunk@kernel.org>
To: ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       mhiramat@redhat.com
Cc: bugme-daemon@bugzilla.kernel.org,
       jean-marc LACROIX <jeanmarc.lacroix@free.Fr>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: [Bug 10489] Kprobe smoke test lockdep warning
Message-ID: <20080421150656.GJ6011@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10489

Please reply via email (more information from the submitter is in the 
Bugzilla entry).


ReportedBy: jeanmarc.lacroix@free.Fr

Earliest failing kernel version: 2.6.25
Distribution: DEbian Etch
Hardware Environment: PIII
Software Environment: 
Problem Description: Warning at boot after running all 
embedded test

Steps to reproduce: boot !!!


   2.701005] Registering sys device '<NULL>'
[    2.702320] Registering sys device '<NULL>'
[    2.703711] Registering sys device '<NULL>'
[    2.704536] Initializing RT-Tester: OK
[    2.704824] device: 'snapshot': device_add
[    2.705140] PM: Adding info for No Bus:snapshot
[    2.706804] audit: initializing netlink socket (disabled)
[    2.707199] type=2000 audit(1208713807.707:1): initialized
[    2.707509] Kprobe smoke test started
[    2.709300] ------------[ cut here ]------------
[    2.709420] WARNING: at kernel/lockdep.c:2658 check_flags+0x4d/0x12c()
[    2.709541] Modules linked in:
[    2.709588] Pid: 1, comm: swapper Not tainted 2.6.25.jml.057 #1
[    2.709588]  [<c0126acc>] warn_on_slowpath+0x41/0x51
[    2.709588]  [<c010bafc>] ? save_stack_trace+0x1d/0x3b
[    2.709588]  [<c0140a83>] ? save_trace+0x37/0x89
[    2.709588]  [<c011987d>] ? kernel_map_pages+0x103/0x11c
[    2.709588]  [<c0109803>] ? native_sched_clock+0xca/0xea
[    2.709588]  [<c0142958>] ? mark_held_locks+0x41/0x5c
[    2.709588]  [<c0382580>] ? kprobe_exceptions_notify+0x322/0x3af
[    2.709588]  [<c0142aff>] ? trace_hardirqs_on+0xf1/0x119
[    2.709588]  [<c03825b3>] ? kprobe_exceptions_notify+0x355/0x3af
[    2.709588]  [<c0140823>] check_flags+0x4d/0x12c
[    2.709588]  [<c0143c9d>] lock_release+0x58/0x195
[    2.709588]  [<c038347c>] ? __atomic_notifier_call_chain+0x0/0x80
[    2.709588]  [<c03834d6>] __atomic_notifier_call_chain+0x5a/0x80
[    2.709588]  [<c0383508>] atomic_notifier_call_chain+0xc/0xe
[    2.709588]  [<c013b6d4>] notify_die+0x2d/0x2f
[    2.709588]  [<c038168a>] do_debug+0x67/0xfe
[    2.709588]  [<c0381287>] debug_stack_correct+0x27/0x30
[    2.709588]  [<c01564c0>] ? kprobe_target+0x1/0x34
[    2.709588]  [<c0156572>] ? init_test_probes+0x50/0x186
[    2.709588]  [<c04fae48>] init_kprobes+0x85/0x8c
[    2.709588]  [<c04e947b>] kernel_init+0x13d/0x298
[    2.709588]  [<c04e933e>] ? kernel_init+0x0/0x298
[    2.709588]  [<c04e933e>] ? kernel_init+0x0/0x298
[    2.709588]  [<c0105ef7>] kernel_thread_helper+0x7/0x10
[    2.709588]  =======================
[    2.709588] ---[ end trace 778e504de7e3b1e3 ]---
[    2.709588] possible reason: unannotated irqs-off.
[    2.709588] irq event stamp: 370065
[    2.709588] hardirqs last  enabled at (370065): [<c0382580>]
kprobe_exceptions_notify+0x322/0x3af
[    2.709588] hardirqs last disabled at (370064): [<c0381bb7>]
do_int3+0x1d/0x7d
[    2.709588] softirqs last  enabled at (370050): [<c012b464>]
__do_softirq+0xfa/0x100
[    2.709588] softirqs last disabled at (370045): [<c0107438>]
do_softirq+0x74/0xd9
[    2.714751] Kprobe smoke test passed successfully
[    2.716150] Total HugeTLB memory allocated, 0
[    2.717288] VFS: Disk quotas dquot_6.5.1
[    2.717689] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    2.719630] device class 'bsg': registering
[    2.720568] Block layer SCSI generic (bsg) driver version 0.4 loaded (major
253)
[    2.720619] io scheduler noop registered
[    2.720732] io scheduler anticipatory registered
[    2.720848] io scheduler deadline registered
[    2.721089] io scheduler cfq registered (default)
[    2.721354] pci 0000:00:01.0: Boot video device




cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


Return-Path: <linux-kernel-owner+w=401wt.eu-S1762170AbZC3WKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762170AbZC3WKv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 18:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757173AbZC3WKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 18:10:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:17831 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757926AbZC3WKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 18:10:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,448,1233561600"; 
   d="scan'208";a="502081955"
Date: Mon, 30 Mar 2009 15:10:34 -0700
From: Chris Leech <christopher.leech@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Leech, Christopher" <christopher.leech@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] irq: mask irq before move it
Message-ID: <20090330221034.GC27774@cleech-lnx.jf.intel.com>
References: <20090326220411.GA16286@cleech-lnx.jf.intel.com> <86802c440903261929s775fe85cv86b900e2610acf1d@mail.gmail.com> <20090327163438.GA10185@cleech-lnx.jf.intel.com> <49CDAAD5.9010202@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49CDAAD5.9010202@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 27, 2009 at 09:43:01PM -0700, Yinghai Lu wrote:
> 
> Imapct: fix panic
> 
> try to mask the irq, before move the irq desc
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

This change did not fix the issue I'm seeing.  The following output was
generated with 2.6.29 + this patch.

I will send system information and kernel config separately.

- Chris


  alloc kstat_irqs on cpu 2 node 0
BUG: spinlock bad magic on CPU#1, swapper/0
general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
last sysfs file: /sys/devices/pci0000:00/0000:00:03.0/0000:03:00.1/irq
CPU 1 
Modules linked in: netconsole configfs sunrpc ipv6 cpufreq_ondemand acpi_cpufreq freq_table dm_multipath ixgbe igb dca [last unloaded: microcode]
Pid: 0, comm: swapper Not tainted 2.6.29-cdl-debug #26 
RIP: 0010:[<ffffffff811b287c>]  [<ffffffff811b287c>] spin_bug+0x77/0xab
RSP: 0018:ffff88007d157ee8  EFLAGS: 00010002
RAX: 00000000ffffffff RBX: 6b6b6b6b6b6b6b6b RCX: ffffffff814f83b5
RDX: 000000007d487d47 RSI: 0000000000000001 RDI: 0000000000000046
RBP: ffff88007d157f08 R08: 0000000000000002 R09: 000000006b6b6b6b
R10: ffffffff814e8f2a R11: 000000000000000a R12: ffff88007bde22a8
R13: ffffffff814e8efc R14: ffff88007bde22a8 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88007d1503e8(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00007fb63f3d8000 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff88003e57e000, task ffff88003e584680)
Stack:
 ffff88007d157f28 ffff88007bde22a8 0000000000000064 ffff88007b030e10
 ffff88007d157f28 ffffffff811b28d1 ffff88007bde22a8 ffff88007bde22a8
 ffff88007d157f48 ffffffff813a0e39 ffff88007bde2238 ffff88007bde2238
Call Trace:
 <IRQ> <0> [<ffffffff811b28d1>] _raw_spin_unlock+0x21/0x94
 [<ffffffff813a0e39>] _spin_unlock+0x2b/0x2f
 [<ffffffff8109a914>] handle_edge_irq+0x11a/0x123
 [<ffffffff81013d27>] do_IRQ+0xe1/0x15a
 [<ffffffff81011f93>] ret_from_intr+0x0/0x2e
 <EOI> <0> [<ffffffff81018110>] ? mwait_idle+0x9e/0xc7
 [<ffffffff81018107>] ? mwait_idle+0x95/0xc7
 [<ffffffff813a42c7>] ? atomic_notifier_call_chain+0xf/0x11
 [<ffffffff810102f8>] ? enter_idle+0x27/0x29
 [<ffffffff81010395>] ? cpu_idle+0x9b/0xe8
 [<ffffffff8139a449>] ? start_secondary+0x1b0/0x1b5
Code: 00 48 8d 88 e8 04 00 00 31 c0 65 8b 14 25 24 00 00 00 e8 c1 b7 1e 00 83 c8 ff 48 85 db 45 8b 4c 24 08 48 c7 c1 b5 83 4f 81 74 0d <8b> 83 98 02 00 00 48 8d 8b e8 04 00 00 41 8b 54 24 04 41 89 c0 
RIP  [<ffffffff811b287c>] spin_bug+0x77/0xab
 RSP <ffff88007d157ee8>
---[ end trace 28512601f8da9d55 ]---
Kernel panic - not syncing: Fatal exception in interrupt
------------[ cut here ]------------
WARNING: at /home/cleech/linux-2.6/kernel/smp.c:329 smp_call_function_many+0x46/0x259()
Modules linked in: netconsole configfs sunrpc ipv6 cpufreq_ondemand acpi_cpufreq freq_table dm_multipath ixgbe igb dca [last unloaded: microcode]
Pid: 0, comm: swapper Tainted: G      D    2.6.29-cdl-debug #26
Call Trace:
 <IRQ>  [<ffffffff8104d176>] warn_slowpath+0xb6/0xf2
 [<ffffffff811b293e>] ? _raw_spin_unlock+0x8e/0x94
 [<ffffffff81065fec>] ? down_trylock+0x14/0x39
 [<ffffffff81083215>] ? crash_kexec+0x20/0xf4
 [<ffffffff8139f314>] ? __mutex_unlock_slowpath+0x128/0x143
 [<ffffffff8107071a>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff810707c8>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff8139f314>] ? __mutex_unlock_slowpath+0x128/0x143
 [<ffffffff8107887b>] smp_call_function_many+0x46/0x259
 [<ffffffff810183bb>] ? stop_this_cpu+0x0/0x36
 [<ffffffff8107071a>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff810707c8>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff813a0df7>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff81078ab3>] smp_call_function+0x25/0x29
 [<ffffffff81022e59>] native_smp_send_stop+0x27/0x6f
 [<ffffffff8139df7a>] panic+0x89/0x138
 [<ffffffff8106600a>] ? down_trylock+0x32/0x39
 [<ffffffff813a2492>] oops_end+0xb9/0xc9
 [<ffffffff81014ca9>] die+0x5a/0x63
 [<ffffffff813a207b>] do_general_protection+0x11e/0x127
 [<ffffffff813a1775>] general_protection+0x25/0x30
 [<ffffffff811b287c>] ? spin_bug+0x77/0xab
 [<ffffffff811b2868>] ? spin_bug+0x63/0xab
 [<ffffffff811b28d1>] _raw_spin_unlock+0x21/0x94
 [<ffffffff813a0e39>] _spin_unlock+0x2b/0x2f
 [<ffffffff8109a914>] handle_edge_irq+0x11a/0x123
 [<ffffffff81013d27>] do_IRQ+0xe1/0x15a
 [<ffffffff81011f93>] ret_from_intr+0x0/0x2e
 <EOI>  [<ffffffff81018110>] ? mwait_idle+0x9e/0xc7
 [<ffffffff81018107>] ? mwait_idle+0x95/0xc7
 [<ffffffff813a42c7>] ? atomic_notifier_call_chain+0xf/0x11
 [<ffffffff810102f8>] ? enter_idle+0x27/0x29
 [<ffffffff81010395>] ? cpu_idle+0x9b/0xe8
 [<ffffffff8139a449>] ? start_secondary+0x1b0/0x1b5
---[ end trace 28512601f8da9d56 ]---
  alloc kstat_irqs on cpu 6 node 0
irq 101: nobody cared (try booting with the "irqpoll" option)
Pid: 0, comm: swapper Tainted: G      D W  2.6.29-cdl-debug #26
Call Trace:
 <IRQ>  [<ffffffff8109a1b7>] __report_bad_irq+0x3d/0x8c
 [<ffffffff8109a323>] note_interrupt+0x11d/0x186
 [<ffffffff8109a8ec>] handle_edge_irq+0xf2/0x123
 [<ffffffff81013d27>] do_IRQ+0xe1/0x15a
 [<ffffffff81011f93>] ret_from_intr+0x0/0x2e
 <EOI>  [<ffffffff81018110>] ? mwait_idle+0x9e/0xc7
 [<ffffffff81018107>] ? mwait_idle+0x95/0xc7
 [<ffffffff813a42c7>] ? atomic_notifier_call_chain+0xf/0x11
 [<ffffffff810102f8>] ? enter_idle+0x27/0x29
 [<ffffffff81010395>] ? cpu_idle+0x9b/0xe8
 [<ffffffff8139a449>] ? start_secondary+0x1b0/0x1b5
handlers:
general protection fault: 0000 [#2] SMP DEBUG_PAGEALLOC
last sysfs file: /sys/devices/pci0000:00/0000:00:03.0/0000:03:00.1/irq
CPU 5 
Modules linked in: netconsole configfs sunrpc ipv6 cpufreq_ondemand acpi_cpufreq freq_table dm_multipath ixgbe igb dca [last unloaded: microcode]
Pid: 0, comm: swapper Tainted: G      D W  2.6.29-cdl-debug #26 
RIP: 0010:[<ffffffff8109a1cb>]  [<ffffffff8109a1cb>] __report_bad_irq+0x51/0x8c
RSP: 0018:ffff88007d1f3ef8  EFLAGS: 00010002
RAX: 000000000000000d RBX: 6b6b6b6b6b6b6b6b RCX: 0000000000000001
RDX: 000000007e557e54 RSI: 0000000000000001 RDI: 0000000000000046
RBP: ffff88007d1f3f08 R08: 0000000000000002 R09: 0000000000000000
R10: ffffffff814d23fc R11: 00000000ffffffff R12: ffff88007beacff8
R13: ffff88007b030ed8 R14: 0000000000000001 R15: 0000000000000065
FS:  0000000000000000(0000) GS:ffff88007d151068(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 000000337404a058 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff88003e664000, task ffff88007d1e8000)
Stack:
 0000000000000000 ffff88007beacff8 ffff88007d1f3f48 ffffffff8109a323
 ffff88007d1f3f48 ffff88007beacff8 0000000000000065 ffff88007b030ed8
 ffff88007bead068 0000000000000000 ffff88007d1f3f78 ffffffff8109a8ec
Call Trace:
 <IRQ> <0> [<ffffffff8109a323>] note_interrupt+0x11d/0x186
 [<ffffffff8109a8ec>] handle_edge_irq+0xf2/0x123
 [<ffffffff81013d27>] do_IRQ+0xe1/0x15a
 [<ffffffff81011f93>] ret_from_intr+0x0/0x2e
 <EOI> <0> [<ffffffff81018110>] ? mwait_idle+0x9e/0xc7
 [<ffffffff81018107>] ? mwait_idle+0x95/0xc7
 [<ffffffff813a42c7>] ? atomic_notifier_call_chain+0xf/0x11
 [<ffffffff810102f8>] ? enter_idle+0x27/0x29
 [<ffffffff81010395>] ? cpu_idle+0x9b/0xe8
 [<ffffffff8139a449>] ? start_secondary+0x1b0/0x1b5
Code: eb 10 89 fe 31 c0 48 c7 c7 bb 23 4d 81 e8 77 3e 30 00 e8 ba 3c 30 00 48 c7 c7 fc 23 4d 81 31 c0 e8 64 3e 30 00 48 8b 5b 48 eb 32 <48> 8b 33 48 c7 c7 0a 24 4d 81 31 c0 e8 4d 3e 30 00 48 8b 33 48 
RIP  [<ffffffff8109a1cb>] __report_bad_irq+0x51/0x8c
 RSP <ffff88007d1f3ef8>
---[ end trace 28512601f8da9d57 ]---
Kernel panic - not syncing: Fatal exception in interrupt
------------[ cut here ]------------
WARNING: at /home/cleech/linux-2.6/kernel/smp.c:329 smp_call_function_many+0x46/0x259()
Modules linked in: netconsole configfs sunrpc ipv6 cpufreq_ondemand acpi_cpufreq freq_table dm_multipath ixgbe igb dca [last unloaded: microcode]
Pid: 0, comm: swapper Tainted: G      D W  2.6.29-cdl-debug #26
Call Trace:
 <IRQ>  [<ffffffff8104d176>] warn_slowpath+0xb6/0xf2
 [<ffffffff811b293e>] ? _raw_spin_unlock+0x8e/0x94
 [<ffffffff81065fec>] ? down_trylock+0x14/0x39
 [<ffffffff81083215>] ? crash_kexec+0x20/0xf4
 [<ffffffff8139f314>] ? __mutex_unlock_slowpath+0x128/0x143
 [<ffffffff8107071a>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff810707c8>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff8139f314>] ? __mutex_unlock_slowpath+0x128/0x143
 [<ffffffff8107887b>] smp_call_function_many+0x46/0x259
 [<ffffffff810183bb>] ? stop_this_cpu+0x0/0x36
 [<ffffffff8107071a>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff810707c8>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff813a0df7>] ? _spin_unlock_irqrestore+0x45/0x5c
 [<ffffffff81078ab3>] smp_call_function+0x25/0x29
 [<ffffffff81022e59>] native_smp_send_stop+0x27/0x6f
 [<ffffffff8139df7a>] panic+0x89/0x138
 [<ffffffff8106600a>] ? down_trylock+0x32/0x39
 [<ffffffff813a2492>] oops_end+0xb9/0xc9
 [<ffffffff81014ca9>] die+0x5a/0x63
 [<ffffffff813a207b>] do_general_protection+0x11e/0x127
 [<ffffffff813a1775>] general_protection+0x25/0x30
 [<ffffffff8109a1cb>] ? __report_bad_irq+0x51/0x8c
 [<ffffffff8109a1c5>] ? __report_bad_irq+0x4b/0x8c
 [<ffffffff8109a323>] note_interrupt+0x11d/0x186
 [<ffffffff8109a8ec>] handle_edge_irq+0xf2/0x123
 [<ffffffff81013d27>] do_IRQ+0xe1/0x15a
 [<ffffffff81011f93>] ret_from_intr+0x0/0x2e
 <EOI>  [<ffffffff81018110>] ? mwait_idle+0x9e/0xc7
 [<ffffffff81018107>] ? mwait_idle+0x95/0xc7
 [<ffffffff813a42c7>] ? atomic_notifier_call_chain+0xf/0x11
 [<ffffffff810102f8>] ? enter_idle+0x27/0x29
 [<ffffffff81010395>] ? cpu_idle+0x9b/0xe8
 [<ffffffff8139a449>] ? start_secondary+0x1b0/0x1b5
---[ end trace 28512601f8da9d58 ]---

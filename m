Return-Path: <linux-kernel-owner+w=401wt.eu-S1760997AbYEFAEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760997AbYEFAEq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 20:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754868AbYEFAEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 20:04:37 -0400
Received: from smtp.enter.net ([216.193.128.24]:2515 "EHLO smtp.enter.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662AbYEFAEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 20:04:36 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: linux-kernel@vger.kernel.org
Subject: linux-next 5/5 does not boot
Date: Mon, 5 May 2008 20:04:33 -0400
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805052004.33804.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This may be related to one of the stack dumps I reported earlier as occurring 
when booting the 4/30 linux-next tree...

During two attempted boots of the 5/5 tree using the same config as the 4/30 
tree the system locked solid at "testing tracer ftrace".

The 4/30 tree produced the following dump (the 5/5 tree locks solid as soon as 
the test is started):
[   10.238230] Testing tracer ftrace: <4>------------[ cut here ]------------
[   10.356558] WARNING: at kernel/lockdep.c:2712 check_flags+0xfb/0x180()
[   10.356726] Modules linked in:
[   10.356915] Pid: 1, comm: swapper Not tainted 2.6.25-next-20080430 #2
[   10.357718]
[   10.357722] Call Trace:
[   10.357939]  <IRQ>  [<ffffffff8023d5f4>] warn_on_slowpath+0x64/0x90
[   10.358174]  [<ffffffff8025f789>] ? tick_get_tick_sched+0x9/0x30
[   10.358337]  [<ffffffff8022f048>] ? __update_rq_clock+0x68/0x140
[   10.358501]  [<ffffffff8026173d>] ? trace_hardirqs_off+0xd/0x10
[   10.358665]  [<ffffffff8026173d>] ? trace_hardirqs_off+0xd/0x10
[   10.358827]  [<ffffffff802953ce>] ? function_trace_call+0x9e/0xa0
[   10.358992]  [<ffffffff8020c4b4>] ? ftrace_call+0x5/0x2b
[   10.359148]  [<ffffffff8023177a>] ? cpu_clock+0xda/0x190
[   10.359302]  [<ffffffff80262d7b>] check_flags+0xfb/0x180
[   10.359457]  [<ffffffff80265635>] lock_acquire+0x65/0xd0
[   10.359614]  [<ffffffff80231799>] cpu_clock+0xf9/0x190
[   10.359769]  [<ffffffff80293de9>] ftrace_now+0x9/0x10
[   10.359920]  [<ffffffff80295194>] trace_function+0xc4/0x260
[   10.360079]  [<ffffffff80243723>] ? _local_bh_enable+0x63/0xc0
[   10.360240]  [<ffffffff804aeec9>] ? sub_preempt_count+0x9/0x90
[   10.360400]  [<ffffffff80243723>] ? _local_bh_enable+0x63/0xc0
[   10.360561]  [<ffffffff804aeec9>] ? sub_preempt_count+0x9/0x90
[   10.360721]  [<ffffffff8029539c>] function_trace_call+0x6c/0xa0
[   10.360883]  [<ffffffff8020c4b4>] ftrace_call+0x5/0x2b
[   10.361038]  [<ffffffff804aeec9>] ? sub_preempt_count+0x9/0x90
[   10.361199]  [<ffffffff80243723>] _local_bh_enable+0x63/0xc0
[   10.361357]  [<ffffffff8024399e>] __do_softirq+0xfe/0x150
[   10.361514]  [<ffffffff8020d93c>] call_softirq+0x1c/0x30
[   10.361669]  [<ffffffff8020f76a>] do_softirq+0x6a/0xb0
[   10.361823]  [<ffffffff80244155>] irq_exit+0xa5/0xb0
[   10.361975]  [<ffffffff802204ee>] smp_apic_timer_interrupt+0x9e/0xf0
[   10.362143]  [<ffffffff8020d3fb>] apic_timer_interrupt+0x6b/0x70
[   10.362301]  <EOI>  [<ffffffff804ab808>] ? 
_spin_unlock_irqrestore+0x68/0x80
[   10.362543]  [<ffffffff8023540b>] ? try_to_wake_up+0xab/0x270
[   10.362704]  [<ffffffff8020c4b4>] ? ftrace_call+0x5/0x2b
[   10.362860]  [<ffffffff80235625>] ? wake_up_process+0x15/0x20
[   10.362979]  [<ffffffff80255264>] ? kthread_create+0xa4/0x120
[   10.362979]  [<ffffffff8027a390>] ? do_stop+0x0/0x190
[   10.362979]  [<ffffffff80265a6e>] ? mark_held_locks+0x3e/0x80
[   10.362979]  [<ffffffff80265d4d>] ? trace_hardirqs_on+0xd/0x10
[   10.362979]  [<ffffffff80265c85>] ? trace_hardirqs_on_caller+0xf5/0x1b0
[   10.362979]  [<ffffffff80263f2b>] ? lockdep_init_map+0x4b/0x140
[   10.362979]  [<ffffffff8037d6f8>] ? __spin_lock_init+0x38/0x70
[   10.362979]  [<ffffffff80255714>] ? init_waitqueue_head+0x24/0x40
[   10.362979]  [<ffffffff8028ffc0>] ? __ftrace_modify_code+0x0/0xa0
[   10.362979]  [<ffffffff8027a185>] ? __stop_machine_run+0x85/0xf0
[   10.362979]  [<ffffffff8028ffc0>] ? __ftrace_modify_code+0x0/0xa0
[   10.362979]  [<ffffffff8028ffc0>] ? __ftrace_modify_code+0x0/0xa0
[   10.362979]  [<ffffffff8028ffc0>] ? __ftrace_modify_code+0x0/0xa0
[   10.362979]  [<ffffffff8027a223>] ? stop_machine_run+0x33/0x60
[   10.362979]  [<ffffffff8028f3a0>] ? ftrace_run_update_code+0x20/0x30
[   10.362979]  [<ffffffff8028f7ea>] ? unregister_ftrace_function+0x14a/0x190
[   10.362979]  [<ffffffff80292e70>] ? tracing_stop_function_trace+0x10/0x20
[   10.362979]  [<ffffffff80296759>] ? stop_function_trace+0x9/0x20
[   10.362979]  [<ffffffff80296787>] ? function_trace_ctrl_update+0x17/0x20
[   10.362979]  [<ffffffff80292d5e>] ? 
trace_selftest_startup_function+0xae/0x140
[   10.362979]  [<ffffffff8029220d>] ? register_tracer+0x11d/0x1f0
[   10.362979]  [<ffffffff80665d50>] ? init_function_trace+0x10/0x20
[   10.362979]  [<ffffffff8064eee4>] ? kernel_init+0x164/0x2f0
[   10.362979]  [<ffffffff804aeec9>] ? sub_preempt_count+0x9/0x90
[   10.362979]  [<ffffffff804ab77b>] ? _spin_unlock_irq+0x3b/0x60
[   10.362979]  [<ffffffff804aab1d>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   10.362979]  [<ffffffff80265c85>] ? trace_hardirqs_on_caller+0xf5/0x1b0
[   10.362979]  [<ffffffff8020d5d8>] ? child_rip+0xa/0x12
[   10.362979]  [<ffffffff8020cc63>] ? restore_args+0x0/0x30
[   10.362979]  [<ffffffff8064ed80>] ? kernel_init+0x0/0x2f0
[   10.362979]  [<ffffffff8020d5ce>] ? child_rip+0x0/0x12
[   10.362979]
[   10.362979] ---[ end trace 5a5d197966b56a2e ]---
[   10.362979] irq event stamp: 3391956
[   10.362979] hardirqs last  enabled at (3391954): [<ffffffff80265d4d>] 
trace_hardirqs_on+0xd/0x10
[   10.362979] hardirqs last disabled at (3391955): [<ffffffff8026173d>] 
trace_hardirqs_off+0xd/0x10
[   10.362979] softirqs last  enabled at (3391956): [<ffffffff8024399e>] 
__do_softirq+0xfe/0x150
[   10.362979] softirqs last disabled at (3391933): [<ffffffff8020d93c>] 
call_softirq+0x1c/0x30
[   10.376978] kstopmachine used greatest stack depth: 6000 bytes left
[   10.377650] PASSED

config for 5/5 tree will be provided on request. Dmesg from 4/30 tree is also 
available. System had not mounted the root drive before the ftrace crash, so 
I have no available logs or dmesg from the 5/5 tree. If asked, I will attempt 
to setup a netconsole and try to capture the logs there.

DRH

--
Dialup is like pissing through a pipette. Slow and excruciatingly painful.

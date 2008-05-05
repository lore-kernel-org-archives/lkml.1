Return-Path: <linux-kernel-owner+w=401wt.eu-S932292AbYEESsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292AbYEESsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763766AbYEESje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:39:34 -0400
Received: from smtp.enter.net ([216.193.128.24]:2155 "EHLO smtp.enter.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763385AbYEESja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:39:30 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next for April 30, 2008 crashes
Date: Mon, 5 May 2008 14:39:18 -0400
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805051439.20696.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When booting linux-next for April 30, 2008 I get  the following crashes:
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

NEXT:
[   10.780060] Testing -fstack-protector-all feature
[   10.780153] No -fstack-protector-stack-frame!
[   10.780252] -fstack-protector-all test failed
[   10.780347] ------------[ cut here ]------------
[   10.780458] WARNING: at kernel/panic.c:375 __stack_chk_test+0x50/0x60()
[   10.780559] Modules linked in:
[   10.780698] Pid: 1, comm: swapper Tainted: G        W 2.6.25-next-20080430 
#2
[   10.780798]
[   10.780799] Call Trace:
[   10.780967]  [<ffffffff8023d5f4>] warn_on_slowpath+0x64/0x90
[   10.781064]  [<ffffffff8023ea3c>] ? printk+0x7c/0xa0
[   10.781158]  [<ffffffff80259dde>] ? up+0x1e/0x50
[   10.781252]  [<ffffffff8020c450>] ? mcount_call+0x5/0x35
[   10.781480]  [<ffffffff8023d670>] __stack_chk_test+0x50/0x60
[   10.781577]  [<ffffffff8064eee4>] kernel_init+0x164/0x2f0
[   10.781675]  [<ffffffff804aeec9>] ? sub_preempt_count+0x9/0x90
[   10.781772]  [<ffffffff804ab77b>] ? _spin_unlock_irq+0x3b/0x60
[   10.781869]  [<ffffffff804aab1d>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   10.781969]  [<ffffffff80265c85>] ? trace_hardirqs_on_caller+0xf5/0x1b0
[   10.782068]  [<ffffffff8020d5d8>] child_rip+0xa/0x12
[   10.782162]  [<ffffffff8020cc63>] ? restore_args+0x0/0x30
[   10.782259]  [<ffffffff8064ed80>] ? kernel_init+0x0/0x2f0
[   10.782354]  [<ffffffff8020d5ce>] ? child_rip+0x0/0x12
[   10.782447]
[   10.782529] ---[ end trace 5a5d197966b56a2e ]---


ANOTHER:
[   40.169749] BUG: unable to handle kernel paging request at ffff81042d8c9114
[   40.170010] IP: [<ffffffff8026ead7>] sys_init_module+0x917/0x1fa0
[   40.170163] PGD 8063 PUD 0
[   40.170346] Oops: 0000 [1] PREEMPT SMP DEBUG_PAGEALLOC
[   40.170632] last sysfs file: /sys/kernel/uevent_seqnum
[   40.170729] CPU 0
[   40.170861] Modules linked in: cpufreq_userspace cpufreq_stats freq_table 
container dm_crypt dm_mod sbp2 parport_pc lp parport snd_hda_intel snd_hwdep 
snd_pcm_oss snd_pcm snd_page_alloc snd_mixer_oss snd_seq_dummy snd_seq_oss 
arc4 snd_seq_midi snd_rawmidi snd_seq_midi_event ecb snd_seq crypto_blkcipher 
snd_timer snd_seq_device iwl3945 joydev mac80211 led_class sdhci cfg80211 
iTCO_wdt iTCO_vendor_support serio_raw mmc_core pcspkr psmouse snd shpchp 
pci_hotplug soundcore video battery wmi button intel_agp ac dcdbas evdev ext3 
jbd mbcache sg sr_mod cdrom sd_mod pata_acpi ata_generic ahci ata_piix 
uhci_hcd ohci1394 ieee1394 libata scsi_mod ehci_hcd tg3 dock usbcore thermal 
processor fan fuse
[   40.174994] Pid: 5503, comm: modprobe Tainted: G        W 
2.6.25-next-20080430 #2
[   40.175127] RIP: 0010:[<ffffffff8026ead7>]  [<ffffffff8026ead7>] 
sys_init_module+0x917/0x1fa0
[   40.175312] RSP: 0018:ffff81003e5a1df8  EFLAGS: 00010206
[   40.175408] RAX: 00000000ffffffff RBX: ffffffffffffffe0 RCX: 
ffff81042d8c9114
[   40.175510] RDX: 00000000000000bc RSI: ffff81002d8c9118 RDI: 
ffff81002d8c9118
[   40.175612] RBP: ffff81003e5a1f78 R08: 0000000000000020 R09: 
0000000000000000
[   40.175714] R10: 0000000000000000 R11: 0000000000000003 R12: 
0000000000000000
[   40.175816] R13: 0000000000000000 R14: 0000000000000020 R15: 
ffffc200040c68c0
[   40.175918] FS:  00007f6cecebb6e0(0000) GS:ffffffff8063d800(0000) 
knlGS:0000000000000000
[   40.176054] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   40.176151] CR2: ffff81042d8c9114 CR3: 000000003ad99000 CR4: 
00000000000006e0
[   40.176253] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[   40.176355] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[   40.176457] Process modprobe (pid: 5503, threadinfo ffff81003e5a0000, task 
ffff81002e404000)
[   40.176592] Stack:  ffff81003e5a1eb8 ffffffff802ae6ef ffff81002e7edac0 
0000000000000046
[   40.176966]  ffffffff80376a5d 0000000000000000 0000000000000000 
0000000000000000
[   40.177290]  0000000000000000 0000000000000000 0000000e00000000 
0000000000000000
[   40.177536] Call Trace:
[   40.177704]  [<ffffffff802ae6ef>] ? mmap_region+0x28f/0x4e0
[   40.177804]  [<ffffffff80376a5d>] ? __up_write+0x2d/0x120
[   40.177909]  [<ffffffff80376b03>] ? __up_write+0xd3/0x120
[   40.178010]  [<ffffffff802595bb>] ? up_write+0x2b/0x40
[   40.178109]  [<ffffffff804aab1d>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   40.178213]  [<ffffffff8020c60b>] system_call_after_swapgs+0x7b/0x80
[   40.178317]
[   40.178399]
[   40.178482] Code: 48 39 c2 73 1e 89 c8 41 83 c2 01 49 83 c1 01 45 39 d3 0f 
84 89 01 00 00 89 c0 48 01 85 20 ff ff ff eb a1 41 8d 42 ff 48 8d 0c 87 <8b> 
01 85 c0 0f 88 5f 01 00 00 44 01 e0 44 89 e2 89 01 8b 0e 29
[   40.179073] RIP  [<ffffffff8026ead7>] sys_init_module+0x917/0x1fa0
[   40.179073]  RSP <ffff81003e5a1df8>
[   40.179073] CR2: ffff81042d8c9114
[   40.179073] ---[ end trace 5a5d197966b56a2e ]---
[   40.179073] BUG: sleeping function called from invalid context at 
kernel/rwsem.c:21
[   40.179073] in_atomic():0, irqs_disabled():1
[   40.179073] INFO: lockdep is turned off.
[   40.179073] irq event stamp: 0
[   40.179073] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
[   40.179073] hardirqs last disabled at (0): [<ffffffff8023bb59>] 
copy_process+0x3c9/0x1450
[   40.183586] softirqs last  enabled at (0): [<ffffffff8023bb59>] 
copy_process+0x3c9/0x1450
[   40.183817] softirqs last disabled at (0): [<0000000000000000>] 0x0
[   40.184013] Pid: 5503, comm: modprobe Tainted: G      D W 
2.6.25-next-20080430 #2
[   40.184145]
[   40.184146] Call Trace:
[   40.184315]  [<ffffffff80262c70>] ? print_irqtrace_events+0x110/0x120
[   40.184418]  [<ffffffff8022fc46>] __might_sleep+0xc6/0xf0
[   40.184515]  [<ffffffff804a9a00>] down_read+0x20/0x70
[   40.184613]  [<ffffffff80275c21>] acct_collect+0x51/0x1c0
[   40.184712]  [<ffffffff80240d5f>] do_exit+0x18f/0x8d0
[   40.184811]  [<ffffffff80259dde>] ? up+0x1e/0x50
[   40.184908]  [<ffffffff804ac1c5>] oops_end+0xc5/0xd0
[   40.185006]  [<ffffffff804aeb53>] do_page_fault+0x553/0x8c0
[   40.185108]  [<ffffffff804abb4d>] error_exit+0x0/0xa9
[   40.185209]  [<ffffffff8026ead7>] ? sys_init_module+0x917/0x1fa0
[   40.185309]  [<ffffffff8026e9da>] ? sys_init_module+0x81a/0x1fa0
[   40.185409]  [<ffffffff802ae6ef>] ? mmap_region+0x28f/0x4e0
[   40.185507]  [<ffffffff80376a5d>] ? __up_write+0x2d/0x120
[   40.185612]  [<ffffffff80376b03>] ? __up_write+0xd3/0x120
[   40.185712]  [<ffffffff802595bb>] ? up_write+0x2b/0x40
[   40.185810]  [<ffffffff804aab1d>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   40.185914]  [<ffffffff8020c60b>] ? system_call_after_swapgs+0x7b/0x80
[   40.186019]


In the end the system is unable to access  the hardware clock (there is a 
message about not being able to register/initialize rtc0) and X freezes at 
start with no messages in any log - and without ever switching to a new VT 
(or even allocating such).

I'm currently building the latest linux-next tree from the same config and 
will test it soon. If needed I'll make the full dmesg and config available.

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756668AbYA3GrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668AbYA3GrW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 01:47:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbYA3GrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 01:47:10 -0500
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:41740 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752528AbYA3GrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 01:47:07 -0500
Message-ID: <47A01C30.7020309@linux.vnet.ibm.com>
Date: Wed, 30 Jan 2008 12:11:52 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: [BUG] 2.6.24-git6 soft lockup detected while running libhugetlbfs
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Softlockup is detected while running libhugetlbfs on the 2.6.24-git6 kernel.
The machine is a Pentium III (Cascades) 16 cpu machine.

BUG: soft lockup - CPU#13 stuck for 61s! [swapper:0]

Pid: 0, comm: swapper Not tainted (2.6.24-git6-autokern1 #1)
EIP: 0060:[<c1000328>] EFLAGS: 00000246 CPU: 13
EIP is at default_idle+0x30/0x44
EAX: 00000000 EBX: c10002f8 ECX: 00100000 EDX: ffff8fcf
ESI: 0000000d EDI: 00128868 EBP: e744bf9c ESP: e744bf9c
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: b7eadcc0 CR3: 01386000 CR4: 000006f0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c1002dfb>] show_trace_log_lvl+0x19/0x2e
 [<c1002e22>] show_trace+0x12/0x14
 [<c1000719>] show_regs+0x1c/0x1f
 [<c103a7ad>] softlockup_tick+0xe0/0xf6
 [<c10249bd>] run_local_timers+0x17/0x19
 [<c1024802>] update_process_times+0x24/0x49
 [<c1033aee>] tick_periodic+0x63/0x6f
 [<c1033b13>] tick_handle_periodic+0x19/0x6a
 [<c100bf00>] local_apic_timer_interrupt+0x4e/0x53
 [<c100bf2f>] smp_apic_timer_interrupt+0x2a/0x39
 [<c1002b7c>] apic_timer_interrupt+0x28/0x30
 [<c10003b9>] cpu_idle+0x76/0x8b
 [<c136bb76>] start_secondary+0xb1/0xb3
 [<00000000>] _stext+0x3effff40/0x19
 =======================
BUG: soft lockup - CPU#12 stuck for 61s! [swapper:0]

Pid: 0, comm: swapper Not tainted (2.6.24-git6-autokern1 #1)
EIP: 0060:[<c1000328>] EFLAGS: 00000246 CPU: 12
EIP is at default_idle+0x30/0x44
EAX: 00000000 EBX: c10002f8 ECX: 000f7000 EDX: ffff8fcf
ESI: 0000000c EDI: 00128868 EBP: e7447f9c ESP: e7447f9c
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: b7f67f1c CR3: 01386000 CR4: 000006f0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c1002dfb>] show_trace_log_lvl+0x19/0x2e
 [<c1002e22>] show_trace+0x12/0x14
 [<c1000719>] show_regs+0x1c/0x1f
 [<c103a7ad>] softlockup_tick+0xe0/0xf6
 [<c10249bd>] run_local_timers+0x17/0x19
 [<c1024802>] update_process_times+0x24/0x49
 [<c1033aee>] tick_periodic+0x63/0x6f
 [<c1033b13>] tick_handle_periodic+0x19/0x6a
 [<c100bf00>] local_apic_timer_interrupt+0x4e/0x53
 [<c100bf2f>] smp_apic_timer_interrupt+0x2a/0x39
 [<c1002b7c>] apic_timer_interrupt+0x28/0x30
 [<c10003b9>] cpu_idle+0x76/0x8b
 [<c136bb76>] start_secondary+0xb1/0xb3
 [<00000000>] _stext+0x3effff40/0x19
 =======================
BUG: soft lockup - CPU#14 stuck for 61s! [swapper:0]

Pid: 0, comm: swapper Not tainted (2.6.24-git6-autokern1 #1)
EIP: 0060:[<c1000328>] EFLAGS: 00000246 CPU: 14
EIP is at default_idle+0x30/0x44
EAX: 00000000 EBX: c10002f8 ECX: 00109000 EDX: ffff8fcf
ESI: 0000000e EDI: 00128868 EBP: e744ff9c ESP: e744ff9c
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: b7e12494 CR3: 01386000 CR4: 000006f0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c1002dfb>] show_trace_log_lvl+0x19/0x2e
 [<c1002e22>] show_trace+0x12/0x14
 [<c1000719>] show_regs+0x1c/0x1f
 [<c103a7ad>] softlockup_tick+0xe0/0xf6
 [<c10249bd>] run_local_timers+0x17/0x19
 [<c1024802>] update_process_times+0x24/0x49
 [<c1033aee>] tick_periodic+0x63/0x6f
 [<c1033b13>] tick_handle_periodic+0x19/0x6a
 [<c100bf00>] local_apic_timer_interrupt+0x4e/0x53
 [<c100bf2f>] smp_apic_timer_interrupt+0x2a/0x39
 [<c1002b7c>] apic_timer_interrupt+0x28/0x30
 [<c10003b9>] cpu_idle+0x76/0x8b
 [<c136bb76>] start_secondary+0xb1/0xb3
 [<00000000>] _stext+0x3effff40/0x19
 =======================
BUG: soft lockup - CPU#15 stuck for 61s! [swapper:0]

Pid: 0, comm: swapper Not tainted (2.6.24-git6-autokern1 #1)
EIP: 0060:[<c1000328>] EFLAGS: 00000246 CPU: 15
EIP is at default_idle+0x30/0x44
EAX: 00000000 EBX: c10002f8 ECX: 00112000 EDX: ffff8fcf
ESI: 0000000f EDI: 00128868 EBP: e7451f9c ESP: e7451f9c
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: b7f2ecc0 CR3: 01386000 CR4: 000006f0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c1002dfb>] show_trace_log_lvl+0x19/0x2e
 [<c1002e22>] show_trace+0x12/0x14
 [<c1000719>] show_regs+0x1c/0x1f
 [<c103a7ad>] softlockup_tick+0xe0/0xf6
 [<c10249bd>] run_local_timers+0x17/0x19
 [<c1024802>] update_process_times+0x24/0x49
 [<c1033aee>] tick_periodic+0x63/0x6f
 [<c1033b13>] tick_handle_periodic+0x19/0x6a
 [<c100bf00>] local_apic_timer_interrupt+0x4e/0x53
 [<c100bf2f>] smp_apic_timer_interrupt+0x2a/0x39
 [<c1002b7c>] apic_timer_interrupt+0x28/0x30
 [<c10003b9>] cpu_idle+0x76/0x8b
 [<c136bb76>] start_secondary+0xb1/0xb3
 [<00000000>] _stext+0x3effff40/0x19
 =======================
BUG: soft lockup - CPU#10 stuck for 61s! [swapper:0]

Pid: 0, comm: swapper Not tainted (2.6.24-git6-autokern1 #1)
EIP: 0060:[<c1000328>] EFLAGS: 00000246 CPU: 10
EIP is at default_idle+0x30/0x44
EAX: 00000000 EBX: c10002f8 ECX: 000e5000 EDX: ffff8fcf
ESI: 0000000a EDI: 00128868 EBP: e7443f9c ESP: e7443f9c
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: b7ed5cc0 CR3: 01386000 CR4: 000006f0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c1002dfb>] show_trace_log_lvl+0x19/0x2e
 [<c1002e22>] show_trace+0x12/0x14
 [<c1000719>] show_regs+0x1c/0x1f
 [<c103a7ad>] softlockup_tick+0xe0/0xf6
 [<c10249bd>] run_local_timers+0x17/0x19
 [<c1024802>] update_process_times+0x24/0x49
 [<c1033aee>] tick_periodic+0x63/0x6f
 [<c1033b13>] tick_handle_periodic+0x19/0x6a
 [<c100bf00>] local_apic_timer_interrupt+0x4e/0x53
 [<c100bf2f>] smp_apic_timer_interrupt+0x2a/0x39
 [<c1002b7c>] apic_timer_interrupt+0x28/0x30
 [<c10003b9>] cpu_idle+0x76/0x8b
 [<c136bb76>] start_secondary+0xb1/0xb3
 [<00000000>] _stext+0x3effff40/0x19
 =======================
BUG: soft lockup - CPU#8 stuck for 61s! [swapper:0]

Pid: 0, comm: swapper Not tainted (2.6.24-git6-autokern1 #1)
EIP: 0060:[<c1000328>] EFLAGS: 00000246 CPU: 8
EIP is at default_idle+0x30/0x44
EAX: 00000000 EBX: c10002f8 ECX: 000d3000 EDX: ffff8fcf
ESI: 00000008 EDI: 00128868 EBP: e743df9c ESP: e743df9c
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: b7e282a0 CR3: 01386000 CR4: 000006f0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c1002dfb>] show_trace_log_lvl+0x19/0x2e
 [<c1002e22>] show_trace+0x12/0x14
 [<c1000719>] show_regs+0x1c/0x1f
 [<c103a7ad>] softlockup_tick+0xe0/0xf6
 [<c10249bd>] run_local_timers+0x17/0x19
 [<c1024802>] update_process_times+0x24/0x49
 [<c1033aee>] tick_periodic+0x63/0x6f
 [<c1033b13>] tick_handle_periodic+0x19/0x6a
 [<c100bf00>] local_apic_timer_interrupt+0x4e/0x53
 [<c100bf2f>] smp_apic_timer_interrupt+0x2a/0x39
 [<c1002b7c>] apic_timer_interrupt+0x28/0x30
 [<c10003b9>] cpu_idle+0x76/0x8b
 [<c136bb76>] start_secondary+0xb1/0xb3
 [<00000000>] _stext+0x3effff40/0x19
 =======================
BUG: soft lockup - CPU#11 stuck for 61s! [swapper:0]

Pid: 0, comm: swapper Not tainted (2.6.24-git6-autokern1 #1)
EIP: 0060:[<c1000328>] EFLAGS: 00000246 CPU: 11
EIP is at default_idle+0x30/0x44
EAX: 00000000 EBX: c10002f8 ECX: 000ee000 EDX: ffff8fcf
ESI: 0000000b EDI: 00128868 EBP: e7445f9c ESP: e7445f9c
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: b7ebf8c0 CR3: 01386000 CR4: 000006f0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c1002dfb>] show_trace_log_lvl+0x19/0x2e
 [<c1002e22>] show_trace+0x12/0x14
 [<c1000719>] show_regs+0x1c/0x1f
 [<c103a7ad>] softlockup_tick+0xe0/0xf6
 [<c10249bd>] run_local_timers+0x17/0x19
 [<c1024802>] update_process_times+0x24/0x49
 [<c1033aee>] tick_periodic+0x63/0x6f
 [<c1033b13>] tick_handle_periodic+0x19/0x6a
 [<c100bf00>] local_apic_timer_interrupt+0x4e/0x53
 [<c100bf2f>] smp_apic_timer_interrupt+0x2a/0x39
 [<c1002b7c>] apic_timer_interrupt+0x28/0x30
 [<c10003b9>] cpu_idle+0x76/0x8b
 [<c136bb76>] start_secondary+0xb1/0xb3
 [<00000000>] _stext+0x3effff40/0x19
 =======================
BUG: soft lockup - CPU#9 stuck for 61s! [swapper:0]

Pid: 0, comm: swapper Not tainted (2.6.24-git6-autokern1 #1)
EIP: 0060:[<c1000328>] EFLAGS: 00000246 CPU: 9
EIP is at default_idle+0x30/0x44
EAX: 00000000 EBX: c10002f8 ECX: 000dc000 EDX: ffff8fcf
ESI: 00000009 EDI: 00128868 EBP: e7441f9c ESP: e7441f9c
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: b7ddff90 CR3: 25958000 CR4: 000006f0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c1002dfb>] show_trace_log_lvl+0x19/0x2e
 [<c1002e22>] show_trace+0x12/0x14
 [<c1000719>] show_regs+0x1c/0x1f
 [<c103a7ad>] softlockup_tick+0xe0/0xf6
 [<c10249bd>] run_local_timers+0x17/0x19
 [<c1024802>] update_process_times+0x24/0x49
 [<c1033aee>] tick_periodic+0x63/0x6f
 [<c1033b13>] tick_handle_periodic+0x19/0x6a
 [<c100bf00>] local_apic_timer_interrupt+0x4e/0x53
 [<c100bf2f>] smp_apic_timer_interrupt+0x2a/0x39
 [<c1002b7c>] apic_timer_interrupt+0x28/0x30
 [<c10003b9>] cpu_idle+0x76/0x8b
 [<c136bb76>] start_secondary+0xb1/0xb3
 [<00000000>] _stext+0x3effff40/0x19
 =======================
BUG: soft lockup - CPU#5 stuck for 61s! [swapper:0]

Pid: 0, comm: swapper Not tainted (2.6.24-git6-autokern1 #1)
EIP: 0060:[<c1000328>] EFLAGS: 00000246 CPU: 5
EIP is at default_idle+0x30/0x44
EAX: 00000000 EBX: c10002f8 ECX: 000b8000 EDX: ffff8fcf
ESI: 00000005 EDI: 00128868 EBP: e7435f9c ESP: e7435f9c
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: b7dda494 CR3: 01386000 CR4: 000006f0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c1002dfb>] show_trace_log_lvl+0x19/0x2e
 [<c1002e22>] show_trace+0x12/0x14
 [<c1000719>] show_regs+0x1c/0x1f
 [<c103a7ad>] softlockup_tick+0xe0/0xf6
 [<c10249bd>] run_local_timers+0x17/0x19
 [<c1024802>] update_process_times+0x24/0x49
 [<c1033aee>] tick_periodic+0x63/0x6f
 [<c1033b13>] tick_handle_periodic+0x19/0x6a
 [<c100bf00>] local_apic_timer_interrupt+0x4e/0x53
 [<c100bf2f>] smp_apic_timer_interrupt+0x2a/0x39
 [<c1002b7c>] apic_timer_interrupt+0x28/0x30
 [<c10003b9>] cpu_idle+0x76/0x8b
 [<c136bb76>] start_secondary+0xb1/0xb3
 [<00000000>] _stext+0x3effff40/0x19
 =======================
BUG: soft lockup - CPU#6 stuck for 61s! [swapper:0]

Pid: 0, comm: swapper Not tainted (2.6.24-git6-autokern1 #1)
EIP: 0060:[<c1000328>] EFLAGS: 00000246 CPU: 6
EIP is at default_idle+0x30/0x44
EAX: 00000000 EBX: c10002f8 ECX: 000c1000 EDX: ffff8fcf
ESI: 00000006 EDI: 00128868 EBP: e7437f9c ESP: e7437f9c
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: b7dda494 CR3: 01386000 CR4: 000006f0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c1002dfb>] show_trace_log_lvl+0x19/0x2e
 [<c1002e22>] show_trace+0x12/0x14
 [<c1000719>] show_regs+0x1c/0x1f
 [<c103a7ad>] softlockup_tick+0xe0/0xf6
 [<c10249bd>] run_local_timers+0x17/0x19
 [<c1024802>] update_process_times+0x24/0x49
 [<c1033aee>] tick_periodic+0x63/0x6f
 [<c1033b13>] tick_handle_periodic+0x19/0x6a
 [<c100bf00>] local_apic_timer_interrupt+0x4e/0x53
 [<c100bf2f>] smp_apic_timer_interrupt+0x2a/0x39
 [<c1002b7c>] apic_timer_interrupt+0x28/0x30
 [<c10003b9>] cpu_idle+0x76/0x8b
 [<c136bb76>] start_secondary+0xb1/0xb3
 [<00000000>] _stext+0x3effff40/0x19
 =======================
BUG: soft lockup - CPU#7 stuck for 61s! [swapper:0]

Pid: 0, comm: swapper Not tainted (2.6.24-git6-autokern1 #1)
EIP: 0060:[<c1000328>] EFLAGS: 00000246 CPU: 7
EIP is at default_idle+0x30/0x44
EAX: 00000000 EBX: c10002f8 ECX: 000ca000 EDX: ffff8fcf
ESI: 00000007 EDI: 00128868 EBP: e743bf9c ESP: e743bf9c
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: b7de01bc CR3: 01386000 CR4: 000006f0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c1002dfb>] show_trace_log_lvl+0x19/0x2e
 [<c1002e22>] show_trace+0x12/0x14
 [<c1000719>] show_regs+0x1c/0x1f
 [<c103a7ad>] softlockup_tick+0xe0/0xf6
 [<c10249bd>] run_local_timers+0x17/0x19
 [<c1024802>] update_process_times+0x24/0x49
 [<c1033aee>] tick_periodic+0x63/0x6f
 [<c1033b13>] tick_handle_periodic+0x19/0x6a
 [<c100bf00>] local_apic_timer_interrupt+0x4e/0x53
 [<c100bf2f>] smp_apic_timer_interrupt+0x2a/0x39
 [<c1002b7c>] apic_timer_interrupt+0x28/0x30
 [<c10003b9>] cpu_idle+0x76/0x8b
 [<c136bb76>] start_secondary+0xb1/0xb3
 [<00000000>] _stext+0x3effff40/0x19
 =======================


the softlockup trace above is just less than half of the trace seen.
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.

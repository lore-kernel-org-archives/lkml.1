Return-Path: <linux-kernel-owner+w=401wt.eu-S1760406AbYHELSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760406AbYHELSv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 07:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756094AbYHELSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 07:18:42 -0400
Received: from mail.gmx.net ([213.165.64.20]:55780 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753289AbYHELSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 07:18:40 -0400
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX1/r/9MNW+ProzDfzc3GA88bmfYqbyU0u87FbSPst+
	9c8QKE9gk/1Oal
Date: Tue, 5 Aug 2008 13:18:36 +0200
From: Eric Sesterhenn <snakebyte@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: shaohua.li@intel.com
Message-ID: <20080805111836.GB12217@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.26 (x86_64)
X-Uptime: 12:31:22 up 21:14,  1 user,  load average: 0.48, 0.43, 0.46
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hi,

issuing a 

cat /sys/devices/system/cpu/cpuidle/current_driver

gives me the following oops on current -git,
it seems that 

[ 1088.476173] BUG: unable to handle kernel paging request at c054f2fc
[ 1088.476512] IP: [<c04172d3>] string+0x52/0x74
[ 1088.476810] Oops: 0003 [#1] PREEMPT DEBUG_PAGEALLOC
[ 1088.477183] Modules linked in:
[ 1088.477358] 
[ 1088.477467] Pid: 18941, comm: cat Not tainted (2.6.27-rc1-00649-gca5de40 #10)
[ 1088.477666] EIP: 0060:[<c04172d3>] EFLAGS: 00010293 CPU: 0
[ 1088.477797] EIP is at string+0x52/0x74
[ 1088.477919] EAX: ffffff61 EBX: c054f2fc ECX: 00000009 EDX: 00000000
[ 1088.478022] ESI: c08ea0b8 EDI: fffffffe EBP: ceac3dec ESP: ceac3ddc
[ 1088.478022]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[ 1088.478022] Process cat (pid: 18941, ti=ceac3000 task=c1640000 task.ti=ceac3000)
[ 1088.478022] Stack: ffffffff ffffffff c054f2fc ceac3f34 ceac3f14 c04175de ffffffff ffffffff 
[ 1088.478022]        00000000 3fab0d03 c054f2fc 00640000 00000100 ffffffff 00000000 ffffffff 
[ 1088.478022]        c012ff72 ceac3f38 c08484da c010487a ceac3ffc c0109e0e ceac3000 c013ba5a 
[ 1088.478022] Call Trace:
[ 1088.478022]  [<c054f2fc>] ? show_current_driver+0x0/0x4c
[ 1088.478022]  [<c04175de>] ? vsnprintf+0x2e9/0x512
[ 1088.478022]  [<c054f2fc>] ? show_current_driver+0x0/0x4c
[ 1088.478022]  [<c012ff72>] ? __kernel_text_address+0x1b/0x27
[ 1088.478022]  [<c010487a>] ? dump_trace+0xca/0xd6
[ 1088.478022]  [<c0109e0e>] ? save_stack_address+0x0/0x2c
[ 1088.478022]  [<c013ba5a>] ? trace_hardirqs_off+0xb/0xd
[ 1088.478022]  [<c0109e8b>] ? save_stack_trace+0x1c/0x3a
[ 1088.478022]  [<c013e374>] ? __lock_acquire+0xc8c/0xca8
[ 1088.478022]  [<c013b53f>] ? put_lock_stats+0xd/0x21
[ 1088.478022]  [<c054f2fc>] ? show_current_driver+0x0/0x4c
[ 1088.478022]  [<c0417824>] ? sprintf+0x1d/0x1f
[ 1088.478022]  [<c054f321>] ? show_current_driver+0x25/0x4c
[ 1088.478022]  [<c054f2fc>] ? show_current_driver+0x0/0x4c
[ 1088.478022]  [<c0480c9f>] ? sysdev_class_show+0x1c/0x20
[ 1088.478022]  [<c01b68cb>] ? sysfs_read_file+0x91/0xee
[ 1088.478022]  [<c01b683a>] ? sysfs_read_file+0x0/0xee
[ 1088.478022]  [<c017ce33>] ? vfs_read+0x8a/0x106
[ 1088.478022]  [<c017d133>] ? sys_read+0x3b/0x60
[ 1088.478022]  [<c01038bd>] ? sysenter_do_call+0x12/0x31
[ 1088.478022]  =======================
[ 1088.478022] Code: 8c 0c 00 00 f6 45 10 10 89 c1 74 0b eb 11 3b 5d f0 73 03 c6 03 20 43 4f 8d 47 01 39 c1 7c ef 31 d2 eb 0c 3b 5d f0 73 05 8a 04 32 <88> 03 43 42 39 ca 7c f0 89 f8 eb 0a 3b 5d f0 73 03 c6 03 20 43 
[ 1088.478022] EIP: [<c04172d3>] string+0x52/0x74 SS:ESP 0068:ceac3ddc
[ 1088.478022] ---[ end trace 45834e2e5edbd2a0 ]---
[ 1088.478022] note: cat[18941] exited with preempt_count 1
[ 1088.493151] BUG: scheduling while atomic: cat/18941/0x10000002
[ 1088.493287] INFO: lockdep is turned off.
[ 1088.493426] Modules linked in:
[ 1088.494109] Pid: 18941, comm: cat Tainted: G      D   2.6.27-rc1-00649-gca5de40 #10
[ 1088.494305]  [<c011f21e>] __schedule_bug+0x5d/0x64
[ 1088.494518]  [<c069c417>] schedule+0x6b/0x427
[ 1088.494738]  [<c0160e69>] ? free_hot_cold_page+0x183/0x1b4
[ 1088.495101]  [<c011f246>] __cond_resched+0x21/0x3a
[ 1088.495308]  [<c069c908>] _cond_resched+0x24/0x2f
[ 1088.495513]  [<c0168614>] unmap_vmas+0x388/0x452
[ 1088.495723]  [<c013d33f>] ? trace_hardirqs_on+0xb/0xd
[ 1088.496040]  [<c016b09a>] exit_mmap+0x57/0xd8
[ 1088.496249]  [<c0120379>] mmput+0x34/0x84
[ 1088.496454]  [<c012367d>] exit_mm+0xbe/0xc6
[ 1088.496660]  [<c012486f>] do_exit+0x1e4/0x6b4
[ 1088.496864]  [<c0122e51>] ? printk+0x15/0x17
[ 1088.497161]  [<c012201e>] ? print_oops_end_marker+0x1e/0x23
[ 1088.497428]  [<c069ed8c>] oops_end+0x82/0x8a
[ 1088.497634]  [<c0104b58>] die+0x57/0x5f
[ 1088.497837]  [<c054f2fc>] ? show_current_driver+0x0/0x4c
[ 1088.498139]  [<c06a063a>] do_page_fault+0x534/0x601
[ 1088.498345]  [<c054f2fc>] ? show_current_driver+0x0/0x4c
[ 1088.498626]  [<c06a0106>] ? do_page_fault+0x0/0x601
[ 1088.498886]  [<c069eb6a>] error_code+0x6a/0x70
[ 1088.499130]  [<c054f2fc>] ? show_current_driver+0x0/0x4c
[ 1088.499412]  [<c04172d3>] ? string+0x52/0x74
[ 1088.499673]  [<c054f2fc>] ? show_current_driver+0x0/0x4c
[ 1088.499975]  [<c04175de>] vsnprintf+0x2e9/0x512
[ 1088.500180]  [<c054f2fc>] ? show_current_driver+0x0/0x4c
[ 1088.500447]  [<c012ff72>] ? __kernel_text_address+0x1b/0x27
[ 1088.500737]  [<c010487a>] ? dump_trace+0xca/0xd6
[ 1088.501035]  [<c0109e0e>] ? save_stack_address+0x0/0x2c
[ 1088.501303]  [<c013ba5a>] ? trace_hardirqs_off+0xb/0xd
[ 1088.501585]  [<c0109e8b>] ? save_stack_trace+0x1c/0x3a
[ 1088.501849]  [<c013e374>] ? __lock_acquire+0xc8c/0xca8
[ 1088.502153]  [<c013b53f>] ? put_lock_stats+0xd/0x21
[ 1088.502434]  [<c054f2fc>] ? show_current_driver+0x0/0x4c
[ 1088.502700]  [<c0417824>] sprintf+0x1d/0x1f
[ 1088.502901]  [<c054f321>] show_current_driver+0x25/0x4c
[ 1088.503134]  [<c054f2fc>] ? show_current_driver+0x0/0x4c
[ 1088.503419]  [<c0480c9f>] sysdev_class_show+0x1c/0x20
[ 1088.503627]  [<c01b68cb>] sysfs_read_file+0x91/0xee
[ 1088.503836]  [<c01b683a>] ? sysfs_read_file+0x0/0xee
[ 1088.504135]  [<c017ce33>] vfs_read+0x8a/0x106
[ 1088.504337]  [<c017d133>] sys_read+0x3b/0x60
[ 1088.504539]  [<c01038bd>] sysenter_do_call+0x12/0x31
[ 1088.504746]  =======================

on another box i get

[ 4089.268648] BUG: unable to handle kernel paging request at 7898b450
[ 4089.268965] IP: [<c0678bd3>] show_current_driver+0x3/0x70
[ 4089.269175] *pde = 00000000 
[ 4089.269370] Oops: 0000 [#1] DEBUG_PAGEALLOC
[ 4089.269579] Modules linked in: [last unloaded: rcutorture]
[ 4089.269875] 
[ 4089.269975] Pid: 13168, comm: cat Not tainted (2.6.27-rc1 #24)
[ 4089.270106] EIP: 0060:[<c0678bd3>] EFLAGS: 00010282 CPU: 0
[ 4089.270295] EIP is at show_current_driver+0x3/0x70
[ 4089.270425] EAX: c0b74da0 EBX: cc8c9000 ECX: c0678bd0 EDX: cc8c9000
[ 4089.270559] ESI: c0b74de2 EDI: cf844cc8 EBP: c99aef3c ESP: c99aef30
[ 4089.270692]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[ 4089.270877] Process cat (pid: 13168, ti=c99ae000 task=ca52d420 task.ti=c99ae000)
[ 4089.271020] Stack: c0563d49 c9a48978 c0b74a20 c99aef6c c01e1cd1 c042cdd4 c99aef6c 00001000 
[ 4089.271746]        092b7000 c9a4898c c0b74a20 c0b74ddc c8456550 092b7000 00001000 c99aef90 
[ 4089.272528]        c0197b09 c99aef9c 00000002 00000000 c01e1c50 c8456550 fffffff7 092b7000 
[ 4089.273252] Call Trace:
[ 4089.273487]  [<c0563d49>] ? sysdev_class_show+0x29/0x40
[ 4089.273795]  [<c01e1cd1>] ? sysfs_read_file+0x81/0x110
[ 4089.274039]  [<c042cdd4>] ? security_file_permission+0x14/0x20
[ 4089.274346]  [<c0197b09>] ? vfs_read+0x99/0x160
[ 4089.274635]  [<c01e1c50>] ? sysfs_read_file+0x0/0x110
[ 4089.274927]  [<c01980e2>] ? sys_read+0x42/0x70
[ 4089.275156]  [<c0103059>] ? sysenter_do_call+0x12/0x31
[ 4089.275452]  [<c019e074>] ? __free_pipe_info+0x44/0x50
[ 4089.275750]  =======================
[ 4089.275860] Code: 00 00 8d bf 00 00 00 00 55 89 e5 e8 ac b0 a8 ff ba a4 35 b8 c0 83 c0 3c e8 db b4 b6 ff 5d c3 89 f6 8d bc 27 00 00 00 00 6e 6f 6e <65> 0a 00 0c 0f 1f 44 00 00 b8 68 35 b8 c0 89 cb e8 d8 70 1b 00 
[ 4089.277001] EIP: [<c0678bd3>] show_current_driver+0x3/0x70 SS:ESP 0068:c99aef30
[ 4089.277925] ---[ end trace 463e756b5a7abbdb ]---

it seems that in drivers/cpuidle/sysfs.c:50 cpuidle_curr_driver->name is bogus

greetings, Eric


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756267AbYILPCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267AbYILPCU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 11:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752728AbYILPCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 11:02:11 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:46170 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751326AbYILPCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 11:02:09 -0400
Date: Fri, 12 Sep 2008 17:02:06 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
cc: Cell Broadband Engine OSS Development <cbe-oss-dev@ozlabs.org>
Subject: ps3: BUG: spinlock lockup on CPU#1, udevd/505 or modprobe/633
Message-ID: <Pine.LNX.4.64.0809121654170.3735@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-1418191396-1221231348=:3735"
Content-ID: <Pine.LNX.4.64.0809121655560.20811@vixen.sonytel.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-1418191396-1221231348=:3735
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.64.0809121655561.20811@vixen.sonytel.be>

	Hi,

>From time to time, I get a lockup in udevd or modprobe when booting a recent
kernel on a PS3. Anyone with an idea what's going on, or how to investigate
this further?

Thanks!

--------------------------------------------------------------------------------
<7>usb-storage: device scan complete
<7>eth0: no IPv6 routers present
<0>BUG: spinlock lockup on CPU#1, udevd/505, c00000000062d880
Call Trace:
[c000000006b6f4a0] [c00000000000f334] .show_stack+0x70/0x184 (unreliable)
[c000000006b6f550] [c0000000001fa6c8] ._raw_spin_lock+0x138/0x174
[c000000006b6f5f0] [c00000000039b87c] .lock_kernel+0x38/0x5c
[c000000006b6f670] [c00000000011e084] .proc_lookup_de+0x34/0x144
[c000000006b6f710] [c000000000118064] .proc_root_lookup+0x28/0x70
[c000000006b6f7b0] [c0000000000c93ac] .do_lookup+0x110/0x260
[c000000006b6f870] [c0000000000cbd40] .__link_path_walk+0xa34/0xf70
[c000000006b6f960] [c0000000000cc2d4] .path_walk+0x58/0xc4
[c000000006b6fa10] [c0000000000cc4d0] .do_path_lookup+0x130/0x174
[c000000006b6fac0] [c0000000000cd284] .__path_lookup_intent_open+0x70/0xd0
[c000000006b6fb70] [c0000000000cd548] .do_filp_open+0xc4/0x7ec
[c000000006b6fd00] [c0000000000bd044] .do_sys_open+0x88/0x158
[c000000006b6fdb0] [c0000000000fe0f0] .compat_sys_open+0x24/0x38
[c000000006b6fe30] [c0000000000074dc] syscall_exit+0x0/0x40
<3>BUG: soft lockup - CPU#0 stuck for 61s! [vol_id:661]
Modules linked in: joydev evdev
irq event stamp: 141818
hardirqs last  enabled at (141817): [<c000000000007a1c>] restore+0x1c/0xe4
hardirqs last disabled at (141818): [<c000000000003600>] decrementer_common+0x100/0x180
softirqs last  enabled at (141814): [<c0000000000202bc>] .call_do_softirq+0x14/0x24
softirqs last disabled at (141809): [<c0000000000202bc>] .call_do_softirq+0x14/0x24
NIP: c000000000082270 LR: c0000000000825d8 CTR: 0000000000324f98
REGS: c00000001cbe7410 TRAP: 0901   Not tainted  (2.6.27-rc6-00036-ga551b98-dirty)
MSR: 8000000000008032 <EE,IR,DR>  CR: 42004422  XER: 20000000
TASK = c00000001cbe1440[661] 'vol_id' THREAD: c00000001cbe4000 CPU: 0
<6>GPR00: 0000000000000001 c00000001cbe7690 c000000000602c20 c00000001cbe7700 
<6>GPR04: 0000000000000000 0000000000000000 0000000000000000 0000000000000000 
<6>GPR08: 0000000000000000 0000000000000001 0000000000000000 c00000000003add8 
<6>GPR12: 8000000000008032 c000000000635300 
NIP [c000000000082270] .csd_flag_wait+0x4/0x1c
LR [c0000000000825d8] .smp_call_function_single+0x13c/0x164
Call Trace:
[c00000001cbe7690] [c0000000000825d8] .smp_call_function_single+0x13c/0x164 (unreliable)
[c00000001cbe7750] [c0000000000826e4] .smp_call_function_mask+0xe4/0x240
[c00000001cbe78b0] [c000000000056780] .on_each_cpu+0x24/0x94
[c00000001cbe7950] [c0000000000ebc1c] .invalidate_bh_lrus+0x24/0x3c
[c00000001cbe79d0] [c0000000000f2ca4] .kill_bdev+0x2c/0x58
[c00000001cbe7a50] [c0000000000f36b4] .__blkdev_put+0x94/0x1d4
[c00000001cbe7af0] [c0000000000c0684] .__fput+0x114/0x1fc
[c00000001cbe7ba0] [c0000000000bcf04] .filp_close+0xac/0xd4
[c00000001cbe7c30] [c000000000052e24] .put_files_struct+0xb4/0x13c
[c00000001cbe7cd0] [c0000000000549b4] .do_exit+0x244/0x7c0
[c00000001cbe7da0] [c000000000054fc4] .do_group_exit+0x94/0xc8
[c00000001cbe7e30] [c0000000000074dc] syscall_exit+0x0/0x40
Instruction dump:
7d005828 7c00592d 40a2fff8 4c00012c 2f880000 3860fff0 409e000c 38600000 
f88b0008 ebc1fff0 4e800020 7c0004ac <80030020> 780907e1 4d820020 7c210b78 
<3>BUG: soft lockup - CPU#1 stuck for 61s! [udevd:505]
Modules linked in: joydev evdev
irq event stamp: 201170
hardirqs last  enabled at (201169): [<c000000000007a1c>] restore+0x1c/0xe4
hardirqs last disabled at (201170): [<c000000000003600>] decrementer_common+0x100/0x180
softirqs last  enabled at (201168): [<c0000000000202bc>] .call_do_softirq+0x14/0x24
softirqs last disabled at (201163): [<c0000000000202bc>] .call_do_softirq+0x14/0x24
NIP: c00000000001c604 LR: c0000000001fa688 CTR: 000000000032ea98
REGS: c000000006b6f2d0 TRAP: 0901   Not tainted  (2.6.27-rc6-00036-ga551b98-dirty)
MSR: 8000000000008032 <EE,IR,DR>  CR: 82000424  XER: 20000000
TASK = c00000000686c5c0[505] 'udevd' THREAD: c000000006b6c000 CPU: 1
<6>GPR00: 0000000080000001 c000000006b6f550 c000000000602c20 0000000000000001 
<6>GPR04: c00000000686c5c0 0000000000000070 0000000000000000 0000000000000000 
<6>GPR08: 0000000000000000 00000002281dfb6f 0000000000000001 0000000000000008 
<6>GPR12: 8000000000000032 c000000000635500 
NIP [c00000000001c604] .__delay+0x4/0x34
LR [c0000000001fa688] ._raw_spin_lock+0xf8/0x174
Call Trace:
[c000000006b6f550] [c0000000001fa6c8] ._raw_spin_lock+0x138/0x174 (unreliable)
[c000000006b6f5f0] [c00000000039b87c] .lock_kernel+0x38/0x5c
[c000000006b6f670] [c00000000011e084] .proc_lookup_de+0x34/0x144
[c000000006b6f710] [c000000000118064] .proc_root_lookup+0x28/0x70
[c000000006b6f7b0] [c0000000000c93ac] .do_lookup+0x110/0x260
[c000000006b6f870] [c0000000000cbd40] .__link_path_walk+0xa34/0xf70
[c000000006b6f960] [c0000000000cc2d4] .path_walk+0x58/0xc4
[c000000006b6fa10] [c0000000000cc4d0] .do_path_lookup+0x130/0x174
[c000000006b6fac0] [c0000000000cd284] .__path_lookup_intent_open+0x70/0xd0
[c000000006b6fb70] [c0000000000cd548] .do_filp_open+0xc4/0x7ec
[c000000006b6fd00] [c0000000000bd044] .do_sys_open+0x88/0x158
[c000000006b6fdb0] [c0000000000fe0f0] .compat_sys_open+0x24/0x38
[c000000006b6fe30] [c0000000000074dc] syscall_exit+0x0/0x40
Instruction dump:
7c0803a6 eb010080 eb210088 eb410090 eb610098 eb8100a0 eba100a8 ebc100b0 
ebe100b8 382100c0 4e800020 7d2c42e6 <2c090000> 41a2fff8 48000008 7c210b78 
--------------------------------------------------------------------------------



--------------------------------------------------------------------------------
<7>usb-storage: device scan complete
<7>eth0: no IPv6 routers present
<0>BUG: spinlock lockup on CPU#1, modprobe/633, c000000000629880
Call Trace:
[c00000001cb376c0] [c00000000000f450] .show_stack+0x70/0x184 (unreliable)
[c00000001cb37770] [c0000000001f9c14] ._raw_spin_lock+0x138/0x174
[c00000001cb37810] [c00000000039ab9c] .lock_kernel+0x38/0x5c
[c00000001cb37890] [c0000000001169cc] .de_put+0x20/0x94
[c00000001cb37910] [c000000000116aa4] .proc_delete_inode+0x64/0xa0
[c00000001cb379a0] [c0000000000d85a4] .generic_delete_inode+0x120/0x1c0
[c00000001cb37a30] [c0000000000d752c] .iput+0x88/0xa4
[c00000001cb37ab0] [c0000000000d3e14] .dentry_iput+0xf0/0x130
[c00000001cb37b40] [c0000000000d3f98] .d_kill+0x44/0x84
[c00000001cb37bd0] [c0000000000d5bf4] .dput+0x1c0/0x1e4
[c00000001cb37c60] [c0000000000bfc78] .__fput+0x1b4/0x1fc
[c00000001cb37d10] [c0000000000bc458] .filp_close+0xac/0xd4
[c00000001cb37da0] [c0000000000bdd54] .sys_close+0xac/0xf8
[c00000001cb37e30] [c0000000000076dc] syscall_exit+0x0/0x40
<3>BUG: soft lockup - CPU#0 stuck for 61s! [vol_id:660]
Modules linked in: evdev
irq event stamp: 142218
hardirqs last  enabled at (142217): [<c000000000007c1c>] restore+0x1c/0xe4
hardirqs last disabled at (142218): [<c000000000003600>] decrementer_common+0x100/0x180
softirqs last  enabled at (142214): [<c00000000001ff50>] .call_do_softirq+0x14/0x24
softirqs last disabled at (142209): [<c00000000001ff50>] .call_do_softirq+0x14/0x24
NIP: c0000000000817c8 LR: c000000000081b2c CTR: 0000000000324f98
REGS: c00000001cbc3410 TRAP: 0901   Not tainted  (2.6.27-rc6-00036-ga551b98-dirty)
MSR: 8000000000008032 <EE,IR,DR>  CR: 42004422  XER: 20000000
TASK = c00000001cbbdd40[660] 'vol_id' THREAD: c00000001cbc0000 CPU: 0
<6>GPR00: 0000000000000001 c00000001cbc3690 c000000000600160 c00000001cbc3700 
<6>GPR04: 0000000000000000 0000000000000000 0000000000000000 0000000000000000 
<6>GPR08: 0000000000000000 0000000000000001 0000000000000000 c00000000003aa58 
<6>GPR12: 8000000000008032 c000000000631300 
NIP [c0000000000817c8] .csd_flag_wait+0x8/0x1c
LR [c000000000081b2c] .smp_call_function_single+0x13c/0x164
Call Trace:
[c00000001cbc3690] [c000000000081b2c] .smp_call_function_single+0x13c/0x164 (unreliable)
[c00000001cbc3750] [c000000000081c38] .smp_call_function_mask+0xe4/0x240
[c00000001cbc38b0] [c000000000055cd4] .on_each_cpu+0x24/0x94
[c00000001cbc3950] [c0000000000eb170] .invalidate_bh_lrus+0x24/0x3c
[c00000001cbc39d0] [c0000000000f21f8] .kill_bdev+0x2c/0x58
[c00000001cbc3a50] [c0000000000f2c08] .__blkdev_put+0x94/0x1d4
[c00000001cbc3af0] [c0000000000bfbd8] .__fput+0x114/0x1fc
[c00000001cbc3ba0] [c0000000000bc458] .filp_close+0xac/0xd4
[c00000001cbc3c30] [c000000000052378] .put_files_struct+0xb4/0x13c
[c00000001cbc3cd0] [c000000000053f08] .do_exit+0x244/0x7c0
[c00000001cbc3da0] [c000000000054518] .do_group_exit+0x94/0xc8
[c00000001cbc3e30] [c0000000000076dc] syscall_exit+0x0/0x40
Instruction dump:
7c00592d 40a2fff8 4c00012c 2f880000 3860fff0 409e000c 38600000 f88b0008 
ebc1fff0 4e800020 7c0004ac 80030020 <780907e1> 4d820020 7c210b78 7c421378 
<3>BUG: soft lockup - CPU#1 stuck for 61s! [modprobe:633]
Modules linked in: evdev
irq event stamp: 130276
hardirqs last  enabled at (130275): [<c000000000007c1c>] restore+0x1c/0xe4
hardirqs last disabled at (130276): [<c000000000003600>] decrementer_common+0x100/0x180
softirqs last  enabled at (130274): [<c00000000001ff50>] .call_do_softirq+0x14/0x24
softirqs last disabled at (130269): [<c00000000001ff50>] .call_do_softirq+0x14/0x24
NIP: c00000000001c444 LR: c0000000001f9bd4 CTR: 000000000032ea98
REGS: c00000001cb374f0 TRAP: 0901   Not tainted  (2.6.27-rc6-00036-ga551b98-dirty)
MSR: 8000000000008032 <EE,IR,DR>  CR: 82000424  XER: 00000000
TASK = c000000006b917c0[633] 'modprobe' THREAD: c00000001cb34000 CPU: 1
<6>GPR00: 0000000080000001 c00000001cb37770 c000000000600160 0000000000000001 
<6>GPR04: c000000006b917c0 0000000000000070 0000000000000000 0000000000000000 
<6>GPR08: 0000000000000000 00000002b85bacd2 0000000000000001 0000000000000008 
<6>GPR12: 8000000000000032 c000000000631500 
NIP [c00000000001c444] .__delay+0x4/0x34
LR [c0000000001f9bd4] ._raw_spin_lock+0xf8/0x174
Call Trace:
[c00000001cb37770] [c0000000001f9c14] ._raw_spin_lock+0x138/0x174 (unreliable)
[c00000001cb37810] [c00000000039ab9c] .lock_kernel+0x38/0x5c
[c00000001cb37890] [c0000000001169cc] .de_put+0x20/0x94
[c00000001cb37910] [c000000000116aa4] .proc_delete_inode+0x64/0xa0
[c00000001cb379a0] [c0000000000d85a4] .generic_delete_inode+0x120/0x1c0
[c00000001cb37a30] [c0000000000d752c] .iput+0x88/0xa4
[c00000001cb37ab0] [c0000000000d3e14] .dentry_iput+0xf0/0x130
[c00000001cb37b40] [c0000000000d3f98] .d_kill+0x44/0x84
[c00000001cb37bd0] [c0000000000d5bf4] .dput+0x1c0/0x1e4
[c00000001cb37c60] [c0000000000bfc78] .__fput+0x1b4/0x1fc
[c00000001cb37d10] [c0000000000bc458] .filp_close+0xac/0xd4
[c00000001cb37da0] [c0000000000bdd54] .sys_close+0xac/0xf8
[c00000001cb37e30] [c0000000000076dc] syscall_exit+0x0/0x40
Instruction dump:
7c0803a6 eb010080 eb210088 eb410090 eb610098 eb8100a0 eba100a8 ebc100b0 
ebe100b8 382100c0 4e800020 7d2c42e6 <2c090000> 41a2fff8 48000008 7c210b78 

--------------------------------------------------------------------------------


With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
---584349381-1418191396-1221231348=:3735--

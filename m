Return-Path: <linux-kernel-owner+w=401wt.eu-S1754004AbXIQNEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004AbXIQNEM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 09:04:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbXIQND4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 09:03:56 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:59265 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbXIQNDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 09:03:55 -0400
Message-ID: <46EE7026.2070203@linux.vnet.ibm.com>
Date: Mon, 17 Sep 2007 17:46:38 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [2.6.23-rc4-mm1][Bug] kernel BUG at include/linux/netdevice.h:339!
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Kernel Bug is hit with 2.6.23-rc4-mm1 kernel on ppc64 machine.

kernel BUG at include/linux/netdevice.h:339!
Oops: Exception in kernel mode, sig: 5 [#1]
SMP NR_CPUS=128 NUMA pSeries
Modules linked in: ipv6 binfmt_misc dm_mirror dm_mod sr_mod sg st
NIP: c00000000035e980 LR: c00000000035e960 CTR: 0000000000000000
REGS: c00000000ffffaa0 TRAP: 0700   Not tainted  (2.6.23-rc4-mm1-autokern1)
MSR: 8000000000029032 <EE,ME,IR,DR>  CR: 24008824  XER: 20000018
TASK = c000000006789fc0[22628] 'growfiles' THREAD: c00000000b870000 CPU: 0
GPR00: 0000000000000001 c00000000ffffd20 c0000000007338f8 0000000000000001 
GPR04: 0000000000000000 ffffffffffffffff 800000000270ea00 0000000000000000 
GPR08: 0000000000000004 0000000000000000 0000000000000000 8000000000135d10 
GPR12: 0000000000004000 c000000000646280 00000000100df9d8 00000000100faf88 
GPR16: 00000000ffffffff 00000000ffffffff 00000000ffff9008 0000000000000000 
GPR20: 0000000000000000 000000000ff56ff8 0000000000000167 0000000000000002 
GPR24: 0000000000000000 c000000000604b90 c000000003121000 c000000003121790 
GPR28: 000000000000012c 0000000000000000 c0000000006eb660 c000000003121780 
NIP [c00000000035e980] .ibmveth_poll+0x144/0x448
LR [c00000000035e960] .ibmveth_poll+0x124/0x448
Call Trace:
[c00000000ffffd20] [c00000000035e948] .ibmveth_poll+0x10c/0x448 (unreliable)
[c00000000ffffe00] [c00000000040496c] .net_rx_action+0x174/0x29c
[c00000000ffffed0] [c00000000005d5e0] .__do_softirq+0xdc/0x194
[c00000000fffff90] [c0000000000265f0] .call_do_softirq+0x14/0x24
[c00000000b873c90] [c00000000000bc70] .do_softirq+0xb4/0xc0
[c00000000b873d20] [c00000000005d74c] .irq_exit+0x70/0x88
[c00000000b873da0] [c00000000000b9d8] .do_IRQ+0x100/0x204
[c00000000b873e30] [c000000000004780] hardware_interrupt_entry+0x18/0x98
Instruction dump:
38a00001 38600104 80890010 4bcd97c5 60000000 38000000 886d01da 980d01da 
e93b0010 792007e1 7c000026 54001ffe <0b000000> 7c0004ac 3ba00001 381b0010 
Kernel panic - not syncing: Fatal exception in interrupt

------------[ cut here ]------------
Badness at arch/powerpc/kernel/smp.c:202
NIP: c000000000028648 LR: c000000000055060 CTR: 80000000000f97dc
REGS: c00000000ffff4b0 TRAP: 0700   Tainted: G      D  (2.6.23-rc4-mm1-autokern1)
MSR: 8000000000021032 <ME,IR,DR>  CR: 22008822  XER: 0000000a
TASK = c000000006789fc0[22628] 'growfiles' THREAD: c00000000b870000 CPU: 0
GPR00: 0000000000000001 c00000000ffff730 c0000000007338f8 c0000000006f14b8 
GPR04: 0000000000000000 0000000000000001 0000000000000000 0000000000000003 
GPR08: 0000000000000000 0000000000000000 00000000000041eb c0000000008259c0 
GPR12: 0000000022008822 c000000000646280 00000000100df9d8 00000000100faf88 
GPR16: 00000000ffffffff 00000000ffffffff 00000000ffff9008 0000000000000000 
GPR20: 0000000000000000 000000000ff56ff8 0000000000000167 0000000000000002 
GPR24: 0000000000000000 c000000000604b90 0000000000000005 ffffffffffffffff 
GPR28: c00000000ffffaa0 c00000000052b118 c0000000006d9d68 0000000000000000 
NIP [c000000000028648] .smp_call_function_map+0x40/0x2c0
LR [c000000000055060] .panic+0x84/0x19c
Call Trace:
[c00000000ffff730] [0000000000000005] 0x5 (unreliable)
[c00000000ffff7f0] [c000000000055060] .panic+0x84/0x19c
[c00000000ffff880] [c0000000000244b4] .die+0x1c4/0x234
[c00000000ffff920] [c00000000002456c] ._exception+0x48/0x13c
[c00000000ffffa30] [c000000000004a84] program_check_common+0x104/0x180
--- Exception: 700 at .ibmveth_poll+0x144/0x448
    LR = .ibmveth_poll+0x124/0x448
[c00000000ffffd20] [c00000000035e948] .ibmveth_poll+0x10c/0x448 (unreliable)
[c00000000ffffe00] [c00000000040496c] .net_rx_action+0x174/0x29c
[c00000000ffffed0] [c00000000005d5e0] .__do_softirq+0xdc/0x194
[c00000000fffff90] [c0000000000265f0] .call_do_softirq+0x14/0x24
[c00000000b873c90] [c00000000000bc70] .do_softirq+0xb4/0xc0
[c00000000b873d20] [c00000000005d74c] .irq_exit+0x70/0x88
[c00000000b873da0] [c00000000000b9d8] .do_IRQ+0x100/0x204
[c00000000b873e30] [c000000000004780] hardware_interrupt_entry+0x18/0x98
Instruction dump:
fba1ffe8 fbc1fff0 3b60ffff fbe1fff8 f8010010 91810008 f821ff41 f8e10110 
f9010118 880d01da 21200000 7c090114 <0b000000> eb82a488 e81c0000 2fa00000 

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.


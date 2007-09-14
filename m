Return-Path: <linux-kernel-owner+w=401wt.eu-S1754776AbXINKGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbXINKGv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 06:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752511AbXINKGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 06:06:43 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:39810 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbXINKGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 06:06:41 -0400
Message-ID: <46EA5CEB.7020104@linux.vnet.ibm.com>
Date: Fri, 14 Sep 2007 15:35:31 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
CC: paulus@samba.org, Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: [BUG][2.6.23-rc6] Badness at arch/powerpc/kernel/smp.c:202
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With 2.6.23-rc6 running on the ppc64 box, following oops is hit

Oops: Machine check, sig: 7 [#1]

SMP NR_CPUS=128 pSeries

Modules linked in: binfmt_misc ipv6 dm_mod ehci_hcd ohci_hcd usbcore

NIP: c0000000000ed560 LR: c0000000000efc7c CTR: c0000000000ed504

REGS: c00000000ffef680 TRAP: 0200   Not tainted  (2.6.23-rc6-autokern1)

MSR: 8000000000109032 <EE,ME,IR,DR>  CR: 28002042  XER: 00000010

TASK = c0000000ecf9f000[0] 'swapper' THREAD: c00000000ff8c000 CPU: 2

GPR00: 0000000000000000 c00000000ffef900 c0000000006fe598 c0000000d7a8f200 

GPR04: 0000000000001000 0000000000000000 0000000000001000 8000000000c26393 

GPR08: c0000000006b43d0 0000000000000001 0000000000001000 0000000000000000 

GPR12: 0000000048000048 c0000000005f1700 0000000000000000 0000000007a8dcd0 

GPR16: 0000000000000002 0000000000000000 0000000000000000 0000000000000000 

GPR20: 0000000000000000 0000000000001000 0000000000001000 0000000000000000 

GPR24: 0000000000000000 0000000000000000 0000000000001000 c0000000063234e8 

GPR28: 0000000000001000 0000000000000000 c000000000689c08 c00000000ff3a480 

NIP [c0000000000ed560] .end_bio_bh_io_sync+0x5c/0xac

LR [c0000000000efc7c] .bio_endio+0xb4/0xd4

Call Trace:

[c00000000ffef900] [c00000000ffef990] 0xc00000000ffef990 (unreliable)

[c00000000ffef980] [c0000000000efc7c] .bio_endio+0xb4/0xd4

[c00000000ffefa10] [c000000000290060] .__end_that_request_first+0x154/0x548

[c00000000ffefae0] [c00000000035af10] .scsi_end_request+0x40/0x138

[c00000000ffefb80] [c00000000035b234] .scsi_io_completion+0x188/0x454

[c00000000ffefc60] [c000000000372a24] .sd_rw_intr+0x2e4/0x338

[c00000000ffefd30] [c000000000354548] .scsi_finish_command+0xbc/0xe0

[c00000000ffefdc0] [c00000000035bdf0] .scsi_softirq_done+0x140/0x188

[c00000000ffefe60] [c000000000293184] .blk_done_softirq+0xa0/0xd0

[c00000000ffefef0] [c000000000055e1c] .__do_softirq+0xa8/0x164

[c00000000ffeff90] [c000000000023f14] .call_do_softirq+0x14/0x24

[c00000000ff8f960] [c00000000000bd30] .do_softirq+0x68/0xac

[c00000000ff8f9f0] [c000000000055f70] .irq_exit+0x54/0x6c

[c00000000ff8fa70] [c00000000000c358] .do_IRQ+0x170/0x1ac

[c00000000ff8fb00] [c000000000004780] hardware_interrupt_entry+0x18/0x98

--- Exception: 501 at .pseries_dedicated_idle_sleep+0xe0/0x194

    LR = .pseries_dedicated_idle_sleep+0xd0/0x194

[c00000000ff8fdf0] [0000000000000000] .__start+0x4000000000000000/0x8 (unreliable)

[c00000000ff8fe80] [c000000000010bd4] .cpu_idle+0x104/0x1d8

[c00000000ff8ff00] [c00000000002672c] .start_secondary+0x160/0x184

[c00000000ff8ff90] [c000000000008364] .start_secondary_prolog+0xc/0x10

Instruction dump:

409a0030 393f0018 38000080 7d6048a8 7d6b0378 7d6049ad 40a2fff4 38002000 

7d2018a8 7d290378 7d2019ad 40a2fff4 <e9230038> e89f0018 e9690000 f8410028 

Kernel panic - not syncing: Fatal exception in interrupt

------------[ cut here ]------------

Badness at arch/powerpc/kernel/smp.c:202

NIP: c000000000026024 LR: c00000000004e378 CTR: 800000000013f270

REGS: c00000000ffef120 TRAP: 0700   Tainted: G      D  (2.6.23-rc6-autokern1)

MSR: 8000000000021032 <ME,IR,DR>  CR: 22002022  XER: 0000000a

TASK = c0000000ecf9f000[0] 'swapper' THREAD: c00000000ff8c000 CPU: 2

GPR00: 0000000000000001 c00000000ffef3a0 c0000000006fe598 c00000000069ffb8 

GPR04: 0000000000000000 0000000000000001 0000000000000000 0000000000000007 

GPR08: 0000000000000000 c000000000739818 c000000000742998 c00000000069ffb8 

GPR12: 0000000000004000 c0000000005f1700 0000000000000000 0000000007a8dcd0 

GPR16: 0000000000000002 0000000000000000 0000000000000000 0000000000000000 

GPR20: 0000000000000000 0000000000001000 0000000000001000 0000000000000000 

GPR24: 0000000000000000 0000000000000000 0000000000001000 0000000000000007 

GPR28: c0000000004e3190 0000000000000000 c000000000685b80 0000000000000000 

NIP [c000000000026024] .smp_call_function_map+0x34/0x28c

LR [c00000000004e378] .panic+0x98/0x1b0

Call Trace:

[c00000000ffef3a0] [c0000000006943e8] 0xc0000000006943e8 (unreliable)

[c00000000ffef450] [c00000000004e378] .panic+0x98/0x1b0

[c00000000ffef4f0] [c00000000002213c] .die+0x224/0x264

[c00000000ffef590] [c0000000000231f0] .machine_check_exception+0x210/0x240

[c00000000ffef610] [c000000000003480] machine_check_common+0x100/0x180

--- Exception: 200 at .end_bio_bh_io_sync+0x5c/0xac

    LR = .bio_endio+0xb4/0xd4

[c00000000ffef900] [c00000000ffef990] 0xc00000000ffef990 (unreliable)

[c00000000ffef980] [c0000000000efc7c] .bio_endio+0xb4/0xd4

[c00000000ffefa10] [c000000000290060] .__end_that_request_first+0x154/0x548

[c00000000ffefae0] [c00000000035af10] .scsi_end_request+0x40/0x138

[c00000000ffefb80] [c00000000035b234] .scsi_io_completion+0x188/0x454

[c00000000ffefc60] [c000000000372a24] .sd_rw_intr+0x2e4/0x338

[c00000000ffefd30] [c000000000354548] .scsi_finish_command+0xbc/0xe0

[c00000000ffefdc0] [c00000000035bdf0] .scsi_softirq_done+0x140/0x188

[c00000000ffefe60] [c000000000293184] .blk_done_softirq+0xa0/0xd0

[c00000000ffefef0] [c000000000055e1c] .__do_softirq+0xa8/0x164

[c00000000ffeff90] [c000000000023f14] .call_do_softirq+0x14/0x24

[c00000000ff8f960] [c00000000000bd30] .do_softirq+0x68/0xac

[c00000000ff8f9f0] [c000000000055f70] .irq_exit+0x54/0x6c

[c00000000ff8fa70] [c00000000000c358] .do_IRQ+0x170/0x1ac

[c00000000ff8fb00] [c000000000004780] hardware_interrupt_entry+0x18/0x98

--- Exception: 501 at .pseries_dedicated_idle_sleep+0xe0/0x194

    LR = .pseries_dedicated_idle_sleep+0xd0/0x194

[c00000000ff8fdf0] [0000000000000000] .__start+0x4000000000000000/0x8 (unreliable)

[c00000000ff8fe80] [c000000000010bd4] .cpu_idle+0x104/0x1d8

[c00000000ff8ff00] [c00000000002672c] .start_secondary+0x160/0x184

[c00000000ff8ff90] [c000000000008364] .start_secondary_prolog+0xc/0x10

Instruction dump:

fba1ffe8 fbc1fff0 fbe1fff8 7c6b1b78 f8010010 f821ff51 7cdd3378 f8e10100 

f9010108 880d01da 7c000074 7800d182 <0b000000> e922a500 3860ffff e8090000 


I tired googling for similar bug and found two which where earlier reported one
at linuxppc-dev mailing list on 2.6.23-rc1 kernel

http://ozlabs.org/pipermail/linuxppc-dev/2007-July/039905.html

and other on 2.6.22-rc1 kernel

http://lkml.org/lkml/2007/5/22/390


-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756545AbYLaQOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545AbYLaQOA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 11:14:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755782AbYLaQNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 11:13:51 -0500
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:59382 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923AbYLaQNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 11:13:50 -0500
Date: Wed, 31 Dec 2008 21:43:41 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, mel@csn.ul.ie
Subject: [BUG] next-20081231 -powerpc - panic at tasklet_kill_immediate()
Message-ID: <20081231161341.GD4268@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20090101003258.eaa44700.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090101003258.eaa44700.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

	next-20081231 kernel panic's, while booting up on powerpc. This
panic was visible in next-20081230 kernel also.

[    1.268844] Brought up 2 CPUs
[    1.268873] Unable to handle kernel paging request for data at address 0x00000009
[    1.268876] Faulting instruction address: 0xc00000000005a9f8
[    1.268880] Oops: Kernel access of bad area, sig: 11 [#1]
[    1.268882] SMP NR_CPUS=32 NUMA PowerMac
[    1.268886] Modules linked in:
[    1.268889] NIP: c00000000005a9f8 LR: c00000000006ee54 CTR: c00000000005a9c0
[    1.268893] REGS: c0000002763c3c80 TRAP: 0300   Not tainted  (2.6.28-next-20081231-autokern1)
[    1.268896] MSR: 9000000000009032 <EE,ME,IR,DR>  CR: 24000024  XER: 000fffff
[    1.268903] DAR: 0000000000000009, DSISR: 0000000040000000
[    1.268905] TASK = c0000002760e20c0[5] 'ksoftirqd/1' THREAD: c0000002763c0000 CPU: 1
[    1.268908] GPR00: 0000000000000000 c0000002763c3f00 c0000000004f9088 0000000000000001 
[    1.268913] GPR04: c0000002760e28d0 0000000000000000 0000000024000022 c000000000010098 
[    1.268917] GPR08: 0000000000000000 000000000ec1c518 c000000000514a40 0000000000000010 
[    1.268922] GPR12: c00000000051c700 c00000000051c500 0000000000000000 0000000000000000 
[    1.268926] GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000 
[    1.268930] GPR20: 0000000000000000 0000000000000000 0000000000000000 0000000001400000 
[    1.268934] GPR24: 0000000001829d88 c000000000429b28 0000000001400000 0000000000000000 
[    1.268939] GPR28: c0000002760bfc48 0000000000000001 c000000000498a98 c0000000004b0150 
[    1.268950] NIP [c00000000005a9f8] .tasklet_kill_immediate+0x38/0xb8
[    1.268955] LR [c00000000006ee54] .kthread+0x78/0xc4
[    1.268957] Call Trace:
[    1.268960] [c0000002763c3f00] [c00000000006ee1c] .kthread+0x40/0xc4 (unreliable)
[    1.268967] [c0000002763c3f90] [c0000000000227a8] .kernel_thread+0x54/0x70
[    1.268969] Instruction dump:
[    1.268971] 7c8b07b4 7d693670 7d290194 556b06be e95e8040 7d2907b4 79291f24 e94a0000 
[    1.268977] 7c0a482a 7c005c36 780007e0 0b000000 <e8030008> 7800ffe2 0b000000 e8030008 
[    1.268992] ---[ end trace 31fd0ba7d8756001 ]---
[    1.269016] Unable to handle kernel paging request for data at address 0x00000000
[    1.269019] Faulting instruction address: 0xc0000000000d9b4c
[    1.269022] Oops: Kernel access of bad area, sig: 11 [#2]
[    1.269024] SMP NR_CPUS=32 NUMA PowerMac
[    1.269026] Modules linked in:
[    1.269029] NIP: c0000000000d9b4c LR: c0000000000511fc CTR: 0000000000000003
[    1.269032] REGS: c0000002763c35d0 TRAP: 0300   Tainted: G      D     (2.6.28-next-20081231-autokern1)
[    1.269035] MSR: 9000000000009032 <EE,ME,IR,DR>  CR: 28004082  XER: 200fffff
[    1.269040] DAR: 0000000000000000, DSISR: 0000000040000000
[    1.269043] TASK = c0000002760e20c0[5] 'ksoftirqd/1' THREAD: c0000002763c0000 CPU: 1
[    1.269046] GPR00: 0000000000000004 c0000002763c3850 c0000000004f9088 c000000276027d00 
[    1.269051] GPR04: c0000002763b6980 0000000000000000 c000000000457278 c000000000457278 
[    1.269055] GPR08: c0000002760e2290 0000000000000000 c00000000051c500 c0000002763b6080 
[    1.269060] GPR12: 0000000048000084 c00000000051c500 0000000000000000 0000000000000000 
[    1.269064] GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000 
[    1.269068] GPR20: 0000000000000000 0000000000000000 0000000000000000 0000000000000001 
[    1.269073] GPR24: c0000002760e20b0 c0000002760e2228 0000000000000000 c000000276027d00 
[    1.269077] GPR28: 0000000000000000 c0000002763b6980 c00000000049c9b8 0000000000000000 
[    1.269086] NIP [c0000000000d9b4c] .kmem_cache_free+0x1b8/0x244
[    1.269090] LR [c0000000000511fc] .__cleanup_sighand+0x44/0x5c
[    1.269092] Call Trace:
[    1.269095] [c0000002763c3850] [c00000000049abe8] 0xc00000000049abe8 (unreliable)
[    1.269099] [c0000002763c3900] [c0000000000511fc] .__cleanup_sighand+0x44/0x5c
[    1.269104] [c0000002763c3980] [c000000000057244] .release_task+0x2dc/0x400
[    1.269108] [c0000002763c3a20] [c000000000057b14] .do_exit+0x7ac/0x858
[    1.269112] [c0000002763c3af0] [c000000000020414] .die+0x1c8/0x1cc
[    1.269117] [c0000002763c3b90] [c000000000027f4c] .bad_page_fault+0xb8/0xd4
[    1.269122] [c0000002763c3c10] [c000000000005318] handle_page_fault+0x3c/0x5c
[    1.269128] --- Exception: 300 at .tasklet_kill_immediate+0x38/0xb8
[    1.269130]     LR = .kthread+0x78/0xc4
[    1.269133] [c0000002763c3f00] [c00000000006ee1c] .kthread+0x40/0xc4 (unreliable)
[    1.269138] [c0000002763c3f90] [c0000000000227a8] .kernel_thread+0x54/0x70
[    1.269141] Instruction dump:
[    1.269142] 4800016d e97d0168 880d01dc 2fa00000 41be0010 7c0004ac 38000000 980d01dc 
[    1.269148] 7c2004ac 38000000 900b0040 48000050 <817f0000> 801f0004 7f8b0040 409c001c 
[    1.269155] ---[ end trace 31fd0ba7d8756001 ]---
[    1.269157] Fixing recursive fault but reboot is needed!
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.

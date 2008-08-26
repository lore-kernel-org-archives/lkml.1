Return-Path: <linux-kernel-owner+w=401wt.eu-S1758757AbYHZS2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758757AbYHZS2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 14:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757460AbYHZS2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 14:28:07 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:40637 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373AbYHZS2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 14:28:05 -0400
Message-ID: <48B44B2D.8070809@linux.vnet.ibm.com>
Date: Tue, 26 Aug 2008 23:57:57 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080724)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, arjan@linux.intel.com, mingo@elte.hu,
       Andy Whitcroft <apw@shadowen.org>
Subject: [BUG] linux-next: Tree for August 26 - Badness at kernel/notifier.c:25
References: <20080826184008.6be39f19.sfr@canb.auug.org.au>
In-Reply-To: <20080826184008.6be39f19.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Badness warning is seen, while booting up the next-20080825/26 kernels on 
the powerpc boxes

Badness at kernel/notifier.c:25
NIP: c000000000075bfc LR: c000000000075bf0 CTR: 0000000000000000
REGS: c000000000843a80 TRAP: 0700   Not tainted  (2.6.27-rc4-next-20080826-autokern1)
MSR: 8000000000021032 <ME,IR,DR>  CR: 44000082  XER: 00000000
TASK = c000000000762b40[0] 'swapper' THREAD: c000000000840000 CPU: 0
GPR00: c000000000075bf0 c000000000843d00 c000000000842148 0000000000000000 
GPR04: c000000000763d28 c000000000634ae0 0000000020000000 0000000000000000 
GPR08: 0000000000000000 ffffffffffffffff c0000000007f96f8 c0000000007f96f8 
GPR12: 3330303030303033 c0000000008c4300 0000000000000000 c000000000636720 
GPR16: 4000000002100000 c000000000634fb8 0000000000000000 0000000000246c00 
GPR20: 0000000002819298 c000000000719298 0000000002819508 c000000000719508 
GPR24: 0000000002c00000 c0000000006361d0 0000000000000000 0000000000000004 
GPR28: 0000000000010000 c000000000763d28 c0000000007d72b0 c000000000763d20 
NIP [c000000000075bfc] .notifier_chain_register+0x30/0x80
LR [c000000000075bf0] .notifier_chain_register+0x24/0x80
Call Trace:
[c000000000843d00] [c000000000075bf0] .notifier_chain_register+0x24/0x80 (unreliable)
[c000000000843d90] [c000000000037c04] .pSeries_reconfig_notifier_register+0x18/0x2c
[c000000000843e00] [c00000000003845c] .iommu_init_early_pSeries+0xe8/0x108
[c000000000843e70] [c0000000006f8954] .pSeries_init_early+0x68/0x80
[c000000000843ef0] [c0000000006ecd9c] .setup_system+0x204/0x398
[c000000000843f90] [c0000000000084fc] .start_here_common+0x2c/0xb0
Instruction dump:
7c0802a6 fba1ffe8 fbe1fff8 7c7f1b78 e8640000 7c9d2378 f8010010 f821ff71 
4bff77c5 60000000 2fa30000 409e0020 <0fe00000> 48000030 801d0010 812b0010 
console [udbg0] enabled
Partition configured for 8 cpus.
CPU maps initialized for 2 threads per core
Starting Linux PPC64 #1 SMP Tue Aug 26 12:55:19 EDT 2008
-----------------------------------------------------
ppc64_pft_size                = 0x19
physicalMemorySize            = 0x80000000
htab_hash_mask                = 0x3ffff
-----------------------------------------------------
Initializing cgroup subsys cpuset
------------[ cut here ]------------
Badness at kernel/notifier.c:25
NIP: c000000000075bfc LR: c000000000075bf0 CTR: c00000000009145c
REGS: c000000000843ac0 TRAP: 0700   Tainted: G        W  (2.6.27-rc4-next-20080826-autokern1)
MSR: 8000000000021032 <ME,IR,DR>  CR: 22000022  XER: 00000001
TASK = c000000000762b40[0] 'swapper' THREAD: c000000000840000 CPU: 0
GPR00: c000000000075bf0 c000000000843d40 c000000000842148 0000000000000000 
GPR04: c00000000077f1a0 c00000000090bd00 c00000000074dc50 0000000000067430 
GPR08: c0000000008bbc28 ffffffffffffffff c0000000007fef60 c0000000007fef60 
GPR12: 0000000000367a5e c0000000008c4300 0000000000000000 c000000000636720 
GPR16: 4000000002100000 c000000000634fb8 0000000000000000 0000000000246c00 
GPR20: 0000000002819298 c000000000719298 0000000002819508 c000000000719508 
GPR24: 0000000002c00000 c0000000006361d0 0000000000000000 c000000000000000 
GPR28: 0000000001b5f8d4 c00000000077f1a0 c0000000007db098 c0000000009073f0 
NIP [c000000000075bfc] .notifier_chain_register+0x30/0x80
LR [c000000000075bf0] .notifier_chain_register+0x24/0x80
Call Trace:
[c000000000843d40] [c000000000075bf0] .notifier_chain_register+0x24/0x80 (unreliable)
[c000000000843dd0] [c00000000007b200] .clockevents_register_notifier+0x3c/0x80
[c000000000843e60] [c0000000006fc41c] .tick_init+0x1c/0x34
[c000000000843ee0] [c0000000006e3600] .start_kernel+0x50/0x498
[c000000000843f90] [c00000000000850c] .start_here_common+0x3c/0xb0
Instruction dump:
7c0802a6 fba1ffe8 fbe1fff8 7c7f1b78 e8640000 7c9d2378 f8010010 f821ff71 
4bff77c5 60000000 2fa30000 409e0020 <0fe00000> 48000030 801d0010 812b0010 
Linux version 2.6.27-rc4-next-20080826-autokern1 (root@tundro2.rchland.ibm.com) (gcc version 4.1.2 20071124 (Red Hat 4.1.2-42)) #1 SMP Tue Aug 26 12:55:19 EDT 2008
[boot]0012 Setup Arch
------------[ cut here ]------------
Badness at kernel/notifier.c:25
NIP: c000000000075bfc LR: c000000000075bf0 CTR: 8000000000f7cdec
REGS: c000000000843a20 TRAP: 0700   Tainted: G        W  (2.6.27-rc4-next-20080826-autokern1)
MSR: 8000000000021032 <ME,IR,DR>  CR: 22000022  XER: 00000001
TASK = c000000000762b40[0] 'swapper' THREAD: c000000000840000 CPU: 0
GPR00: c000000000075bf0 c000000000843ca0 c000000000842148 0000000000000000 
GPR04: c000000000761c40 ffffffffffffffff 00000000000000c0 c0000000008c4298 
GPR08: c0000000008c429c ffffffffffffffff c0000000007f72c0 c0000000007f72c0 
GPR12: 0000000000368181 c0000000008c4300 0000000000000000 c000000000636720 
GPR16: 4000000002100000 c000000000634fb8 0000000000000000 0000000000246c00 
GPR20: 0000000002819298 c000000000719298 0000000002819508 c000000000719508 
GPR24: 0000000002c00000 c0000000006361d0 0000000000000000 0000000000000000 
GPR28: c0000000008dfe00 c000000000761c40 c0000000007d8970 c0000000008dfe08 
NIP [c000000000075bfc] .notifier_chain_register+0x30/0x80
LR [c000000000075bf0] .notifier_chain_register+0x24/0x80
Call Trace:
[c000000000843ca0] [c000000000075bf0] .notifier_chain_register+0x24/0x80 (unreliable)
[c000000000843d30] [c00000000007600c] .atomic_notifier_chain_register+0x38/0x6c
[c000000000843dd0] [c0000000006efd68] .setup_panic+0x20/0x38
[c000000000843e50] [c0000000006ec920] .setup_arch+0x80/0x21c
[c000000000843ee0] [c0000000006e36a0] .start_kernel+0xf0/0x498
[c000000000843f90] [c00000000000850c] .start_here_common+0x3c/0xb0
Instruction dump:
7c0802a6 fba1ffe8 fbe1fff8 7c7f1b78 e8640000 7c9d2378 f8010010 f821ff71 
4bff77c5 60000000 2fa30000 409e0020 <0fe00000> 48000030 801d0010 812b0010 
------------[ cut here ]------------
Badness at kernel/notifier.c:25
NIP: c000000000075bfc LR: c000000000075bf0 CTR: 0000000000000001
REGS: c0000000008439d0 TRAP: 0700   Tainted: G        W  (2.6.27-rc4-next-20080826-autokern1)
MSR: 8000000000021032 <ME,IR,DR>  CR: 24000022  XER: 00000001
TASK = c000000000762b40[0] 'swapper' THREAD: c000000000840000 CPU: 0
GPR00: c000000000075bf0 c000000000843c50 c000000000842148 0000000000000000 
GPR04: c00000000075f498 0000000000000000 c0000000008e0270 c00000000074d7d4 
GPR08: 0000000000000002 ffffffffffffffff c0000000007f8980 c0000000007f8980 
GPR12: 00000000000186a0 c0000000008c4300 0000000000000000 c000000000636720 
GPR16: 4000000002100000 c000000000634fb8 0000000000000000 0000000000246c00 
GPR20: 0000000002819298 c000000000719298 0000000002819508 c000000000719508 
GPR24: 0000000002c00000 c0000000006361d0 c0000000030512c0 0000000004000000 
GPR28: 0000000000000400 c00000000075f498 c0000000007d9ee8 c00000000075f4f8 
NIP [c000000000075bfc] .notifier_chain_register+0x30/0x80
LR [c000000000075bf0] .notifier_chain_register+0x24/0x80
Call Trace:
[c000000000843c50] [c000000000075bf0] .notifier_chain_register+0x24/0x80 (unreliable)
[c000000000843ce0] [c0000000004d6240] .register_cpu_notifier+0x2c/0x54
[c000000000843d70] [c0000000006f6b00] .do_init_bootmem+0x7a8/0xb18
[c000000000843e50] [c0000000006eca48] .setup_arch+0x1a8/0x21c
[c000000000843ee0] [c0000000006e36a0] .start_kernel+0xf0/0x498
[c000000000843f90] [c00000000000850c] .start_here_common+0x3c/0xb0
Instruction dump:
7c0802a6 fba1ffe8 fbe1fff8 7c7f1b78 e8640000 7c9d2378 f8010010 f821ff71 
4bff77c5 60000000 2fa30000 409e0020 <0fe00000> 48000030 801d0010 812b0010 
------------[ cut here ]------------
Badness at kernel/notifier.c:25
NIP: c000000000075bfc LR: c000000000075bf0 CTR: 0000000000000000
REGS: c000000000843930 TRAP: 0700   Tainted: G        W  (2.6.27-rc4-next-20080826-autokern1)
MSR: 8000000000021032 <ME,IR,DR>  CR: 24000022  XER: 00000001
TASK = c000000000762b40[0] 'swapper' THREAD: c000000000840000 CPU: 0
GPR00: c000000000075bf0 c000000000843bb0 c000000000842148 0000000000000000 
GPR04: c000000000761f90 c000000003056808 0000000020000001 0000000000000000 
GPR08: c0000000007518d0 ffffffffffffffff c0000000007f7e90 c0000000007f7e90 
GPR12: c000000000843b80 c0000000008c4300 0000000000000000 c000000000636720 
GPR16: 4000000002100000 c000000000634fb8 0000000000000000 0000000000246c00 
GPR20: 0000000002819298 c000000000719298 0000000002819508 c000000000719508 
GPR24: 0000000002c00000 c0000000006361d0 0000000000000000 c000000000000000 
GPR28: c00000007fff80c0 c000000000761f90 c0000000007d90b0 c000000000763d20 
NIP [c000000000075bfc] .notifier_chain_register+0x30/0x80
LR [c000000000075bf0] .notifier_chain_register+0x24/0x80
Call Trace:
[c000000000843bb0] [c000000000075bf0] .notifier_chain_register+0x24/0x80 (unreliable)
[c000000000843c40] [c000000000037c04] .pSeries_reconfig_notifier_register+0x18/0x2c
[c000000000843cb0] [c0000000006f48b4] .pci_devs_phb_init+0x58/0x74
[c000000000843d30] [c0000000006edad4] .find_and_init_phbs+0xd8/0x130
[c000000000843dc0] [c0000000006f8470] .pSeries_setup_arch+0xf0/0x210
[c000000000843e50] [c0000000006eca88] .setup_arch+0x1e8/0x21c
[c000000000843ee0] [c0000000006e36a0] .start_kernel+0xf0/0x498
[c000000000843f90] [c00000000000850c] .start_here_common+0x3c/0xb0
Instruction dump:
7c0802a6 fba1ffe8 fbe1fff8 7c7f1b78 e8640000 7c9d2378 f8010010 f821ff71 
4bff77c5 60000000 2fa30000 409e0020 <0fe00000> 48000030 801d0010 812b0010 
EEH: No capable adapters found
PPC64 nvram contains 15360 bytes
Zone PFN ranges:
  DMA      0x00000000 -> 0x00080000
  Normal   0x00080000 -> 0x00080000
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x00044000
    1: 0x00044000 -> 0x00080000
[boot]0015 Setup Done
Built 2 zonelists in Node order, mobility grouping on.  Total pages: 517120
Policy zone: DMA
------------[ cut here ]------------
Badness at kernel/notifier.c:25
NIP: c000000000075bfc LR: c000000000075bf0 CTR: 8000000000f7cdec
REGS: c000000000843ac0 TRAP: 0700   Tainted: G        W  (2.6.27-rc4-next-20080826-autokern1)
MSR: 8000000000021032 <ME,IR,DR>  CR: 24000022  XER: 00000001
TASK = c000000000762b40[0] 'swapper' THREAD: c000000000840000 CPU: 0
GPR00: c000000000075bf0 c000000000843d40 c000000000842148 0000000000000000 
GPR04: c00000000075f640 ffffffffffffffff 00000000000000b0 00000000001bb4f0 
GPR08: 000000003b7d85d0 ffffffffffffffff c0000000008027b0 c0000000008027b0 
GPR12: 00000000003697af c0000000008c4300 0000000000000000 c000000000636720 
GPR16: 4000000002100000 c000000000634fb8 0000000000000000 0000000000246c00 
GPR20: 0000000002819298 c000000000719298 0000000002819508 c000000000719508 
GPR24: 0000000002c00000 c0000000006361d0 c0000000008d5918 c000000000716618 
GPR28: c0000000008c1040 c00000000075f640 c0000000007d9ee8 c00000000075f4f8 
NIP [c000000000075bfc] .notifier_chain_register+0x30/0x80
LR [c000000000075bf0] .notifier_chain_register+0x24/0x80
Call Trace:
[c000000000843d40] [c000000000075bf0] .notifier_chain_register+0x24/0x80 (unreliable)
[c000000000843dd0] [c0000000004d6240] .register_cpu_notifier+0x2c/0x54
[c000000000843e60] [c0000000006fefe8] .page_alloc_init+0x1c/0x34
[c000000000843ee0] [c0000000006e3784] .start_kernel+0x1d4/0x498
[c000000000843f90] [c00000000000850c] .start_here_common+0x3c/0xb0
Instruction dump:
7c0802a6 fba1ffe8 fbe1fff8 7c7f1b78 e8640000 7c9d2378 f8010010 f821ff71 
4bff77c5 60000000 2fa30000 409e0020 <0fe00000> 48000030 801d0010 812b0010 
.
.
.
<snip many of the similar call traces>

the commit which introduced this warning is

commit 16f9b13de93c8bfdac16b4d15577af2c132358ef
Author: Arjan van de Ven <arjan@linux.intel.com>
Date:   Fri Aug 15 15:29:38 2008 -0700

    debug: add notifier chain debugging
    
    during some development we suspected a case where we left something
    in a notifier chain that was from a module that was unloaded already...
    and that sort of thing is rather hard to track down.
    
    This patch adds a very simple sanity check (which isn't all that
    expensive) to make sure the notifier we're about to call is
    actually from either the kernel itself of from a still-loaded
    module, avoiding a hard-to-chase-down crash.
    
    Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/kernel/notifier.c b/kernel/notifier.c
index 823be11..143fdd7 100644
--- a/kernel/notifier.c
+++ b/kernel/notifier.c
@@ -21,6 +21,10 @@ BLOCKING_NOTIFIER_HEAD(reboot_notifier_list);
 static int notifier_chain_register(struct notifier_block **nl,
                struct notifier_block *n)
 {
+       if (!kernel_text_address((unsigned long)n->notifier_call)) {
+               WARN(1, "Invalid notifier registered!");
+               return 0;
+       }
        while ((*nl) != NULL) {
                if (n->priority > (*nl)->priority)
                        break;
<snip>


-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.

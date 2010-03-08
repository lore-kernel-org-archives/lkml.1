Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab0CHRGX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 12:06:23 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:55848 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab0CHRGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 12:06:16 -0500
Date: Mon, 8 Mar 2010 18:06:37 +0100
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, x86 <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86, k8 nb: Enable k8_northbridges unconditionally on AMD
Message-ID: <20100308170637.GA26565@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

we're getting the following oopsie with current -git. Proposed patch is below:

[    5.582656] BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
[    5.583643] IP: [<ffffffff81645859>] cpuid4_cache_lookup_regs+0x22c/0x31d
[    5.583643] PGD 0 
[    5.583643] Oops: 0000 [#1] SMP 
[    5.583643] last sysfs file: 
[    5.583643] CPU 0 
[    5.583643] Modules linked in:
[    5.583643] 
[    5.583643] Pid: 0, comm: swapper Not tainted 2.6.33 #1
[    5.583643] RIP: 0010:[<ffffffff81645859>]  [<ffffffff81645859>] cpuid4_cache_lookup_regs+0x22c/0x31d
[    5.583643] RSP: 0018:ffff880002a03e78  EFLAGS: 00010046
[    5.583643] RAX: 0000000000000000 RBX: 0000000042004200 RCX: 00000000000006aa
[    5.583643] RDX: 0000000000000000 RSI: 0000000000500000 RDI: 0000000000000003
[    5.583643] RBP: ffff880002a03ee8 R08: 0000000000000030 R09: 0000000000000001
[    5.583643] R10: 0000000000000040 R11: ffff880002a12f00 R12: 000000000bc0003f
[    5.583643] R13: 00000000000006a9 R14: ffff8808357be6a8 R15: 000000002c000163
[    5.583643] FS:  0000000000000000(0000) GS:ffff880002a00000(0000) knlGS:0000000000000000
[    5.583643] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    5.583643] CR2: 0000000000000038 CR3: 0000000001cdf000 CR4: 00000000000006f0
[    5.583643] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    5.583643] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    5.583643] Process swapper (pid: 0, threadinfo ffffffff81c00000, task ffffffff81ce7020)
[    5.583643] Stack:
[    5.583643]  000140000000e8b0 7fffffffffffffff ffff880002a03eb8 000000008104f595
[    5.583643] <0> ffffffff40020140 00000001000002c0 0000000040020140 0000000000000046
[    5.583643] <0> ffffffff81ce7020 0000000000000001 ffff880002a12500 0000000000000003
[    5.583643] Call Trace:
[    5.583643]  <IRQ> 
[    5.583643]  [<ffffffff81646289>] get_cpu_leaves+0x6a/0x235
[    5.583643]  [<ffffffff81062326>] generic_smp_call_function_single_interrupt+0xdf/0x11b
[    5.583643]  [<ffffffff810171d1>] smp_call_function_single_interrupt+0x22/0x31
[    5.583643]  [<ffffffff810035b3>] call_function_single_interrupt+0x13/0x20
[    5.583643]  <EOI> 
[    5.583643]  [<ffffffff8102bdd4>] ? cpuacct_charge+0x1c/0x97
[    5.583643]  [<ffffffff8100986c>] ? default_idle+0x27/0x41
[    5.583643]  [<ffffffff8100986a>] ? default_idle+0x25/0x41
[    5.583643]  [<ffffffff810099fe>] c1e_idle+0xe9/0xf0
[    5.583643]  [<ffffffff81652991>] ? atomic_notifier_call_chain+0xf/0x11
[    5.583643]  [<ffffffff81001d7a>] cpu_idle+0x5a/0x92
[    5.583643]  [<ffffffff8162928a>] rest_init+0xbe/0xc2
[    5.583643]  [<ffffffff816291cc>] ? rest_init+0x0/0xc2
[    5.583643]  [<ffffffff81dedd05>] start_kernel+0x3ac/0x3b8
[    5.583643]  [<ffffffff81ded295>] x86_64_start_reservations+0xa5/0xa9
[    5.583643]  [<ffffffff81ded37a>] x86_64_start_kernel+0xe1/0xe8
[    5.583643] Code: 98 48 8b 04 c5 60 12 dd 81 8b 14 02 31 c0 3b 15 06 be 86 00 7d 0e 48 8b 05 f5 bd 86 00 48 63 d2 48 8b 04 d0 c7 45 ac 00 00 00 00 <8b> 70 38 48 8d 4d ac 48 8b 78 10 ba c4 01 00 00 e8 b6 c2 bb ff 
[    5.583643] RIP  [<ffffffff81645859>] cpuid4_cache_lookup_regs+0x22c/0x31d
[    5.583643]  RSP <ffff880002a03e78>
[    5.583643] CR2: 0000000000000038
[    5.583643] ---[ end trace a7919e7f17c0a725 ]---
[    5.583643] Kernel panic - not syncing: Fatal exception in interrupt
[    5.583643] Pid: 0, comm: swapper Tainted: G      D    2.6.33 #1
[    5.583643] Call Trace:
[    5.583643]  <IRQ>  [<ffffffff8164cd8d>] panic+0x9e/0x11d
[    5.583643]  [<ffffffff810386be>] ? kmsg_dump+0xa8/0x14d
[    5.583643]  [<ffffffff8105abde>] ? trace_hardirqs_off+0xd/0xf
[    5.583643]  [<ffffffff8164f670>] ? _raw_spin_unlock_irqrestore+0x38/0x47
[    5.583643]  [<ffffffff81038749>] ? kmsg_dump+0x133/0x14d
[    5.583643]  [<ffffffff81650781>] oops_end+0xaa/0xba
[    5.583643]  [<ffffffff81023f71>] no_context+0x1f3/0x202
[    5.583643]  [<ffffffff8105b410>] ? mark_lock+0x22/0x22f
[    5.583643]  [<ffffffff81024148>] __bad_area_nosemaphore+0x1c8/0x1ee
[    5.583643]  [<ffffffff8105b410>] ? mark_lock+0x22/0x22f
[    5.583643]  [<ffffffff8105b410>] ? mark_lock+0x22/0x22f
[    5.583643]  [<ffffffff8105d123>] ? __lock_acquire+0xd7d/0xd8c
[    5.583643]  [<ffffffff8102417c>] bad_area_nosemaphore+0xe/0x10
[    5.583643]  [<ffffffff81652751>] do_page_fault+0x190/0x2e0
[    5.583643]  [<ffffffff8164fb7f>] page_fault+0x1f/0x30
[    5.583643]  [<ffffffff81645859>] ? cpuid4_cache_lookup_regs+0x22c/0x31d
[    5.583643]  [<ffffffff8164f670>] ? _raw_spin_unlock_irqrestore+0x38/0x47
[    5.583643]  [<ffffffff81646289>] get_cpu_leaves+0x6a/0x235
[    5.583643]  [<ffffffff81062326>] generic_smp_call_function_single_interrupt+0xdf/0x11b
[    5.583643]  [<ffffffff810171d1>] smp_call_function_single_interrupt+0x22/0x31
[    5.583643]  [<ffffffff810035b3>] call_function_single_interrupt+0x13/0x20
[    5.583643]  <EOI>  [<ffffffff8102bdd4>] ? cpuacct_charge+0x1c/0x97
[    5.583643]  [<ffffffff8100986c>] ? default_idle+0x27/0x41
[    5.583643]  [<ffffffff8100986a>] ? default_idle+0x25/0x41
[    5.583643]  [<ffffffff810099fe>] c1e_idle+0xe9/0xf0
[    5.583643]  [<ffffffff81652991>] ? atomic_notifier_call_chain+0xf/0x11
[    5.583643]  [<ffffffff81001d7a>] cpu_idle+0x5a/0x92
[    5.583643]  [<ffffffff8162928a>] rest_init+0xbe/0xc2
[    5.583643]  [<ffffffff816291cc>] ? rest_init+0x0/0xc2
[    5.583643]  [<ffffffff81dedd05>] start_kernel+0x3ac/0x3b8
[    5.583643]  [<ffffffff81ded295>] x86_64_start_reservations+0xa5/0xa9
[    5.583643]  [<ffffffff81ded37a>] x86_64_start_kernel+0xe1/0xe8
---

Fix:

---
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Mon, 8 Mar 2010 14:27:01 +0100
Subject: [PATCH] x86, k8 nb: Enable k8_northbridges unconditionally on AMD

de957628ce7c84764ff41331111036b3ae5bad0f changed setting of the
x86_init.iommu.iommu_init function ptr only when GART IOMMU is found.

One side effect of it is that num_k8_northbridges
is not initialized anymore if not explicitly
called. This resulted in uninitialized pointers in
<arch/x86/kernel/cpu/intel_cacheinfo.c:amd_calc_l3_indices()>,
for example, which uses the num_k8_northbridges thing through
node_to_k8_nb_misc().

Fix that through an initcall that runs right after the PCI subsystem and
does all the scanning. Then, remove initialization in gart_iommu_init()
which is a rootfs_initcall and we're running before that.

What is more, since num_k8_northbridges is being used in other places
beside GART IOMMU, include it whenever we add AMD CPU support.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Tested-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/Kconfig              |    2 +-
 arch/x86/kernel/k8.c          |   14 ++++++++++++++
 arch/x86/kernel/pci-gart_64.c |    2 +-
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e984403..2f3ab91 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2058,7 +2058,7 @@ endif # X86_32
 
 config K8_NB
 	def_bool y
-	depends on AGP_AMD64 || (X86_64 && (GART_IOMMU || (PCI && NUMA)))
+	depends on CPU_SUP_AMD && PCI
 
 source "drivers/pcmcia/Kconfig"
 
diff --git a/arch/x86/kernel/k8.c b/arch/x86/kernel/k8.c
index cbc4332..9b89546 100644
--- a/arch/x86/kernel/k8.c
+++ b/arch/x86/kernel/k8.c
@@ -121,3 +121,17 @@ void k8_flush_garts(void)
 }
 EXPORT_SYMBOL_GPL(k8_flush_garts);
 
+static __init int init_k8_nbs(void)
+{
+	int err = 0;
+
+	err = cache_k8_northbridges();
+
+	if (err < 0)
+		printk(KERN_NOTICE "K8 NB: Cannot enumerate AMD northbridges.\n");
+
+	return err;
+}
+
+/* This has to go after the PCI subsystem */
+fs_initcall(init_k8_nbs);
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 34de53b..f3af115 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -735,7 +735,7 @@ int __init gart_iommu_init(void)
 	unsigned long scratch;
 	long i;
 
-	if (cache_k8_northbridges() < 0 || num_k8_northbridges == 0)
+	if (num_k8_northbridges == 0)
 		return 0;
 
 #ifndef CONFIG_AGP_AMD64
-- 
1.6.6.1


-- 
Regards/Gruss,
Boris.

-
Advanced Micro Devices, Inc.
Operating Systems Research Center

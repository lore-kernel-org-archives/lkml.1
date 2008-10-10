Return-Path: <linux-kernel-owner+w=401wt.eu-S1761338AbYJJP7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761338AbYJJP7f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 11:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759615AbYJJP7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 11:59:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33260 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759557AbYJJP7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 11:59:12 -0400
Date: Fri, 10 Oct 2008 17:58:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [git pull] x86 updates for v2.6.28, phase #1
Message-ID: <20081010155830.GA4767@elte.hu>
References: <20081009234705.GA20540@elte.hu> <alpine.LFD.2.00.0810100808540.3524@nehalem.linux-foundation.org> <20081010152631.GB26231@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081010152631.GB26231@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > Ok, so I pulled phase 1, but quite frankly, I think this was utter 
> > crap. Why the hell did this go in?
> 
> we'll fix that up. We'll move all header files to 
> arch/x86/include/asm/ anyway later in the merge window, once the dust 
> settles, and can do a separate commit for this as well.

we'll do the commit below once we've moved the header files to 
arch/x86/include/asm/. (doing it right now would conflict with various 
existing branches so it would be nice to wait with this.)

	Ingo

---------------->
>From 5f3a8db0d4b091521541153580454099618fec2c Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 10 Oct 2008 17:51:28 +0200
Subject: [PATCH] x86: fix header guard naming ugliness

as Linus has noticed, the underscore aspect of these changes in
77ef50a ("x86: consolidate header guards") are bogus:

-#ifndef _ASM_BOOT_H
-#define _ASM_BOOT_H
+#ifndef ASM_X86__BOOT_H
+#define ASM_X86__BOOT_H

as Linus pointed out:

1) header guard symbols are internal symbols in a reserved namespace,
   so a leading underscore is perfectly justified

2) user-space might accidentally stumble into the new symbols:

        #include <sys/types.h>

        int ASM_X86__TYPES_H = 1;

plus this deviates from all the standard header guard naming we
use elsewhere in the kernel.

So move the underscore back to its standard place.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/asm-x86/a.out-core.h                |    6 +++---
 include/asm-x86/a.out.h                     |    6 +++---
 include/asm-x86/acpi.h                      |    6 +++---
 include/asm-x86/agp.h                       |    6 +++---
 include/asm-x86/alternative.h               |    6 +++---
 include/asm-x86/amd_iommu.h                 |    6 +++---
 include/asm-x86/amd_iommu_types.h           |    6 +++---
 include/asm-x86/apic.h                      |    6 +++---
 include/asm-x86/apicdef.h                   |    6 +++---
 include/asm-x86/arch_hooks.h                |    6 +++---
 include/asm-x86/asm.h                       |    6 +++---
 include/asm-x86/atomic_32.h                 |    6 +++---
 include/asm-x86/atomic_64.h                 |    6 +++---
 include/asm-x86/auxvec.h                    |    6 +++---
 include/asm-x86/bios_ebda.h                 |    6 +++---
 include/asm-x86/bitops.h                    |    6 +++---
 include/asm-x86/boot.h                      |    6 +++---
 include/asm-x86/bootparam.h                 |    6 +++---
 include/asm-x86/bug.h                       |    6 +++---
 include/asm-x86/bugs.h                      |    6 +++---
 include/asm-x86/byteorder.h                 |    6 +++---
 include/asm-x86/cache.h                     |    6 +++---
 include/asm-x86/cacheflush.h                |    6 +++---
 include/asm-x86/calgary.h                   |    6 +++---
 include/asm-x86/checksum_32.h               |    6 +++---
 include/asm-x86/checksum_64.h               |    6 +++---
 include/asm-x86/cmpxchg_32.h                |    6 +++---
 include/asm-x86/cmpxchg_64.h                |    6 +++---
 include/asm-x86/compat.h                    |    6 +++---
 include/asm-x86/cpu.h                       |    6 +++---
 include/asm-x86/cpufeature.h                |    6 +++---
 include/asm-x86/current.h                   |    6 +++---
 include/asm-x86/debugreg.h                  |    6 +++---
 include/asm-x86/delay.h                     |    6 +++---
 include/asm-x86/desc.h                      |    6 +++---
 include/asm-x86/desc_defs.h                 |    6 +++---
 include/asm-x86/device.h                    |    6 +++---
 include/asm-x86/div64.h                     |    6 +++---
 include/asm-x86/dma-mapping.h               |    6 +++---
 include/asm-x86/dma.h                       |    6 +++---
 include/asm-x86/dmi.h                       |    6 +++---
 include/asm-x86/ds.h                        |    6 +++---
 include/asm-x86/dwarf2.h                    |    6 +++---
 include/asm-x86/e820.h                      |    6 +++---
 include/asm-x86/edac.h                      |    6 +++---
 include/asm-x86/efi.h                       |    6 +++---
 include/asm-x86/elf.h                       |    6 +++---
 include/asm-x86/emergency-restart.h         |    6 +++---
 include/asm-x86/fb.h                        |    6 +++---
 include/asm-x86/fixmap.h                    |    6 +++---
 include/asm-x86/fixmap_32.h                 |    6 +++---
 include/asm-x86/fixmap_64.h                 |    6 +++---
 include/asm-x86/floppy.h                    |    6 +++---
 include/asm-x86/ftrace.h                    |    6 +++---
 include/asm-x86/futex.h                     |    6 +++---
 include/asm-x86/gart.h                      |    6 +++---
 include/asm-x86/genapic_32.h                |    6 +++---
 include/asm-x86/genapic_64.h                |    6 +++---
 include/asm-x86/geode.h                     |    6 +++---
 include/asm-x86/gpio.h                      |    2 +-
 include/asm-x86/hardirq_32.h                |    6 +++---
 include/asm-x86/hardirq_64.h                |    6 +++---
 include/asm-x86/highmem.h                   |    6 +++---
 include/asm-x86/hpet.h                      |    6 +++---
 include/asm-x86/hugetlb.h                   |    6 +++---
 include/asm-x86/hw_irq.h                    |    6 +++---
 include/asm-x86/hypertransport.h            |    6 +++---
 include/asm-x86/i387.h                      |    6 +++---
 include/asm-x86/i8253.h                     |    6 +++---
 include/asm-x86/i8259.h                     |    6 +++---
 include/asm-x86/ia32.h                      |    6 +++---
 include/asm-x86/ia32_unistd.h               |    6 +++---
 include/asm-x86/idle.h                      |    6 +++---
 include/asm-x86/intel_arch_perfmon.h        |    6 +++---
 include/asm-x86/io.h                        |    6 +++---
 include/asm-x86/io_32.h                     |    6 +++---
 include/asm-x86/io_64.h                     |    6 +++---
 include/asm-x86/io_apic.h                   |    6 +++---
 include/asm-x86/ioctls.h                    |    6 +++---
 include/asm-x86/iommu.h                     |    6 +++---
 include/asm-x86/ipcbuf.h                    |    6 +++---
 include/asm-x86/ipi.h                       |    6 +++---
 include/asm-x86/irq.h                       |    6 +++---
 include/asm-x86/irq_regs_32.h               |    6 +++---
 include/asm-x86/irq_vectors.h               |    6 +++---
 include/asm-x86/ist.h                       |    6 +++---
 include/asm-x86/k8.h                        |    6 +++---
 include/asm-x86/kdebug.h                    |    6 +++---
 include/asm-x86/kexec.h                     |    6 +++---
 include/asm-x86/kgdb.h                      |    6 +++---
 include/asm-x86/kmap_types.h                |    6 +++---
 include/asm-x86/kprobes.h                   |    6 +++---
 include/asm-x86/kvm.h                       |    6 +++---
 include/asm-x86/kvm_host.h                  |    6 +++---
 include/asm-x86/kvm_para.h                  |    6 +++---
 include/asm-x86/kvm_x86_emulate.h           |    6 +++---
 include/asm-x86/ldt.h                       |    6 +++---
 include/asm-x86/lguest.h                    |    6 +++---
 include/asm-x86/lguest_hcall.h              |    6 +++---
 include/asm-x86/linkage.h                   |    6 +++---
 include/asm-x86/local.h                     |    6 +++---
 include/asm-x86/mach-default/apm.h          |    6 +++---
 include/asm-x86/mach-default/mach_apic.h    |    6 +++---
 include/asm-x86/mach-default/mach_apicdef.h |    6 +++---
 include/asm-x86/mach-default/mach_ipi.h     |    6 +++---
 include/asm-x86/mach-default/mach_mpparse.h |    6 +++---
 include/asm-x86/mach-default/mach_mpspec.h  |    6 +++---
 include/asm-x86/mach-default/mach_timer.h   |    6 +++---
 include/asm-x86/mach-default/mach_traps.h   |    6 +++---
 include/asm-x86/mach-default/mach_wakecpu.h |    6 +++---
 include/asm-x86/mach-generic/gpio.h         |    6 +++---
 include/asm-x86/mach-generic/mach_apic.h    |    6 +++---
 include/asm-x86/mach-generic/mach_apicdef.h |    6 +++---
 include/asm-x86/mach-generic/mach_ipi.h     |    6 +++---
 include/asm-x86/mach-generic/mach_mpparse.h |    6 +++---
 include/asm-x86/mach-generic/mach_mpspec.h  |    6 +++---
 include/asm-x86/mach-rdc321x/gpio.h         |    6 +++---
 include/asm-x86/math_emu.h                  |    6 +++---
 include/asm-x86/mc146818rtc.h               |    6 +++---
 include/asm-x86/mca.h                       |    6 +++---
 include/asm-x86/mca_dma.h                   |    6 +++---
 include/asm-x86/mce.h                       |    6 +++---
 include/asm-x86/microcode.h                 |    6 +++---
 include/asm-x86/mman.h                      |    6 +++---
 include/asm-x86/mmconfig.h                  |    6 +++---
 include/asm-x86/mmu.h                       |    6 +++---
 include/asm-x86/mmu_context.h               |    6 +++---
 include/asm-x86/mmu_context_32.h            |    6 +++---
 include/asm-x86/mmu_context_64.h            |    6 +++---
 include/asm-x86/mmx.h                       |    6 +++---
 include/asm-x86/mmzone_32.h                 |    6 +++---
 include/asm-x86/mmzone_64.h                 |    6 +++---
 include/asm-x86/module.h                    |    6 +++---
 include/asm-x86/mpspec.h                    |    6 +++---
 include/asm-x86/mpspec_def.h                |    6 +++---
 include/asm-x86/msgbuf.h                    |    6 +++---
 include/asm-x86/msidef.h                    |    6 +++---
 include/asm-x86/msr-index.h                 |    6 +++---
 include/asm-x86/msr.h                       |    6 +++---
 include/asm-x86/mtrr.h                      |    6 +++---
 include/asm-x86/mutex_32.h                  |    6 +++---
 include/asm-x86/mutex_64.h                  |    6 +++---
 include/asm-x86/nmi.h                       |    6 +++---
 include/asm-x86/nops.h                      |    6 +++---
 include/asm-x86/numa_32.h                   |    6 +++---
 include/asm-x86/numa_64.h                   |    6 +++---
 include/asm-x86/numaq.h                     |    6 +++---
 include/asm-x86/olpc.h                      |    6 +++---
 include/asm-x86/page.h                      |    6 +++---
 include/asm-x86/page_32.h                   |    6 +++---
 include/asm-x86/page_64.h                   |    6 +++---
 include/asm-x86/param.h                     |    6 +++---
 include/asm-x86/paravirt.h                  |    6 +++---
 include/asm-x86/parport.h                   |    6 +++---
 include/asm-x86/pat.h                       |    6 +++---
 include/asm-x86/pci-direct.h                |    6 +++---
 include/asm-x86/pci.h                       |    6 +++---
 include/asm-x86/pci_32.h                    |    6 +++---
 include/asm-x86/pci_64.h                    |    6 +++---
 include/asm-x86/pda.h                       |    6 +++---
 include/asm-x86/percpu.h                    |    6 +++---
 include/asm-x86/pgalloc.h                   |    6 +++---
 include/asm-x86/pgtable-2level-defs.h       |    6 +++---
 include/asm-x86/pgtable-2level.h            |    6 +++---
 include/asm-x86/pgtable-3level-defs.h       |    6 +++---
 include/asm-x86/pgtable-3level.h            |    6 +++---
 include/asm-x86/pgtable.h                   |    6 +++---
 include/asm-x86/pgtable_32.h                |    6 +++---
 include/asm-x86/pgtable_64.h                |    6 +++---
 include/asm-x86/posix_types_32.h            |    6 +++---
 include/asm-x86/posix_types_64.h            |    6 +++---
 include/asm-x86/prctl.h                     |    6 +++---
 include/asm-x86/processor-flags.h           |    6 +++---
 include/asm-x86/processor.h                 |    6 +++---
 include/asm-x86/proto.h                     |    6 +++---
 include/asm-x86/ptrace-abi.h                |    6 +++---
 include/asm-x86/ptrace.h                    |    6 +++---
 include/asm-x86/pvclock-abi.h               |    6 +++---
 include/asm-x86/pvclock.h                   |    6 +++---
 include/asm-x86/reboot.h                    |    6 +++---
 include/asm-x86/reboot_fixups.h             |    6 +++---
 include/asm-x86/required-features.h         |    6 +++---
 include/asm-x86/resume-trace.h              |    6 +++---
 include/asm-x86/rio.h                       |    6 +++---
 include/asm-x86/rwlock.h                    |    6 +++---
 include/asm-x86/rwsem.h                     |    6 +++---
 include/asm-x86/scatterlist.h               |    6 +++---
 include/asm-x86/seccomp_32.h                |    6 +++---
 include/asm-x86/seccomp_64.h                |    6 +++---
 include/asm-x86/segment.h                   |    6 +++---
 include/asm-x86/sembuf.h                    |    6 +++---
 include/asm-x86/serial.h                    |    6 +++---
 include/asm-x86/setup.h                     |    6 +++---
 include/asm-x86/shmbuf.h                    |    6 +++---
 include/asm-x86/shmparam.h                  |    6 +++---
 include/asm-x86/sigcontext.h                |    6 +++---
 include/asm-x86/sigcontext32.h              |    6 +++---
 include/asm-x86/siginfo.h                   |    6 +++---
 include/asm-x86/signal.h                    |    6 +++---
 include/asm-x86/smp.h                       |    6 +++---
 include/asm-x86/socket.h                    |    6 +++---
 include/asm-x86/sockios.h                   |    6 +++---
 include/asm-x86/sparsemem.h                 |    6 +++---
 include/asm-x86/spinlock.h                  |    6 +++---
 include/asm-x86/spinlock_types.h            |    6 +++---
 include/asm-x86/srat.h                      |    6 +++---
 include/asm-x86/stacktrace.h                |    6 +++---
 include/asm-x86/stat.h                      |    6 +++---
 include/asm-x86/statfs.h                    |    6 +++---
 include/asm-x86/string_32.h                 |    6 +++---
 include/asm-x86/string_64.h                 |    6 +++---
 include/asm-x86/suspend_32.h                |    6 +++---
 include/asm-x86/suspend_64.h                |    6 +++---
 include/asm-x86/swiotlb.h                   |    6 +++---
 include/asm-x86/sync_bitops.h               |    6 +++---
 include/asm-x86/system.h                    |    6 +++---
 include/asm-x86/system_64.h                 |    6 +++---
 include/asm-x86/tce.h                       |    6 +++---
 include/asm-x86/termbits.h                  |    6 +++---
 include/asm-x86/termios.h                   |    6 +++---
 include/asm-x86/therm_throt.h               |    6 +++---
 include/asm-x86/thread_info.h               |    6 +++---
 include/asm-x86/time.h                      |    6 +++---
 include/asm-x86/timer.h                     |    6 +++---
 include/asm-x86/timex.h                     |    6 +++---
 include/asm-x86/tlb.h                       |    6 +++---
 include/asm-x86/tlbflush.h                  |    6 +++---
 include/asm-x86/topology.h                  |    6 +++---
 include/asm-x86/trampoline.h                |    6 +++---
 include/asm-x86/traps.h                     |    6 +++---
 include/asm-x86/tsc.h                       |    6 +++---
 include/asm-x86/types.h                     |    6 +++---
 include/asm-x86/uaccess.h                   |    6 +++---
 include/asm-x86/uaccess_32.h                |    6 +++---
 include/asm-x86/uaccess_64.h                |    6 +++---
 include/asm-x86/ucontext.h                  |    6 +++---
 include/asm-x86/unaligned.h                 |    6 +++---
 include/asm-x86/unistd_32.h                 |    6 +++---
 include/asm-x86/unistd_64.h                 |    6 +++---
 include/asm-x86/unwind.h                    |    6 +++---
 include/asm-x86/user32.h                    |    6 +++---
 include/asm-x86/user_32.h                   |    6 +++---
 include/asm-x86/user_64.h                   |    6 +++---
 include/asm-x86/uv/bios.h                   |    6 +++---
 include/asm-x86/uv/uv_bau.h                 |    6 +++---
 include/asm-x86/uv/uv_hub.h                 |    6 +++---
 include/asm-x86/uv/uv_irq.h                 |    6 +++---
 include/asm-x86/uv/uv_mmrs.h                |    6 +++---
 include/asm-x86/vdso.h                      |    6 +++---
 include/asm-x86/vga.h                       |    6 +++---
 include/asm-x86/vgtod.h                     |    6 +++---
 include/asm-x86/visws/cobalt.h              |    6 +++---
 include/asm-x86/visws/lithium.h             |    6 +++---
 include/asm-x86/visws/piix4.h               |    6 +++---
 include/asm-x86/vm86.h                      |    6 +++---
 include/asm-x86/vmi_time.h                  |    6 +++---
 include/asm-x86/vsyscall.h                  |    6 +++---
 include/asm-x86/xen/events.h                |    6 +++---
 include/asm-x86/xen/grant_table.h           |    6 +++---
 include/asm-x86/xen/hypercall.h             |    6 +++---
 include/asm-x86/xen/hypervisor.h            |    6 +++---
 include/asm-x86/xen/interface.h             |    6 +++---
 include/asm-x86/xen/interface_32.h          |    6 +++---
 include/asm-x86/xen/interface_64.h          |    6 +++---
 include/asm-x86/xen/page.h                  |    6 +++---
 include/asm-x86/xor_32.h                    |    6 +++---
 include/asm-x86/xor_64.h                    |    6 +++---
 267 files changed, 799 insertions(+), 799 deletions(-)

diff --git a/include/asm-x86/a.out-core.h b/include/asm-x86/a.out-core.h
index f570576..3782220 100644
--- a/include/asm-x86/a.out-core.h
+++ b/include/asm-x86/a.out-core.h
@@ -9,8 +9,8 @@
  * 2 of the Licence, or (at your option) any later version.
  */
 
-#ifndef ASM_X86__A_OUT_CORE_H
-#define ASM_X86__A_OUT_CORE_H
+#ifndef _ASM_X86_A_OUT_CORE_H
+#define _ASM_X86_A_OUT_CORE_H
 
 #ifdef __KERNEL__
 #ifdef CONFIG_X86_32
@@ -70,4 +70,4 @@ static inline void aout_dump_thread(struct pt_regs *regs, struct user *dump)
 
 #endif /* CONFIG_X86_32 */
 #endif /* __KERNEL__ */
-#endif /* ASM_X86__A_OUT_CORE_H */
+#endif /* _ASM_X86_A_OUT_CORE_H */
diff --git a/include/asm-x86/a.out.h b/include/asm-x86/a.out.h
index 0948748..4684f97 100644
--- a/include/asm-x86/a.out.h
+++ b/include/asm-x86/a.out.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__A_OUT_H
-#define ASM_X86__A_OUT_H
+#ifndef _ASM_X86_A_OUT_H
+#define _ASM_X86_A_OUT_H
 
 struct exec
 {
@@ -17,4 +17,4 @@ struct exec
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-#endif /* ASM_X86__A_OUT_H */
+#endif /* _ASM_X86_A_OUT_H */
diff --git a/include/asm-x86/acpi.h b/include/asm-x86/acpi.h
index 672e1e1..ae4fd87 100644
--- a/include/asm-x86/acpi.h
+++ b/include/asm-x86/acpi.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__ACPI_H
-#define ASM_X86__ACPI_H
+#ifndef _ASM_X86_ACPI_H
+#define _ASM_X86_ACPI_H
 
 /*
  *  Copyright (C) 2001 Paul Diefenbaugh <paul.s.diefenbaugh@intel.com>
@@ -172,4 +172,4 @@ static inline void acpi_fake_nodes(const struct bootnode *fake_nodes,
 
 #define acpi_unlazy_tlb(x)	leave_mm(x)
 
-#endif /* ASM_X86__ACPI_H */
+#endif /* _ASM_X86_ACPI_H */
diff --git a/include/asm-x86/agp.h b/include/asm-x86/agp.h
index 3617fd4..9825cd6 100644
--- a/include/asm-x86/agp.h
+++ b/include/asm-x86/agp.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__AGP_H
-#define ASM_X86__AGP_H
+#ifndef _ASM_X86_AGP_H
+#define _ASM_X86_AGP_H
 
 #include <asm/pgtable.h>
 #include <asm/cacheflush.h>
@@ -32,4 +32,4 @@
 #define free_gatt_pages(table, order)	\
 	free_pages((unsigned long)(table), (order))
 
-#endif /* ASM_X86__AGP_H */
+#endif /* _ASM_X86_AGP_H */
diff --git a/include/asm-x86/alternative.h b/include/asm-x86/alternative.h
index 22d3c98..f6aa18e 100644
--- a/include/asm-x86/alternative.h
+++ b/include/asm-x86/alternative.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__ALTERNATIVE_H
-#define ASM_X86__ALTERNATIVE_H
+#ifndef _ASM_X86_ALTERNATIVE_H
+#define _ASM_X86_ALTERNATIVE_H
 
 #include <linux/types.h>
 #include <linux/stddef.h>
@@ -180,4 +180,4 @@ extern void add_nops(void *insns, unsigned int len);
 extern void *text_poke(void *addr, const void *opcode, size_t len);
 extern void *text_poke_early(void *addr, const void *opcode, size_t len);
 
-#endif /* ASM_X86__ALTERNATIVE_H */
+#endif /* _ASM_X86_ALTERNATIVE_H */
diff --git a/include/asm-x86/amd_iommu.h b/include/asm-x86/amd_iommu.h
index 041d0db..f712344 100644
--- a/include/asm-x86/amd_iommu.h
+++ b/include/asm-x86/amd_iommu.h
@@ -17,8 +17,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
  */
 
-#ifndef ASM_X86__AMD_IOMMU_H
-#define ASM_X86__AMD_IOMMU_H
+#ifndef _ASM_X86_AMD_IOMMU_H
+#define _ASM_X86_AMD_IOMMU_H
 
 #include <linux/irqreturn.h>
 
@@ -32,4 +32,4 @@ static inline int amd_iommu_init(void) { return -ENODEV; }
 static inline void amd_iommu_detect(void) { }
 #endif
 
-#endif /* ASM_X86__AMD_IOMMU_H */
+#endif /* _ASM_X86_AMD_IOMMU_H */
diff --git a/include/asm-x86/amd_iommu_types.h b/include/asm-x86/amd_iommu_types.h
index b308586..1a30c04 100644
--- a/include/asm-x86/amd_iommu_types.h
+++ b/include/asm-x86/amd_iommu_types.h
@@ -17,8 +17,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
  */
 
-#ifndef ASM_X86__AMD_IOMMU_TYPES_H
-#define ASM_X86__AMD_IOMMU_TYPES_H
+#ifndef _ASM_X86_AMD_IOMMU_TYPES_H
+#define _ASM_X86_AMD_IOMMU_TYPES_H
 
 #include <linux/types.h>
 #include <linux/list.h>
@@ -401,4 +401,4 @@ static inline u16 calc_devid(u8 bus, u8 devfn)
 	return (((u16)bus) << 8) | devfn;
 }
 
-#endif /* ASM_X86__AMD_IOMMU_TYPES_H */
+#endif /* _ASM_X86_AMD_IOMMU_TYPES_H */
diff --git a/include/asm-x86/apic.h b/include/asm-x86/apic.h
index ef1d72d..3b1510b 100644
--- a/include/asm-x86/apic.h
+++ b/include/asm-x86/apic.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__APIC_H
-#define ASM_X86__APIC_H
+#ifndef _ASM_X86_APIC_H
+#define _ASM_X86_APIC_H
 
 #include <linux/pm.h>
 #include <linux/delay.h>
@@ -196,4 +196,4 @@ static inline void init_apic_mappings(void) { }
 
 #endif /* !CONFIG_X86_LOCAL_APIC */
 
-#endif /* ASM_X86__APIC_H */
+#endif /* _ASM_X86_APIC_H */
diff --git a/include/asm-x86/apicdef.h b/include/asm-x86/apicdef.h
index b922c85..63134e3 100644
--- a/include/asm-x86/apicdef.h
+++ b/include/asm-x86/apicdef.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__APICDEF_H
-#define ASM_X86__APICDEF_H
+#ifndef _ASM_X86_APICDEF_H
+#define _ASM_X86_APICDEF_H
 
 /*
  * Constants for various Intel APICs. (local APIC, IOAPIC, etc.)
@@ -414,4 +414,4 @@ struct local_apic {
 #else
  #define BAD_APICID 0xFFFFu
 #endif
-#endif /* ASM_X86__APICDEF_H */
+#endif /* _ASM_X86_APICDEF_H */
diff --git a/include/asm-x86/arch_hooks.h b/include/asm-x86/arch_hooks.h
index de4596b..cbd4957 100644
--- a/include/asm-x86/arch_hooks.h
+++ b/include/asm-x86/arch_hooks.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__ARCH_HOOKS_H
-#define ASM_X86__ARCH_HOOKS_H
+#ifndef _ASM_X86_ARCH_HOOKS_H
+#define _ASM_X86_ARCH_HOOKS_H
 
 #include <linux/interrupt.h>
 
@@ -23,4 +23,4 @@ extern void pre_time_init_hook(void);
 extern void time_init_hook(void);
 extern void mca_nmi_hook(void);
 
-#endif /* ASM_X86__ARCH_HOOKS_H */
+#endif /* _ASM_X86_ARCH_HOOKS_H */
diff --git a/include/asm-x86/asm.h b/include/asm-x86/asm.h
index e1355f4..56be78f 100644
--- a/include/asm-x86/asm.h
+++ b/include/asm-x86/asm.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__ASM_H
-#define ASM_X86__ASM_H
+#ifndef _ASM_X86_ASM_H
+#define _ASM_X86_ASM_H
 
 #ifdef __ASSEMBLY__
 # define __ASM_FORM(x)	x
@@ -44,4 +44,4 @@
 	_ASM_PTR #from "," #to "\n" \
 	" .previous\n"
 
-#endif /* ASM_X86__ASM_H */
+#endif /* _ASM_X86_ASM_H */
diff --git a/include/asm-x86/atomic_32.h b/include/asm-x86/atomic_32.h
index 14d3f0b..ad5b9f6 100644
--- a/include/asm-x86/atomic_32.h
+++ b/include/asm-x86/atomic_32.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__ATOMIC_32_H
-#define ASM_X86__ATOMIC_32_H
+#ifndef _ASM_X86_ATOMIC_32_H
+#define _ASM_X86_ATOMIC_32_H
 
 #include <linux/compiler.h>
 #include <asm/processor.h>
@@ -256,4 +256,4 @@ static inline int atomic_add_unless(atomic_t *v, int a, int u)
 #define smp_mb__after_atomic_inc()	barrier()
 
 #include <asm-generic/atomic.h>
-#endif /* ASM_X86__ATOMIC_32_H */
+#endif /* _ASM_X86_ATOMIC_32_H */
diff --git a/include/asm-x86/atomic_64.h b/include/asm-x86/atomic_64.h
index 2cb218c..279d2a7 100644
--- a/include/asm-x86/atomic_64.h
+++ b/include/asm-x86/atomic_64.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__ATOMIC_64_H
-#define ASM_X86__ATOMIC_64_H
+#ifndef _ASM_X86_ATOMIC_64_H
+#define _ASM_X86_ATOMIC_64_H
 
 #include <asm/alternative.h>
 #include <asm/cmpxchg.h>
@@ -470,4 +470,4 @@ static inline void atomic_or_long(unsigned long *v1, unsigned long v2)
 #define smp_mb__after_atomic_inc()	barrier()
 
 #include <asm-generic/atomic.h>
-#endif /* ASM_X86__ATOMIC_64_H */
+#endif /* _ASM_X86_ATOMIC_64_H */
diff --git a/include/asm-x86/auxvec.h b/include/asm-x86/auxvec.h
index 12c7cac..1316b4c 100644
--- a/include/asm-x86/auxvec.h
+++ b/include/asm-x86/auxvec.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__AUXVEC_H
-#define ASM_X86__AUXVEC_H
+#ifndef _ASM_X86_AUXVEC_H
+#define _ASM_X86_AUXVEC_H
 /*
  * Architecture-neutral AT_ values in 0-17, leave some room
  * for more of them, start the x86-specific ones at 32.
@@ -9,4 +9,4 @@
 #endif
 #define AT_SYSINFO_EHDR		33
 
-#endif /* ASM_X86__AUXVEC_H */
+#endif /* _ASM_X86_AUXVEC_H */
diff --git a/include/asm-x86/bios_ebda.h b/include/asm-x86/bios_ebda.h
index ec42ed8..32685a8 100644
--- a/include/asm-x86/bios_ebda.h
+++ b/include/asm-x86/bios_ebda.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__BIOS_EBDA_H
-#define ASM_X86__BIOS_EBDA_H
+#ifndef _ASM_X86_BIOS_EBDA_H
+#define _ASM_X86_BIOS_EBDA_H
 
 #include <asm/io.h>
 
@@ -16,4 +16,4 @@ static inline unsigned int get_bios_ebda(void)
 
 void reserve_ebda_region(void);
 
-#endif /* ASM_X86__BIOS_EBDA_H */
+#endif /* _ASM_X86_BIOS_EBDA_H */
diff --git a/include/asm-x86/bitops.h b/include/asm-x86/bitops.h
index 451a747..3600103 100644
--- a/include/asm-x86/bitops.h
+++ b/include/asm-x86/bitops.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__BITOPS_H
-#define ASM_X86__BITOPS_H
+#ifndef _ASM_X86_BITOPS_H
+#define _ASM_X86_BITOPS_H
 
 /*
  * Copyright 1992, Linus Torvalds.
@@ -448,4 +448,4 @@ static inline int fls(int x)
 #include <asm-generic/bitops/minix.h>
 
 #endif /* __KERNEL__ */
-#endif /* ASM_X86__BITOPS_H */
+#endif /* _ASM_X86_BITOPS_H */
diff --git a/include/asm-x86/boot.h b/include/asm-x86/boot.h
index 1d63bd5..dd61616 100644
--- a/include/asm-x86/boot.h
+++ b/include/asm-x86/boot.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__BOOT_H
-#define ASM_X86__BOOT_H
+#ifndef _ASM_X86_BOOT_H
+#define _ASM_X86_BOOT_H
 
 /* Don't touch these, unless you really know what you're doing. */
 #define DEF_SYSSEG	0x1000
@@ -23,4 +23,4 @@
 #define BOOT_STACK_SIZE	0x1000
 #endif
 
-#endif /* ASM_X86__BOOT_H */
+#endif /* _ASM_X86_BOOT_H */
diff --git a/include/asm-x86/bootparam.h b/include/asm-x86/bootparam.h
index ccf027e..433adae 100644
--- a/include/asm-x86/bootparam.h
+++ b/include/asm-x86/bootparam.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__BOOTPARAM_H
-#define ASM_X86__BOOTPARAM_H
+#ifndef _ASM_X86_BOOTPARAM_H
+#define _ASM_X86_BOOTPARAM_H
 
 #include <linux/types.h>
 #include <linux/screen_info.h>
@@ -108,4 +108,4 @@ struct boot_params {
 	__u8  _pad9[276];				/* 0xeec */
 } __attribute__((packed));
 
-#endif /* ASM_X86__BOOTPARAM_H */
+#endif /* _ASM_X86_BOOTPARAM_H */
diff --git a/include/asm-x86/bug.h b/include/asm-x86/bug.h
index 91ad43a..3def206 100644
--- a/include/asm-x86/bug.h
+++ b/include/asm-x86/bug.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__BUG_H
-#define ASM_X86__BUG_H
+#ifndef _ASM_X86_BUG_H
+#define _ASM_X86_BUG_H
 
 #ifdef CONFIG_BUG
 #define HAVE_ARCH_BUG
@@ -36,4 +36,4 @@ do {								\
 #endif /* !CONFIG_BUG */
 
 #include <asm-generic/bug.h>
-#endif /* ASM_X86__BUG_H */
+#endif /* _ASM_X86_BUG_H */
diff --git a/include/asm-x86/bugs.h b/include/asm-x86/bugs.h
index dc60498..08abf63 100644
--- a/include/asm-x86/bugs.h
+++ b/include/asm-x86/bugs.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__BUGS_H
-#define ASM_X86__BUGS_H
+#ifndef _ASM_X86_BUGS_H
+#define _ASM_X86_BUGS_H
 
 extern void check_bugs(void);
 
@@ -9,4 +9,4 @@ int ppro_with_ram_bug(void);
 static inline int ppro_with_ram_bug(void) { return 0; }
 #endif
 
-#endif /* ASM_X86__BUGS_H */
+#endif /* _ASM_X86_BUGS_H */
diff --git a/include/asm-x86/byteorder.h b/include/asm-x86/byteorder.h
index 722f27d..e02ae2d 100644
--- a/include/asm-x86/byteorder.h
+++ b/include/asm-x86/byteorder.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__BYTEORDER_H
-#define ASM_X86__BYTEORDER_H
+#ifndef _ASM_X86_BYTEORDER_H
+#define _ASM_X86_BYTEORDER_H
 
 #include <asm/types.h>
 #include <linux/compiler.h>
@@ -78,4 +78,4 @@ static inline __attribute_const__ __u32 ___arch__swab32(__u32 x)
 
 #include <linux/byteorder/little_endian.h>
 
-#endif /* ASM_X86__BYTEORDER_H */
+#endif /* _ASM_X86_BYTEORDER_H */
diff --git a/include/asm-x86/cache.h b/include/asm-x86/cache.h
index ea3f1cc..5d367ca 100644
--- a/include/asm-x86/cache.h
+++ b/include/asm-x86/cache.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__CACHE_H
-#define ASM_X86__CACHE_H
+#ifndef _ASM_X86_CACHE_H
+#define _ASM_X86_CACHE_H
 
 /* L1 cache line size */
 #define L1_CACHE_SHIFT	(CONFIG_X86_L1_CACHE_SHIFT)
@@ -17,4 +17,4 @@
 #endif
 #endif
 
-#endif /* ASM_X86__CACHE_H */
+#endif /* _ASM_X86_CACHE_H */
diff --git a/include/asm-x86/cacheflush.h b/include/asm-x86/cacheflush.h
index 68840ef..2f84665 100644
--- a/include/asm-x86/cacheflush.h
+++ b/include/asm-x86/cacheflush.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__CACHEFLUSH_H
-#define ASM_X86__CACHEFLUSH_H
+#ifndef _ASM_X86_CACHEFLUSH_H
+#define _ASM_X86_CACHEFLUSH_H
 
 /* Keep includes the same across arches.  */
 #include <linux/mm.h>
@@ -115,4 +115,4 @@ static inline int rodata_test(void)
 }
 #endif
 
-#endif /* ASM_X86__CACHEFLUSH_H */
+#endif /* _ASM_X86_CACHEFLUSH_H */
diff --git a/include/asm-x86/calgary.h b/include/asm-x86/calgary.h
index 933fd27..b03bedb 100644
--- a/include/asm-x86/calgary.h
+++ b/include/asm-x86/calgary.h
@@ -21,8 +21,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
  */
 
-#ifndef ASM_X86__CALGARY_H
-#define ASM_X86__CALGARY_H
+#ifndef _ASM_X86_CALGARY_H
+#define _ASM_X86_CALGARY_H
 
 #include <linux/spinlock.h>
 #include <linux/device.h>
@@ -69,4 +69,4 @@ static inline int calgary_iommu_init(void) { return 1; }
 static inline void detect_calgary(void) { return; }
 #endif
 
-#endif /* ASM_X86__CALGARY_H */
+#endif /* _ASM_X86_CALGARY_H */
diff --git a/include/asm-x86/checksum_32.h b/include/asm-x86/checksum_32.h
index d041e8c..7c5ef8b 100644
--- a/include/asm-x86/checksum_32.h
+++ b/include/asm-x86/checksum_32.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__CHECKSUM_32_H
-#define ASM_X86__CHECKSUM_32_H
+#ifndef _ASM_X86_CHECKSUM_32_H
+#define _ASM_X86_CHECKSUM_32_H
 
 #include <linux/in6.h>
 
@@ -186,4 +186,4 @@ static inline __wsum csum_and_copy_to_user(const void *src,
 	return (__force __wsum)-1; /* invalid checksum */
 }
 
-#endif /* ASM_X86__CHECKSUM_32_H */
+#endif /* _ASM_X86_CHECKSUM_32_H */
diff --git a/include/asm-x86/checksum_64.h b/include/asm-x86/checksum_64.h
index 110f403..9bfdc41 100644
--- a/include/asm-x86/checksum_64.h
+++ b/include/asm-x86/checksum_64.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__CHECKSUM_64_H
-#define ASM_X86__CHECKSUM_64_H
+#ifndef _ASM_X86_CHECKSUM_64_H
+#define _ASM_X86_CHECKSUM_64_H
 
 /*
  * Checksums for x86-64
@@ -188,4 +188,4 @@ static inline unsigned add32_with_carry(unsigned a, unsigned b)
 	return a;
 }
 
-#endif /* ASM_X86__CHECKSUM_64_H */
+#endif /* _ASM_X86_CHECKSUM_64_H */
diff --git a/include/asm-x86/cmpxchg_32.h b/include/asm-x86/cmpxchg_32.h
index 0622e45..82ceb78 100644
--- a/include/asm-x86/cmpxchg_32.h
+++ b/include/asm-x86/cmpxchg_32.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__CMPXCHG_32_H
-#define ASM_X86__CMPXCHG_32_H
+#ifndef _ASM_X86_CMPXCHG_32_H
+#define _ASM_X86_CMPXCHG_32_H
 
 #include <linux/bitops.h> /* for LOCK_PREFIX */
 
@@ -341,4 +341,4 @@ extern unsigned long long cmpxchg_486_u64(volatile void *, u64, u64);
 
 #endif
 
-#endif /* ASM_X86__CMPXCHG_32_H */
+#endif /* _ASM_X86_CMPXCHG_32_H */
diff --git a/include/asm-x86/cmpxchg_64.h b/include/asm-x86/cmpxchg_64.h
index 63c1a5e..52de72e 100644
--- a/include/asm-x86/cmpxchg_64.h
+++ b/include/asm-x86/cmpxchg_64.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__CMPXCHG_64_H
-#define ASM_X86__CMPXCHG_64_H
+#ifndef _ASM_X86_CMPXCHG_64_H
+#define _ASM_X86_CMPXCHG_64_H
 
 #include <asm/alternative.h> /* Provides LOCK_PREFIX */
 
@@ -182,4 +182,4 @@ static inline unsigned long __cmpxchg_local(volatile void *ptr,
 	cmpxchg_local((ptr), (o), (n));					\
 })
 
-#endif /* ASM_X86__CMPXCHG_64_H */
+#endif /* _ASM_X86_CMPXCHG_64_H */
diff --git a/include/asm-x86/compat.h b/include/asm-x86/compat.h
index 6732b15..9a9c7bd 100644
--- a/include/asm-x86/compat.h
+++ b/include/asm-x86/compat.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__COMPAT_H
-#define ASM_X86__COMPAT_H
+#ifndef _ASM_X86_COMPAT_H
+#define _ASM_X86_COMPAT_H
 
 /*
  * Architecture specific compatibility types
@@ -215,4 +215,4 @@ static inline int is_compat_task(void)
 	return current_thread_info()->status & TS_COMPAT;
 }
 
-#endif /* ASM_X86__COMPAT_H */
+#endif /* _ASM_X86_COMPAT_H */
diff --git a/include/asm-x86/cpu.h b/include/asm-x86/cpu.h
index 83a1150..bae482d 100644
--- a/include/asm-x86/cpu.h
+++ b/include/asm-x86/cpu.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__CPU_H
-#define ASM_X86__CPU_H
+#ifndef _ASM_X86_CPU_H
+#define _ASM_X86_CPU_H
 
 #include <linux/device.h>
 #include <linux/cpu.h>
@@ -17,4 +17,4 @@ extern void arch_unregister_cpu(int);
 #endif
 
 DECLARE_PER_CPU(int, cpu_state);
-#endif /* ASM_X86__CPU_H */
+#endif /* _ASM_X86_CPU_H */
diff --git a/include/asm-x86/cpufeature.h b/include/asm-x86/cpufeature.h
index 98cadc9..cfdf8c2 100644
--- a/include/asm-x86/cpufeature.h
+++ b/include/asm-x86/cpufeature.h
@@ -1,8 +1,8 @@
 /*
  * Defines x86 CPU feature bits
  */
-#ifndef ASM_X86__CPUFEATURE_H
-#define ASM_X86__CPUFEATURE_H
+#ifndef _ASM_X86_CPUFEATURE_H
+#define _ASM_X86_CPUFEATURE_H
 
 #include <asm/required-features.h>
 
@@ -268,4 +268,4 @@ extern const char * const x86_power_flags[32];
 
 #endif /* defined(__KERNEL__) && !defined(__ASSEMBLY__) */
 
-#endif /* ASM_X86__CPUFEATURE_H */
+#endif /* _ASM_X86_CPUFEATURE_H */
diff --git a/include/asm-x86/current.h b/include/asm-x86/current.h
index a863ead..0930b4f 100644
--- a/include/asm-x86/current.h
+++ b/include/asm-x86/current.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__CURRENT_H
-#define ASM_X86__CURRENT_H
+#ifndef _ASM_X86_CURRENT_H
+#define _ASM_X86_CURRENT_H
 
 #ifdef CONFIG_X86_32
 #include <linux/compiler.h>
@@ -36,4 +36,4 @@ static __always_inline struct task_struct *get_current(void)
 
 #define current get_current()
 
-#endif /* ASM_X86__CURRENT_H */
+#endif /* _ASM_X86_CURRENT_H */
diff --git a/include/asm-x86/debugreg.h b/include/asm-x86/debugreg.h
index ecb6907..3ea6f37 100644
--- a/include/asm-x86/debugreg.h
+++ b/include/asm-x86/debugreg.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__DEBUGREG_H
-#define ASM_X86__DEBUGREG_H
+#ifndef _ASM_X86_DEBUGREG_H
+#define _ASM_X86_DEBUGREG_H
 
 
 /* Indicate the register numbers for a number of the specific
@@ -67,4 +67,4 @@
 #define DR_LOCAL_SLOWDOWN (0x100)   /* Local slow the pipeline */
 #define DR_GLOBAL_SLOWDOWN (0x200)  /* Global slow the pipeline */
 
-#endif /* ASM_X86__DEBUGREG_H */
+#endif /* _ASM_X86_DEBUGREG_H */
diff --git a/include/asm-x86/delay.h b/include/asm-x86/delay.h
index 8a0da95..409a649 100644
--- a/include/asm-x86/delay.h
+++ b/include/asm-x86/delay.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__DELAY_H
-#define ASM_X86__DELAY_H
+#ifndef _ASM_X86_DELAY_H
+#define _ASM_X86_DELAY_H
 
 /*
  * Copyright (C) 1993 Linus Torvalds
@@ -28,4 +28,4 @@ extern void __delay(unsigned long loops);
 
 void use_tsc_delay(void);
 
-#endif /* ASM_X86__DELAY_H */
+#endif /* _ASM_X86_DELAY_H */
diff --git a/include/asm-x86/desc.h b/include/asm-x86/desc.h
index f06adac..e6b82b1 100644
--- a/include/asm-x86/desc.h
+++ b/include/asm-x86/desc.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__DESC_H
-#define ASM_X86__DESC_H
+#ifndef _ASM_X86_DESC_H
+#define _ASM_X86_DESC_H
 
 #ifndef __ASSEMBLY__
 #include <asm/desc_defs.h>
@@ -406,4 +406,4 @@ static inline void set_system_intr_gate_ist(int n, void *addr, unsigned ist)
 
 #endif /* __ASSEMBLY__ */
 
-#endif /* ASM_X86__DESC_H */
+#endif /* _ASM_X86_DESC_H */
diff --git a/include/asm-x86/desc_defs.h b/include/asm-x86/desc_defs.h
index b881db6..a6adefa 100644
--- a/include/asm-x86/desc_defs.h
+++ b/include/asm-x86/desc_defs.h
@@ -1,6 +1,6 @@
 /* Written 2000 by Andi Kleen */
-#ifndef ASM_X86__DESC_DEFS_H
-#define ASM_X86__DESC_DEFS_H
+#ifndef _ASM_X86_DESC_DEFS_H
+#define _ASM_X86_DESC_DEFS_H
 
 /*
  * Segment descriptor structure definitions, usable from both x86_64 and i386
@@ -92,4 +92,4 @@ struct desc_ptr {
 
 #endif /* !__ASSEMBLY__ */
 
-#endif /* ASM_X86__DESC_DEFS_H */
+#endif /* _ASM_X86_DESC_DEFS_H */
diff --git a/include/asm-x86/device.h b/include/asm-x86/device.h
index 1bece04..3c034f4 100644
--- a/include/asm-x86/device.h
+++ b/include/asm-x86/device.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__DEVICE_H
-#define ASM_X86__DEVICE_H
+#ifndef _ASM_X86_DEVICE_H
+#define _ASM_X86_DEVICE_H
 
 struct dev_archdata {
 #ifdef CONFIG_ACPI
@@ -13,4 +13,4 @@ struct dma_mapping_ops *dma_ops;
 #endif
 };
 
-#endif /* ASM_X86__DEVICE_H */
+#endif /* _ASM_X86_DEVICE_H */
diff --git a/include/asm-x86/div64.h b/include/asm-x86/div64.h
index f9530f2..9a2d644 100644
--- a/include/asm-x86/div64.h
+++ b/include/asm-x86/div64.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__DIV64_H
-#define ASM_X86__DIV64_H
+#ifndef _ASM_X86_DIV64_H
+#define _ASM_X86_DIV64_H
 
 #ifdef CONFIG_X86_32
 
@@ -57,4 +57,4 @@ static inline u64 div_u64_rem(u64 dividend, u32 divisor, u32 *remainder)
 # include <asm-generic/div64.h>
 #endif /* CONFIG_X86_32 */
 
-#endif /* ASM_X86__DIV64_H */
+#endif /* _ASM_X86_DIV64_H */
diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
index 7b9f308..3293b96 100644
--- a/include/asm-x86/dma-mapping.h
+++ b/include/asm-x86/dma-mapping.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__DMA_MAPPING_H
-#define ASM_X86__DMA_MAPPING_H
+#ifndef _ASM_X86_DMA_MAPPING_H
+#define _ASM_X86_DMA_MAPPING_H
 
 /*
  * IOMMU interface. See Documentation/DMA-mapping.txt and DMA-API.txt for
@@ -66,7 +66,7 @@ static inline struct dma_mapping_ops *get_dma_ops(struct device *dev)
 		return dma_ops;
 	else
 		return dev->archdata.dma_ops;
-#endif /* ASM_X86__DMA_MAPPING_H */
+#endif /* _ASM_X86_DMA_MAPPING_H */
 }
 
 /* Make sure we keep the same behaviour */
diff --git a/include/asm-x86/dma.h b/include/asm-x86/dma.h
index c9f7a4e..ca1098a 100644
--- a/include/asm-x86/dma.h
+++ b/include/asm-x86/dma.h
@@ -5,8 +5,8 @@
  * and John Boyd, Nov. 1992.
  */
 
-#ifndef ASM_X86__DMA_H
-#define ASM_X86__DMA_H
+#ifndef _ASM_X86_DMA_H
+#define _ASM_X86_DMA_H
 
 #include <linux/spinlock.h>	/* And spinlocks */
 #include <asm/io.h>		/* need byte IO */
@@ -315,4 +315,4 @@ extern int isa_dma_bridge_buggy;
 #define isa_dma_bridge_buggy	(0)
 #endif
 
-#endif /* ASM_X86__DMA_H */
+#endif /* _ASM_X86_DMA_H */
diff --git a/include/asm-x86/dmi.h b/include/asm-x86/dmi.h
index 1cff6fe..bc68212 100644
--- a/include/asm-x86/dmi.h
+++ b/include/asm-x86/dmi.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__DMI_H
-#define ASM_X86__DMI_H
+#ifndef _ASM_X86_DMI_H
+#define _ASM_X86_DMI_H
 
 #include <asm/io.h>
 
@@ -23,4 +23,4 @@ static inline void *dmi_alloc(unsigned len)
 #define dmi_ioremap early_ioremap
 #define dmi_iounmap early_iounmap
 
-#endif /* ASM_X86__DMI_H */
+#endif /* _ASM_X86_DMI_H */
diff --git a/include/asm-x86/ds.h b/include/asm-x86/ds.h
index c3c953a..72c5a19 100644
--- a/include/asm-x86/ds.h
+++ b/include/asm-x86/ds.h
@@ -20,8 +20,8 @@
  * Markus Metzger <markus.t.metzger@intel.com>, 2007-2008
  */
 
-#ifndef ASM_X86__DS_H
-#define ASM_X86__DS_H
+#ifndef _ASM_X86_DS_H
+#define _ASM_X86_DS_H
 
 #ifdef CONFIG_X86_DS
 
@@ -235,4 +235,4 @@ extern void ds_free(struct ds_context *context);
 #define ds_init_intel(config) do {} while (0)
 
 #endif /* CONFIG_X86_DS */
-#endif /* ASM_X86__DS_H */
+#endif /* _ASM_X86_DS_H */
diff --git a/include/asm-x86/dwarf2.h b/include/asm-x86/dwarf2.h
index 21d1bc3..804b6e6 100644
--- a/include/asm-x86/dwarf2.h
+++ b/include/asm-x86/dwarf2.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__DWARF2_H
-#define ASM_X86__DWARF2_H
+#ifndef _ASM_X86_DWARF2_H
+#define _ASM_X86_DWARF2_H
 
 #ifndef __ASSEMBLY__
 #warning "asm/dwarf2.h should be only included in pure assembly files"
@@ -58,4 +58,4 @@
 
 #endif
 
-#endif /* ASM_X86__DWARF2_H */
+#endif /* _ASM_X86_DWARF2_H */
diff --git a/include/asm-x86/e820.h b/include/asm-x86/e820.h
index 5abbdec..3d8cedd 100644
--- a/include/asm-x86/e820.h
+++ b/include/asm-x86/e820.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__E820_H
-#define ASM_X86__E820_H
+#ifndef _ASM_X86_E820_H
+#define _ASM_X86_E820_H
 #define E820MAP	0x2d0		/* our map */
 #define E820MAX	128		/* number of entries in E820MAP */
 
@@ -143,4 +143,4 @@ extern char *memory_setup(void);
 #define HIGH_MEMORY	(1024*1024)
 #endif /* __KERNEL__ */
 
-#endif /* ASM_X86__E820_H */
+#endif /* _ASM_X86_E820_H */
diff --git a/include/asm-x86/edac.h b/include/asm-x86/edac.h
index 9493c5b..e9b57ec 100644
--- a/include/asm-x86/edac.h
+++ b/include/asm-x86/edac.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__EDAC_H
-#define ASM_X86__EDAC_H
+#ifndef _ASM_X86_EDAC_H
+#define _ASM_X86_EDAC_H
 
 /* ECC atomic, DMA, SMP and interrupt safe scrub function */
 
@@ -15,4 +15,4 @@ static inline void atomic_scrub(void *va, u32 size)
 		asm volatile("lock; addl $0, %0"::"m" (*virt_addr));
 }
 
-#endif /* ASM_X86__EDAC_H */
+#endif /* _ASM_X86_EDAC_H */
diff --git a/include/asm-x86/efi.h b/include/asm-x86/efi.h
index 313438e..a2e545c 100644
--- a/include/asm-x86/efi.h
+++ b/include/asm-x86/efi.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__EFI_H
-#define ASM_X86__EFI_H
+#ifndef _ASM_X86_EFI_H
+#define _ASM_X86_EFI_H
 
 #ifdef CONFIG_X86_32
 
@@ -107,4 +107,4 @@ extern void efi_call_phys_epilog(void);
 #define efi_call6(_f, _a1, _a2, _a3, _a4, _a5, _a6)	(-ENOSYS)
 #endif /* CONFIG_EFI */
 
-#endif /* ASM_X86__EFI_H */
+#endif /* _ASM_X86_EFI_H */
diff --git a/include/asm-x86/elf.h b/include/asm-x86/elf.h
index 5c4745b..bd8f493 100644
--- a/include/asm-x86/elf.h
+++ b/include/asm-x86/elf.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__ELF_H
-#define ASM_X86__ELF_H
+#ifndef _ASM_X86_ELF_H
+#define _ASM_X86_ELF_H
 
 /*
  * ELF register definitions..
@@ -333,4 +333,4 @@ extern int syscall32_setup_pages(struct linux_binprm *, int exstack);
 extern unsigned long arch_randomize_brk(struct mm_struct *mm);
 #define arch_randomize_brk arch_randomize_brk
 
-#endif /* ASM_X86__ELF_H */
+#endif /* _ASM_X86_ELF_H */
diff --git a/include/asm-x86/emergency-restart.h b/include/asm-x86/emergency-restart.h
index 190d0d8..94826cf 100644
--- a/include/asm-x86/emergency-restart.h
+++ b/include/asm-x86/emergency-restart.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__EMERGENCY_RESTART_H
-#define ASM_X86__EMERGENCY_RESTART_H
+#ifndef _ASM_X86_EMERGENCY_RESTART_H
+#define _ASM_X86_EMERGENCY_RESTART_H
 
 enum reboot_type {
 	BOOT_TRIPLE = 't',
@@ -15,4 +15,4 @@ extern enum reboot_type reboot_type;
 
 extern void machine_emergency_restart(void);
 
-#endif /* ASM_X86__EMERGENCY_RESTART_H */
+#endif /* _ASM_X86_EMERGENCY_RESTART_H */
diff --git a/include/asm-x86/fb.h b/include/asm-x86/fb.h
index aca38db..5301846 100644
--- a/include/asm-x86/fb.h
+++ b/include/asm-x86/fb.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__FB_H
-#define ASM_X86__FB_H
+#ifndef _ASM_X86_FB_H
+#define _ASM_X86_FB_H
 
 #include <linux/fb.h>
 #include <linux/fs.h>
@@ -18,4 +18,4 @@ extern int fb_is_primary_device(struct fb_info *info);
 static inline int fb_is_primary_device(struct fb_info *info) { return 0; }
 #endif
 
-#endif /* ASM_X86__FB_H */
+#endif /* _ASM_X86_FB_H */
diff --git a/include/asm-x86/fixmap.h b/include/asm-x86/fixmap.h
index 78e33a1..8668a94 100644
--- a/include/asm-x86/fixmap.h
+++ b/include/asm-x86/fixmap.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__FIXMAP_H
-#define ASM_X86__FIXMAP_H
+#ifndef _ASM_X86_FIXMAP_H
+#define _ASM_X86_FIXMAP_H
 
 #ifdef CONFIG_X86_32
 # include "fixmap_32.h"
@@ -65,4 +65,4 @@ static inline unsigned long virt_to_fix(const unsigned long vaddr)
 	BUG_ON(vaddr >= FIXADDR_TOP || vaddr < FIXADDR_START);
 	return __virt_to_fix(vaddr);
 }
-#endif /* ASM_X86__FIXMAP_H */
+#endif /* _ASM_X86_FIXMAP_H */
diff --git a/include/asm-x86/fixmap_32.h b/include/asm-x86/fixmap_32.h
index c6fde10..921a2d4 100644
--- a/include/asm-x86/fixmap_32.h
+++ b/include/asm-x86/fixmap_32.h
@@ -10,8 +10,8 @@
  * Support of BIGMEM added by Gerhard Wichert, Siemens AG, July 1999
  */
 
-#ifndef ASM_X86__FIXMAP_32_H
-#define ASM_X86__FIXMAP_32_H
+#ifndef _ASM_X86_FIXMAP_32_H
+#define _ASM_X86_FIXMAP_32_H
 
 
 /* used by vmalloc.c, vsyscall.lds.S.
@@ -116,4 +116,4 @@ extern void reserve_top_address(unsigned long reserve);
 #define FIXADDR_BOOT_START	(FIXADDR_TOP - __FIXADDR_BOOT_SIZE)
 
 #endif /* !__ASSEMBLY__ */
-#endif /* ASM_X86__FIXMAP_32_H */
+#endif /* _ASM_X86_FIXMAP_32_H */
diff --git a/include/asm-x86/fixmap_64.h b/include/asm-x86/fixmap_64.h
index a6ff01d..298d9ba 100644
--- a/include/asm-x86/fixmap_64.h
+++ b/include/asm-x86/fixmap_64.h
@@ -8,8 +8,8 @@
  * Copyright (C) 1998 Ingo Molnar
  */
 
-#ifndef ASM_X86__FIXMAP_64_H
-#define ASM_X86__FIXMAP_64_H
+#ifndef _ASM_X86_FIXMAP_64_H
+#define _ASM_X86_FIXMAP_64_H
 
 #include <linux/kernel.h>
 #include <asm/acpi.h>
@@ -76,4 +76,4 @@ enum fixed_addresses {
 #define FIXADDR_USER_START	((unsigned long)VSYSCALL32_VSYSCALL)
 #define FIXADDR_USER_END	(FIXADDR_USER_START + PAGE_SIZE)
 
-#endif /* ASM_X86__FIXMAP_64_H */
+#endif /* _ASM_X86_FIXMAP_64_H */
diff --git a/include/asm-x86/floppy.h b/include/asm-x86/floppy.h
index 7d83a3a..dbe82a5 100644
--- a/include/asm-x86/floppy.h
+++ b/include/asm-x86/floppy.h
@@ -7,8 +7,8 @@
  *
  * Copyright (C) 1995
  */
-#ifndef ASM_X86__FLOPPY_H
-#define ASM_X86__FLOPPY_H
+#ifndef _ASM_X86_FLOPPY_H
+#define _ASM_X86_FLOPPY_H
 
 #include <linux/vmalloc.h>
 
@@ -278,4 +278,4 @@ static int FDC2 = -1;
 
 #define EXTRA_FLOPPY_PARAMS
 
-#endif /* ASM_X86__FLOPPY_H */
+#endif /* _ASM_X86_FLOPPY_H */
diff --git a/include/asm-x86/ftrace.h b/include/asm-x86/ftrace.h
index 1bb6f9b..47f7e65 100644
--- a/include/asm-x86/ftrace.h
+++ b/include/asm-x86/ftrace.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__FTRACE_H
-#define ASM_X86__FTRACE_H
+#ifndef _ASM_X86_FTRACE_H
+#define _ASM_X86_FTRACE_H
 
 #ifdef CONFIG_FTRACE
 #define MCOUNT_ADDR		((long)(mcount))
@@ -21,4 +21,4 @@ static inline unsigned long ftrace_call_adjust(unsigned long addr)
 
 #endif /* CONFIG_FTRACE */
 
-#endif /* ASM_X86__FTRACE_H */
+#endif /* _ASM_X86_FTRACE_H */
diff --git a/include/asm-x86/futex.h b/include/asm-x86/futex.h
index 06b924e..1f11ce4 100644
--- a/include/asm-x86/futex.h
+++ b/include/asm-x86/futex.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__FUTEX_H
-#define ASM_X86__FUTEX_H
+#ifndef _ASM_X86_FUTEX_H
+#define _ASM_X86_FUTEX_H
 
 #ifdef __KERNEL__
 
@@ -137,4 +137,4 @@ static inline int futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval,
 }
 
 #endif
-#endif /* ASM_X86__FUTEX_H */
+#endif /* _ASM_X86_FUTEX_H */
diff --git a/include/asm-x86/gart.h b/include/asm-x86/gart.h
index 605edb3..7425226 100644
--- a/include/asm-x86/gart.h
+++ b/include/asm-x86/gart.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__GART_H
-#define ASM_X86__GART_H
+#ifndef _ASM_X86_GART_H
+#define _ASM_X86_GART_H
 
 #include <asm/e820.h>
 
@@ -70,4 +70,4 @@ static inline int aperture_valid(u64 aper_base, u32 aper_size, u32 min_size)
 	return 1;
 }
 
-#endif /* ASM_X86__GART_H */
+#endif /* _ASM_X86_GART_H */
diff --git a/include/asm-x86/genapic_32.h b/include/asm-x86/genapic_32.h
index 6fe4f81..5cbd4fc 100644
--- a/include/asm-x86/genapic_32.h
+++ b/include/asm-x86/genapic_32.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__GENAPIC_32_H
-#define ASM_X86__GENAPIC_32_H
+#ifndef _ASM_X86_GENAPIC_32_H
+#define _ASM_X86_GENAPIC_32_H
 
 #include <asm/mpspec.h>
 
@@ -123,4 +123,4 @@ enum uv_system_type {UV_NONE, UV_LEGACY_APIC, UV_X2APIC, UV_NON_UNIQUE_APIC};
 #define uv_system_init()		do {} while (0)
 
 
-#endif /* ASM_X86__GENAPIC_32_H */
+#endif /* _ASM_X86_GENAPIC_32_H */
diff --git a/include/asm-x86/genapic_64.h b/include/asm-x86/genapic_64.h
index ed6a488..13c4e96 100644
--- a/include/asm-x86/genapic_64.h
+++ b/include/asm-x86/genapic_64.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__GENAPIC_64_H
-#define ASM_X86__GENAPIC_64_H
+#ifndef _ASM_X86_GENAPIC_64_H
+#define _ASM_X86_GENAPIC_64_H
 
 /*
  * Copyright 2004 James Cleverdon, IBM.
@@ -55,4 +55,4 @@ extern int uv_wakeup_secondary(int phys_apicid, unsigned int start_rip);
 
 extern void setup_apic_routing(void);
 
-#endif /* ASM_X86__GENAPIC_64_H */
+#endif /* _ASM_X86_GENAPIC_64_H */
diff --git a/include/asm-x86/geode.h b/include/asm-x86/geode.h
index 3f3444b..ad3c2ed 100644
--- a/include/asm-x86/geode.h
+++ b/include/asm-x86/geode.h
@@ -7,8 +7,8 @@
  * as published by the Free Software Foundation.
  */
 
-#ifndef ASM_X86__GEODE_H
-#define ASM_X86__GEODE_H
+#ifndef _ASM_X86_GEODE_H
+#define _ASM_X86_GEODE_H
 
 #include <asm/processor.h>
 #include <linux/io.h>
@@ -250,4 +250,4 @@ extern int __init mfgpt_timer_setup(void);
 static inline int mfgpt_timer_setup(void) { return 0; }
 #endif
 
-#endif /* ASM_X86__GEODE_H */
+#endif /* _ASM_X86_GEODE_H */
diff --git a/include/asm-x86/gpio.h b/include/asm-x86/gpio.h
index 497fb98..1c07aad 100644
--- a/include/asm-x86/gpio.h
+++ b/include/asm-x86/gpio.h
@@ -53,4 +53,4 @@ static inline int irq_to_gpio(unsigned int irq)
 
 #endif /* CONFIG_GPIOLIB */
 
-#endif /* ASM_X86__GPIO_H */
+#endif /* _ASM_X86_GPIO_H */
diff --git a/include/asm-x86/hardirq_32.h b/include/asm-x86/hardirq_32.h
index 700fe23..5ca135e 100644
--- a/include/asm-x86/hardirq_32.h
+++ b/include/asm-x86/hardirq_32.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__HARDIRQ_32_H
-#define ASM_X86__HARDIRQ_32_H
+#ifndef _ASM_X86_HARDIRQ_32_H
+#define _ASM_X86_HARDIRQ_32_H
 
 #include <linux/threads.h>
 #include <linux/irq.h>
@@ -25,4 +25,4 @@ DECLARE_PER_CPU(irq_cpustat_t, irq_stat);
 void ack_bad_irq(unsigned int irq);
 #include <linux/irq_cpustat.h>
 
-#endif /* ASM_X86__HARDIRQ_32_H */
+#endif /* _ASM_X86_HARDIRQ_32_H */
diff --git a/include/asm-x86/hardirq_64.h b/include/asm-x86/hardirq_64.h
index f8bd291..1ba381f 100644
--- a/include/asm-x86/hardirq_64.h
+++ b/include/asm-x86/hardirq_64.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__HARDIRQ_64_H
-#define ASM_X86__HARDIRQ_64_H
+#ifndef _ASM_X86_HARDIRQ_64_H
+#define _ASM_X86_HARDIRQ_64_H
 
 #include <linux/threads.h>
 #include <linux/irq.h>
@@ -20,4 +20,4 @@
 
 extern void ack_bad_irq(unsigned int irq);
 
-#endif /* ASM_X86__HARDIRQ_64_H */
+#endif /* _ASM_X86_HARDIRQ_64_H */
diff --git a/include/asm-x86/highmem.h b/include/asm-x86/highmem.h
index bc3f6a2..a3b3b7c 100644
--- a/include/asm-x86/highmem.h
+++ b/include/asm-x86/highmem.h
@@ -15,8 +15,8 @@
  * Copyright (C) 1999 Ingo Molnar <mingo@redhat.com>
  */
 
-#ifndef ASM_X86__HIGHMEM_H
-#define ASM_X86__HIGHMEM_H
+#ifndef _ASM_X86_HIGHMEM_H
+#define _ASM_X86_HIGHMEM_H
 
 #ifdef __KERNEL__
 
@@ -79,4 +79,4 @@ extern void add_highpages_with_active_regions(int nid, unsigned long start_pfn,
 
 #endif /* __KERNEL__ */
 
-#endif /* ASM_X86__HIGHMEM_H */
+#endif /* _ASM_X86_HIGHMEM_H */
diff --git a/include/asm-x86/hpet.h b/include/asm-x86/hpet.h
index 58b273f..1c22cb0 100644
--- a/include/asm-x86/hpet.h
+++ b/include/asm-x86/hpet.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__HPET_H
-#define ASM_X86__HPET_H
+#ifndef _ASM_X86_HPET_H
+#define _ASM_X86_HPET_H
 
 #include <linux/msi.h>
 
@@ -111,4 +111,4 @@ static inline int is_hpet_enabled(void) { return 0; }
 #define hpet_readl(a) 0
 
 #endif
-#endif /* ASM_X86__HPET_H */
+#endif /* _ASM_X86_HPET_H */
diff --git a/include/asm-x86/hugetlb.h b/include/asm-x86/hugetlb.h
index 0b7ec5d..439a9ac 100644
--- a/include/asm-x86/hugetlb.h
+++ b/include/asm-x86/hugetlb.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__HUGETLB_H
-#define ASM_X86__HUGETLB_H
+#ifndef _ASM_X86_HUGETLB_H
+#define _ASM_X86_HUGETLB_H
 
 #include <asm/page.h>
 
@@ -90,4 +90,4 @@ static inline void arch_release_hugepage(struct page *page)
 {
 }
 
-#endif /* ASM_X86__HUGETLB_H */
+#endif /* _ASM_X86_HUGETLB_H */
diff --git a/include/asm-x86/hw_irq.h b/include/asm-x86/hw_irq.h
index 749d042..b97aecb 100644
--- a/include/asm-x86/hw_irq.h
+++ b/include/asm-x86/hw_irq.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__HW_IRQ_H
-#define ASM_X86__HW_IRQ_H
+#ifndef _ASM_X86_HW_IRQ_H
+#define _ASM_X86_HW_IRQ_H
 
 /*
  * (C) 1992, 1993 Linus Torvalds, (C) 1997 Ingo Molnar
@@ -128,4 +128,4 @@ static inline void __setup_vector_irq(int cpu) {}
 
 #endif /* !ASSEMBLY_ */
 
-#endif /* ASM_X86__HW_IRQ_H */
+#endif /* _ASM_X86_HW_IRQ_H */
diff --git a/include/asm-x86/hypertransport.h b/include/asm-x86/hypertransport.h
index cc011a3..334b1a8 100644
--- a/include/asm-x86/hypertransport.h
+++ b/include/asm-x86/hypertransport.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__HYPERTRANSPORT_H
-#define ASM_X86__HYPERTRANSPORT_H
+#ifndef _ASM_X86_HYPERTRANSPORT_H
+#define _ASM_X86_HYPERTRANSPORT_H
 
 /*
  * Constants for x86 Hypertransport Interrupts.
@@ -42,4 +42,4 @@
 #define HT_IRQ_HIGH_DEST_ID(v)						\
 	((((v) >> 8) << HT_IRQ_HIGH_DEST_ID_SHIFT) & HT_IRQ_HIGH_DEST_ID_MASK)
 
-#endif /* ASM_X86__HYPERTRANSPORT_H */
+#endif /* _ASM_X86_HYPERTRANSPORT_H */
diff --git a/include/asm-x86/i387.h b/include/asm-x86/i387.h
index 9ba862a..48f0004 100644
--- a/include/asm-x86/i387.h
+++ b/include/asm-x86/i387.h
@@ -7,8 +7,8 @@
  * x86-64 work by Andi Kleen 2002
  */
 
-#ifndef ASM_X86__I387_H
-#define ASM_X86__I387_H
+#ifndef _ASM_X86_I387_H
+#define _ASM_X86_I387_H
 
 #include <linux/sched.h>
 #include <linux/kernel_stat.h>
@@ -397,4 +397,4 @@ static inline unsigned short get_fpu_mxcsr(struct task_struct *tsk)
 	}
 }
 
-#endif /* ASM_X86__I387_H */
+#endif /* _ASM_X86_I387_H */
diff --git a/include/asm-x86/i8253.h b/include/asm-x86/i8253.h
index 15a5b53..1edbf89 100644
--- a/include/asm-x86/i8253.h
+++ b/include/asm-x86/i8253.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__I8253_H
-#define ASM_X86__I8253_H
+#ifndef _ASM_X86_I8253_H
+#define _ASM_X86_I8253_H
 
 /* i8253A PIT registers */
 #define PIT_MODE		0x43
@@ -15,4 +15,4 @@ extern void setup_pit_timer(void);
 #define inb_pit		inb_p
 #define outb_pit	outb_p
 
-#endif /* ASM_X86__I8253_H */
+#endif /* _ASM_X86_I8253_H */
diff --git a/include/asm-x86/i8259.h b/include/asm-x86/i8259.h
index 23c1b3b..58d7091 100644
--- a/include/asm-x86/i8259.h
+++ b/include/asm-x86/i8259.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__I8259_H
-#define ASM_X86__I8259_H
+#ifndef _ASM_X86_I8259_H
+#define _ASM_X86_I8259_H
 
 #include <linux/delay.h>
 
@@ -60,4 +60,4 @@ extern struct irq_chip i8259A_chip;
 extern void mask_8259A(void);
 extern void unmask_8259A(void);
 
-#endif /* ASM_X86__I8259_H */
+#endif /* _ASM_X86_I8259_H */
diff --git a/include/asm-x86/ia32.h b/include/asm-x86/ia32.h
index f932f7a..97989c0 100644
--- a/include/asm-x86/ia32.h
+++ b/include/asm-x86/ia32.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__IA32_H
-#define ASM_X86__IA32_H
+#ifndef _ASM_X86_IA32_H
+#define _ASM_X86_IA32_H
 
 
 #ifdef CONFIG_IA32_EMULATION
@@ -167,4 +167,4 @@ extern void ia32_pick_mmap_layout(struct mm_struct *mm);
 
 #endif /* !CONFIG_IA32_SUPPORT */
 
-#endif /* ASM_X86__IA32_H */
+#endif /* _ASM_X86_IA32_H */
diff --git a/include/asm-x86/ia32_unistd.h b/include/asm-x86/ia32_unistd.h
index dbd887d..976f6ec 100644
--- a/include/asm-x86/ia32_unistd.h
+++ b/include/asm-x86/ia32_unistd.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__IA32_UNISTD_H
-#define ASM_X86__IA32_UNISTD_H
+#ifndef _ASM_X86_IA32_UNISTD_H
+#define _ASM_X86_IA32_UNISTD_H
 
 /*
  * This file contains the system call numbers of the ia32 port,
@@ -15,4 +15,4 @@
 #define __NR_ia32_sigreturn	119
 #define __NR_ia32_rt_sigreturn	173
 
-#endif /* ASM_X86__IA32_UNISTD_H */
+#endif /* _ASM_X86_IA32_UNISTD_H */
diff --git a/include/asm-x86/idle.h b/include/asm-x86/idle.h
index baa3f78..8ed9376 100644
--- a/include/asm-x86/idle.h
+++ b/include/asm-x86/idle.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__IDLE_H
-#define ASM_X86__IDLE_H
+#ifndef _ASM_X86_IDLE_H
+#define _ASM_X86_IDLE_H
 
 #define IDLE_START 1
 #define IDLE_END 2
@@ -12,4 +12,4 @@ void exit_idle(void);
 
 void c1e_remove_cpu(int cpu);
 
-#endif /* ASM_X86__IDLE_H */
+#endif /* _ASM_X86_IDLE_H */
diff --git a/include/asm-x86/intel_arch_perfmon.h b/include/asm-x86/intel_arch_perfmon.h
index 07c03c6..fa0fd06 100644
--- a/include/asm-x86/intel_arch_perfmon.h
+++ b/include/asm-x86/intel_arch_perfmon.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__INTEL_ARCH_PERFMON_H
-#define ASM_X86__INTEL_ARCH_PERFMON_H
+#ifndef _ASM_X86_INTEL_ARCH_PERFMON_H
+#define _ASM_X86_INTEL_ARCH_PERFMON_H
 
 #define MSR_ARCH_PERFMON_PERFCTR0		0xc1
 #define MSR_ARCH_PERFMON_PERFCTR1		0xc2
@@ -28,4 +28,4 @@ union cpuid10_eax {
 	unsigned int full;
 };
 
-#endif /* ASM_X86__INTEL_ARCH_PERFMON_H */
+#endif /* _ASM_X86_INTEL_ARCH_PERFMON_H */
diff --git a/include/asm-x86/io.h b/include/asm-x86/io.h
index a233f83..5618a10 100644
--- a/include/asm-x86/io.h
+++ b/include/asm-x86/io.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__IO_H
-#define ASM_X86__IO_H
+#ifndef _ASM_X86_IO_H
+#define _ASM_X86_IO_H
 
 #define ARCH_HAS_IOREMAP_WC
 
@@ -88,4 +88,4 @@ extern void early_iounmap(void *addr, unsigned long size);
 extern void __iomem *fix_ioremap(unsigned idx, unsigned long phys);
 
 
-#endif /* ASM_X86__IO_H */
+#endif /* _ASM_X86_IO_H */
diff --git a/include/asm-x86/io_32.h b/include/asm-x86/io_32.h
index 4f7d878..d8e242e 100644
--- a/include/asm-x86/io_32.h
+++ b/include/asm-x86/io_32.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__IO_32_H
-#define ASM_X86__IO_32_H
+#ifndef _ASM_X86_IO_32_H
+#define _ASM_X86_IO_32_H
 
 #include <linux/string.h>
 #include <linux/compiler.h>
@@ -281,4 +281,4 @@ BUILDIO(b, b, char)
 BUILDIO(w, w, short)
 BUILDIO(l, , int)
 
-#endif /* ASM_X86__IO_32_H */
+#endif /* _ASM_X86_IO_32_H */
diff --git a/include/asm-x86/io_64.h b/include/asm-x86/io_64.h
index ee6e086..fea325a 100644
--- a/include/asm-x86/io_64.h
+++ b/include/asm-x86/io_64.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__IO_64_H
-#define ASM_X86__IO_64_H
+#ifndef _ASM_X86_IO_64_H
+#define _ASM_X86_IO_64_H
 
 
 /*
@@ -241,4 +241,4 @@ void memset_io(volatile void __iomem *a, int b, size_t c);
 
 #endif /* __KERNEL__ */
 
-#endif /* ASM_X86__IO_64_H */
+#endif /* _ASM_X86_IO_64_H */
diff --git a/include/asm-x86/io_apic.h b/include/asm-x86/io_apic.h
index 28976a4..e475e00 100644
--- a/include/asm-x86/io_apic.h
+++ b/include/asm-x86/io_apic.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__IO_APIC_H
-#define ASM_X86__IO_APIC_H
+#ifndef _ASM_X86_IO_APIC_H
+#define _ASM_X86_IO_APIC_H
 
 #include <linux/types.h>
 #include <asm/mpspec.h>
@@ -211,4 +211,4 @@ static inline int probe_nr_irqs(void)
 }
 #endif
 
-#endif /* ASM_X86__IO_APIC_H */
+#endif /* _ASM_X86_IO_APIC_H */
diff --git a/include/asm-x86/ioctls.h b/include/asm-x86/ioctls.h
index 3366035..dbaabf9 100644
--- a/include/asm-x86/ioctls.h
+++ b/include/asm-x86/ioctls.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__IOCTLS_H
-#define ASM_X86__IOCTLS_H
+#ifndef _ASM_X86_IOCTLS_H
+#define _ASM_X86_IOCTLS_H
 
 #include <asm/ioctl.h>
 
@@ -85,4 +85,4 @@
 
 #define TIOCSER_TEMT    0x01	/* Transmitter physically empty */
 
-#endif /* ASM_X86__IOCTLS_H */
+#endif /* _ASM_X86_IOCTLS_H */
diff --git a/include/asm-x86/iommu.h b/include/asm-x86/iommu.h
index 546ad31..fbd0054 100644
--- a/include/asm-x86/iommu.h
+++ b/include/asm-x86/iommu.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__IOMMU_H
-#define ASM_X86__IOMMU_H
+#ifndef _ASM_X86_IOMMU_H
+#define _ASM_X86_IOMMU_H
 
 extern void pci_iommu_shutdown(void);
 extern void no_iommu_init(void);
@@ -43,4 +43,4 @@ static inline void gart_iommu_hole_init(void)
 }
 #endif
 
-#endif /* ASM_X86__IOMMU_H */
+#endif /* _ASM_X86_IOMMU_H */
diff --git a/include/asm-x86/ipcbuf.h b/include/asm-x86/ipcbuf.h
index 910304f..ee678fd 100644
--- a/include/asm-x86/ipcbuf.h
+++ b/include/asm-x86/ipcbuf.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__IPCBUF_H
-#define ASM_X86__IPCBUF_H
+#ifndef _ASM_X86_IPCBUF_H
+#define _ASM_X86_IPCBUF_H
 
 /*
  * The ipc64_perm structure for x86 architecture.
@@ -25,4 +25,4 @@ struct ipc64_perm {
 	unsigned long		__unused2;
 };
 
-#endif /* ASM_X86__IPCBUF_H */
+#endif /* _ASM_X86_IPCBUF_H */
diff --git a/include/asm-x86/ipi.h b/include/asm-x86/ipi.h
index 30a692c..f89dffb 100644
--- a/include/asm-x86/ipi.h
+++ b/include/asm-x86/ipi.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__IPI_H
-#define ASM_X86__IPI_H
+#ifndef _ASM_X86_IPI_H
+#define _ASM_X86_IPI_H
 
 /*
  * Copyright 2004 James Cleverdon, IBM.
@@ -135,4 +135,4 @@ static inline void send_IPI_mask_sequence(cpumask_t mask, int vector)
 	local_irq_restore(flags);
 }
 
-#endif /* ASM_X86__IPI_H */
+#endif /* _ASM_X86_IPI_H */
diff --git a/include/asm-x86/irq.h b/include/asm-x86/irq.h
index 1e5f290..bae0eda 100644
--- a/include/asm-x86/irq.h
+++ b/include/asm-x86/irq.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__IRQ_H
-#define ASM_X86__IRQ_H
+#ifndef _ASM_X86_IRQ_H
+#define _ASM_X86_IRQ_H
 /*
  *	(C) 1992, 1993 Linus Torvalds, (C) 1997 Ingo Molnar
  *
@@ -47,4 +47,4 @@ extern void native_init_IRQ(void);
 /* Interrupt vector management */
 extern DECLARE_BITMAP(used_vectors, NR_VECTORS);
 
-#endif /* ASM_X86__IRQ_H */
+#endif /* _ASM_X86_IRQ_H */
diff --git a/include/asm-x86/irq_regs_32.h b/include/asm-x86/irq_regs_32.h
index 316a3b2..af2f02d 100644
--- a/include/asm-x86/irq_regs_32.h
+++ b/include/asm-x86/irq_regs_32.h
@@ -4,8 +4,8 @@
  *
  * Jeremy Fitzhardinge <jeremy@goop.org>
  */
-#ifndef ASM_X86__IRQ_REGS_32_H
-#define ASM_X86__IRQ_REGS_32_H
+#ifndef _ASM_X86_IRQ_REGS_32_H
+#define _ASM_X86_IRQ_REGS_32_H
 
 #include <asm/percpu.h>
 
@@ -26,4 +26,4 @@ static inline struct pt_regs *set_irq_regs(struct pt_regs *new_regs)
 	return old_regs;
 }
 
-#endif /* ASM_X86__IRQ_REGS_32_H */
+#endif /* _ASM_X86_IRQ_REGS_32_H */
diff --git a/include/asm-x86/irq_vectors.h b/include/asm-x86/irq_vectors.h
index a8d065d..d843ed0 100644
--- a/include/asm-x86/irq_vectors.h
+++ b/include/asm-x86/irq_vectors.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__IRQ_VECTORS_H
-#define ASM_X86__IRQ_VECTORS_H
+#ifndef _ASM_X86_IRQ_VECTORS_H
+#define _ASM_X86_IRQ_VECTORS_H
 
 #include <linux/threads.h>
 
@@ -161,4 +161,4 @@
 #define VIC_CPU_BOOT_ERRATA_CPI		(VIC_CPI_LEVEL0 + 8)
 
 
-#endif /* ASM_X86__IRQ_VECTORS_H */
+#endif /* _ASM_X86_IRQ_VECTORS_H */
diff --git a/include/asm-x86/ist.h b/include/asm-x86/ist.h
index 35a2fe9..7e5dff1 100644
--- a/include/asm-x86/ist.h
+++ b/include/asm-x86/ist.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__IST_H
-#define ASM_X86__IST_H
+#ifndef _ASM_X86_IST_H
+#define _ASM_X86_IST_H
 
 /*
  * Include file for the interface to IST BIOS
@@ -31,4 +31,4 @@ struct ist_info {
 extern struct ist_info ist_info;
 
 #endif	/* __KERNEL__ */
-#endif /* ASM_X86__IST_H */
+#endif /* _ASM_X86_IST_H */
diff --git a/include/asm-x86/k8.h b/include/asm-x86/k8.h
index 2bbaf43..54c8cc5 100644
--- a/include/asm-x86/k8.h
+++ b/include/asm-x86/k8.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__K8_H
-#define ASM_X86__K8_H
+#ifndef _ASM_X86_K8_H
+#define _ASM_X86_K8_H
 
 #include <linux/pci.h>
 
@@ -12,4 +12,4 @@ extern int cache_k8_northbridges(void);
 extern void k8_flush_garts(void);
 extern int k8_scan_nodes(unsigned long start, unsigned long end);
 
-#endif /* ASM_X86__K8_H */
+#endif /* _ASM_X86_K8_H */
diff --git a/include/asm-x86/kdebug.h b/include/asm-x86/kdebug.h
index fbbab66..fa7c0b9 100644
--- a/include/asm-x86/kdebug.h
+++ b/include/asm-x86/kdebug.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__KDEBUG_H
-#define ASM_X86__KDEBUG_H
+#ifndef _ASM_X86_KDEBUG_H
+#define _ASM_X86_KDEBUG_H
 
 #include <linux/notifier.h>
 
@@ -34,4 +34,4 @@ extern void show_regs(struct pt_regs *regs);
 extern unsigned long oops_begin(void);
 extern void oops_end(unsigned long, struct pt_regs *, int signr);
 
-#endif /* ASM_X86__KDEBUG_H */
+#endif /* _ASM_X86_KDEBUG_H */
diff --git a/include/asm-x86/kexec.h b/include/asm-x86/kexec.h
index ea09600..a1f2277 100644
--- a/include/asm-x86/kexec.h
+++ b/include/asm-x86/kexec.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__KEXEC_H
-#define ASM_X86__KEXEC_H
+#ifndef _ASM_X86_KEXEC_H
+#define _ASM_X86_KEXEC_H
 
 #ifdef CONFIG_X86_32
 # define PA_CONTROL_PAGE	0
@@ -172,4 +172,4 @@ relocate_kernel(unsigned long indirection_page,
 
 #endif /* __ASSEMBLY__ */
 
-#endif /* ASM_X86__KEXEC_H */
+#endif /* _ASM_X86_KEXEC_H */
diff --git a/include/asm-x86/kgdb.h b/include/asm-x86/kgdb.h
index d283863..e6c6c80 100644
--- a/include/asm-x86/kgdb.h
+++ b/include/asm-x86/kgdb.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__KGDB_H
-#define ASM_X86__KGDB_H
+#ifndef _ASM_X86_KGDB_H
+#define _ASM_X86_KGDB_H
 
 /*
  * Copyright (C) 2001-2004 Amit S. Kale
@@ -76,4 +76,4 @@ static inline void arch_kgdb_breakpoint(void)
 #define BREAK_INSTR_SIZE	1
 #define CACHE_FLUSH_IS_SAFE	1
 
-#endif /* ASM_X86__KGDB_H */
+#endif /* _ASM_X86_KGDB_H */
diff --git a/include/asm-x86/kmap_types.h b/include/asm-x86/kmap_types.h
index 89f4449..5759c16 100644
--- a/include/asm-x86/kmap_types.h
+++ b/include/asm-x86/kmap_types.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__KMAP_TYPES_H
-#define ASM_X86__KMAP_TYPES_H
+#ifndef _ASM_X86_KMAP_TYPES_H
+#define _ASM_X86_KMAP_TYPES_H
 
 #if defined(CONFIG_X86_32) && defined(CONFIG_DEBUG_HIGHMEM)
 # define D(n) __KM_FENCE_##n ,
@@ -26,4 +26,4 @@ D(13)	KM_TYPE_NR
 
 #undef D
 
-#endif /* ASM_X86__KMAP_TYPES_H */
+#endif /* _ASM_X86_KMAP_TYPES_H */
diff --git a/include/asm-x86/kprobes.h b/include/asm-x86/kprobes.h
index 8a0748d..4fe681d 100644
--- a/include/asm-x86/kprobes.h
+++ b/include/asm-x86/kprobes.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__KPROBES_H
-#define ASM_X86__KPROBES_H
+#ifndef _ASM_X86_KPROBES_H
+#define _ASM_X86_KPROBES_H
 /*
  *  Kernel Probes (KProbes)
  *
@@ -85,4 +85,4 @@ struct kprobe_ctlblk {
 extern int kprobe_fault_handler(struct pt_regs *regs, int trapnr);
 extern int kprobe_exceptions_notify(struct notifier_block *self,
 				    unsigned long val, void *data);
-#endif /* ASM_X86__KPROBES_H */
+#endif /* _ASM_X86_KPROBES_H */
diff --git a/include/asm-x86/kvm.h b/include/asm-x86/kvm.h
index 78e954d..ff92127 100644
--- a/include/asm-x86/kvm.h
+++ b/include/asm-x86/kvm.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__KVM_H
-#define ASM_X86__KVM_H
+#ifndef _ASM_X86_KVM_H
+#define _ASM_X86_KVM_H
 
 /*
  * KVM x86 specific structures and definitions
@@ -230,4 +230,4 @@ struct kvm_pit_state {
 #define KVM_TRC_APIC_ACCESS      (KVM_TRC_HANDLER + 0x14)
 #define KVM_TRC_TDP_FAULT        (KVM_TRC_HANDLER + 0x15)
 
-#endif /* ASM_X86__KVM_H */
+#endif /* _ASM_X86_KVM_H */
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index 6979454..5469d3f 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -8,8 +8,8 @@
  *
  */
 
-#ifndef ASM_X86__KVM_HOST_H
-#define ASM_X86__KVM_HOST_H
+#ifndef _ASM_X86_KVM_HOST_H
+#define _ASM_X86_KVM_HOST_H
 
 #include <linux/types.h>
 #include <linux/mm.h>
@@ -735,4 +735,4 @@ asmlinkage void kvm_handle_fault_on_reboot(void);
 int kvm_unmap_hva(struct kvm *kvm, unsigned long hva);
 int kvm_age_hva(struct kvm *kvm, unsigned long hva);
 
-#endif /* ASM_X86__KVM_HOST_H */
+#endif /* _ASM_X86_KVM_HOST_H */
diff --git a/include/asm-x86/kvm_para.h b/include/asm-x86/kvm_para.h
index 30054fd..b8a3305 100644
--- a/include/asm-x86/kvm_para.h
+++ b/include/asm-x86/kvm_para.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__KVM_PARA_H
-#define ASM_X86__KVM_PARA_H
+#ifndef _ASM_X86_KVM_PARA_H
+#define _ASM_X86_KVM_PARA_H
 
 /* This CPUID returns the signature 'KVMKVMKVM' in ebx, ecx, and edx.  It
  * should be used to determine that a VM is running under KVM.
@@ -144,4 +144,4 @@ static inline unsigned int kvm_arch_para_features(void)
 
 #endif
 
-#endif /* ASM_X86__KVM_PARA_H */
+#endif /* _ASM_X86_KVM_PARA_H */
diff --git a/include/asm-x86/kvm_x86_emulate.h b/include/asm-x86/kvm_x86_emulate.h
index e2d9b03..25179a2 100644
--- a/include/asm-x86/kvm_x86_emulate.h
+++ b/include/asm-x86/kvm_x86_emulate.h
@@ -8,8 +8,8 @@
  * From: xen-unstable 10676:af9809f51f81a3c43f276f00c81a52ef558afda4
  */
 
-#ifndef ASM_X86__KVM_X86_EMULATE_H
-#define ASM_X86__KVM_X86_EMULATE_H
+#ifndef _ASM_X86_KVM_X86_EMULATE_H
+#define _ASM_X86_KVM_X86_EMULATE_H
 
 struct x86_emulate_ctxt;
 
@@ -181,4 +181,4 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt,
 int x86_emulate_insn(struct x86_emulate_ctxt *ctxt,
 		     struct x86_emulate_ops *ops);
 
-#endif /* ASM_X86__KVM_X86_EMULATE_H */
+#endif /* _ASM_X86_KVM_X86_EMULATE_H */
diff --git a/include/asm-x86/ldt.h b/include/asm-x86/ldt.h
index a522850..46727eb 100644
--- a/include/asm-x86/ldt.h
+++ b/include/asm-x86/ldt.h
@@ -3,8 +3,8 @@
  *
  * Definitions of structures used with the modify_ldt system call.
  */
-#ifndef ASM_X86__LDT_H
-#define ASM_X86__LDT_H
+#ifndef _ASM_X86_LDT_H
+#define _ASM_X86_LDT_H
 
 /* Maximum number of LDT entries supported. */
 #define LDT_ENTRIES	8192
@@ -37,4 +37,4 @@ struct user_desc {
 #define MODIFY_LDT_CONTENTS_CODE	2
 
 #endif /* !__ASSEMBLY__ */
-#endif /* ASM_X86__LDT_H */
+#endif /* _ASM_X86_LDT_H */
diff --git a/include/asm-x86/lguest.h b/include/asm-x86/lguest.h
index 7505e94..d28a507 100644
--- a/include/asm-x86/lguest.h
+++ b/include/asm-x86/lguest.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__LGUEST_H
-#define ASM_X86__LGUEST_H
+#ifndef _ASM_X86_LGUEST_H
+#define _ASM_X86_LGUEST_H
 
 #define GDT_ENTRY_LGUEST_CS	10
 #define GDT_ENTRY_LGUEST_DS	11
@@ -91,4 +91,4 @@ static inline void lguest_set_ts(void)
 
 #endif /* __ASSEMBLY__ */
 
-#endif /* ASM_X86__LGUEST_H */
+#endif /* _ASM_X86_LGUEST_H */
diff --git a/include/asm-x86/lguest_hcall.h b/include/asm-x86/lguest_hcall.h
index 8f034ba..4389442 100644
--- a/include/asm-x86/lguest_hcall.h
+++ b/include/asm-x86/lguest_hcall.h
@@ -1,6 +1,6 @@
 /* Architecture specific portion of the lguest hypercalls */
-#ifndef ASM_X86__LGUEST_HCALL_H
-#define ASM_X86__LGUEST_HCALL_H
+#ifndef _ASM_X86_LGUEST_HCALL_H
+#define _ASM_X86_LGUEST_HCALL_H
 
 #define LHCALL_FLUSH_ASYNC	0
 #define LHCALL_LGUEST_INIT	1
@@ -68,4 +68,4 @@ struct hcall_args {
 };
 
 #endif /* !__ASSEMBLY__ */
-#endif /* ASM_X86__LGUEST_HCALL_H */
+#endif /* _ASM_X86_LGUEST_HCALL_H */
diff --git a/include/asm-x86/linkage.h b/include/asm-x86/linkage.h
index 42d8b62..f61ee8f 100644
--- a/include/asm-x86/linkage.h
+++ b/include/asm-x86/linkage.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__LINKAGE_H
-#define ASM_X86__LINKAGE_H
+#ifndef _ASM_X86_LINKAGE_H
+#define _ASM_X86_LINKAGE_H
 
 #undef notrace
 #define notrace __attribute__((no_instrument_function))
@@ -57,5 +57,5 @@
 #define __ALIGN_STR ".align 16,0x90"
 #endif
 
-#endif /* ASM_X86__LINKAGE_H */
+#endif /* _ASM_X86_LINKAGE_H */
 
diff --git a/include/asm-x86/local.h b/include/asm-x86/local.h
index ae91994..47b9b6f 100644
--- a/include/asm-x86/local.h
+++ b/include/asm-x86/local.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__LOCAL_H
-#define ASM_X86__LOCAL_H
+#ifndef _ASM_X86_LOCAL_H
+#define _ASM_X86_LOCAL_H
 
 #include <linux/percpu.h>
 
@@ -232,4 +232,4 @@ static inline long local_sub_return(long i, local_t *l)
 #define __cpu_local_add(i, l)	cpu_local_add((i), (l))
 #define __cpu_local_sub(i, l)	cpu_local_sub((i), (l))
 
-#endif /* ASM_X86__LOCAL_H */
+#endif /* _ASM_X86_LOCAL_H */
diff --git a/include/asm-x86/mach-default/apm.h b/include/asm-x86/mach-default/apm.h
index 2aa61b5..fc392ec 100644
--- a/include/asm-x86/mach-default/apm.h
+++ b/include/asm-x86/mach-default/apm.h
@@ -3,8 +3,8 @@
  *  Split out from apm.c by Osamu Tomita <tomita@cinet.co.jp>
  */
 
-#ifndef ASM_X86__MACH_DEFAULT__APM_H
-#define ASM_X86__MACH_DEFAULT__APM_H
+#ifndef _ASM_X86_MACH_DEFAULT__APM_H
+#define _ASM_X86_MACH_DEFAULT__APM_H
 
 #ifdef APM_ZERO_SEGS
 #	define APM_DO_ZERO_SEGS \
@@ -70,4 +70,4 @@ static inline u8 apm_bios_call_simple_asm(u32 func, u32 ebx_in,
 	return error;
 }
 
-#endif /* ASM_X86__MACH_DEFAULT__APM_H */
+#endif /* _ASM_X86_MACH_DEFAULT__APM_H */
diff --git a/include/asm-x86/mach-default/mach_apic.h b/include/asm-x86/mach-default/mach_apic.h
index 3c66f2c..2ad00eb 100644
--- a/include/asm-x86/mach-default/mach_apic.h
+++ b/include/asm-x86/mach-default/mach_apic.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__MACH_DEFAULT__MACH_APIC_H
-#define ASM_X86__MACH_DEFAULT__MACH_APIC_H
+#ifndef _ASM_X86_MACH_DEFAULT__MACH_APIC_H
+#define _ASM_X86_MACH_DEFAULT__MACH_APIC_H
 
 #ifdef CONFIG_X86_LOCAL_APIC
 
@@ -153,4 +153,4 @@ static inline void enable_apic_mode(void)
 {
 }
 #endif /* CONFIG_X86_LOCAL_APIC */
-#endif /* ASM_X86__MACH_DEFAULT__MACH_APIC_H */
+#endif /* _ASM_X86_MACH_DEFAULT__MACH_APIC_H */
diff --git a/include/asm-x86/mach-default/mach_apicdef.h b/include/asm-x86/mach-default/mach_apicdef.h
index 0c2d41c..b9feb25 100644
--- a/include/asm-x86/mach-default/mach_apicdef.h
+++ b/include/asm-x86/mach-default/mach_apicdef.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__MACH_DEFAULT__MACH_APICDEF_H
-#define ASM_X86__MACH_DEFAULT__MACH_APICDEF_H
+#ifndef _ASM_X86_MACH_DEFAULT__MACH_APICDEF_H
+#define _ASM_X86_MACH_DEFAULT__MACH_APICDEF_H
 
 #include <asm/apic.h>
 
@@ -21,4 +21,4 @@ static inline unsigned get_apic_id(unsigned long x)
 #define		GET_APIC_ID(x)	get_apic_id(x)
 #endif
 
-#endif /* ASM_X86__MACH_DEFAULT__MACH_APICDEF_H */
+#endif /* _ASM_X86_MACH_DEFAULT__MACH_APICDEF_H */
diff --git a/include/asm-x86/mach-default/mach_ipi.h b/include/asm-x86/mach-default/mach_ipi.h
index 674bc7e..377dfd8 100644
--- a/include/asm-x86/mach-default/mach_ipi.h
+++ b/include/asm-x86/mach-default/mach_ipi.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__MACH_DEFAULT__MACH_IPI_H
-#define ASM_X86__MACH_DEFAULT__MACH_IPI_H
+#ifndef _ASM_X86_MACH_DEFAULT__MACH_IPI_H
+#define _ASM_X86_MACH_DEFAULT__MACH_IPI_H
 
 /* Avoid include hell */
 #define NMI_VECTOR 0x02
@@ -61,4 +61,4 @@ static inline void send_IPI_all(int vector)
 }
 #endif
 
-#endif /* ASM_X86__MACH_DEFAULT__MACH_IPI_H */
+#endif /* _ASM_X86_MACH_DEFAULT__MACH_IPI_H */
diff --git a/include/asm-x86/mach-default/mach_mpparse.h b/include/asm-x86/mach-default/mach_mpparse.h
index 9c381f2..028e08b 100644
--- a/include/asm-x86/mach-default/mach_mpparse.h
+++ b/include/asm-x86/mach-default/mach_mpparse.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__MACH_DEFAULT__MACH_MPPARSE_H
-#define ASM_X86__MACH_DEFAULT__MACH_MPPARSE_H
+#ifndef _ASM_X86_MACH_DEFAULT__MACH_MPPARSE_H
+#define _ASM_X86_MACH_DEFAULT__MACH_MPPARSE_H
 
 static inline int mps_oem_check(struct mp_config_table *mpc, char *oem, 
 		char *productid)
@@ -14,4 +14,4 @@ static inline int acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 }
 
 
-#endif /* ASM_X86__MACH_DEFAULT__MACH_MPPARSE_H */
+#endif /* _ASM_X86_MACH_DEFAULT__MACH_MPPARSE_H */
diff --git a/include/asm-x86/mach-default/mach_mpspec.h b/include/asm-x86/mach-default/mach_mpspec.h
index d77646f..2a96633 100644
--- a/include/asm-x86/mach-default/mach_mpspec.h
+++ b/include/asm-x86/mach-default/mach_mpspec.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__MACH_DEFAULT__MACH_MPSPEC_H
-#define ASM_X86__MACH_DEFAULT__MACH_MPSPEC_H
+#ifndef _ASM_X86_MACH_DEFAULT__MACH_MPSPEC_H
+#define _ASM_X86_MACH_DEFAULT__MACH_MPSPEC_H
 
 #define MAX_IRQ_SOURCES 256
 
@@ -9,4 +9,4 @@
 #define MAX_MP_BUSSES 32
 #endif
 
-#endif /* ASM_X86__MACH_DEFAULT__MACH_MPSPEC_H */
+#endif /* _ASM_X86_MACH_DEFAULT__MACH_MPSPEC_H */
diff --git a/include/asm-x86/mach-default/mach_timer.h b/include/asm-x86/mach-default/mach_timer.h
index 990b158..a075b46 100644
--- a/include/asm-x86/mach-default/mach_timer.h
+++ b/include/asm-x86/mach-default/mach_timer.h
@@ -10,8 +10,8 @@
  * directly because of the awkward 8-bit access mechanism of the 82C54
  * device.
  */
-#ifndef ASM_X86__MACH_DEFAULT__MACH_TIMER_H
-#define ASM_X86__MACH_DEFAULT__MACH_TIMER_H
+#ifndef _ASM_X86_MACH_DEFAULT__MACH_TIMER_H
+#define _ASM_X86_MACH_DEFAULT__MACH_TIMER_H
 
 #define CALIBRATE_TIME_MSEC 30 /* 30 msecs */
 #define CALIBRATE_LATCH	\
@@ -45,4 +45,4 @@ static inline void mach_countup(unsigned long *count_p)
 	*count_p = count;
 }
 
-#endif /* ASM_X86__MACH_DEFAULT__MACH_TIMER_H */
+#endif /* _ASM_X86_MACH_DEFAULT__MACH_TIMER_H */
diff --git a/include/asm-x86/mach-default/mach_traps.h b/include/asm-x86/mach-default/mach_traps.h
index ff8778f..d4fb0bc 100644
--- a/include/asm-x86/mach-default/mach_traps.h
+++ b/include/asm-x86/mach-default/mach_traps.h
@@ -2,8 +2,8 @@
  *  Machine specific NMI handling for generic.
  *  Split out from traps.c by Osamu Tomita <tomita@cinet.co.jp>
  */
-#ifndef ASM_X86__MACH_DEFAULT__MACH_TRAPS_H
-#define ASM_X86__MACH_DEFAULT__MACH_TRAPS_H
+#ifndef _ASM_X86_MACH_DEFAULT__MACH_TRAPS_H
+#define _ASM_X86_MACH_DEFAULT__MACH_TRAPS_H
 
 #include <asm/mc146818rtc.h>
 
@@ -30,4 +30,4 @@ static inline void reassert_nmi(void)
 		unlock_cmos();
 }
 
-#endif /* ASM_X86__MACH_DEFAULT__MACH_TRAPS_H */
+#endif /* _ASM_X86_MACH_DEFAULT__MACH_TRAPS_H */
diff --git a/include/asm-x86/mach-default/mach_wakecpu.h b/include/asm-x86/mach-default/mach_wakecpu.h
index 361b810..d7136fc 100644
--- a/include/asm-x86/mach-default/mach_wakecpu.h
+++ b/include/asm-x86/mach-default/mach_wakecpu.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__MACH_DEFAULT__MACH_WAKECPU_H
-#define ASM_X86__MACH_DEFAULT__MACH_WAKECPU_H
+#ifndef _ASM_X86_MACH_DEFAULT__MACH_WAKECPU_H
+#define _ASM_X86_MACH_DEFAULT__MACH_WAKECPU_H
 
 /* 
  * This file copes with machines that wakeup secondary CPUs by the
@@ -39,4 +39,4 @@ static inline void restore_NMI_vector(unsigned short *high, unsigned short *low)
  #define inquire_remote_apic(apicid) {}
 #endif
 
-#endif /* ASM_X86__MACH_DEFAULT__MACH_WAKECPU_H */
+#endif /* _ASM_X86_MACH_DEFAULT__MACH_WAKECPU_H */
diff --git a/include/asm-x86/mach-generic/gpio.h b/include/asm-x86/mach-generic/gpio.h
index 6ce0f77..5fef612 100644
--- a/include/asm-x86/mach-generic/gpio.h
+++ b/include/asm-x86/mach-generic/gpio.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__MACH_GENERIC__GPIO_H
-#define ASM_X86__MACH_GENERIC__GPIO_H
+#ifndef _ASM_X86_MACH_GENERIC__GPIO_H
+#define _ASM_X86_MACH_GENERIC__GPIO_H
 
 int gpio_request(unsigned gpio, const char *label);
 void gpio_free(unsigned gpio);
@@ -12,4 +12,4 @@ int irq_to_gpio(unsigned irq);
 
 #include <asm-generic/gpio.h>           /* cansleep wrappers */
 
-#endif /* ASM_X86__MACH_GENERIC__GPIO_H */
+#endif /* _ASM_X86_MACH_GENERIC__GPIO_H */
diff --git a/include/asm-x86/mach-generic/mach_apic.h b/include/asm-x86/mach-generic/mach_apic.h
index 5085b52..81668b3 100644
--- a/include/asm-x86/mach-generic/mach_apic.h
+++ b/include/asm-x86/mach-generic/mach_apic.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__MACH_GENERIC__MACH_APIC_H
-#define ASM_X86__MACH_GENERIC__MACH_APIC_H
+#ifndef _ASM_X86_MACH_GENERIC__MACH_APIC_H
+#define _ASM_X86_MACH_GENERIC__MACH_APIC_H
 
 #include <asm/genapic.h>
 
@@ -30,4 +30,4 @@
 
 extern void generic_bigsmp_probe(void);
 
-#endif /* ASM_X86__MACH_GENERIC__MACH_APIC_H */
+#endif /* _ASM_X86_MACH_GENERIC__MACH_APIC_H */
diff --git a/include/asm-x86/mach-generic/mach_apicdef.h b/include/asm-x86/mach-generic/mach_apicdef.h
index 1657f38..b2eaf1e 100644
--- a/include/asm-x86/mach-generic/mach_apicdef.h
+++ b/include/asm-x86/mach-generic/mach_apicdef.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__MACH_GENERIC__MACH_APICDEF_H
-#define ASM_X86__MACH_GENERIC__MACH_APICDEF_H
+#ifndef _ASM_X86_MACH_GENERIC__MACH_APICDEF_H
+#define _ASM_X86_MACH_GENERIC__MACH_APICDEF_H
 
 #ifndef APIC_DEFINITION
 #include <asm/genapic.h>
@@ -8,4 +8,4 @@
 #define APIC_ID_MASK (genapic->apic_id_mask)
 #endif
 
-#endif /* ASM_X86__MACH_GENERIC__MACH_APICDEF_H */
+#endif /* _ASM_X86_MACH_GENERIC__MACH_APICDEF_H */
diff --git a/include/asm-x86/mach-generic/mach_ipi.h b/include/asm-x86/mach-generic/mach_ipi.h
index f67433d..fe430df 100644
--- a/include/asm-x86/mach-generic/mach_ipi.h
+++ b/include/asm-x86/mach-generic/mach_ipi.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__MACH_GENERIC__MACH_IPI_H
-#define ASM_X86__MACH_GENERIC__MACH_IPI_H
+#ifndef _ASM_X86_MACH_GENERIC__MACH_IPI_H
+#define _ASM_X86_MACH_GENERIC__MACH_IPI_H
 
 #include <asm/genapic.h>
 
@@ -7,4 +7,4 @@
 #define send_IPI_allbutself (genapic->send_IPI_allbutself)
 #define send_IPI_all (genapic->send_IPI_all)
 
-#endif /* ASM_X86__MACH_GENERIC__MACH_IPI_H */
+#endif /* _ASM_X86_MACH_GENERIC__MACH_IPI_H */
diff --git a/include/asm-x86/mach-generic/mach_mpparse.h b/include/asm-x86/mach-generic/mach_mpparse.h
index 3115564..aed9f85 100644
--- a/include/asm-x86/mach-generic/mach_mpparse.h
+++ b/include/asm-x86/mach-generic/mach_mpparse.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__MACH_GENERIC__MACH_MPPARSE_H
-#define ASM_X86__MACH_GENERIC__MACH_MPPARSE_H
+#ifndef _ASM_X86_MACH_GENERIC__MACH_MPPARSE_H
+#define _ASM_X86_MACH_GENERIC__MACH_MPPARSE_H
 
 
 extern int mps_oem_check(struct mp_config_table *mpc, char *oem,
@@ -7,4 +7,4 @@ extern int mps_oem_check(struct mp_config_table *mpc, char *oem,
 
 extern int acpi_madt_oem_check(char *oem_id, char *oem_table_id);
 
-#endif /* ASM_X86__MACH_GENERIC__MACH_MPPARSE_H */
+#endif /* _ASM_X86_MACH_GENERIC__MACH_MPPARSE_H */
diff --git a/include/asm-x86/mach-generic/mach_mpspec.h b/include/asm-x86/mach-generic/mach_mpspec.h
index 6061b15..ec615de 100644
--- a/include/asm-x86/mach-generic/mach_mpspec.h
+++ b/include/asm-x86/mach-generic/mach_mpspec.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__MACH_GENERIC__MACH_MPSPEC_H
-#define ASM_X86__MACH_GENERIC__MACH_MPSPEC_H
+#ifndef _ASM_X86_MACH_GENERIC__MACH_MPSPEC_H
+#define _ASM_X86_MACH_GENERIC__MACH_MPSPEC_H
 
 #define MAX_IRQ_SOURCES 256
 
@@ -9,4 +9,4 @@
 
 extern void numaq_mps_oem_check(struct mp_config_table *mpc, char *oem,
 				char *productid);
-#endif /* ASM_X86__MACH_GENERIC__MACH_MPSPEC_H */
+#endif /* _ASM_X86_MACH_GENERIC__MACH_MPSPEC_H */
diff --git a/include/asm-x86/mach-rdc321x/gpio.h b/include/asm-x86/mach-rdc321x/gpio.h
index 94b6cdf..b21d917 100644
--- a/include/asm-x86/mach-rdc321x/gpio.h
+++ b/include/asm-x86/mach-rdc321x/gpio.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__MACH_RDC321X__GPIO_H
-#define ASM_X86__MACH_RDC321X__GPIO_H
+#ifndef _ASM_X86_MACH_RDC321X__GPIO_H
+#define _ASM_X86_MACH_RDC321X__GPIO_H
 
 #include <linux/kernel.h>
 
@@ -57,4 +57,4 @@ static inline int irq_to_gpio(unsigned irq)
 /* For cansleep */
 #include <asm-generic/gpio.h>
 
-#endif /* ASM_X86__MACH_RDC321X__GPIO_H */
+#endif /* _ASM_X86_MACH_RDC321X__GPIO_H */
diff --git a/include/asm-x86/math_emu.h b/include/asm-x86/math_emu.h
index 5768d8e..5a65b10 100644
--- a/include/asm-x86/math_emu.h
+++ b/include/asm-x86/math_emu.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__MATH_EMU_H
-#define ASM_X86__MATH_EMU_H
+#ifndef _ASM_X86_MATH_EMU_H
+#define _ASM_X86_MATH_EMU_H
 
 /* This structure matches the layout of the data saved to the stack
    following a device-not-present interrupt, part of it saved
@@ -28,4 +28,4 @@ struct info {
 	long ___vm86_fs;
 	long ___vm86_gs;
 };
-#endif /* ASM_X86__MATH_EMU_H */
+#endif /* _ASM_X86_MATH_EMU_H */
diff --git a/include/asm-x86/mc146818rtc.h b/include/asm-x86/mc146818rtc.h
index a995f33..01fdf56 100644
--- a/include/asm-x86/mc146818rtc.h
+++ b/include/asm-x86/mc146818rtc.h
@@ -1,8 +1,8 @@
 /*
  * Machine dependent access functions for RTC registers.
  */
-#ifndef ASM_X86__MC146818RTC_H
-#define ASM_X86__MC146818RTC_H
+#ifndef _ASM_X86_MC146818RTC_H
+#define _ASM_X86_MC146818RTC_H
 
 #include <asm/io.h>
 #include <asm/system.h>
@@ -101,4 +101,4 @@ extern unsigned long mach_get_cmos_time(void);
 
 #define RTC_IRQ 8
 
-#endif /* ASM_X86__MC146818RTC_H */
+#endif /* _ASM_X86_MC146818RTC_H */
diff --git a/include/asm-x86/mca.h b/include/asm-x86/mca.h
index 60d1ed2..eedbb6c 100644
--- a/include/asm-x86/mca.h
+++ b/include/asm-x86/mca.h
@@ -1,8 +1,8 @@
 /* -*- mode: c; c-basic-offset: 8 -*- */
 
 /* Platform specific MCA defines */
-#ifndef ASM_X86__MCA_H
-#define ASM_X86__MCA_H
+#ifndef _ASM_X86_MCA_H
+#define _ASM_X86_MCA_H
 
 /* Maximal number of MCA slots - actually, some machines have less, but
  * they all have sufficient number of POS registers to cover 8.
@@ -40,4 +40,4 @@
  */
 #define MCA_NUMADAPTERS (MCA_MAX_SLOT_NR+3)
 
-#endif /* ASM_X86__MCA_H */
+#endif /* _ASM_X86_MCA_H */
diff --git a/include/asm-x86/mca_dma.h b/include/asm-x86/mca_dma.h
index 49f22be..45271ae 100644
--- a/include/asm-x86/mca_dma.h
+++ b/include/asm-x86/mca_dma.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__MCA_DMA_H
-#define ASM_X86__MCA_DMA_H
+#ifndef _ASM_X86_MCA_DMA_H
+#define _ASM_X86_MCA_DMA_H
 
 #include <asm/io.h>
 #include <linux/ioport.h>
@@ -198,4 +198,4 @@ static inline void mca_set_dma_mode(unsigned int dmanr, unsigned int mode)
 	outb(mode, MCA_DMA_REG_EXE);
 }
 
-#endif /* ASM_X86__MCA_DMA_H */
+#endif /* _ASM_X86_MCA_DMA_H */
diff --git a/include/asm-x86/mce.h b/include/asm-x86/mce.h
index 036133e..1d6e17c 100644
--- a/include/asm-x86/mce.h
+++ b/include/asm-x86/mce.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__MCE_H
-#define ASM_X86__MCE_H
+#ifndef _ASM_X86_MCE_H
+#define _ASM_X86_MCE_H
 
 #ifdef __x86_64__
 
@@ -127,4 +127,4 @@ extern void restart_mce(void);
 
 #endif /* __KERNEL__ */
 
-#endif /* ASM_X86__MCE_H */
+#endif /* _ASM_X86_MCE_H */
diff --git a/include/asm-x86/microcode.h b/include/asm-x86/microcode.h
index 62c793b..c882664 100644
--- a/include/asm-x86/microcode.h
+++ b/include/asm-x86/microcode.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__MICROCODE_H
-#define ASM_X86__MICROCODE_H
+#ifndef _ASM_X86_MICROCODE_H
+#define _ASM_X86_MICROCODE_H
 
 struct cpu_signature {
 	unsigned int sig;
@@ -44,4 +44,4 @@ static inline struct microcode_ops * __init init_amd_microcode(void)
 }
 #endif
 
-#endif /* ASM_X86__MICROCODE_H */
+#endif /* _ASM_X86_MICROCODE_H */
diff --git a/include/asm-x86/mman.h b/include/asm-x86/mman.h
index 4ef28e6..90bc410 100644
--- a/include/asm-x86/mman.h
+++ b/include/asm-x86/mman.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__MMAN_H
-#define ASM_X86__MMAN_H
+#ifndef _ASM_X86_MMAN_H
+#define _ASM_X86_MMAN_H
 
 #include <asm-generic/mman.h>
 
@@ -17,4 +17,4 @@
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
 
-#endif /* ASM_X86__MMAN_H */
+#endif /* _ASM_X86_MMAN_H */
diff --git a/include/asm-x86/mmconfig.h b/include/asm-x86/mmconfig.h
index fb79b1c..9b119da 100644
--- a/include/asm-x86/mmconfig.h
+++ b/include/asm-x86/mmconfig.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__MMCONFIG_H
-#define ASM_X86__MMCONFIG_H
+#ifndef _ASM_X86_MMCONFIG_H
+#define _ASM_X86_MMCONFIG_H
 
 #ifdef CONFIG_PCI_MMCONFIG
 extern void __cpuinit fam10h_check_enable_mmcfg(void);
@@ -9,4 +9,4 @@ static inline void fam10h_check_enable_mmcfg(void) { }
 static inline void check_enable_amd_mmconf_dmi(void) { }
 #endif
 
-#endif /* ASM_X86__MMCONFIG_H */
+#endif /* _ASM_X86_MMCONFIG_H */
diff --git a/include/asm-x86/mmu.h b/include/asm-x86/mmu.h
index 9d5aff1..80a1dee 100644
--- a/include/asm-x86/mmu.h
+++ b/include/asm-x86/mmu.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__MMU_H
-#define ASM_X86__MMU_H
+#ifndef _ASM_X86_MMU_H
+#define _ASM_X86_MMU_H
 
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
@@ -23,4 +23,4 @@ static inline void leave_mm(int cpu)
 }
 #endif
 
-#endif /* ASM_X86__MMU_H */
+#endif /* _ASM_X86_MMU_H */
diff --git a/include/asm-x86/mmu_context.h b/include/asm-x86/mmu_context.h
index 8ec940b..8aeeb3f 100644
--- a/include/asm-x86/mmu_context.h
+++ b/include/asm-x86/mmu_context.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__MMU_CONTEXT_H
-#define ASM_X86__MMU_CONTEXT_H
+#ifndef _ASM_X86_MMU_CONTEXT_H
+#define _ASM_X86_MMU_CONTEXT_H
 
 #include <asm/desc.h>
 #include <asm/atomic.h>
@@ -34,4 +34,4 @@ do {						\
 } while (0);
 
 
-#endif /* ASM_X86__MMU_CONTEXT_H */
+#endif /* _ASM_X86_MMU_CONTEXT_H */
diff --git a/include/asm-x86/mmu_context_32.h b/include/asm-x86/mmu_context_32.h
index cce6f6e..8e10015 100644
--- a/include/asm-x86/mmu_context_32.h
+++ b/include/asm-x86/mmu_context_32.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__MMU_CONTEXT_32_H
-#define ASM_X86__MMU_CONTEXT_32_H
+#ifndef _ASM_X86_MMU_CONTEXT_32_H
+#define _ASM_X86_MMU_CONTEXT_32_H
 
 static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 {
@@ -53,4 +53,4 @@ static inline void switch_mm(struct mm_struct *prev,
 #define deactivate_mm(tsk, mm)			\
 	asm("movl %0,%%gs": :"r" (0));
 
-#endif /* ASM_X86__MMU_CONTEXT_32_H */
+#endif /* _ASM_X86_MMU_CONTEXT_32_H */
diff --git a/include/asm-x86/mmu_context_64.h b/include/asm-x86/mmu_context_64.h
index 2675867..677d36e 100644
--- a/include/asm-x86/mmu_context_64.h
+++ b/include/asm-x86/mmu_context_64.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__MMU_CONTEXT_64_H
-#define ASM_X86__MMU_CONTEXT_64_H
+#ifndef _ASM_X86_MMU_CONTEXT_64_H
+#define _ASM_X86_MMU_CONTEXT_64_H
 
 #include <asm/pda.h>
 
@@ -51,4 +51,4 @@ do {						\
 	asm volatile("movl %0,%%fs"::"r"(0));	\
 } while (0)
 
-#endif /* ASM_X86__MMU_CONTEXT_64_H */
+#endif /* _ASM_X86_MMU_CONTEXT_64_H */
diff --git a/include/asm-x86/mmx.h b/include/asm-x86/mmx.h
index 2e7299b..5cbf313 100644
--- a/include/asm-x86/mmx.h
+++ b/include/asm-x86/mmx.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__MMX_H
-#define ASM_X86__MMX_H
+#ifndef _ASM_X86_MMX_H
+#define _ASM_X86_MMX_H
 
 /*
  *	MMX 3Dnow! helper operations
@@ -11,4 +11,4 @@ extern void *_mmx_memcpy(void *to, const void *from, size_t size);
 extern void mmx_clear_page(void *page);
 extern void mmx_copy_page(void *to, void *from);
 
-#endif /* ASM_X86__MMX_H */
+#endif /* _ASM_X86_MMX_H */
diff --git a/include/asm-x86/mmzone_32.h b/include/asm-x86/mmzone_32.h
index 121b65d..485bdf0 100644
--- a/include/asm-x86/mmzone_32.h
+++ b/include/asm-x86/mmzone_32.h
@@ -3,8 +3,8 @@
  *
  */
 
-#ifndef ASM_X86__MMZONE_32_H
-#define ASM_X86__MMZONE_32_H
+#ifndef _ASM_X86_MMZONE_32_H
+#define _ASM_X86_MMZONE_32_H
 
 #include <asm/smp.h>
 
@@ -131,4 +131,4 @@ static inline int pfn_valid(int pfn)
 })
 #endif /* CONFIG_NEED_MULTIPLE_NODES */
 
-#endif /* ASM_X86__MMZONE_32_H */
+#endif /* _ASM_X86_MMZONE_32_H */
diff --git a/include/asm-x86/mmzone_64.h b/include/asm-x86/mmzone_64.h
index 6480f33..a5b3817 100644
--- a/include/asm-x86/mmzone_64.h
+++ b/include/asm-x86/mmzone_64.h
@@ -1,8 +1,8 @@
 /* K8 NUMA support */
 /* Copyright 2002,2003 by Andi Kleen, SuSE Labs */
 /* 2.5 Version loosely based on the NUMAQ Code by Pat Gaughen. */
-#ifndef ASM_X86__MMZONE_64_H
-#define ASM_X86__MMZONE_64_H
+#ifndef _ASM_X86_MMZONE_64_H
+#define _ASM_X86_MMZONE_64_H
 
 
 #ifdef CONFIG_NUMA
@@ -48,4 +48,4 @@ extern int early_pfn_to_nid(unsigned long pfn);
 #endif
 
 #endif
-#endif /* ASM_X86__MMZONE_64_H */
+#endif /* _ASM_X86_MMZONE_64_H */
diff --git a/include/asm-x86/module.h b/include/asm-x86/module.h
index 864f200..47d6274 100644
--- a/include/asm-x86/module.h
+++ b/include/asm-x86/module.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__MODULE_H
-#define ASM_X86__MODULE_H
+#ifndef _ASM_X86_MODULE_H
+#define _ASM_X86_MODULE_H
 
 /* x86_32/64 are simple */
 struct mod_arch_specific {};
@@ -77,4 +77,4 @@ struct mod_arch_specific {};
 # define MODULE_ARCH_VERMAGIC MODULE_PROC_FAMILY MODULE_STACKSIZE
 #endif
 
-#endif /* ASM_X86__MODULE_H */
+#endif /* _ASM_X86_MODULE_H */
diff --git a/include/asm-x86/mpspec.h b/include/asm-x86/mpspec.h
index be2241a..91885c2 100644
--- a/include/asm-x86/mpspec.h
+++ b/include/asm-x86/mpspec.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__MPSPEC_H
-#define ASM_X86__MPSPEC_H
+#ifndef _ASM_X86_MPSPEC_H
+#define _ASM_X86_MPSPEC_H
 
 #include <linux/init.h>
 
@@ -142,4 +142,4 @@ static inline void physid_set_mask_of_physid(int physid, physid_mask_t *map)
 
 extern physid_mask_t phys_cpu_present_map;
 
-#endif /* ASM_X86__MPSPEC_H */
+#endif /* _ASM_X86_MPSPEC_H */
diff --git a/include/asm-x86/mpspec_def.h b/include/asm-x86/mpspec_def.h
index 79166b0..e3ace7d 100644
--- a/include/asm-x86/mpspec_def.h
+++ b/include/asm-x86/mpspec_def.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__MPSPEC_DEF_H
-#define ASM_X86__MPSPEC_DEF_H
+#ifndef _ASM_X86_MPSPEC_DEF_H
+#define _ASM_X86_MPSPEC_DEF_H
 
 /*
  * Structure definitions for SMP machines following the
@@ -177,4 +177,4 @@ enum mp_bustype {
 	MP_BUS_PCI,
 	MP_BUS_MCA,
 };
-#endif /* ASM_X86__MPSPEC_DEF_H */
+#endif /* _ASM_X86_MPSPEC_DEF_H */
diff --git a/include/asm-x86/msgbuf.h b/include/asm-x86/msgbuf.h
index 1b538c9..7e4e948 100644
--- a/include/asm-x86/msgbuf.h
+++ b/include/asm-x86/msgbuf.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__MSGBUF_H
-#define ASM_X86__MSGBUF_H
+#ifndef _ASM_X86_MSGBUF_H
+#define _ASM_X86_MSGBUF_H
 
 /*
  * The msqid64_ds structure for i386 architecture.
@@ -36,4 +36,4 @@ struct msqid64_ds {
 	unsigned long  __unused5;
 };
 
-#endif /* ASM_X86__MSGBUF_H */
+#endif /* _ASM_X86_MSGBUF_H */
diff --git a/include/asm-x86/msidef.h b/include/asm-x86/msidef.h
index ed91902..6706b30 100644
--- a/include/asm-x86/msidef.h
+++ b/include/asm-x86/msidef.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__MSIDEF_H
-#define ASM_X86__MSIDEF_H
+#ifndef _ASM_X86_MSIDEF_H
+#define _ASM_X86_MSIDEF_H
 
 /*
  * Constants for Intel APIC based MSI messages.
@@ -52,4 +52,4 @@
 #define MSI_ADDR_IR_SHV			(1 << 3)
 #define MSI_ADDR_IR_INDEX1(index)	((index & 0x8000) >> 13)
 #define MSI_ADDR_IR_INDEX2(index)	((index & 0x7fff) << 5)
-#endif /* ASM_X86__MSIDEF_H */
+#endif /* _ASM_X86_MSIDEF_H */
diff --git a/include/asm-x86/msr-index.h b/include/asm-x86/msr-index.h
index 0bb4330..d6b3908 100644
--- a/include/asm-x86/msr-index.h
+++ b/include/asm-x86/msr-index.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__MSR_INDEX_H
-#define ASM_X86__MSR_INDEX_H
+#ifndef _ASM_X86_MSR_INDEX_H
+#define _ASM_X86_MSR_INDEX_H
 
 /* CPU model specific register (MSR) numbers */
 
@@ -326,4 +326,4 @@
 #define MSR_IA32_VMX_PROCBASED_CTLS2    0x0000048b
 #define MSR_IA32_VMX_EPT_VPID_CAP       0x0000048c
 
-#endif /* ASM_X86__MSR_INDEX_H */
+#endif /* _ASM_X86_MSR_INDEX_H */
diff --git a/include/asm-x86/msr.h b/include/asm-x86/msr.h
index 530af1f..46be2fa 100644
--- a/include/asm-x86/msr.h
+++ b/include/asm-x86/msr.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__MSR_H
-#define ASM_X86__MSR_H
+#ifndef _ASM_X86_MSR_H
+#define _ASM_X86_MSR_H
 
 #include <asm/msr-index.h>
 
@@ -244,4 +244,4 @@ static inline int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
 #endif /* __KERNEL__ */
 
 
-#endif /* ASM_X86__MSR_H */
+#endif /* _ASM_X86_MSR_H */
diff --git a/include/asm-x86/mtrr.h b/include/asm-x86/mtrr.h
index 23a7f83..7c1e425 100644
--- a/include/asm-x86/mtrr.h
+++ b/include/asm-x86/mtrr.h
@@ -20,8 +20,8 @@
     The postal address is:
       Richard Gooch, c/o ATNF, P. O. Box 76, Epping, N.S.W., 2121, Australia.
 */
-#ifndef ASM_X86__MTRR_H
-#define ASM_X86__MTRR_H
+#ifndef _ASM_X86_MTRR_H
+#define _ASM_X86_MTRR_H
 
 #include <linux/ioctl.h>
 #include <linux/errno.h>
@@ -170,4 +170,4 @@ struct mtrr_gentry32 {
 
 #endif /* __KERNEL__ */
 
-#endif /* ASM_X86__MTRR_H */
+#endif /* _ASM_X86_MTRR_H */
diff --git a/include/asm-x86/mutex_32.h b/include/asm-x86/mutex_32.h
index 25c16d8..03f90c8 100644
--- a/include/asm-x86/mutex_32.h
+++ b/include/asm-x86/mutex_32.h
@@ -6,8 +6,8 @@
  *
  *  Copyright (C) 2004, 2005, 2006 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
  */
-#ifndef ASM_X86__MUTEX_32_H
-#define ASM_X86__MUTEX_32_H
+#ifndef _ASM_X86_MUTEX_32_H
+#define _ASM_X86_MUTEX_32_H
 
 #include <asm/alternative.h>
 
@@ -122,4 +122,4 @@ static inline int __mutex_fastpath_trylock(atomic_t *count,
 #endif
 }
 
-#endif /* ASM_X86__MUTEX_32_H */
+#endif /* _ASM_X86_MUTEX_32_H */
diff --git a/include/asm-x86/mutex_64.h b/include/asm-x86/mutex_64.h
index 918ba21..68a87b0 100644
--- a/include/asm-x86/mutex_64.h
+++ b/include/asm-x86/mutex_64.h
@@ -6,8 +6,8 @@
  *
  *  Copyright (C) 2004, 2005, 2006 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
  */
-#ifndef ASM_X86__MUTEX_64_H
-#define ASM_X86__MUTEX_64_H
+#ifndef _ASM_X86_MUTEX_64_H
+#define _ASM_X86_MUTEX_64_H
 
 /**
  * __mutex_fastpath_lock - decrement and call function if negative
@@ -97,4 +97,4 @@ static inline int __mutex_fastpath_trylock(atomic_t *count,
 		return 0;
 }
 
-#endif /* ASM_X86__MUTEX_64_H */
+#endif /* _ASM_X86_MUTEX_64_H */
diff --git a/include/asm-x86/nmi.h b/include/asm-x86/nmi.h
index a53f829..c45a0a5 100644
--- a/include/asm-x86/nmi.h
+++ b/include/asm-x86/nmi.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__NMI_H
-#define ASM_X86__NMI_H
+#ifndef _ASM_X86_NMI_H
+#define _ASM_X86_NMI_H
 
 #include <linux/pm.h>
 #include <asm/irq.h>
@@ -78,4 +78,4 @@ void enable_lapic_nmi_watchdog(void);
 void stop_nmi(void);
 void restart_nmi(void);
 
-#endif /* ASM_X86__NMI_H */
+#endif /* _ASM_X86_NMI_H */
diff --git a/include/asm-x86/nops.h b/include/asm-x86/nops.h
index ae74272..ad2668e 100644
--- a/include/asm-x86/nops.h
+++ b/include/asm-x86/nops.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__NOPS_H
-#define ASM_X86__NOPS_H
+#ifndef _ASM_X86_NOPS_H
+#define _ASM_X86_NOPS_H
 
 /* Define nops for use with alternative() */
 
@@ -115,4 +115,4 @@
 
 #define ASM_NOP_MAX 8
 
-#endif /* ASM_X86__NOPS_H */
+#endif /* _ASM_X86_NOPS_H */
diff --git a/include/asm-x86/numa_32.h b/include/asm-x86/numa_32.h
index 44cb078..e9f5db7 100644
--- a/include/asm-x86/numa_32.h
+++ b/include/asm-x86/numa_32.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__NUMA_32_H
-#define ASM_X86__NUMA_32_H
+#ifndef _ASM_X86_NUMA_32_H
+#define _ASM_X86_NUMA_32_H
 
 extern int pxm_to_nid(int pxm);
 extern void numa_remove_cpu(int cpu);
@@ -8,4 +8,4 @@ extern void numa_remove_cpu(int cpu);
 extern void set_highmem_pages_init(void);
 #endif
 
-#endif /* ASM_X86__NUMA_32_H */
+#endif /* _ASM_X86_NUMA_32_H */
diff --git a/include/asm-x86/numa_64.h b/include/asm-x86/numa_64.h
index 15c9903..064ed6d 100644
--- a/include/asm-x86/numa_64.h
+++ b/include/asm-x86/numa_64.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__NUMA_64_H
-#define ASM_X86__NUMA_64_H
+#ifndef _ASM_X86_NUMA_64_H
+#define _ASM_X86_NUMA_64_H
 
 #include <linux/nodemask.h>
 #include <asm/apicdef.h>
@@ -40,4 +40,4 @@ static inline void numa_add_cpu(int cpu, int node)	{ }
 static inline void numa_remove_cpu(int cpu)		{ }
 #endif
 
-#endif /* ASM_X86__NUMA_64_H */
+#endif /* _ASM_X86_NUMA_64_H */
diff --git a/include/asm-x86/numaq.h b/include/asm-x86/numaq.h
index 124bf7d..1e8bd30 100644
--- a/include/asm-x86/numaq.h
+++ b/include/asm-x86/numaq.h
@@ -23,8 +23,8 @@
  * Send feedback to <gone@us.ibm.com>
  */
 
-#ifndef ASM_X86__NUMAQ_H
-#define ASM_X86__NUMAQ_H
+#ifndef _ASM_X86_NUMAQ_H
+#define _ASM_X86_NUMAQ_H
 
 #ifdef CONFIG_X86_NUMAQ
 
@@ -165,5 +165,5 @@ static inline int get_memcfg_numaq(void)
 	return 0;
 }
 #endif /* CONFIG_X86_NUMAQ */
-#endif /* ASM_X86__NUMAQ_H */
+#endif /* _ASM_X86_NUMAQ_H */
 
diff --git a/include/asm-x86/olpc.h b/include/asm-x86/olpc.h
index d7328b1..834a302 100644
--- a/include/asm-x86/olpc.h
+++ b/include/asm-x86/olpc.h
@@ -1,7 +1,7 @@
 /* OLPC machine specific definitions */
 
-#ifndef ASM_X86__OLPC_H
-#define ASM_X86__OLPC_H
+#ifndef _ASM_X86_OLPC_H
+#define _ASM_X86_OLPC_H
 
 #include <asm/geode.h>
 
@@ -129,4 +129,4 @@ extern int olpc_ec_mask_unset(uint8_t bits);
 #define OLPC_GPIO_LID		geode_gpio(26)
 #define OLPC_GPIO_ECSCI		geode_gpio(27)
 
-#endif /* ASM_X86__OLPC_H */
+#endif /* _ASM_X86_OLPC_H */
diff --git a/include/asm-x86/page.h b/include/asm-x86/page.h
index d4f1d57..e9873a2 100644
--- a/include/asm-x86/page.h
+++ b/include/asm-x86/page.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__PAGE_H
-#define ASM_X86__PAGE_H
+#ifndef _ASM_X86_PAGE_H
+#define _ASM_X86_PAGE_H
 
 #include <linux/const.h>
 
@@ -206,4 +206,4 @@ extern bool __virt_addr_valid(unsigned long kaddr);
 #define __HAVE_ARCH_GATE_AREA 1
 
 #endif	/* __KERNEL__ */
-#endif /* ASM_X86__PAGE_H */
+#endif /* _ASM_X86_PAGE_H */
diff --git a/include/asm-x86/page_32.h b/include/asm-x86/page_32.h
index bdf5dba..bcde0d7 100644
--- a/include/asm-x86/page_32.h
+++ b/include/asm-x86/page_32.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__PAGE_32_H
-#define ASM_X86__PAGE_32_H
+#ifndef _ASM_X86_PAGE_32_H
+#define _ASM_X86_PAGE_32_H
 
 /*
  * This handles the memory map.
@@ -133,4 +133,4 @@ static inline void copy_page(void *to, void *from)
 #endif	/* CONFIG_X86_3DNOW */
 #endif	/* !__ASSEMBLY__ */
 
-#endif /* ASM_X86__PAGE_32_H */
+#endif /* _ASM_X86_PAGE_32_H */
diff --git a/include/asm-x86/page_64.h b/include/asm-x86/page_64.h
index 49380b8..5ebca29 100644
--- a/include/asm-x86/page_64.h
+++ b/include/asm-x86/page_64.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__PAGE_64_H
-#define ASM_X86__PAGE_64_H
+#ifndef _ASM_X86_PAGE_64_H
+#define _ASM_X86_PAGE_64_H
 
 #define PAGETABLE_LEVELS	4
 
@@ -102,4 +102,4 @@ extern void init_extra_mapping_wb(unsigned long phys, unsigned long size);
 #endif
 
 
-#endif /* ASM_X86__PAGE_64_H */
+#endif /* _ASM_X86_PAGE_64_H */
diff --git a/include/asm-x86/param.h b/include/asm-x86/param.h
index 0009cfb..6f0d042 100644
--- a/include/asm-x86/param.h
+++ b/include/asm-x86/param.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__PARAM_H
-#define ASM_X86__PARAM_H
+#ifndef _ASM_X86_PARAM_H
+#define _ASM_X86_PARAM_H
 
 #ifdef __KERNEL__
 # define HZ		CONFIG_HZ	/* Internal kernel timer frequency */
@@ -19,4 +19,4 @@
 
 #define MAXHOSTNAMELEN	64	/* max length of hostname */
 
-#endif /* ASM_X86__PARAM_H */
+#endif /* _ASM_X86_PARAM_H */
diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
index d580865..19affc1 100644
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__PARAVIRT_H
-#define ASM_X86__PARAVIRT_H
+#ifndef _ASM_X86_PARAVIRT_H
+#define _ASM_X86_PARAVIRT_H
 /* Various instructions on x86 need to be replaced for
  * para-virtualization: those hooks are defined here. */
 
@@ -1652,4 +1652,4 @@ static inline unsigned long __raw_local_irq_save(void)
 
 #endif /* __ASSEMBLY__ */
 #endif /* CONFIG_PARAVIRT */
-#endif /* ASM_X86__PARAVIRT_H */
+#endif /* _ASM_X86_PARAVIRT_H */
diff --git a/include/asm-x86/parport.h b/include/asm-x86/parport.h
index 2e3dda4..3c4ffeb 100644
--- a/include/asm-x86/parport.h
+++ b/include/asm-x86/parport.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__PARPORT_H
-#define ASM_X86__PARPORT_H
+#ifndef _ASM_X86_PARPORT_H
+#define _ASM_X86_PARPORT_H
 
 static int __devinit parport_pc_find_isa_ports(int autoirq, int autodma);
 static int __devinit parport_pc_find_nonpci_ports(int autoirq, int autodma)
@@ -7,4 +7,4 @@ static int __devinit parport_pc_find_nonpci_ports(int autoirq, int autodma)
 	return parport_pc_find_isa_ports(autoirq, autodma);
 }
 
-#endif /* ASM_X86__PARPORT_H */
+#endif /* _ASM_X86_PARPORT_H */
diff --git a/include/asm-x86/pat.h b/include/asm-x86/pat.h
index 482c3e3..b8493b3 100644
--- a/include/asm-x86/pat.h
+++ b/include/asm-x86/pat.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__PAT_H
-#define ASM_X86__PAT_H
+#ifndef _ASM_X86_PAT_H
+#define _ASM_X86_PAT_H
 
 #include <linux/types.h>
 
@@ -19,4 +19,4 @@ extern int free_memtype(u64 start, u64 end);
 
 extern void pat_disable(char *reason);
 
-#endif /* ASM_X86__PAT_H */
+#endif /* _ASM_X86_PAT_H */
diff --git a/include/asm-x86/pci-direct.h b/include/asm-x86/pci-direct.h
index da42be0..b1e7a45 100644
--- a/include/asm-x86/pci-direct.h
+++ b/include/asm-x86/pci-direct.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__PCI_DIRECT_H
-#define ASM_X86__PCI_DIRECT_H
+#ifndef _ASM_X86_PCI_DIRECT_H
+#define _ASM_X86_PCI_DIRECT_H
 
 #include <linux/types.h>
 
@@ -18,4 +18,4 @@ extern int early_pci_allowed(void);
 extern unsigned int pci_early_dump_regs;
 extern void early_dump_pci_device(u8 bus, u8 slot, u8 func);
 extern void early_dump_pci_devices(void);
-#endif /* ASM_X86__PCI_DIRECT_H */
+#endif /* _ASM_X86_PCI_DIRECT_H */
diff --git a/include/asm-x86/pci.h b/include/asm-x86/pci.h
index 61c9232..6477812 100644
--- a/include/asm-x86/pci.h
+++ b/include/asm-x86/pci.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__PCI_H
-#define ASM_X86__PCI_H
+#ifndef _ASM_X86_PCI_H
+#define _ASM_X86_PCI_H
 
 #include <linux/mm.h> /* for struct page */
 #include <linux/types.h>
@@ -113,4 +113,4 @@ static inline cpumask_t __pcibus_to_cpumask(struct pci_bus *bus)
 }
 #endif
 
-#endif /* ASM_X86__PCI_H */
+#endif /* _ASM_X86_PCI_H */
diff --git a/include/asm-x86/pci_32.h b/include/asm-x86/pci_32.h
index 3f22882..6f1213a 100644
--- a/include/asm-x86/pci_32.h
+++ b/include/asm-x86/pci_32.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__PCI_32_H
-#define ASM_X86__PCI_32_H
+#ifndef _ASM_X86_PCI_32_H
+#define _ASM_X86_PCI_32_H
 
 
 #ifdef __KERNEL__
@@ -31,4 +31,4 @@ struct pci_dev;
 #endif /* __KERNEL__ */
 
 
-#endif /* ASM_X86__PCI_32_H */
+#endif /* _ASM_X86_PCI_32_H */
diff --git a/include/asm-x86/pci_64.h b/include/asm-x86/pci_64.h
index f72e12d..5b28995 100644
--- a/include/asm-x86/pci_64.h
+++ b/include/asm-x86/pci_64.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__PCI_64_H
-#define ASM_X86__PCI_64_H
+#ifndef _ASM_X86_PCI_64_H
+#define _ASM_X86_PCI_64_H
 
 #ifdef __KERNEL__
 
@@ -63,4 +63,4 @@ extern void pci_iommu_alloc(void);
 
 #endif /* __KERNEL__ */
 
-#endif /* ASM_X86__PCI_64_H */
+#endif /* _ASM_X86_PCI_64_H */
diff --git a/include/asm-x86/pda.h b/include/asm-x86/pda.h
index db94ae0..cc9f981 100644
--- a/include/asm-x86/pda.h
+++ b/include/asm-x86/pda.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__PDA_H
-#define ASM_X86__PDA_H
+#ifndef _ASM_X86_PDA_H
+#define _ASM_X86_PDA_H
 
 #ifndef __ASSEMBLY__
 #include <linux/stddef.h>
@@ -133,4 +133,4 @@ do {									\
 
 #define PDA_STACKOFFSET (5*8)
 
-#endif /* ASM_X86__PDA_H */
+#endif /* _ASM_X86_PDA_H */
diff --git a/include/asm-x86/percpu.h b/include/asm-x86/percpu.h
index ceae33a..313b3d6 100644
--- a/include/asm-x86/percpu.h
+++ b/include/asm-x86/percpu.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__PERCPU_H
-#define ASM_X86__PERCPU_H
+#ifndef _ASM_X86_PERCPU_H
+#define _ASM_X86_PERCPU_H
 
 #ifdef CONFIG_X86_64
 #include <linux/compiler.h>
@@ -288,4 +288,4 @@ do {							\
 
 #endif	/* !CONFIG_SMP */
 
-#endif /* ASM_X86__PERCPU_H */
+#endif /* _ASM_X86_PERCPU_H */
diff --git a/include/asm-x86/pgalloc.h b/include/asm-x86/pgalloc.h
index 3cd23ad..cb7c151 100644
--- a/include/asm-x86/pgalloc.h
+++ b/include/asm-x86/pgalloc.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__PGALLOC_H
-#define ASM_X86__PGALLOC_H
+#ifndef _ASM_X86_PGALLOC_H
+#define _ASM_X86_PGALLOC_H
 
 #include <linux/threads.h>
 #include <linux/mm.h>		/* for struct page */
@@ -111,4 +111,4 @@ extern void __pud_free_tlb(struct mmu_gather *tlb, pud_t *pud);
 #endif	/* PAGETABLE_LEVELS > 3 */
 #endif	/* PAGETABLE_LEVELS > 2 */
 
-#endif /* ASM_X86__PGALLOC_H */
+#endif /* _ASM_X86_PGALLOC_H */
diff --git a/include/asm-x86/pgtable-2level-defs.h b/include/asm-x86/pgtable-2level-defs.h
index 7ec48f4..d77db89 100644
--- a/include/asm-x86/pgtable-2level-defs.h
+++ b/include/asm-x86/pgtable-2level-defs.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__PGTABLE_2LEVEL_DEFS_H
-#define ASM_X86__PGTABLE_2LEVEL_DEFS_H
+#ifndef _ASM_X86_PGTABLE_2LEVEL_DEFS_H
+#define _ASM_X86_PGTABLE_2LEVEL_DEFS_H
 
 #define SHARED_KERNEL_PMD	0
 
@@ -17,4 +17,4 @@
 
 #define PTRS_PER_PTE	1024
 
-#endif /* ASM_X86__PGTABLE_2LEVEL_DEFS_H */
+#endif /* _ASM_X86_PGTABLE_2LEVEL_DEFS_H */
diff --git a/include/asm-x86/pgtable-2level.h b/include/asm-x86/pgtable-2level.h
index 8176208..b17edfd 100644
--- a/include/asm-x86/pgtable-2level.h
+++ b/include/asm-x86/pgtable-2level.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__PGTABLE_2LEVEL_H
-#define ASM_X86__PGTABLE_2LEVEL_H
+#ifndef _ASM_X86_PGTABLE_2LEVEL_H
+#define _ASM_X86_PGTABLE_2LEVEL_H
 
 #define pte_ERROR(e) \
 	printk("%s:%d: bad pte %08lx.\n", __FILE__, __LINE__, (e).pte_low)
@@ -76,4 +76,4 @@ static inline pte_t native_ptep_get_and_clear(pte_t *xp)
 #define __pte_to_swp_entry(pte)		((swp_entry_t) { (pte).pte_low })
 #define __swp_entry_to_pte(x)		((pte_t) { .pte = (x).val })
 
-#endif /* ASM_X86__PGTABLE_2LEVEL_H */
+#endif /* _ASM_X86_PGTABLE_2LEVEL_H */
diff --git a/include/asm-x86/pgtable-3level-defs.h b/include/asm-x86/pgtable-3level-defs.h
index c05fe6f..6256136 100644
--- a/include/asm-x86/pgtable-3level-defs.h
+++ b/include/asm-x86/pgtable-3level-defs.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__PGTABLE_3LEVEL_DEFS_H
-#define ASM_X86__PGTABLE_3LEVEL_DEFS_H
+#ifndef _ASM_X86_PGTABLE_3LEVEL_DEFS_H
+#define _ASM_X86_PGTABLE_3LEVEL_DEFS_H
 
 #ifdef CONFIG_PARAVIRT
 #define SHARED_KERNEL_PMD	(pv_info.shared_kernel_pmd)
@@ -25,4 +25,4 @@
  */
 #define PTRS_PER_PTE	512
 
-#endif /* ASM_X86__PGTABLE_3LEVEL_DEFS_H */
+#endif /* _ASM_X86_PGTABLE_3LEVEL_DEFS_H */
diff --git a/include/asm-x86/pgtable-3level.h b/include/asm-x86/pgtable-3level.h
index 75f4276..fb16cec 100644
--- a/include/asm-x86/pgtable-3level.h
+++ b/include/asm-x86/pgtable-3level.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__PGTABLE_3LEVEL_H
-#define ASM_X86__PGTABLE_3LEVEL_H
+#ifndef _ASM_X86_PGTABLE_3LEVEL_H
+#define _ASM_X86_PGTABLE_3LEVEL_H
 
 /*
  * Intel Physical Address Extension (PAE) Mode - three-level page
@@ -172,4 +172,4 @@ static inline int pte_none(pte_t pte)
 #define __pte_to_swp_entry(pte)		((swp_entry_t){ (pte).pte_high })
 #define __swp_entry_to_pte(x)		((pte_t){ { .pte_high = (x).val } })
 
-#endif /* ASM_X86__PGTABLE_3LEVEL_H */
+#endif /* _ASM_X86_PGTABLE_3LEVEL_H */
diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
index 4b09533..3d8c84d 100644
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__PGTABLE_H
-#define ASM_X86__PGTABLE_H
+#ifndef _ASM_X86_PGTABLE_H
+#define _ASM_X86_PGTABLE_H
 
 #define FIRST_USER_ADDRESS	0
 
@@ -553,4 +553,4 @@ static inline void clone_pgd_range(pgd_t *dst, pgd_t *src, int count)
 #include <asm-generic/pgtable.h>
 #endif	/* __ASSEMBLY__ */
 
-#endif /* ASM_X86__PGTABLE_H */
+#endif /* _ASM_X86_PGTABLE_H */
diff --git a/include/asm-x86/pgtable_32.h b/include/asm-x86/pgtable_32.h
index 34cbd82..23f6447 100644
--- a/include/asm-x86/pgtable_32.h
+++ b/include/asm-x86/pgtable_32.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__PGTABLE_32_H
-#define ASM_X86__PGTABLE_32_H
+#ifndef _ASM_X86_PGTABLE_32_H
+#define _ASM_X86_PGTABLE_32_H
 
 
 /*
@@ -194,4 +194,4 @@ do {						\
 #define io_remap_pfn_range(vma, vaddr, pfn, size, prot)	\
 	remap_pfn_range(vma, vaddr, pfn, size, prot)
 
-#endif /* ASM_X86__PGTABLE_32_H */
+#endif /* _ASM_X86_PGTABLE_32_H */
diff --git a/include/asm-x86/pgtable_64.h b/include/asm-x86/pgtable_64.h
index b91ab6d..862b3ee 100644
--- a/include/asm-x86/pgtable_64.h
+++ b/include/asm-x86/pgtable_64.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__PGTABLE_64_H
-#define ASM_X86__PGTABLE_64_H
+#ifndef _ASM_X86_PGTABLE_64_H
+#define _ASM_X86_PGTABLE_64_H
 
 #include <linux/const.h>
 #ifndef __ASSEMBLY__
@@ -288,4 +288,4 @@ extern void cleanup_highmap(void);
 #define __HAVE_ARCH_PTE_SAME
 #endif /* !__ASSEMBLY__ */
 
-#endif /* ASM_X86__PGTABLE_64_H */
+#endif /* _ASM_X86_PGTABLE_64_H */
diff --git a/include/asm-x86/posix_types_32.h b/include/asm-x86/posix_types_32.h
index 70cf2bb..f7d9adf 100644
--- a/include/asm-x86/posix_types_32.h
+++ b/include/asm-x86/posix_types_32.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__POSIX_TYPES_32_H
-#define ASM_X86__POSIX_TYPES_32_H
+#ifndef _ASM_X86_POSIX_TYPES_32_H
+#define _ASM_X86_POSIX_TYPES_32_H
 
 /*
  * This file is generally used by user-level software, so you need to
@@ -82,4 +82,4 @@ do {								\
 
 #endif /* defined(__KERNEL__) */
 
-#endif /* ASM_X86__POSIX_TYPES_32_H */
+#endif /* _ASM_X86_POSIX_TYPES_32_H */
diff --git a/include/asm-x86/posix_types_64.h b/include/asm-x86/posix_types_64.h
index 388b4e7..eb8d2d9 100644
--- a/include/asm-x86/posix_types_64.h
+++ b/include/asm-x86/posix_types_64.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__POSIX_TYPES_64_H
-#define ASM_X86__POSIX_TYPES_64_H
+#ifndef _ASM_X86_POSIX_TYPES_64_H
+#define _ASM_X86_POSIX_TYPES_64_H
 
 /*
  * This file is generally used by user-level software, so you need to
@@ -116,4 +116,4 @@ static inline void __FD_ZERO(__kernel_fd_set *p)
 
 #endif /* defined(__KERNEL__) */
 
-#endif /* ASM_X86__POSIX_TYPES_64_H */
+#endif /* _ASM_X86_POSIX_TYPES_64_H */
diff --git a/include/asm-x86/prctl.h b/include/asm-x86/prctl.h
index e7ae34e..fe68114 100644
--- a/include/asm-x86/prctl.h
+++ b/include/asm-x86/prctl.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__PRCTL_H
-#define ASM_X86__PRCTL_H
+#ifndef _ASM_X86_PRCTL_H
+#define _ASM_X86_PRCTL_H
 
 #define ARCH_SET_GS 0x1001
 #define ARCH_SET_FS 0x1002
@@ -7,4 +7,4 @@
 #define ARCH_GET_GS 0x1004
 
 
-#endif /* ASM_X86__PRCTL_H */
+#endif /* _ASM_X86_PRCTL_H */
diff --git a/include/asm-x86/processor-flags.h b/include/asm-x86/processor-flags.h
index dc5f071..7a3e836 100644
--- a/include/asm-x86/processor-flags.h
+++ b/include/asm-x86/processor-flags.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__PROCESSOR_FLAGS_H
-#define ASM_X86__PROCESSOR_FLAGS_H
+#ifndef _ASM_X86_PROCESSOR_FLAGS_H
+#define _ASM_X86_PROCESSOR_FLAGS_H
 /* Various flags defined: can be included from assembler. */
 
 /*
@@ -97,4 +97,4 @@
 #endif
 #endif
 
-#endif /* ASM_X86__PROCESSOR_FLAGS_H */
+#endif /* _ASM_X86_PROCESSOR_FLAGS_H */
diff --git a/include/asm-x86/processor.h b/include/asm-x86/processor.h
index ee7cbb3..5ca01e3 100644
--- a/include/asm-x86/processor.h
+++ b/include/asm-x86/processor.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__PROCESSOR_H
-#define ASM_X86__PROCESSOR_H
+#ifndef _ASM_X86_PROCESSOR_H
+#define _ASM_X86_PROCESSOR_H
 
 #include <asm/processor-flags.h>
 
@@ -933,4 +933,4 @@ extern void start_thread(struct pt_regs *regs, unsigned long new_ip,
 extern int get_tsc_mode(unsigned long adr);
 extern int set_tsc_mode(unsigned int val);
 
-#endif /* ASM_X86__PROCESSOR_H */
+#endif /* _ASM_X86_PROCESSOR_H */
diff --git a/include/asm-x86/proto.h b/include/asm-x86/proto.h
index 6e89e8b..d6a22f9 100644
--- a/include/asm-x86/proto.h
+++ b/include/asm-x86/proto.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__PROTO_H
-#define ASM_X86__PROTO_H
+#ifndef _ASM_X86_PROTO_H
+#define _ASM_X86_PROTO_H
 
 #include <asm/ldt.h>
 
@@ -29,4 +29,4 @@ long do_arch_prctl(struct task_struct *task, int code, unsigned long addr);
 #define round_up(x, y) (((x) + (y) - 1) & ~((y) - 1))
 #define round_down(x, y) ((x) & ~((y) - 1))
 
-#endif /* ASM_X86__PROTO_H */
+#endif /* _ASM_X86_PROTO_H */
diff --git a/include/asm-x86/ptrace-abi.h b/include/asm-x86/ptrace-abi.h
index 4298b88..25f1bb8 100644
--- a/include/asm-x86/ptrace-abi.h
+++ b/include/asm-x86/ptrace-abi.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__PTRACE_ABI_H
-#define ASM_X86__PTRACE_ABI_H
+#ifndef _ASM_X86_PTRACE_ABI_H
+#define _ASM_X86_PTRACE_ABI_H
 
 #ifdef __i386__
 
@@ -142,4 +142,4 @@ struct ptrace_bts_config {
 */
 #endif /* CONFIG_X86_PTRACE_BTS */
 
-#endif /* ASM_X86__PTRACE_ABI_H */
+#endif /* _ASM_X86_PTRACE_ABI_H */
diff --git a/include/asm-x86/ptrace.h b/include/asm-x86/ptrace.h
index a202552..d1531c8 100644
--- a/include/asm-x86/ptrace.h
+++ b/include/asm-x86/ptrace.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__PTRACE_H
-#define ASM_X86__PTRACE_H
+#ifndef _ASM_X86_PTRACE_H
+#define _ASM_X86_PTRACE_H
 
 #include <linux/compiler.h>	/* For __user */
 #include <asm/ptrace-abi.h>
@@ -277,4 +277,4 @@ extern int do_set_thread_area(struct task_struct *p, int idx,
 
 #endif /* !__ASSEMBLY__ */
 
-#endif /* ASM_X86__PTRACE_H */
+#endif /* _ASM_X86_PTRACE_H */
diff --git a/include/asm-x86/pvclock-abi.h b/include/asm-x86/pvclock-abi.h
index edb3b4e..6d93508 100644
--- a/include/asm-x86/pvclock-abi.h
+++ b/include/asm-x86/pvclock-abi.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__PVCLOCK_ABI_H
-#define ASM_X86__PVCLOCK_ABI_H
+#ifndef _ASM_X86_PVCLOCK_ABI_H
+#define _ASM_X86_PVCLOCK_ABI_H
 #ifndef __ASSEMBLY__
 
 /*
@@ -39,4 +39,4 @@ struct pvclock_wall_clock {
 } __attribute__((__packed__));
 
 #endif /* __ASSEMBLY__ */
-#endif /* ASM_X86__PVCLOCK_ABI_H */
+#endif /* _ASM_X86_PVCLOCK_ABI_H */
diff --git a/include/asm-x86/pvclock.h b/include/asm-x86/pvclock.h
index 1a38f68..8125182 100644
--- a/include/asm-x86/pvclock.h
+++ b/include/asm-x86/pvclock.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__PVCLOCK_H
-#define ASM_X86__PVCLOCK_H
+#ifndef _ASM_X86_PVCLOCK_H
+#define _ASM_X86_PVCLOCK_H
 
 #include <linux/clocksource.h>
 #include <asm/pvclock-abi.h>
@@ -10,4 +10,4 @@ void pvclock_read_wallclock(struct pvclock_wall_clock *wall,
 			    struct pvclock_vcpu_time_info *vcpu,
 			    struct timespec *ts);
 
-#endif /* ASM_X86__PVCLOCK_H */
+#endif /* _ASM_X86_PVCLOCK_H */
diff --git a/include/asm-x86/reboot.h b/include/asm-x86/reboot.h
index 1c2f0ce..df77103 100644
--- a/include/asm-x86/reboot.h
+++ b/include/asm-x86/reboot.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__REBOOT_H
-#define ASM_X86__REBOOT_H
+#ifndef _ASM_X86_REBOOT_H
+#define _ASM_X86_REBOOT_H
 
 struct pt_regs;
 
@@ -18,4 +18,4 @@ void native_machine_crash_shutdown(struct pt_regs *regs);
 void native_machine_shutdown(void);
 void machine_real_restart(const unsigned char *code, int length);
 
-#endif /* ASM_X86__REBOOT_H */
+#endif /* _ASM_X86_REBOOT_H */
diff --git a/include/asm-x86/reboot_fixups.h b/include/asm-x86/reboot_fixups.h
index 2c2987d..765debe 100644
--- a/include/asm-x86/reboot_fixups.h
+++ b/include/asm-x86/reboot_fixups.h
@@ -1,6 +1,6 @@
-#ifndef ASM_X86__REBOOT_FIXUPS_H
-#define ASM_X86__REBOOT_FIXUPS_H
+#ifndef _ASM_X86_REBOOT_FIXUPS_H
+#define _ASM_X86_REBOOT_FIXUPS_H
 
 extern void mach_reboot_fixups(void);
 
-#endif /* ASM_X86__REBOOT_FIXUPS_H */
+#endif /* _ASM_X86_REBOOT_FIXUPS_H */
diff --git a/include/asm-x86/required-features.h b/include/asm-x86/required-features.h
index a01c4e3..d5cd6c5 100644
--- a/include/asm-x86/required-features.h
+++ b/include/asm-x86/required-features.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__REQUIRED_FEATURES_H
-#define ASM_X86__REQUIRED_FEATURES_H
+#ifndef _ASM_X86_REQUIRED_FEATURES_H
+#define _ASM_X86_REQUIRED_FEATURES_H
 
 /* Define minimum CPUID feature set for kernel These bits are checked
    really early to actually display a visible error message before the
@@ -79,4 +79,4 @@
 #define REQUIRED_MASK6	0
 #define REQUIRED_MASK7	0
 
-#endif /* ASM_X86__REQUIRED_FEATURES_H */
+#endif /* _ASM_X86_REQUIRED_FEATURES_H */
diff --git a/include/asm-x86/resume-trace.h b/include/asm-x86/resume-trace.h
index e39376d..3ff1c2c 100644
--- a/include/asm-x86/resume-trace.h
+++ b/include/asm-x86/resume-trace.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__RESUME_TRACE_H
-#define ASM_X86__RESUME_TRACE_H
+#ifndef _ASM_X86_RESUME_TRACE_H
+#define _ASM_X86_RESUME_TRACE_H
 
 #include <asm/asm.h>
 
@@ -18,4 +18,4 @@ do {								\
 	}							\
 } while (0)
 
-#endif /* ASM_X86__RESUME_TRACE_H */
+#endif /* _ASM_X86_RESUME_TRACE_H */
diff --git a/include/asm-x86/rio.h b/include/asm-x86/rio.h
index 5e1256b..97bab63 100644
--- a/include/asm-x86/rio.h
+++ b/include/asm-x86/rio.h
@@ -5,8 +5,8 @@
  * Author: Laurent Vivier <Laurent.Vivier@bull.net>
  */
 
-#ifndef ASM_X86__RIO_H
-#define ASM_X86__RIO_H
+#ifndef _ASM_X86_RIO_H
+#define _ASM_X86_RIO_H
 
 #define RIO_TABLE_VERSION	3
 
@@ -60,4 +60,4 @@ enum {
 	ALT_CALGARY	= 5,	/* Second Planar Calgary      */
 };
 
-#endif /* ASM_X86__RIO_H */
+#endif /* _ASM_X86_RIO_H */
diff --git a/include/asm-x86/rwlock.h b/include/asm-x86/rwlock.h
index 48a3109..6a8c0d6 100644
--- a/include/asm-x86/rwlock.h
+++ b/include/asm-x86/rwlock.h
@@ -1,8 +1,8 @@
-#ifndef ASM_X86__RWLOCK_H
-#define ASM_X86__RWLOCK_H
+#ifndef _ASM_X86_RWLOCK_H
+#define _ASM_X86_RWLOCK_H
 
 #define RW_LOCK_BIAS		 0x01000000
 
 /* Actual code is in asm/spinlock.h or in arch/x86/lib/rwlock.S */
 
-#endif /* ASM_X86__RWLOCK_H */
+#endif /* _ASM_X86_RWLOCK_H */
diff --git a/include/asm-x86/rwsem.h b/include/asm-x86/rwsem.h
index 3ff3015..ca7517d 100644
--- a/include/asm-x86/rwsem.h
+++ b/include/asm-x86/rwsem.h
@@ -29,8 +29,8 @@
  * front, then they'll all be woken up, but no other readers will be.
  */
 
-#ifndef ASM_X86__RWSEM_H
-#define ASM_X86__RWSEM_H
+#ifndef _ASM_X86_RWSEM_H
+#define _ASM_X86_RWSEM_H
 
 #ifndef _LINUX_RWSEM_H
 #error "please don't include asm/rwsem.h directly, use linux/rwsem.h instead"
@@ -262,4 +262,4 @@ static inline int rwsem_is_locked(struct rw_semaphore *sem)
 }
 
 #endif /* __KERNEL__ */
-#endif /* ASM_X86__RWSEM_H */
+#endif /* _ASM_X86_RWSEM_H */
diff --git a/include/asm-x86/scatterlist.h b/include/asm-x86/scatterlist.h
index ee48f88..263d397 100644
--- a/include/asm-x86/scatterlist.h
+++ b/include/asm-x86/scatterlist.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__SCATTERLIST_H
-#define ASM_X86__SCATTERLIST_H
+#ifndef _ASM_X86_SCATTERLIST_H
+#define _ASM_X86_SCATTERLIST_H
 
 #include <asm/types.h>
 
@@ -30,4 +30,4 @@ struct scatterlist {
 # define sg_dma_len(sg)		((sg)->dma_length)
 #endif
 
-#endif /* ASM_X86__SCATTERLIST_H */
+#endif /* _ASM_X86_SCATTERLIST_H */
diff --git a/include/asm-x86/seccomp_32.h b/include/asm-x86/seccomp_32.h
index cf9ab2d..a6ad87b 100644
--- a/include/asm-x86/seccomp_32.h
+++ b/include/asm-x86/seccomp_32.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__SECCOMP_32_H
-#define ASM_X86__SECCOMP_32_H
+#ifndef _ASM_X86_SECCOMP_32_H
+#define _ASM_X86_SECCOMP_32_H
 
 #include <linux/thread_info.h>
 
@@ -14,4 +14,4 @@
 #define __NR_seccomp_exit __NR_exit
 #define __NR_seccomp_sigreturn __NR_sigreturn
 
-#endif /* ASM_X86__SECCOMP_32_H */
+#endif /* _ASM_X86_SECCOMP_32_H */
diff --git a/include/asm-x86/seccomp_64.h b/include/asm-x86/seccomp_64.h
index 03274ce..4171bb7 100644
--- a/include/asm-x86/seccomp_64.h
+++ b/include/asm-x86/seccomp_64.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__SECCOMP_64_H
-#define ASM_X86__SECCOMP_64_H
+#ifndef _ASM_X86_SECCOMP_64_H
+#define _ASM_X86_SECCOMP_64_H
 
 #include <linux/thread_info.h>
 
@@ -22,4 +22,4 @@
 #define __NR_seccomp_exit_32 __NR_ia32_exit
 #define __NR_seccomp_sigreturn_32 __NR_ia32_sigreturn
 
-#endif /* ASM_X86__SECCOMP_64_H */
+#endif /* _ASM_X86_SECCOMP_64_H */
diff --git a/include/asm-x86/segment.h b/include/asm-x86/segment.h
index 5d6e694..1dc1b51 100644
--- a/include/asm-x86/segment.h
+++ b/include/asm-x86/segment.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__SEGMENT_H
-#define ASM_X86__SEGMENT_H
+#ifndef _ASM_X86_SEGMENT_H
+#define _ASM_X86_SEGMENT_H
 
 /* Constructor for a conventional segment GDT (or LDT) entry */
 /* This is a macro so it can be used in initializers */
@@ -206,4 +206,4 @@ extern const char early_idt_handlers[NUM_EXCEPTION_VECTORS][10];
 #endif
 #endif
 
-#endif /* ASM_X86__SEGMENT_H */
+#endif /* _ASM_X86_SEGMENT_H */
diff --git a/include/asm-x86/sembuf.h b/include/asm-x86/sembuf.h
index 81f06b7..ee50c80 100644
--- a/include/asm-x86/sembuf.h
+++ b/include/asm-x86/sembuf.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__SEMBUF_H
-#define ASM_X86__SEMBUF_H
+#ifndef _ASM_X86_SEMBUF_H
+#define _ASM_X86_SEMBUF_H
 
 /*
  * The semid64_ds structure for x86 architecture.
@@ -21,4 +21,4 @@ struct semid64_ds {
 	unsigned long	__unused4;
 };
 
-#endif /* ASM_X86__SEMBUF_H */
+#endif /* _ASM_X86_SEMBUF_H */
diff --git a/include/asm-x86/serial.h b/include/asm-x86/serial.h
index 303660b..628c801 100644
--- a/include/asm-x86/serial.h
+++ b/include/asm-x86/serial.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__SERIAL_H
-#define ASM_X86__SERIAL_H
+#ifndef _ASM_X86_SERIAL_H
+#define _ASM_X86_SERIAL_H
 
 /*
  * This assumes you have a 1.8432 MHz clock for your UART.
@@ -26,4 +26,4 @@
 	{ 0, BASE_BAUD, 0x3E8, 4, STD_COM_FLAGS },	/* ttyS2 */	\
 	{ 0, BASE_BAUD, 0x2E8, 3, STD_COM4_FLAGS },	/* ttyS3 */
 
-#endif /* ASM_X86__SERIAL_H */
+#endif /* _ASM_X86_SERIAL_H */
diff --git a/include/asm-x86/setup.h b/include/asm-x86/setup.h
index 11b6cc1..f12d372 100644
--- a/include/asm-x86/setup.h
+++ b/include/asm-x86/setup.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__SETUP_H
-#define ASM_X86__SETUP_H
+#ifndef _ASM_X86_SETUP_H
+#define _ASM_X86_SETUP_H
 
 #define COMMAND_LINE_SIZE 2048
 
@@ -102,4 +102,4 @@ void __init x86_64_start_reservations(char *real_mode_data);
 #endif /* __ASSEMBLY__ */
 #endif  /*  __KERNEL__  */
 
-#endif /* ASM_X86__SETUP_H */
+#endif /* _ASM_X86_SETUP_H */
diff --git a/include/asm-x86/shmbuf.h b/include/asm-x86/shmbuf.h
index f51aec2..b51413b 100644
--- a/include/asm-x86/shmbuf.h
+++ b/include/asm-x86/shmbuf.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__SHMBUF_H
-#define ASM_X86__SHMBUF_H
+#ifndef _ASM_X86_SHMBUF_H
+#define _ASM_X86_SHMBUF_H
 
 /*
  * The shmid64_ds structure for x86 architecture.
@@ -48,4 +48,4 @@ struct shminfo64 {
 	unsigned long	__unused4;
 };
 
-#endif /* ASM_X86__SHMBUF_H */
+#endif /* _ASM_X86_SHMBUF_H */
diff --git a/include/asm-x86/shmparam.h b/include/asm-x86/shmparam.h
index a83a1fd..0880cf0 100644
--- a/include/asm-x86/shmparam.h
+++ b/include/asm-x86/shmparam.h
@@ -1,6 +1,6 @@
-#ifndef ASM_X86__SHMPARAM_H
-#define ASM_X86__SHMPARAM_H
+#ifndef _ASM_X86_SHMPARAM_H
+#define _ASM_X86_SHMPARAM_H
 
 #define SHMLBA PAGE_SIZE	 /* attach addr a multiple of this */
 
-#endif /* ASM_X86__SHMPARAM_H */
+#endif /* _ASM_X86_SHMPARAM_H */
diff --git a/include/asm-x86/sigcontext.h b/include/asm-x86/sigcontext.h
index ee813f4..0afcb5e 100644
--- a/include/asm-x86/sigcontext.h
+++ b/include/asm-x86/sigcontext.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__SIGCONTEXT_H
-#define ASM_X86__SIGCONTEXT_H
+#ifndef _ASM_X86_SIGCONTEXT_H
+#define _ASM_X86_SIGCONTEXT_H
 
 #include <linux/compiler.h>
 #include <asm/types.h>
@@ -281,4 +281,4 @@ struct _xstate {
 	/* new processor state extensions go here */
 };
 
-#endif /* ASM_X86__SIGCONTEXT_H */
+#endif /* _ASM_X86_SIGCONTEXT_H */
diff --git a/include/asm-x86/sigcontext32.h b/include/asm-x86/sigcontext32.h
index 8c34703..6126188 100644
--- a/include/asm-x86/sigcontext32.h
+++ b/include/asm-x86/sigcontext32.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__SIGCONTEXT32_H
-#define ASM_X86__SIGCONTEXT32_H
+#ifndef _ASM_X86_SIGCONTEXT32_H
+#define _ASM_X86_SIGCONTEXT32_H
 
 /* signal context for 32bit programs. */
 
@@ -72,4 +72,4 @@ struct sigcontext_ia32 {
        unsigned int cr2;
 };
 
-#endif /* ASM_X86__SIGCONTEXT32_H */
+#endif /* _ASM_X86_SIGCONTEXT32_H */
diff --git a/include/asm-x86/siginfo.h b/include/asm-x86/siginfo.h
index 808bdfb..fc1aa55 100644
--- a/include/asm-x86/siginfo.h
+++ b/include/asm-x86/siginfo.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__SIGINFO_H
-#define ASM_X86__SIGINFO_H
+#ifndef _ASM_X86_SIGINFO_H
+#define _ASM_X86_SIGINFO_H
 
 #ifdef __x86_64__
 # define __ARCH_SI_PREAMBLE_SIZE	(4 * sizeof(int))
@@ -7,4 +7,4 @@
 
 #include <asm-generic/siginfo.h>
 
-#endif /* ASM_X86__SIGINFO_H */
+#endif /* _ASM_X86_SIGINFO_H */
diff --git a/include/asm-x86/signal.h b/include/asm-x86/signal.h
index 65acc82..96ac44f 100644
--- a/include/asm-x86/signal.h
+++ b/include/asm-x86/signal.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__SIGNAL_H
-#define ASM_X86__SIGNAL_H
+#ifndef _ASM_X86_SIGNAL_H
+#define _ASM_X86_SIGNAL_H
 
 #ifndef __ASSEMBLY__
 #include <linux/types.h>
@@ -259,4 +259,4 @@ struct pt_regs;
 #endif /* __KERNEL__ */
 #endif /* __ASSEMBLY__ */
 
-#endif /* ASM_X86__SIGNAL_H */
+#endif /* _ASM_X86_SIGNAL_H */
diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
index 76b9ffb..0a9a875 100644
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__SMP_H
-#define ASM_X86__SMP_H
+#ifndef _ASM_X86_SMP_H
+#define _ASM_X86_SMP_H
 #ifndef __ASSEMBLY__
 #include <linux/cpumask.h>
 #include <linux/init.h>
@@ -226,4 +226,4 @@ static inline int hard_smp_processor_id(void)
 #endif /* CONFIG_X86_LOCAL_APIC */
 
 #endif /* __ASSEMBLY__ */
-#endif /* ASM_X86__SMP_H */
+#endif /* _ASM_X86_SMP_H */
diff --git a/include/asm-x86/socket.h b/include/asm-x86/socket.h
index db73274..8ab9cc8 100644
--- a/include/asm-x86/socket.h
+++ b/include/asm-x86/socket.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__SOCKET_H
-#define ASM_X86__SOCKET_H
+#ifndef _ASM_X86_SOCKET_H
+#define _ASM_X86_SOCKET_H
 
 #include <asm/sockios.h>
 
@@ -54,4 +54,4 @@
 
 #define SO_MARK			36
 
-#endif /* ASM_X86__SOCKET_H */
+#endif /* _ASM_X86_SOCKET_H */
diff --git a/include/asm-x86/sockios.h b/include/asm-x86/sockios.h
index a006704..49cc72b 100644
--- a/include/asm-x86/sockios.h
+++ b/include/asm-x86/sockios.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__SOCKIOS_H
-#define ASM_X86__SOCKIOS_H
+#ifndef _ASM_X86_SOCKIOS_H
+#define _ASM_X86_SOCKIOS_H
 
 /* Socket-level I/O control calls. */
 #define FIOSETOWN	0x8901
@@ -10,4 +10,4 @@
 #define SIOCGSTAMP	0x8906		/* Get stamp (timeval) */
 #define SIOCGSTAMPNS	0x8907		/* Get stamp (timespec) */
 
-#endif /* ASM_X86__SOCKIOS_H */
+#endif /* _ASM_X86_SOCKIOS_H */
diff --git a/include/asm-x86/sparsemem.h b/include/asm-x86/sparsemem.h
index 38f8e6b..be44f7d 100644
--- a/include/asm-x86/sparsemem.h
+++ b/include/asm-x86/sparsemem.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__SPARSEMEM_H
-#define ASM_X86__SPARSEMEM_H
+#ifndef _ASM_X86_SPARSEMEM_H
+#define _ASM_X86_SPARSEMEM_H
 
 #ifdef CONFIG_SPARSEMEM
 /*
@@ -31,4 +31,4 @@
 #endif
 
 #endif /* CONFIG_SPARSEMEM */
-#endif /* ASM_X86__SPARSEMEM_H */
+#endif /* _ASM_X86_SPARSEMEM_H */
diff --git a/include/asm-x86/spinlock.h b/include/asm-x86/spinlock.h
index 157ff7f..d17c919 100644
--- a/include/asm-x86/spinlock.h
+++ b/include/asm-x86/spinlock.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__SPINLOCK_H
-#define ASM_X86__SPINLOCK_H
+#ifndef _ASM_X86_SPINLOCK_H
+#define _ASM_X86_SPINLOCK_H
 
 #include <asm/atomic.h>
 #include <asm/rwlock.h>
@@ -361,4 +361,4 @@ static inline void __raw_write_unlock(raw_rwlock_t *rw)
 #define _raw_read_relax(lock)	cpu_relax()
 #define _raw_write_relax(lock)	cpu_relax()
 
-#endif /* ASM_X86__SPINLOCK_H */
+#endif /* _ASM_X86_SPINLOCK_H */
diff --git a/include/asm-x86/spinlock_types.h b/include/asm-x86/spinlock_types.h
index 6aa9b56..845f81c 100644
--- a/include/asm-x86/spinlock_types.h
+++ b/include/asm-x86/spinlock_types.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__SPINLOCK_TYPES_H
-#define ASM_X86__SPINLOCK_TYPES_H
+#ifndef _ASM_X86_SPINLOCK_TYPES_H
+#define _ASM_X86_SPINLOCK_TYPES_H
 
 #ifndef __LINUX_SPINLOCK_TYPES_H
 # error "please don't include this file directly"
@@ -17,4 +17,4 @@ typedef struct {
 
 #define __RAW_RW_LOCK_UNLOCKED		{ RW_LOCK_BIAS }
 
-#endif /* ASM_X86__SPINLOCK_TYPES_H */
+#endif /* _ASM_X86_SPINLOCK_TYPES_H */
diff --git a/include/asm-x86/srat.h b/include/asm-x86/srat.h
index 5363e4f..b508d63 100644
--- a/include/asm-x86/srat.h
+++ b/include/asm-x86/srat.h
@@ -24,8 +24,8 @@
  * Send feedback to Pat Gaughen <gone@us.ibm.com>
  */
 
-#ifndef ASM_X86__SRAT_H
-#define ASM_X86__SRAT_H
+#ifndef _ASM_X86_SRAT_H
+#define _ASM_X86_SRAT_H
 
 #ifdef CONFIG_ACPI_NUMA
 extern int get_memcfg_from_srat(void);
@@ -36,4 +36,4 @@ static inline int get_memcfg_from_srat(void)
 }
 #endif
 
-#endif /* ASM_X86__SRAT_H */
+#endif /* _ASM_X86_SRAT_H */
diff --git a/include/asm-x86/stacktrace.h b/include/asm-x86/stacktrace.h
index f43517e..f517944 100644
--- a/include/asm-x86/stacktrace.h
+++ b/include/asm-x86/stacktrace.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__STACKTRACE_H
-#define ASM_X86__STACKTRACE_H
+#ifndef _ASM_X86_STACKTRACE_H
+#define _ASM_X86_STACKTRACE_H
 
 extern int kstack_depth_to_print;
 
@@ -18,4 +18,4 @@ void dump_trace(struct task_struct *tsk, struct pt_regs *regs,
 		unsigned long *stack, unsigned long bp,
 		const struct stacktrace_ops *ops, void *data);
 
-#endif /* ASM_X86__STACKTRACE_H */
+#endif /* _ASM_X86_STACKTRACE_H */
diff --git a/include/asm-x86/stat.h b/include/asm-x86/stat.h
index 1e120f6..e0b1d9b 100644
--- a/include/asm-x86/stat.h
+++ b/include/asm-x86/stat.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__STAT_H
-#define ASM_X86__STAT_H
+#ifndef _ASM_X86_STAT_H
+#define _ASM_X86_STAT_H
 
 #define STAT_HAVE_NSEC 1
 
@@ -111,4 +111,4 @@ struct __old_kernel_stat {
 #endif
 };
 
-#endif /* ASM_X86__STAT_H */
+#endif /* _ASM_X86_STAT_H */
diff --git a/include/asm-x86/statfs.h b/include/asm-x86/statfs.h
index 3f005bc..2f8e732 100644
--- a/include/asm-x86/statfs.h
+++ b/include/asm-x86/statfs.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__STATFS_H
-#define ASM_X86__STATFS_H
+#ifndef _ASM_X86_STATFS_H
+#define _ASM_X86_STATFS_H
 
 #ifdef __i386__
 #include <asm-generic/statfs.h>
@@ -60,4 +60,4 @@ struct compat_statfs64 {
 } __attribute__((packed));
 
 #endif /* !__i386__ */
-#endif /* ASM_X86__STATFS_H */
+#endif /* _ASM_X86_STATFS_H */
diff --git a/include/asm-x86/string_32.h b/include/asm-x86/string_32.h
index 6983805..c86f452 100644
--- a/include/asm-x86/string_32.h
+++ b/include/asm-x86/string_32.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__STRING_32_H
-#define ASM_X86__STRING_32_H
+#ifndef _ASM_X86_STRING_32_H
+#define _ASM_X86_STRING_32_H
 
 #ifdef __KERNEL__
 
@@ -331,4 +331,4 @@ extern void *memscan(void *addr, int c, size_t size);
 
 #endif /* __KERNEL__ */
 
-#endif /* ASM_X86__STRING_32_H */
+#endif /* _ASM_X86_STRING_32_H */
diff --git a/include/asm-x86/string_64.h b/include/asm-x86/string_64.h
index e531bce..19e2c46 100644
--- a/include/asm-x86/string_64.h
+++ b/include/asm-x86/string_64.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__STRING_64_H
-#define ASM_X86__STRING_64_H
+#ifndef _ASM_X86_STRING_64_H
+#define _ASM_X86_STRING_64_H
 
 #ifdef __KERNEL__
 
@@ -65,4 +65,4 @@ int strcmp(const char *cs, const char *ct);
 
 #endif /* __KERNEL__ */
 
-#endif /* ASM_X86__STRING_64_H */
+#endif /* _ASM_X86_STRING_64_H */
diff --git a/include/asm-x86/suspend_32.h b/include/asm-x86/suspend_32.h
index acb6d4d..a5074bd 100644
--- a/include/asm-x86/suspend_32.h
+++ b/include/asm-x86/suspend_32.h
@@ -3,8 +3,8 @@
  * Based on code
  * Copyright 2001 Patrick Mochel <mochel@osdl.org>
  */
-#ifndef ASM_X86__SUSPEND_32_H
-#define ASM_X86__SUSPEND_32_H
+#ifndef _ASM_X86_SUSPEND_32_H
+#define _ASM_X86_SUSPEND_32_H
 
 #include <asm/desc.h>
 #include <asm/i387.h>
@@ -48,4 +48,4 @@ static inline void acpi_save_register_state(unsigned long return_point)
 extern int acpi_save_state_mem(void);
 #endif
 
-#endif /* ASM_X86__SUSPEND_32_H */
+#endif /* _ASM_X86_SUSPEND_32_H */
diff --git a/include/asm-x86/suspend_64.h b/include/asm-x86/suspend_64.h
index cf821dd..06284f4 100644
--- a/include/asm-x86/suspend_64.h
+++ b/include/asm-x86/suspend_64.h
@@ -3,8 +3,8 @@
  * Based on code
  * Copyright 2001 Patrick Mochel <mochel@osdl.org>
  */
-#ifndef ASM_X86__SUSPEND_64_H
-#define ASM_X86__SUSPEND_64_H
+#ifndef _ASM_X86_SUSPEND_64_H
+#define _ASM_X86_SUSPEND_64_H
 
 #include <asm/desc.h>
 #include <asm/i387.h>
@@ -49,4 +49,4 @@ extern int acpi_save_state_mem(void);
 extern char core_restore_code;
 extern char restore_registers;
 
-#endif /* ASM_X86__SUSPEND_64_H */
+#endif /* _ASM_X86_SUSPEND_64_H */
diff --git a/include/asm-x86/swiotlb.h b/include/asm-x86/swiotlb.h
index 1e20adb..51fb2c7 100644
--- a/include/asm-x86/swiotlb.h
+++ b/include/asm-x86/swiotlb.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__SWIOTLB_H
-#define ASM_X86__SWIOTLB_H
+#ifndef _ASM_X86_SWIOTLB_H
+#define _ASM_X86_SWIOTLB_H
 
 #include <asm/dma-mapping.h>
 
@@ -55,4 +55,4 @@ static inline void pci_swiotlb_init(void)
 
 static inline void dma_mark_clean(void *addr, size_t size) {}
 
-#endif /* ASM_X86__SWIOTLB_H */
+#endif /* _ASM_X86_SWIOTLB_H */
diff --git a/include/asm-x86/sync_bitops.h b/include/asm-x86/sync_bitops.h
index b689bee..9d09b40 100644
--- a/include/asm-x86/sync_bitops.h
+++ b/include/asm-x86/sync_bitops.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__SYNC_BITOPS_H
-#define ASM_X86__SYNC_BITOPS_H
+#ifndef _ASM_X86_SYNC_BITOPS_H
+#define _ASM_X86_SYNC_BITOPS_H
 
 /*
  * Copyright 1992, Linus Torvalds.
@@ -127,4 +127,4 @@ static inline int sync_test_and_change_bit(int nr, volatile unsigned long *addr)
 
 #undef ADDR
 
-#endif /* ASM_X86__SYNC_BITOPS_H */
+#endif /* _ASM_X86_SYNC_BITOPS_H */
diff --git a/include/asm-x86/system.h b/include/asm-x86/system.h
index d79fa4a..c1fe6c7 100644
--- a/include/asm-x86/system.h
+++ b/include/asm-x86/system.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__SYSTEM_H
-#define ASM_X86__SYSTEM_H
+#ifndef _ASM_X86_SYSTEM_H
+#define _ASM_X86_SYSTEM_H
 
 #include <asm/asm.h>
 #include <asm/segment.h>
@@ -426,4 +426,4 @@ static inline void rdtsc_barrier(void)
 	alternative(ASM_NOP3, "lfence", X86_FEATURE_LFENCE_RDTSC);
 }
 
-#endif /* ASM_X86__SYSTEM_H */
+#endif /* _ASM_X86_SYSTEM_H */
diff --git a/include/asm-x86/system_64.h b/include/asm-x86/system_64.h
index 5aedb8b..1159e09 100644
--- a/include/asm-x86/system_64.h
+++ b/include/asm-x86/system_64.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__SYSTEM_64_H
-#define ASM_X86__SYSTEM_64_H
+#ifndef _ASM_X86_SYSTEM_64_H
+#define _ASM_X86_SYSTEM_64_H
 
 #include <asm/segment.h>
 #include <asm/cmpxchg.h>
@@ -19,4 +19,4 @@ static inline void write_cr8(unsigned long val)
 
 #include <linux/irqflags.h>
 
-#endif /* ASM_X86__SYSTEM_64_H */
+#endif /* _ASM_X86_SYSTEM_64_H */
diff --git a/include/asm-x86/tce.h b/include/asm-x86/tce.h
index e7932d7..7a6677c 100644
--- a/include/asm-x86/tce.h
+++ b/include/asm-x86/tce.h
@@ -21,8 +21,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
  */
 
-#ifndef ASM_X86__TCE_H
-#define ASM_X86__TCE_H
+#ifndef _ASM_X86_TCE_H
+#define _ASM_X86_TCE_H
 
 extern unsigned int specified_table_size;
 struct iommu_table;
@@ -45,4 +45,4 @@ extern void * __init alloc_tce_table(void);
 extern void __init free_tce_table(void *tbl);
 extern int __init build_tce_table(struct pci_dev *dev, void __iomem *bbar);
 
-#endif /* ASM_X86__TCE_H */
+#endif /* _ASM_X86_TCE_H */
diff --git a/include/asm-x86/termbits.h b/include/asm-x86/termbits.h
index 3d00dc5..af1b70e 100644
--- a/include/asm-x86/termbits.h
+++ b/include/asm-x86/termbits.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__TERMBITS_H
-#define ASM_X86__TERMBITS_H
+#ifndef _ASM_X86_TERMBITS_H
+#define _ASM_X86_TERMBITS_H
 
 #include <linux/posix_types.h>
 
@@ -195,4 +195,4 @@ struct ktermios {
 #define	TCSADRAIN	1
 #define	TCSAFLUSH	2
 
-#endif /* ASM_X86__TERMBITS_H */
+#endif /* _ASM_X86_TERMBITS_H */
diff --git a/include/asm-x86/termios.h b/include/asm-x86/termios.h
index e235db2..f729563 100644
--- a/include/asm-x86/termios.h
+++ b/include/asm-x86/termios.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__TERMIOS_H
-#define ASM_X86__TERMIOS_H
+#ifndef _ASM_X86_TERMIOS_H
+#define _ASM_X86_TERMIOS_H
 
 #include <asm/termbits.h>
 #include <asm/ioctls.h>
@@ -110,4 +110,4 @@ static inline int kernel_termios_to_user_termios_1(struct termios __user *u,
 
 #endif	/* __KERNEL__ */
 
-#endif /* ASM_X86__TERMIOS_H */
+#endif /* _ASM_X86_TERMIOS_H */
diff --git a/include/asm-x86/therm_throt.h b/include/asm-x86/therm_throt.h
index 1c7f57b..c62349e 100644
--- a/include/asm-x86/therm_throt.h
+++ b/include/asm-x86/therm_throt.h
@@ -1,9 +1,9 @@
-#ifndef ASM_X86__THERM_THROT_H
-#define ASM_X86__THERM_THROT_H
+#ifndef _ASM_X86_THERM_THROT_H
+#define _ASM_X86_THERM_THROT_H
 
 #include <asm/atomic.h>
 
 extern atomic_t therm_throt_en;
 int therm_throt_process(int curr);
 
-#endif /* ASM_X86__THERM_THROT_H */
+#endif /* _ASM_X86_THERM_THROT_H */
diff --git a/include/asm-x86/thread_info.h b/include/asm-x86/thread_info.h
index 3f4e52b..e44d379 100644
--- a/include/asm-x86/thread_info.h
+++ b/include/asm-x86/thread_info.h
@@ -4,8 +4,8 @@
  * - Incorporating suggestions made by Linus Torvalds and Dave Miller
  */
 
-#ifndef ASM_X86__THREAD_INFO_H
-#define ASM_X86__THREAD_INFO_H
+#ifndef _ASM_X86_THREAD_INFO_H
+#define _ASM_X86_THREAD_INFO_H
 
 #include <linux/compiler.h>
 #include <asm/page.h>
@@ -261,4 +261,4 @@ extern void free_thread_info(struct thread_info *ti);
 extern int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src);
 #define arch_task_cache_init arch_task_cache_init
 #endif
-#endif /* ASM_X86__THREAD_INFO_H */
+#endif /* _ASM_X86_THREAD_INFO_H */
diff --git a/include/asm-x86/time.h b/include/asm-x86/time.h
index 3e724ee..50c733a 100644
--- a/include/asm-x86/time.h
+++ b/include/asm-x86/time.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__TIME_H
-#define ASM_X86__TIME_H
+#ifndef _ASM_X86_TIME_H
+#define _ASM_X86_TIME_H
 
 extern void hpet_time_init(void);
 
@@ -60,4 +60,4 @@ extern void time_init(void);
 
 extern unsigned long __init calibrate_cpu(void);
 
-#endif /* ASM_X86__TIME_H */
+#endif /* _ASM_X86_TIME_H */
diff --git a/include/asm-x86/timer.h b/include/asm-x86/timer.h
index d0babce..2bb6a83 100644
--- a/include/asm-x86/timer.h
+++ b/include/asm-x86/timer.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__TIMER_H
-#define ASM_X86__TIMER_H
+#ifndef _ASM_X86_TIMER_H
+#define _ASM_X86_TIMER_H
 #include <linux/init.h>
 #include <linux/pm.h>
 #include <linux/percpu.h>
@@ -63,4 +63,4 @@ static inline unsigned long long cycles_2_ns(unsigned long long cyc)
 	return ns;
 }
 
-#endif /* ASM_X86__TIMER_H */
+#endif /* _ASM_X86_TIMER_H */
diff --git a/include/asm-x86/timex.h b/include/asm-x86/timex.h
index d1ce241..1287dc1 100644
--- a/include/asm-x86/timex.h
+++ b/include/asm-x86/timex.h
@@ -1,6 +1,6 @@
 /* x86 architecture timex specifications */
-#ifndef ASM_X86__TIMEX_H
-#define ASM_X86__TIMEX_H
+#ifndef _ASM_X86_TIMEX_H
+#define _ASM_X86_TIMEX_H
 
 #include <asm/processor.h>
 #include <asm/tsc.h>
@@ -16,4 +16,4 @@
 
 #define ARCH_HAS_READ_CURRENT_TIMER
 
-#endif /* ASM_X86__TIMEX_H */
+#endif /* _ASM_X86_TIMEX_H */
diff --git a/include/asm-x86/tlb.h b/include/asm-x86/tlb.h
index db36e9e..829215f 100644
--- a/include/asm-x86/tlb.h
+++ b/include/asm-x86/tlb.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__TLB_H
-#define ASM_X86__TLB_H
+#ifndef _ASM_X86_TLB_H
+#define _ASM_X86_TLB_H
 
 #define tlb_start_vma(tlb, vma) do { } while (0)
 #define tlb_end_vma(tlb, vma) do { } while (0)
@@ -8,4 +8,4 @@
 
 #include <asm-generic/tlb.h>
 
-#endif /* ASM_X86__TLB_H */
+#endif /* _ASM_X86_TLB_H */
diff --git a/include/asm-x86/tlbflush.h b/include/asm-x86/tlbflush.h
index 3cdd08b..0e7bbb5 100644
--- a/include/asm-x86/tlbflush.h
+++ b/include/asm-x86/tlbflush.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__TLBFLUSH_H
-#define ASM_X86__TLBFLUSH_H
+#ifndef _ASM_X86_TLBFLUSH_H
+#define _ASM_X86_TLBFLUSH_H
 
 #include <linux/mm.h>
 #include <linux/sched.h>
@@ -175,4 +175,4 @@ static inline void flush_tlb_kernel_range(unsigned long start,
 	flush_tlb_all();
 }
 
-#endif /* ASM_X86__TLBFLUSH_H */
+#endif /* _ASM_X86_TLBFLUSH_H */
diff --git a/include/asm-x86/topology.h b/include/asm-x86/topology.h
index 7eca9bc..90ac771 100644
--- a/include/asm-x86/topology.h
+++ b/include/asm-x86/topology.h
@@ -22,8 +22,8 @@
  *
  * Send feedback to <colpatch@us.ibm.com>
  */
-#ifndef ASM_X86__TOPOLOGY_H
-#define ASM_X86__TOPOLOGY_H
+#ifndef _ASM_X86_TOPOLOGY_H
+#define _ASM_X86_TOPOLOGY_H
 
 #ifdef CONFIG_X86_32
 # ifdef CONFIG_X86_HT
@@ -255,4 +255,4 @@ static inline void set_mp_bus_to_node(int busnum, int node)
 }
 #endif
 
-#endif /* ASM_X86__TOPOLOGY_H */
+#endif /* _ASM_X86_TOPOLOGY_H */
diff --git a/include/asm-x86/trampoline.h b/include/asm-x86/trampoline.h
index 0406bbd..fa0d79f 100644
--- a/include/asm-x86/trampoline.h
+++ b/include/asm-x86/trampoline.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__TRAMPOLINE_H
-#define ASM_X86__TRAMPOLINE_H
+#ifndef _ASM_X86_TRAMPOLINE_H
+#define _ASM_X86_TRAMPOLINE_H
 
 #ifndef __ASSEMBLY__
 
@@ -18,4 +18,4 @@ extern unsigned long setup_trampoline(void);
 
 #endif /* __ASSEMBLY__ */
 
-#endif /* ASM_X86__TRAMPOLINE_H */
+#endif /* _ASM_X86_TRAMPOLINE_H */
diff --git a/include/asm-x86/traps.h b/include/asm-x86/traps.h
index 6c3dc2c..45dee28 100644
--- a/include/asm-x86/traps.h
+++ b/include/asm-x86/traps.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__TRAPS_H
-#define ASM_X86__TRAPS_H
+#ifndef _ASM_X86_TRAPS_H
+#define _ASM_X86_TRAPS_H
 
 #include <asm/debugreg.h>
 
@@ -78,4 +78,4 @@ unsigned long patch_espfix_desc(unsigned long, unsigned long);
 asmlinkage void math_emulate(long);
 #endif
 
-#endif /* ASM_X86__TRAPS_H */
+#endif /* _ASM_X86_TRAPS_H */
diff --git a/include/asm-x86/tsc.h b/include/asm-x86/tsc.h
index ad0f5c4..38ae163 100644
--- a/include/asm-x86/tsc.h
+++ b/include/asm-x86/tsc.h
@@ -1,8 +1,8 @@
 /*
  * x86 TSC related functions
  */
-#ifndef ASM_X86__TSC_H
-#define ASM_X86__TSC_H
+#ifndef _ASM_X86_TSC_H
+#define _ASM_X86_TSC_H
 
 #include <asm/processor.h>
 
@@ -59,4 +59,4 @@ extern void check_tsc_sync_target(void);
 
 extern int notsc_setup(char *);
 
-#endif /* ASM_X86__TSC_H */
+#endif /* _ASM_X86_TSC_H */
diff --git a/include/asm-x86/types.h b/include/asm-x86/types.h
index e78b52e..e6f7363 100644
--- a/include/asm-x86/types.h
+++ b/include/asm-x86/types.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__TYPES_H
-#define ASM_X86__TYPES_H
+#ifndef _ASM_X86_TYPES_H
+#define _ASM_X86_TYPES_H
 
 #include <asm-generic/int-ll64.h>
 
@@ -33,4 +33,4 @@ typedef u32 dma_addr_t;
 #endif /* __ASSEMBLY__ */
 #endif /* __KERNEL__ */
 
-#endif /* ASM_X86__TYPES_H */
+#endif /* _ASM_X86_TYPES_H */
diff --git a/include/asm-x86/uaccess.h b/include/asm-x86/uaccess.h
index 414b116..99192bb 100644
--- a/include/asm-x86/uaccess.h
+++ b/include/asm-x86/uaccess.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__UACCESS_H
-#define ASM_X86__UACCESS_H
+#ifndef _ASM_X86_UACCESS_H
+#define _ASM_X86_UACCESS_H
 /*
  * User space memory access functions
  */
@@ -452,5 +452,5 @@ extern struct movsl_mask {
 # include "uaccess_64.h"
 #endif
 
-#endif /* ASM_X86__UACCESS_H */
+#endif /* _ASM_X86_UACCESS_H */
 
diff --git a/include/asm-x86/uaccess_32.h b/include/asm-x86/uaccess_32.h
index 956794d..5e06259 100644
--- a/include/asm-x86/uaccess_32.h
+++ b/include/asm-x86/uaccess_32.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__UACCESS_32_H
-#define ASM_X86__UACCESS_32_H
+#ifndef _ASM_X86_UACCESS_32_H
+#define _ASM_X86_UACCESS_32_H
 
 /*
  * User space memory access functions
@@ -215,4 +215,4 @@ long strnlen_user(const char __user *str, long n);
 unsigned long __must_check clear_user(void __user *mem, unsigned long len);
 unsigned long __must_check __clear_user(void __user *mem, unsigned long len);
 
-#endif /* ASM_X86__UACCESS_32_H */
+#endif /* _ASM_X86_UACCESS_32_H */
diff --git a/include/asm-x86/uaccess_64.h b/include/asm-x86/uaccess_64.h
index cdf5949..543ba88 100644
--- a/include/asm-x86/uaccess_64.h
+++ b/include/asm-x86/uaccess_64.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__UACCESS_64_H
-#define ASM_X86__UACCESS_64_H
+#ifndef _ASM_X86_UACCESS_64_H
+#define _ASM_X86_UACCESS_64_H
 
 /*
  * User space memory access functions
@@ -205,4 +205,4 @@ static inline int __copy_from_user_inatomic_nocache(void *dst,
 unsigned long
 copy_user_handle_tail(char *to, char *from, unsigned len, unsigned zerorest);
 
-#endif /* ASM_X86__UACCESS_64_H */
+#endif /* _ASM_X86_UACCESS_64_H */
diff --git a/include/asm-x86/ucontext.h b/include/asm-x86/ucontext.h
index 89eaa54..87324cf 100644
--- a/include/asm-x86/ucontext.h
+++ b/include/asm-x86/ucontext.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__UCONTEXT_H
-#define ASM_X86__UCONTEXT_H
+#ifndef _ASM_X86_UCONTEXT_H
+#define _ASM_X86_UCONTEXT_H
 
 #define UC_FP_XSTATE	0x1	/* indicates the presence of extended state
 				 * information in the memory layout pointed
@@ -15,4 +15,4 @@ struct ucontext {
 	sigset_t	  uc_sigmask;	/* mask last for extensibility */
 };
 
-#endif /* ASM_X86__UCONTEXT_H */
+#endif /* _ASM_X86_UCONTEXT_H */
diff --git a/include/asm-x86/unaligned.h b/include/asm-x86/unaligned.h
index 59dcdec..a7bd416 100644
--- a/include/asm-x86/unaligned.h
+++ b/include/asm-x86/unaligned.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__UNALIGNED_H
-#define ASM_X86__UNALIGNED_H
+#ifndef _ASM_X86_UNALIGNED_H
+#define _ASM_X86_UNALIGNED_H
 
 /*
  * The x86 can do unaligned accesses itself.
@@ -11,4 +11,4 @@
 #define get_unaligned __get_unaligned_le
 #define put_unaligned __put_unaligned_le
 
-#endif /* ASM_X86__UNALIGNED_H */
+#endif /* _ASM_X86_UNALIGNED_H */
diff --git a/include/asm-x86/unistd_32.h b/include/asm-x86/unistd_32.h
index 017f4a8..f2bba78 100644
--- a/include/asm-x86/unistd_32.h
+++ b/include/asm-x86/unistd_32.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__UNISTD_32_H
-#define ASM_X86__UNISTD_32_H
+#ifndef _ASM_X86_UNISTD_32_H
+#define _ASM_X86_UNISTD_32_H
 
 /*
  * This file contains the system call numbers.
@@ -376,4 +376,4 @@
 #endif
 
 #endif /* __KERNEL__ */
-#endif /* ASM_X86__UNISTD_32_H */
+#endif /* _ASM_X86_UNISTD_32_H */
diff --git a/include/asm-x86/unistd_64.h b/include/asm-x86/unistd_64.h
index ace83f1..834b2c1 100644
--- a/include/asm-x86/unistd_64.h
+++ b/include/asm-x86/unistd_64.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__UNISTD_64_H
-#define ASM_X86__UNISTD_64_H
+#ifndef _ASM_X86_UNISTD_64_H
+#define _ASM_X86_UNISTD_64_H
 
 #ifndef __SYSCALL
 #define __SYSCALL(a, b)
@@ -690,4 +690,4 @@ __SYSCALL(__NR_inotify_init1, sys_inotify_init1)
 #define cond_syscall(x) asm(".weak\t" #x "\n\t.set\t" #x ",sys_ni_syscall")
 #endif	/* __KERNEL__ */
 
-#endif /* ASM_X86__UNISTD_64_H */
+#endif /* _ASM_X86_UNISTD_64_H */
diff --git a/include/asm-x86/unwind.h b/include/asm-x86/unwind.h
index a215156..8b064bd 100644
--- a/include/asm-x86/unwind.h
+++ b/include/asm-x86/unwind.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__UNWIND_H
-#define ASM_X86__UNWIND_H
+#ifndef _ASM_X86_UNWIND_H
+#define _ASM_X86_UNWIND_H
 
 #define UNW_PC(frame) ((void)(frame), 0UL)
 #define UNW_SP(frame) ((void)(frame), 0UL)
@@ -10,4 +10,4 @@ static inline int arch_unw_user_mode(const void *info)
 	return 0;
 }
 
-#endif /* ASM_X86__UNWIND_H */
+#endif /* _ASM_X86_UNWIND_H */
diff --git a/include/asm-x86/user32.h b/include/asm-x86/user32.h
index aa66c18..14cbb73 100644
--- a/include/asm-x86/user32.h
+++ b/include/asm-x86/user32.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__USER32_H
-#define ASM_X86__USER32_H
+#ifndef _ASM_X86_USER32_H
+#define _ASM_X86_USER32_H
 
 /* IA32 compatible user structures for ptrace.
  * These should be used for 32bit coredumps too. */
@@ -67,4 +67,4 @@ struct user32 {
 };
 
 
-#endif /* ASM_X86__USER32_H */
+#endif /* _ASM_X86_USER32_H */
diff --git a/include/asm-x86/user_32.h b/include/asm-x86/user_32.h
index e0fe2f5..bebfd86 100644
--- a/include/asm-x86/user_32.h
+++ b/include/asm-x86/user_32.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__USER_32_H
-#define ASM_X86__USER_32_H
+#ifndef _ASM_X86_USER_32_H
+#define _ASM_X86_USER_32_H
 
 #include <asm/page.h>
 /* Core file format: The core file is written in such a way that gdb
@@ -128,4 +128,4 @@ struct user{
 #define HOST_TEXT_START_ADDR (u.start_code)
 #define HOST_STACK_END_ADDR (u.start_stack + u.u_ssize * NBPG)
 
-#endif /* ASM_X86__USER_32_H */
+#endif /* _ASM_X86_USER_32_H */
diff --git a/include/asm-x86/user_64.h b/include/asm-x86/user_64.h
index 38b5799..faf2cd3 100644
--- a/include/asm-x86/user_64.h
+++ b/include/asm-x86/user_64.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__USER_64_H
-#define ASM_X86__USER_64_H
+#ifndef _ASM_X86_USER_64_H
+#define _ASM_X86_USER_64_H
 
 #include <asm/types.h>
 #include <asm/page.h>
@@ -134,4 +134,4 @@ struct user {
 #define HOST_TEXT_START_ADDR (u.start_code)
 #define HOST_STACK_END_ADDR (u.start_stack + u.u_ssize * NBPG)
 
-#endif /* ASM_X86__USER_64_H */
+#endif /* _ASM_X86_USER_64_H */
diff --git a/include/asm-x86/uv/bios.h b/include/asm-x86/uv/bios.h
index 215f196..2836439 100644
--- a/include/asm-x86/uv/bios.h
+++ b/include/asm-x86/uv/bios.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__UV__BIOS_H
-#define ASM_X86__UV__BIOS_H
+#ifndef _ASM_X86_UV__BIOS_H
+#define _ASM_X86_UV__BIOS_H
 
 /*
  * UV BIOS layer definitions.
@@ -91,4 +91,4 @@ extern long uv_region_size;
 
 extern struct kobject *sgi_uv_kobj;	/* /sys/firmware/sgi_uv */
 
-#endif /* ASM_X86__UV__BIOS_H */
+#endif /* _ASM_X86_UV__BIOS_H */
diff --git a/include/asm-x86/uv/uv_bau.h b/include/asm-x86/uv/uv_bau.h
index 77153fb..4d632fd 100644
--- a/include/asm-x86/uv/uv_bau.h
+++ b/include/asm-x86/uv/uv_bau.h
@@ -8,8 +8,8 @@
  * Copyright (C) 2008 Silicon Graphics, Inc. All rights reserved.
  */
 
-#ifndef ASM_X86__UV__UV_BAU_H
-#define ASM_X86__UV__UV_BAU_H
+#ifndef _ASM_X86_UV__UV_BAU_H
+#define _ASM_X86_UV__UV_BAU_H
 
 #include <linux/bitmap.h>
 #define BITSPERBYTE 8
@@ -329,4 +329,4 @@ extern int uv_flush_tlb_others(cpumask_t *, struct mm_struct *, unsigned long);
 extern void uv_bau_message_intr1(void);
 extern void uv_bau_timeout_intr1(void);
 
-#endif /* ASM_X86__UV__UV_BAU_H */
+#endif /* _ASM_X86_UV__UV_BAU_H */
diff --git a/include/asm-x86/uv/uv_hub.h b/include/asm-x86/uv/uv_hub.h
index bdb5b01..126fafa 100644
--- a/include/asm-x86/uv/uv_hub.h
+++ b/include/asm-x86/uv/uv_hub.h
@@ -8,8 +8,8 @@
  * Copyright (C) 2007-2008 Silicon Graphics, Inc. All rights reserved.
  */
 
-#ifndef ASM_X86__UV__UV_HUB_H
-#define ASM_X86__UV__UV_HUB_H
+#ifndef _ASM_X86_UV__UV_HUB_H
+#define _ASM_X86_UV__UV_HUB_H
 
 #include <linux/numa.h>
 #include <linux/percpu.h>
@@ -350,5 +350,5 @@ static inline int uv_num_possible_blades(void)
 	return uv_possible_blades;
 }
 
-#endif /* ASM_X86__UV__UV_HUB_H */
+#endif /* _ASM_X86_UV__UV_HUB_H */
 
diff --git a/include/asm-x86/uv/uv_irq.h b/include/asm-x86/uv/uv_irq.h
index 8bf5f32..8502826 100644
--- a/include/asm-x86/uv/uv_irq.h
+++ b/include/asm-x86/uv/uv_irq.h
@@ -8,8 +8,8 @@
  * Copyright (C) 2008 Silicon Graphics, Inc. All rights reserved.
  */
 
-#ifndef ASM_X86__UV__UV_IRQ_H
-#define ASM_X86__UV__UV_IRQ_H
+#ifndef _ASM_X86_UV__UV_IRQ_H
+#define _ASM_X86_UV__UV_IRQ_H
 
 /* If a generic version of this structure gets defined, eliminate this one. */
 struct uv_IO_APIC_route_entry {
@@ -33,4 +33,4 @@ extern void arch_disable_uv_irq(int, unsigned long);
 extern int uv_setup_irq(char *, int, int, unsigned long);
 extern void uv_teardown_irq(unsigned int, int, unsigned long);
 
-#endif /* ASM_X86__UV__UV_IRQ_H */
+#endif /* _ASM_X86_UV__UV_IRQ_H */
diff --git a/include/asm-x86/uv/uv_mmrs.h b/include/asm-x86/uv/uv_mmrs.h
index 8b03d89..9ce9ba5 100644
--- a/include/asm-x86/uv/uv_mmrs.h
+++ b/include/asm-x86/uv/uv_mmrs.h
@@ -8,8 +8,8 @@
  * Copyright (C) 2007-2008 Silicon Graphics, Inc. All rights reserved.
  */
 
-#ifndef ASM_X86__UV__UV_MMRS_H
-#define ASM_X86__UV__UV_MMRS_H
+#ifndef _ASM_X86_UV__UV_MMRS_H
+#define _ASM_X86_UV__UV_MMRS_H
 
 #define UV_MMR_ENABLE		(1UL << 63)
 
@@ -1292,4 +1292,4 @@ union uvh_si_alias2_overlay_config_u {
 };
 
 
-#endif /* ASM_X86__UV__UV_MMRS_H */
+#endif /* _ASM_X86_UV__UV_MMRS_H */
diff --git a/include/asm-x86/vdso.h b/include/asm-x86/vdso.h
index 4ab3209..9064052 100644
--- a/include/asm-x86/vdso.h
+++ b/include/asm-x86/vdso.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__VDSO_H
-#define ASM_X86__VDSO_H
+#ifndef _ASM_X86_VDSO_H
+#define _ASM_X86_VDSO_H
 
 #ifdef CONFIG_X86_64
 extern const char VDSO64_PRELINK[];
@@ -44,4 +44,4 @@ extern const char vdso32_int80_start, vdso32_int80_end;
 extern const char vdso32_syscall_start, vdso32_syscall_end;
 extern const char vdso32_sysenter_start, vdso32_sysenter_end;
 
-#endif /* ASM_X86__VDSO_H */
+#endif /* _ASM_X86_VDSO_H */
diff --git a/include/asm-x86/vga.h b/include/asm-x86/vga.h
index b9e493d..c4b9dc2 100644
--- a/include/asm-x86/vga.h
+++ b/include/asm-x86/vga.h
@@ -4,8 +4,8 @@
  *	(c) 1998 Martin Mares <mj@ucw.cz>
  */
 
-#ifndef ASM_X86__VGA_H
-#define ASM_X86__VGA_H
+#ifndef _ASM_X86_VGA_H
+#define _ASM_X86_VGA_H
 
 /*
  *	On the PC, we can just recalculate addresses and then
@@ -17,4 +17,4 @@
 #define vga_readb(x) (*(x))
 #define vga_writeb(x, y) (*(y) = (x))
 
-#endif /* ASM_X86__VGA_H */
+#endif /* _ASM_X86_VGA_H */
diff --git a/include/asm-x86/vgtod.h b/include/asm-x86/vgtod.h
index 38fd133..dc27a69 100644
--- a/include/asm-x86/vgtod.h
+++ b/include/asm-x86/vgtod.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__VGTOD_H
-#define ASM_X86__VGTOD_H
+#ifndef _ASM_X86_VGTOD_H
+#define _ASM_X86_VGTOD_H
 
 #include <asm/vsyscall.h>
 #include <linux/clocksource.h>
@@ -26,4 +26,4 @@ extern struct vsyscall_gtod_data __vsyscall_gtod_data
 __section_vsyscall_gtod_data;
 extern struct vsyscall_gtod_data vsyscall_gtod_data;
 
-#endif /* ASM_X86__VGTOD_H */
+#endif /* _ASM_X86_VGTOD_H */
diff --git a/include/asm-x86/visws/cobalt.h b/include/asm-x86/visws/cobalt.h
index 9627a8f..0cc20f3 100644
--- a/include/asm-x86/visws/cobalt.h
+++ b/include/asm-x86/visws/cobalt.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__VISWS__COBALT_H
-#define ASM_X86__VISWS__COBALT_H
+#ifndef _ASM_X86_VISWS__COBALT_H
+#define _ASM_X86_VISWS__COBALT_H
 
 #include <asm/fixmap.h>
 
@@ -122,4 +122,4 @@ extern char visws_board_type;
 
 extern char visws_board_rev;
 
-#endif /* ASM_X86__VISWS__COBALT_H */
+#endif /* _ASM_X86_VISWS__COBALT_H */
diff --git a/include/asm-x86/visws/lithium.h b/include/asm-x86/visws/lithium.h
index b36d3b3..1163e51 100644
--- a/include/asm-x86/visws/lithium.h
+++ b/include/asm-x86/visws/lithium.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__VISWS__LITHIUM_H
-#define ASM_X86__VISWS__LITHIUM_H
+#ifndef _ASM_X86_VISWS__LITHIUM_H
+#define _ASM_X86_VISWS__LITHIUM_H
 
 #include <asm/fixmap.h>
 
@@ -49,5 +49,5 @@ static inline unsigned short li_pcib_read16(unsigned long reg)
 	return *((volatile unsigned short *)(LI_PCIB_VADDR+reg));
 }
 
-#endif /* ASM_X86__VISWS__LITHIUM_H */
+#endif /* _ASM_X86_VISWS__LITHIUM_H */
 
diff --git a/include/asm-x86/visws/piix4.h b/include/asm-x86/visws/piix4.h
index 61c9380..80d376e 100644
--- a/include/asm-x86/visws/piix4.h
+++ b/include/asm-x86/visws/piix4.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__VISWS__PIIX4_H
-#define ASM_X86__VISWS__PIIX4_H
+#ifndef _ASM_X86_VISWS__PIIX4_H
+#define _ASM_X86_VISWS__PIIX4_H
 
 /*
  * PIIX4 as used on SGI Visual Workstations
@@ -104,4 +104,4 @@
  */
 #define	PIIX_GPI_STPCLK		0x4	// STPCLK signal routed back in
 
-#endif /* ASM_X86__VISWS__PIIX4_H */
+#endif /* _ASM_X86_VISWS__PIIX4_H */
diff --git a/include/asm-x86/vm86.h b/include/asm-x86/vm86.h
index 998bd18..f930360 100644
--- a/include/asm-x86/vm86.h
+++ b/include/asm-x86/vm86.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__VM86_H
-#define ASM_X86__VM86_H
+#ifndef _ASM_X86_VM86_H
+#define _ASM_X86_VM86_H
 
 /*
  * I'm guessing at the VIF/VIP flag usage, but hope that this is how
@@ -205,4 +205,4 @@ static inline int handle_vm86_trap(struct kernel_vm86_regs *a, long b, int c)
 
 #endif /* __KERNEL__ */
 
-#endif /* ASM_X86__VM86_H */
+#endif /* _ASM_X86_VM86_H */
diff --git a/include/asm-x86/vmi_time.h b/include/asm-x86/vmi_time.h
index b2d39e6..c6e0bee 100644
--- a/include/asm-x86/vmi_time.h
+++ b/include/asm-x86/vmi_time.h
@@ -22,8 +22,8 @@
  *
  */
 
-#ifndef ASM_X86__VMI_TIME_H
-#define ASM_X86__VMI_TIME_H
+#ifndef _ASM_X86_VMI_TIME_H
+#define _ASM_X86_VMI_TIME_H
 
 /*
  * Raw VMI call indices for timer functions
@@ -95,4 +95,4 @@ extern void __devinit vmi_time_ap_init(void);
 
 #define CONFIG_VMI_ALARM_HZ	100
 
-#endif /* ASM_X86__VMI_TIME_H */
+#endif /* _ASM_X86_VMI_TIME_H */
diff --git a/include/asm-x86/vsyscall.h b/include/asm-x86/vsyscall.h
index dcd4682..d0983d2 100644
--- a/include/asm-x86/vsyscall.h
+++ b/include/asm-x86/vsyscall.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__VSYSCALL_H
-#define ASM_X86__VSYSCALL_H
+#ifndef _ASM_X86_VSYSCALL_H
+#define _ASM_X86_VSYSCALL_H
 
 enum vsyscall_num {
 	__NR_vgettimeofday,
@@ -41,4 +41,4 @@ extern void map_vsyscall(void);
 
 #endif /* __KERNEL__ */
 
-#endif /* ASM_X86__VSYSCALL_H */
+#endif /* _ASM_X86_VSYSCALL_H */
diff --git a/include/asm-x86/xen/events.h b/include/asm-x86/xen/events.h
index 8151f5b..ae3c9ad 100644
--- a/include/asm-x86/xen/events.h
+++ b/include/asm-x86/xen/events.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__XEN__EVENTS_H
-#define ASM_X86__XEN__EVENTS_H
+#ifndef _ASM_X86_XEN__EVENTS_H
+#define _ASM_X86_XEN__EVENTS_H
 
 enum ipi_vector {
 	XEN_RESCHEDULE_VECTOR,
@@ -21,4 +21,4 @@ static inline void xen_do_IRQ(int irq, struct pt_regs *regs)
 	do_IRQ(regs);
 }
 
-#endif /* ASM_X86__XEN__EVENTS_H */
+#endif /* _ASM_X86_XEN__EVENTS_H */
diff --git a/include/asm-x86/xen/grant_table.h b/include/asm-x86/xen/grant_table.h
index c4baab4..6d55da9 100644
--- a/include/asm-x86/xen/grant_table.h
+++ b/include/asm-x86/xen/grant_table.h
@@ -1,7 +1,7 @@
-#ifndef ASM_X86__XEN__GRANT_TABLE_H
-#define ASM_X86__XEN__GRANT_TABLE_H
+#ifndef _ASM_X86_XEN__GRANT_TABLE_H
+#define _ASM_X86_XEN__GRANT_TABLE_H
 
 #define xen_alloc_vm_area(size)	alloc_vm_area(size)
 #define xen_free_vm_area(area)	free_vm_area(area)
 
-#endif /* ASM_X86__XEN__GRANT_TABLE_H */
+#endif /* _ASM_X86_XEN__GRANT_TABLE_H */
diff --git a/include/asm-x86/xen/hypercall.h b/include/asm-x86/xen/hypercall.h
index 44f4259..7c1192a 100644
--- a/include/asm-x86/xen/hypercall.h
+++ b/include/asm-x86/xen/hypercall.h
@@ -30,8 +30,8 @@
  * IN THE SOFTWARE.
  */
 
-#ifndef ASM_X86__XEN__HYPERCALL_H
-#define ASM_X86__XEN__HYPERCALL_H
+#ifndef _ASM_X86_XEN__HYPERCALL_H
+#define _ASM_X86_XEN__HYPERCALL_H
 
 #include <linux/errno.h>
 #include <linux/string.h>
@@ -524,4 +524,4 @@ MULTI_stack_switch(struct multicall_entry *mcl,
 	mcl->args[1] = esp;
 }
 
-#endif /* ASM_X86__XEN__HYPERCALL_H */
+#endif /* _ASM_X86_XEN__HYPERCALL_H */
diff --git a/include/asm-x86/xen/hypervisor.h b/include/asm-x86/xen/hypervisor.h
index 445a247..ff60551 100644
--- a/include/asm-x86/xen/hypervisor.h
+++ b/include/asm-x86/xen/hypervisor.h
@@ -30,8 +30,8 @@
  * IN THE SOFTWARE.
  */
 
-#ifndef ASM_X86__XEN__HYPERVISOR_H
-#define ASM_X86__XEN__HYPERVISOR_H
+#ifndef _ASM_X86_XEN__HYPERVISOR_H
+#define _ASM_X86_XEN__HYPERVISOR_H
 
 #include <linux/types.h>
 #include <linux/kernel.h>
@@ -79,4 +79,4 @@ extern enum xen_domain_type xen_domain_type;
 #define xen_initial_domain()	(xen_pv_domain() && xen_start_info->flags & SIF_INITDOMAIN)
 #define xen_hvm_domain()	(xen_domain_type == XEN_HVM_DOMAIN)
 
-#endif /* ASM_X86__XEN__HYPERVISOR_H */
+#endif /* _ASM_X86_XEN__HYPERVISOR_H */
diff --git a/include/asm-x86/xen/interface.h b/include/asm-x86/xen/interface.h
index d077bba..6cfc896 100644
--- a/include/asm-x86/xen/interface.h
+++ b/include/asm-x86/xen/interface.h
@@ -6,8 +6,8 @@
  * Copyright (c) 2004, K A Fraser
  */
 
-#ifndef ASM_X86__XEN__INTERFACE_H
-#define ASM_X86__XEN__INTERFACE_H
+#ifndef _ASM_X86_XEN__INTERFACE_H
+#define _ASM_X86_XEN__INTERFACE_H
 
 #ifdef __XEN__
 #define __DEFINE_GUEST_HANDLE(name, type) \
@@ -172,4 +172,4 @@ DEFINE_GUEST_HANDLE_STRUCT(vcpu_guest_context);
 #define XEN_CPUID          XEN_EMULATE_PREFIX "cpuid"
 #endif
 
-#endif /* ASM_X86__XEN__INTERFACE_H */
+#endif /* _ASM_X86_XEN__INTERFACE_H */
diff --git a/include/asm-x86/xen/interface_32.h b/include/asm-x86/xen/interface_32.h
index 08167e1..a5377d4 100644
--- a/include/asm-x86/xen/interface_32.h
+++ b/include/asm-x86/xen/interface_32.h
@@ -6,8 +6,8 @@
  * Copyright (c) 2004, K A Fraser
  */
 
-#ifndef ASM_X86__XEN__INTERFACE_32_H
-#define ASM_X86__XEN__INTERFACE_32_H
+#ifndef _ASM_X86_XEN__INTERFACE_32_H
+#define _ASM_X86_XEN__INTERFACE_32_H
 
 
 /*
@@ -94,4 +94,4 @@ typedef struct xen_callback xen_callback_t;
 #define xen_pfn_to_cr3(pfn) (((unsigned)(pfn) << 12) | ((unsigned)(pfn) >> 20))
 #define xen_cr3_to_pfn(cr3) (((unsigned)(cr3) >> 12) | ((unsigned)(cr3) << 20))
 
-#endif /* ASM_X86__XEN__INTERFACE_32_H */
+#endif /* _ASM_X86_XEN__INTERFACE_32_H */
diff --git a/include/asm-x86/xen/interface_64.h b/include/asm-x86/xen/interface_64.h
index 046c0f1..21373e7 100644
--- a/include/asm-x86/xen/interface_64.h
+++ b/include/asm-x86/xen/interface_64.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__XEN__INTERFACE_64_H
-#define ASM_X86__XEN__INTERFACE_64_H
+#ifndef _ASM_X86_XEN__INTERFACE_64_H
+#define _ASM_X86_XEN__INTERFACE_64_H
 
 /*
  * 64-bit segment selectors
@@ -156,4 +156,4 @@ typedef unsigned long xen_callback_t;
 #endif /* !__ASSEMBLY__ */
 
 
-#endif /* ASM_X86__XEN__INTERFACE_64_H */
+#endif /* _ASM_X86_XEN__INTERFACE_64_H */
diff --git a/include/asm-x86/xen/page.h b/include/asm-x86/xen/page.h
index d5eada0..4f483e4 100644
--- a/include/asm-x86/xen/page.h
+++ b/include/asm-x86/xen/page.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__XEN__PAGE_H
-#define ASM_X86__XEN__PAGE_H
+#ifndef _ASM_X86_XEN__PAGE_H
+#define _ASM_X86_XEN__PAGE_H
 
 #include <linux/pfn.h>
 
@@ -162,4 +162,4 @@ xmaddr_t arbitrary_virt_to_machine(void *address);
 void make_lowmem_page_readonly(void *vaddr);
 void make_lowmem_page_readwrite(void *vaddr);
 
-#endif /* ASM_X86__XEN__PAGE_H */
+#endif /* _ASM_X86_XEN__PAGE_H */
diff --git a/include/asm-x86/xor_32.h b/include/asm-x86/xor_32.h
index 921b458..133b40a 100644
--- a/include/asm-x86/xor_32.h
+++ b/include/asm-x86/xor_32.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__XOR_32_H
-#define ASM_X86__XOR_32_H
+#ifndef _ASM_X86_XOR_32_H
+#define _ASM_X86_XOR_32_H
 
 /*
  * Optimized RAID-5 checksumming functions for MMX and SSE.
@@ -885,4 +885,4 @@ do {							\
 #define XOR_SELECT_TEMPLATE(FASTEST)			\
 	(cpu_has_xmm ? &xor_block_pIII_sse : FASTEST)
 
-#endif /* ASM_X86__XOR_32_H */
+#endif /* _ASM_X86_XOR_32_H */
diff --git a/include/asm-x86/xor_64.h b/include/asm-x86/xor_64.h
index 2d3a18d..1549b5e 100644
--- a/include/asm-x86/xor_64.h
+++ b/include/asm-x86/xor_64.h
@@ -1,5 +1,5 @@
-#ifndef ASM_X86__XOR_64_H
-#define ASM_X86__XOR_64_H
+#ifndef _ASM_X86_XOR_64_H
+#define _ASM_X86_XOR_64_H
 
 /*
  * Optimized RAID-5 checksumming functions for MMX and SSE.
@@ -358,4 +358,4 @@ do {						\
    deals with a load to a line that is being prefetched.  */
 #define XOR_SELECT_TEMPLATE(FASTEST) (&xor_block_sse)
 
-#endif /* ASM_X86__XOR_64_H */
+#endif /* _ASM_X86_XOR_64_H */

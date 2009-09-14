Return-Path: <linux-kernel-owner+w=401wt.eu-S1755893AbZINRzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbZINRzi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 13:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbZINRzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 13:55:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867AbZINRzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 13:55:31 -0400
Message-ID: <4AAE8371.6020300@redhat.com>
Date: Mon, 14 Sep 2009 20:54:57 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: kvm-devel <kvm@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: [GIT PULL][RESEND]KVM updates for 2.6.32-rc1
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

   git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/2.6.32

to receive the KVM updates for this cycle.  Changes include

- support for injecting MCEs into guests
- irqfd/ioeventfd, an eventfd-based mechanism to connect user- and 
kernel- based components to guests
- "unrestricted guests" on Intel, which improves real-mode support
- nested svm improvements
- event traces supplant the old KVM-private trace implementation
- syscall/sysenter emulation for cross-vendor migration
- 1GB pages on AMD
- x2apic, which improves SMP performance

as well as the usual fixes and performance and scaling improvements.

Note that Marcelo is joining me as co-maintainer, so you may get KVM 
updates from him in the future.

Shortlog/diffstat:

Akinobu Mita (2):
       KVM: x86: use get_desc_base() and get_desc_limit()
       KVM: x86: use kvm_get_gdt() and kvm_read_ldt()

Alexander Graf (4):
       x86: Add definition for IGNNE MSR
       KVM: Implement MSRs used by Hyper-V
       KVM: SVM: Implement INVLPGA
       KVM: SVM: Improve nested interrupt injection

Amit Shah (2):
       KVM: ignore reads to perfctr msrs
       Documentation: Update KVM list email address

Andre Przywara (15):
       KVM: SVM: use explicit 64bit storage for sysenter values
       KVM: Move performance counter MSR access interception to generic 
x86 path
       KVM: Allow emulation of syscalls instructions on #UD
       KVM: x86 emulator: Add missing EFLAGS bit definitions
       KVM: x86 emulator: Prepare for emulation of syscall instructions
       KVM: x86 emulator: add syscall emulation
       KVM: x86 emulator: Add sysenter emulation
       KVM: x86 emulator: Add sysexit emulation
       KVM: ignore AMDs HWCR register access to set the FFDIS bit
       KVM: ignore reads from AMDs C1E enabled MSR
       KVM: introduce module parameter for ignoring unknown MSRs accesses
       KVM: Ignore PCI ECS I/O enablement
       KVM: handle AMD microcode MSR
       KVM: fix MMIO_CONF_BASE MSR access
       KVM: add module parameters documentation

Anthony Liguori (1):
       KVM: When switching to a vm8086 task, load segments as 16-bit

Avi Kivity (37):
       KVM: x86 emulator: Implement zero-extended immediate decoding
       KVM: x86 emulator: fix jmp far decoding (opcode 0xea)
       KVM: Move common KVM Kconfig items to new file virt/kvm/Kconfig
       KVM: SVM: Fold kvm_svm.h info svm.c
       KVM: VMX: Avoid duplicate ept tlb flush when setting cr3
       KVM: VMX: Simplify pdptr and cr3 management
       KVM: Cache pdptrs
       KVM: VMX: Fix reporting of unhandled EPT violations
       KVM: Calculate available entries in coalesced mmio ring
       KVM: Reorder ioctls in kvm.h
       KVM: VMX: Move rmode structure to vmx-specific code
       KVM: MMU: Fix is_dirty_pte()
       KVM: MMU: Adjust pte accessors to explicitly indicate guest or 
shadow pte
       KVM: MMU: s/shadow_pte/spte/
       KVM: Return to userspace on emulation failure
       KVM: VMX: Only reload guest cr2 if different from host cr2
       KVM: SVM: Don't save/restore host cr2
       KVM: Trace irq level and source id
       KVM: Trace mmio
       KVM: Trace apic registers using their symbolic names
       KVM: MMU: Trace guest pagetable walker
       KVM: Document basic API
       KVM: Trace shadow page lifecycle
       KVM: VMX: Optimize vmx_get_cpl()
       x86: Export kmap_atomic_to_page()
       KVM: SVM: Drop tlb flush workaround in npt
       KVM: Move #endif KVM_CAP_IRQ_ROUTING to correct place
       KVM: VMX: Adjust rflags if in real mode emulation
       KVM: Rename x86_emulate.c to emulate.c
       KVM: Add __KERNEL__ guards to exported headers
       KVM: Add missing #include
       KVM: Protect update_cr8_intercept() when running without an apic
       KVM: Document KVM_CAP_IRQCHIP
       KVM: Optimize kvm_mmu_unprotect_page_virt() for tdp
       KVM: Use thread debug register storage instead of kvm specific data
       KVM: VMX: Conditionally reload debug register 6
       KVM: VMX: Check cpl before emulating debug register access

Bartlomiej Zolnierkiewicz (1):
       KVM: remove superfluous NULL pointer check in 
kvm_inject_pit_timer_irqs()

Beth Kon (1):
       KVM: PIT support for HPET legacy mode

Christian Borntraeger (1):
       KVM: s390: Fix memslot initialization for userspace_addr != 0

Christian Ehrhardt (4):
       KVM: s390: infrastructure to kick vcpus out of guest state
       KVM: s390: fix signal handling
       KVM: s390: streamline memslot handling
       KVM: remove redundant declarations

Christoph Hellwig (1):
       KVM: cleanup arch/x86/kvm/Makefile

Glauber Costa (1):
       KVM guest: fix bogus wallclock physical address calculation

Gleb Natapov (28):
       KVM: VMX: Properly handle software interrupt re-injection in real 
mode
       KVM: Drop interrupt shadow when single stepping should be done 
only on VMX
       KVM: Introduce kvm_vcpu_is_bsp() function.
       KVM: Use pointer to vcpu instead of vcpu_id in timer code.
       KVM: Break dependency between vcpu index in vcpus array and vcpu_id.
       KVM: Use macro to iterate over vcpus.
       KVM: Replace pending exception by PF if it happens serially
       KVM: Optimize searching for highest IRR
       KVM: Add Directed EOI support to APIC emulation
       KVM: x2apic interface to lapic
       KVM: Use temporary variable to shorten lines.
       KVM: Add trace points in irqchip code
       KVM: No need to kick cpu if not in a guest mode
       KVM: Always report x2apic as supported feature
       KVM: Move exception handling to the same place as other events
       KVM: Move kvm_cpu_get_interrupt() declaration to x86 code
       KVM: Reduce runnability interface with arch support code
       KVM: silence lapic kernel messages that can be triggered by a guest
       KVM: s390: remove unused structs
       KVM: PIT: Unregister ack notifier callback when freeing
       KVM: Call kvm_vcpu_kick() inside pic spinlock
       KVM: Call ack notifiers from PIC when guest OS acks an IRQ.
       KVM: Replace pic_lock()/pic_unlock() with direct call to spinlock 
functions
       KVM: Update cr8 intercept when APIC TPR is changed by userspace
       KVM: VMX: Fix cr8 exiting control clobbering by EPT
       KVM: Fix coalesced interrupt reporting in IOAPIC
       KVM: VMX: call vmx_load_host_state() only if msr is cached
       KVM: fix misreporting of coalesced interrupts by kvm tracer

Gregory Haskins (6):
       KVM: irqfd
       KVM: Clean up coalesced_mmio destruction
       KVM: cleanup io_device code
       KVM: do not register i8254 PIO regions until we are initialized
       KVM: make io_bus interface more robust
       KVM: add ioeventfd support

Heiko Carstens (1):
       KVM: fix compile warnings on s390

Huang Ying (1):
       KVM: Add MCE support

Izik Eidus (1):
       KVM: MMU: make __kvm_mmu_free_some_pages handle empty list

Jan Kiszka (8):
       KVM: Allow PIT emulation without speaker port
       KVM: Cleanup LAPIC interface
       KVM: Fix racy event propagation in timer
       KVM: Drop useless atomic test from timer function
       Revert "KVM: x86: check for cr3 validity in ioctl_set_sregs"
       KVM: Drop obsolete cpu_get/put in make_all_cpus_request
       KVM: VMX: Avoid to return ENOTSUPP to userland
       KVM: x86: Disallow hypercalls for guest callers in rings > 0

Jaswinder Singh Rajput (2):
       KVM: Replace MSR_IA32_TIME_STAMP_COUNTER with MSR_IA32_TSC of 
msr-index.h
       KVM: Use MSR names in place of address

Jes Sorensen (1):
       KVM: ia64: Correct itc_offset calculations

Jiri Slaby (1):
       KVM: fix lock imbalance

Joerg Roedel (31):
       hugetlbfs: export vma_kernel_pagsize to modules
       KVM: Prepare memslot data structures for multiple hugepage sizes
       KVM: MMU: Fix MMU_DEBUG compile breakage
       KVM: MMU: make rmap code aware of mapping levels
       KVM: MMU: rename is_largepage_backed to mapping_level
       KVM: MMU: make direct mapping paths aware of mapping levels
       KVM: MMU: make page walker aware of mapping levels
       KVM: MMU: shadow support for 1gb pages
       KVM: MMU: enable gbpages by increasing nr of pagesizes
       KVM: report 1GB page support to userspace
       KVM: SVM: add helper functions for global interrupt flag
       KVM: SVM: optimize nested #vmexit
       KVM: SVM: optimize nested vmrun
       KVM: SVM: copy only necessary parts of the control area on 
vmrun/vmexit
       KVM: SVM: complete interrupts after handling nested exits
       KVM: SVM: move nested svm state into seperate struct
       KVM: SVM: cache nested intercepts
       KVM: SVM: consolidate nested_svm_exit_handled
       KVM: SVM: do nested vmexit in nested_svm_exit_handled
       KVM: SVM: simplify nested_svm_check_exception
       KVM: SVM: get rid of nested_svm_vmexit_real
       KVM: SVM: clean up nested_svm_exit_handled_msr
       KVM: SVM: clean up nestec vmload/vmsave paths
       KVM: SVM: clean up nested vmrun path
       KVM: SVM: remove nested_svm_do and helper functions
       KVM: SVM: handle errors in vmrun emulation path appropriatly
       KVM: SVM: move special nested exit handling to separate function
       KVM: SVM: remove unnecessary is_nested check from svm_cpu_run
       KVM: SVM: move nested_svm_intr main logic out of if-clause
       KVM: SVM: check for nested VINTR flag in svm_interrupt_allowed
       KVM: SVM: enable nested svm by default

Julia Lawall (1):
       KVM: correct error-handling code

Liu Yu (3):
       KVM: ppc: e500: Move to Book-3e MMU definitions
       KVM: ppc: e500: Directly pass pvr to guest
       KVM: ppc: e500: Add MMUCFG and PVR emulation

Marcelo Tosatti (26):
       KVM: Grab pic lock in kvm_pic_clear_isr_ack
       KVM: move coalesced_mmio locking to its own device
       KVM: introduce irq_lock, use it to protect ioapic
       KVM: switch irq injection/acking data structures to irq_lock
       KVM: MMU: introduce is_last_spte helper
       KVM: MMU audit: update count_writable_mappings / count_rmaps
       KVM: MMU audit: update audit_write_protection
       KVM: MMU audit: nontrapping ptes in nonleaf level
       KVM: MMU audit: audit_mappings tweaks
       KVM: MMU audit: largepage handling
       KVM: VMX: more MSR_IA32_VMX_EPT_VPID_CAP capability bits
       KVM: MMU: make for_each_shadow_entry aware of largepages
       KVM: MMU: add kvm_mmu_get_spte_hierarchy helper
       KVM: VMX: EPT misconfiguration handler
       KVM: VMX: conditionally disable 2M pages
       KVM: convert custom marker based tracing to event traces
       KVM: x86: missing locking in PIT/IRQCHIP/SET_BSP_CPU ioctl paths
       KVM: powerpc: convert marker probes to event trace
       KVM: remove old KVMTRACE support code
       KVM: use vcpu_id instead of bsp_vcpu pointer in kvm_vcpu_is_bsp
       KVM: MMU: fix missing locking in alloc_mmu_pages
       KVM: limit lapic periodic timer frequency
       KVM: MMU: fix bogus alloc_mmu_pages assignment
       KVM guest: do not batch pte updates from interrupt context
       KVM: x86: drop duplicate kvm_flush_remote_tlb calls
       MAINTAINERS: update KVM entry

Mark McLoughlin (1):
       KVM: fix cpuid E2BIG handling for extended request types

Michael S. Tsirkin (8):
       KVM: document locking for kvm_io_device_ops
       KVM: switch coalesced mmio changes to slots_lock
       KVM: switch pit creation to slots_lock
       KVM: convert bus to slots_lock
       KVM: remove in_range from io devices
       KVM: document lock nesting rule
       KVM: ignore msi request if !level
       KVM: export kvm_para.h

Mikhail Ershov (2):
       KVM: Align cr8 threshold when userspace changes cr8
       KVM: Use kvm_{read,write}_guest_virt() to read and write segment 
descriptors

Mohammed Gamal (1):
       KVM: x86 emulator: Add adc and sbb missing decoder flags

Nitin A Kamble (1):
       KVM: VMX: Support Unrestricted Guest feature

Roel Kluin (1):
       KVM: fix EFER read buffer overflow

Sheng Yang (6):
       KVM: Downsize max support MSI-X entry to 256
       KVM: No disable_irq for MSI/MSI-X interrupt on device assignment
       KVM: Fix apic_mmio_write return for unaligned write
       KVM: Discard unnecessary kvm_mmu_flush_tlb() in kvm_mmu_load()
       KVM: VMX: Introduce KVM_SET_IDENTITY_MAP_ADDR ioctl
       KVM: VMX: Fix EPT with WP bit change during paging

Stephen Rothwell (1):
       KVM: powerpc: fix some init/exit annotations

Xiao Guangrong (1):
       KVM: fix kvm_init() error handling

  Documentation/ioctl/ioctl-number.txt               |    2 +-
  Documentation/kernel-parameters.txt                |   39 +
  Documentation/kvm/api.txt                          |  759 
+++++++++++++++++
  MAINTAINERS                                        |    1 +
  arch/ia64/include/asm/kvm_host.h                   |    4 +-
  arch/ia64/include/asm/kvm_para.h                   |    4 +
  arch/ia64/kvm/Kconfig                              |   11 +-
  arch/ia64/kvm/kvm-ia64.c                           |   85 +--
  arch/ia64/kvm/vcpu.c                               |    4 +-
  arch/powerpc/include/asm/kvm_host.h                |    4 +-
  arch/powerpc/kvm/44x.c                             |    4 +-
  arch/powerpc/kvm/44x_tlb.c                         |   11 +-
  arch/powerpc/kvm/Kconfig                           |   14 +-
  arch/powerpc/kvm/Makefile                          |    4 +-
  arch/powerpc/kvm/booke.c                           |    2 +-
  arch/powerpc/kvm/e500.c                            |    7 +-
  arch/powerpc/kvm/e500_emulate.c                    |    3 +
  arch/powerpc/kvm/e500_tlb.c                        |   26 +-
  arch/powerpc/kvm/e500_tlb.h                        |    6 +-
  arch/powerpc/kvm/emulate.c                         |    7 +-
  arch/powerpc/kvm/powerpc.c                         |   32 +-
  arch/powerpc/kvm/trace.h                           |  104 +++
  arch/s390/include/asm/kvm.h                        |    9 -
  arch/s390/include/asm/kvm_host.h                   |   15 +-
  arch/s390/include/asm/kvm_para.h                   |    4 +
  arch/s390/kvm/Kconfig                              |    9 +-
  arch/s390/kvm/gaccess.h                            |   23 +-
  arch/s390/kvm/intercept.c                          |   18 +-
  arch/s390/kvm/interrupt.c                          |    8 +-
  arch/s390/kvm/kvm-s390.c                           |   78 +-
  arch/s390/kvm/kvm-s390.h                           |   32 +-
  arch/s390/kvm/sigp.c                               |   60 +-
  arch/x86/include/asm/apicdef.h                     |    2 +
  arch/x86/include/asm/kvm.h                         |   10 +
  .../asm/{kvm_x86_emulate.h => kvm_emulate.h}       |    0
  arch/x86/include/asm/kvm_host.h                    |   60 +-
  arch/x86/include/asm/kvm_para.h                    |    2 +
  arch/x86/include/asm/msr-index.h                   |    1 +
  arch/x86/include/asm/vmx.h                         |    8 +
  arch/x86/kernel/kvm.c                              |    7 +-
  arch/x86/kernel/kvmclock.c                         |    4 +-
  arch/x86/kvm/Kconfig                               |   21 +-
  arch/x86/kvm/Makefile                              |   35 +-
  arch/x86/kvm/{x86_emulate.c => emulate.c}          |  265 ++++++-
  arch/x86/kvm/i8254.c                               |  160 +++--
  arch/x86/kvm/i8254.h                               |    5 +-
  arch/x86/kvm/i8259.c                               |  116 ++--
  arch/x86/kvm/irq.h                                 |    1 -
  arch/x86/kvm/kvm_cache_regs.h                      |    9 +
  arch/x86/kvm/kvm_svm.h                             |   51 --
  arch/x86/kvm/kvm_timer.h                           |    2 +-
  arch/x86/kvm/lapic.c                               |  334 ++++++--
  arch/x86/kvm/lapic.h                               |    4 +
  arch/x86/kvm/mmu.c                                 |  587 +++++++++-----
  arch/x86/kvm/mmu.h                                 |    4 +-
  arch/x86/kvm/mmutrace.h                            |  220 +++++
  arch/x86/kvm/paging_tmpl.h                         |  141 ++--
  arch/x86/kvm/svm.c                                 |  889 
++++++++++++--------
  arch/x86/kvm/timer.c                               |   16 +-
  arch/x86/kvm/trace.h                               |  355 ++++++++
  arch/x86/kvm/vmx.c                                 |  497 ++++++++---
  arch/x86/kvm/x86.c                                 |  815 
+++++++++++++------
  arch/x86/kvm/x86.h                                 |    4 +
  arch/x86/mm/highmem_32.c                           |    1 +
  include/asm-generic/Kbuild.asm                     |    5 +
  include/linux/Kbuild                               |    4 +
  include/linux/kvm.h                                |  127 ++-
  include/linux/kvm_host.h                           |  114 ++-
  include/linux/kvm_para.h                           |    1 +
  include/trace/events/kvm.h                         |  151 ++++
  mm/hugetlb.c                                       |    1 +
  virt/kvm/Kconfig                                   |   14 +
  virt/kvm/coalesced_mmio.c                          |   74 +-
  virt/kvm/coalesced_mmio.h                          |    1 +
  virt/kvm/eventfd.c                                 |  578 +++++++++++++
  virt/kvm/ioapic.c                                  |   78 ++-
  virt/kvm/iodev.h                                   |   55 +-
  virt/kvm/irq_comm.c                                |   51 +-
  virt/kvm/kvm_main.c                                |  298 +++++--
  virt/kvm/kvm_trace.c                               |  285 -------
  80 files changed, 5692 insertions(+), 2160 deletions(-)
  create mode 100644 Documentation/kvm/api.txt
  create mode 100644 arch/powerpc/kvm/trace.h
  rename arch/x86/include/asm/{kvm_x86_emulate.h => kvm_emulate.h} (100%)
  rename arch/x86/kvm/{x86_emulate.c => emulate.c} (90%)
  delete mode 100644 arch/x86/kvm/kvm_svm.h
  create mode 100644 arch/x86/kvm/mmutrace.h
  create mode 100644 arch/x86/kvm/trace.h
  create mode 100644 include/trace/events/kvm.h
  create mode 100644 virt/kvm/Kconfig
  create mode 100644 virt/kvm/eventfd.c
  delete mode 100644 virt/kvm/kvm_trace.c

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.


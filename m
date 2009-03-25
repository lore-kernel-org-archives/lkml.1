Return-Path: <linux-kernel-owner+w=401wt.eu-S1755781AbZCYIqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781AbZCYIqy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 04:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbZCYIqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 04:46:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37346 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945AbZCYIqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 04:46:39 -0400
From: Avi Kivity <avi@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] KVM updates for the 2.6.30 merge window
Date: Wed, 25 Mar 2009 10:45:35 +0200
Message-Id: <1237970735-5838-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from repo+branch at

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/2.6.30

to receive the 2.6.30 KVM batch.  Changes include nested virtualization on
AMD hosts, ppc e500 support, improved guest debugging support, better
performance and improved emulation accuracy.

Shortlog and diffstat follow.

Alexander Graf (13):
      KVM: SVM: Clean up VINTR setting
      KVM: SVM: Move EFER and MSR constants to generic x86 code
      KVM: SVM: Add helper functions for nested SVM
      KVM: SVM: Implement GIF, clgi and stgi
      KVM: SVM: Implement hsave
      KVM: SVM: Add VMLOAD and VMSAVE handlers
      KVM: SVM: Add VMRUN handler
      KVM: SVM: Add VMEXIT handler and intercepts
      KVM: SVM: Allow setting the SVME bit
      KVM: SVM: Only allow setting of EFER_SVME when CPUID SVM is set
      KVM: SVM: Add microcode patch level dummy
      x86: Add EFER descriptions for FFXSR
      KVM: Add FFXSR support

Amit Shah (3):
      KVM: x86: Fix typos and whitespace errors
      KVM: VMX: Update necessary state when guest enters long mode
      KVM: is_long_mode() should check for EFER.LMA

Andre Przywara (1):
      KVM: SVM: set accessed bit for VMCB segment selectors

Andrea Arcangeli (1):
      KVM: Fix missing smp tlb flush in invlpg

Avi Kivity (27):
      KVM: MMU: Inherit a shadow page's guest level count from vcpu setup
      KVM: MMU: Segregate mmu pages created with different cr4.pge settings
      KVM: MMU: Initialize a shadow page's global attribute from cr4.pge
      KVM: Fix vmload and friends misinterpreted as lidt
      KVM: MMU: Add for_each_shadow_entry(), a simpler alternative to walk_shadow()
      KVM: MMU: Use for_each_shadow_entry() in __direct_map()
      KVM: MMU: Replace walk_shadow() by for_each_shadow_entry() in fetch()
      KVM: MMU: Replace walk_shadow() by for_each_shadow_entry() in invlpg()
      KVM: MMU: Drop walk_shadow()
      KVM: Fallback support for MSR_VM_HSAVE_PA
      KVM: Move struct kvm_pio_request into x86 kvm_host.h
      KVM: VMX: Fix guest state validity checks
      KVM: VMX: don't clobber segment AR if emulating invalid state
      KVM: VMX: Prevent exit handler from running if emulating due to invalid state
      KVM: x86 emulator: Make emulate_pop() a little more generic
      KVM: VMX: When emulating on invalid vmx state, don't return to userspace unnecessarily
      KVM: x86 emulator: implement 'ret far' instruction (opcode 0xcb)
      KVM: Properly lock PIT creation
      KVM: MMU: Optimize page unshadowing
      KVM: Add CONFIG_HAVE_KVM_IRQCHIP
      KVM: Interrupt mask notifiers for ioapic
      KVM: Reset PIT irq injection logic when the PIT IRQ is unmasked
      KVM: MMU: Rename "metaphysical" attribute to "direct"
      KVM: MMU: Only enable cr4_pge role in shadow mode
      KVM: Userspace controlled irq routing
      KVM: Avoid using CONFIG_ in userspace visible headers
      KVM: VMX: Don't allow uninhibited access to EFER on i386

Christian Borntraeger (3):
      KVM: s390: Fix printk on SIGP set arch
      KVM: s390: Fix problem state check for b2 intercepts
      KVM: s390: Fix SIGP set prefix ioctl

Gerd Hoffmann (1):
      KVM: Fix kvmclock on !constant_tsc boxes

Gleb Natapov (2):
      KVM: Report IRQ injection status to userspace.
      KVM: Report IRQ injection status for MSI delivered interrupts

Hannes Eder (2):
      KVM: fix sparse warnings: context imbalance
      KVM: fix sparse warnings: Should it be static?

Hollis Blanchard (17):
      KVM: ppc: move struct kvmppc_44x_tlbe into 44x-specific header
      KVM: ppc: cosmetic changes to mmu hook names
      KVM: ppc: small cosmetic changes to Book E DTLB miss handler
      KVM: ppc: change kvmppc_mmu_map() parameters
      KVM: ppc: turn tlb_xlate() into a per-core hook (and give it a better name)
      KVM: ppc: rename 44x MMU functions used in booke.c
      KVM: ppc: remove last 44x-specific bits from booke.c
      KVM: ppc: use macros instead of hardcoded literals for instruction decoding
      KVM: ppc: split out common Book E instruction emulation
      KVM: ppc: Add dbsr in kvm_vcpu_arch
      KVM: ppc: No need to include core-header for KVM in asm-offsets.c currently
      KVM: ppc: ifdef iccci with CONFIG_44x
      KVM: ppc: E500 core-specific code
      KVM: ppc: Add kvmppc_mmu_dtlb/itlb_miss for booke
      KVM: ppc: distinguish between interrupts and priorities
      KVM: ppc: Add extra E500 exceptions
      KVM: ppc: remove debug support broken by KVM debug rewrite

Izik Eidus (2):
      KVM: introduce kvm_read_guest_virt, kvm_write_guest_virt
      KVM: remove the vmap usage

Jan Kiszka (8):
      KVM: VMX: Support for injecting software exceptions
      KVM: New guest debug interface
      KVM: VMX: Allow single-stepping when uninterruptible
      KVM: x86: Virtualize debug registers
      KVM: x86: Wire-up hardware breakpoints for guest debugging
      KVM: Remove old kvm_guest_debug structs
      KVM: Advertise guest debug capability per-arch
      KVM: Drop unused evaluations from string pio handlers

Jes Sorensen (3):
      KVM: ia64: stack get/restore patch
      KVM: ia64: expose registers in struct kvm_regs
      KVM: ia64: dynamic nr online cpus

Joe Perches (1):
      KVM: SVM: Fix typo in has_svm()

Joerg Roedel (5):
      KVM: SVM: Allow read access to MSR_VM_VR
      KVM: MMU: handle compound pages in kvm_is_mmio_pfn
      KVM: MMU: remove redundant check in mmu_set_spte
      KVM: MMU: remove assertion in kvm_mmu_alloc_page
      KVM: MMU: Fix another largepage memory leak

Liu Yu (6):
      powerpc/fsl-booke: declare tlbcam_index for use in c
      KVM: ppc: Fix e500 warnings and some spelling problems
      KVM: ppc: Move to new TLB invalidate interface
      KVM: ppc: Add emulation of E500 register mmucsr0
      KVM: ppc: e500: Fix the bug that mas0 update to wrong value when read TLB entry
      KVM: ppc: e500: Fix the bug that KVM is unstable in SMP

Marcelo Tosatti (4):
      KVM: VMX: initialize TSC offset relative to vm creation time
      KVM: PIT: provide an option to disable interrupt reinjection
      KVM: MMU: drop zeroing on mmu_memory_cache_alloc
      KVM: make irq ack notifications aware of routing table

Sheng Yang (6):
      KVM: Remove duplicated prototype of kvm_arch_destroy_vm
      KVM: Add support to disable MSI for assigned device
      KVM: Use irq routing API for MSI
      KVM: VMX: Use kvm_mmu_page_fault() handle EPT violation mmio
      KVM: Get support IRQ routing entry counts
      KVM: Correct deassign device ioctl to IOW

Weidong Han (2):
      KVM: define KVM_CAP_DEVICE_DEASSIGNMENT
      KVM: fix kvm_vm_ioctl_deassign_device

Xiantao Zhang (6):
      KVM: ia64: Code cleanup
      KVM: ia64: vTLB change for enabling windows 2008 boot
      KVM: ia64: Add the support for translating PAL Call's pointer args
      KVM: ia64: Implement some pal calls needed for windows 2008
      ia64: Move the macro definitions related to MSI to one header file.
      KVM: ia64: Fix the build errors due to lack of macros related to MSI.

 arch/ia64/include/asm/kvm.h              |   49 ++-
 arch/ia64/include/asm/kvm_host.h         |   18 +-
 arch/ia64/include/asm/msidef.h           |   42 ++
 arch/ia64/kernel/msi_ia64.c              |   55 +--
 arch/ia64/kvm/Kconfig                    |    4 +
 arch/ia64/kvm/irq.h                      |    2 +
 arch/ia64/kvm/kvm-ia64.c                 |  125 ++++-
 arch/ia64/kvm/kvm_fw.c                   |  151 +++++-
 arch/ia64/kvm/process.c                  |   71 ++-
 arch/ia64/kvm/vcpu.c                     |   44 +--
 arch/ia64/kvm/vcpu.h                     |    4 +-
 arch/ia64/kvm/vtlb.c                     |   44 +-
 arch/powerpc/include/asm/kvm.h           |    7 +
 arch/powerpc/include/asm/kvm_44x.h       |    7 +
 arch/powerpc/include/asm/kvm_asm.h       |    7 +-
 arch/powerpc/include/asm/kvm_e500.h      |   67 +++
 arch/powerpc/include/asm/kvm_host.h      |   21 +-
 arch/powerpc/include/asm/kvm_ppc.h       |   15 +-
 arch/powerpc/include/asm/mmu-fsl-booke.h |    2 +
 arch/powerpc/kernel/asm-offsets.c        |    4 +-
 arch/powerpc/kvm/44x.c                   |   72 +---
 arch/powerpc/kvm/44x_emulate.c           |  217 +-------
 arch/powerpc/kvm/44x_tlb.c               |   39 +-
 arch/powerpc/kvm/44x_tlb.h               |    9 -
 arch/powerpc/kvm/Kconfig                 |   16 +
 arch/powerpc/kvm/Makefile                |   10 +
 arch/powerpc/kvm/booke.c                 |   50 +-
 arch/powerpc/kvm/booke.h                 |   35 +-
 arch/powerpc/kvm/booke_emulate.c         |  266 +++++++++
 arch/powerpc/kvm/booke_interrupts.S      |    5 +
 arch/powerpc/kvm/e500.c                  |  169 ++++++
 arch/powerpc/kvm/e500_emulate.c          |  202 +++++++
 arch/powerpc/kvm/e500_tlb.c              |  757 ++++++++++++++++++++++++
 arch/powerpc/kvm/e500_tlb.h              |  185 ++++++
 arch/powerpc/kvm/emulate.c               |   93 ++-
 arch/powerpc/kvm/powerpc.c               |   31 +-
 arch/s390/include/asm/kvm.h              |    7 +
 arch/s390/include/asm/kvm_host.h         |    3 -
 arch/s390/kvm/Kconfig                    |    3 +
 arch/s390/kvm/intercept.c                |    2 +-
 arch/s390/kvm/interrupt.c                |    7 +-
 arch/s390/kvm/kvm-s390.c                 |    4 +-
 arch/s390/kvm/kvm-s390.h                 |    2 +-
 arch/s390/kvm/priv.c                     |   18 +-
 arch/s390/kvm/sigp.c                     |    2 -
 arch/x86/include/asm/kvm.h               |   24 +
 arch/x86/include/asm/kvm_host.h          |   61 ++-
 arch/x86/include/asm/msr-index.h         |    9 +
 arch/x86/include/asm/svm.h               |    4 -
 arch/x86/include/asm/virtext.h           |    2 +-
 arch/x86/include/asm/vmx.h               |    5 +-
 arch/x86/kvm/Kconfig                     |    4 +
 arch/x86/kvm/i8254.c                     |   21 +-
 arch/x86/kvm/i8254.h                     |    2 +
 arch/x86/kvm/i8259.c                     |   25 +-
 arch/x86/kvm/irq.h                       |    2 +
 arch/x86/kvm/kvm_svm.h                   |   16 +-
 arch/x86/kvm/mmu.c                       |  237 ++++----
 arch/x86/kvm/mmu.h                       |    2 +-
 arch/x86/kvm/paging_tmpl.h               |  219 ++++----
 arch/x86/kvm/svm.c                       |  916 ++++++++++++++++++++++++++----
 arch/x86/kvm/vmx.c                       |  393 ++++++++------
 arch/x86/kvm/x86.c                       |  432 +++++++++++----
 arch/x86/kvm/x86_emulate.c               |   56 ++-
 include/linux/kvm.h                      |  115 ++++-
 include/linux/kvm_host.h                 |   62 ++-
 include/linux/kvm_types.h                |   13 -
 virt/kvm/ioapic.c                        |   39 +-
 virt/kvm/ioapic.h                        |    2 +-
 virt/kvm/irq_comm.c                      |  297 +++++++++-
 virt/kvm/kvm_main.c                      |  141 +++---
 71 files changed, 4640 insertions(+), 1402 deletions(-)
 create mode 100644 arch/ia64/include/asm/msidef.h
 create mode 100644 arch/powerpc/include/asm/kvm_e500.h
 create mode 100644 arch/powerpc/kvm/booke_emulate.c
 create mode 100644 arch/powerpc/kvm/e500.c
 create mode 100644 arch/powerpc/kvm/e500_emulate.c
 create mode 100644 arch/powerpc/kvm/e500_tlb.c
 create mode 100644 arch/powerpc/kvm/e500_tlb.h

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757999AbZB0K2K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999AbZB0K2K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:28:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756002AbZB0K1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:27:11 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53558 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755181AbZB0K1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:27:08 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/37] KVM Updates for the 2.6.30 merge window (2/3)
Date: Fri, 27 Feb 2009 12:26:23 +0200
Message-Id: <1235730420-7929-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Second batch of three containing the KVM updates for the next merge window.

Alexander Graf (1):
  KVM: SVM: Add microcode patch level dummy

Amit Shah (1):
  KVM: x86: Fix typos and whitespace errors

Avi Kivity (15):
  KVM: VMX: Fix guest state validity checks
  KVM: VMX: don't clobber segment AR if emulating invalid state
  KVM: VMX: Prevent exit handler from running if emulating due to
    invalid state
  KVM: x86 emulator: Make emulate_pop() a little more generic
  KVM: VMX: When emulating on invalid vmx state, don't return to
    userspace unnecessarily
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

Hollis Blanchard (12):
  KVM: ppc: rename 44x MMU functions used in booke.c
  KVM: ppc: remove last 44x-specific bits from booke.c
  KVM: ppc: use macros instead of hardcoded literals for instruction
    decoding
  KVM: ppc: split out common Book E instruction emulation
  KVM: ppc: Add dbsr in kvm_vcpu_arch
  KVM: ppc: No need to include core-header for KVM in asm-offsets.c
    currently
  KVM: ppc: ifdef iccci with CONFIG_44x
  KVM: ppc: E500 core-specific code
  KVM: ppc: Add kvmppc_mmu_dtlb/itlb_miss for booke
  KVM: ppc: distinguish between interrupts and priorities
  KVM: ppc: Add extra E500 exceptions
  KVM: ppc: remove debug support broken by KVM debug rewrite

Jes Sorensen (1):
  KVM: ia64: expose registers in struct kvm_regs

Joe Perches (1):
  KVM: SVM: Fix typo in has_svm()

Liu Yu (3):
  powerpc/fsl-booke: declare tlbcam_index for use in c
  KVM: ppc: Fix e500 warnings and some spelling problems
  KVM: ppc: Move to new TLB invalidate interface

Marcelo Tosatti (1):
  KVM: MMU: drop zeroing on mmu_memory_cache_alloc

Sheng Yang (2):
  KVM: Remove duplicated prototype of kvm_arch_destroy_vm
  KVM: Add support to disable MSI for assigned device

 arch/ia64/include/asm/kvm.h              |   35 ++-
 arch/ia64/kvm/Kconfig                    |    4 +
 arch/ia64/kvm/kvm-ia64.c                 |    5 +
 arch/powerpc/include/asm/kvm_asm.h       |    7 +-
 arch/powerpc/include/asm/kvm_e500.h      |   67 +++
 arch/powerpc/include/asm/kvm_host.h      |    8 +-
 arch/powerpc/include/asm/kvm_ppc.h       |    7 +-
 arch/powerpc/include/asm/mmu-fsl-booke.h |    2 +
 arch/powerpc/kernel/asm-offsets.c        |    4 +-
 arch/powerpc/kvm/44x.c                   |   66 ---
 arch/powerpc/kvm/44x_emulate.c           |  217 +--------
 arch/powerpc/kvm/44x_tlb.c               |   12 +-
 arch/powerpc/kvm/44x_tlb.h               |    2 -
 arch/powerpc/kvm/Kconfig                 |   16 +
 arch/powerpc/kvm/Makefile                |   10 +
 arch/powerpc/kvm/booke.c                 |   30 +-
 arch/powerpc/kvm/booke.h                 |   35 +-
 arch/powerpc/kvm/booke_emulate.c         |  266 +++++++++++
 arch/powerpc/kvm/booke_interrupts.S      |    5 +
 arch/powerpc/kvm/e500.c                  |  169 +++++++
 arch/powerpc/kvm/e500_emulate.c          |  194 ++++++++
 arch/powerpc/kvm/e500_tlb.c              |  737 ++++++++++++++++++++++++++++++
 arch/powerpc/kvm/e500_tlb.h              |  184 ++++++++
 arch/powerpc/kvm/emulate.c               |   93 +++--
 arch/powerpc/kvm/powerpc.c               |   27 +-
 arch/s390/kvm/Kconfig                    |    3 +
 arch/x86/include/asm/kvm.h               |    1 +
 arch/x86/include/asm/kvm_host.h          |    5 +-
 arch/x86/kvm/Kconfig                     |    4 +
 arch/x86/kvm/i8254.c                     |   17 +-
 arch/x86/kvm/i8254.h                     |    1 +
 arch/x86/kvm/mmu.c                       |   46 ++-
 arch/x86/kvm/paging_tmpl.h               |   12 +-
 arch/x86/kvm/svm.c                       |    5 +-
 arch/x86/kvm/vmx.c                       |   35 +-
 arch/x86/kvm/x86.c                       |   47 ++-
 arch/x86/kvm/x86_emulate.c               |   41 ++-
 include/linux/kvm.h                      |   38 ++-
 include/linux/kvm_host.h                 |   49 ++-
 virt/kvm/ioapic.c                        |    6 +
 virt/kvm/irq_comm.c                      |  192 ++++++++-
 virt/kvm/kvm_main.c                      |   57 +++-
 42 files changed, 2323 insertions(+), 438 deletions(-)
 create mode 100644 arch/powerpc/include/asm/kvm_e500.h
 create mode 100644 arch/powerpc/kvm/booke_emulate.c
 create mode 100644 arch/powerpc/kvm/e500.c
 create mode 100644 arch/powerpc/kvm/e500_emulate.c
 create mode 100644 arch/powerpc/kvm/e500_tlb.c
 create mode 100644 arch/powerpc/kvm/e500_tlb.h


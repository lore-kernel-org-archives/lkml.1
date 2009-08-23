Return-Path: <linux-kernel-owner+w=401wt.eu-S933849AbZHWMGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933849AbZHWMGl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 08:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933844AbZHWMGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 08:06:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38745 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933521AbZHWL4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 07:56:47 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/46] KVM updates for 2.6.32 merge window (3/4)
Date: Sun, 23 Aug 2009 14:55:59 +0300
Message-Id: <1251028605-31977-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Third batch of the KVM patch queue.

Akinobu Mita (2):
  KVM: x86: use get_desc_base() and get_desc_limit()
  KVM: x86: use kvm_get_gdt() and kvm_read_ldt()

Andre Przywara (4):
  KVM: Ignore PCI ECS I/O enablement
  KVM: handle AMD microcode MSR
  KVM: fix MMIO_CONF_BASE MSR access
  KVM: add module parameters documentation

Avi Kivity (6):
  KVM: Trace irq level and source id
  KVM: Trace mmio
  KVM: Trace apic registers using their symbolic names
  KVM: MMU: Trace guest pagetable walker
  KVM: Document basic API
  KVM: Trace shadow page lifecycle

Beth Kon (1):
  KVM: PIT support for HPET legacy mode

Gleb Natapov (12):
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

Gregory Haskins (2):
  KVM: make io_bus interface more robust
  KVM: add ioeventfd support

Jan Kiszka (3):
  Revert "KVM: x86: check for cr3 validity in ioctl_set_sregs"
  KVM: Drop obsolete cpu_get/put in make_all_cpus_request
  KVM: VMX: Avoid to return ENOTSUPP to userland

Joerg Roedel (8):
  KVM: MMU: Fix MMU_DEBUG compile breakage
  KVM: MMU: make rmap code aware of mapping levels
  KVM: MMU: rename is_largepage_backed to mapping_level
  KVM: MMU: make direct mapping paths aware of mapping levels
  KVM: MMU: make page walker aware of mapping levels
  KVM: MMU: shadow support for 1gb pages
  KVM: MMU: enable gbpages by increasing nr of pagesizes
  KVM: report 1GB page support to userspace

Marcelo Tosatti (2):
  KVM: MMU: fix missing locking in alloc_mmu_pages
  KVM: limit lapic periodic timer frequency

Michael S. Tsirkin (1):
  KVM: ignore msi request if !level

Mikhail Ershov (1):
  KVM: Align cr8 threshold when userspace changes cr8

Sheng Yang (3):
  KVM: Fix apic_mmio_write return for unaligned write
  KVM: Discard unnecessary kvm_mmu_flush_tlb() in kvm_mmu_load()
  KVM: VMX: Introduce KVM_SET_IDENTITY_MAP_ADDR ioctl

Xiao Guangrong (1):
  KVM: fix kvm_init() error handling

 Documentation/kernel-parameters.txt |   39 ++
 Documentation/kvm/api.txt           |  683 +++++++++++++++++++++++++++++++++++
 arch/ia64/kvm/kvm-ia64.c            |   16 +-
 arch/powerpc/kvm/powerpc.c          |   13 +-
 arch/s390/include/asm/kvm.h         |    9 -
 arch/s390/kvm/interrupt.c           |    8 +-
 arch/x86/include/asm/apicdef.h      |    2 +
 arch/x86/include/asm/kvm.h          |    9 +
 arch/x86/include/asm/kvm_host.h     |    9 +-
 arch/x86/kvm/i8254.c                |   44 ++-
 arch/x86/kvm/i8254.h                |    3 +-
 arch/x86/kvm/i8259.c                |   12 +-
 arch/x86/kvm/lapic.c                |  268 +++++++++++----
 arch/x86/kvm/lapic.h                |    3 +
 arch/x86/kvm/mmu.c                  |  272 +++++++++------
 arch/x86/kvm/mmutrace.h             |  220 +++++++++++
 arch/x86/kvm/paging_tmpl.h          |  108 +++---
 arch/x86/kvm/svm.c                  |   12 +-
 arch/x86/kvm/trace.h                |   99 +++++-
 arch/x86/kvm/vmx.c                  |   25 +-
 arch/x86/kvm/x86.c                  |  176 +++++++---
 arch/x86/kvm/x86.h                  |    4 +
 include/linux/kvm.h                 |   32 ++
 include/linux/kvm_host.h            |   23 +-
 include/trace/events/kvm.h          |  100 +++++-
 virt/kvm/coalesced_mmio.c           |    8 +-
 virt/kvm/eventfd.c                  |  251 +++++++++++++-
 virt/kvm/ioapic.c                   |   28 +-
 virt/kvm/irq_comm.c                 |    8 +-
 virt/kvm/kvm_main.c                 |   59 +++-
 30 files changed, 2177 insertions(+), 366 deletions(-)
 create mode 100644 Documentation/kvm/api.txt
 create mode 100644 arch/x86/kvm/mmutrace.h


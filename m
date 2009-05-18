Return-Path: <linux-kernel-owner+w=401wt.eu-S1754676AbZERJYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbZERJYV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754204AbZERJXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:23:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38395 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbZERJXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:23:07 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 00/43] KVM updates for the 2.6.31 merge window (batch 1/4)
Date: Mon, 18 May 2009 12:22:22 +0300
Message-Id: <1242638585-18470-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following is my queue for the 2.6.31 merge window that is now approaching.
Please review.

Amit Shah (1):
  KVM: x86: Ignore reads to EVNTSEL MSRs

Avi Kivity (9):
  KVM: VMX: Don't use highmem pages for the msr and pio bitmaps
  KVM: VMX: Don't intercept MSR_KERNEL_GS_BASE
  KVM: VMX: Make module parameters readable
  KVM: VMX: Rename kvm_handle_exit() to vmx_handle_exit()
  KVM: VMX: Simplify module parameter names
  KVM: VMX: Annotate module parameters as __read_mostly
  KVM: VMX: Zero the vpid module parameter if vpid is not supported
  KVM: VMX: Zero ept module parameter if ept is not present
  KVM: VMX: Fold vm_need_ept() into callers

Christian Borntraeger (1):
  KVM: declare ioapic functions only on affected hardware

Gleb Natapov (10):
  KVM: APIC: kvm_apic_set_irq deliver all kinds of interrupts
  KVM: ioapic/msi interrupt delivery consolidation
  KVM: consolidate ioapic/ipi interrupt delivery logic
  KVM: change the way how lowest priority vcpu is calculated
  KVM: APIC: get rid of deliver_bitmask
  KVM: MMU: do not free active mmu pages in free_mmu_pages()
  KVM: SVM: Remove duplicate code in svm_do_inject_vector()
  KVM: reuse (pop|push)_irq from svm.c in vmx.c
  KVM: Timer event should not unconditionally unhalt vcpu.
  KVM: Fix interrupt unhalting a vcpu when it shouldn't

Hannes Eder (1):
  KVM: make 'lapic_timer_ops' and 'kpit_ops' static

Jes Sorensen (4):
  KVM: ia64: Map in SN2 RTC registers to the VMM module
  KVM: ia64: Create inline function kvm_get_itc() to centralize ITC
    reading.
  KVM: ia64: SN2 adjust emulated ITC frequency to match RTC frequency
  KVM: ia64: Drop in SN2 replacement of fast path ITC emulation fault
    handler

Joerg Roedel (1):
  KVM: MMU: remove call to kvm_mmu_pte_write from walk_addr

Marcelo Tosatti (4):
  KVM: x86: paravirt skip pit-through-ioapic boot check
  KVM: PIT: remove unused scheduled variable
  KVM: PIT: remove usage of count_load_time for channel 0
  KVM: unify part of generic timer handling

Matt T. Yourst (1):
  KVM: x86: silence preempt warning on kvm_write_guest_time

Sheng Yang (10):
  KVM: Split IOAPIC structure
  KVM: Unify the delivery of IOAPIC and MSI interrupts
  KVM: Change API of kvm_ioapic_get_delivery_bitmask
  KVM: Update intr delivery func to accept unsigned long* bitmap
  KVM: bit ops for deliver_bitmap
  KVM: Ioctls for init MSI-X entry
  KVM: Add MSI-X interrupt injection logic
  KVM: Enable MSI-X for KVM assigned device
  KVM: Merge kvm_ioapic_get_delivery_bitmask into
    kvm_get_intr_delivery_bitmask
  KVM: Device assignment framework rework

Yang Zhang (1):
  KVM: ia64: fix compilation error in kvm_get_lowest_prio_vcpu

 arch/ia64/include/asm/kvm_host.h |    5 +-
 arch/ia64/include/asm/pgtable.h  |    2 +
 arch/ia64/kvm/kvm-ia64.c         |  159 +++++++---
 arch/ia64/kvm/kvm_fw.c           |   28 ++-
 arch/ia64/kvm/lapic.h            |    6 +-
 arch/ia64/kvm/optvfault.S        |   30 ++
 arch/ia64/kvm/vcpu.c             |   20 +-
 arch/ia64/kvm/vmm.c              |   12 +-
 arch/powerpc/kvm/powerpc.c       |    6 +
 arch/s390/kvm/interrupt.c        |    6 +
 arch/x86/include/asm/kvm.h       |    1 +
 arch/x86/include/asm/kvm_host.h  |    4 +-
 arch/x86/kernel/kvm.c            |    4 +
 arch/x86/kvm/Makefile            |    2 +-
 arch/x86/kvm/i8254.c             |   95 +++---
 arch/x86/kvm/i8254.h             |   12 +-
 arch/x86/kvm/kvm_timer.h         |   18 +
 arch/x86/kvm/lapic.c             |  251 +++++----------
 arch/x86/kvm/lapic.h             |   12 +-
 arch/x86/kvm/mmu.c               |    8 -
 arch/x86/kvm/paging_tmpl.h       |    1 -
 arch/x86/kvm/svm.c               |   43 +--
 arch/x86/kvm/timer.c             |   46 +++
 arch/x86/kvm/vmx.c               |  186 ++++++-----
 arch/x86/kvm/x86.c               |   67 +++--
 arch/x86/kvm/x86.h               |   18 +
 include/linux/kvm.h              |   40 +++-
 include/linux/kvm_host.h         |   15 +-
 include/linux/kvm_types.h        |   27 ++
 virt/kvm/ioapic.c                |  153 ++--------
 virt/kvm/ioapic.h                |   27 +--
 virt/kvm/irq_comm.c              |  109 ++++---
 virt/kvm/kvm_main.c              |  634 +++++++++++++++++++++++++++-----------
 33 files changed, 1240 insertions(+), 807 deletions(-)
 create mode 100644 arch/x86/kvm/kvm_timer.h
 create mode 100644 arch/x86/kvm/timer.c


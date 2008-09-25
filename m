Return-Path: <linux-kernel-owner+w=401wt.eu-S1754592AbYIYLz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbYIYLz7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 07:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753497AbYIYLzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 07:55:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48513 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325AbYIYLzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 07:55:19 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 00/39] KVM Updates for 2.6.28 merge window (part 2 of 3)
Date: Thu, 25 Sep 2008 14:54:32 +0300
Message-Id: <1222343711-12508-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the second batch of the KVM updates for the 2.6.28 merge window.

Linux 2.6.28 KVM will introduce support for pci device assignment and will
improve overall emulation accuracy.

Amit Shah (3):
  KVM: Device assignment: Check for privileges before assigning irq
  KVM: SVM: Fix typo
  KVM: Use kvm_set_irq to inject interrupts

Avi Kivity (20):
  KVM: VMX: Use interrupt queue for !irqchip_in_kernel
  KVM: Simplify exception entries by using __ASM_SIZE and _ASM_PTR
  KVM: Handle spurious acks for PIT interrupts
  KVM: VMX: Change cs reset state to be a data segment
  KVM: VMX: Change segment dpl at reset to 3
  KVM: Load real mode segments correctly
  KVM: x86 emulator: remove bad ByteOp specifier from NEG descriptor
  KVM: MMU: Move SHADOW_PT_INDEX to mmu.c
  KVM: MMU: Unify direct map 4K and large page paths
  KVM: MMU: Infer shadow root level in direct_map()
  KVM: MMU: Add generic shadow walker
  KVM: MMU: Convert direct maps to use the generic shadow walker
  KVM: MMU: Convert the paging mode shadow walk to use the generic
    walker
  KVM: Allocate guest memory as MAP_PRIVATE, not MAP_SHARED
  KVM: Don't call get_user_pages(.force = 1)
  KVM: MMU: Account for npt/ept/realmode page faults
  KVM: MMU: Add locking around kvm_mmu_slot_remove_write_access()
  KVM: MMU: Flush tlbs after clearing write permission when accessing
    dirty log
  KVM: MMU: Fix setting the accessed bit on non-speculative sptes
  KVM: SVM: No need to unprotect memory during event injection when
    using npt

Ben-Ami Yassour (1):
  KVM: remove unused field from the assigned dev struct

Christian Borntraeger (2):
  KVM: s390: Make facility bits future-proof
  KVM: s390: change help text of guest Kconfig

Harvey Harrison (1):
  KVM: make irq ack notifier functions static

Joerg Roedel (1):
  KVM: add MC5_MISC msr read support

Marcelo Tosatti (2):
  KVM: set debug registers after "schedulable" section
  KVM: fix i8259 reset irq acking

Mohammed Gamal (5):
  KVM: VMX: Add Guest State Validity Checks
  KVM: VMX: Add module parameter and emulation flag.
  KVM: VMX: Add invalid guest state handler
  KVM: VMX: Modify mode switching and vmentry functions
  KVM: x86 emulator: Add mov r, imm instructions (opcodes 0xb0-0xbf)

Sheng Yang (1):
  KVM: VMX: Clean up magic number 0x66 in init_rmode_tss

Xiantao Zhang (2):
  KVM: ia64: add a dummy irq ack notification
  KVM: ia64: Enable virtio driver for ia64 in Kconfig

roel kluin (1):
  KVM: x86 emulator: remove duplicate SrcImm

 arch/ia64/kvm/Kconfig      |    2 +
 arch/ia64/kvm/irq.h        |   32 ++++++
 arch/s390/Kconfig          |    7 +-
 arch/s390/kvm/priv.c       |    4 +-
 arch/x86/kvm/i8254.c       |   10 +-
 arch/x86/kvm/i8259.c       |   16 ++-
 arch/x86/kvm/mmu.c         |  145 +++++++++++++++++--------
 arch/x86/kvm/paging_tmpl.h |  161 +++++++++++++++-------------
 arch/x86/kvm/svm.c         |    4 +-
 arch/x86/kvm/vmx.c         |  260 ++++++++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/x86.c         |   49 ++++++---
 arch/x86/kvm/x86_emulate.c |   19 ++-
 include/asm-x86/kvm_host.h |   14 +--
 virt/kvm/ioapic.c          |    2 +-
 virt/kvm/kvm_main.c        |    2 +-
 15 files changed, 544 insertions(+), 183 deletions(-)
 create mode 100644 arch/ia64/kvm/irq.h


Return-Path: <linux-kernel-owner+w=401wt.eu-S1757341AbZHZKmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341AbZHZKmM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:42:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932815AbZHZKmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:42:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756760AbZHZKaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:30:10 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/47] KVM updates for 2.6.32 merge window (4/4)
Date: Wed, 26 Aug 2009 13:29:22 +0300
Message-Id: <1251282609-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fourth and final batch of the 2.6.32 KVM patch queue.

Amit Shah (2):
  KVM: ignore reads to perfctr msrs
  Documentation: Update KVM list email address

Anthony Liguori (1):
  KVM: When switching to a vm8086 task, load segments as 16-bit

Avi Kivity (10):
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

Bartlomiej Zolnierkiewicz (1):
  KVM: remove superfluous NULL pointer check in
    kvm_inject_pit_timer_irqs()

Gleb Natapov (4):
  KVM: Call kvm_vcpu_kick() inside pic spinlock
  KVM: Call ack notifiers from PIC when guest OS acks an IRQ.
  KVM: Replace pic_lock()/pic_unlock() with direct call to spinlock
    functions
  KVM: Update cr8 intercept when APIC TPR is changed by userspace

Izik Eidus (1):
  KVM: MMU: make __kvm_mmu_free_some_pages handle empty list

Jan Kiszka (1):
  KVM: x86: Disallow hypercalls for guest callers in rings > 0

Joerg Roedel (21):
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

Marcelo Tosatti (1):
  KVM: MMU: fix bogus alloc_mmu_pages assignment

Michael S. Tsirkin (1):
  KVM: export kvm_para.h

Mikhail Ershov (1):
  KVM: Use kvm_{read,write}_guest_virt() to read and write segment
    descriptors

Mohammed Gamal (1):
  KVM: x86 emulator: Add adc and sbb missing decoder flags

Roel Kluin (1):
  KVM: fix EFER read buffer overflow

Sheng Yang (1):
  KVM: VMX: Fix EPT with WP bit change during paging

 Documentation/ioctl/ioctl-number.txt               |    2 +-
 Documentation/kvm/api.txt                          |   76 +++
 arch/ia64/include/asm/kvm_para.h                   |    4 +
 arch/s390/include/asm/kvm_para.h                   |    4 +
 .../asm/{kvm_x86_emulate.h => kvm_emulate.h}       |    0
 arch/x86/include/asm/kvm_host.h                    |    2 +-
 arch/x86/include/asm/kvm_para.h                    |    2 +
 arch/x86/kvm/Makefile                              |    2 +-
 arch/x86/kvm/{x86_emulate.c => emulate.c}          |    8 +-
 arch/x86/kvm/i8254.c                               |    2 +-
 arch/x86/kvm/i8259.c                               |   64 +--
 arch/x86/kvm/irq.h                                 |    1 -
 arch/x86/kvm/mmu.c                                 |   11 +-
 arch/x86/kvm/svm.c                                 |  650 +++++++++++---------
 arch/x86/kvm/vmx.c                                 |   25 +-
 arch/x86/kvm/x86.c                                 |   35 +-
 arch/x86/mm/highmem_32.c                           |    1 +
 include/asm-generic/Kbuild.asm                     |    5 +
 include/linux/Kbuild                               |    4 +
 include/linux/kvm_para.h                           |    1 +
 virt/kvm/kvm_main.c                                |    2 +-
 21 files changed, 525 insertions(+), 376 deletions(-)
 rename arch/x86/include/asm/{kvm_x86_emulate.h => kvm_emulate.h} (100%)
 rename arch/x86/kvm/{x86_emulate.c => emulate.c} (99%)


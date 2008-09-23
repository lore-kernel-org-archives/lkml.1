Return-Path: <linux-kernel-owner+w=401wt.eu-S1753019AbYIWNrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbYIWNrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 09:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbYIWNq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:46:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52325 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbYIWNq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:46:58 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 00/40] KVM Updates for 2.6.28 merge window (part 1 of 3)
Date: Tue, 23 Sep 2008 16:46:14 +0300
Message-Id: <1222177614-26669-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are the first 40 patches (out of 104, currently) for the 2.6.28 merge
window.

Linux 2.6.28 KVM will introduce support for pci device assignment and will
improve overall emulation accuracy.

Alexander Graf (1):
  KVM: Ignore DEBUGCTL MSRs with no effect

Amit Shah (1):
  KVM: Introduce kvm_set_irq to inject interrupts in guests

Avi Kivity (13):
  KVM: MMU: Separate the code for unlinking a shadow page from its
    parents
  KVM: MMU: Simplify kvm_mmu_zap_page()
  KVM: Move NMI IRET fault processing to new vmx_complete_interrupts()
  KVM: VMX: Move nmi injection failure processing to vm exit path
  KVM: Clear exception queue before emulating an instruction
  KVM: VMX: Fix pending exception processing
  KVM: Add a pending interrupt queue
  KVM: VMX: Move interrupt post-processing to vmx_complete_interrupts()
  KVM: Consolidate PIC isr clearing into a function
  KVM: VMX: Unify register save/restore across 32 and 64 bit hosts
  KVM: SVM: Unify register save/restore across 32 and 64 bit hosts
  KVM: VMX: Avoid vmwrite(HOST_RSP) when possible
  KVM: Add irq ack notifier list

Ben-Ami Yassour (2):
  KVM: direct mmio pfn check
  KVM: pci device assignment

Christian Ehrhardt (3):
  KVM: kvmtrace: Remove use of bit fields in kvm trace structure
  KVM: kvmtrace: replace get_cycles with ktime_get v3
  KVM: ppc: trace powerpc instruction emulation

Dave Hansen (4):
  KVM: Reduce kvm stack usage in kvm_arch_vm_ioctl()
  KVM: Reduce stack usage in kvm_vcpu_ioctl()
  KVM: Reduce stack usage in kvm_arch_vcpu_ioctl()
  KVM: Reduce stack usage in kvm_pv_mmu_op()

Glauber Costa (2):
  x86: paravirt: factor out cpu_khz to common code
  x86: KVM guest: use paravirt function to calculate cpu khz

Hollis Blanchard (5):
  KVM: Move KVM TRACE DEFINITIONS to common header
  KVM: ppc: guest breakpoint support
  KVM: ppc: Stop saving host TLB state
  KVM: ppc: Write only modified shadow entries into the TLB on exit
  KVM: powerpc: Map guest userspace with TID=0 mappings

Jan Kiszka (2):
  KVM: Consolidate XX_VECTOR defines
  KVM: VMX: Reinject real mode exception

Jerone Young (2):
  KVM: ppc: enable KVM_TRACE building for powerpc
  KVM: ppc: adds trace points for ppc tlb activity

Marcelo Tosatti (3):
  KVM: x86: accessors for guest registers
  KVM: irq ack notification
  KVM: PIT: fix injection logic and count

Mohammed Gamal (1):
  KVM: VMX: Remove redundant check in handle_rmode_exception

Sheng Yang (1):
  KVM: VMX: Rename misnamed msr bits

 arch/powerpc/include/asm/kvm_host.h |   14 +-
 arch/powerpc/include/asm/kvm_ppc.h  |   12 +
 arch/powerpc/kernel/asm-offsets.c   |    4 +-
 arch/powerpc/kvm/44x_tlb.c          |   49 +++-
 arch/powerpc/kvm/Kconfig            |   11 +
 arch/powerpc/kvm/Makefile           |    6 +-
 arch/powerpc/kvm/booke_guest.c      |   17 +
 arch/powerpc/kvm/booke_interrupts.S |   79 +++--
 arch/powerpc/kvm/emulate.c          |    8 +-
 arch/powerpc/kvm/powerpc.c          |   99 ++++++-
 arch/x86/kernel/kvmclock.c          |   30 ++
 arch/x86/kernel/pvclock.c           |   12 +
 arch/x86/kvm/i8254.c                |   70 ++--
 arch/x86/kvm/i8254.h                |    7 +-
 arch/x86/kvm/i8259.c                |   30 ++-
 arch/x86/kvm/irq.c                  |   36 ++-
 arch/x86/kvm/irq.h                  |   10 +-
 arch/x86/kvm/kvm_cache_regs.h       |   32 ++
 arch/x86/kvm/lapic.c                |   11 +-
 arch/x86/kvm/mmu.c                  |   46 ++--
 arch/x86/kvm/svm.c                  |  138 +++-----
 arch/x86/kvm/vmx.c                  |  428 +++++++++++++------------
 arch/x86/kvm/vmx.h                  |    4 +-
 arch/x86/kvm/x86.c                  |  623 ++++++++++++++++++++++++++---------
 arch/x86/kvm/x86.h                  |   22 ++
 arch/x86/kvm/x86_emulate.c          |   19 +-
 arch/x86/xen/time.c                 |   11 +-
 include/asm-x86/kvm.h               |   22 --
 include/asm-x86/kvm_host.h          |   77 +++--
 include/asm-x86/pvclock.h           |    1 +
 include/linux/kvm.h                 |   67 ++++-
 include/linux/kvm_host.h            |   19 +
 virt/kvm/ioapic.c                   |   20 +-
 virt/kvm/ioapic.h                   |    3 +-
 virt/kvm/kvm_main.c                 |   68 +++--
 virt/kvm/kvm_trace.c                |   30 +-
 36 files changed, 1428 insertions(+), 707 deletions(-)
 create mode 100644 arch/x86/kvm/kvm_cache_regs.h
 create mode 100644 arch/x86/kvm/x86.h


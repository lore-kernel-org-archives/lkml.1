Return-Path: <linux-kernel-owner+w=401wt.eu-S1755532AbZB1Bm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532AbZB1Bm6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 20:42:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754914AbZB1Bl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 20:41:59 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41762 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753484AbZB1Bl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 20:41:56 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/30] KVM Updates for the 2.6.30 merge window (3/3)
Date: Sat, 28 Feb 2009 03:41:19 +0200
Message-Id: <1235785309-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Third and last batch containing the KVM updates for the next merge window.
Depending on schedule, some of the patches in the 'master' branch may
end up here as well.

Alexander Graf (2):
  x86: Add EFER descriptions for FFXSR
  KVM: Add FFXSR support

Amit Shah (2):
  KVM: VMX: Update necessary state when guest enters long mode
  KVM: is_long_mode() should check for EFER.LMA

Andre Przywara (1):
  KVM: SVM: set accessed bit for VMCB segment selectors

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

Jan Kiszka (1):
  KVM: Drop unused evaluations from string pio handlers

Jes Sorensen (1):
  KVM: ia64: dynamic nr online cpus

Joerg Roedel (4):
  KVM: MMU: handle compound pages in kvm_is_mmio_pfn
  KVM: MMU: remove redundant check in mmu_set_spte
  KVM: MMU: remove assertion in kvm_mmu_alloc_page
  KVM: MMU: Fix another largepage memory leak

Liu Yu (1):
  KVM: ppc: Add emulation of E500 register mmucsr0

Marcelo Tosatti (1):
  KVM: make irq ack notifications aware of routing table

Sheng Yang (2):
  KVM: Use irq routing API for MSI
  KVM: VMX: Use kvm_mmu_page_fault() handle EPT violation mmio

Weidong Han (2):
  KVM: define KVM_CAP_DEVICE_DEASSIGNMENT
  KVM: fix kvm_vm_ioctl_deassign_device

Xiantao Zhang (5):
  KVM: ia64: vTLB change for enabling windows 2008 boot
  KVM: ia64: Add the support for translating PAL Call's pointer args
  KVM: ia64: Implement some pal calls needed for windows 2008
  ia64: Move the macro definitions related to MSI to one header file.
  KVM: ia64: Fix the build errors due to lack of macros related to MSI.

 arch/ia64/include/asm/kvm_host.h |   10 ++-
 arch/ia64/include/asm/msidef.h   |   42 +++++++++++
 arch/ia64/kernel/msi_ia64.c      |   55 ++------------
 arch/ia64/kvm/irq.h              |    2 +
 arch/ia64/kvm/kvm-ia64.c         |   24 +++++--
 arch/ia64/kvm/kvm_fw.c           |  151 +++++++++++++++++++++++++++++++++++++-
 arch/ia64/kvm/process.c          |   56 ++++++++++++--
 arch/ia64/kvm/vcpu.c             |    5 +-
 arch/ia64/kvm/vcpu.h             |    4 +-
 arch/ia64/kvm/vtlb.c             |   39 ++++------
 arch/powerpc/kvm/e500_emulate.c  |    8 ++
 arch/powerpc/kvm/e500_tlb.c      |   16 ++++
 arch/powerpc/kvm/e500_tlb.h      |    1 +
 arch/s390/kvm/intercept.c        |    2 +-
 arch/s390/kvm/interrupt.c        |    7 ++-
 arch/s390/kvm/kvm-s390.h         |    2 +-
 arch/s390/kvm/priv.c             |   18 ++++-
 arch/s390/kvm/sigp.c             |    2 -
 arch/x86/include/asm/kvm_host.h  |    2 +-
 arch/x86/include/asm/msr-index.h |    2 +
 arch/x86/kvm/i8259.c             |   25 +++++--
 arch/x86/kvm/irq.h               |    2 +
 arch/x86/kvm/mmu.c               |   20 ++---
 arch/x86/kvm/mmu.h               |    2 +-
 arch/x86/kvm/paging_tmpl.h       |    2 +-
 arch/x86/kvm/svm.c               |   48 ++++++++----
 arch/x86/kvm/vmx.c               |   88 +++++++----------------
 arch/x86/kvm/x86.c               |  136 ++++++++++++++++++++++++++++++----
 include/linux/kvm.h              |   21 +++++-
 include/linux/kvm_host.h         |    9 +-
 virt/kvm/ioapic.c                |   33 +++++---
 virt/kvm/ioapic.h                |    2 +-
 virt/kvm/irq_comm.c              |  131 +++++++++++++++++++++++++++------
 virt/kvm/kvm_main.c              |   78 +++-----------------
 34 files changed, 724 insertions(+), 321 deletions(-)
 create mode 100644 arch/ia64/include/asm/msidef.h


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756601AbYLIU3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601AbYLIU3M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:29:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754756AbYLIUXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:23:40 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34913 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755284AbYLIUX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:23:26 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/44] KVM Updates for 2.6.29 (part 2 of 3)
Date: Tue,  9 Dec 2008 22:22:15 +0200
Message-Id: <1228854179-23002-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the second batch of the 2.6.29 merge window queue.

Avi Kivity (2):
  Merge branch 'x86/crashdump' of
    git://git.kernel.org/.../tip/linux-2.6-tip
  KVM: VMX: Conditionally request interrupt window after injecting irq

Eduardo Habkost (12):
  KVM: VMX: move vmx.h to include/asm
  KVM: SVM: move svm.h to include/asm
  KVM: VMX: move ASM_VMX_* definitions from asm/kvm_host.h to asm/vmx.h
  KVM: VMX: move cpu_has_kvm_support() to an inline on asm/virtext.h
  x86: asm/virtext.h: add cpu_vmxoff() inline function
  KVM: VMX: extract kvm_cpu_vmxoff() from hardware_disable()
  x86: cpu_emergency_vmxoff() function
  KVM: SVM: move has_svm() code to asm/virtext.h
  KVM: SVM: move svm_hardware_disable() code to asm/virtext.h
  x86: cpu_emergency_svm_disable() function
  kdump: forcibly disable VMX and SVM on machine_crash_shutdown()
  x86: disable VMX on all CPUs on reboot

Glauber Costa (1):
  x86: KVM guest: sign kvmclock as paravirt

Hollis Blanchard (11):
  KVM: ppc: adjust vcpu types to support 64-bit cores
  KVM: ppc: fix set regs to take care of msr change
  KVM: ppc: optimize kvm stat handling
  KVM: ppc: optimize find first bit
  KVM: ppc: optimize irq delivery path
  KVM: ppc: improve trap emulation
  KVM: ensure that memslot userspace addresses are page-aligned
  KVM: ppc: fix Kconfig constraints
  KVM: ppc: use MMUCR accessor to obtain TID
  KVM: ppc: use prefetchable mappings for guest memory
  KVM: ppc: fix userspace mapping invalidation on context switch

Marcelo Tosatti (1):
  KVM: MMU: optimize set_spte for page sync

Nitin A Kamble (2):
  KVM: Fix cpuid leaf 0xb loop termination
  KVM: Fix cpuid iteration on multiple leaves per eac

Sheng Yang (10):
  KVM: Fix kernel allocated memory slot
  KVM: Move ack notifier register and IRQ sourcd ID request
  KVM: Separate update irq to a single function
  KVM: Replace irq_requested with more generic irq_requested_type
  KVM: Clean up assigned_device_update_irq
  KVM: Add fields for MSI device assignment
  KVM: Export ioapic_get_delivery_bitmask
  KVM: Add assigned_device_msi_dispatch()
  KVM: Enable MSI for device assignment
  KVM: MSI to INTx translate

Xiantao Zhang (5):
  KVM: ia64: Remove some macro definitions in asm-offsets.c.
  KVM: ia64: Define printk function for kvm-intel module
  KVM: ia64: Add some debug points to provide crash infomation
  KVM: ia64: Add handler for crashed vmm
  KVM: ia64: Clean up vmm_ivt.S using tab to indent every line

 arch/ia64/include/asm/kvm_host.h     |    4 +
 arch/ia64/kvm/Makefile               |    2 +-
 arch/ia64/kvm/asm-offsets.c          |   11 +-
 arch/ia64/kvm/kvm-ia64.c             |    8 +
 arch/ia64/kvm/kvm_lib.c              |   15 +
 arch/ia64/kvm/mmio.c                 |   38 +-
 arch/ia64/kvm/process.c              |   29 +-
 arch/ia64/kvm/vcpu.c                 |   71 ++-
 arch/ia64/kvm/vcpu.h                 |    5 +-
 arch/ia64/kvm/vmm.c                  |   29 +
 arch/ia64/kvm/vmm_ivt.S              | 1469 +++++++++++++++++-----------------
 arch/powerpc/include/asm/kvm_44x.h   |    2 +
 arch/powerpc/include/asm/kvm_host.h  |   50 +-
 arch/powerpc/include/asm/kvm_ppc.h   |    3 -
 arch/powerpc/kvm/44x_emulate.c       |  109 ++-
 arch/powerpc/kvm/44x_tlb.c           |   42 +-
 arch/powerpc/kvm/Kconfig             |   18 +-
 arch/powerpc/kvm/booke.c             |  221 ++----
 arch/powerpc/kvm/booke.h             |   18 +
 arch/powerpc/kvm/emulate.c           |    6 +-
 arch/powerpc/kvm/powerpc.c           |    4 +-
 arch/x86/include/asm/kexec.h         |   31 +-
 arch/x86/include/asm/kvm_host.h      |   12 -
 arch/x86/include/asm/reboot.h        |    5 +
 arch/x86/{kvm => include/asm}/svm.h  |    0
 arch/x86/include/asm/virtext.h       |  132 +++
 arch/x86/{kvm => include/asm}/vmx.h  |   15 +
 arch/x86/kernel/crash.c              |   86 +--
 arch/x86/kernel/kvmclock.c           |    2 +
 arch/x86/kernel/machine_kexec_32.c   |  104 ++-
 arch/x86/kernel/reboot.c             |  157 ++++-
 arch/x86/kernel/relocate_kernel_32.S |  115 ---
 arch/x86/kvm/kvm_svm.h               |    2 +-
 arch/x86/kvm/mmu.c                   |   11 +-
 arch/x86/kvm/svm.c                   |   25 +-
 arch/x86/kvm/vmx.c                   |   21 +-
 arch/x86/kvm/x86.c                   |    5 +-
 include/linux/kexec.h                |    4 +
 include/linux/kvm.h                  |   10 +
 include/linux/kvm_host.h             |    8 +-
 virt/kvm/ioapic.c                    |    7 +-
 virt/kvm/ioapic.h                    |    2 +
 virt/kvm/kvm_main.c                  |  255 +++++-
 43 files changed, 1834 insertions(+), 1329 deletions(-)
 create mode 100644 arch/ia64/kvm/kvm_lib.c
 rename arch/x86/{kvm => include/asm}/svm.h (100%)
 create mode 100644 arch/x86/include/asm/virtext.h
 rename arch/x86/{kvm => include/asm}/vmx.h (95%)


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754487AbZKSNf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbZKSNf6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 08:35:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753798AbZKSNfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 08:35:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649AbZKSNfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 08:35:06 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 00/35] KVM updates for the 2.6.33 merge window (batch 2/2)
Date: Thu, 19 Nov 2009 15:34:36 +0200
Message-Id: <1258637711-11674-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Highlights:
- improved kernel context switching speed
- better interoperation with other users of virtualization extensions
- improved irq scaling
- nested svm improvements and tracing
- improved cpufreq integration
- spin loop detection on newer hardware

Notes:
- kvm/ppc64 support will be merged through the powerpc tree
- depends on tip x86/entry branch (user return notifiers)

Arnd Bergmann (1):
  KVM: Enable 32bit dirty log pointers on 64bit host

Avi Kivity (6):
  KVM: VMX: Move MSR_KERNEL_GS_BASE out of the vmx autoload msr area
  KVM: x86 shared msr infrastructure
  KVM: VMX: Use shared msr infrastructure
  KVM: VMX: Remove vmx->msr_offset_efer
  KVM: Allow internal errors reported to userspace to carry extra data
  KVM: VMX: Report unexpected simultaneous exceptions as internal
    errors

Ed Swierk (1):
  KVM: Xen PV-on-HVM guest support

Eduardo Habkost (3):
  KVM: VMX: Use macros instead of hex value on cr0 initialization
  KVM: SVM: Reset cr0 properly on vcpu reset
  KVM: SVM: init_vmcb(): remove redundant save->cr0 initialization

Glauber Costa (1):
  KVM: allow userspace to adjust kvmclock offset

Gleb Natapov (1):
  KVM: remove duplicated task_switch check

Hollis Blanchard (1):
  KVM: powerpc: Fix BUILD_BUG_ON condition

Jan Kiszka (6):
  KVM: x86: Drop unneeded CONFIG_HAS_IOMEM check
  KVM: x86: Fix guest single-stepping while interruptible
  KVM: SVM: Cleanup NMI singlestep
  KVM: x86: Polish exception injection via KVM_SET_GUEST_DEBUG
  KVM: Reorder IOCTLs in main kvm.h
  KVM: x86: Add KVM_GET/SET_VCPU_EVENTS

Joerg Roedel (4):
  KVM: SVM: Add tracepoint for #vmexit because intr pending
  KVM: SVM: Add tracepoint for invlpga instruction
  KVM: SVM: Add tracepoint for skinit instruction
  KVM: SVM: Remove nsvm_printk debugging code

Marcelo Tosatti (7):
  KVM: VMX: fix handle_pause declaration
  KVM: fix irq_source_id size verification
  KVM: VMX: move CR3/PDPTR update to vmx_set_cr3
  KVM: MMU: update invlpg handler comment
  KVM: x86: disallow multiple KVM_CREATE_IRQCHIP
  KVM: x86: disallow KVM_{SET,GET}_LAPIC without allocated in-kernel
    lapic
  KVM: only clear irq_source_id if irqchip is present

Mark Langsdorf (1):
  KVM: SVM: Support Pause Filter in AMD processors

Zachary Amsden (1):
  KVM: x86: Harden against cpufreq

Zhai, Edwin (2):
  KVM: introduce kvm_vcpu_on_spin
  KVM: VMX: Add support for Pause-Loop Exiting

 Documentation/kvm/api.txt       |  109 +++++++++++
 arch/powerpc/kvm/timing.h       |    2 +-
 arch/x86/include/asm/kvm.h      |   29 +++
 arch/x86/include/asm/kvm_host.h |   13 ++-
 arch/x86/include/asm/svm.h      |    3 +-
 arch/x86/include/asm/vmx.h      |    4 +
 arch/x86/kvm/Kconfig            |    1 +
 arch/x86/kvm/irq.h              |    6 +-
 arch/x86/kvm/mmu.c              |    1 +
 arch/x86/kvm/paging_tmpl.h      |    1 -
 arch/x86/kvm/svm.c              |  107 ++++++-----
 arch/x86/kvm/trace.h            |   63 +++++++
 arch/x86/kvm/vmx.c              |  253 ++++++++++++++++----------
 arch/x86/kvm/x86.c              |  379 ++++++++++++++++++++++++++++++++++-----
 include/linux/kvm.h             |  264 +++++++++++++++------------
 include/linux/kvm_host.h        |    1 +
 virt/kvm/irq_comm.c             |   12 +-
 virt/kvm/kvm_main.c             |   67 +++++++-
 18 files changed, 1002 insertions(+), 313 deletions(-)


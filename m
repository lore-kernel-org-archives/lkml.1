Return-Path: <linux-kernel-owner+w=401wt.eu-S1759936AbXFQJqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759936AbXFQJqV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 05:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758468AbXFQJon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:44:43 -0400
Received: from il.qumranet.com ([82.166.9.18]:55127 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757680AbXFQJok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:40 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/58] KVM updates for 2.6.23
Date: Sun, 17 Jun 2007 12:43:41 +0300
Message-Id: <1182073479890-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Following is my patchqueue for the 2.6.23 merge window, not including
the cpu hotplug fixes posted earlier.  The changes include performance
improvements, guest smp, random fixes, and cleanups.  Comments welcome.

Anthony Liguori (1):
      KVM: SVM: Allow direct guest access to PC debug port

Avi Kivity (44):
      KVM: Assume that writes smaller than 4 bytes are to non-pagetable pages
      KVM: Avoid saving and restoring some host CPU state on lightweight vmexit
      KVM: Unindent some code
      KVM: Reduce misfirings of the fork detector
      KVM: Be more careful restoring fs on lightweight vmexit
      KVM: Unify kvm_mmu_pre_write() and kvm_mmu_post_write()
      KVM: MMU: Respect nonpae pagetable quadrant when zapping ptes
      KVM: Update shadow pte on write to guest pte
      KVM: Increase mmu shadow cache to 1024 pages
      KVM: Fix potential guest state leak into host
      KVM: Move some more msr mangling into vmx_save_host_state()
      KVM: Rationalize exception bitmap usage
      KVM: Consolidate guest fpu activation and deactivation
      KVM: Set cr0.mp for guests
      KVM: MMU: Simplify kvm_mmu_free_page() a tiny bit
      KVM: MMU: Store shadow page tables as kernel virtual addresses, not physical
      KVM: VMX: Only reload guest msrs if they are already loaded
      KVM: Avoid corrupting tr in real mode
      KVM: Fix vmx I/O bitmap initialization on highmem systems
      KVM: VMX: Use local labels in inline assembly
      KVM: x86 emulator: implement wbinvd
      KVM: MMU: Use slab caches for shadow pages and their headers
      KVM: MMU: Simplify fetch() a little bit
      KVM: MMU: Move set_pte_common() to pte width dependent code
      KVM: MMU: Pass the guest pde to set_pte_common
      KVM: MMU: Fold fix_read_pf() into set_pte_common()
      KVM: MMU: Fold fix_write_pf() into set_pte_common()
      KVM: Move shadow pte modifications from set_pte/set_pde to set_pde_common()
      KVM: Make shadow pte updates atomic
      KVM: MMU: Make setting shadow ptes atomic on i386
      KVM: MMU: Remove cr0.wp tricks
      KVM: MMU: Simpify accessed/dirty/present/nx bit handling
      KVM: MMU: Don't cache guest access bits in the shadow page table
      KVM: MMU: Remove unused large page marker
      KVM: Lazy guest cr3 switching
      KVM: Fix vcpu freeing for guest smp
      KVM: Fix adding an smp virtual machine to the vm list
      KVM: Enable guest smp
      KVM: Move duplicate halt handling code into kvm_main.c
      KVM: Emulate hlt on real mode for Intel
      KVM: Keep an upper bound of initialized vcpus
      KVM: Flush remote tlbs when reducing shadow pte permissions
      KVM: Initialize the BSP bit in the APIC_BASE msr correctly
      KVM: VMX: Ensure vcpu time stamp counter is monotonous

Eddie Dong (4):
      KVM: VMX: Avoid saving and restoring msrs on lightweight vmexit
      KVM: VMX: Cleanup redundant code in MSR set
      KVM: VMX: Avoid saving and restoring msr_efer on lightweight vmexit
      KVM: Use symbolic constants instead of magic numbers

He, Qing (1):
      KVM: VMX: Enable io bitmaps to avoid IO port 0x80 VMEXITs

Jan Engelhardt (1):
      Use menuconfig objects II - KVM/Virt

Markus Rechberger (1):
      KVM: Fix includes

Matthew Gregan (1):
      KVM: Implement IA32_EBL_CR_POWERON msr

Nguyen Anh Quynh (1):
      KVM: Remove unnecessary initialization and checks in mark_page_dirty()

Nitin A Kamble (1):
      KVM: VMX: Handle #SS faults from real mode

Robert P. J. Day (1):
      KVM: Replace C code with call to ARRAY_SIZE() macro.

Shani Moideen (2):
      KVM: SVM: Replace memset(<addr>, 0, PAGESIZE) with clear_page(<addr>)
      KVM: VMX: Replace memset(<addr>, 0, PAGESIZE) with clear_page(<addr>)

 drivers/kvm/Kconfig       |    9 +-
 drivers/kvm/kvm.h         |   53 ++++-
 drivers/kvm/kvm_main.c    |  115 ++++++++-
 drivers/kvm/mmu.c         |  284 +++++++++-----------
 drivers/kvm/paging_tmpl.h |  273 ++++++++++---------
 drivers/kvm/svm.c         |   46 ++--
 drivers/kvm/vmx.c         |  640 ++++++++++++++++++++++++++++-----------------
 drivers/kvm/x86_emulate.c |   10 +-
 8 files changed, 868 insertions(+), 562 deletions(-)

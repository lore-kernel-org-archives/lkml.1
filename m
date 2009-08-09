Return-Path: <linux-kernel-owner+w=401wt.eu-S1751979AbZHILqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979AbZHILqQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 07:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751310AbZHILqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 07:46:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36299 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbZHILqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 07:46:15 -0400
From: Avi Kivity <avi@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] KVM updates for 2.6.31-rc5
Date: Sun,  9 Aug 2009 14:46:12 +0300
Message-Id: <1249818372-11379-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/2.6.31

Several critical patches, including a guest-initiated DoS fix, guest
memory corruption on AMD, and edge-triggered interrupt mishandling which
confuses some Windows variants on SMP.

Avi Kivity (1):
      KVM: ia64: fix build failures due to ia64/unsigned long mismatches

Christian Borntraeger (1):
      KVM: s390: fix wait_queue handling

Gleb Natapov (1):
      KVM: Avoid redelivery of edge interrupt before next edge

Jan Kiszka (3):
      KVM: Fix KVM_GET_MSR_INDEX_LIST
      KVM: VMX: Fix locking order in handle_invalid_guest_state
      KVM: VMX: Fix locking imbalance on emulation failure

Marcelo Tosatti (5):
      KVM: PIT: fix kpit_elapsed division by zero
      KVM: x86: verify MTRR/PAT validity
      KVM: SVM: force new asid on vcpu migration
      KVM: MMU: handle n_free_mmu_pages > n_alloc_mmu_pages in kvm_mmu_change_mmu_pages
      KVM: MMU: limit rmap chain length

Michael S. Tsirkin (1):
      KVM: fix ack not being delivered when msi present

Stephen Rothwell (1):
      KVM: Make KVM_HPAGES_PER_HPAGE unsigned long to avoid build error on powerpc

 arch/ia64/kvm/mmio.c                |    6 +++-
 arch/ia64/kvm/vcpu.c                |    6 ++--
 arch/ia64/kvm/vcpu.h                |   13 +++++----
 arch/powerpc/include/asm/kvm_host.h |    2 +-
 arch/s390/kvm/interrupt.c           |    2 +-
 arch/x86/kvm/i8254.c                |    3 ++
 arch/x86/kvm/mmu.c                  |   48 ++++++++++++++++++++++++++--------
 arch/x86/kvm/svm.c                  |    6 ++--
 arch/x86/kvm/vmx.c                  |    6 ++--
 arch/x86/kvm/x86.c                  |   44 +++++++++++++++++++++++++++++---
 include/linux/kvm_host.h            |    1 +
 virt/kvm/ioapic.c                   |   10 +++---
 virt/kvm/irq_comm.c                 |    4 ++-
 13 files changed, 110 insertions(+), 41 deletions(-)

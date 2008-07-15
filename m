Return-Path: <linux-kernel-owner+w=401wt.eu-S1757982AbYGOMOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982AbYGOMOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 08:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756351AbYGOMMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 08:12:46 -0400
Received: from il.qumranet.com ([212.179.150.194]:30325 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755378AbYGOMMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 08:12:40 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/19] KVM Updates for the 2.6.27 (supplemental)
Date: Tue, 15 Jul 2008 15:12:19 +0300
Message-Id: <1216123958-10717-1-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to the longer-than-usual release cycle, a few patches have accumulated
that I'd like to push out for the merge window.  These are all fairly local
and safe changes.

Shortlog/diffstat follow; please review.

Adrian Bunk (1):
  x86: KVM guest: make kvm_smp_prepare_boot_cpu() static

Avi Kivity (3):
  KVM: Apply the kernel sigmask to vcpus blocked due to being
    uninitialized
  KVM: Prefix some x86 low level function with kvm_, to avoid namespace
    issues
  KVM: MMU: Fix potential race setting upper shadow ptes on nonpae
    hosts

Ben-Ami Yassour (1):
  KVM: check injected pic irq within valid pic irqs

Carsten Otte (2):
  KVM: s390: dont allocate dirty bitmap
  KVM: Fix memory leak on guest exit

Chris Lalancette (1):
  KVM: VMX: Fake emulate Intel perfctr MSRs

Christian Borntraeger (2):
  KVM: s390: Set guest storage limit and offset to sane values
  KVM: s390: rename private structures

Glauber Costa (1):
  KVM: x86 emulator: emulate clflush

Joerg Roedel (1):
  KVM: SVM: fix suspend/resume support

Marcelo Tosatti (4):
  KVM: move slots_lock acquision down to vapic_exit
  KVM: mmu_shrink: kvm_mmu_zap_page requires slots_lock to be held
  KVM: MMU: nuke shadowed pgtable pages and ptes on memslot destruction
  KVM: MMU: improve invalid shadow root page handling

Mohammed Gamal (1):
  KVM: x86 emulator: Fix HLT instruction

Sheng Yang (2):
  KVM: VMX: Fix a wrong usage of vmcs_config
  KVM: VMX: Add ept_sync_context in flush_tlb

 arch/ia64/kvm/kvm-ia64.c    |    3 ++
 arch/powerpc/kvm/powerpc.c  |    4 +++
 arch/s390/kvm/interrupt.c   |   32 +++++++++++++++---------------
 arch/s390/kvm/kvm-s390.c    |   17 +++++++++++++--
 arch/s390/kvm/priv.c        |    2 +-
 arch/s390/kvm/sigp.c        |   20 +++++++++---------
 arch/x86/kernel/kvmclock.c  |    2 +-
 arch/x86/kvm/i8259.c        |    6 +++-
 arch/x86/kvm/irq.h          |    2 +
 arch/x86/kvm/mmu.c          |   15 ++++++++++---
 arch/x86/kvm/svm.c          |   46 ++++++++++++++++++++++++++----------------
 arch/x86/kvm/vmx.c          |   43 +++++++++++++++++++++++++++-------------
 arch/x86/kvm/x86.c          |   37 +++++++++++++++++++---------------
 arch/x86/kvm/x86_emulate.c  |    6 +++-
 include/asm-s390/kvm_host.h |   36 ++++++++++++++++----------------
 include/asm-x86/kvm_host.h  |   26 +++++++++++-------------
 include/linux/kvm_host.h    |    1 +
 virt/kvm/kvm_main.c         |    5 ++++
 18 files changed, 184 insertions(+), 119 deletions(-)


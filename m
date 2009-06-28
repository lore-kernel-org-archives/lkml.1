Return-Path: <linux-kernel-owner+w=401wt.eu-S1755796AbZF1Nxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796AbZF1Nxh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 09:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbZF1Nx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 09:53:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59212 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102AbZF1Nx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 09:53:28 -0400
From: Avi Kivity <avi@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for 2.6.31-rc1
Date: Sun, 28 Jun 2009 16:53:26 +0300
Message-Id: <1246197206-24770-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please find, in

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/2.6.31

a few kvm updates for 2.6.31-rc1.  There's nothing earth shattering in
there.  Most significant is a race fix which could leave stale guest tlb
entries under fairly rare conditions.

Amit Shah (1):
      KVM: Ignore reads to K7 EVNTSEL MSRs

Avi Kivity (2):
      KVM: MMU: Allow 4K ptes with bit 7 (PAT) set
      KVM: VMX: Handle vmx instruction vmexits

Christian Borntraeger (1):
      KVM: s390: Allow stfle instruction in the guest

Izik Eidus (1):
      KVM: Fix dirty bit tracking for slots with large pages

Jaswinder Singh Rajput (2):
      KVM: kvm/x86_emulate.c toggle_interruptibility() should be static
      KVM: shut up uninit compiler warning in paging_tmpl.h

Jes Sorensen (1):
      KVM: ia64: fix ia64 build due to missing kallsyms_lookup() and double export

Marcelo Tosatti (1):
      KVM: protect concurrent make_all_cpus_request

 arch/ia64/kvm/kvm_lib.c          |    6 ++++++
 arch/s390/include/asm/kvm_host.h |    4 +++-
 arch/s390/kvm/kvm-s390.c         |   23 ++++++++++++++++++++++-
 arch/s390/kvm/priv.c             |    2 +-
 arch/x86/kvm/mmu.c               |    6 +++---
 arch/x86/kvm/paging_tmpl.h       |    2 +-
 arch/x86/kvm/vmx.c               |   15 +++++++++++++++
 arch/x86/kvm/x86.c               |    1 +
 arch/x86/kvm/x86_emulate.c       |    2 +-
 include/linux/kvm_host.h         |    1 +
 virt/kvm/kvm_main.c              |    5 +++++
 11 files changed, 59 insertions(+), 8 deletions(-)

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752766AbYK3J6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbYK3J6T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 04:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751163AbYK3J55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 04:57:57 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60582 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111AbYK3J5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 04:57:55 -0500
From: Avi Kivity <avi@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] KVM updates for Linux 2.6.28-rc6
Date: Sun, 30 Nov 2008 11:57:17 +0200
Message-Id: <1228039037-4708-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull some kvm fixes from repo and branch at:

  git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git kvm-updates/2.6.28

There are a couple of fixes for the out-of-sync mmu, a fix for a lost irq
while injecting an nmi (which causes guests with an nmi watchdog to hang),
as well as fixes for the ppc, s390, and ia64 kvm ports.

Avi Kivity (1):
      KVM: VMX: Fix interrupt loss during race with NMI

Christian Borntraeger (1):
      KVM: s390: Fix problem state handling in guest sigp handler

Hollis Blanchard (1):
      KVM: ppc: stop leaking host memory on VM exit

Marcelo Tosatti (2):
      KVM: MMU: fix sync of ptes addressed at owner pagetable
      KVM: MMU: avoid creation of unreachable pages in the shadow

Xiantao Zhang (2):
      KVM: ia64: Fix incorrect kbuild CFLAGS override
      KVM: ia64: Fix: Use correct calling convention for PAL_VPS_RESUME_HANDLER

 arch/ia64/kvm/Makefile             |    2 +-
 arch/ia64/kvm/optvfault.S          |   11 +++++++----
 arch/powerpc/include/asm/kvm_ppc.h |    2 ++
 arch/powerpc/kvm/44x_tlb.c         |    8 ++++++++
 arch/powerpc/kvm/powerpc.c         |    1 +
 arch/s390/kvm/sigp.c               |    5 +++++
 arch/x86/kvm/mmu.c                 |    2 +-
 arch/x86/kvm/paging_tmpl.h         |    1 +
 arch/x86/kvm/vmx.c                 |    4 +++-
 9 files changed, 29 insertions(+), 7 deletions(-)

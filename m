Return-Path: <linux-kernel-owner+w=401wt.eu-S1753330AbYLBIy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330AbYLBIy0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 03:54:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbYLBIyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 03:54:15 -0500
Received: from mx2.redhat.com ([66.187.237.31]:42666 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbYLBIyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 03:54:14 -0500
Message-ID: <4934F7AD.3060104@redhat.com>
Date: Tue, 02 Dec 2008 10:54:05 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL][RESEND] KVM updates for Linux 2.6.28-rc6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull some kvm fixes from repo and branch at:

   git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git 
kvm-updates/2.6.28

There are a couple of fixes for the out-of-sync mmu, a fix for a lost 
irq while injecting an nmi (which causes guests with an nmi watchdog to 
hang), as well as fixes for the ppc, s390, and ia64 kvm ports.

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
       KVM: ia64: Fix: Use correct calling convention for 
PAL_VPS_RESUME_HANDLER

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

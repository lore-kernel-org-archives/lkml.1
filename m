Return-Path: <linux-kernel-owner+w=401wt.eu-S1756577AbYEDMHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577AbYEDMHO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 08:07:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754890AbYEDMHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 08:07:00 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:44023
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbYEDMG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 08:06:59 -0400
Message-ID: <481DA6E0.7010409@qumranet.com>
Date: Sun, 04 May 2008 15:06:56 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
Subject: [GIT PULL] KVM updates for 2.6.26-rc1
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from repo and branch at:

  git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git 
kvm-updates-2.6.26

In addition to a few random fixes this update adds support for Intel 
Extended Page Tables (EPT), a feature which greatly improves 
virtualization performance on the new Nehalem processors.  The 
implementation builds on the same code paths as AMD NPT (and real-mode 
shadow) and is therefore small and safe for inclusion.

Andrea Arcangeli (1):
      KVM: avoid fx_init() schedule in atomic

Avi Kivity (2):
      KVM: x86 emulator: disable writeback on lmsw
      KVM: MMU: Allow more than PAGES_PER_HPAGE write protections per 
large page

Christian Ehrhardt (1):
      KVM: ppc: deliver INTERRUPT_FP_UNAVAIL to the guest

Glauber Costa (1):
      x86: KVM geust: make setup_secondary_clock definition dependent on 
local apic

Hollis Blanchard (1):
      KVM: ppc: Handle guest idle by emulating MSR[WE] writes

Izik Eidus (1):
      KVM: x86: task switch: fix wrong bit setting for the busy flag

Jan Kiszka (1):
      KVM: Avoid spurious execeptions after setting registers

Marcelo Tosatti (1):
      KVM: PIT: support mode 4

Sheng Yang (8):
      KVM: VMX: EPT Feature Detection
      KVM: MMU: Move some definitions to a header file
      KVM: Add kvm_x86_ops get_tdp_level()
      KVM: MMU: Add EPT support
      KVM: MMU: Remove #ifdef CONFIG_X86_64 to support 4 level EPT
      KVM: Export necessary function for EPT
      KVM: VMX: Prepare an identity page table for EPT in real mode
      KVM: VMX: Enable EPT feature for KVM

 arch/powerpc/kvm/booke_guest.c |    6 +
 arch/powerpc/kvm/powerpc.c     |   20 ++-
 arch/x86/kernel/kvmclock.c     |    4 +
 arch/x86/kvm/i8254.c           |    2 +
 arch/x86/kvm/mmu.c             |   89 ++++------
 arch/x86/kvm/mmu.h             |   37 ++++-
 arch/x86/kvm/svm.c             |   10 +
 arch/x86/kvm/vmx.c             |  375 
++++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx.h             |   38 ++++
 arch/x86/kvm/x86.c             |   22 ++-
 arch/x86/kvm/x86_emulate.c     |    1 +
 include/asm-powerpc/kvm_host.h |    1 +
 include/asm-powerpc/kvm_ppc.h  |    5 +
 include/asm-x86/kvm_host.h     |   10 +-
 virt/kvm/kvm_main.c            |    1 +
 15 files changed, 542 insertions(+), 79 deletions(-)

-- 
error compiling committee.c: too many arguments to function


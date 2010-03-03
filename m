Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab0CCTNG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 14:13:06 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:9036 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab0CCTMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 14:12:52 -0500
X-SpamScore: -6
X-BigFish: VPS-6(zz146fK4015Lzz1202hzzz32i6bh87h2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYQ015-02-H51-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/18][RFC] Nested Paging support for Nested SVM (aka NPT-Virtualization)
Date: Wed, 3 Mar 2010 20:12:03 +0100
Message-ID: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0
X-OriginalArrivalTime: 03 Mar 2010 19:12:42.0391 (UTC) FILETIME=[7FA01A70:01CABB05]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here are the patches that implement nested paging support for nested
svm. They are somewhat intrusive to the soft-mmu so I post them as RFC
in the first round to get feedback about the general direction of the
changes.  Nevertheless I am proud to report that with these patches the
famous kernel-compile benchmark runs only 4% slower in the l2 guest as
in the l1 guest when l2 is single-processor. With SMP guests the
situation is very different. The more vcpus the guest has the more is
the performance drop from l1 to l2. 
Anyway, this post is to get feedback about the overall concept of these
patches.  Please review and give feedback :-)

Thanks,

	Joerg

Diffstat:

 arch/x86/include/asm/kvm_host.h |   21 ++++++
 arch/x86/kvm/mmu.c              |  152 ++++++++++++++++++++++++++++++---------
 arch/x86/kvm/mmu.h              |    2 +
 arch/x86/kvm/paging_tmpl.h      |   81 ++++++++++++++++++---
 arch/x86/kvm/svm.c              |  126 +++++++++++++++++++++++++++-----
 arch/x86/kvm/vmx.c              |    9 +++
 arch/x86/kvm/x86.c              |   19 +++++-
 include/linux/kvm.h             |    1 +
 include/linux/kvm_host.h        |    5 ++
 9 files changed, 354 insertions(+), 62 deletions(-)

Shortlog:

Joerg Roedel (18):
      KVM: MMU: Check for root_level instead of long mode
      KVM: MMU: Make tdp_enabled a mmu-context parameter
      KVM: MMU: Make set_cr3 a function pointer in kvm_mmu
      KVM: X86: Introduce a tdp_set_cr3 function
      KVM: MMU: Introduce get_cr3 function pointer
      KVM: MMU: Introduce inject_page_fault function pointer
      KVM: SVM: Implement MMU helper functions for Nested Nested Paging
      KVM: MMU: Change init_kvm_softmmu to take a context as parameter
      KVM: MMU: Let is_rsvd_bits_set take mmu context instead of vcpu
      KVM: MMU: Introduce generic walk_addr function
      KVM: MMU: Add infrastructure for two-level page walker
      KVM: MMU: Implement nested gva_to_gpa functions
      KVM: MMU: Introduce Nested MMU context
      KVM: SVM: Initialize Nested Nested MMU context on VMRUN
      KVM: MMU: Propagate the right fault back to the guest after gva_to_gpa
      KVM: X86: Add callback to let modules decide over some supported cpuid bits
      KVM: SVM: Report Nested Paging support to userspace
      KVM: X86: Add KVM_CAP_SVM_CPUID_FIXED



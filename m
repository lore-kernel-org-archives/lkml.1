Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503Ab0BXR7n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 12:59:43 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:22179
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757468Ab0BXR7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 12:59:39 -0500
X-SpamScore: -3
X-BigFish: VPS-3(zz4015Lzz1202hzzz32i6bh87h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYCXYZ-01-2QZ-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/11] Another set of nested svm fixes and optimizations
Date: Wed, 24 Feb 2010 18:59:09 +0100
Message-ID: <1267034360-5907-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0
X-OriginalArrivalTime: 24 Feb 2010 17:59:23.0449 (UTC) FILETIME=[18C29290:01CAB57B]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is another set of patches I collected in the last days while trying
to get Hyper-V running with nested svm. I was not successful yet but the
patches in this set make sense anyway :-)
The patches fix coding style issues which annoyed me for some time
because my vim shows all c-space-errors with red color. Other patches in
this set make nested svm more complete (nmi and selective cr0 related).
The vm_cr and hwcr.ignne patches are related to Hyper-V tests. This
hypervisor expects to write to those msrs.
The most interesting thing is patch 11 which reduces the amount of
memory which is touched in the vmrun emulation for merging the msrpms
from 24kb to 48 bytes.  Please review and comment (or apply if
perfect ;-) ) these patches.

Thanks,

	Joerg

diffstat:

 arch/x86/include/asm/svm.h |    4 +
 arch/x86/kvm/svm.c         |  282 +++++++++++++++++++++++++++++++-------------
 arch/x86/kvm/trace.h       |   22 ++++
 arch/x86/kvm/x86.c         |    3 +-
 4 files changed, 226 insertions(+), 85 deletions(-)

shortlog:

Joerg Roedel (11):
      KVM: SVM: Coding style cleanup
      KVM: SVM: Reset MMU on nested_svm_vmrun for NPT too
      KVM: SVM: Check for nested intercepts on NMI injection
      KVM: SVM: Restore tracing of nested vmcb address
      KVM: SVM: Add kvm_nested_intercepts tracepoint
      KVM: SVM: Implement emulation of vm_cr msr
      KVM: SVM: Ignore write of hwcr.ignne
      KVM: x86: Don't set arch.cr0 in kvm_set_cr0
      KVM: SVM: Handle nested selective_cr0 intercept correctly
      KVM: SVM: Clear exit_info for injected INTR exits
      KVM: SVM: Optimize nested svm msrpm merging



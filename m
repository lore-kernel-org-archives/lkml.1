Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab0CCTQH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 14:16:07 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:11655
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753746Ab0CCTNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 14:13:02 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i2a8h6bh87h43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYQ01C-02-H5M-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 18/18] KVM: X86: Add KVM_CAP_SVM_CPUID_FIXED
Date: Wed, 3 Mar 2010 20:12:21 +0100
Message-ID: <1267643541-451-19-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
References: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 03 Mar 2010 19:12:42.0907 (UTC) FILETIME=[7FEED6B0:01CABB05]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This capability shows userspace that is can trust the values
of cpuid[0x8000000A] that it gets from the kernel. Old
behavior was to just return the host cpuid values which is
broken because all additional svm-features need support in
the svm emulation code.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/x86.c  |    1 +
 include/linux/kvm.h |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 53360de..51bad08 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1557,6 +1557,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_PCI_SEGMENT:
 	case KVM_CAP_DEBUGREGS:
 	case KVM_CAP_X86_ROBUST_SINGLESTEP:
+	case KVM_CAP_SVM_CPUID_FIXED:
 		r = 1;
 		break;
 	case KVM_CAP_COALESCED_MMIO:
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index ce28767..86caf32 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -507,6 +507,7 @@ struct kvm_ioeventfd {
 #define KVM_CAP_DEBUGREGS 50
 #endif
 #define KVM_CAP_X86_ROBUST_SINGLESTEP 51
+#define KVM_CAP_SVM_CPUID_FIXED 52
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
1.7.0



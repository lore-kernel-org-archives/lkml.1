Return-Path: <linux-kernel-owner+w=401wt.eu-S1762956AbYDCTiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762956AbYDCTiW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761070AbYDCTdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:33:13 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:53040
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760099AbYDCTc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:32:59 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 18/35] KVM: add basic paravirt support
Date: Thu,  3 Apr 2008 22:32:33 +0300
Message-Id: <1207251170-5013-19-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1207251170-5013-1-git-send-email-avi@qumranet.com>
References: <1207251170-5013-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Add basic KVM paravirt support. Avoid vm-exits on IO delays.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86.c         |    1 +
 include/asm-x86/kvm_para.h |    3 ++-
 include/linux/kvm.h        |    1 +
 3 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 621a8e3..1b9e695 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -820,6 +820,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_EXT_CPUID:
 	case KVM_CAP_CLOCKSOURCE:
 	case KVM_CAP_PIT:
+	case KVM_CAP_NOP_IO_DELAY:
 		r = 1;
 		break;
 	case KVM_CAP_VAPIC:
diff --git a/include/asm-x86/kvm_para.h b/include/asm-x86/kvm_para.h
index 5ab7d3d..ed5df3a 100644
--- a/include/asm-x86/kvm_para.h
+++ b/include/asm-x86/kvm_para.h
@@ -10,7 +10,8 @@
  * paravirtualization, the appropriate feature bit should be checked.
  */
 #define KVM_CPUID_FEATURES	0x40000001
-#define KVM_FEATURE_CLOCKSOURCE 0
+#define KVM_FEATURE_CLOCKSOURCE		0
+#define KVM_FEATURE_NOP_IO_DELAY	1
 
 #define MSR_KVM_WALL_CLOCK  0x11
 #define MSR_KVM_SYSTEM_TIME 0x12
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index a2f3274..76f0947 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -237,6 +237,7 @@ struct kvm_vapic_addr {
 #define KVM_CAP_NR_VCPUS 9       /* returns max vcpus per vm */
 #define KVM_CAP_NR_MEMSLOTS 10   /* returns max memory slots per vm */
 #define KVM_CAP_PIT 11
+#define KVM_CAP_NOP_IO_DELAY 12
 
 /*
  * ioctls for VM fds
-- 
1.5.4.5


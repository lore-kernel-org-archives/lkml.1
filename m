Return-Path: <linux-kernel-owner+w=401wt.eu-S1755877AbYFZMeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877AbYFZMeG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:34:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753728AbYFZM24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:28:56 -0400
Received: from il.qumranet.com ([212.179.150.194]:32339 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610AbYFZM2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:28:43 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Laurent Vivier <Laurent.Vivier@bull.net>
Subject: [PATCH 35/50] KVM: Add coalesced MMIO support (x86 part)
Date: Thu, 26 Jun 2008 15:28:17 +0300
Message-Id: <1214483312-9265-36-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214483312-9265-1-git-send-email-avi@qumranet.com>
References: <1214483312-9265-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Vivier <Laurent.Vivier@bull.net>

This patch enables coalesced MMIO for x86 architecture.
It defines KVM_MMIO_PAGE_OFFSET and KVM_CAP_COALESCED_MMIO.
It enables the compilation of coalesced_mmio.c.

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/Makefile      |    3 ++-
 arch/x86/kvm/x86.c         |    3 +++
 include/asm-x86/kvm_host.h |    1 +
 3 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index c97d35c..d0e940b 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -2,7 +2,8 @@
 # Makefile for Kernel-based Virtual Machine module
 #
 
-common-objs = $(addprefix ../../../virt/kvm/, kvm_main.o ioapic.o)
+common-objs = $(addprefix ../../../virt/kvm/, kvm_main.o ioapic.o \
+                coalesced_mmio.o)
 ifeq ($(CONFIG_KVM_TRACE),y)
 common-objs += $(addprefix ../../../virt/kvm/, kvm_trace.o)
 endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 00333b6..d568792 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -885,6 +885,9 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_MP_STATE:
 		r = 1;
 		break;
+	case KVM_CAP_COALESCED_MMIO:
+		r = KVM_COALESCED_MMIO_PAGE_OFFSET;
+		break;
 	case KVM_CAP_VAPIC:
 		r = !kvm_x86_ops->cpu_has_accelerated_tpr();
 		break;
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index cd6a4bb..c64d124 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -27,6 +27,7 @@
 #define KVM_PRIVATE_MEM_SLOTS 4
 
 #define KVM_PIO_PAGE_OFFSET 1
+#define KVM_COALESCED_MMIO_PAGE_OFFSET 2
 
 #define CR3_PAE_RESERVED_BITS ((X86_CR3_PWT | X86_CR3_PCD) - 1)
 #define CR3_NONPAE_RESERVED_BITS ((PAGE_SIZE-1) & ~(X86_CR3_PWT | X86_CR3_PCD))
-- 
1.5.6


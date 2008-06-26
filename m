Return-Path: <linux-kernel-owner+w=401wt.eu-S1759132AbYFZMl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759132AbYFZMl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754599AbYFZM3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:29:37 -0400
Received: from il.qumranet.com ([212.179.150.194]:32338 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752847AbYFZM2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:28:44 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Laurent Vivier <Laurent.Vivier@bull.net>
Subject: [PATCH 36/50] KVM: Add coalesced MMIO support (powerpc part)
Date: Thu, 26 Jun 2008 15:28:18 +0300
Message-Id: <1214483312-9265-37-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214483312-9265-1-git-send-email-avi@qumranet.com>
References: <1214483312-9265-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Vivier <Laurent.Vivier@bull.net>

This patch enables coalesced MMIO for powerpc architecture.
It defines KVM_MMIO_PAGE_OFFSET and KVM_CAP_COALESCED_MMIO.
It enables the compilation of coalesced_mmio.c.

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/powerpc/kvm/Makefile      |    2 +-
 arch/powerpc/kvm/powerpc.c     |    3 +++
 include/asm-powerpc/kvm_host.h |    2 ++
 3 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kvm/Makefile b/arch/powerpc/kvm/Makefile
index d0d358d..04e3449 100644
--- a/arch/powerpc/kvm/Makefile
+++ b/arch/powerpc/kvm/Makefile
@@ -4,7 +4,7 @@
 
 EXTRA_CFLAGS += -Ivirt/kvm -Iarch/powerpc/kvm
 
-common-objs = $(addprefix ../../../virt/kvm/, kvm_main.o)
+common-objs = $(addprefix ../../../virt/kvm/, kvm_main.o coalesced_mmio.o)
 
 kvm-objs := $(common-objs) powerpc.o emulate.o booke_guest.o
 obj-$(CONFIG_KVM) += kvm.o
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 0513b35..b850d24 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -145,6 +145,9 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_USER_MEMORY:
 		r = 1;
 		break;
+	case KVM_CAP_COALESCED_MMIO:
+		r = KVM_COALESCED_MMIO_PAGE_OFFSET;
+		break;
 	default:
 		r = 0;
 		break;
diff --git a/include/asm-powerpc/kvm_host.h b/include/asm-powerpc/kvm_host.h
index 81a69d7..2655e2a 100644
--- a/include/asm-powerpc/kvm_host.h
+++ b/include/asm-powerpc/kvm_host.h
@@ -31,6 +31,8 @@
 /* memory slots that does not exposed to userspace */
 #define KVM_PRIVATE_MEM_SLOTS 4
 
+#define KVM_COALESCED_MMIO_PAGE_OFFSET 1
+
 /* We don't currently support large pages. */
 #define KVM_PAGES_PER_HPAGE (1<<31)
 
-- 
1.5.6


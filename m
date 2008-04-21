Return-Path: <linux-kernel-owner+w=401wt.eu-S1760581AbYDUKfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760581AbYDUKfy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 06:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756656AbYDUKaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 06:30:23 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:37887
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987AbYDUKaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 06:30:08 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 21/31] KVM: ppc: Add DCR access information to struct kvm_run
Date: Mon, 21 Apr 2008 13:29:47 +0300
Message-Id: <1208773797-7829-22-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208773797-7829-1-git-send-email-avi@qumranet.com>
References: <1208773797-7829-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

Device Control Registers are essentially another address space found on PowerPC
4xx processors, analogous to PIO on x86. DCRs are always 32 bits, and can be
identified by a 32-bit number. We forward most DCR accesses to userspace for
emulation (with the exception of CPR0 registers, which can be read directly
for simplicity in timebase frequency determination).

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 include/linux/kvm.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index f8e211d..a281afe 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -82,6 +82,7 @@ struct kvm_irqchip {
 #define KVM_EXIT_TPR_ACCESS       12
 #define KVM_EXIT_S390_SIEIC       13
 #define KVM_EXIT_S390_RESET       14
+#define KVM_EXIT_DCR              15
 
 /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
 struct kvm_run {
@@ -161,6 +162,12 @@ struct kvm_run {
 #define KVM_S390_RESET_CPU_INIT  8
 #define KVM_S390_RESET_IPL       16
 		__u64 s390_reset_flags;
+		/* KVM_EXIT_DCR */
+		struct {
+			__u32 dcrn;
+			__u32 data;
+			__u8  is_write;
+		} dcr;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
-- 
1.5.5


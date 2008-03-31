Return-Path: <linux-kernel-owner+w=401wt.eu-S1760562AbYCaOtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760562AbYCaOtq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 10:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753497AbYCaOh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 10:37:56 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:51318
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbYCaOhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 10:37:37 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 37/40] KVM: Add API to retrieve the number of supported vcpus per vm
Date: Mon, 31 Mar 2008 17:37:21 +0300
Message-Id: <1206974244-9716-38-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1206974244-9716-1-git-send-email-avi@qumranet.com>
References: <1206974244-9716-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86.c  |    3 +++
 include/linux/kvm.h |    1 +
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 256c0fc..955d2ee 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -811,6 +811,9 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_VAPIC:
 		r = !kvm_x86_ops->cpu_has_accelerated_tpr();
 		break;
+	case KVM_CAP_NR_VCPUS:
+		r = KVM_MAX_VCPUS;
+		break;
 	default:
 		r = 0;
 		break;
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 94540b3..deb9c38 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -234,6 +234,7 @@ struct kvm_vapic_addr {
 #define KVM_CAP_VAPIC 6
 #define KVM_CAP_EXT_CPUID 7
 #define KVM_CAP_CLOCKSOURCE 8
+#define KVM_CAP_NR_VCPUS 9       /* returns max vcpus per vm */
 
 /*
  * ioctls for VM fds
-- 
1.5.4.5


Return-Path: <linux-kernel-owner+w=401wt.eu-S933277AbXDAOtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933277AbXDAOtA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 10:49:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933158AbXDAOs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 10:48:59 -0400
Received: from il.qumranet.com ([82.166.9.18]:47553 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933143AbXDAOfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 10:35:42 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 12/41] KVM: Add method to check for backwards-compatible API extensions
Date: Sun,  1 Apr 2007 17:35:09 +0300
Message-Id: <1175438139430-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.5
In-Reply-To: <1175438139795-git-send-email-avi@qumranet.com>
References: <1175438138288-git-send-email-avi@qumranet.com> <11754381381990-git-send-email-avi@qumranet.com> <11754381384009-git-send-email-avi@qumranet.com> <1175438138805-git-send-email-avi@qumranet.com> <11754381382515-git-send-email-avi@qumranet.com> <11754381383730-git-send-email-avi@qumranet.com> <11754381383144-git-send-email-avi@qumranet.com> <11754381381597-git-send-email-avi@qumranet.com> <1175438139242-git-send-email-avi@qumranet.com> <1175438139494-git-send-email-avi@qumranet.com> <11754381392046-git-send-email-avi@qumranet.com> <1175438139795-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    6 ++++++
 include/linux/kvm.h    |    5 +++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 5d24203..39cf8fd 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -2416,6 +2416,12 @@ static long kvm_dev_ioctl(struct file *filp,
 		r = 0;
 		break;
 	}
+	case KVM_CHECK_EXTENSION:
+		/*
+		 * No extensions defined at present.
+		 */
+		r = 0;
+		break;
 	default:
 		;
 	}
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 93472da..c93cf53 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -232,6 +232,11 @@ struct kvm_cpuid {
 #define KVM_GET_API_VERSION       _IO(KVMIO,   0x00)
 #define KVM_CREATE_VM             _IO(KVMIO,   0x01) /* returns a VM fd */
 #define KVM_GET_MSR_INDEX_LIST    _IOWR(KVMIO, 0x02, struct kvm_msr_list)
+/*
+ * Check if a kvm extension is available.  Argument is extension number,
+ * return is 1 (yes) or 0 (no, sorry).
+ */
+#define KVM_CHECK_EXTENSION       _IO(KVMIO,   0x03)
 
 /*
  * ioctls for VM fds
-- 
1.5.0.5


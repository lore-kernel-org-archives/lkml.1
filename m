Return-Path: <linux-kernel-owner+w=401wt.eu-S933591AbXCKNyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933591AbXCKNyW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 09:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbXCKNxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 09:53:35 -0400
Received: from il.qumranet.com ([82.166.9.18]:43435 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323AbXCKNxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 09:53:30 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@osdl.org>, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 08/15] KVM: Add method to check for backwards-compatible API extensions
Date: Sun, 11 Mar 2007 15:53:20 +0200
Message-Id: <1173621207256-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.2
In-Reply-To: <11736212072915-git-send-email-avi@qumranet.com>
References: <11736212072915-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    6 ++++++
 include/linux/kvm.h    |    5 +++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 747966e..376538c 100644
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
1.5.0.2


Return-Path: <linux-kernel-owner+w=401wt.eu-S933158AbXDAOuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933158AbXDAOuL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 10:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933257AbXDAOtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 10:49:05 -0400
Received: from il.qumranet.com ([82.166.9.18]:47551 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933140AbXDAOfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 10:35:42 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 10/41] KVM: Remove minor wart from KVM_CREATE_VCPU ioctl
Date: Sun,  1 Apr 2007 17:35:07 +0300
Message-Id: <11754381392046-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.5
In-Reply-To: <1175438139494-git-send-email-avi@qumranet.com>
References: <1175438138288-git-send-email-avi@qumranet.com> <11754381381990-git-send-email-avi@qumranet.com> <11754381384009-git-send-email-avi@qumranet.com> <1175438138805-git-send-email-avi@qumranet.com> <11754381382515-git-send-email-avi@qumranet.com> <11754381383730-git-send-email-avi@qumranet.com> <11754381383144-git-send-email-avi@qumranet.com> <11754381381597-git-send-email-avi@qumranet.com> <1175438139242-git-send-email-avi@qumranet.com> <1175438139494-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

That ioctl does not transfer any data, so it should be an _IO rather than an
_IOW.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 include/linux/kvm.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index c6dd4a7..d89189a 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -241,7 +241,7 @@ struct kvm_cpuid {
  * KVM_CREATE_VCPU receives as a parameter the vcpu slot, and returns
  * a vcpu fd.
  */
-#define KVM_CREATE_VCPU           _IOW(KVMIO, 11, int)
+#define KVM_CREATE_VCPU           _IO(KVMIO, 11)
 #define KVM_GET_DIRTY_LOG         _IOW(KVMIO, 12, struct kvm_dirty_log)
 
 /*
-- 
1.5.0.5


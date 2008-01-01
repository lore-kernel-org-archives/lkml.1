Return-Path: <linux-kernel-owner+w=401wt.eu-S1756402AbYAAPkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402AbYAAPkr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:40:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755289AbYAAPgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:36:33 -0500
Received: from il.qumranet.com ([82.166.9.18]:33788 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754217AbYAAPgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:25 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Jerone Young <jyoung5@us.ibm.com>
Subject: [PATCH 15/54] KVM: Add ifdef in irqchip struct for x86 only structures
Date: Tue,  1 Jan 2008 17:35:41 +0200
Message-Id: <1199201780-14001-16-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jerone Young <jyoung5@us.ibm.com>

This patch fixes a small issue where sturctures:
	kvm_pic_state
	kvm_ioapic_state

are defined inside x86 specific code and may or may not
be defined in anyway for other architectures. The problem
caused is one cannot compile userspace apps (ex. libkvm)
for other archs since a size cannot be determined for these
structures.

Signed-off-by: Jerone Young <jyoung5@us.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 include/linux/Kbuild |    2 +-
 include/linux/kvm.h  |    2 ++
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 9abf5a8..805c2a7 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -98,7 +98,6 @@ header-y += iso_fs.h
 header-y += ixjuser.h
 header-y += jffs2.h
 header-y += keyctl.h
-header-y += kvm.h
 header-y += limits.h
 header-y += lock_dlm_plock.h
 header-y += magic.h
@@ -254,6 +253,7 @@ unifdef-y += kd.h
 unifdef-y += kernelcapi.h
 unifdef-y += kernel.h
 unifdef-y += keyboard.h
+unifdef-y += kvm.h
 unifdef-y += llc.h
 unifdef-y += loop.h
 unifdef-y += lp.h
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index b751552..f0bebd6 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -51,8 +51,10 @@ struct kvm_irqchip {
 	__u32 pad;
         union {
 		char dummy[512];  /* reserving space */
+#ifdef CONFIG_X86
 		struct kvm_pic_state pic;
 		struct kvm_ioapic_state ioapic;
+#endif
 	} chip;
 };
 
-- 
1.5.3.7


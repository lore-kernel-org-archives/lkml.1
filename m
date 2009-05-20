Return-Path: <linux-kernel-owner+w=401wt.eu-S1758175AbZETLY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175AbZETLY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756704AbZETLTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:19:50 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55289 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755751AbZETLSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:18:50 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 20/46] KVM: Make kvm header C++ friendly
Date: Wed, 20 May 2009 14:18:17 +0300
Message-Id: <1242818323-10413-21-git-send-email-avi@redhat.com>
In-Reply-To: <1242818323-10413-1-git-send-email-avi@redhat.com>
References: <1242818323-10413-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: nathan binkert <nate@binkert.org>

Two things needed fixing: 1) g++ does not allow a named structure type
within an anonymous union and 2) Avoid name clash between two padding
fields within the same struct by giving them different names as is
done elsewhere in the header.

Signed-off-by: Nathan Binkert <nate@binkert.org>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 include/linux/kvm.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 644e3a9..3db5d8d 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -119,7 +119,7 @@ struct kvm_run {
 			__u32 error_code;
 		} ex;
 		/* KVM_EXIT_IO */
-		struct kvm_io {
+		struct {
 #define KVM_EXIT_IO_IN  0
 #define KVM_EXIT_IO_OUT 1
 			__u8 direction;
@@ -224,10 +224,10 @@ struct kvm_interrupt {
 /* for KVM_GET_DIRTY_LOG */
 struct kvm_dirty_log {
 	__u32 slot;
-	__u32 padding;
+	__u32 padding1;
 	union {
 		void __user *dirty_bitmap; /* one bit per page */
-		__u64 padding;
+		__u64 padding2;
 	};
 };
 
-- 
1.6.0.6


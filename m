Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458Ab0BMIIm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 03:08:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416Ab0BMICE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 03:02:04 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 23/39] KVM: SVM: Fix SVM_CR0_SELECTIVE_MASK
Date: Sat, 13 Feb 2010 10:01:43 +0200
Message-Id: <1266048119-14325-24-git-send-email-avi@redhat.com>
In-Reply-To: <1266048119-14325-1-git-send-email-avi@redhat.com>
References: <1266048119-14325-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of selecting TS and MP as the comments say, the macro included TS and
PE.  Luckily the macro is unused now, but fix in order to save a few hours of
debugging from anyone who attempts to use it.

Acked-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/svm.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 1fecb7e..38638cd 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -313,7 +313,7 @@ struct __attribute__ ((__packed__)) vmcb {
 
 #define SVM_EXIT_ERR		-1
 
-#define SVM_CR0_SELECTIVE_MASK (1 << 3 | 1) /* TS and MP */
+#define SVM_CR0_SELECTIVE_MASK (X86_CR0_TS | X86_CR0_MP)
 
 #define SVM_VMLOAD ".byte 0x0f, 0x01, 0xda"
 #define SVM_VMRUN  ".byte 0x0f, 0x01, 0xd8"
-- 
1.6.5.3


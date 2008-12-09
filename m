Return-Path: <linux-kernel-owner+w=401wt.eu-S1757435AbYLIUi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435AbYLIUi0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:38:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755511AbYLIUYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:24:38 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34866 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754794AbYLIUXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:23:10 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 26/44] x86: cpu_emergency_svm_disable() function
Date: Tue,  9 Dec 2008 22:22:41 +0200
Message-Id: <1228854179-23002-27-git-send-email-avi@redhat.com>
In-Reply-To: <1228854179-23002-1-git-send-email-avi@redhat.com>
References: <1228854179-23002-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eduardo Habkost <ehabkost@redhat.com>

This function can be used by the reboot or kdump code to forcibly
disable SVM on the CPU.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/virtext.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/virtext.h b/arch/x86/include/asm/virtext.h
index 2cfe363..5936362 100644
--- a/arch/x86/include/asm/virtext.h
+++ b/arch/x86/include/asm/virtext.h
@@ -121,4 +121,12 @@ static inline void cpu_svm_disable(void)
 	wrmsrl(MSR_EFER, efer & ~MSR_EFER_SVME_MASK);
 }
 
+/** Makes sure SVM is disabled, if it is supported on the CPU
+ */
+static inline void cpu_emergency_svm_disable(void)
+{
+	if (cpu_has_svm(NULL))
+		cpu_svm_disable();
+}
+
 #endif /* _ASM_X86_VIRTEX_H */
-- 
1.6.0.3


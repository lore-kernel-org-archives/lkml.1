Return-Path: <linux-kernel-owner+w=401wt.eu-S1758793AbYAAPsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793AbYAAPsp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:48:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754330AbYAAPgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:36:55 -0500
Received: from il.qumranet.com ([82.166.9.18]:33792 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755051AbYAAPg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:29 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 40/54] KVM: SVM: Trap access to the cr8 register
Date: Tue,  1 Jan 2008 17:36:06 +0200
Message-Id: <1199201780-14001-41-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Later we may be able to use the virtual tpr feature, but for now,
just trap it.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/svm.c |    8 ++++++--
 drivers/kvm/svm.h |    1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 8b1cc60..677b525 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -449,11 +449,13 @@ static void init_vmcb(struct vmcb *vmcb)
 
 	control->intercept_cr_read = 	INTERCEPT_CR0_MASK |
 					INTERCEPT_CR3_MASK |
-					INTERCEPT_CR4_MASK;
+					INTERCEPT_CR4_MASK |
+					INTERCEPT_CR8_MASK;
 
 	control->intercept_cr_write = 	INTERCEPT_CR0_MASK |
 					INTERCEPT_CR3_MASK |
-					INTERCEPT_CR4_MASK;
+					INTERCEPT_CR4_MASK |
+					INTERCEPT_CR8_MASK;
 
 	control->intercept_dr_read = 	INTERCEPT_DR0_MASK |
 					INTERCEPT_DR1_MASK |
@@ -1195,10 +1197,12 @@ static int (*svm_exit_handlers[])(struct vcpu_svm *svm,
 	[SVM_EXIT_READ_CR0]           		= emulate_on_interception,
 	[SVM_EXIT_READ_CR3]           		= emulate_on_interception,
 	[SVM_EXIT_READ_CR4]           		= emulate_on_interception,
+	[SVM_EXIT_READ_CR8]           		= emulate_on_interception,
 	/* for now: */
 	[SVM_EXIT_WRITE_CR0]          		= emulate_on_interception,
 	[SVM_EXIT_WRITE_CR3]          		= emulate_on_interception,
 	[SVM_EXIT_WRITE_CR4]          		= emulate_on_interception,
+	[SVM_EXIT_WRITE_CR8]          		= emulate_on_interception,
 	[SVM_EXIT_READ_DR0] 			= emulate_on_interception,
 	[SVM_EXIT_READ_DR1]			= emulate_on_interception,
 	[SVM_EXIT_READ_DR2]			= emulate_on_interception,
diff --git a/drivers/kvm/svm.h b/drivers/kvm/svm.h
index 5fa277c..5fd5049 100644
--- a/drivers/kvm/svm.h
+++ b/drivers/kvm/svm.h
@@ -204,6 +204,7 @@ struct __attribute__ ((__packed__)) vmcb {
 #define INTERCEPT_CR0_MASK 1
 #define INTERCEPT_CR3_MASK (1 << 3)
 #define INTERCEPT_CR4_MASK (1 << 4)
+#define INTERCEPT_CR8_MASK (1 << 8)
 
 #define INTERCEPT_DR0_MASK 1
 #define INTERCEPT_DR1_MASK (1 << 1)
-- 
1.5.3.7


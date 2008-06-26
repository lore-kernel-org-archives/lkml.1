Return-Path: <linux-kernel-owner+w=401wt.eu-S1760690AbYFZMqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760690AbYFZMqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbYFZMaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:30:07 -0400
Received: from il.qumranet.com ([212.179.150.194]:32338 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694AbYFZM2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:28:35 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 05/50] KVM: SVM: implement dedicated INTR exit handler
Date: Thu, 26 Jun 2008 15:27:47 +0300
Message-Id: <1214483312-9265-6-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214483312-9265-1-git-send-email-avi@qumranet.com>
References: <1214483312-9265-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

With an exit handler for INTR intercepts its possible to account them using
kvmtrace.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/svm.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 8a2118b..0eac1a5 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1086,6 +1086,12 @@ static int nmi_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 	return 1;
 }
 
+static int intr_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
+{
+	++svm->vcpu.stat.irq_exits;
+	return 1;
+}
+
 static int nop_on_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 {
 	return 1;
@@ -1369,7 +1375,7 @@ static int (*svm_exit_handlers[])(struct vcpu_svm *svm,
 	[SVM_EXIT_EXCP_BASE + PF_VECTOR] 	= pf_interception,
 	[SVM_EXIT_EXCP_BASE + NM_VECTOR] 	= nm_interception,
 	[SVM_EXIT_EXCP_BASE + MC_VECTOR] 	= mc_interception,
-	[SVM_EXIT_INTR] 			= nop_on_interception,
+	[SVM_EXIT_INTR] 			= intr_interception,
 	[SVM_EXIT_NMI]				= nmi_interception,
 	[SVM_EXIT_SMI]				= nop_on_interception,
 	[SVM_EXIT_INIT]				= nop_on_interception,
-- 
1.5.6


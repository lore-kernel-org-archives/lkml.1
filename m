Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933028Ab0BPKnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 05:43:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932787Ab0BPKfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 05:35:39 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 10/38] KVM: SVM: Trap all debug register accesses
Date: Tue, 16 Feb 2010 12:35:08 +0200
Message-Id: <1266316536-28936-11-git-send-email-avi@redhat.com>
In-Reply-To: <1266316536-28936-1-git-send-email-avi@redhat.com>
References: <1266316536-28936-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

To enable proper debug register emulation under all conditions, trap
access to all DR0..7. This may be optimized later on.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/svm.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 4295dfc..a281368 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -554,13 +554,19 @@ static void init_vmcb(struct vcpu_svm *svm)
 	control->intercept_dr_read = 	INTERCEPT_DR0_MASK |
 					INTERCEPT_DR1_MASK |
 					INTERCEPT_DR2_MASK |
-					INTERCEPT_DR3_MASK;
+					INTERCEPT_DR3_MASK |
+					INTERCEPT_DR4_MASK |
+					INTERCEPT_DR5_MASK |
+					INTERCEPT_DR6_MASK |
+					INTERCEPT_DR7_MASK;
 
 	control->intercept_dr_write = 	INTERCEPT_DR0_MASK |
 					INTERCEPT_DR1_MASK |
 					INTERCEPT_DR2_MASK |
 					INTERCEPT_DR3_MASK |
+					INTERCEPT_DR4_MASK |
 					INTERCEPT_DR5_MASK |
+					INTERCEPT_DR6_MASK |
 					INTERCEPT_DR7_MASK;
 
 	control->intercept_exceptions = (1 << PF_VECTOR) |
@@ -2319,11 +2325,17 @@ static int (*svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_READ_DR1]			= emulate_on_interception,
 	[SVM_EXIT_READ_DR2]			= emulate_on_interception,
 	[SVM_EXIT_READ_DR3]			= emulate_on_interception,
+	[SVM_EXIT_READ_DR4]			= emulate_on_interception,
+	[SVM_EXIT_READ_DR5]			= emulate_on_interception,
+	[SVM_EXIT_READ_DR6]			= emulate_on_interception,
+	[SVM_EXIT_READ_DR7]			= emulate_on_interception,
 	[SVM_EXIT_WRITE_DR0]			= emulate_on_interception,
 	[SVM_EXIT_WRITE_DR1]			= emulate_on_interception,
 	[SVM_EXIT_WRITE_DR2]			= emulate_on_interception,
 	[SVM_EXIT_WRITE_DR3]			= emulate_on_interception,
+	[SVM_EXIT_WRITE_DR4]			= emulate_on_interception,
 	[SVM_EXIT_WRITE_DR5]			= emulate_on_interception,
+	[SVM_EXIT_WRITE_DR6]			= emulate_on_interception,
 	[SVM_EXIT_WRITE_DR7]			= emulate_on_interception,
 	[SVM_EXIT_EXCP_BASE + DB_VECTOR]	= db_interception,
 	[SVM_EXIT_EXCP_BASE + BP_VECTOR]	= bp_interception,
-- 
1.6.5.3


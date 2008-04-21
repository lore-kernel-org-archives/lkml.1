Return-Path: <linux-kernel-owner+w=401wt.eu-S1757574AbYDUKdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574AbYDUKdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 06:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756440AbYDUKaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 06:30:15 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:37889
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753AbYDUKaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 06:30:02 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 10/31] KVM: SVM: do not intercept task switch with NPT
Date: Mon, 21 Apr 2008 13:29:36 +0300
Message-Id: <1208773797-7829-11-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208773797-7829-1-git-send-email-avi@qumranet.com>
References: <1208773797-7829-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

When KVM uses NPT there is no reason to intercept task switches. This patch
removes the intercept for it in that case.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/svm.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index da3ddef..8d04aed 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -591,6 +591,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 	if (npt_enabled) {
 		/* Setup VMCB for Nested Paging */
 		control->nested_ctl = 1;
+		control->intercept &= ~(1ULL << INTERCEPT_TASK_SWITCH);
 		control->intercept_exceptions &= ~(1 << PF_VECTOR);
 		control->intercept_cr_read &= ~(INTERCEPT_CR0_MASK|
 						INTERCEPT_CR3_MASK);
-- 
1.5.5


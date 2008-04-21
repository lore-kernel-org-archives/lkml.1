Return-Path: <linux-kernel-owner+w=401wt.eu-S1761889AbYDUKkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761889AbYDUKkU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 06:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756087AbYDUKan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 06:30:43 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:37897
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756169AbYDUKaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 06:30:10 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 29/31] KVM: SVM: remove selective CR0 comment
Date: Mon, 21 Apr 2008 13:29:55 +0300
Message-Id: <1208773797-7829-30-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208773797-7829-1-git-send-email-avi@qumranet.com>
References: <1208773797-7829-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

There is not selective cr0 intercept bug. The code in the comment sets the
CR0.PG bit. But KVM sets the CR4.PG bit for SVM always to implement the paged
real mode. So the 'mov %eax,%cr0' instruction does not change the CR0.PG bit.
Selective CR0 intercepts only occur when a bit is actually changed. So its the
right behavior that there is no intercept on this instruction.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/svm.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index d643605..89e0be2 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -513,17 +513,6 @@ static void init_vmcb(struct vcpu_svm *svm)
 	control->intercept = 	(1ULL << INTERCEPT_INTR) |
 				(1ULL << INTERCEPT_NMI) |
 				(1ULL << INTERCEPT_SMI) |
-		/*
-		 * selective cr0 intercept bug?
-		 *    	0:   0f 22 d8                mov    %eax,%cr3
-		 *	3:   0f 20 c0                mov    %cr0,%eax
-		 *	6:   0d 00 00 00 80          or     $0x80000000,%eax
-		 *	b:   0f 22 c0                mov    %eax,%cr0
-		 * set cr3 ->interception
-		 * get cr0 ->interception
-		 * set cr0 -> no interception
-		 */
-		/*              (1ULL << INTERCEPT_SELECTIVE_CR0) | */
 				(1ULL << INTERCEPT_CPUID) |
 				(1ULL << INTERCEPT_INVD) |
 				(1ULL << INTERCEPT_HLT) |
-- 
1.5.5


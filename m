Return-Path: <linux-kernel-owner+w=401wt.eu-S1754656AbYLHLkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbYLHLkl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:40:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbYLHLhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:37:24 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48260 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753308AbYLHLhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:37:04 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Amit Shah <amit.shah@redhat.com>
Subject: [PATCH 31/45] KVM: SVM: Set the 'busy' flag of the TR selector
Date: Mon,  8 Dec 2008 13:36:42 +0200
Message-Id: <1228736216-15787-32-git-send-email-avi@redhat.com>
In-Reply-To: <1228736216-15787-1-git-send-email-avi@redhat.com>
References: <1228736216-15787-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amit Shah <amit.shah@redhat.com>

The busy flag of the TR selector is not set by the hardware. This breaks
migration from amd hosts to intel hosts.

Signed-off-by: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 665008d..743aebd 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -781,6 +781,13 @@ static void svm_get_segment(struct kvm_vcpu *vcpu,
 	if (seg == VCPU_SREG_CS)
 		var->g = s->limit > 0xfffff;
 
+	/*
+	 * Work around a bug where the busy flag in the tr selector
+	 * isn't exposed
+	 */
+	if (seg == VCPU_SREG_TR)
+		var->type |= 0x2;
+
 	var->unusable = !var->present;
 }
 
-- 
1.6.0.3


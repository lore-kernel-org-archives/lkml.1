Return-Path: <linux-kernel-owner+w=401wt.eu-S1761278AbYDUKjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761278AbYDUKjK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 06:39:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756753AbYDUKae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 06:30:34 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:37872
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759AbYDUKaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 06:30:06 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 15/31] KVM: SVM: force a new asid when initializing the vmcb
Date: Mon, 21 Apr 2008 13:29:41 +0300
Message-Id: <1208773797-7829-16-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208773797-7829-1-git-send-email-avi@qumranet.com>
References: <1208773797-7829-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shutdown interception clears the vmcb, leaving the asid at zero (which is
illegal.  so force a new asid on vmcb initialization.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/svm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 8d04aed..3379e13 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -603,7 +603,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 		save->cr3 = 0;
 		save->cr4 = 0;
 	}
-
+	force_new_asid(&svm->vcpu);
 }
 
 static int svm_vcpu_reset(struct kvm_vcpu *vcpu)
-- 
1.5.5


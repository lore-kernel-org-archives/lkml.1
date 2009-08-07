Return-Path: <linux-kernel-owner+w=401wt.eu-S1757370AbZHGJyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370AbZHGJyA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 05:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755894AbZHGJua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 05:50:30 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:17605 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755895AbZHGJuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 05:50:08 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KO03BC-04-L8J-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 18/21] kvm/svm: remove unnecessary is_nested check from svm_cpu_run
Date: Fri, 7 Aug 2009 11:49:45 +0200
Message-ID: <1249638588-10982-19-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249638588-10982-1-git-send-email-joerg.roedel@amd.com>
References: <1249638588-10982-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Aug 2009 09:49:51.0233 (UTC) FILETIME=[68865710:01CA1744]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This check is not necessary. We have to sync the vcpu->arch.cr2 always
back to the VMCB. This patch remove the is_nested check.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 1839c19..9a2354d 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2606,8 +2606,7 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	fs_selector = kvm_read_fs();
 	gs_selector = kvm_read_gs();
 	ldt_selector = kvm_read_ldt();
-	if (!is_nested(svm))
-		svm->vmcb->save.cr2 = vcpu->arch.cr2;
+	svm->vmcb->save.cr2 = vcpu->arch.cr2;
 	/* required for live migration with NPT */
 	if (npt_enabled)
 		svm->vmcb->save.cr3 = vcpu->arch.cr3;
-- 
1.6.3.3



Return-Path: <linux-kernel-owner+w=401wt.eu-S1757287AbZHGJur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287AbZHGJur (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 05:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757258AbZHGJup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 05:50:45 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:18900 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755944AbZHGJuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 05:50:11 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KO03BE-03-0WZ-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 20/21] kvm/svm: check for nested VINTR flag in svm_interrupt_allowed
Date: Fri, 7 Aug 2009 11:49:47 +0200
Message-ID: <1249638588-10982-21-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249638588-10982-1-git-send-email-joerg.roedel@amd.com>
References: <1249638588-10982-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Aug 2009 09:49:51.0358 (UTC) FILETIME=[689969E0:01CA1744]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not checking for this flag breaks any nested hypervisor that does not
set VINTR. So fix it with this patch.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 089310d..8b32cc8 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2467,7 +2467,7 @@ static int svm_interrupt_allowed(struct kvm_vcpu *vcpu)
 	return (vmcb->save.rflags & X86_EFLAGS_IF) &&
 		!(vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK) &&
 		gif_set(svm) &&
-		!is_nested(svm);
+		!(is_nested(svm) && (svm->vcpu.arch.hflags & HF_VINTR_MASK));
 }
 
 static void enable_irq_window(struct kvm_vcpu *vcpu)
-- 
1.6.3.3



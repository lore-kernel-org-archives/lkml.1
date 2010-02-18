Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077Ab0BRLwP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 06:52:15 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:55506 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757980Ab0BRLwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 06:52:11 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zz936eMab9bhzz1202hzzz32i6bh87h43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KY1CCG-01-N2O-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 05/10] KVM: SVM: Annotate nested_svm_map with might_sleep()
Date: Thu, 18 Feb 2010 12:38:30 +0100
Message-ID: <1266493115-28386-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1266493115-28386-1-git-send-email-joerg.roedel@amd.com>
References: <1266493115-28386-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 18 Feb 2010 11:38:37.0624 (UTC) FILETIME=[E91BD380:01CAB08E]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The nested_svm_map() function can sleep and must not be
called from atomic context. So annotate that function.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 9a4f9ee..3f59cbd 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1423,6 +1423,8 @@ static void *nested_svm_map(struct vcpu_svm *svm, u64 gpa)
 {
 	struct page *page;
 
+	might_sleep();
+
 	page = gfn_to_page(svm->vcpu.kvm, gpa >> PAGE_SHIFT);
 	if (is_error_page(page))
 		goto error;
-- 
1.6.6



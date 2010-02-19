Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613Ab0BSPXk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 10:23:40 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:3158 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753748Ab0BSPXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 10:23:37 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zz936eMab9bhzz1202hzzz32i87h6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KY3HEV-01-M8S-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 05/11] KVM: SVM: Annotate nested_svm_map with might_sleep()
Date: Fri, 19 Feb 2010 16:23:04 +0100
Message-ID: <1266592990-8911-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1266592990-8911-1-git-send-email-joerg.roedel@amd.com>
References: <1266592990-8911-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 19 Feb 2010 15:23:12.0871 (UTC) FILETIME=[73651770:01CAB177]
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
index c9d359a..4becefd 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1429,6 +1429,8 @@ static void *nested_svm_map(struct vcpu_svm *svm, u64 gpa, struct page **_page)
 {
 	struct page *page;
 
+	might_sleep();
+
 	page = gfn_to_page(svm->vcpu.kvm, gpa >> PAGE_SHIFT);
 	if (is_error_page(page))
 		goto error;
-- 
1.6.6



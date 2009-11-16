Return-Path: <linux-kernel-owner+w=401wt.eu-S1753599AbZKPM1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599AbZKPM1s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 07:27:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbZKPMT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 07:19:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911AbZKPMTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 07:19:42 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 22/42] KVM: SVM: remove needless mmap_sem acquision from nested_svm_map
Date: Mon, 16 Nov 2009 14:19:23 +0200
Message-Id: <1258373983-8693-23-git-send-email-avi@redhat.com>
In-Reply-To: <1258373983-8693-1-git-send-email-avi@redhat.com>
References: <1258373983-8693-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

nested_svm_map unnecessarily takes mmap_sem around gfn_to_page, since
gfn_to_page / get_user_pages are responsible for it.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Acked-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 92048a6..f54c4f9 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1396,10 +1396,7 @@ static void *nested_svm_map(struct vcpu_svm *svm, u64 gpa, enum km_type idx)
 {
 	struct page *page;
 
-	down_read(&current->mm->mmap_sem);
 	page = gfn_to_page(svm->vcpu.kvm, gpa >> PAGE_SHIFT);
-	up_read(&current->mm->mmap_sem);
-
 	if (is_error_page(page))
 		goto error;
 
-- 
1.6.5.2


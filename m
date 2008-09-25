Return-Path: <linux-kernel-owner+w=401wt.eu-S1754748AbYIYLzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbYIYLzd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 07:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbYIYLzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 07:55:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48512 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752912AbYIYLzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 07:55:18 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Sheng Yang <sheng.yang@intel.com>
Subject: [PATCH 01/39] KVM: VMX: Clean up magic number 0x66 in init_rmode_tss
Date: Thu, 25 Sep 2008 14:54:33 +0300
Message-Id: <1222343711-12508-2-git-send-email-avi@redhat.com>
In-Reply-To: <1222343711-12508-1-git-send-email-avi@redhat.com>
References: <1222343711-12508-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng.yang@intel.com>

Signed-off-by: Sheng Yang <sheng.yang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/vmx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index ddb49e3..229e2d0 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1732,7 +1732,8 @@ static int init_rmode_tss(struct kvm *kvm)
 	if (r < 0)
 		goto out;
 	data = TSS_BASE_SIZE + TSS_REDIRECTION_SIZE;
-	r = kvm_write_guest_page(kvm, fn++, &data, 0x66, sizeof(u16));
+	r = kvm_write_guest_page(kvm, fn++, &data,
+			TSS_IOPB_BASE_OFFSET, sizeof(u16));
 	if (r < 0)
 		goto out;
 	r = kvm_clear_guest_page(kvm, fn++, 0, PAGE_SIZE);
-- 
1.6.0.1


Return-Path: <linux-kernel-owner+w=401wt.eu-S1762004AbXFQJ6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762004AbXFQJ6p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 05:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759672AbXFQJpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:45:32 -0400
Received: from il.qumranet.com ([82.166.9.18]:55166 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759466AbXFQJou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:50 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Shani Moideen <shani.moideen@wipro.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 56/58] KVM: VMX: Replace memset(<addr>, 0, PAGESIZE) with clear_page(<addr>)
Date: Sun, 17 Jun 2007 12:44:37 +0300
Message-Id: <11820734822030-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shani Moideen <shani.moideen@wipro.com>

Signed-off-by: Shani Moideen <shani.moideen@wipro.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index b969db1..b909b54 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1180,16 +1180,16 @@ static int init_rmode_tss(struct kvm* kvm)
 	}
 
 	page = kmap_atomic(p1, KM_USER0);
-	memset(page, 0, PAGE_SIZE);
+	clear_page(page);
 	*(u16*)(page + 0x66) = TSS_BASE_SIZE + TSS_REDIRECTION_SIZE;
 	kunmap_atomic(page, KM_USER0);
 
 	page = kmap_atomic(p2, KM_USER0);
-	memset(page, 0, PAGE_SIZE);
+	clear_page(page);
 	kunmap_atomic(page, KM_USER0);
 
 	page = kmap_atomic(p3, KM_USER0);
-	memset(page, 0, PAGE_SIZE);
+	clear_page(page);
 	*(page + RMODE_TSS_SIZE - 2 * PAGE_SIZE - 1) = ~0;
 	kunmap_atomic(page, KM_USER0);
 
-- 
1.5.0.6


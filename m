Return-Path: <linux-kernel-owner+w=401wt.eu-S1765851AbZDHOLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765851AbZDHOLt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 10:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933361AbZDHOKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 10:10:40 -0400
Received: from gate.crashing.org ([63.228.1.57]:59962 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933338AbZDHOKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 10:10:38 -0400
From: Kumar Gala <galak@kernel.crashing.org>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, jeremy@goop.org,
       fujita.tomonori@lab.ntt.co.jp, ian.campbell@citrix.com
Cc: beckyb@kernel.crashing.org
Subject: [PATCH 2/7] swiotlb: fix compile warning
Date: Wed,  8 Apr 2009 09:09:16 -0500
Message-Id: <1239199761-22886-3-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1239199761-22886-2-git-send-email-galak@kernel.crashing.org>
References: <1239199761-22886-1-git-send-email-galak@kernel.crashing.org>
 <1239199761-22886-2-git-send-email-galak@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Becky Bruce <beckyb@kernel.crashing.org>

Squash a build warning seen on 32-bit powerpc caused by calling min()
with 2 different types. Use min_t() instead

Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---
 lib/swiotlb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 170cf56..4fd6a76 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -341,7 +341,7 @@ static void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
 		unsigned long flags;
 
 		while (size) {
-			sz = min(PAGE_SIZE - offset, size);
+			sz = min_t(size_t, PAGE_SIZE - offset, size);
 
 			local_irq_save(flags);
 			buffer = kmap_atomic(pfn_to_page(pfn),
-- 
1.6.0.6


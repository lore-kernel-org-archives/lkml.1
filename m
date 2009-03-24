Return-Path: <linux-kernel-owner+w=401wt.eu-S1752261AbZCXVpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261AbZCXVpU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 17:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754266AbZCXVo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 17:44:26 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:34830 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbZCXVoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 17:44:25 -0400
From: Becky Bruce <beckyb@kernel.crashing.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fujita.tomonori@lab.ntt.co.jp, ian.campbell@citrix.com,
       jeremy@goop.org, Becky Bruce <beckyb@kernel.crashing.org>
Subject: [PATCH 2/5] swiotlb: fix compile warning
Date: Tue, 24 Mar 2009 16:28:43 -0500
Message-Id: <1237930126-6741-3-git-send-email-beckyb@kernel.crashing.org>
X-Mailer: git-send-email 1.5.6.6
In-Reply-To: <1237930126-6741-2-git-send-email-beckyb@kernel.crashing.org>
References: <1237930126-6741-1-git-send-email-beckyb@kernel.crashing.org>
 <1237930126-6741-2-git-send-email-beckyb@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Squash a build warning seen on 32-bit powerpc caused by calling min()
with 2 different types.  Cast the first arg to size_t, which is the
type of the second, and should be portable across architectures.

Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
---
 lib/swiotlb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index f59cf30..62f5f75 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -341,7 +341,7 @@ static void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
 		unsigned long flags;
 
 		while (size) {
-			sz = min(PAGE_SIZE - offset, size);
+			sz = min((size_t)(PAGE_SIZE - offset), size);
 
 			local_irq_save(flags);
 			buffer = kmap_atomic(pfn_to_page(pfn),
-- 
1.5.6.6


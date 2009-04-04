Return-Path: <linux-kernel-owner+w=401wt.eu-S937776AbZDDCA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937776AbZDDCA3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 22:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765234AbZDDB5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 21:57:53 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:64900 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937414AbZDDB5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 21:57:50 -0400
From: Becky Bruce <beckyb@kernel.crashing.org>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, jeremy@goop.org,
       fujita.tomonori@lab.ntt.co.jp, ian.campbell@citrix.com
Cc: Becky Bruce <beckyb@kernel.crashing.org>
Subject: [PATCH 2/7] swiotlb: fix compile warning
Date: Fri,  3 Apr 2009 20:56:44 -0500
Message-Id: <1238810209-24499-3-git-send-email-beckyb@kernel.crashing.org>
X-Mailer: git-send-email 1.5.6.6
In-Reply-To: <1238810209-24499-2-git-send-email-beckyb@kernel.crashing.org>
References: <1238810209-24499-1-git-send-email-beckyb@kernel.crashing.org>
 <1238810209-24499-2-git-send-email-beckyb@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Squash a build warning seen on 32-bit powerpc caused by calling min()
with 2 different types. Use min_t() instead

Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
---
 lib/swiotlb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index f59cf30..fa62498 100644
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
1.5.6.6


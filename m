Return-Path: <linux-kernel-owner+w=401wt.eu-S1762045AbYDPMde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762045AbYDPMde (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 08:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753969AbYDPMdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 08:33:24 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:59882 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbYDPMdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 08:33:24 -0400
From: Duck <duck@freescale.com>
To: linux-kernel@vger.kernel.org
Cc: Bruce Schmid <duck@freescale.com>, Dean Nelson <dcn@sgi.com>
Subject: [PATCH] generic pool allocator: allow all chunks to be allocated.
Date: Wed, 16 Apr 2008 06:33:10 -0600
Message-Id: <1208349190-9650-1-git-send-email-duck@freescale.com>
X-Mailer: git-send-email 1.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bruce Schmid <duck@freescale.com>


gen_pool_alloc() doesn't allocate the last chunk in a pool.
This patch fixes that problem by correcting the calculation
of the number of the last bit in the bitmap.

Cc: Dean Nelson <dcn@sgi.com>
Signed-off-by: Bruce Schmid <duck@freescale.com>
---
 lib/genalloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/genalloc.c b/lib/genalloc.c
index f6d276d..ac00492 100644
--- a/lib/genalloc.c
+++ b/lib/genalloc.c
@@ -127,7 +127,7 @@ unsigned long gen_pool_alloc(struct gen_pool *pool, size_t size)
 		chunk = list_entry(_chunk, struct gen_pool_chunk, next_chunk);
 
 		end_bit = (chunk->end_addr - chunk->start_addr) >> order;
-		end_bit -= nbits + 1;
+		end_bit -= (nbits - 1);
 
 		spin_lock_irqsave(&chunk->lock, flags);
 		bit = -1;
-- 
1.5.4


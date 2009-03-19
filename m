Return-Path: <linux-kernel-owner+w=401wt.eu-S1757872AbZCSBkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872AbZCSBkV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 21:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756368AbZCSBjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 21:39:53 -0400
Received: from sh.osrg.net ([192.16.179.4]:40786 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757208AbZCSBjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 21:39:52 -0400
Date: Thu, 19 Mar 2009 10:39:31 +0900
To: mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, joerg.roedel@amd.com
Subject: [PATCH -tip] dma-debug: warn of unmapping an invalid dma address
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090319103743N.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 19 Mar 2009 10:39:31 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling dma_unmap families against an invalid dma address should be a
bug.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 lib/dma-debug.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 9a350b4..f9e6d38 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -531,8 +531,11 @@ static void check_unmap(struct dma_debug_entry *ref)
 	struct hash_bucket *bucket;
 	unsigned long flags;
 
-	if (dma_mapping_error(ref->dev, ref->dev_addr))
+	if (dma_mapping_error(ref->dev, ref->dev_addr)) {
+		err_printk(ref->dev, NULL, "DMA-API: device driver tries "
+			   "to free an invalid DMA memory address\n");
 		return;
+	}
 
 	bucket = get_hash_bucket(ref, &flags);
 	entry = hash_bucket_find(bucket, ref);
-- 
1.6.0.6


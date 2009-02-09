Return-Path: <linux-kernel-owner+w=401wt.eu-S1755434AbZBIMUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbZBIMUv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 07:20:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754089AbZBIMUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 07:20:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39238 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753388AbZBIMUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 07:20:42 -0500
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: linux-kernel@vger.kernel.org
Subject: [PATCH] check bh->b_blocknr only if BH_Mapped is set
Date: Mon, 9 Feb 2009 17:48:11 +0530
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-9-default; KDE/4.1.3; x86_64; ; )
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902091748.12545.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

check bh->b_blocknr only if BH_Mapped is set

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/fs/buffer.c b/fs/buffer.c
index 665d446..782c365 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -344,13 +344,13 @@ __find_get_block_slow(struct block_device *bdev, 
sector_t block)
 	head = page_buffers(page);
 	bh = head;
 	do {
-		if (bh->b_blocknr == block) {
+		if (!buffer_mapped(bh))
+			all_mapped = 0;
+		else if (bh->b_blocknr == block) {
 			ret = bh;
 			get_bh(bh);
 			goto out_unlock;
 		}
-		if (!buffer_mapped(bh))
-			all_mapped = 0;
 		bh = bh->b_this_page;
 	} while (bh != head);
 


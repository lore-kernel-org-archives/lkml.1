Return-Path: <linux-kernel-owner+w=401wt.eu-S1751517AbZL3DfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517AbZL3DfI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 22:35:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751271AbZL3DfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 22:35:06 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56605 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbZL3DfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 22:35:04 -0500
Message-ID: <4B3AC945.3090304@cn.fujitsu.com>
Date: Wed, 30 Dec 2009 11:30:13 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: [PATCH] block: blk_rq_err_sectors cleanup
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk_rq_err_sectors() seems useless, get rid of it.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 include/linux/blkdev.h |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 221cecd..fcbb9e2 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -843,7 +843,6 @@ static inline void blk_run_address_space(struct address_space *mapping)
  * blk_rq_err_bytes()		: bytes left till the next error boundary
  * blk_rq_sectors()		: sectors left in the entire request
  * blk_rq_cur_sectors()		: sectors left in the current segment
- * blk_rq_err_sectors()		: sectors left till the next error boundary
  */
 static inline sector_t blk_rq_pos(const struct request *rq)
 {
@@ -872,11 +871,6 @@ static inline unsigned int blk_rq_cur_sectors(const struct request *rq)
 	return blk_rq_cur_bytes(rq) >> 9;
 }
 
-static inline unsigned int blk_rq_err_sectors(const struct request *rq)
-{
-	return blk_rq_err_bytes(rq) >> 9;
-}
-
 /*
  * Request issue related functions.
  */
-- 
1.5.4.rc3


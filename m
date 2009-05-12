Return-Path: <linux-kernel-owner+w=401wt.eu-S1760729AbZELLdE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760729AbZELLdE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 07:33:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759324AbZELLch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 07:32:37 -0400
Received: from sh.osrg.net ([192.16.179.4]:49848 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757173AbZELLcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 07:32:36 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: jens.axboe@oracle.com
Cc: tj@kernel.org, linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] swim3: use blk_end_request_all when we hit the maximum retry count
Date: Tue, 12 May 2009 20:29:46 +0900
Message-Id: <1242127787-29842-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1242127787-29842-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1242127787-29842-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 12 May 2009 20:31:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like we need to use blk_end_request_all() when we hit the maximum
retry count.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/block/swim3.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/block/swim3.c b/drivers/block/swim3.c
index 80df93e..116d169 100644
--- a/drivers/block/swim3.c
+++ b/drivers/block/swim3.c
@@ -737,7 +737,8 @@ static irqreturn_t swim3_interrupt(int irq, void *dev_id)
 				printk("swim3: error %sing block %ld (err=%x)\n",
 				       rq_data_dir(fd_req) == WRITE? "writ": "read",
 				       (long)blk_rq_pos(fd_req), err);
-				swim3_end_request_cur(-EIO);
+				blk_end_request_all(fd_req, -EIO);
+				fd_req = NULL;
 				fs->state = idle;
 			}
 		} else {
-- 
1.6.0.6


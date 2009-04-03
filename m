Return-Path: <linux-kernel-owner+w=401wt.eu-S1764759AbZDCNGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764759AbZDCNGX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 09:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755226AbZDCNFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 09:05:43 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:55657 "EHLO
	pophost.sonytel.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752574AbZDCNFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 09:05:42 -0400
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       cbe-oss-dev@ozlabs.org,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH] ps3vram: Fix error path (return -EIO) for short read/write
Date: Fri,  3 Apr 2009 15:05:35 +0200
Message-Id: <1238763938-7076-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 drivers/block/ps3vram.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/block/ps3vram.c b/drivers/block/ps3vram.c
index 8eddef3..2e79d2c 100644
--- a/drivers/block/ps3vram.c
+++ b/drivers/block/ps3vram.c
@@ -585,6 +585,7 @@ static int ps3vram_make_request(struct request_queue *q, struct bio *bio)
 
 		if (retlen != len) {
 			dev_err(&dev->core, "Short %s\n", op);
+			error = -EIO;
 			goto out;
 		}
 
-- 
1.6.0.4


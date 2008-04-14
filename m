Return-Path: <linux-kernel-owner+w=401wt.eu-S1762258AbYDNOYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762258AbYDNOYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 10:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761617AbYDNOVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 10:21:33 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:41397 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761611AbYDNOV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 10:21:29 -0400
Date: Mon, 14 Apr 2008 17:20:24 +0300
From: Adrian Bunk <bunk@kernel.org>
To: dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] mtd/ftl.c: make code static
Message-ID: <20080414142024.GS6695@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the following needlessly global code static:
- ftl_freepart()
- struct ftl_tr

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/mtd/ftl.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

febd03449dbd4d03eb0e9a73b47815c9a63255b9 diff --git a/drivers/mtd/ftl.c b/drivers/mtd/ftl.c
index c815d0f..4a79b18 100644
--- a/drivers/mtd/ftl.c
+++ b/drivers/mtd/ftl.c
@@ -136,8 +136,6 @@ typedef struct partition_t {
 #endif
 } partition_t;
 
-void ftl_freepart(partition_t *part);
-
 /* Partition state flags */
 #define FTL_FORMATTED	0x01
 
@@ -1014,7 +1012,7 @@ static int ftl_writesect(struct mtd_blktrans_dev *dev,
 
 /*====================================================================*/
 
-void ftl_freepart(partition_t *part)
+static void ftl_freepart(partition_t *part)
 {
 	vfree(part->VirtualBlockMap);
 	part->VirtualBlockMap = NULL;
@@ -1069,7 +1067,7 @@ static void ftl_remove_dev(struct mtd_blktrans_dev *dev)
 	kfree(dev);
 }
 
-struct mtd_blktrans_ops ftl_tr = {
+static struct mtd_blktrans_ops ftl_tr = {
 	.name		= "ftl",
 	.major		= FTL_MAJOR,
 	.part_bits	= PART_BITS,


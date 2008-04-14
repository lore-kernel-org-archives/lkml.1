Return-Path: <linux-kernel-owner+w=401wt.eu-S1762053AbYDNOZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762053AbYDNOZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 10:25:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761652AbYDNOVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 10:21:42 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:41410 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760868AbYDNOVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 10:21:41 -0400
Date: Mon, 14 Apr 2008 17:20:36 +0300
From: Adrian Bunk <bunk@kernel.org>
To: dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] mtd: make onenand_scan_bbt() static
Message-ID: <20080414142036.GU6695@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global onenand_scan_bbt() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/mtd/onenand/onenand_bbt.c |    3 +--
 include/linux/mtd/bbm.h           |    1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

c54bdc9336c6627a6baa5d268edb41563451f191 diff --git a/drivers/mtd/onenand/onenand_bbt.c b/drivers/mtd/onenand/onenand_bbt.c
index aecdd50..1d590cd 100644
--- a/drivers/mtd/onenand/onenand_bbt.c
+++ b/drivers/mtd/onenand/onenand_bbt.c
@@ -175,7 +175,7 @@ static int onenand_isbad_bbt(struct mtd_info *mtd, loff_t offs, int allowbbt)
  * by the onenand_release function.
  *
  */
-int onenand_scan_bbt(struct mtd_info *mtd, struct nand_bbt_descr *bd)
+static int onenand_scan_bbt(struct mtd_info *mtd, struct nand_bbt_descr *bd)
 {
 	struct onenand_chip *this = mtd->priv;
 	struct bbm_info *bbm = this->bbm;
@@ -246,5 +246,4 @@ int onenand_default_bbt(struct mtd_info *mtd)
 	return onenand_scan_bbt(mtd, bbm->badblock_pattern);
 }
 
-EXPORT_SYMBOL(onenand_scan_bbt);
 EXPORT_SYMBOL(onenand_default_bbt);
diff --git a/include/linux/mtd/bbm.h b/include/linux/mtd/bbm.h
index fff8c53..0c07c7a 100644
--- a/include/linux/mtd/bbm.h
+++ b/include/linux/mtd/bbm.h
@@ -126,7 +126,6 @@ struct bbm_info {
 };
 
 /* OneNAND BBT interface */
-extern int onenand_scan_bbt(struct mtd_info *mtd, struct nand_bbt_descr *bd);
 extern int onenand_default_bbt(struct mtd_info *mtd);
 
 #endif	/* __LINUX_MTD_BBM_H */


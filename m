Return-Path: <linux-kernel-owner+w=401wt.eu-S1758964AbYDNOXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758964AbYDNOXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 10:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761268AbYDNOVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 10:21:08 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:41375 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761106AbYDNOVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 10:21:05 -0400
Date: Mon, 14 Apr 2008 17:20:00 +0300
From: Adrian Bunk <bunk@kernel.org>
To: dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] mtd: proper prototypes for nftl_{read,write}_oob()
Message-ID: <20080414142000.GP6695@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds proper prototypes for nftl_{read,write}_oob() in 
include/linux/mtd/nftl.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/mtd/nftlmount.c  |    5 -----
 include/linux/mtd/nftl.h |    5 +++++
 2 files changed, 5 insertions(+), 5 deletions(-)

b716491528ee42a150415b8ac133b06545ef66ec diff --git a/drivers/mtd/nftlmount.c b/drivers/mtd/nftlmount.c
index 0513cbc..345e6ef 100644
--- a/drivers/mtd/nftlmount.c
+++ b/drivers/mtd/nftlmount.c
@@ -33,11 +33,6 @@
 
 char nftlmountrev[]="$Revision: 1.41 $";
 
-extern int nftl_read_oob(struct mtd_info *mtd, loff_t offs, size_t len,
-			 size_t *retlen, uint8_t *buf);
-extern int nftl_write_oob(struct mtd_info *mtd, loff_t offs, size_t len,
-			  size_t *retlen, uint8_t *buf);
-
 /* find_boot_record: Find the NFTL Media Header and its Spare copy which contains the
  *	various device information of the NFTL partition and Bad Unit Table. Update
  *	the ReplUnitTable[] table accroding to the Bad Unit Table. ReplUnitTable[]
diff --git a/include/linux/mtd/nftl.h b/include/linux/mtd/nftl.h
index bcf2fb3..001eec5 100644
--- a/include/linux/mtd/nftl.h
+++ b/include/linux/mtd/nftl.h
@@ -43,6 +43,11 @@ struct NFTLrecord {
 int NFTL_mount(struct NFTLrecord *s);
 int NFTL_formatblock(struct NFTLrecord *s, int block);
 
+int nftl_read_oob(struct mtd_info *mtd, loff_t offs, size_t len,
+		  size_t *retlen, uint8_t *buf);
+int nftl_write_oob(struct mtd_info *mtd, loff_t offs, size_t len,
+		   size_t *retlen, uint8_t *buf);
+
 #ifndef NFTL_MAJOR
 #define NFTL_MAJOR 93
 #endif


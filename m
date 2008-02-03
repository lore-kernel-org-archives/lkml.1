Return-Path: <linux-kernel-owner+w=401wt.eu-S935989AbYBCCHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935989AbYBCCHq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 21:07:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932217AbYBCCHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 21:07:36 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62211 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753947AbYBCCHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 21:07:35 -0500
Message-ID: <47A521B5.9020007@cn.fujitsu.com>
Date: Sun, 03 Feb 2008 10:06:45 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: dwmw2@infradead.org
CC: linux-mtd@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] MTD/NAND: fix a compile warning in plat_nand_remove
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With CONFIG_MTD_PARTITIONS not set, got this:
drivers/mtd/nand/plat_nand.c:113: warning: unused variable 'pdata'

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 drivers/mtd/nand/plat_nand.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/nand/plat_nand.c b/drivers/mtd/nand/plat_nand.c
index cd725fc..f6d5c2a 100644
--- a/drivers/mtd/nand/plat_nand.c
+++ b/drivers/mtd/nand/plat_nand.c
@@ -110,7 +110,9 @@ out:
 static int __devexit plat_nand_remove(struct platform_device *pdev)
 {
 	struct plat_nand_data *data = platform_get_drvdata(pdev);
+#ifdef CONFIG_MTD_PARTITIONS
 	struct platform_nand_data *pdata = pdev->dev.platform_data;
+#endif
 
 	nand_release(&data->mtd);
 #ifdef CONFIG_MTD_PARTITIONS
-- 
1.5.4.rc3


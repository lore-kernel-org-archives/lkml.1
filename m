Return-Path: <linux-kernel-owner+w=401wt.eu-S1031618AbXHMNjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031618AbXHMNjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968996AbXHMJ5B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 05:57:01 -0400
Received: from wip-cdc-wd.wipro.com ([203.91.201.26]:42604 "EHLO
	wip-cdc-wd.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759398AbXHMJ47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 05:56:59 -0400
Subject: [KJ] replacing kmalloc with kzalloc in
	drivers/mtd/devices/docprobe.c
From: Surya Prabhakar N <surya.prabhakar@wipro.com>
Reply-To: surya.prabhakar@wipro.com
To: dwmw2@infradead.org, linux-mtd@lists.infradead.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       kernel-janitors <kernel-janitors@lists.osdl.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Linux Coe, Wipro Technologies
Date: Mon, 13 Aug 2007 15:26:32 +0530
Message-Id: <1186998992.29518.15.camel@bluegenie>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
X-OriginalArrivalTime: 13 Aug 2007 09:57:10.0622 (UTC) FILETIME=[50EF07E0:01C7DD90]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
   Replacing kmalloc with kzalloc and cleaning up memset in
drivers/mtd/devices/docprobe.c.


Signed-off-by: Surya Prabhakar <surya.prabhakar@wipro.com>
---

diff --git a/drivers/mtd/devices/docprobe.c b/drivers/mtd/devices/docprobe.c
index 54aa759..53be397 100644
--- a/drivers/mtd/devices/docprobe.c
+++ b/drivers/mtd/devices/docprobe.c
@@ -254,7 +254,7 @@ static void __init DoC_Probe(unsigned long physadr)
 			return;
 		}
 		docfound = 1;
-		mtd = kmalloc(sizeof(struct DiskOnChip) + sizeof(struct mtd_info), GFP_KERNEL);
+		mtd = kzalloc(sizeof(struct DiskOnChip) + sizeof(struct mtd_info), GFP_KERNEL);
 
 		if (!mtd) {
 			printk(KERN_WARNING "Cannot allocate memory for data structures. Dropping.\n");
@@ -264,9 +264,6 @@ static void __init DoC_Probe(unsigned long physadr)
 
 		this = (struct DiskOnChip *)(&mtd[1]);
 
-		memset((char *)mtd,0, sizeof(struct mtd_info));
-		memset((char *)this, 0, sizeof(struct DiskOnChip));
-
 		mtd->priv = this;
 		this->virtadr = docptr;
 		this->physadr = physadr;

--
thanks
surya.

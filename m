Return-Path: <linux-kernel-owner+w=401wt.eu-S1761907AbZDJMoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761907AbZDJMoW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 08:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754849AbZDJMoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 08:44:08 -0400
Received: from ti-out-0910.google.com ([209.85.142.190]:14245 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757752AbZDJMoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 08:44:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :user-agent;
        b=by7+Ev5MxWgF8RuoE+9vFKQ4J3bNb1/uU3AbTWsCg+O4B4bigDcxciBL4isatNe7b2
         vXAMbY5K58vhkNQk1PXqWwONdnU+k23FZ0O8I7ttqH4NKGUt8LhTprsOJEgsGh9au5S3
         HPayN1E54fHCFkBRgCgFtSI0pWAH8WvpwjBWA=
Date: Fri, 10 Apr 2009 20:42:43 +0800
From: Zhenwen Xu <helight.xu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, linux-mtd@lists.infradead.org
Subject: [PATCH]fix a warning on drivers/mtd/nand/cafe_nand.c
Message-ID: <20090410124243.GA9852@helight>
Reply-To: Zhenwen Xu <helight.xu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix this warning:

drivers/mtd/nand/cafe_nand.c: In function ‘cafe_nand_probe’:
drivers/mtd/nand/cafe_nand.c:730: warning: passing argument 2 of ‘request_irq’ from incompatible pointer type


>From 8f877dd15fedd434e2f5d95a1bc5f4e528dc4528 Mon Sep 17 00:00:00 2001
From: Zhenwen Xu <Helight.Xu@gmail.com>
Date: Fri, 10 Apr 2009 20:35:30 +0800
Subject: [PATCH] fix a warning on drivers/mtd/nand/cafe_nand.c

Signed-off-by: Zhenwen Xu <helight.xu@gmail.com>
---
 drivers/mtd/nand/cafe_nand.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/cafe_nand.c b/drivers/mtd/nand/cafe_nand.c
index 7c5b257..29acd06 100644
--- a/drivers/mtd/nand/cafe_nand.c
+++ b/drivers/mtd/nand/cafe_nand.c
@@ -332,7 +332,7 @@ static void cafe_select_chip(struct mtd_info *mtd, int chipnr)
 		cafe->ctl1 &= ~CTRL1_CHIPSELECT;
 }
 
-static int cafe_nand_interrupt(int irq, void *id)
+static irqreturn_t cafe_nand_interrupt(int irq, void *id)
 {
 	struct mtd_info *mtd = id;
 	struct cafe_priv *cafe = mtd->priv;
-- 
1.5.6.5

-- 
---------------------------------
Zhenwen Xu - Open and Free
Home Page:	http://zhwen.org
My Studio:	http://dim4.cn


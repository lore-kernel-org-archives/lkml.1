Return-Path: <linux-kernel-owner+w=401wt.eu-S1759192AbXJDEO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759192AbXJDEO5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 00:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758421AbXJDEOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 00:14:34 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:50881 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758345AbXJDEOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 00:14:32 -0400
Date: Wed, 03 Oct 2007 22:13:23 -0600
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 2/3] Sysace: sparse fixes
In-reply-to: <20071004041114.20868.34605.stgit@trillian.cg.shawcable.net>
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Message-id: <20071004041323.20868.70997.stgit@trillian.cg.shawcable.net>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
References: <20071004041114.20868.34605.stgit@trillian.cg.shawcable.net>
User-Agent: StGIT/0.12.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 drivers/block/xsysace.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index 3847464..5b73471 100644
--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -195,7 +195,7 @@ struct ace_device {
 
 	/* Details of hardware device */
 	unsigned long physaddr;
-	void *baseaddr;
+	void __iomem *baseaddr;
 	int irq;
 	int bus_width;		/* 0 := 8 bit; 1 := 16 bit */
 	struct ace_reg_ops *reg_ops;
@@ -227,20 +227,20 @@ struct ace_reg_ops {
 /* 8 Bit bus width */
 static u16 ace_in_8(struct ace_device *ace, int reg)
 {
-	void *r = ace->baseaddr + reg;
+	void __iomem *r = ace->baseaddr + reg;
 	return in_8(r) | (in_8(r + 1) << 8);
 }
 
 static void ace_out_8(struct ace_device *ace, int reg, u16 val)
 {
-	void *r = ace->baseaddr + reg;
+	void __iomem *r = ace->baseaddr + reg;
 	out_8(r, val);
 	out_8(r + 1, val >> 8);
 }
 
 static void ace_datain_8(struct ace_device *ace)
 {
-	void *r = ace->baseaddr + 0x40;
+	void __iomem *r = ace->baseaddr + 0x40;
 	u8 *dst = ace->data_ptr;
 	int i = ACE_FIFO_SIZE;
 	while (i--)
@@ -250,7 +250,7 @@ static void ace_datain_8(struct ace_device *ace)
 
 static void ace_dataout_8(struct ace_device *ace)
 {
-	void *r = ace->baseaddr + 0x40;
+	void __iomem *r = ace->baseaddr + 0x40;
 	u8 *src = ace->data_ptr;
 	int i = ACE_FIFO_SIZE;
 	while (i--)


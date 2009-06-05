Return-Path: <linux-kernel-owner+w=401wt.eu-S1754570AbZFEQbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbZFEQbu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 12:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755303AbZFEQaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 12:30:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:63228 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755588AbZFEQaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 12:30:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JfsKOVSXXFV6NFeMYCElCuTpxvGJo+nNs6fY8l8u/s0MH/ugVNY2cm2/QAWGDUpYm7
         GfcZcI25WdBq1MO1lW9hdAGxmRT22//GzFalLue4NR5esqRg+dbwMQ1I52096e5igq3o
         HFJ/QglPq/sbOKmLYXSlwDSUzXYBNWp+b16Mo=
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH 4/7] MFD: ASIC3: use resource_size macro instead of local variable
Date: Fri,  5 Jun 2009 18:31:04 +0200
Message-Id: <1244219467-32136-5-git-send-email-philipp.zabel@gmail.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244219467-32136-1-git-send-email-philipp.zabel@gmail.com>
References: <1244219467-32136-1-git-send-email-philipp.zabel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should make the code a little bit easier to read.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/mfd/asic3.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
index ebe8893..d5dd0df 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -623,7 +623,6 @@ static int __init asic3_probe(struct platform_device *pdev)
 	struct asic3 *asic;
 	struct resource *mem;
 	unsigned long clksel;
-	int map_size;
 	int ret = 0;
 
 	asic = kzalloc(sizeof(struct asic3), GFP_KERNEL);
@@ -643,8 +642,7 @@ static int __init asic3_probe(struct platform_device *pdev)
 		goto out_free;
 	}
 
-	map_size = mem->end - mem->start + 1;
-	asic->mapping = ioremap(mem->start, map_size);
+	asic->mapping = ioremap(mem->start, resource_size(mem));
 	if (!asic->mapping) {
 		ret = -ENOMEM;
 		dev_err(asic->dev, "Couldn't ioremap\n");
@@ -654,7 +652,7 @@ static int __init asic3_probe(struct platform_device *pdev)
 	asic->irq_base = pdata->irq_base;
 
 	/* calculate bus shift from mem resource */
-	asic->bus_shift = 2 - (map_size >> 12);
+	asic->bus_shift = 2 - (resource_size(mem) >> 12);
 
 	clksel = 0;
 	asic3_write_register(asic, ASIC3_OFFSET(CLOCK, SEL), clksel);
-- 
1.6.3.1


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754366AbZFDSgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366AbZFDSgp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 14:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753924AbZFDSgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 14:36:31 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:3497 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988AbZFDSga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 14:36:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=D5vwG4OHRy/AVDOnJmQyiATYtXJWsm41B6iSiS4XXZcBELRyfi1zOLrlclD53JlzEz
         q4EwkQ/cOt7eowGHFvYpRoZGfhpdZZLNARalPSsCcb9zwaE2wguhKvqcvUdJnGPGHBWL
         BSN/cV/3qT9/YAghIbuSZlwXTpwCZ67PuFC6A=
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@openedhand.com>,
       Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH 4/7] MFD: ASIC3: use resource_size macro instead of local variable
Date: Thu,  4 Jun 2009 20:36:13 +0200
Message-Id: <1244140576-18006-5-git-send-email-philipp.zabel@gmail.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244140576-18006-1-git-send-email-philipp.zabel@gmail.com>
References: <1244140576-18006-1-git-send-email-philipp.zabel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should make the code a little bit easier to read.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/mfd/asic3.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
index ed7f0c1..a2a446d 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -656,7 +656,6 @@ static int __init asic3_probe(struct platform_device *pdev)
 	struct asic3 *asic;
 	struct resource *mem;
 	unsigned long clksel;
-	int map_size;
 	int ret = 0;
 
 	asic = kzalloc(sizeof(struct asic3), GFP_KERNEL);
@@ -676,8 +675,7 @@ static int __init asic3_probe(struct platform_device *pdev)
 		goto out_free;
 	}
 
-	map_size = mem->end - mem->start + 1;
-	asic->mapping = ioremap(mem->start, map_size);
+	asic->mapping = ioremap(mem->start, resource_size(mem));
 	if (!asic->mapping) {
 		ret = -ENOMEM;
 		dev_err(asic->dev, "Couldn't ioremap\n");
@@ -687,7 +685,7 @@ static int __init asic3_probe(struct platform_device *pdev)
 	asic->irq_base = pdata->irq_base;
 
 	/* calculate bus shift from mem resource */
-	asic->bus_shift = 2 - (map_size >> 12);
+	asic->bus_shift = 2 - (resource_size(mem) >> 12);
 
 	clksel = 0;
 	asic3_write_register(asic, ASIC3_OFFSET(CLOCK, SEL), clksel);
-- 
1.6.3.1


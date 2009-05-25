Return-Path: <linux-kernel-owner+w=401wt.eu-S1754000AbZEYT2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbZEYT2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 15:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbZEYT15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 15:27:57 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:9307 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804AbZEYT14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 15:27:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HIjuCLXLatQHXJ7OFg0A/o6886nVo14CJSuPIWXB2oNezVqgkwHdIvvp8z3ov/RFZz
         5weXNTWVBgBBjiAwfktqAV6lfYDY6QVq2pRkAkMFK0D+h3rs9rDQdGJPxsFTPusQWn+Q
         9JQLjEde4Imv6V+XxMiQjUigZRBS50v1rdjOk=
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ian Molton <spyro@f2s.com>, Philipp Zabel <philipp.zabel@gmail.com>,
       Pierre Ossman <pierre@ossman.eu>
Subject: [PATCH 3/5] mmc: tmio_mmc: don't use set_irq_type
Date: Mon, 25 May 2009 21:27:59 +0200
Message-Id: <1243279681-4233-4-git-send-email-philipp.zabel@gmail.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1243279681-4233-1-git-send-email-philipp.zabel@gmail.com>
References: <1243279681-4233-1-git-send-email-philipp.zabel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use an IRQF_TRIGGER_ flag in request_irq instead.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
Cc: Pierre Ossman <pierre@ossman.eu>
Cc: Ian Molton <spyro@f2s.com>
---
 drivers/mmc/host/tmio_mmc.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/tmio_mmc.c b/drivers/mmc/host/tmio_mmc.c
index 245de05..9a3dc54 100644
--- a/drivers/mmc/host/tmio_mmc.c
+++ b/drivers/mmc/host/tmio_mmc.c
@@ -595,13 +595,11 @@ static int __devinit tmio_mmc_probe(struct platform_device *dev)
 
 	disable_mmc_irqs(host, TMIO_MASK_ALL);
 
-	ret = request_irq(host->irq, tmio_mmc_irq, IRQF_DISABLED, "tmio-mmc",
-		host);
+	ret = request_irq(host->irq, tmio_mmc_irq, IRQF_DISABLED | IRQF_TRIGGER_FALLING,
+		"tmio-mmc", host);
 	if (ret)
 		goto unmap_cnf;
 
-	set_irq_type(host->irq, IRQ_TYPE_EDGE_FALLING);
-
 	mmc_add_host(mmc);
 
 	printk(KERN_INFO "%s at 0x%08lx irq %d\n", mmc_hostname(host->mmc),
-- 
1.6.3.1


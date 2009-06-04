Return-Path: <linux-kernel-owner+w=401wt.eu-S1753471AbZFDSNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbZFDSNA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 14:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753428AbZFDSMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 14:12:41 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:11354 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbZFDSMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 14:12:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xT44Kc0ygobSHeIA8wn7uasEGmN/ZWxXzvJae4IFU6XWYPp8zyLdfm8hbuqiQqbffY
         xAyXZSuKRoEtWAtI7kCtz5Q1tOY7vE0gzqX+l8DubOSDABrHduKC42ovWnMKEFYiLEij
         a2YrbAvW1ffRhXwRJDjnqZASDhtRaEZcLjlFA=
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ian Molton <ian@mnementh.co.uk>, Pierre Ossman <pierre@ossman.eu>,
       Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH 3/7] mmc: tmio_mmc: don't use set_irq_type (v2)
Date: Thu,  4 Jun 2009 20:12:33 +0200
Message-Id: <1244139157-16404-4-git-send-email-philipp.zabel@gmail.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244139157-16404-1-git-send-email-philipp.zabel@gmail.com>
References: <1244139157-16404-1-git-send-email-philipp.zabel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use an IRQF_TRIGGER_ flag in request_irq instead.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
Acked-by: Ian Molton <ian@mnementh.co.uk>
Cc: Pierre Ossman <pierre@ossman.eu>
---
 drivers/mmc/host/tmio_mmc.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/tmio_mmc.c b/drivers/mmc/host/tmio_mmc.c
index 01add9b..bbcbd72 100644
--- a/drivers/mmc/host/tmio_mmc.c
+++ b/drivers/mmc/host/tmio_mmc.c
@@ -597,13 +597,11 @@ static int __devinit tmio_mmc_probe(struct platform_device *dev)
 
 	disable_mmc_irqs(host, TMIO_MASK_ALL);
 
-	ret = request_irq(host->irq, tmio_mmc_irq, IRQF_DISABLED, "tmio-mmc",
-		host);
+	ret = request_irq(host->irq, tmio_mmc_irq, IRQF_DISABLED |
+		IRQF_TRIGGER_FALLING, "tmio-mmc", host);
 	if (ret)
 		goto unmap_cnf;
 
-	set_irq_type(host->irq, IRQ_TYPE_EDGE_FALLING);
-
 	mmc_add_host(mmc);
 
 	printk(KERN_INFO "%s at 0x%08lx irq %d\n", mmc_hostname(host->mmc),
-- 
1.6.3.1


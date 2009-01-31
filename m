Return-Path: <linux-kernel-owner+w=401wt.eu-S1755363AbZAaUsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbZAaUsA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 15:48:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752578AbZAaUrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 15:47:52 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:20773 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbZAaUrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 15:47:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Oul9Tli/neimeeUmy3EmOlHKCfgFpJjbKe8risxjAqS7jfJ2JfKdFvLh5xv0LOxG9E
         0dt4tqKtbDFWSvoA36q7lC5fMGpV9tyWjMU9DCaO7kdez+eT9e+vvHqvui91gIf4Dyof
         KsRercltwGmLv6zLfRO1Mjt4qzqK85L+o7ur4=
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@openedhand.com>,
       Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH] mfd/htc-egpio: fix iomem resource handling using resource_size
Date: Sat, 31 Jan 2009 21:47:43 +0100
Message-Id: <1233434863-11806-1-git-send-email-philipp.zabel@gmail.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes an off-by-one error in the iomem resource mapping.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/mfd/htc-egpio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/htc-egpio.c b/drivers/mfd/htc-egpio.c
index 1a4d046..e9b0745 100644
--- a/drivers/mfd/htc-egpio.c
+++ b/drivers/mfd/htc-egpio.c
@@ -286,7 +286,7 @@ static int __init egpio_probe(struct platform_device *pdev)
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
 		goto fail;
-	ei->base_addr = ioremap_nocache(res->start, res->end - res->start);
+	ei->base_addr = ioremap_nocache(res->start, resource_size(res));
 	if (!ei->base_addr)
 		goto fail;
 	pr_debug("EGPIO phys=%08x virt=%p\n", (u32)res->start, ei->base_addr);
-- 
1.5.6.5


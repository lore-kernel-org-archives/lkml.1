Return-Path: <linux-kernel-owner+w=401wt.eu-S1754181AbZGYHLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbZGYHLu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 03:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbZGYHLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 03:11:50 -0400
Received: from smtpauth.net4india.com ([202.71.129.41]:50019 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbZGYHLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 03:11:49 -0400
From: David John <davidjon@xenontk.org>
To: torvalds@linux-foundation.org
Cc: elendil@planet.nl, linux-kernel@vger.kernel.org, yinghai@kernel.org,
       jbarnes@virtuousgeek.org
Subject: [PATCH] Remove Spurious PnP Memory Reserved Warning
Date: Sat, 25 Jul 2009 12:42:56 +0530
Message-Id: <1248505976-4952-1-BlackWidow-davidjon@xenontk.org>
X-Mailer: BlackWidow
In-Reply-To: <1248415883-11809-1-git-send-email-davidjon@xenontk.org>
References: <1248415883-11809-1-git-send-email-davidjon@xenontk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An alternate version that ignores just the errors.

Remove unnecessary complaints by the PnP sub-system about memory
ranges being reserved.

Signed-off-by: David John <davidjon@xenontk.org>

diff --git a/drivers/pnp/system.c b/drivers/pnp/system.c
index 59b9092..84ee297 100644
--- a/drivers/pnp/system.c
+++ b/drivers/pnp/system.c
@@ -48,10 +48,11 @@ static void reserve_range(struct pnp_dev *dev, resource_size_t start,
 	 * example do reserve stuff they know about too, so we may well
 	 * have double reservations.
 	 */
-	dev_info(&dev->dev, "%s range 0x%llx-0x%llx %s reserved\n",
-		port ? "ioport" : "iomem",
-		(unsigned long long) start, (unsigned long long) end,
-		res ? "has been" : "could not be");
+	if(res) {
+		dev_info(&dev->dev, "%s range 0x%llx-0x%llx has been reserved\n",
+			port ? "ioport" : "iomem",
+			(unsigned long long) start, (unsigned long long) end);
+	}
 }
 
 static void reserve_resources_of_dev(struct pnp_dev *dev)

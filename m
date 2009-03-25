Return-Path: <linux-kernel-owner+w=401wt.eu-S1758146AbZCYAil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146AbZCYAil (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756851AbZCYA37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:29:59 -0400
Received: from kroah.org ([198.145.64.141]:54099 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756825AbZCYA34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:29:56 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, sameo@openedhand.com
Subject: [PATCH 24/61] mfd: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue, 24 Mar 2009 17:26:28 -0700
Message-Id: <1237940825-22904-24-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Cc: sameo@openedhand.com
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/mfd/mcp-core.c     |    2 +-
 drivers/mfd/ucb1x00-core.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/mcp-core.c b/drivers/mfd/mcp-core.c
index 6063dc2..57271cb 100644
--- a/drivers/mfd/mcp-core.c
+++ b/drivers/mfd/mcp-core.c
@@ -214,7 +214,7 @@ EXPORT_SYMBOL(mcp_host_alloc);
 
 int mcp_host_register(struct mcp *mcp)
 {
-	strcpy(mcp->attached_device.bus_id, "mcp0");
+	dev_set_name(&mcp->attached_device, "mcp0");
 	return device_register(&mcp->attached_device);
 }
 EXPORT_SYMBOL(mcp_host_register);
diff --git a/drivers/mfd/ucb1x00-core.c b/drivers/mfd/ucb1x00-core.c
index 6860c92..fea9085 100644
--- a/drivers/mfd/ucb1x00-core.c
+++ b/drivers/mfd/ucb1x00-core.c
@@ -492,7 +492,7 @@ static int ucb1x00_probe(struct mcp *mcp)
 
 	ucb->dev.class = &ucb1x00_class;
 	ucb->dev.parent = &mcp->attached_device;
-	strlcpy(ucb->dev.bus_id, "ucb1x00", sizeof(ucb->dev.bus_id));
+	dev_set_name(&ucb->dev, "ucb1x00");
 
 	spin_lock_init(&ucb->lock);
 	spin_lock_init(&ucb->io_lock);
-- 
1.6.2


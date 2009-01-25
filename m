Return-Path: <linux-kernel-owner+w=401wt.eu-S1751850AbZAYWu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850AbZAYWu5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 17:50:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750925AbZAYWur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 17:50:47 -0500
Received: from mu-out-0910.google.com ([209.85.134.184]:25316 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbZAYWup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 17:50:45 -0500
Subject: mfd: struct device - replace bus_id with dev_name(), dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: sameo@openedhand.com
Cc: gregkh <gregkh@suse.de>, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 25 Jan 2009 23:49:53 +0100
Message-Id: <1232923793.2924.13.camel@nga>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>
Subject: mfd: struct device - replace bus_id with dev_name(), dev_set_name()

Cc: sameo@openedhand.com
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/mfd/mcp-core.c     |    2 +-
 drivers/mfd/ucb1x00-core.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

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
--- a/drivers/mfd/ucb1x00-core.c
+++ b/drivers/mfd/ucb1x00-core.c
@@ -492,7 +492,7 @@ static int ucb1x00_probe(struct mcp *mcp
 
 	ucb->dev.class = &ucb1x00_class;
 	ucb->dev.parent = &mcp->attached_device;
-	strlcpy(ucb->dev.bus_id, "ucb1x00", sizeof(ucb->dev.bus_id));
+	dev_set_name(&ucb->dev, "ucb1x00");
 
 	spin_lock_init(&ucb->lock);
 	spin_lock_init(&ucb->io_lock);


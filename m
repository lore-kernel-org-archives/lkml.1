Return-Path: <linux-kernel-owner+w=401wt.eu-S1755963AbZAFWWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbZAFWWw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:22:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755955AbZAFWNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:13:47 -0500
Received: from kroah.org ([198.145.64.141]:51250 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752143AbZAFWNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:13:45 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 27/60] tifm: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue,  6 Jan 2009 14:11:46 -0800
Message-Id: <1231279939-32728-27-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090106221123.GA32689@kroah.com>
References: <20090106221123.GA32689@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/misc/tifm_7xx1.c |    2 +-
 drivers/misc/tifm_core.c |    7 +++----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/misc/tifm_7xx1.c b/drivers/misc/tifm_7xx1.c
index 67503ea..e71eba3 100644
--- a/drivers/misc/tifm_7xx1.c
+++ b/drivers/misc/tifm_7xx1.c
@@ -164,7 +164,7 @@ static void tifm_7xx1_switch_media(struct work_struct *work)
 		if (sock) {
 			printk(KERN_INFO
 			       "%s : demand removing card from socket %u:%u\n",
-			       fm->dev.bus_id, fm->id, cnt);
+			       dev_name(&fm->dev), fm->id, cnt);
 			fm->sockets[cnt] = NULL;
 			sock_addr = sock->addr;
 			spin_unlock_irqrestore(&fm->lock, flags);
diff --git a/drivers/misc/tifm_core.c b/drivers/misc/tifm_core.c
index 82dc72a..98bcba5 100644
--- a/drivers/misc/tifm_core.c
+++ b/drivers/misc/tifm_core.c
@@ -203,7 +203,7 @@ int tifm_add_adapter(struct tifm_adapter *fm)
 	if (rc)
 		return rc;
 
-	snprintf(fm->dev.bus_id, BUS_ID_SIZE, "tifm%u", fm->id);
+	dev_set_name(&fm->dev, "tifm%u", fm->id);
 	rc = device_add(&fm->dev);
 	if (rc) {
 		spin_lock(&tifm_adapter_lock);
@@ -266,9 +266,8 @@ struct tifm_dev *tifm_alloc_device(struct tifm_adapter *fm, unsigned int id,
 		sock->dev.dma_mask = fm->dev.parent->dma_mask;
 		sock->dev.release = tifm_free_device;
 
-		snprintf(sock->dev.bus_id, BUS_ID_SIZE,
-			 "tifm_%s%u:%u", tifm_media_type_name(type, 2),
-			 fm->id, id);
+		dev_set_name(&sock->dev, "tifm_%s%u:%u",
+			     tifm_media_type_name(type, 2), fm->id, id);
 		printk(KERN_INFO DRIVER_NAME
 		       ": %s card detected in socket %u:%u\n",
 		       tifm_media_type_name(type, 0), fm->id, id);
-- 
1.6.0.4


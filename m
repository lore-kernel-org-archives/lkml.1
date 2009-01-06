Return-Path: <linux-kernel-owner+w=401wt.eu-S1757818AbZAFW36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757818AbZAFW36 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:29:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756062AbZAFWOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:14:07 -0500
Received: from kroah.org ([198.145.64.141]:51311 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756026AbZAFWOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:14:04 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 45/60] i2o: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue,  6 Jan 2009 14:12:04 -0800
Message-Id: <1231279939-32728-45-git-send-email-gregkh@suse.de>
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
 drivers/message/i2o/device.c   |    8 ++++----
 drivers/message/i2o/i2o_proc.c |    2 +-
 drivers/message/i2o/iop.c      |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/message/i2o/device.c b/drivers/message/i2o/device.c
index 54c2e9a..a7dd03e 100644
--- a/drivers/message/i2o/device.c
+++ b/drivers/message/i2o/device.c
@@ -134,7 +134,7 @@ static void i2o_device_release(struct device *dev)
 {
 	struct i2o_device *i2o_dev = to_i2o_device(dev);
 
-	pr_debug("i2o: device %s released\n", dev->bus_id);
+	pr_debug("i2o: device %s released\n", dev_name(dev));
 
 	kfree(i2o_dev);
 }
@@ -229,8 +229,8 @@ static int i2o_device_add(struct i2o_controller *c, i2o_lct_entry *entry)
 
 	i2o_dev->lct_data = *entry;
 
-	snprintf(i2o_dev->device.bus_id, BUS_ID_SIZE, "%d:%03x", c->unit,
-		 i2o_dev->lct_data.tid);
+	dev_set_name(&i2o_dev->device, "%d:%03x", c->unit,
+		     i2o_dev->lct_data.tid);
 
 	i2o_dev->iop = c;
 	i2o_dev->device.parent = &c->device;
@@ -281,7 +281,7 @@ static int i2o_device_add(struct i2o_controller *c, i2o_lct_entry *entry)
 
 	i2o_driver_notify_device_add_all(i2o_dev);
 
-	pr_debug("i2o: device %s added\n", i2o_dev->device.bus_id);
+	pr_debug("i2o: device %s added\n", dev_name(&i2o_dev->device));
 
 	return 0;
 
diff --git a/drivers/message/i2o/i2o_proc.c b/drivers/message/i2o/i2o_proc.c
index 54a3016..9a36b5a 100644
--- a/drivers/message/i2o/i2o_proc.c
+++ b/drivers/message/i2o/i2o_proc.c
@@ -1300,7 +1300,7 @@ static int i2o_seq_show_dev_name(struct seq_file *seq, void *v)
 {
 	struct i2o_device *d = (struct i2o_device *)seq->private;
 
-	seq_printf(seq, "%s\n", d->device.bus_id);
+	seq_printf(seq, "%s\n", dev_name(&d->device));
 
 	return 0;
 }
diff --git a/drivers/message/i2o/iop.c b/drivers/message/i2o/iop.c
index 35c67d1..27cf4af 100644
--- a/drivers/message/i2o/iop.c
+++ b/drivers/message/i2o/iop.c
@@ -1072,7 +1072,7 @@ struct i2o_controller *i2o_iop_alloc(void)
 
 	c->device.release = &i2o_iop_release;
 
-	snprintf(c->device.bus_id, BUS_ID_SIZE, "iop%d", c->unit);
+	dev_set_name(&c->device, "iop%d", c->unit);
 
 #if BITS_PER_LONG == 64
 	spin_lock_init(&c->context_list_lock);
-- 
1.6.0.4


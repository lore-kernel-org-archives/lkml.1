Return-Path: <linux-kernel-owner+w=401wt.eu-S1758209AbZCYAi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209AbZCYAi4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756854AbZCYAaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:30:00 -0400
Received: from kroah.org ([198.145.64.141]:54101 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756448AbZCYA35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:29:57 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, inaky.perez-gonzalez@intel.com,
       linux-wimax@intel.com
Subject: [PATCH 25/61] wimax: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue, 24 Mar 2009 17:26:29 -0700
Message-Id: <1237940825-22904-25-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Cc: inaky.perez-gonzalez@intel.com
Cc: linux-wimax@intel.com
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/net/wimax/i2400m/driver.c    |    2 +-
 drivers/net/wimax/i2400m/usb-notif.c |    2 +-
 include/linux/wimax/debug.h          |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wimax/i2400m/driver.c b/drivers/net/wimax/i2400m/driver.c
index e80a0b6..d58b971 100644
--- a/drivers/net/wimax/i2400m/driver.c
+++ b/drivers/net/wimax/i2400m/driver.c
@@ -613,7 +613,7 @@ int i2400m_setup(struct i2400m *i2400m, enum i2400m_bri bm_flags)
 	d_fnstart(3, dev, "(i2400m %p)\n", i2400m);
 
 	snprintf(wimax_dev->name, sizeof(wimax_dev->name),
-		 "i2400m-%s:%s", dev->bus->name, dev->bus_id);
+		 "i2400m-%s:%s", dev->bus->name, dev_name(dev));
 
 	i2400m->bm_cmd_buf = kzalloc(I2400M_BM_CMD_BUF_SIZE, GFP_KERNEL);
 	if (i2400m->bm_cmd_buf == NULL) {
diff --git a/drivers/net/wimax/i2400m/usb-notif.c b/drivers/net/wimax/i2400m/usb-notif.c
index 9702c22..0528879 100644
--- a/drivers/net/wimax/i2400m/usb-notif.c
+++ b/drivers/net/wimax/i2400m/usb-notif.c
@@ -102,7 +102,7 @@ int i2400mu_notification_grok(struct i2400mu *i2400mu, const void *buf,
 		dev_err(dev, "HW BUG? Unknown/unexpected data in notification "
 			"message (%zu bytes)\n", buf_len);
 		snprintf(prefix, sizeof(prefix), "%s %s: ",
-			 dev_driver_string(dev) , dev->bus_id);
+			 dev_driver_string(dev) , dev_name(dev));
 		if (buf_len > 64) {
 			print_hex_dump(KERN_ERR, prefix, DUMP_PREFIX_OFFSET,
 				       8, 4, buf, 64, 0);
diff --git a/include/linux/wimax/debug.h b/include/linux/wimax/debug.h
index ba0c493..c703e03 100644
--- a/include/linux/wimax/debug.h
+++ b/include/linux/wimax/debug.h
@@ -178,7 +178,7 @@ void __d_head(char *head, size_t head_size,
 		WARN_ON(1);
 	} else
 		snprintf(head, head_size, "%s %s: ",
-			 dev_driver_string(dev), dev->bus_id);
+			 dev_driver_string(dev), dev_name(dev));
 }
 
 
-- 
1.6.2


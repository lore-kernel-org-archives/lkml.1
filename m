Return-Path: <linux-kernel-owner+w=401wt.eu-S1755915Ab0AVREN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915Ab0AVREN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 12:04:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755130Ab0AVREM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 12:04:12 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46525 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755055Ab0AVREJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 12:04:09 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Eric Miao <eric.miao@marvell.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] RFC: make struct platform_driver.id_table const
Date: Fri, 22 Jan 2010 18:03:57 +0100
Message-Id: <1264179837-22999-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.6
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a warning on several pxa based machines:

	arch/arm/mach-pxa/ssp.c:475: warning: initialization discards qualifiers from pointer target type

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Eric Miao <eric.miao@marvell.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/platform.c         |    2 +-
 include/linux/platform_device.h |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 58efaf2..962246c 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -578,7 +578,7 @@ static int platform_uevent(struct device *dev, struct kobj_uevent_env *env)
 }
 
 static const struct platform_device_id *platform_match_id(
-			struct platform_device_id *id,
+			const struct platform_device_id *id,
 			struct platform_device *pdev)
 {
 	while (id->name[0]) {
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index 71ff887..3a6201e 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -21,7 +21,7 @@ struct platform_device {
 	u32		num_resources;
 	struct resource	* resource;
 
-	struct platform_device_id	*id_entry;
+	const struct platform_device_id	*id_entry;
 
 	/* arch specific additions */
 	struct pdev_archdata	archdata;
@@ -62,7 +62,7 @@ struct platform_driver {
 	int (*suspend)(struct platform_device *, pm_message_t state);
 	int (*resume)(struct platform_device *);
 	struct device_driver driver;
-	struct platform_device_id *id_table;
+	const struct platform_device_id *id_table;
 };
 
 extern int platform_driver_register(struct platform_driver *);
-- 
1.6.6


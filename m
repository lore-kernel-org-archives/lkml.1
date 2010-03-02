Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160Ab0CBXyO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:54:14 -0500
Received: from kroah.org ([198.145.64.141]:38565 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754271Ab0CBX32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:28 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 28/62] Driver core: make struct platform_driver.id_table const
Date: Tue,  2 Mar 2010 15:28:27 -0800
Message-Id: <1267572541-410-28-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230933.GA32287@kroah.com>
References: <20100302230933.GA32287@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

This fixes a warning on several pxa based machines:

	arch/arm/mach-pxa/ssp.c:475: warning: initialization discards qualifiers from pointer target type

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Vikram Dhillon <dhillonv10@gmail.com>
Acked-by: Eric Miao <eric.y.miao@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/platform.c         |    2 +-
 include/linux/platform_device.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 937d580..575e08b 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -636,7 +636,7 @@ static int platform_uevent(struct device *dev, struct kobj_uevent_env *env)
 }
 
 static const struct platform_device_id *platform_match_id(
-			struct platform_device_id *id,
+			const struct platform_device_id *id,
 			struct platform_device *pdev)
 {
 	while (id->name[0]) {
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index 2c2d035..212da17 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -62,7 +62,7 @@ struct platform_driver {
 	int (*suspend)(struct platform_device *, pm_message_t state);
 	int (*resume)(struct platform_device *);
 	struct device_driver driver;
-	struct platform_device_id *id_table;
+	const struct platform_device_id *id_table;
 };
 
 extern int platform_driver_register(struct platform_driver *);
-- 
1.7.0.1


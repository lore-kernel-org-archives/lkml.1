Return-Path: <linux-kernel-owner+w=401wt.eu-S1759073AbZAFWYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759073AbZAFWYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:24:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755312AbZAFWNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:13:50 -0500
Received: from kroah.org ([198.145.64.141]:51261 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755979AbZAFWNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:13:49 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Jack Steiner <steiner@sgi.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 31/60] SGI: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue,  6 Jan 2009 14:11:50 -0800
Message-Id: <1231279939-32728-31-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090106221123.GA32689@kroah.com>
References: <20090106221123.GA32689@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

CC: Jack Steiner <steiner@sgi.com>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/misc/sgi-gru/grumain.c |    2 +-
 drivers/misc/sgi-xp/xp_main.c  |    2 +-
 drivers/misc/sgi-xp/xpc_main.c |    8 ++++----
 drivers/misc/sgi-xp/xpnet.c    |    2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/misc/sgi-gru/grumain.c b/drivers/misc/sgi-gru/grumain.c
index e11e1ac..3d2fc21 100644
--- a/drivers/misc/sgi-gru/grumain.c
+++ b/drivers/misc/sgi-gru/grumain.c
@@ -29,7 +29,7 @@ static struct device_driver gru_driver = {
 };
 
 static struct device gru_device = {
-	.bus_id = {0},
+	.init_name = "",
 	.driver = &gru_driver,
 };
 
diff --git a/drivers/misc/sgi-xp/xp_main.c b/drivers/misc/sgi-xp/xp_main.c
index 9a2e771..16f8dca 100644
--- a/drivers/misc/sgi-xp/xp_main.c
+++ b/drivers/misc/sgi-xp/xp_main.c
@@ -25,7 +25,7 @@ struct device_driver xp_dbg_name = {
 };
 
 struct device xp_dbg_subname = {
-	.bus_id = {0},		/* set to "" */
+	.init_name = "",		/* set to "" */
 	.driver = &xp_dbg_name
 };
 
diff --git a/drivers/misc/sgi-xp/xpc_main.c b/drivers/misc/sgi-xp/xpc_main.c
index e8d5cfb..89218f7 100644
--- a/drivers/misc/sgi-xp/xpc_main.c
+++ b/drivers/misc/sgi-xp/xpc_main.c
@@ -59,12 +59,12 @@ struct device_driver xpc_dbg_name = {
 };
 
 struct device xpc_part_dbg_subname = {
-	.bus_id = {0},		/* set to "part" at xpc_init() time */
+	.init_name = "",	/* set to "part" at xpc_init() time */
 	.driver = &xpc_dbg_name
 };
 
 struct device xpc_chan_dbg_subname = {
-	.bus_id = {0},		/* set to "chan" at xpc_init() time */
+	.init_name = "",	/* set to "chan" at xpc_init() time */
 	.driver = &xpc_dbg_name
 };
 
@@ -1258,8 +1258,8 @@ xpc_init(void)
 	int ret;
 	struct task_struct *kthread;
 
-	snprintf(xpc_part->bus_id, BUS_ID_SIZE, "part");
-	snprintf(xpc_chan->bus_id, BUS_ID_SIZE, "chan");
+	dev_set_name(xpc_part, "part");
+	dev_set_name(xpc_chan, "chan");
 
 	if (is_shub()) {
 		/*
diff --git a/drivers/misc/sgi-xp/xpnet.c b/drivers/misc/sgi-xp/xpnet.c
index 8e6aa95..81152b3 100644
--- a/drivers/misc/sgi-xp/xpnet.c
+++ b/drivers/misc/sgi-xp/xpnet.c
@@ -138,7 +138,7 @@ struct device_driver xpnet_dbg_name = {
 };
 
 struct device xpnet_dbg_subname = {
-	.bus_id = {0},		/* set to "" */
+	.init_name = "",	/* set to "" */
 	.driver = &xpnet_dbg_name
 };
 
-- 
1.6.0.4


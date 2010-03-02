Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341Ab0CBX3e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:29:34 -0500
Received: from kroah.org ([198.145.64.141]:38544 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754217Ab0CBX3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:23 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 21/62] Driver-Core: require valid action string in uevent trigger
Date: Tue,  2 Mar 2010 15:28:20 -0800
Message-Id: <1267572541-410-21-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230933.GA32287@kroah.com>
References: <20100302230933.GA32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

No longer fall back to "add" and warn, but always require a valid
action-string written to the "uevent" file.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 2820257..e1d6cb4 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -306,15 +306,10 @@ static ssize_t store_uevent(struct device *dev, struct device_attribute *attr,
 {
 	enum kobject_action action;
 
-	if (kobject_action_type(buf, count, &action) == 0) {
+	if (kobject_action_type(buf, count, &action) == 0)
 		kobject_uevent(&dev->kobj, action);
-		goto out;
-	}
-
-	dev_err(dev, "uevent: unsupported action-string; this will "
-		     "be ignored in a future kernel version\n");
-	kobject_uevent(&dev->kobj, KOBJ_ADD);
-out:
+	else
+		dev_err(dev, "uevent: unknown action-string\n");
 	return count;
 }
 
-- 
1.7.0.1


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756585Ab0ANVyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab0ANVyk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 16:54:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751852Ab0ANVyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 16:54:38 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:37542 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756058Ab0ANVyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 16:54:36 -0500
Subject: Driver-Core: require valid action string in uevent trigger
From: Kay Sievers <kay.sievers@vrfy.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jan 2010 22:54:37 +0100
Message-ID: <1263506077.2074.8.camel@yio.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.4 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Driver-Core: require valid action string in uevent trigger

No longer fall back to "add" and warn, but always require a valid
action-string written to the "uevent" file. 

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/base/core.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -306,15 +306,10 @@ static ssize_t store_uevent(struct devic
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
 



Return-Path: <linux-kernel-owner+w=401wt.eu-S1756716AbYGVAa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716AbYGVAa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 20:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756447AbYGVA33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 20:29:29 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:9567 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756415AbYGVA31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 20:29:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=DDXUViUPpa784H5jGg559xzmcE4Lj9vdQ6D34qXgroOmMpCk35moBbqkYeDJVhYqR9
         kx9CtC+86rYL66oiQng2QSYxJnOJ7Tv5VB1xIa2FwmZbTwUDJbHihOzTlagIPWGfDE0g
         7Pux0RR2la0Jmxjp7rEclrCDwJIybbWYQPdFs=
Message-ID: <488529E3.3020609@gmail.com>
Date: Mon, 21 Jul 2008 20:29:23 -0400
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: colin@colino.net
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 5/9] adt746x: test below 0 on unsigned val
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

val is unsigned so the test doesn't work.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/macintosh/therm_adt746x.c b/drivers/macintosh/therm_adt746x.c
index 22bf981..f574077 100644
--- a/drivers/macintosh/therm_adt746x.c
+++ b/drivers/macintosh/therm_adt746x.c
@@ -500,7 +500,7 @@ static ssize_t store_##name(struct device *dev, struct device_attribute *attr, c
 {								\
 	u32 val;						\
 	val = simple_strtoul(buf, NULL, 10);			\
-	if (val < 0 || val > 255)				\
+	if (val > 255)						\
 		return -EINVAL;					\
 	printk(KERN_INFO "Setting specified fan speed to %d\n", val);	\
 	data = val;						\

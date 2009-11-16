Return-Path: <linux-kernel-owner+w=401wt.eu-S1752577AbZKPETJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbZKPETJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 23:19:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752954AbZKPETG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 23:19:06 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:56872 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbZKPETE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 23:19:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JichBjOkAlWxpE/UprYKOx1wCsUi4Q7PGe1ckEGLRgP3iU5CJccKaNM0RAStSbed4Q
         8VkBg0jrW16nx3qk27IRqoBMFteoQKBzK1ctZB/PyWAvK2LAfxCeMqVyVMXrVu7rQ4rM
         J8mB10cKoJ6QvHj5JSWW6meI3soLZFSKep+IE=
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: [PATCH 10/13] staging: line6: Convert simple_strtol to strict_strtol in toneport.c
Date: Sun, 15 Nov 2009 22:17:59 -0600
Message-Id: <1258345082-11811-11-git-send-email-shawn.bohrer@gmail.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1258345082-11811-1-git-send-email-shawn.bohrer@gmail.com>
References: <1258345082-11811-1-git-send-email-shawn.bohrer@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
---
 drivers/staging/line6/toneport.c |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/line6/toneport.c b/drivers/staging/line6/toneport.c
index 84bf29c..e6770ea 100644
--- a/drivers/staging/line6/toneport.c
+++ b/drivers/staging/line6/toneport.c
@@ -96,8 +96,14 @@ static ssize_t toneport_set_led_red(struct device *dev,
 				    struct device_attribute *attr,
 				    const char *buf, size_t count)
 {
-	char *c;
-	led_red = simple_strtol(buf, &c, 10);
+	int retval;
+	long value;
+
+	retval = strict_strtol(buf, 10, &value);
+	if (retval)
+		return retval;
+
+	led_red = value;
 	toneport_update_led(dev);
 	return count;
 }
@@ -106,8 +112,14 @@ static ssize_t toneport_set_led_green(struct device *dev,
 				      struct device_attribute *attr,
 				      const char *buf, size_t count)
 {
-	char *c;
-	led_green = simple_strtol(buf, &c, 10);
+	int retval;
+	long value;
+
+	retval = strict_strtol(buf, 10, &value);
+	if (retval)
+		return retval;
+
+	led_green = value;
 	toneport_update_led(dev);
 	return count;
 }
-- 
1.6.5


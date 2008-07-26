Return-Path: <linux-kernel-owner+w=401wt.eu-S1752463AbYGZJHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbYGZJHh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 05:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbYGZJH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 05:07:29 -0400
Received: from mail.tut.by ([195.137.160.40]:38715 "EHLO speedy.tutby.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239AbYGZJH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 05:07:29 -0400
X-Greylist: delayed 907 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Jul 2008 05:07:28 EDT
Subject: [PATCH] fix warning in drivers/hwmon/w83791d.c
From: Michael Borisov <niro@tut.by>
To: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Date: Sat, 26 Jul 2008 11:52:14 +0300
Message-Id: <1217062334.25013.9.camel@inlin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following compile warning:

drivers/hwmon/w83791d.c: In function ‘w83791d_probe’:
drivers/hwmon/w83791d.c:1049: warning: unused variable ‘val1’

Signed-off-by: Michael Borisov <niro@tut.by>
---
diff --git a/drivers/hwmon/w83791d.c b/drivers/hwmon/w83791d.c
index e4e91c9..1e2dff3 100644
--- a/drivers/hwmon/w83791d.c
+++ b/drivers/hwmon/w83791d.c
@@ -1046,9 +1046,10 @@ static int w83791d_probe(struct i2c_client
*client,
 {
        struct w83791d_data *data;
        struct device *dev = &client->dev;
-       int i, val1, err;
+       int i, err;
 
 #ifdef DEBUG
+        int val1;
        val1 = w83791d_read(client, W83791D_REG_DID_VID4);
        dev_dbg(dev, "Device ID version: %d.%d (0x%02x)\n",
                        (val1 >> 5) & 0x07, (val1 >> 1) & 0x0f, val1);



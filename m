Return-Path: <linux-kernel-owner+w=401wt.eu-S1753752AbXJWAA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752AbXJWAA3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 20:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751125AbXJWAAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 20:00:18 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:56928 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbXJWAAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 20:00:16 -0400
Message-ID: <471D398E.8080209@tiscali.nl>
Date: Tue, 23 Oct 2007 02:00:14 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] unlock 12c_mutex before return
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    unlock 12c_mutex before return -EINVAL
    
    Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/media/dvb/dvb-usb/au6610.c b/drivers/media/dvb/dvb-usb/au6610.c
index 18e0b16..31f47c7 100644
--- a/drivers/media/dvb/dvb-usb/au6610.c
+++ b/drivers/media/dvb/dvb-usb/au6610.c
@@ -82,8 +82,10 @@ static int au6610_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
 		return -EAGAIN;
 
-	if (num > 2)
+	if (num > 2) {
+                mutex_unlock(&d->i2c_mutex);
 		return -EINVAL;
+	}
 
 	for (i = 0; i < num; i++) {
 		/* write/read request */

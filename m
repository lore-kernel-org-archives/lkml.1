Return-Path: <linux-kernel-owner+w=401wt.eu-S1752203AbXJWAGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbXJWAGq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 20:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751135AbXJWAGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 20:06:39 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:37439 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbXJWAGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 20:06:38 -0400
Message-ID: <471D3B0C.6040703@tiscali.nl>
Date: Tue, 23 Oct 2007 02:06:36 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] unlock 12c_mutex before return
References: <471D398E.8080209@tiscali.nl>
In-Reply-To: <471D398E.8080209@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

And a similar one in drivers/media/dvb/dvb-usb/gl861.c
--
    unlock 12c_mutex before return -EINVAL
    
    Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/media/dvb/dvb-usb/gl861.c b/drivers/media/dvb/dvb-usb/gl861.c
index f01d99c..20c340a 100644
--- a/drivers/media/dvb/dvb-usb/gl861.c
+++ b/drivers/media/dvb/dvb-usb/gl861.c
@@ -59,8 +59,10 @@ static int gl861_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
 		return -EAGAIN;
 
-	if (num > 2)
+	if (num > 2) {
+		mutex_unlock(&d->i2c_mutex);
 		return -EINVAL;
+	}
 
 	for (i = 0; i < num; i++) {
 		/* write/read request */


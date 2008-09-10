Return-Path: <linux-kernel-owner+w=401wt.eu-S1753525AbYIJP7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbYIJP7P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 11:59:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbYIJP7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 11:59:00 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:40812 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbYIJP67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 11:58:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=fU8Uyrb9G8TzJovNetPbLoe8HibmMymfJDWlTInucSFfZJRTmZ0CcE7GrzmYfMcqbH
         px34DBe9zPALhjq+UDRbHaQKXzB0Dc5bklyYs5j+VIyLQTAOMtvhBrYuwgTemaAywvq/
         2zg4LpGyj7R+ZJEc39QpC1+hUHVOiR2dhQdTg=
Message-ID: <48C7EEBE.3050105@gmail.com>
Date: Wed, 10 Sep 2008 17:58:54 +0200
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: hverkuil@xs4all.nl, mchehab@infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] V4L/DVB (7725): cx23885: unsigned cx23417_mailbox cannot
 be negative
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unsigned cx23417_mailbox cannot be negative

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/media/video/cx23885/cx23885-417.c b/drivers/media/video/cx23885/cx23885-417.c
index 8118091..f0f09aa 100644
--- a/drivers/media/video/cx23885/cx23885-417.c
+++ b/drivers/media/video/cx23885/cx23885-417.c
@@ -1028,12 +1028,13 @@ static int cx23885_initialize_codec(struct cx23885_dev *dev)
 			printk(KERN_ERR "%s() f/w load failed\n", __func__);
 			return retval;
 		}
-		dev->cx23417_mailbox = cx23885_find_mailbox(dev);
-		if (dev->cx23417_mailbox < 0) {
+		retval = cx23885_find_mailbox(dev);
+		if (retval < 0) {
 			printk(KERN_ERR "%s() mailbox < 0, error\n",
 				__func__);
 			return -1;
 		}
+		dev->cx23417_mailbox = retval;
 		retval = cx23885_api_cmd(dev, CX2341X_ENC_PING_FW, 0, 0);
 		if (retval < 0) {
 			printk(KERN_ERR

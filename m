Return-Path: <linux-kernel-owner+w=401wt.eu-S1753214AbYKZWDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbYKZWDe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 17:03:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbYKZWDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 17:03:25 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:20075 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbYKZWDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 17:03:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=gFMIdwWc34Pc+XOwaWniLISTNPQ8rK1U8D0nEZRimqjFhoJ9jlhjHUL79rRUihwrVY
         7uNhw5bgzxYPjOLMQ0TuBZC7OqRY5BAwb/zsk/kfPl2+KrbBSgCHNEwPployV5r2Xkdd
         uFxXZWHrD++uWEyWvxFwr8mY5+TANvF3fOrBw=
Message-ID: <492DC7A6.5090806@gmail.com>
Date: Wed, 26 Nov 2008 17:03:18 -0500
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: hverkuil@xs4all.nl, mchehab@infradead.org
CC: linux-kernel@vger.kernel.org, video4linux-list@redhat.com
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
dev->cx23417_mailbox has type u32, see
vi drivers/media/video/cx23885/cx23885.h +330

cx23885_find_mailbox() returns int, see
vi drivers/media/video/cx23885/cx23885-417.c +832

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


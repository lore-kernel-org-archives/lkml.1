Return-Path: <linux-kernel-owner+w=401wt.eu-S1756972AbYDWTS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972AbYDWTS2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 15:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753926AbYDWTSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 15:18:00 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:47983 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617AbYDWTR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 15:17:59 -0400
Message-ID: <480F8B4F.9050605@tiscali.nl>
Date: Wed, 23 Apr 2008 21:17:35 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
       v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] blackbird_find_mailbox negative return ignored in blackbird_initialize_codec()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev->mailbox is unsigned. so a negative return goes unnoticed

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/media/video/cx88/cx88-blackbird.c b/drivers/media/video/cx88/cx88-blackbird.c
index a99e9d5..07abd41 100644
--- a/drivers/media/video/cx88/cx88-blackbird.c
+++ b/drivers/media/video/cx88/cx88-blackbird.c
@@ -546,10 +546,12 @@ static int blackbird_initialize_codec(struct cx8802_dev *dev)
 		if (retval < 0)
 			return retval;
 
-		dev->mailbox = blackbird_find_mailbox(dev);
-		if (dev->mailbox < 0)
+		retval = blackbird_find_mailbox(dev);
+		if (retval < 0)
 			return -1;
 
+		dev->mailbox = retval;
+
 		retval = blackbird_api_cmd(dev, CX2341X_ENC_PING_FW, 0, 0); /* ping */
 		if (retval < 0) {
 			dprintk(0, "ERROR: Firmware ping failed!\n");

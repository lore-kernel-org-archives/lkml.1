Return-Path: <linux-kernel-owner+w=401wt.eu-S1754683AbZESRMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683AbZESRMo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 13:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751905AbZESRMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 13:12:38 -0400
Received: from d112a2.x-mailer.de ([212.162.53.4]:48569 "EHLO
	d112a2.x-mailer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbZESRMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 13:12:37 -0400
Message-Id: <a9196e249a7d3815c000bda0ea6106f20a4e987c.1242739648.git.kkeil@pingi.linux-pingi.de>
In-Reply-To: <cover.1242739648.git.kkeil@pingi.linux-pingi.de>
References: <cover.1242739648.git.kkeil@pingi.linux-pingi.de>
Subject: [PATCH 19/19] isdn: get_free_devid() failure ignored
From: Karsten Keil <keil@b1-systems.de>
To: linux-kernel@vger.kernel.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       i4ldeveloper@listserv.isdn4linux.de
Date: Tue, 19 May 2009 15:58:38 +0200
X-Info: valid message
X-Info: original Date
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <roel.kluin@gmail.com>

dev->id is unsigned so a get_free_devid() error is ignored.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Karsten Keil <keil@b1-systems.de>
---
 drivers/isdn/mISDN/core.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/isdn/mISDN/core.c b/drivers/isdn/mISDN/core.c
index 9426c98..21d34be 100644
--- a/drivers/isdn/mISDN/core.c
+++ b/drivers/isdn/mISDN/core.c
@@ -214,7 +214,7 @@ get_free_devid(void)
 		if (!test_and_set_bit(i, (u_long *)&device_ids))
 			break;
 	if (i > MAX_DEVICE_ID)
-		return -1;
+		return -EBUSY;
 	return i;
 }
 
@@ -224,10 +224,10 @@ mISDN_register_device(struct mISDNdevice *dev,
 {
 	int	err;
 
-	dev->id = get_free_devid();
-	err = -EBUSY;
-	if (dev->id < 0)
+	err = get_free_devid();
+	if (err < 0)
 		goto error1;
+	dev->id = err;
 
 	device_initialize(&dev->dev);
 	if (name && name[0])
-- 
1.6.0.2


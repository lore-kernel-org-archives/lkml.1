Return-Path: <linux-kernel-owner+w=401wt.eu-S1758915AbZEVVIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758915AbZEVVIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 17:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757902AbZEVVEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 17:04:54 -0400
Received: from d112a2.x-mailer.de ([212.162.53.4]:47589 "EHLO
	d112a2.x-mailer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758069AbZEVVEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 17:04:52 -0400
Message-Id: <ca07ceb5f4c3cede952943686120b27e20008074.1243024967.git.kkeil@pingi.linux-pingi.de>
In-Reply-To: <cover.1243024967.git.kkeil@pingi.linux-pingi.de>
References: <cover.1243024967.git.kkeil@pingi.linux-pingi.de>
Subject: [mISDN PATCH v2 13/19] isdn: get_free_devid() failure ignored
From: Karsten Keil <keil@b1-systems.de>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       i4ldeveloper@listserv.isdn4linux.de
Date: Fri, 22 May 2009 23:04:53 +0200
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


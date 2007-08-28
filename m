Return-Path: <linux-kernel-owner+w=401wt.eu-S1758037AbXH1ISS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037AbXH1ISS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 04:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754296AbXH1IR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 04:17:56 -0400
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:45439 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220AbXH1IRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 04:17:54 -0400
Message-id: <54324564250413328@pripojeni.net>
In-reply-to: <12315207221202319057@pripojeni.net>
Subject: [PATCH 2/3] V4L: stk11xx, use retval from stk11xx_check_device
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Tue, 28 Aug 2007 04:17:54 -0400
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

stk11xx, use retval from stk11xx_check_device

stk11xx_check_device returns 0 for success of non-inited device, 1 for
success of inited device and negative for error cases. bubble the negative
value to the caller.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 95de679efc8c9fbd13121f3fbe4144196a66f387
tree bdc82d59c4ea9ec96abdde81209cb319d71192b6
parent addcd116df57eaca525a1c827efdd5bf3e61b7b5
author Jiri Slaby <jirislaby@gmail.com> Tue, 28 Aug 2007 09:55:20 +0200
committer Jiri Slaby <jirislaby@gmail.com> Tue, 28 Aug 2007 09:55:20 +0200

 drivers/media/video/stk1125.c  |    2 +-
 drivers/media/video/stk1135.c  |    2 +-
 drivers/media/video/stkdcnew.c |    3 +--
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/stk1125.c b/drivers/media/video/stk1125.c
index 2429225..f12030d 100644
--- a/drivers/media/video/stk1125.c
+++ b/drivers/media/video/stk1125.c
@@ -91,7 +91,7 @@ static int stk1125_load_microcode(struct stk11xx *dev)
 		retok = stk11xx_check_device(dev, 500);
 		if (retok != 1) {
 			dev_err(&dev->udev->dev, "load microcode fail\n");
-			return -EIO;
+			return retok < 0 ? retok : -EIO;
 		}
 
 		stk11xx_write_reg(dev, 0x02ff, 0x00);
diff --git a/drivers/media/video/stk1135.c b/drivers/media/video/stk1135.c
index 9acd951..cba95e0 100644
--- a/drivers/media/video/stk1135.c
+++ b/drivers/media/video/stk1135.c
@@ -64,7 +64,7 @@ static int stk1135_load_microcode(struct stk11xx *dev)
 		retok = stk11xx_check_device(dev, 500);
 		if (retok != 1) {
 			dev_err(&dev->udev->dev, "load microcode failed\n");
-			return -EIO;
+			return retok < 0 ? retok : -EIO;
 		}
 
 		stk11xx_write_reg(dev, 0x02ff, 0x00);
diff --git a/drivers/media/video/stkdcnew.c b/drivers/media/video/stkdcnew.c
index 52513e2..00176f2 100644
--- a/drivers/media/video/stkdcnew.c
+++ b/drivers/media/video/stkdcnew.c
@@ -102,10 +102,9 @@ static int stkdcnew_load_microcode(struct stk11xx *dev)
 		stk11xx_write_reg(dev, 0x0200, 0x01);
 
 		retok = stk11xx_check_device(dev, 500);
-
 		if (retok != 1) {
 			dev_err(&dev->udev->dev, "load microcode fail!\n");
-			return -EIO;
+			return retok < 0 ? retok : -EIO;
 		}
 
 		stk11xx_write_reg(dev, 0x02ff, 0x00);

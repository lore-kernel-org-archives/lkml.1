Return-Path: <linux-kernel-owner+w=401wt.eu-S1755368AbYFRRAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbYFRRAO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 13:00:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752739AbYFRRAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 13:00:00 -0400
Received: from multi.imgtec.com ([194.200.65.239]:51679 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487AbYFRQ77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 12:59:59 -0400
X-Greylist: delayed 740 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Jun 2008 12:59:59 EDT
From: Will Newton <will.newton@imgtec.com>
To: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org, Will Newton <will.newton@gmail.com>
Subject: [PATCH] sisusbvga: Fix oops on disconnect.
Date: Wed, 18 Jun 2008 17:59:57 +0100
Message-Id: <1213808397-17450-1-git-send-email-will.newton@imgtec.com>
X-Mailer: git-send-email 1.5.5.2
X-OriginalArrivalTime: 18 Jun 2008 16:59:58.0069 (UTC) FILETIME=[BD2AC250:01C8D164]
X-SEF-Processed: 6_0_1_111__2008_06_18_17_59_58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Newton <will.newton@gmail.com>

Remove the message printed with dev_info on disconnect after sisusb_dev has
potentially been zeroed by sisusb_delete. The message does not provide
any extra information over that which the USB subsystem prints as standard
so just kill it.

Signed-off-by: Will Newton <will.newton@gmail.com>
---
 drivers/usb/misc/sisusbvga/sisusb.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/misc/sisusbvga/sisusb.c b/drivers/usb/misc/sisusbvga/sisusb.c
index cb7fa0e..33182f4 100644
--- a/drivers/usb/misc/sisusbvga/sisusb.c
+++ b/drivers/usb/misc/sisusbvga/sisusb.c
@@ -3264,8 +3264,6 @@ static void sisusb_disconnect(struct usb_interface *intf)
 
 	/* decrement our usage count */
 	kref_put(&sisusb->kref, sisusb_delete);
-
-	dev_info(&sisusb->sisusb_dev->dev, "Disconnected\n");
 }
 
 static struct usb_device_id sisusb_table [] = {
-- 
1.5.5.2


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754892AbYFRRC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbYFRRC4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 13:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbYFRRCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 13:02:47 -0400
Received: from multi.imgtec.com ([194.200.65.239]:16886 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbYFRRCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 13:02:47 -0400
From: Will Newton <will.newton@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org, Will Newton <will.newton@gmail.com>
Subject: [PATCH] sisusbvga: Fix oops on disconnect.
Date: Wed, 18 Jun 2008 17:47:38 +0100
Message-Id: <1213807658-16208-1-git-send-email-will.newton@gmail.com>
X-Mailer: git-send-email 1.5.5.2
X-OriginalArrivalTime: 18 Jun 2008 16:47:39.0049 (UTC) FILETIME=[04AD4190:01C8D163]
X-SEF-Processed: 6_0_1_111__2008_06_18_17_47_39
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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


Return-Path: <linux-kernel-owner+w=401wt.eu-S1762724AbYF0MT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762724AbYF0MT3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760886AbYF0MIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 08:08:13 -0400
Received: from multi.imgtec.com ([194.200.65.239]:36238 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759124AbYF0MIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 08:08:11 -0400
From: Will Newton <will.newton@imgtec.com>
To: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org, felipe.lima@indt.org.br, gregkh@suse.de,
       Will Newton <will.newton@gmail.com>
Subject: [PATCH] sisusbvga: Fix oops on disconnect.
Date: Fri, 27 Jun 2008 13:08:08 +0100
Message-Id: <1214568488-5356-1-git-send-email-will.newton@imgtec.com>
X-Mailer: git-send-email 1.5.5.2
X-OriginalArrivalTime: 27 Jun 2008 12:08:09.0250 (UTC) FILETIME=[76D0C020:01C8D84E]
X-SEF-Processed: 6_0_1_111__2008_06_27_13_08_09
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Newton <will.newton@gmail.com>

Remove dev_info call on disconnect. The sisusb_dev pointer may have been
set to zero by sisusb_delete at this point causing an oops.

The message does not provide any extra information over the standard USB
subsystem output so removing it does not affect functionality.

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


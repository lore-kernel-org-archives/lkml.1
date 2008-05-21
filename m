Return-Path: <linux-kernel-owner+w=401wt.eu-S934558AbYEUBH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934558AbYEUBH6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 21:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765716AbYEUBHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 21:07:15 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48426 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933006AbYEUBGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 21:06:53 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] irda-usb endianness annotations and fixes
Cc: jgarzik@pobox.com, linux-kernel@vger.kernel.org
Message-Id: <E1Jycn5-0008Jz-L3@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 21 May 2008 02:06:51 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Content-Length: 1257
Lines: 40

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/net/irda/irda-usb.c |    2 +-
 drivers/net/irda/irda-usb.h |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/irda/irda-usb.c b/drivers/net/irda/irda-usb.c
index 9081234..6f50ed7 100644
--- a/drivers/net/irda/irda-usb.c
+++ b/drivers/net/irda/irda-usb.c
@@ -1120,7 +1120,7 @@ static int stir421x_patch_device(struct irda_usb_cb *self)
                 }
         }
 
-        if (self->usbdev->descriptor.bcdDevice == fw_version) {
+        if (self->usbdev->descriptor.bcdDevice == cpu_to_le16(fw_version)) {
                 /*
 		 * If we're here, we've found a correct patch
                  * The actual image starts after the "STMP" keyword
diff --git a/drivers/net/irda/irda-usb.h b/drivers/net/irda/irda-usb.h
index e846c38..a0ca9c1 100644
--- a/drivers/net/irda/irda-usb.h
+++ b/drivers/net/irda/irda-usb.h
@@ -117,11 +117,11 @@
 struct irda_class_desc {
 	__u8  bLength;
 	__u8  bDescriptorType;
-	__u16 bcdSpecRevision;
+	__le16 bcdSpecRevision;
 	__u8  bmDataSize;
 	__u8  bmWindowSize;
 	__u8  bmMinTurnaroundTime;
-	__u16 wBaudRate;
+	__le16 wBaudRate;
 	__u8  bmAdditionalBOFs;
 	__u8  bIrdaRateSniff;
 	__u8  bMaxUnicastList;
-- 
1.5.3.GIT



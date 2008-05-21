Return-Path: <linux-kernel-owner+w=401wt.eu-S1759032AbYEUAcI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759032AbYEUAcI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 20:32:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755963AbYEUAbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 20:31:05 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45298 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763373AbYEUAbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 20:31:02 -0400
To: mchehab@infradead.org
Subject: [PATCH] endianness fix in flexcop-usb.c
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Message-Id: <E1JycEP-0004lS-QJ@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 21 May 2008 01:31:01 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/media/dvb/b2c2/flexcop-usb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/b2c2/flexcop-usb.c b/drivers/media/dvb/b2c2/flexcop-usb.c
index 449fb5c..ae0d76a 100644
--- a/drivers/media/dvb/b2c2/flexcop-usb.c
+++ b/drivers/media/dvb/b2c2/flexcop-usb.c
@@ -379,7 +379,7 @@ static void flexcop_usb_transfer_exit(struct flexcop_usb *fc_usb)
 
 static int flexcop_usb_transfer_init(struct flexcop_usb *fc_usb)
 {
-	u16 frame_size = fc_usb->uintf->cur_altsetting->endpoint[0].desc.wMaxPacketSize;
+	u16 frame_size = le16_to_cpu(fc_usb->uintf->cur_altsetting->endpoint[0].desc.wMaxPacketSize);
 	int bufsize = B2C2_USB_NUM_ISO_URB * B2C2_USB_FRAMES_PER_ISO * frame_size,i,j,ret;
 	int buffer_offset = 0;
 
-- 
1.5.3.GIT



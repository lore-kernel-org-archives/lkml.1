Return-Path: <linux-kernel-owner+w=401wt.eu-S933220AbYEUAhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933220AbYEUAhX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 20:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765526AbYEUAdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 20:33:05 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45330 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765576AbYEUAdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 20:33:03 -0400
To: mchehab@infradead.org
Subject: [PATCH] dvb-usb: unaligned
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Message-Id: <E1JycGL-0004x6-SF@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 21 May 2008 01:33:01 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/media/dvb/dvb-usb/dvb-usb-firmware.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-firmware.c b/drivers/media/dvb/dvb-usb/dvb-usb-firmware.c
index e1112e3..733a7ff 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-firmware.c
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-firmware.c
@@ -127,7 +127,7 @@ int dvb_usb_get_hexline(const struct firmware *fw, struct hexline *hx,
 	if ((*pos + hx->len + 4) >= fw->size)
 		return -EINVAL;
 
-	hx->addr = le16_to_cpu( *((u16 *) &b[1]) );
+	hx->addr = b[1] | (b[2] << 8);
 	hx->type = b[3];
 
 	if (hx->type == 0x04) {
-- 
1.5.3.GIT



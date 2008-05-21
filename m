Return-Path: <linux-kernel-owner+w=401wt.eu-S1763761AbYEUAgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763761AbYEUAgf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 20:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765531AbYEUAcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 20:32:43 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45321 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765806AbYEUAcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 20:32:42 -0400
To: mchehab@infradead.org
Subject: [PATCH] m920x: unaligned access
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Message-Id: <E1JycG1-0004uR-Ry@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 21 May 2008 01:32:41 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/media/dvb/dvb-usb/m920x.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/m920x.c b/drivers/media/dvb/dvb-usb/m920x.c
index a12e6f7..54626a0 100644
--- a/drivers/media/dvb/dvb-usb/m920x.c
+++ b/drivers/media/dvb/dvb-usb/m920x.c
@@ -16,6 +16,7 @@
 #include "qt1010.h"
 #include "tda1004x.h"
 #include "tda827x.h"
+#include <asm/unaligned.h>
 
 /* debug */
 static int dvb_usb_m920x_debug;
@@ -347,13 +348,13 @@ static int m920x_firmware_download(struct usb_device *udev, const struct firmwar
 
 	for (pass = 0; pass < 2; pass++) {
 		for (i = 0; i + (sizeof(u16) * 3) < fw->size;) {
-			value = le16_to_cpu(*(u16 *)(fw->data + i));
+			value = get_unaligned_le16(fw->data + i);
 			i += sizeof(u16);
 
-			index = le16_to_cpu(*(u16 *)(fw->data + i));
+			index = get_unaligned_le16(fw->data + i);
 			i += sizeof(u16);
 
-			size = le16_to_cpu(*(u16 *)(fw->data + i));
+			size = get_unaligned_le16(fw->data + i);
 			i += sizeof(u16);
 
 			if (pass == 1) {
-- 
1.5.3.GIT



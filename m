Return-Path: <linux-kernel-owner+w=401wt.eu-S1762945AbYDNQiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762945AbYDNQiw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 12:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762757AbYDNQiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 12:38:22 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:28605 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762746AbYDNQiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 12:38:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TYhnngSdcR7XSV0rE59eLyRuFrQWXDN8YzI+wq9KiygNCy0WUewYNPGQ7i/WnOQkTZcL3lecP0ZPlyMtSAgTYDQNXLLFCKzsG6qu8FMNtsfl3UQ42XwkNGB2LElKv/FtfMvhJLrzo5c0RgE43DQreh6qx9TonHaGh9haTKAvfFI=
Subject: [PATCH 03/10] input: Use get_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 14 Apr 2008 09:37:54 -0700
Message-Id: <1208191074.5721.25.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/input/tablet/aiptek.c |   16 ++++++++--------
 drivers/input/tablet/gtco.c   |   14 +++++++-------
 drivers/input/tablet/kbtab.c  |    4 ++--
 3 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/input/tablet/aiptek.c b/drivers/input/tablet/aiptek.c
index 94683f5..6266db8 100644
--- a/drivers/input/tablet/aiptek.c
+++ b/drivers/input/tablet/aiptek.c
@@ -527,9 +527,9 @@ static void aiptek_irq(struct urb *urb)
 			    (aiptek->curSetting.pointerMode)) {
 				aiptek->diagnostic = AIPTEK_DIAGNOSTIC_TOOL_DISALLOWED;
 		} else {
-			x = le16_to_cpu(get_unaligned((__le16 *) (data + 1)));
-			y = le16_to_cpu(get_unaligned((__le16 *) (data + 3)));
-			z = le16_to_cpu(get_unaligned((__le16 *) (data + 6)));
+			x = get_unaligned_le16(data + 1);
+			y = get_unaligned_le16(data + 3);
+			z = get_unaligned_le16(data + 6);
 
 			dv = (data[5] & 0x01) != 0 ? 1 : 0;
 			p = (data[5] & 0x02) != 0 ? 1 : 0;
@@ -612,8 +612,8 @@ static void aiptek_irq(struct urb *urb)
 			(aiptek->curSetting.pointerMode)) {
 			aiptek->diagnostic = AIPTEK_DIAGNOSTIC_TOOL_DISALLOWED;
 		} else {
-			x = le16_to_cpu(get_unaligned((__le16 *) (data + 1)));
-			y = le16_to_cpu(get_unaligned((__le16 *) (data + 3)));
+			x = get_unaligned_le16(data + 1);
+			y = get_unaligned_le16(data + 3);
 
 			jitterable = data[5] & 0x1c;
 
@@ -678,7 +678,7 @@ static void aiptek_irq(struct urb *urb)
 		pck = (data[1] & aiptek->curSetting.stylusButtonUpper) != 0 ? 1 : 0;
 
 		macro = dv && p && tip && !(data[3] & 1) ? (data[3] >> 1) : -1;
-		z = le16_to_cpu(get_unaligned((__le16 *) (data + 4)));
+		z = get_unaligned_le16(data + 4);
 
 		if (dv) {
 		        /* If the selected tool changed, reset the old
@@ -756,7 +756,7 @@ static void aiptek_irq(struct urb *urb)
 	 * hat switches (which just so happen to be the macroKeys.)
 	 */
 	else if (data[0] == 6) {
-		macro = le16_to_cpu(get_unaligned((__le16 *) (data + 1)));
+		macro = get_unaligned_le16(data + 1);
 		if (macro > 0) {
 			input_report_key(inputdev, macroKeyEvents[macro - 1],
 					 0);
@@ -950,7 +950,7 @@ aiptek_query(struct aiptek *aiptek, unsigned char command, unsigned char data)
 		    buf[0], buf[1], buf[2]);
 		ret = -EIO;
 	} else {
-		ret = le16_to_cpu(get_unaligned((__le16 *) (buf + 1)));
+		ret = get_unaligned_le16(buf + 1);
 	}
 	kfree(buf);
 	return ret;
diff --git a/drivers/input/tablet/gtco.c b/drivers/input/tablet/gtco.c
index d2c6da2..91ba891 100644
--- a/drivers/input/tablet/gtco.c
+++ b/drivers/input/tablet/gtco.c
@@ -245,11 +245,11 @@ static void parse_hid_report_descriptor(struct gtco *device, char * report,
 			data = report[i];
 			break;
 		case 2:
-			data16 = le16_to_cpu(get_unaligned((__le16 *)&report[i]));
+			data16 = get_unaligned_le16(&report[i]);
 			break;
 		case 3:
 			size = 4;
-			data32 = le32_to_cpu(get_unaligned((__le32 *)&report[i]));
+			data32 = get_unaligned_le32(&report[i]);
 			break;
 		}
 
@@ -695,10 +695,10 @@ static void gtco_urb_callback(struct urb *urbinfo)
 			/*  Fall thru */
 		case 1:
 			/* All reports have X and Y coords in the same place */
-			val = le16_to_cpu(get_unaligned((__le16 *)&device->buffer[1]));
+			val = get_unaligned_le16(&device->buffer[1]);
 			input_report_abs(inputdev, ABS_X, val);
 
-			val = le16_to_cpu(get_unaligned((__le16 *)&device->buffer[3]));
+			val = get_unaligned_le16(&device->buffer[3]);
 			input_report_abs(inputdev, ABS_Y, val);
 
 			/* Ditto for proximity bit */
@@ -762,7 +762,7 @@ static void gtco_urb_callback(struct urb *urbinfo)
 				le_buffer[1]  = (u8)(device->buffer[4] >> 1);
 				le_buffer[1] |= (u8)((device->buffer[5] & 0x1) << 7);
 
-				val = le16_to_cpu(get_unaligned((__le16 *)le_buffer));
+				val = get_unaligned_le16(le_buffer);
 				input_report_abs(inputdev, ABS_Y, val);
 
 				/*
@@ -772,10 +772,10 @@ static void gtco_urb_callback(struct urb *urbinfo)
 				buttonbyte = device->buffer[5] >> 1;
 			} else {
 
-				val = le16_to_cpu(get_unaligned((__le16 *)&device->buffer[1]));
+				val = get_unaligned_le16(&device->buffer[1]);
 				input_report_abs(inputdev, ABS_X, val);
 
-				val = le16_to_cpu(get_unaligned((__le16 *)&device->buffer[3]));
+				val = get_unaligned_le16(&device->buffer[3]);
 				input_report_abs(inputdev, ABS_Y, val);
 
 				buttonbyte = device->buffer[5];
diff --git a/drivers/input/tablet/kbtab.c b/drivers/input/tablet/kbtab.c
index 1182fc1..f23f5a9 100644
--- a/drivers/input/tablet/kbtab.c
+++ b/drivers/input/tablet/kbtab.c
@@ -63,8 +63,8 @@ static void kbtab_irq(struct urb *urb)
 		goto exit;
 	}
 
-	kbtab->x = le16_to_cpu(get_unaligned((__le16 *) &data[1]));
-	kbtab->y = le16_to_cpu(get_unaligned((__le16 *) &data[3]));
+	kbtab->x = get_unaligned_le16(&data[1]);
+	kbtab->y = get_unaligned_le16(&data[3]);
 
 	kbtab->pressure = (data[5]);
 
-- 
1.5.5.144.g3e42



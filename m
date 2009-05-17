Return-Path: <linux-kernel-owner+w=401wt.eu-S1754744AbZEQUvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744AbZEQUvv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 16:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbZEQUvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 16:51:40 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:59777 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752037AbZEQUvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 16:51:39 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH] input: mt: add tracking ID to the MT protocol
Date: Sun, 17 May 2009 22:51:18 +0200
Message-Id: <1242593479-9238-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.5.6.3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: 83.248.194.102
X-Scan-Result: No virus found in message 1M5nKT-0001Df-5C.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1M5nKT-0001Df-5C 7897f070e16a3f0151d45350902bb7ec
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a few multi-touch devices that support finger tracking
well in hardware, Stantum being the prime example. By exposing the
tracking ID in the MT protocol, evdev bandwidth and cpu usage in
user space can be reduced.

This patch adds the ABS_MT_TRACKING_ID to the MT protocol.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Tested-by: Stéphane Chatty <chatty@enac.fr>
---
 drivers/input/input.c |    1 +
 include/linux/input.h |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index e54e002..5d445f4 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -42,6 +42,7 @@ static unsigned int input_abs_bypass_init_data[] __initdata = {
 	ABS_MT_POSITION_Y,
 	ABS_MT_TOOL_TYPE,
 	ABS_MT_BLOB_ID,
+	ABS_MT_TRACKING_ID,
 	0
 };
 static unsigned long input_abs_bypass[BITS_TO_LONGS(ABS_CNT)];
diff --git a/include/linux/input.h b/include/linux/input.h
index 0e6ff5d..6fed4f6 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -656,6 +656,7 @@ struct input_absinfo {
 #define ABS_MT_POSITION_Y	0x36	/* Center Y ellipse position */
 #define ABS_MT_TOOL_TYPE	0x37	/* Type of touching device */
 #define ABS_MT_BLOB_ID		0x38	/* Group a set of packets as a blob */
+#define ABS_MT_TRACKING_ID	0x39	/* Unique ID of initiated contact */
 
 #define ABS_MAX			0x3f
 #define ABS_CNT			(ABS_MAX+1)
-- 
1.5.6.3


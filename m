Return-Path: <linux-kernel-owner+w=401wt.eu-S1755713Ab0A1XDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713Ab0A1XDt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 18:03:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755213Ab0A1XDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 18:03:48 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:48533 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754181Ab0A1XDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 18:03:48 -0500
X-Greylist: delayed 1247 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Jan 2010 18:03:48 EST
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, jy0922.shim@samsung.com,
       mika.kuoppala@nokia.com, peter.hutterer@who-t.net,
       Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 1/2] input: mt: add the ABS_MT_PRESSURE event
Date: Thu, 28 Jan 2010 23:42:48 +0100
Message-Id: <1264718569-9772-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.6.3.3
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1Nad6R-0007Ek-4p.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1Nad6R-0007Ek-4p c582cf2e51d67f20899d97e41d5127d9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For pressure-based multi-touch devices, a direct way to send sensor
intensity data per finger is needed. This patch adds the ABS_MT_PRESSURE
event to the MT protocol.

Requested-by: Yoonyoung Shim <jy0922.shim@samsung.com>
Requested-by: Mika Kuoppala <mika.kuoppala@nokia.com>
Requested-by: Peter Hutterer <peter.hutterer@who-t.net>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/input.c |    1 +
 include/linux/input.h |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index 30b503b..86cb2d2 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -46,6 +46,7 @@ static unsigned int input_abs_bypass_init_data[] __initdata = {
 	ABS_MT_TOOL_TYPE,
 	ABS_MT_BLOB_ID,
 	ABS_MT_TRACKING_ID,
+	ABS_MT_PRESSURE,
 	0
 };
 static unsigned long input_abs_bypass[BITS_TO_LONGS(ABS_CNT)];
diff --git a/include/linux/input.h b/include/linux/input.h
index 7be8a65..735ceaf 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -660,6 +660,7 @@ struct input_absinfo {
 #define ABS_MT_TOOL_TYPE	0x37	/* Type of touching device */
 #define ABS_MT_BLOB_ID		0x38	/* Group a set of packets as a blob */
 #define ABS_MT_TRACKING_ID	0x39	/* Unique ID of initiated contact */
+#define ABS_MT_PRESSURE		0x3a	/* Pressure on contact area */
 
 #define ABS_MAX			0x3f
 #define ABS_CNT			(ABS_MAX+1)
-- 
1.6.3.3


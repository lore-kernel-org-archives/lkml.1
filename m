Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309AbZA1KYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbZA1KYs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 05:24:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910AbZA1KYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 05:24:05 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:45469 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751769AbZA1KYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 05:24:04 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 2/6] input: bcm5974: Add quad-finger tapping
Date: Wed, 28 Jan 2009 11:23:45 +0100
Message-Id: <1233138229-12489-3-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1233138229-12489-2-git-send-email-rydberg@euromail.se>
References: <1233138229-12489-1-git-send-email-rydberg@euromail.se>
 <1233138229-12489-2-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.192.132
X-Scan-Result: No virus found in message 1LS7aR-0000Q7-9Q.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1LS7aR-0000Q7-9Q 0b72b3d339a5061d45d6ba5ea30e5e63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The integrated button on the new unibody Macbooks presents a need to
report explicit four-finger actions. Evidently, the finger pressing
the button is also touching the trackpad, so in order to fully support
three-finger actions, the driver must be able to report four-finger
actions. This patch adds a new button, BTN_TOOL_QUADTAP, which
achieves this.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/mouse/bcm5974.c |    4 +++-
 include/linux/input.h         |    1 +
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
index e97462e..a170574 100644
--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -258,6 +258,7 @@ static void setup_events_to_report(struct input_dev *input_dev,
 	__set_bit(BTN_TOOL_FINGER, input_dev->keybit);
 	__set_bit(BTN_TOOL_DOUBLETAP, input_dev->keybit);
 	__set_bit(BTN_TOOL_TRIPLETAP, input_dev->keybit);
+	__set_bit(BTN_TOOL_QUADTAP, input_dev->keybit);
 	__set_bit(BTN_LEFT, input_dev->keybit);
 }
 
@@ -328,7 +329,8 @@ static int report_tp_state(struct bcm5974 *dev, int size)
 	input_report_key(input, BTN_TOUCH, dev->fingers > 0);
 	input_report_key(input, BTN_TOOL_FINGER, dev->fingers == 1);
 	input_report_key(input, BTN_TOOL_DOUBLETAP, dev->fingers == 2);
-	input_report_key(input, BTN_TOOL_TRIPLETAP, dev->fingers > 2);
+	input_report_key(input, BTN_TOOL_TRIPLETAP, dev->fingers == 3);
+	input_report_key(input, BTN_TOOL_QUADTAP, dev->fingers > 3);
 
 	input_report_abs(input, ABS_PRESSURE, abs_p);
 	input_report_abs(input, ABS_TOOL_WIDTH, abs_w);
diff --git a/include/linux/input.h b/include/linux/input.h
index 1249a0c..ee5754a 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -445,6 +445,7 @@ struct input_absinfo {
 #define BTN_STYLUS2		0x14c
 #define BTN_TOOL_DOUBLETAP	0x14d
 #define BTN_TOOL_TRIPLETAP	0x14e
+#define BTN_TOOL_QUADTAP	0x14f	/* Four fingers on trackpad */
 
 #define BTN_WHEEL		0x150
 #define BTN_GEAR_DOWN		0x150
-- 
1.5.6.3


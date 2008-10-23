Return-Path: <linux-kernel-owner+w=401wt.eu-S1756916AbYJWQZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916AbYJWQZc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 12:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbYJWQZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 12:25:22 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:59894 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752037AbYJWQZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 12:25:20 -0400
Message-ID: <4900A56D.7030900@euromail.se>
Date: Thu, 23 Oct 2008 18:25:17 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, akpm@osdl.org,
       linux-input@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] input: bcm5974: Add quad-finger tapping
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.192.132
X-Scan-Result: No virus found in message 1Kt2zu-0007cK-5m.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1Kt2zu-0007cK-5m 063bfabbce907f4546e1cbc3f9428c99
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
index b86fb55..0082b24 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -443,6 +443,7 @@ struct input_absinfo {
 #define BTN_STYLUS2		0x14c
 #define BTN_TOOL_DOUBLETAP	0x14d
 #define BTN_TOOL_TRIPLETAP	0x14e
+#define BTN_TOOL_QUADTAP	0x14f	/* Four fingers on trackpad */

 #define BTN_WHEEL		0x150
 #define BTN_GEAR_DOWN		0x150
-- 
1.5.6.3


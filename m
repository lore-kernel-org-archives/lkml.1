Return-Path: <linux-kernel-owner+w=401wt.eu-S1753211AbYKGLPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbYKGLPx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 06:15:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751895AbYKGLPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 06:15:43 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:34338 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751809AbYKGLPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 06:15:41 -0500
Message-ID: <49142351.9080805@euromail.se>
Date: Fri, 07 Nov 2008 12:15:29 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] input: Add a detailed multi-touch finger data report protocol
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.192.132
X-Scan-Result: No virus found in message 1KyPJT-0003qx-5I.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1KyPJT-0003qx-5I 18ba6e6edb1d1edf389d8351fc802d16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to utilize the full power of the new multi-touch devices, a
way to report detailed finger data to user space is needed. This patch
adds a multi-touch (MT) protocol which allows drivers to report details
for an arbitrary number of fingers.

BTN_MT_REPORT_PACKET

The driver presses this button to indicate the start of a packet of
finger data. The button is released after the whole packet has been
reported.

BTN_MT_REPORT_FINGER

The driver presses this button to indicate the start of a new
finger. The button is released when the finger has been reported.

In order to stay compatible with existing applications, the data
reported in a finger packet must not be recognized as single-touch
events. Therefore, a specific set of ABS_MT events is used instead.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 include/linux/input.h |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/linux/input.h b/include/linux/input.h
index b86fb55..c82dd42 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -590,6 +590,9 @@ struct input_absinfo {
 #define KEY_NUMERIC_STAR	0x20a
 #define KEY_NUMERIC_POUND	0x20b

+#define BTN_MT_REPORT_PACKET	0x210	/* report multitouch packet data */
+#define BTN_MT_REPORT_FINGER	0x211	/* report multitouch finger data */
+
 /* We avoid low common keys in module aliases so they don't get huge. */
 #define KEY_MIN_INTERESTING	KEY_MUTE
 #define KEY_MAX			0x2ff
@@ -642,6 +645,15 @@ struct input_absinfo {
 #define ABS_TOOL_WIDTH		0x1c
 #define ABS_VOLUME		0x20
 #define ABS_MISC		0x28
+#define ABS_MT_TOUCH		0x30	/* Diameter of touching circle */
+#define ABS_MT_TOUCH_MAJOR	0x30	/* Major axis of touching ellipse */
+#define ABS_MT_TOUCH_MINOR	0x31	/* Minor axis of touching ellipse */
+#define ABS_MT_WIDTH		0x32	/* Diameter of approaching circle */
+#define ABS_MT_WIDTH_MAJOR	0x32	/* Major axis of approaching ellipse */
+#define ABS_MT_WIDTH_MINOR	0x33	/* Minor axis of approaching ellipse */
+#define ABS_MT_ORIENTATION	0x34	/* Ellipse orientation */
+#define ABS_MT_POSITION_X	0x35	/* Center X ellipse position */
+#define ABS_MT_POSITION_Y	0x36	/* Center Y ellipse position */
 #define ABS_MAX			0x3f
 #define ABS_CNT			(ABS_MAX+1)

-- 
1.5.6.3


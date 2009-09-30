Return-Path: <linux-kernel-owner+w=401wt.eu-S1754215AbZI3N0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbZI3N0W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 09:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753862AbZI3N0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 09:26:21 -0400
Received: from smtp.nokia.com ([192.100.105.134]:42843 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbZI3N0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 09:26:20 -0400
From: Amit Kucheria <amit.kucheria@verdurent.com>
To: List Linux Kernel <linux-kernel@vger.kernel.org>, dtor@mail.ru,
       List Linux Omap <linux-omap@vger.kernel.org>
Cc: Tony Lindgren <tony@atomide.com>,
       Lauri Leukkunen <lauri.leukkunen@nokia.com>,
       Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH] input: fix rx51 board keymap
Date: Wed, 30 Sep 2009 16:25:28 +0300
Message-Id: <1254317128-13954-1-git-send-email-amit.kucheria@verdurent.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 30 Sep 2009 13:25:30.0956 (UTC) FILETIME=[7B81E0C0:01CA41D1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original driver was written with the KEY() macro defined as (col, row)
instead of (row, col) as defined by the matrix keypad infrastructure. So the
keymap was defined accordingly.

Since the driver that was merged upstream uses the matrix keypad
infrastructure, modify the keymap accordingly.

While we are at it, fix the comments in twl4030.h and define PERSISTENT_KEY as
(r,c) instead of (c, r)

Tested on a RX51 (N900) device.

Signed-off-by: Amit Kucheria <amit.kucheria@verdurent.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Lauri Leukkunen <lauri.leukkunen@nokia.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
---
 arch/arm/mach-omap2/board-rx51-peripherals.c |   78 +++++++++++++-------------
 include/linux/i2c/twl4030.h                  |    6 +-
 2 files changed, 42 insertions(+), 42 deletions(-)

diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
index b45ad31..c1af532 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -38,49 +38,49 @@
 
 static int board_keymap[] = {
 	KEY(0, 0, KEY_Q),
-	KEY(0, 1, KEY_W),
-	KEY(0, 2, KEY_E),
-	KEY(0, 3, KEY_R),
-	KEY(0, 4, KEY_T),
-	KEY(0, 5, KEY_Y),
-	KEY(0, 6, KEY_U),
-	KEY(0, 7, KEY_I),
-	KEY(1, 0, KEY_O),
+	KEY(0, 1, KEY_O),
+	KEY(0, 2, KEY_P),
+	KEY(0, 3, KEY_COMMA),
+	KEY(0, 4, KEY_BACKSPACE),
+	KEY(0, 6, KEY_A),
+	KEY(0, 7, KEY_S),
+	KEY(1, 0, KEY_W),
 	KEY(1, 1, KEY_D),
-	KEY(1, 2, KEY_DOT),
-	KEY(1, 3, KEY_V),
-	KEY(1, 4, KEY_DOWN),
-	KEY(2, 0, KEY_P),
-	KEY(2, 1, KEY_F),
+	KEY(1, 2, KEY_F),
+	KEY(1, 3, KEY_G),
+	KEY(1, 4, KEY_H),
+	KEY(1, 5, KEY_J),
+	KEY(1, 6, KEY_K),
+	KEY(1, 7, KEY_L),
+	KEY(2, 0, KEY_E),
+	KEY(2, 1, KEY_DOT),
 	KEY(2, 2, KEY_UP),
-	KEY(2, 3, KEY_B),
-	KEY(2, 4, KEY_RIGHT),
-	KEY(3, 0, KEY_COMMA),
-	KEY(3, 1, KEY_G),
-	KEY(3, 2, KEY_ENTER),
+	KEY(2, 3, KEY_ENTER),
+	KEY(2, 5, KEY_Z),
+	KEY(2, 6, KEY_X),
+	KEY(2, 7, KEY_C),
+	KEY(3, 0, KEY_R),
+	KEY(3, 1, KEY_V),
+	KEY(3, 2, KEY_B),
 	KEY(3, 3, KEY_N),
-	KEY(4, 0, KEY_BACKSPACE),
-	KEY(4, 1, KEY_H),
-	KEY(4, 3, KEY_M),
+	KEY(3, 4, KEY_M),
+	KEY(3, 5, KEY_SPACE),
+	KEY(3, 6, KEY_SPACE),
+	KEY(3, 7, KEY_LEFT),
+	KEY(4, 0, KEY_T),
+	KEY(4, 1, KEY_DOWN),
+	KEY(4, 2, KEY_RIGHT),
 	KEY(4, 4, KEY_LEFTCTRL),
-	KEY(5, 1, KEY_J),
-	KEY(5, 2, KEY_Z),
-	KEY(5, 3, KEY_SPACE),
-	KEY(5, 4, KEY_LEFTSHIFT),
-	KEY(6, 0, KEY_A),
-	KEY(6, 1, KEY_K),
-	KEY(6, 2, KEY_X),
-	KEY(6, 3, KEY_SPACE),
-	KEY(6, 4, KEY_FN),
-	KEY(7, 0, KEY_S),
-	KEY(7, 1, KEY_L),
-	KEY(7, 2, KEY_C),
-	KEY(7, 3, KEY_LEFT),
-	KEY(0xff, 0, KEY_F6),
-	KEY(0xff, 1, KEY_F7),
-	KEY(0xff, 2, KEY_F8),
-	KEY(0xff, 4, KEY_F9),
-	KEY(0xff, 5, KEY_F10),
+	KEY(4, 5, KEY_RIGHTALT),
+	KEY(4, 6, KEY_LEFTSHIFT),
+	KEY(5, 0, KEY_Y),
+	KEY(6, 0, KEY_U),
+	KEY(7, 0, KEY_I),
+	KEY(7, 1, KEY_F7),
+	KEY(7, 2, KEY_F8),
+	KEY(0xff, 2, KEY_F9),
+	KEY(0xff, 4, KEY_F10),
+	KEY(0xff, 5, KEY_F11),
 };
 
 static struct matrix_keymap_data board_map_data = {
diff --git a/include/linux/i2c/twl4030.h b/include/linux/i2c/twl4030.h
index 2d02dfd..508824e 100644
--- a/include/linux/i2c/twl4030.h
+++ b/include/linux/i2c/twl4030.h
@@ -349,11 +349,11 @@ struct twl4030_madc_platform_data {
 	int		irq_line;
 };
 
-/* Boards have uniqe mappings of {col, row} --> keycode.
- * Column and row are 4 bits, but range only from 0..7.
+/* Boards have uniqe mappings of {row, col} --> keycode.
+ * Column and row are 8 bits each, but range only from 0..7.
  * a PERSISTENT_KEY is "always on" and never reported.
  */
-#define PERSISTENT_KEY(c, r)	KEY((c), (r), KEY_RESERVED)
+#define PERSISTENT_KEY(r, c)	KEY((r), (c), KEY_RESERVED)
 
 struct twl4030_keypad_data {
 	const struct matrix_keymap_data *keymap_data;
-- 
1.6.3.3


Return-Path: <linux-kernel-owner+w=401wt.eu-S932065AbXKMVgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065AbXKMVgf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 16:36:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763572AbXKMVgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 16:36:20 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:59737 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762827AbXKMVgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 16:36:19 -0500
Date: Tue, 13 Nov 2007 22:36:12 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: dmitry.torokhov@gmail.com, linux-input@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 4/4] drivers/input: Drop redundant includes of moduleparam.h
Message-ID: <Pine.LNX.4.64.0711132235150.18337@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Drop #include <linux/moduleparam.h> in files that also include #include
<linux/module.h>.  module.h includes moduleparam.h already.

The semantic patch implementing this change is as follows:

@ includesmodule @
@@

#include <linux/module.h>

@ depends on includesmodule @
@@

- #include <linux/moduleparam.h>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -u -p -b -B a/drivers/input/joystick/amijoy.c b/drivers/input/joystick/amijoy.c
--- a/drivers/input/joystick/amijoy.c 2007-10-22 11:25:09.000000000 +0200
+++ b/drivers/input/joystick/amijoy.c 2007-11-13 17:50:33.000000000 +0100
@@ -32,7 +32,6 @@
  #include <linux/errno.h>
  #include <linux/kernel.h>
  #include <linux/module.h>
-#include <linux/moduleparam.h>
  #include <linux/init.h>
  #include <linux/input.h>
  #include <linux/interrupt.h>
diff -u -p -b -B a/drivers/input/joystick/analog.c b/drivers/input/joystick/analog.c
--- a/drivers/input/joystick/analog.c 2007-10-22 11:25:09.000000000 +0200
+++ b/drivers/input/joystick/analog.c 2007-11-13 17:50:33.000000000 +0100
@@ -31,7 +31,6 @@
  #include <linux/delay.h>
  #include <linux/kernel.h>
  #include <linux/module.h>
-#include <linux/moduleparam.h>
  #include <linux/slab.h>
  #include <linux/bitops.h>
  #include <linux/init.h>
diff -u -p -b -B a/drivers/input/joystick/db9.c b/drivers/input/joystick/db9.c
--- a/drivers/input/joystick/db9.c 2007-10-22 11:25:09.000000000 +0200
+++ b/drivers/input/joystick/db9.c 2007-11-13 17:50:33.000000000 +0100
@@ -33,7 +33,6 @@

  #include <linux/kernel.h>
  #include <linux/module.h>
-#include <linux/moduleparam.h>
  #include <linux/delay.h>
  #include <linux/init.h>
  #include <linux/parport.h>
diff -u -p -b -B a/drivers/input/joystick/gamecon.c b/drivers/input/joystick/gamecon.c
--- a/drivers/input/joystick/gamecon.c 2007-10-22 11:25:09.000000000 +0200
+++ b/drivers/input/joystick/gamecon.c 2007-11-13 17:50:34.000000000 +0100
@@ -33,7 +33,6 @@
  #include <linux/kernel.h>
  #include <linux/delay.h>
  #include <linux/module.h>
-#include <linux/moduleparam.h>
  #include <linux/init.h>
  #include <linux/parport.h>
  #include <linux/input.h>
diff -u -p -b -B a/drivers/input/joystick/turbografx.c b/drivers/input/joystick/turbografx.c
--- a/drivers/input/joystick/turbografx.c 2007-10-22 11:25:09.000000000 +0200
+++ b/drivers/input/joystick/turbografx.c 2007-11-13 17:50:35.000000000 +0100
@@ -35,7 +35,6 @@
  #include <linux/parport.h>
  #include <linux/input.h>
  #include <linux/module.h>
-#include <linux/moduleparam.h>
  #include <linux/init.h>
  #include <linux/mutex.h>

diff -u -p -b -B a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
--- a/drivers/input/joystick/xpad.c 2007-11-08 08:00:51.000000000 +0100
+++ b/drivers/input/joystick/xpad.c 2007-11-13 17:50:36.000000000 +0100
@@ -75,7 +75,6 @@
  #include <linux/slab.h>
  #include <linux/stat.h>
  #include <linux/module.h>
-#include <linux/moduleparam.h>
  #include <linux/usb/input.h>

  #define DRIVER_VERSION "v0.0.6"
diff -u -p -b -B a/drivers/input/keyboard/atkbd.c b/drivers/input/keyboard/atkbd.c
--- a/drivers/input/keyboard/atkbd.c 2007-10-22 11:25:09.000000000 +0200
+++ b/drivers/input/keyboard/atkbd.c 2007-11-13 17:50:36.000000000 +0100
@@ -19,7 +19,6 @@

  #include <linux/delay.h>
  #include <linux/module.h>
-#include <linux/moduleparam.h>
  #include <linux/slab.h>
  #include <linux/interrupt.h>
  #include <linux/init.h>
diff -u -p -b -B a/drivers/input/keyboard/lkkbd.c b/drivers/input/keyboard/lkkbd.c
--- a/drivers/input/keyboard/lkkbd.c 2007-06-02 22:32:14.000000000 +0200
+++ b/drivers/input/keyboard/lkkbd.c 2007-11-13 17:50:37.000000000 +0100
@@ -64,7 +64,6 @@
  #include <linux/delay.h>
  #include <linux/slab.h>
  #include <linux/module.h>
-#include <linux/moduleparam.h>
  #include <linux/interrupt.h>
  #include <linux/init.h>
  #include <linux/input.h>
diff -u -p -b -B a/drivers/input/misc/ati_remote.c b/drivers/input/misc/ati_remote.c
--- a/drivers/input/misc/ati_remote.c 2007-10-22 11:25:09.000000000 +0200
+++ b/drivers/input/misc/ati_remote.c 2007-11-13 17:50:38.000000000 +0100
@@ -90,7 +90,6 @@
  #include <linux/init.h>
  #include <linux/slab.h>
  #include <linux/module.h>
-#include <linux/moduleparam.h>
  #include <linux/usb/input.h>
  #include <linux/wait.h>
  #include <linux/jiffies.h>
diff -u -p -b -B a/drivers/input/misc/keyspan_remote.c b/drivers/input/misc/keyspan_remote.c
--- a/drivers/input/misc/keyspan_remote.c 2007-10-22 11:25:09.000000000 +0200
+++ b/drivers/input/misc/keyspan_remote.c 2007-11-13 17:50:39.000000000 +0100
@@ -16,7 +16,6 @@
  #include <linux/init.h>
  #include <linux/slab.h>
  #include <linux/module.h>
-#include <linux/moduleparam.h>
  #include <linux/usb/input.h>

  #define DRIVER_VERSION	"v0.1"
diff -u -p -b -B a/drivers/input/mouse/inport.c b/drivers/input/mouse/inport.c
--- a/drivers/input/mouse/inport.c 2007-11-08 08:00:51.000000000 +0100
+++ b/drivers/input/mouse/inport.c 2007-11-13 17:50:40.000000000 +0100
@@ -35,7 +35,6 @@
   */

  #include <linux/module.h>
-#include <linux/moduleparam.h>
  #include <linux/ioport.h>
  #include <linux/init.h>
  #include <linux/interrupt.h>
diff -u -p -b -B a/drivers/input/mouse/logibm.c b/drivers/input/mouse/logibm.c
--- a/drivers/input/mouse/logibm.c 2007-11-08 08:00:51.000000000 +0100
+++ b/drivers/input/mouse/logibm.c 2007-11-13 17:50:40.000000000 +0100
@@ -36,7 +36,6 @@
   */

  #include <linux/module.h>
-#include <linux/moduleparam.h>
  #include <linux/delay.h>
  #include <linux/ioport.h>
  #include <linux/init.h>
diff -u -p -b -B a/drivers/input/mouse/psmouse-base.c b/drivers/input/mouse/psmouse-base.c
--- a/drivers/input/mouse/psmouse-base.c 2007-10-22 11:25:09.000000000 +0200
+++ b/drivers/input/mouse/psmouse-base.c 2007-11-13 17:50:40.000000000 +0100
@@ -13,7 +13,6 @@

  #include <linux/delay.h>
  #include <linux/module.h>
-#include <linux/moduleparam.h>
  #include <linux/slab.h>
  #include <linux/interrupt.h>
  #include <linux/input.h>
diff -u -p -b -B a/drivers/input/mouse/trackpoint.c b/drivers/input/mouse/trackpoint.c
--- a/drivers/input/mouse/trackpoint.c 2007-02-09 17:34:12.000000000 +0100
+++ b/drivers/input/mouse/trackpoint.c 2007-11-13 17:50:41.000000000 +0100
@@ -11,7 +11,6 @@
  #include <linux/delay.h>
  #include <linux/serio.h>
  #include <linux/module.h>
-#include <linux/moduleparam.h>
  #include <linux/input.h>
  #include <linux/libps2.h>
  #include <linux/proc_fs.h>
diff -u -p -b -B a/drivers/input/mousedev.c b/drivers/input/mousedev.c
--- a/drivers/input/mousedev.c 2007-10-22 11:25:09.000000000 +0200
+++ b/drivers/input/mousedev.c 2007-11-13 17:50:42.000000000 +0100
@@ -16,7 +16,6 @@
  #include <linux/slab.h>
  #include <linux/poll.h>
  #include <linux/module.h>
-#include <linux/moduleparam.h>
  #include <linux/init.h>
  #include <linux/input.h>
  #include <linux/random.h>
diff -u -p -b -B a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
--- a/drivers/input/serio/i8042.c 2007-11-01 10:30:39.000000000 +0100
+++ b/drivers/input/serio/i8042.c 2007-11-13 17:50:44.000000000 +0100
@@ -12,7 +12,6 @@

  #include <linux/delay.h>
  #include <linux/module.h>
-#include <linux/moduleparam.h>
  #include <linux/interrupt.h>
  #include <linux/ioport.h>
  #include <linux/init.h>
diff -u -p -b -B a/drivers/input/serio/libps2.c b/drivers/input/serio/libps2.c
--- a/drivers/input/serio/libps2.c 2007-06-02 22:32:15.000000000 +0200
+++ b/drivers/input/serio/libps2.c 2007-11-13 17:50:44.000000000 +0100
@@ -13,7 +13,6 @@

  #include <linux/delay.h>
  #include <linux/module.h>
-#include <linux/moduleparam.h>
  #include <linux/slab.h>
  #include <linux/interrupt.h>
  #include <linux/input.h>
diff -u -p -b -B a/drivers/input/touchscreen/mk712.c b/drivers/input/touchscreen/mk712.c
--- a/drivers/input/touchscreen/mk712.c 2007-10-22 11:25:09.000000000 +0200
+++ b/drivers/input/touchscreen/mk712.c 2007-11-13 17:50:45.000000000 +0100
@@ -36,7 +36,6 @@
   */

  #include <linux/module.h>
-#include <linux/moduleparam.h>
  #include <linux/kernel.h>
  #include <linux/init.h>
  #include <linux/errno.h>
diff -u -p -b -B a/drivers/input/touchscreen/ucb1400_ts.c b/drivers/input/touchscreen/ucb1400_ts.c
--- a/drivers/input/touchscreen/ucb1400_ts.c 2007-10-22 11:25:09.000000000 +0200
+++ b/drivers/input/touchscreen/ucb1400_ts.c 2007-11-13 17:50:46.000000000 +0100
@@ -15,7 +15,6 @@
   */

  #include <linux/module.h>
-#include <linux/moduleparam.h>
  #include <linux/init.h>
  #include <linux/completion.h>
  #include <linux/delay.h>

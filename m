Return-Path: <linux-kernel-owner+w=401wt.eu-S933266AbZHDWAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933266AbZHDWAU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 18:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933191AbZHDWAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 18:00:19 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36920 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933186AbZHDWAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 18:00:18 -0400
Date: Wed, 5 Aug 2009 00:00:10 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Cc: arve@android.com
Subject: synaptics touchscreen for dream: documentation
Message-ID: <20090804220009.GA2077@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This adds pointer to hardware documentation, and adds code comment
from Arve.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/staging/dream/synaptics_i2c_rmi.c b/drivers/staging/dream/synaptics_i2c_rmi.c
index 3770d2c..dc1e3c7 100644
--- a/drivers/staging/dream/synaptics_i2c_rmi.c
+++ b/drivers/staging/dream/synaptics_i2c_rmi.c
@@ -13,6 +13,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
+ * http://www.synaptics.com/sites/default/files/511_000099_01F.pdf
  */
 
 #include <linux/module.h>
@@ -87,6 +88,22 @@ static int synaptics_init_panel(struct synaptics_ts_data *ts)
 
 static void decode_report(struct synaptics_ts_data *ts, u8 *buf)
 {
+/* 
+ * This sensor sends two 6-byte absolute finger reports, an optional
+ * 2-byte relative report followed by a status byte. This function
+ * reads the two finger reports and transforms the coordinates
+ * according the platform data so they can be aligned with the lcd
+ * behind the touchscreen. Typically we flip the y-axis since the
+ * sensor uses the bottom left corner as the origin, but if the sensor
+ * is mounted upside down the platform data will request that the
+ * x-axis should be flipped instead. The snap to inactive edge border
+ * are used to allow tapping the edges of the screen on the G1. The
+ * active area of the touchscreen is smaller than the lcd. When the
+ * finger gets close the edge of the screen we snap it to the
+ * edge. This allows ui elements at the edge of the screen to be hit,
+ * and it prevents hitting ui elements that are not at the edge of the
+ * screen when the finger is touching the edge.
+ */
 	int pos[2][2];
 	int f, a;
 	int base = 2;

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

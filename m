Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943Ab0CHVOL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 16:14:11 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:62249 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755775Ab0CHVOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 16:14:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=FuqcwRqQruiHghyQOUbUmWKmExB1Bn+2+8KDhwjvwujgVClHK9dT131J5gh+e8svI6
         AmX9Z8LRISbTZBvOYQJDuLGnlMPY4AwBcMhzrPNgoX0zAyOnIr8Sh1uJ5jhICY6gshEY
         kD47sW+p6NyYO3c0EnZiuqzM3AGdugPIp6DOg=
From: mickib1@gmail.com
To: jkosina@suse.cz, rafi@seas.upenn.edu, chatty@enac.fr, peterhuewe@gmx.de,
       micki@n-trig.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] HID: N-trig MTM Driver fix And cleanup patch 3
Date: Mon,  8 Mar 2010 23:13:43 +0200
Message-Id: <1268082827-2680-3-git-send-email-micki@n-trig.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1268082827-2680-2-git-send-email-micki@n-trig.com>
References: <1268082827-2680-1-git-send-email-micki@n-trig.com>
 <1268082827-2680-2-git-send-email-micki@n-trig.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: micki <micki@micki-laptop.(none)>

Change ntrig_input_mapped function to support EV_MSC events.
Support pen button left/right

N-trig is changing the way people interact with computers by providing a dual-mode pen and true multi-touch input device, specifically designed for today's advanced computing world.
N-trig DuoSense® solution provides a real Hands-on computing® experience, and sets the stage for OEMs and ISVs to introduce innovative computer products and applications for an intuitive, Hands-on® experience directly onscreen.
DuoSense digitizers are easily integrated into existing technologies, support all LCDs, keep devices slim and light, and can be implemented in a broad range of products, ranging from small notebooks to large LCDs.
N-trig has offices in Israel, the US, Taiwan and Japan.

Signed-off-by: Micki Balanga <micki@n-trig.com>
---
 drivers/hid/hid-ntrig.c |   26 ++++++++++++++++++--------
 1 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
index 3602cd0..8130c3c 100644
--- a/drivers/hid/hid-ntrig.c
+++ b/drivers/hid/hid-ntrig.c
@@ -16,6 +16,7 @@
  *	1.1 - N-trig - Add Change Log and defines of MTM firmware.
  *		Add debug Paramater change Driver name in hid_driver structure
  *	1.2 - N-trig - Change ntrig_input_mapping
+ *	1.3 - N-trig - Change ntrig_input_mapped
  */
 
 /*
@@ -182,14 +183,23 @@ static int ntrig_input_mapped(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
 		unsigned long **bit, int *max)
 {
-	/* No special mappings needed for the pen and single touch */
-	if (field->physical)
-		return 0;
-
-	if (usage->type == EV_KEY || usage->type == EV_REL
-			|| usage->type == EV_ABS)
-		clear_bit(usage->code, *bit);
-
+       /*
+	* Maps Key For Pen And Touch events
+	* MSC events used to transfer information about finger status
+	* In cureent Frame
+	* todo: Maybe later transfer to mt proctol
+	* if there will be relevant events
+	*/
+	struct input_dev *input = hi->input;
+	set_bit(BTN_LEFT, input->keybit);
+	set_bit(BTN_RIGHT, input->keybit);
+	set_bit(EV_MSC, input->evbit);
+	set_bit(MSC_PULSELED, input->mscbit);
+	set_bit(MSC_SERIAL, input->mscbit);
+	set_bit(MSC_SCAN, input->mscbit);
+
+	input_set_abs_params(hi->input, ABS_PRESSURE,
+			0/*Min*/, 255 /*Max*/, 0, 0);
 	return 0;
 }
 
-- 
1.6.3.3


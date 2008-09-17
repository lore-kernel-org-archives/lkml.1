Return-Path: <linux-kernel-owner+w=401wt.eu-S1756254AbYIQWXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254AbYIQWXz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 18:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbYIQWXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 18:23:43 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:55279 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754098AbYIQWXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 18:23:42 -0400
Message-ID: <48D1836D.9060106@euromail.se>
Date: Thu, 18 Sep 2008 00:23:41 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Nicolas Boichat <nicolas@boichat.ch>, lm-sensors@lm-sensors.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] hwmon: applesmc: Prolong status wait
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.33.63
X-Scan-Result: No virus found in message 1Kg5Qz-00039S-81.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1Kg5Qz-00039S-81 21460c8da675d2b102c2665c89874af6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The time to wait for a status change while reading or writing to the
SMC ports is a balance between read reliability and system
performance. The current setting yields rougly three errors in a
thousand when simultaneously reading three different temperature
values on a Macbook Air. This patch increases the setting to a value
yielding roughly one error in ten thousand, with no noticable system
performance degradation.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hwmon/applesmc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index b06b8e0..091338c 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -163,7 +163,7 @@ static unsigned int key_at_index;
 static struct workqueue_struct *applesmc_led_wq;

 /*
- * __wait_status - Wait up to 2ms for the status port to get a certain value
+ * __wait_status - Wait up to 10ms for the status port to get a certain value
  * (masked with 0x0f), returning zero if the value is obtained.  Callers must
  * hold applesmc_lock.
  */
@@ -173,7 +173,7 @@ static int __wait_status(u8 val)

 	val = val & APPLESMC_STATUS_MASK;

-	for (i = 0; i < 200; i++) {
+	for (i = 0; i < 1000; i++) {
 		if ((inb(APPLESMC_CMD_PORT) & APPLESMC_STATUS_MASK) == val) {
 			if (debug)
 				printk(KERN_DEBUG
-- 
1.5.4.3


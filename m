Return-Path: <linux-kernel-owner+w=401wt.eu-S1754816AbZJCOgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbZJCOgz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 10:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754207AbZJCOgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 10:36:54 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:61281 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752927AbZJCOgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 10:36:54 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsAEAA39xkpR8xqU/2dsb2JhbACBUdBhhCoE
Message-ID: <4AC76178.8090302@computer.org>
Date: Sat, 03 Oct 2009 16:36:40 +0200
From: Jan Ceuleers <jan.ceuleers@computer.org>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Richard Purdie <rpurdie@rpsys.net>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/video/backlight: memset region size error
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 61755f56b829f59a40f9d30799651f80a3554104 Mon Sep 17 00:00:00 2001
From: Jan Ceuleers <jan.ceuleers@computer.org>
Date: Sat, 3 Oct 2009 16:00:36 +0200
Subject: [PATCH] drivers/video/backlight: memset region size error

The size of the region to be memset() should be the size
of the target rather than the size of the pointer to it.

Compile-tested only.

Signed-off-by: Jan Ceuleers <jan.ceuleers@computer.org>

---
 drivers/video/backlight/lcd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/backlight/lcd.c b/drivers/video/backlight/lcd.c
index b644947..a482dd7 100644
--- a/drivers/video/backlight/lcd.c
+++ b/drivers/video/backlight/lcd.c
@@ -56,7 +56,7 @@ static int fb_notifier_callback(struct notifier_block *self,
 
 static int lcd_register_fb(struct lcd_device *ld)
 {
-	memset(&ld->fb_notif, 0, sizeof(&ld->fb_notif));
+	memset(&ld->fb_notif, 0, sizeof(ld->fb_notif));
 	ld->fb_notif.notifier_call = fb_notifier_callback;
 	return fb_register_client(&ld->fb_notif);
 }
-- 
1.5.4.3

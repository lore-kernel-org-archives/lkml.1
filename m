Return-Path: <linux-kernel-owner+w=401wt.eu-S1754071AbZBITih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071AbZBITih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 14:38:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754317AbZBITgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 14:36:03 -0500
Received: from kroah.org ([198.145.64.141]:34774 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755263AbZBITfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 14:35:50 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Sachin P. Sant" <sachinp@in.ibm.com>, Willy Tarreau <w@1wt.eu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 6/6] Staging: panel: fix lcd panel driver build failure
Date: Mon,  9 Feb 2009 11:34:06 -0800
Message-Id: <1234208046-2295-6-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.1.2
In-Reply-To: <20090209193201.GB2194@kroah.com>
References: <20090209193201.GB2194@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sachin P. Sant <sachinp@in.ibm.com>

* Fix build break for lcd panel driver.

Signed-off-by : Sachin Sant <sachinp@in.ibm.com>
Cc: Willy Tarreau <w@1wt.eu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/panel/panel.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 5ffe269..ab69c1b 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -622,7 +622,7 @@ static int set_ctrl_bits(void)
 }
 
 /* sets ctrl & data port bits according to current signals values */
-static void set_bits(void)
+static void panel_set_bits(void)
 {
 	set_data_bits();
 	set_ctrl_bits();
@@ -707,12 +707,12 @@ static void lcd_send_serial(int byte)
 	 */
 	for (bit = 0; bit < 8; bit++) {
 		bits.cl = BIT_CLR;	/* CLK low */
-		set_bits();
+		panel_set_bits();
 		bits.da = byte & 1;
-		set_bits();
+		panel_set_bits();
 		udelay(2);	/* maintain the data during 2 us before CLK up */
 		bits.cl = BIT_SET;	/* CLK high */
-		set_bits();
+		panel_set_bits();
 		udelay(1);	/* maintain the strobe during 1 us */
 		byte >>= 1;
 	}
@@ -727,7 +727,7 @@ static void lcd_backlight(int on)
 	/* The backlight is activated by seting the AUTOFEED line to +5V  */
 	spin_lock(&pprt_lock);
 	bits.bl = on;
-	set_bits();
+	panel_set_bits();
 	spin_unlock(&pprt_lock);
 }
 
-- 
1.6.0.2


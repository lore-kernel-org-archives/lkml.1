Return-Path: <linux-kernel-owner+w=401wt.eu-S1753995AbZKPRSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbZKPRSZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 12:18:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753718AbZKPRSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 12:18:23 -0500
Received: from bar.sig21.net ([80.81.252.164]:55558 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753684AbZKPRSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 12:18:18 -0500
Date: Mon, 16 Nov 2009 18:18:14 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] input: atkbd - add forced release kays quirk for Samsung
 N130
Message-ID: <20091116171814.GA26183@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -2.9 (--)
X-Spam-21-Report: No, score=-2.9 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.027,BAYES_05=-1.11 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samsung N130 has the same function key quirks as the NC10.

Signed-off-by: Johannes Stezenbach <js@sig21.net>
---
It would be nice if this could go into 2.6.32.  It might also be
suitable for stable.


diff --git a/drivers/input/keyboard/atkbd.c b/drivers/input/keyboard/atkbd.c
index 4452eab..ad2dc7d 100644
--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -1646,6 +1646,15 @@ static struct dmi_system_id atkbd_dmi_quirk_table[] __initdata = {
 		.driver_data = atkbd_samsung_forced_release_keys,
 	},
 	{
+		.ident = "Samsung N130",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "N130"),
+		},
+		.callback = atkbd_setup_forced_release,
+		.driver_data = atkbd_samsung_forced_release_keys,
+	},
+	{
 		.ident = "Samsung SQ45S70S",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),

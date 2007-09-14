Return-Path: <linux-kernel-owner+w=401wt.eu-S1759231AbXINLjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759231AbXINLjq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 07:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754040AbXINLjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 07:39:35 -0400
Received: from mail.arklinux.osuosl.org ([140.211.166.26]:41344 "EHLO
	mail.arklinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755819AbXINLje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 07:39:34 -0400
From: Bernhard Rosenkraenzer <bero@arklinux.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Make wistron-btns recognize special keys on Medion WIM2160 notebooks
Date: Fri, 14 Sep 2007 13:37:36 +0200
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709141337.36398.bero@arklinux.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below adds support for Medion WIM2160 notebooks to the wistron-btns 
driver.

Signed-off-by: Bernhard Rosenkraenzer <bero@arklinux.org>

--- linux-2.6.22/drivers/input/misc/wistron_btns.c.ark	2007-09-07 
22:47:49.000000000 +0000
+++ linux-2.6.22/drivers/input/misc/wistron_btns.c	2007-09-07 
22:54:19.000000000 +0000
@@ -536,6 +536,13 @@
 	{ KE_END, FE_MAIL_LED | FE_WIFI_LED | FE_UNTESTED }
 };
 
+static struct key_entry keymap_medion_wim2160[] __initdata = {
+	{ KE_WIFI, 0x30 },
+	{ KE_KEY, 0x11, {KEY_PROG1} },
+	{ KE_KEY, 0x12, {KEY_PROG2} },
+	{ KE_END, 0 }
+};
+
 static struct key_entry keymap_wistron_md2900[] __initdata = {
 	{ KE_KEY, 0x01, {KEY_HELP} },
 	{ KE_KEY, 0x02, {KEY_CONFIG} },
@@ -917,6 +924,15 @@
 		},
 		.driver_data = keymap_fs_amilo_d88x0
 	},
+	{
+		.callback = dmi_matched,
+		.ident = "Medion WIM2160",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "MEDION"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "WIM2160"),
+		},
+		.driver_data = keymap_medion_wim2160
+	},
 	{ NULL, }
 };
 

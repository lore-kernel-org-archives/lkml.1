Return-Path: <linux-kernel-owner+w=401wt.eu-S1754571AbXICWDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571AbXICWDV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 18:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754792AbXICWC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 18:02:58 -0400
Received: from prans.org ([209.59.209.223]:38281 "EHLO prans.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754441AbXICWC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 18:02:56 -0400
X-Greylist: delayed 929 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Sep 2007 18:02:56 EDT
From: Elvis Pranskevichus <el@prans.net>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Dmitry Torokhov <dtor@insightbb.com>, Elvis Pranskevichus <el@prans.net>
Subject: [PATCH] Input: i8042 - add HP Pavilion DV4270ca to the MUX blacklist
Date: Mon,  3 Sep 2007 17:47:18 -0400
Message-Id: <11888560383968-git-send-email-el@prans.net>
X-Mailer: git-send-email 1.5.3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes "atkbd.c: Suprious NAK on isa0060/serio0" errors for
HP Pavilion DV4270ca. Same reasons as for 9d9d50bb2efb50594abfc3941a5504b62c514ebd
and 6e782584e0713ea89da151333e7fe754c8f40324.

Signed-off-by: Elvis Pranskevichus <el@prans.net>

 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index 702a526..f8fe421 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -211,6 +211,16 @@ static struct dmi_system_id __initdata i8042_dmi_nomux_table[] = {
 		},
 	},
 	{
+		/*
+		 * Like DV4017EA does not raise AUXERR for errors on MUX ports.
+		 */
+		.ident = "HP Pavilion DV4270ca",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Pavilion dv4000 (EH476UA#ABL)"),
+		},
+	},
+	{
 		.ident = "Toshiba P10",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
-- 
1.5.3


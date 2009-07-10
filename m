Return-Path: <linux-kernel-owner+w=401wt.eu-S1757753AbZGJXNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757753AbZGJXNk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 19:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757895AbZGJXNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 19:13:21 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:48853 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757667AbZGJXNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 19:13:19 -0400
Message-ID: <4A57CB09.9030404@nexxdesign.co.uk>
Date: Sat, 11 Jul 2009 00:13:13 +0100
From: Nexx <nexx@nexxdesign.co.uk>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: dmitry.torokhov@gmail.com
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] linux-2.6.30.1 atkbd.c: Add FSC Amilo Pi 3525 Hotkey forced
 releasing
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Simon Davie <nexx@nexxdesign.co.uk>

This patch enables forced releasing of the Fn+Volume hotkeys
on the Fujitsu Siemens Amilo Pi 3525 notebook.

Signed-off-by: Simon Davie <nexx@nexxdesign.co.uk>
---
--- linux-2.6.30/drivers/input/keyboard/atkbd.c.orig	2009-07-10 22:54:21.000000000 +0100
+++ linux-2.6.30/drivers/input/keyboard/atkbd.c	2009-07-10 23:02:43.000000000 +0100
@@ -895,6 +895,13 @@ static unsigned int atkbd_amilo_pa1510_f
 };

 /*
+ * Amilo Pi 3525 key release for Fn+Volume keys not working
+ */
+static unsigned int atkbd_amilo_pi3525_forced_release_keys[] = {
+	0x20, 0xa0, 0x2e, 0xae, 0x30, 0xb0, -1U
+};
+
+/*
  * Amilo Xi 3650 key release for light touch bar not working
  */
 static unsigned int atkbd_amilo_xi3650_forced_release_keys[] = {
@@ -1568,6 +1575,15 @@ static struct dmi_system_id atkbd_dmi_qu
 		.driver_data = atkbd_amilo_pa1510_forced_release_keys,
 	},
 	{
+		.ident = "Fujitsu Amilo Pi 3525",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "AMILO Pi 3525"),
+		},
+		.callback = atkbd_setup_forced_release,
+		.driver_data = atkbd_amilo_pi3525_forced_release_keys,
+	},
+	{
 		.ident = "Fujitsu Amilo Xi 3650",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),

---

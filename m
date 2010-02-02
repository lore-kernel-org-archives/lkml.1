Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883Ab0BBHrP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 02:47:15 -0500
Received: from iksaif.net ([88.191.73.63]:48713 "EHLO iksaif.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755504Ab0BBHrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 02:47:08 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Corentin Chary <corentincj@iksaif.net>
Subject: [PATCH 01/28] asus-laptop: add wireless and bluetooth status parameter
Date: Tue,  2 Feb 2010 08:38:44 +0100
Message-Id: <1265096351-15239-2-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1265096351-15239-1-git-send-email-corentincj@iksaif.net>
References: <1265096351-15239-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These to parameter allow to set the status of wlan and bluetooth
device when the module load. On some models, the device will
always be down on boot, so the default behavior is to always
enable these devices.

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/asus-laptop.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index 61a1c75..1d799b3 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -113,6 +113,19 @@ static uint wapf = 1;
 module_param(wapf, uint, 0644);
 MODULE_PARM_DESC(wapf, "WAPF value");
 
+static uint wireless_status = 1;
+static uint bluetooth_status = 1;
+
+module_param(wireless_status, uint, 0644);
+MODULE_PARM_DESC(wireless_status, "Set the wireless status on boot "
+		 "(0 = disabled, 1 = enabled, -1 = don't do anything). "
+		 "default is 1");
+
+module_param(bluetooth_status, uint, 0644);
+MODULE_PARM_DESC(bluetooth_status, "Set the wireless status on boot "
+		 "(0 = disabled, 1 = enabled, -1 = don't do anything). "
+		 "default is 1");
+
 #define ASUS_HANDLE(object, paths...)					\
 	static acpi_handle  object##_handle = NULL;			\
 	static char *object##_paths[] = { paths }
@@ -1272,8 +1285,10 @@ static int asus_hotk_add(struct acpi_device *device)
 	asus_hotk_found = 1;
 
 	/* WLED and BLED are on by default */
-	write_status(bt_switch_handle, 1, BT_ON);
-	write_status(wl_switch_handle, 1, WL_ON);
+	if (bluetooth_status != -1)
+		write_status(bt_switch_handle, !!bluetooth_status, BT_ON);
+	if (wireless_status != -1)
+		write_status(wl_switch_handle, !!wireless_status, WL_ON);
 
 	/* If the h/w switch is off, we need to check the real status */
 	write_status(NULL, read_status(BT_ON), BT_ON);
-- 
1.6.6.1


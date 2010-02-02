Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758Ab0BBHrJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 02:47:09 -0500
Received: from iksaif.net ([88.191.73.63]:48707 "EHLO iksaif.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755382Ab0BBHrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 02:47:07 -0500
X-Greylist: delayed 470 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Feb 2010 02:47:07 EST
From: Corentin Chary <corentincj@iksaif.net>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Corentin Chary <corentincj@iksaif.net>
Subject: [PATCH 03/28] asus-laptop: no need to check argument of set_brightness()
Date: Tue,  2 Feb 2010 08:38:46 +0100
Message-Id: <1265096351-15239-4-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1265096351-15239-3-git-send-email-corentincj@iksaif.net>
References: <1265096351-15239-1-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-2-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-3-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already tell the backlight class our maximum brightness value; it
will validate the user requested values for us.

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/asus-laptop.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index 1d799b3..013ab86 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -571,17 +571,11 @@ static int read_brightness(struct backlight_device *bd)
 
 static int set_brightness(struct backlight_device *bd, int value)
 {
-	int ret = 0;
-
-	value = (0 < value) ? ((15 < value) ? 15 : value) : 0;
-	/* 0 <= value <= 15 */
-
 	if (write_acpi_int(brightness_set_handle, NULL, value, NULL)) {
 		pr_warning("Error changing brightness\n");
-		ret = -EIO;
+		return -EIO;
 	}
-
-	return ret;
+	return 0;
 }
 
 static int update_bl_status(struct backlight_device *bd)
-- 
1.6.6.1


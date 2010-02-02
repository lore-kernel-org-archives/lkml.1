Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab0BBHwS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 02:52:18 -0500
Received: from iksaif.net ([88.191.73.63]:50254 "EHLO iksaif.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755769Ab0BBHwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 02:52:08 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Corentin Chary <corentincj@iksaif.net>
Subject: [PATCH 06/28] asus-laptop: remove unecessary hotk != NULL check
Date: Tue,  2 Feb 2010 08:38:49 +0100
Message-Id: <1265096351-15239-7-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1265096351-15239-6-git-send-email-corentincj@iksaif.net>
References: <1265096351-15239-1-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-2-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-3-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-4-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-5-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-6-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/asus-laptop.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index 5889bda..74463a0 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -941,10 +941,6 @@ static void asus_hotk_notify(struct acpi_device *device, u32 event)
 	static struct key_entry *key;
 	u16 count;
 
-	/* TODO Find a better way to handle events count. */
-	if (!hotk)
-		return;
-
 	/*
 	 * We need to tell the backlight device when the backlight power is
 	 * switched
@@ -957,6 +953,7 @@ static void asus_hotk_notify(struct acpi_device *device, u32 event)
 		lcd_blank(FB_BLANK_POWERDOWN);
 	}
 
+	/* TODO Find a better way to handle events count. */
 	count = hotk->event_count[event % 128]++;
 	acpi_bus_generate_proc_event(hotk->device, event, count);
 	acpi_bus_generate_netlink_event(hotk->device->pnp.device_class,
-- 
1.6.6.1


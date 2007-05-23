Return-Path: <linux-kernel-owner+w=401wt.eu-S932943AbXEWTir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932943AbXEWTir (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 15:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756516AbXEWTil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 15:38:41 -0400
Received: from mail.tpi.com ([198.107.51.143]:3707 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755898AbXEWTik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 15:38:40 -0400
X-Greylist: delayed 1539 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 May 2007 15:38:40 EDT
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       tim.gardner@ubuntu.com
Subject: [PATCH 1/1] Work around Dell E520 BIOS reboot bug.
Message-Id: <20070523191244.50078196AA1@rtg.theglobal.net>
Date: Wed, 23 May 2007 13:12:44 -0600 (MDT)
From: rtg@tpi.com (Tim Gardner)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Gardner <tim.gardner@ubuntu.com>
Subject: [PATCH] Work around Dell E520 BIOS reboot bug.

Force Dell E520 to use the BIOS to shutdown/reboot.

Signed-off-by: Tim Gardner <tim.gardner@ubuntu.com>
---

I have at least one report that this patch fixes shutdown/reboot
problems on the Dell E520 platform.

 arch/i386/kernel/reboot.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/i386/kernel/reboot.c b/arch/i386/kernel/reboot.c
index 3514b41..e33f51a 100644
--- a/arch/i386/kernel/reboot.c
+++ b/arch/i386/kernel/reboot.c
@@ -88,6 +88,14 @@ static int __init set_bios_reboot(struct dmi_system_id *d)
 }
 
 static struct dmi_system_id __initdata reboot_dmi_table[] = {
+	{	/* Handle problems with rebooting on Dell E520's */
+		.callback = set_bios_reboot,
+		.ident = "Dell E520",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Dell DM061"),
+		},
+	},
 	{	/* Handle problems with rebooting on Dell 1300's */
 		.callback = set_bios_reboot,
 		.ident = "Dell PowerEdge 1300",
-- 
1.4.4.2


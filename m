Return-Path: <linux-kernel-owner+w=401wt.eu-S933040AbZHDQgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933040AbZHDQgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 12:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932990AbZHDQga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 12:36:30 -0400
Received: from lider.pardus.org.tr ([193.140.100.216]:39762 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932987AbZHDQg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 12:36:29 -0400
From: =?utf-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>
To: linux-kernel@vger.kernel.org
Cc: hpa@zytor.com, mingo@elte.hu
Subject: [PATCH] x86: Add quirk to make Apple MacBookPro5,1 use reboot=pci
Date: Tue,  4 Aug 2009 19:39:31 +0300
Message-Id: <1249403971-6543-1-git-send-email-ozan@pardus.org.tr>
X-Mailer: git-send-email 1.6.3.4
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MacBookPro5,1 is not able to reboot unless reboot=pci is set.
This patch forces it through a DMI quirk specific to this device.

Tested-by: Ozan Çağlayan <ozan@pardus.org.tr>
Signed-off-by: Ozan Çağlayan <ozan@pardus.org.tr>
---

Seen that the previous quirk by Paul Mackerras was committed to tip/x86/urgent,
this is based on top of that patch which introduced the reboot=p quirk stuff.

 arch/x86/kernel/reboot.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 834c9da..9eb8976 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -405,7 +405,7 @@ EXPORT_SYMBOL(machine_real_restart);
 #endif /* CONFIG_X86_32 */
 
 /*
- * Apple MacBook5,2 (2009 MacBook) needs reboot=p
+ * Some Apple MacBook and MacBookPro's needs reboot=p to be able to reboot
  */
 static int __init set_pci_reboot(const struct dmi_system_id *d)
 {
@@ -426,6 +426,14 @@ static struct dmi_system_id __initdata pci_reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "MacBook5,2"),
 		},
 	},
+	{	/* Handle problems with rebooting on Apple MacBookPro5,1 */
+		.callback = set_pci_reboot,
+		.ident = "Apple MacBookPro5,1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro5,1"),
+		},
+	},
 	{ }
 };
 
-- 
1.6.3.4


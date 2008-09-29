Return-Path: <linux-kernel-owner+w=401wt.eu-S1753492AbYI2SaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbYI2SaI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:30:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbYI2S34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:29:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53683 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876AbYI2S34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:29:56 -0400
From: Adam Jackson <ajax@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Adam Jackson <ajax@redhat.com>
Subject: [PATCH] ACPI: Reduce blacklist-by-date failures to KERN_INFO
Date: Mon, 29 Sep 2008 14:29:54 -0400
Message-Id: <1222712994-1017-1-git-send-email-ajax@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No reason to punish quiet boot for these.

Signed-off-by: Adam Jackson <ajax@redhat.com>
---
 drivers/acpi/blacklist.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/blacklist.c b/drivers/acpi/blacklist.c
index ea92bac..00498fe 100644
--- a/drivers/acpi/blacklist.c
+++ b/drivers/acpi/blacklist.c
@@ -81,18 +81,18 @@ static int __init blacklist_by_year(void)
 	int year = dmi_get_year(DMI_BIOS_DATE);
 	/* Doesn't exist? Likely an old system */
 	if (year == -1) {
-		printk(KERN_ERR PREFIX "no DMI BIOS year, "
+		printk(KERN_INFO PREFIX "no DMI BIOS year, "
 			"acpi=force is required to enable ACPI\n" );
 		return 1;
 	}
 	/* 0? Likely a buggy new BIOS */
 	if (year == 0) {
-		printk(KERN_ERR PREFIX "DMI BIOS year==0, "
+		printk(KERN_INFO PREFIX "DMI BIOS year==0, "
 			"assuming ACPI-capable machine\n" );
 		return 0;
 	}
 	if (year < CONFIG_ACPI_BLACKLIST_YEAR) {
-		printk(KERN_ERR PREFIX "BIOS age (%d) fails cutoff (%d), "
+		printk(KERN_INFO PREFIX "BIOS age (%d) fails cutoff (%d), "
 		       "acpi=force is required to enable ACPI\n",
 		       year, CONFIG_ACPI_BLACKLIST_YEAR);
 		return 1;
-- 
1.6.0.1


Return-Path: <linux-kernel-owner+w=401wt.eu-S1758524AbYLKWOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758524AbYLKWOX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 17:14:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756940AbYLKWNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 17:13:49 -0500
Received: from mx1.redhat.com ([66.187.233.31]:32830 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756804AbYLKWNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 17:13:48 -0500
From: Adam Jackson <ajax@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Adam Jackson <ajax@redhat.com>
Subject: [PATCH] ACPI: Silence blacklist warnings.
Date: Thu, 11 Dec 2008 17:13:43 -0500
Message-Id: <1229033625-30825-2-git-send-email-ajax@redhat.com>
In-Reply-To: <1229033625-30825-1-git-send-email-ajax@redhat.com>
References: <1229033625-30825-1-git-send-email-ajax@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you have a machine that matches these warnings, there's almost
certainly nothing you can do about it, so don't punish quiet boot.

Signed-off-by: Adam Jackson <ajax@redhat.com>
---
 drivers/acpi/blacklist.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/blacklist.c b/drivers/acpi/blacklist.c
index 09c6980..786376e 100644
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
1.6.0.3


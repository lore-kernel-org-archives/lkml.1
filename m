Return-Path: <linux-kernel-owner+w=401wt.eu-S1763261AbYBAEps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763261AbYBAEps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 23:45:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760283AbYBAEmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 23:42:08 -0500
Received: from mga05.intel.com ([192.55.52.89]:61249 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757043AbYBAEl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 23:41:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,288,1199692800"; 
   d="scan'208";a="511516554"
From: Len Brown <lenb@kernel.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>
Subject: [PATCH 06/37] ACPI: Fix mismerge in acpi_hibernation_finish
Date: Thu, 31 Jan 2008 23:36:37 -0500
Message-Id: <0122b99e0414205d1f3c1f4bf80f2082f6f1c8b0.1201840183.git.len.brown@intel.com>
X-Mailer: git-send-email 1.5.4.rc5.16.gc0279
In-Reply-To: <1201840628-23136-1-git-send-email-lenb@kernel.org>
References: <1201840628-23136-1-git-send-email-lenb@kernel.org>
In-Reply-To: <edae89f5d1eb1fbe1cab74333db5a8e29776900e.1201840183.git.len.brown@intel.com>
References: <edae89f5d1eb1fbe1cab74333db5a8e29776900e.1201840183.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Some code in acpi_hibernation_finish() was moved to acpi_hibernation_leave(),
but the old copy had been left (it's harmless, but also useless).  Remove it.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/sleep/main.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/sleep/main.c b/drivers/acpi/sleep/main.c
index 2c0b663..cbfa058 100644
--- a/drivers/acpi/sleep/main.c
+++ b/drivers/acpi/sleep/main.c
@@ -267,11 +267,6 @@ static void acpi_hibernation_leave(void)
 
 static void acpi_hibernation_finish(void)
 {
-	/*
-	 * If ACPI is not enabled by the BIOS and the boot kernel, we need to
-	 * enable it here.
-	 */
-	acpi_enable();
 	acpi_disable_wakeup_device(ACPI_STATE_S4);
 	acpi_leave_sleep_state(ACPI_STATE_S4);
 
-- 
1.5.4.rc5.16.gc0279


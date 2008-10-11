Return-Path: <linux-kernel-owner+w=401wt.eu-S1754210AbYJKGkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbYJKGkO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 02:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775AbYJKGhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 02:37:03 -0400
Received: from vms172069pub.verizon.net ([206.46.172.69]:65510 "EHLO
	vms172069pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbYJKGg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 02:36:56 -0400
Date: Sat, 11 Oct 2008 02:35:43 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 23/85] ACPI: Clear WAK_STS on resume
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Matthew Garrett <mjg@redhat.com>,
       Andi Kleen <ak@linux.intel.com>, Len Brown <len.brown@intel.com>
Message-id: <32bd813b0324309ab744d70a93bc5d8b82af36ce.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Garrett <mjg59@srcf.ucam.org>

The leading other brand OS appears to clear the WAK_STS flag on resume.
When rebooted, certain BIOSes assume that the system is actually
resuming if it's still set and so fail to reboot correctly. Make sure
that it's cleared at resume time.

Comment clarified as suggested by Bob Moore

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/hardware/hwsleep.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/hardware/hwsleep.c b/drivers/acpi/hardware/hwsleep.c
index dba3cfb..130a44b 100644
--- a/drivers/acpi/hardware/hwsleep.c
+++ b/drivers/acpi/hardware/hwsleep.c
@@ -627,6 +627,13 @@ acpi_status acpi_leave_sleep_state(u8 sleep_state)
 	}
 	/* TBD: _WAK "sometimes" returns stuff - do we want to look at it? */
 
+	/*
+	 * Some BIOSes assume that WAK_STS will be cleared on resume and use
+	 * it to determine whether the system is rebooting or resuming. Clear
+	 * it for compatibility.
+	 */
+	acpi_set_register(ACPI_BITREG_WAKE_STATUS, 1);
+
 	acpi_gbl_system_awake_and_running = TRUE;
 
 	/* Enable power button */
-- 
1.5.5.1


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755215AbXJ3KyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbXJ3KyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 06:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbXJ3KyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 06:54:14 -0400
Received: from gepetto.dc.ltu.se ([130.240.42.40]:46743 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbXJ3KyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 06:54:13 -0400
Date: Tue, 30 Oct 2007 11:54:07 +0100 (MET)
From: Richard Knutsson <ricknu-0@student.ltu.se>
To: len.brown@intel.com
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Richard Knutsson <ricknu-0@student.ltu.se>
Message-Id: <20071030104750.30935.5409.sendpatchset@thinktank.campus.ltu.se>
Subject: [PATCH] acpi: 'acpi_gbl_system_awake_and_running' is no longer used, only assigned.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

'acpi_gbl_system_awake_and_running' is no longer used, only assigned.

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Diffed against linus-git
Checked with script/checkpatch.pl

 drivers/acpi/hardware/hwsleep.c   |    5 -----
 drivers/acpi/utilities/utglobal.c |    1 -
 include/acpi/acglobal.h           |    1 -
 3 files changed, 7 deletions(-)


diff --git a/drivers/acpi/hardware/hwsleep.c b/drivers/acpi/hardware/hwsleep.c
index 81b2484..e020e50 100644
--- a/drivers/acpi/hardware/hwsleep.c
+++ b/drivers/acpi/hardware/hwsleep.c
@@ -300,8 +300,6 @@ acpi_status asmlinkage acpi_enter_sleep_state(u8 sleep_state)
 		return_ACPI_STATUS(status);
 	}
 
-	acpi_gbl_system_awake_and_running = FALSE;
-
 	status = acpi_hw_enable_all_wakeup_gpes();
 	if (ACPI_FAILURE(status)) {
 		return_ACPI_STATUS(status);
@@ -446,7 +444,6 @@ acpi_status asmlinkage acpi_enter_sleep_state_s4bios(void)
 	if (ACPI_FAILURE(status)) {
 		return_ACPI_STATUS(status);
 	}
-	acpi_gbl_system_awake_and_running = FALSE;
 
 	status = acpi_hw_enable_all_wakeup_gpes();
 	if (ACPI_FAILURE(status)) {
@@ -587,8 +584,6 @@ acpi_status acpi_leave_sleep_state(u8 sleep_state)
 	}
 	/* TBD: _WAK "sometimes" returns stuff - do we want to look at it? */
 
-	acpi_gbl_system_awake_and_running = TRUE;
-
 	/* Enable power button */
 
 	(void)
diff --git a/drivers/acpi/utilities/utglobal.c b/drivers/acpi/utilities/utglobal.c
index 93ea829..f2ba315 100644
--- a/drivers/acpi/utilities/utglobal.c
+++ b/drivers/acpi/utilities/utglobal.c
@@ -709,7 +709,6 @@ void acpi_ut_init_globals(void)
 	/* Hardware oriented */
 
 	acpi_gbl_events_initialized = FALSE;
-	acpi_gbl_system_awake_and_running = TRUE;
 
 	/* Namespace */
 
diff --git a/include/acpi/acglobal.h b/include/acpi/acglobal.h
index 347a911..ae0fc0a 100644
--- a/include/acpi/acglobal.h
+++ b/include/acpi/acglobal.h
@@ -236,7 +236,6 @@ ACPI_EXTERN u8 acpi_gbl_step_to_next_call;
 ACPI_EXTERN u8 acpi_gbl_acpi_hardware_present;
 ACPI_EXTERN u8 acpi_gbl_global_lock_present;
 ACPI_EXTERN u8 acpi_gbl_events_initialized;
-ACPI_EXTERN u8 acpi_gbl_system_awake_and_running;
 
 extern u8 acpi_gbl_shutdown;
 extern u32 acpi_gbl_startup_flags;

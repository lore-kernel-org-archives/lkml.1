Return-Path: <linux-kernel-owner+w=401wt.eu-S1761406AbYJKG4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761406AbYJKG4H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 02:56:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757546AbYJKGkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 02:40:04 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:52476 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbYJKGhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 02:37:03 -0400
Date: Sat, 11 Oct 2008 02:36:06 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 46/85] ACPI: don't enable control method power button as wakeup
 device when Fixed Power button is used
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Zhang Rui <rui.zhang@intel.com>, Len Brown <len.brown@intel.com>
Message-id: <faee816b1502385dc9bc5abf2960d1cc645844d1.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Rui <rui.zhang@intel.com>

don't enable control method power button as wakeup device
when Fixed Power button is used.

http://bugzilla.kernel.org/show_bug.cgi?id=10503

Tested-by: walken@zoy.org <walken@zoy.org>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/scan.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index f6f52c1..5ce14ae 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -744,6 +744,16 @@ static int acpi_bus_get_wakeup_device_flags(struct acpi_device *device)
 	if (!acpi_match_device_ids(device, button_device_ids))
 		device->wakeup.flags.run_wake = 1;
 
+	/*
+	 * Don't set Power button GPE as run_wake
+	 * if Fixed Power button is used
+	 */
+	if (!strcmp(device->pnp.hardware_id, "PNP0C0C") &&
+		!(acpi_gbl_FADT.flags & ACPI_FADT_POWER_BUTTON)) {
+		device->wakeup.flags.run_wake = 0;
+		device->wakeup.flags.valid = 0;
+	}
+
       end:
 	if (ACPI_FAILURE(status))
 		device->flags.wake_capable = 0;
-- 
1.5.5.1


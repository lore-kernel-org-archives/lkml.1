Return-Path: <linux-kernel-owner+w=401wt.eu-S1762608AbYBRVEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762608AbYBRVEx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 16:04:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762153AbYBRVDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 16:03:49 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43145 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761977AbYBRVDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 16:03:46 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, andrew.grover@intel.com,
       paul.s.diefenbaugh@intel.com, linux@brodo.de,
       anil.s.keshavamurthy@intel.com, lenb@kernel.org,
       linux-acpi@vger.kernel.org
Subject: [PATCH 4/4] remove goto statement
Date: Mon, 18 Feb 2008 17:56:53 -0300
Message-Id: <1203368213-30528-4-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1203368213-30528-3-git-send-email-gcosta@redhat.com>
References: <1203368213-30528-1-git-send-email-gcosta@redhat.com>
 <1203368213-30528-2-git-send-email-gcosta@redhat.com>
 <1203368213-30528-3-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes goto statements in favour of plain returns
in places that had nothing left behind that would justify
such construction
---
 drivers/acpi/processor_core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index 06a230a..70f62b6 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -651,7 +651,7 @@ static int __cpuinit acpi_processor_star
 
 	result = acpi_processor_add_fs(device);
 	if (result)
-		goto end;
+		return result;
 
 	status = acpi_install_notify_handler(pr->handle, ACPI_DEVICE_NOTIFY,
 					     acpi_processor_notify, pr);
@@ -675,7 +675,7 @@ #endif
 			"%s is registered as cooling_device%d\n",
 			device->dev.bus_id, cdev->id);
 	else
-		goto end;
+		return result;
 
 	result = sysfs_create_link(&device->dev.kobj, &cdev->device.kobj,
 					"thermal_cooling");
-- 
1.4.2


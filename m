Return-Path: <linux-kernel-owner+w=401wt.eu-S1759520AbYJKGso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759520AbYJKGso (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 02:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751332AbYJKGii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 02:38:38 -0400
Received: from vms172071pub.verizon.net ([206.46.172.71]:52181 "EHLO
	vms172071pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892AbYJKGh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 02:37:27 -0400
Date: Sat, 11 Oct 2008 02:36:36 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 76/85] ACPI video: Debug interface used for error message
 cleanup
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Thomas Renninger <trenn@suse.de>, Andi Kleen <ak@linux.intel.com>,
       Len Brown <len.brown@intel.com>
Message-id: <44ce0da3e71b57c11233611c598d94b91e2994d0.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Renninger <trenn@suse.de>

Signed-off-by: Thomas Renninger <trenn@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/video.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index e8a51a1..d758944 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -1530,8 +1530,8 @@ acpi_video_bus_get_one_device(struct acpi_device *device,
 						     acpi_video_device_notify,
 						     data);
 		if (ACPI_FAILURE(status)) {
-			ACPI_DEBUG_PRINT((ACPI_DB_ERROR,
-					  "Error installing notify handler\n"));
+			ACPI_EXCEPTION((AE_INFO, status,
+					"Error installing notify handler"));
 			if(data->brightness)
 				kfree(data->brightness->levels);
 			kfree(data->brightness);
@@ -1745,8 +1745,7 @@ acpi_video_bus_get_devices(struct acpi_video_bus *video,
 
 		status = acpi_video_bus_get_one_device(dev, video);
 		if (ACPI_FAILURE(status)) {
-			ACPI_DEBUG_PRINT((ACPI_DB_WARN,
-					"Cant attach device"));
+			printk(KERN_ERR "Cant attach device [%d]\n", status);
 			continue;
 		}
 	}
@@ -2003,8 +2002,8 @@ static int acpi_video_bus_add(struct acpi_device *device)
 					     ACPI_DEVICE_NOTIFY,
 					     acpi_video_bus_notify, video);
 	if (ACPI_FAILURE(status)) {
-		ACPI_DEBUG_PRINT((ACPI_DB_ERROR,
-				  "Error installing notify handler\n"));
+		ACPI_EXCEPTION((AE_INFO, status,
+				"Error installing notify handler"));
 		error = -ENODEV;
 		goto err_stop_video;
 	}
-- 
1.5.5.1


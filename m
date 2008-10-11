Return-Path: <linux-kernel-owner+w=401wt.eu-S1757171AbYJKHg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171AbYJKHg7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 03:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751434AbYJKHgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 03:36:50 -0400
Received: from vms172073pub.verizon.net ([206.46.172.73]:65534 "EHLO
	vms172073pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbYJKHgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 03:36:49 -0400
X-Greylist: delayed 3600 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 Oct 2008 03:36:49 EDT
Date: Sat, 11 Oct 2008 02:35:22 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 02/85] acpi: replace AE_BAD_ADDRESS exception code with AE_ERROR
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Lin Ming <ming.m.lin@intel.com>, Andi Kleen <ak@linux.intel.com>
Message-id: <a7be432189eb771907fb52b3f28f3e9c9309683d.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lin Ming <ming.m.lin@intel.com>

The AE_BAD_ADDRESS exception code is now unused in ACPICA.
For linux, it's only used at wmi.c and acer-wmi.c.
I checked both wmi.c and acer-wmi.c, the AE_BAD_ADDRESS exception code
has no special meaning. The parent functions just call AE_SUCCESS() or
AE_FAILURE() to check the return status.
So it's safe to replace AE_BAD_ADDRESS with AE_ERROR.

Signed-off-by Lin Ming <ming.m.lin@intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/acpi/wmi.c      |   10 +++++-----
 drivers/misc/acer-wmi.c |   10 +++++-----
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/acpi/wmi.c b/drivers/acpi/wmi.c
index cfe2c83..5b94be3 100644
--- a/drivers/acpi/wmi.c
+++ b/drivers/acpi/wmi.c
@@ -242,7 +242,7 @@ u32 method_id, const struct acpi_buffer *in, struct acpi_buffer *out)
 	char method[4] = "WM";
 
 	if (!find_guid(guid_string, &wblock))
-		return AE_BAD_ADDRESS;
+		return AE_ERROR;
 
 	block = &wblock->gblock;
 	handle = wblock->handle;
@@ -304,7 +304,7 @@ struct acpi_buffer *out)
 		return AE_BAD_PARAMETER;
 
 	if (!find_guid(guid_string, &wblock))
-		return AE_BAD_ADDRESS;
+		return AE_ERROR;
 
 	block = &wblock->gblock;
 	handle = wblock->handle;
@@ -314,7 +314,7 @@ struct acpi_buffer *out)
 
 	/* Check GUID is a data block */
 	if (block->flags & (ACPI_WMI_EVENT | ACPI_WMI_METHOD))
-		return AE_BAD_ADDRESS;
+		return AE_ERROR;
 
 	input.count = 1;
 	input.pointer = wq_params;
@@ -385,7 +385,7 @@ const struct acpi_buffer *in)
 		return AE_BAD_DATA;
 
 	if (!find_guid(guid_string, &wblock))
-		return AE_BAD_ADDRESS;
+		return AE_ERROR;
 
 	block = &wblock->gblock;
 	handle = wblock->handle;
@@ -395,7 +395,7 @@ const struct acpi_buffer *in)
 
 	/* Check GUID is a data block */
 	if (block->flags & (ACPI_WMI_EVENT | ACPI_WMI_METHOD))
-		return AE_BAD_ADDRESS;
+		return AE_ERROR;
 
 	input.count = 2;
 	input.pointer = params;
diff --git a/drivers/misc/acer-wmi.c b/drivers/misc/acer-wmi.c
index d8b0d32..a67aef5 100644
--- a/drivers/misc/acer-wmi.c
+++ b/drivers/misc/acer-wmi.c
@@ -476,7 +476,7 @@ struct wmi_interface *iface)
 		}
 		break;
 	default:
-		return AE_BAD_ADDRESS;
+		return AE_ERROR;
 	}
 	return AE_OK;
 }
@@ -514,7 +514,7 @@ static acpi_status AMW0_set_u32(u32 value, u32 cap, struct wmi_interface *iface)
 			break;
 		}
 	default:
-		return AE_BAD_ADDRESS;
+		return AE_ERROR;
 	}
 
 	/* Actually do the set */
@@ -689,7 +689,7 @@ struct wmi_interface *iface)
 			return 0;
 		}
 	default:
-		return AE_BAD_ADDRESS;
+		return AE_ERROR;
 	}
 	status = WMI_execute_u32(method_id, 0, &result);
 
@@ -735,7 +735,7 @@ static acpi_status WMID_set_u32(u32 value, u32 cap, struct wmi_interface *iface)
 		}
 		break;
 	default:
-		return AE_BAD_ADDRESS;
+		return AE_ERROR;
 	}
 	return WMI_execute_u32(method_id, (u32)value, NULL);
 }
@@ -785,7 +785,7 @@ static struct wmi_interface wmid_interface = {
 
 static acpi_status get_u32(u32 *value, u32 cap)
 {
-	acpi_status status = AE_BAD_ADDRESS;
+	acpi_status status = AE_ERROR;
 
 	switch (interface->type) {
 	case ACER_AMW0:
-- 
1.5.5.1


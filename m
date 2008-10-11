Return-Path: <linux-kernel-owner+w=401wt.eu-S1762022AbYJKGsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762022AbYJKGsB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 02:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbYJKGie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 02:38:34 -0400
Received: from vms172069pub.verizon.net ([206.46.172.69]:32774 "EHLO
	vms172069pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772AbYJKGh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 02:37:27 -0400
Date: Sat, 11 Oct 2008 02:36:32 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 72/85] Subject: ACPI dock: Use ACPI_EXCEPTION instead of
 printk(KERN_ERR
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Thomas Renninger <trenn@suse.de>, Len Brown <len.brown@intel.com>
Message-id: <0a918a9432cc30aede10f904253b66ea6ab485ac.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Renninger <trenn@suse.de>

lenb: stripped patch down to what still applied to new dock.c

Signed-off-by: Thomas Renninger <trenn@suse.de>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/dock.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index b7d1581..913bb1e 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -488,8 +488,9 @@ static void handle_dock(struct dock_station *ds, int dock)
 	arg.integer.value = dock;
 	status = acpi_evaluate_object(ds->handle, "_DCK", &arg_list, &buffer);
 	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND)
-		printk(KERN_ERR PREFIX "%s - failed to execute _DCK\n",
-			 (char *)name_buffer.pointer);
+		ACPI_EXCEPTION((AE_INFO, status, "%s - failed to execute"
+			" _DCK\n", (char *)name_buffer.pointer));
+
 	kfree(buffer.pointer);
 	kfree(name_buffer.pointer);
 }
-- 
1.5.5.1


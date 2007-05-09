Return-Path: <linux-kernel-owner+w=401wt.eu-S1759952AbXEIWNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759952AbXEIWNb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 18:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757816AbXEIWNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 18:13:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:37190 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759884AbXEIWNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 18:13:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,512,1170662400"; 
   d="scan'208";a="241395014"
Date: Wed, 9 May 2007 15:10:22 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ACPI: dock: send envp with uevent
Message-Id: <20070509151022.c9753632.kristen.c.accardi@intel.com>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI: dock: send env with uevent

Send an env along with our KOBJ_CHANGE uevent so that user space has 
the option of checking for that to see if a dock or undock has occurred.

Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Index: 2.6-git/drivers/acpi/dock.c
===================================================================
--- 2.6-git.orig/drivers/acpi/dock.c
+++ 2.6-git/drivers/acpi/dock.c
@@ -336,11 +336,19 @@ static void hotplug_dock_devices(struct 
 static void dock_event(struct dock_station *ds, u32 event, int num)
 {
 	struct device *dev = &dock_device->dev;
+	char event_string[7];
+	char *envp[] = { event_string, NULL };
+
+	if (num == UNDOCK_EVENT)
+		sprintf(event_string, "UNDOCK");
+	else
+		sprintf(event_string, "DOCK");
+
 	/*
 	 * Indicate that the status of the dock station has
 	 * changed.
 	 */
-	kobject_uevent(&dev->kobj, KOBJ_CHANGE);
+	kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
 }
 
 /**

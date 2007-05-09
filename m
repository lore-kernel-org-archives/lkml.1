Return-Path: <linux-kernel-owner+w=401wt.eu-S1759734AbXEIWM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759734AbXEIWM3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 18:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755634AbXEIWMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 18:12:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:50837 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754059AbXEIWMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 18:12:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,512,1170662400"; 
   d="scan'208";a="243974019"
Date: Wed, 9 May 2007 15:09:12 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ACPI: dock: unsuppress uevents
Message-Id: <20070509150912.d87e6a2d.kristen.c.accardi@intel.com>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI: dock: unsuppress uevents

Platform devices may not send uevents by default - override the setting
so that we can send uevents on dock/undock.

Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Index: 2.6-git/drivers/acpi/dock.c
===================================================================
--- 2.6-git.orig/drivers/acpi/dock.c
+++ 2.6-git/drivers/acpi/dock.c
@@ -751,6 +751,9 @@ static int dock_add(acpi_handle handle)
 		return PTR_ERR(dock_device);
 	}
 
+	/* we want the dock device to send uevents */
+	dock_device->dev.uevent_suppress = 0;
+
 	ret = device_create_file(&dock_device->dev, &dev_attr_docked);
 	if (ret) {
 		printk("Error %d adding sysfs file\n", ret);

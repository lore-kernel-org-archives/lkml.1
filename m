Return-Path: <linux-kernel-owner+w=401wt.eu-S1760140AbXEIW7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760140AbXEIW7M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 18:59:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758811AbXEIW6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 18:58:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:32196 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757055AbXEIW6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 18:58:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,512,1170662400"; 
   d="scan'208";a="243988958"
Date: Wed, 9 May 2007 15:55:53 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ACPI: bay: unsuppress uevents
Message-Id: <20070509155553.17674722.kristen.c.accardi@intel.com>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI: bay: unsuppress uevents

Since platform devices seem to get uevents suppressed by default,
manually unsuppress for the bay device since we want to be able
to send uevents.

Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Index: 2.6-git/drivers/acpi/bay.c
===================================================================
--- 2.6-git.orig/drivers/acpi/bay.c
+++ 2.6-git/drivers/acpi/bay.c
@@ -287,6 +287,11 @@ static int bay_add(acpi_handle handle, i
 	}
 	new_bay->pdev = pdev;
 	platform_set_drvdata(pdev, new_bay);
+
+	/*
+	 * we want the bay driver to be able to send uevents
+	 */
+	pdev->dev.uevent_suppress = 0;
 
 	if (acpi_bay_add_fs(new_bay)) {
 		platform_device_unregister(new_bay->pdev);

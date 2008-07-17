Return-Path: <linux-kernel-owner+w=401wt.eu-S1759363AbYGQRNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759363AbYGQRNp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 13:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755668AbYGQRNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 13:13:37 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:18127 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288AbYGQRNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 13:13:36 -0400
Date: Thu, 17 Jul 2008 11:13:32 -0600
From: Alex Chiang <achiang@hp.com>
To: jbarnes@virtuousgeek.org
Cc: juha_motorsportcom@luukku.com, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] PCI: hotplug: fix error path in pci_slot's register_slot
Message-ID: <20080717171332.GD24683@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>, jbarnes@virtuousgeek.org,
	juha_motorsportcom@luukku.com, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Juha Leppänen noticed that an error path in register_slot()
wasn't returning appropriately, leading to a condition where we
might access a kfree'ed pointer, so let's fix that.

Additionally, fix up the copyright information in the file while
we're in there.

Signed-off-by: Alex Chiang <achiang@hp.com>

diff --git a/drivers/acpi/pci_slot.c b/drivers/acpi/pci_slot.c
index b9ab030..dd376f7 100644
--- a/drivers/acpi/pci_slot.c
+++ b/drivers/acpi/pci_slot.c
@@ -6,8 +6,8 @@
  *  Thanks to Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com> for code
  *  review and fixes.
  *
- *  Copyright (C) 2007 Alex Chiang <achiang@hp.com>
- *  Copyright (C) 2007 Hewlett-Packard Development Company, L.P.
+ *  Copyright (C) 2007-2008 Hewlett-Packard Development Company, L.P.
+ *  	Alex Chiang <achiang@hp.com>
  *
  *  This program is free software; you can redistribute it and/or modify it
  *  under the terms and conditions of the GNU General Public License,
@@ -158,6 +158,7 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
 	if (IS_ERR(pci_slot)) {
 		err("pci_create_slot returned %ld\n", PTR_ERR(pci_slot));
 		kfree(slot);
+		return AE_OK;
 	}
 
 	slot->root_handle = parent_context->root_handle;

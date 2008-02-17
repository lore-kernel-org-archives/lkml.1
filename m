Return-Path: <linux-kernel-owner+w=401wt.eu-S1756563AbYBQMKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563AbYBQMKX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 07:10:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754580AbYBQMKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 07:10:09 -0500
Received: from mail.southpole.se ([193.12.106.18]:45469 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488AbYBQMKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 07:10:08 -0500
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Cc: olof@lixom.net, sam@ravnborg.com, Jonas Bonn <jonas@southpole.se>
Subject: [PATCH] Add PCI_DEVICE_TABLE macro
Date: Sun, 17 Feb 2008 13:10:05 +0100
Message-Id: <1203250205-5103-1-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.5.3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The definitions of struct pci_device_id arrays should generally follow
the same pattern across the entire kernel.  This macro defines this
array as static const and puts it into the __devinitconst section.

Signed-off-by: Jonas Bonn <jonas@southpole.se>
---
 include/linux/pci.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index 87195b6..487d31c 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -389,6 +389,14 @@ struct pci_driver {
 #define	to_pci_driver(drv) container_of(drv, struct pci_driver, driver)
 
 /**
+ * PCI_DEVICE_TABLE - macro used to describe a pci device table
+ * 
+ * This macro is used to create a struct pci_device_id array in a generic
+ * manner.
+ */
+#define PCI_DEVICE_TABLE(_table) static const struct pci_device_id _table[] __devinitconst
+
+/**
  * PCI_DEVICE - macro used to describe a specific pci device
  * @vend: the 16 bit PCI Vendor ID
  * @dev: the 16 bit PCI Device ID
-- 
1.5.3.8



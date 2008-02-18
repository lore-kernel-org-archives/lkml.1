Return-Path: <linux-kernel-owner+w=401wt.eu-S1757076AbYBRIEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076AbYBRIEJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 03:04:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754181AbYBRID5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 03:03:57 -0500
Received: from mail.southpole.se ([193.12.106.18]:55744 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686AbYBRID4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 03:03:56 -0500
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Cc: olof@lixom.net, randy.dunlap@oracle.com, Jonas Bonn <jonas@southpole.se>
Subject: [PATCH] Add PCI_DEVICE_TABLE macro
Date: Mon, 18 Feb 2008 09:03:54 +0100
Message-Id: <1203321834-6156-1-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: 20080217101445.881c2f4b.randy.dunlap@oracle.com
References: 20080217101445.881c2f4b.randy.dunlap@oracle.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The definitions of struct pci_device_id arrays should generally follow
the same pattern across the entire kernel.  This macro defines this
array as const and puts it into the __devinitconst section.

Signed-off-by: Jonas Bonn <jonas@southpole.se>
---
 include/linux/pci.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index 87195b6..c7a91b1 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -389,6 +389,15 @@ struct pci_driver {
 #define	to_pci_driver(drv) container_of(drv, struct pci_driver, driver)
 
 /**
+ * PCI_DEVICE_TABLE - macro used to describe a pci device table
+ * @_table: device table name
+ *
+ * This macro is used to create a struct pci_device_id array (a device table) 
+ * in a generic manner.
+ */
+#define PCI_DEVICE_TABLE(_table) const struct pci_device_id _table[] __devinitconst
+
+/**
  * PCI_DEVICE - macro used to describe a specific pci device
  * @vend: the 16 bit PCI Vendor ID
  * @dev: the 16 bit PCI Device ID
-- 
1.5.3.8



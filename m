Return-Path: <linux-kernel-owner+w=401wt.eu-S1765426AbXHWRje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765426AbXHWRje (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 13:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754867AbXHWRj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 13:39:27 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:31629 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759222AbXHWRj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 13:39:26 -0400
Date: Thu, 23 Aug 2007 10:37:53 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>, linux-pci@atrey.karlin.mff.cuni.cz
Cc: linas@austin.ibm.com, gregkh <greg@kroah.com>,
       akpm <akpm@linux-foundation.org>
Subject: [PATCH] PCI AER: fix warnings when PCIEAER=n
Message-Id: <20070823103753.f048aa3a.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix warnings when CONFIG_PCIEAER=n:

drivers/pci/pcie/portdrv_pci.c:105: warning: statement with no effect
drivers/pci/pcie/portdrv_pci.c:226: warning: statement with no effect
drivers/scsi/arcmsr/arcmsr_hba.c:352: warning: statement with no effect

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/linux/aer.h |   25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

--- linux-2623-rc3-kex.orig/include/linux/aer.h
+++ linux-2623-rc3-kex/include/linux/aer.h
@@ -15,11 +15,26 @@ extern int pci_disable_pcie_error_report
 extern int pci_cleanup_aer_uncorrect_error_status(struct pci_dev *dev);
 extern int pci_cleanup_aer_correct_error_status(struct pci_dev *dev);
 #else
-#define pci_enable_pcie_error_reporting(dev)		(-EINVAL)
-#define pci_find_aer_capability(dev)			(0)
-#define pci_disable_pcie_error_reporting(dev)		(-EINVAL)
-#define pci_cleanup_aer_uncorrect_error_status(dev)	(-EINVAL)
-#define pci_cleanup_aer_correct_error_status(dev)	(-EINVAL)
+static inline int pci_enable_pcie_error_reporting(struct pci_dev *dev)
+{
+	return -EINVAL;
+}
+static inline int pci_find_aer_capability(struct pci_dev *dev)
+{
+	return 0;
+}
+static inline int pci_disable_pcie_error_reporting(struct pci_dev *dev)
+{
+	return -EINVAL;
+}
+static inline int pci_cleanup_aer_uncorrect_error_status(struct pci_dev *dev)
+{
+	return -EINVAL;
+}
+static inline int pci_cleanup_aer_correct_error_status(struct pci_dev *dev)
+{
+	return -EINVAL;
+}
 #endif
 
 #endif //_AER_H_

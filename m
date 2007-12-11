Return-Path: <linux-kernel-owner+w=401wt.eu-S1756114AbXLKWW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114AbXLKWW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 17:22:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756309AbXLKWVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 17:21:54 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:38495 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756137AbXLKWVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 17:21:36 -0500
Date: Tue, 11 Dec 2007 23:21:37 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Stephen Hemminger <shemminger@linux-foundation.org>,
       Zhang Yanmin <yanmin.zhang@intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: [2.6 patch] #if 0 pci_cleanup_aer_correct_error_status()
Message-ID: <20071211222137.GJ14204@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch #if 0's the no longer used 
pci_cleanup_aer_correct_error_status().

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/pci/pcie/aer/aerdrv_core.c |    3 ++-
 include/linux/aer.h                |    5 -----
 2 files changed, 2 insertions(+), 6 deletions(-)

5e074e99ac5290c61ed022c6084ddc0ac7d5b71a 
diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerdrv_core.c
index 3c0d8d1..e84dfc8 100644
--- a/drivers/pci/pcie/aer/aerdrv_core.c
+++ b/drivers/pci/pcie/aer/aerdrv_core.c
@@ -117,6 +117,7 @@ int pci_cleanup_aer_uncorrect_error_status(struct pci_dev *dev)
 	return 0;
 }
 
+#if 0
 int pci_cleanup_aer_correct_error_status(struct pci_dev *dev)
 {
 	int pos;
@@ -131,6 +132,7 @@ int pci_cleanup_aer_correct_error_status(struct pci_dev *dev)
 
 	return 0;
 }
+#endif  /*  0  */
 
 static int find_device_iter(struct device *device, void *data)
 {
@@ -757,5 +759,4 @@ EXPORT_SYMBOL_GPL(pci_find_aer_capability);
 EXPORT_SYMBOL_GPL(pci_enable_pcie_error_reporting);
 EXPORT_SYMBOL_GPL(pci_disable_pcie_error_reporting);
 EXPORT_SYMBOL_GPL(pci_cleanup_aer_uncorrect_error_status);
-EXPORT_SYMBOL_GPL(pci_cleanup_aer_correct_error_status);
 
diff --git a/include/linux/aer.h b/include/linux/aer.h
index bcf236d..f251814 100644
--- a/include/linux/aer.h
+++ b/include/linux/aer.h
@@ -13,7 +13,6 @@ extern int pci_enable_pcie_error_reporting(struct pci_dev *dev);
 extern int pci_find_aer_capability(struct pci_dev *dev);
 extern int pci_disable_pcie_error_reporting(struct pci_dev *dev);
 extern int pci_cleanup_aer_uncorrect_error_status(struct pci_dev *dev);
-extern int pci_cleanup_aer_correct_error_status(struct pci_dev *dev);
 #else
 static inline int pci_enable_pcie_error_reporting(struct pci_dev *dev)
 {
@@ -31,10 +30,6 @@ static inline int pci_cleanup_aer_uncorrect_error_status(struct pci_dev *dev)
 {
 	return -EINVAL;
 }
-static inline int pci_cleanup_aer_correct_error_status(struct pci_dev *dev)
-{
-	return -EINVAL;
-}
 #endif
 
 #endif //_AER_H_


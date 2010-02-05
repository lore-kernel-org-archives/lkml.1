Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933772Ab0BEStX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 13:49:23 -0500
Received: from mga02.intel.com ([134.134.136.20]:24941 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933756Ab0BEStU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 13:49:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,414,1262592000"; 
   d="scan'208";a="593522972"
From: Mark Allyn <mark.a.allyn@intel.com>
To: linux-kernel@vger.kernel.org, alan@linux.intel.com,
       charles.f.johnson@intel.com, greg@kroah.com
Cc: Mark Allyn <mark.a.allyn@intel.com>
Subject: [PATCH 6/6] staging:rar_register: add suspend and resume functions
Date: Fri,  5 Feb 2010 10:53:34 -0800
Message-Id: <1265396014-16107-1-git-send-email-mark.a.allyn@intel.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add suspend and resume functions (which are currently stubs
returning -ENOSYS)

Signed-off-by: Mark Allyn <mark.a.allyn@intel.com>
---
 drivers/staging/rar_register/rar_register.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rar_register/rar_register.c b/drivers/staging/rar_register/rar_register.c
index c9dcc99..bfc0e31 100644
--- a/drivers/staging/rar_register/rar_register.c
+++ b/drivers/staging/rar_register/rar_register.c
@@ -506,6 +506,17 @@ int register_rar(int (*callback)(void *yourparameter), void *yourparameter)
 }
 EXPORT_SYMBOL(register_rar);
 
+/* Suspend - returns -ENOSYS */
+static int rar_suspend(struct pci_dev *dev, pm_message_t state)
+{
+	return -ENOSYS;
+}
+
+static int rar_resume(struct pci_dev *dev)
+{
+	return -ENOSYS;
+}
+
 /*
  * This function registers the driver with the device subsystem (
  * either PCI, USB, etc).
@@ -582,7 +593,9 @@ const struct pci_device_id *my_id_table = rar_pci_id_tbl;
 static struct pci_driver rar_pci_driver = {
 	.name = "rar_register_driver",
 	.id_table = rar_pci_id_tbl,
-	.probe = rar_probe
+	.probe = rar_probe,
+	.suspend = rar_suspend,
+	.resume = rar_resume
 };
 
 static int __init rar_init_handler(void)
-- 
1.6.0.6


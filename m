Return-Path: <linux-kernel-owner+w=401wt.eu-S1756757AbYC2DIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757AbYC2DIM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 23:08:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759238AbYC2DHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 23:07:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49737 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759231AbYC2DHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 23:07:49 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] NULL noise: drivers/misc
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1JfRQ4-0002Za-IC@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 29 Mar 2008 03:07:48 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/misc/fujitsu-laptop.c |    2 +-
 drivers/misc/ibmasm/module.c  |    2 +-
 drivers/misc/lkdtm.c          |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/fujitsu-laptop.c b/drivers/misc/fujitsu-laptop.c
index 1cfd7f3..e2e7c05 100644
--- a/drivers/misc/fujitsu-laptop.c
+++ b/drivers/misc/fujitsu-laptop.c
@@ -231,7 +231,7 @@ static int acpi_fujitsu_remove(struct acpi_device *device, int type)
 
 	if (!device || !acpi_driver_data(device))
 		return -EINVAL;
-	fujitsu->acpi_handle = 0;
+	fujitsu->acpi_handle = NULL;
 
 	return 0;
 }
diff --git a/drivers/misc/ibmasm/module.c b/drivers/misc/ibmasm/module.c
index 4f9d4a9..b5f6add 100644
--- a/drivers/misc/ibmasm/module.c
+++ b/drivers/misc/ibmasm/module.c
@@ -106,7 +106,7 @@ static int __devinit ibmasm_init_one(struct pci_dev *pdev, const struct pci_devi
 	sp->irq = pdev->irq;
 	sp->base_address = ioremap(pci_resource_start(pdev, 0),
 					pci_resource_len(pdev, 0));
-	if (sp->base_address == 0) {
+	if (!sp->base_address) {
 		dev_err(sp->dev, "Failed to ioremap pci memory\n");
 		result =  -ENODEV;
 		goto error_ioremap;
diff --git a/drivers/misc/lkdtm.c b/drivers/misc/lkdtm.c
index c884730..1bfe5d1 100644
--- a/drivers/misc/lkdtm.c
+++ b/drivers/misc/lkdtm.c
@@ -197,7 +197,7 @@ static int lkdtm_parse_commandline(void)
 {
 	int i;
 
-	if (cpoint_name == INVALID || cpoint_type == NONE ||
+	if (cpoint_name == NULL || cpoint_type == NULL ||
 					cpoint_count < 1 || recur_count < 1)
 		return -EINVAL;
 
-- 
1.5.3.GIT



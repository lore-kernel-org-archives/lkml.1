Return-Path: <linux-kernel-owner+w=401wt.eu-S933925AbXCOWPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933925AbXCOWPy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 18:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933911AbXCOWPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 18:15:40 -0400
Received: from mx.pathscale.com ([198.186.3.68]:33698 "EHLO mx.pathscale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753415AbXCOWP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 18:15:26 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 22 of 33] IB/ipath - print better error messages if kernel is
	misconfigured
X-Mercurial-Node: fe719d50378ce70909f96bd5e7bc8e4f28a5031b
Message-Id: <fe719d50378ce70909f9.1173995106@iqa-25.internal.keyresearch.com>
In-Reply-To: <patchbomb.1173995084@iqa-25.internal.keyresearch.com>
Date: Thu, 15 Mar 2007 14:45:06 -0700
From: "Bryan O'Sullivan" <bos@pathscale.com>
To: rdreier@cisco.com
Cc: openib-general@openfabrics.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Bryan O'Sullivan <bryan.osullivan@qlogic.com>
# Date 1173994465 25200
# Node ID fe719d50378ce70909f96bd5e7bc8e4f28a5031b
# Parent  68302e9dbd8803f937af9f02ca26a63ff43e9afa
IB/ipath - print better error messages if kernel is misconfigured

Signed-off-by: Bryan O'Sullivan <bryan.osullivan@qlogic.com>

diff -r 68302e9dbd88 -r fe719d50378c drivers/infiniband/hw/ipath/ipath_driver.c
--- a/drivers/infiniband/hw/ipath/ipath_driver.c	Thu Mar 15 14:34:25 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_driver.c	Thu Mar 15 14:34:25 2007 -0700
@@ -390,15 +390,23 @@ static int __devinit ipath_init_one(stru
 
 	/* setup the chip-specific functions, as early as possible. */
 	switch (ent->device) {
+	case PCI_DEVICE_ID_INFINIPATH_HT:
 #ifdef CONFIG_HT_IRQ
-	case PCI_DEVICE_ID_INFINIPATH_HT:
 		ipath_init_iba6110_funcs(dd);
 		break;
+#else
+		ipath_dev_err(dd, "QLogic HT device 0x%x cannot work if "
+			      "CONFIG_HT_IRQ is not enabled\n", ent->device);
+		return -ENODEV;
 #endif
+	case PCI_DEVICE_ID_INFINIPATH_PE800:
 #ifdef CONFIG_PCI_MSI
-	case PCI_DEVICE_ID_INFINIPATH_PE800:
 		ipath_init_iba6120_funcs(dd);
 		break;
+#else
+		ipath_dev_err(dd, "QLogic PCIE device 0x%x cannot work if "
+			      "CONFIG_PCI_MSI is not enabled\n", ent->device);
+		return -ENODEV;
 #endif
 	default:
 		ipath_dev_err(dd, "Found unknown QLogic deviceid 0x%x, "

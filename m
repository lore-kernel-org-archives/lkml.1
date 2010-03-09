Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017Ab0CIUva (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 15:51:30 -0500
Received: from mail-ew0-f216.google.com ([209.85.219.216]:56942 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153Ab0CIUv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 15:51:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Xy485CorDkxFGETVRao/T91cLvC7/M4XGHCN8Irckm/KvS1G3ApCaHthrJHJaRnXoj
         pfGwgCCqpbRTJt7ltRUh+7sAT8Qzcbao5iPQ8dsOQ+n2yHohaY9Pam78Qod6DCrSSYZs
         YZ22c/p3RbfF3lH7XcqQA+yxpnonrHS4yzicg=
From: Henrik Hautakoski <henrik.hautakoski@gmail.com>
To: gregkh@suse.de, bzolnier@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Henrik Hautakoski <henrik.hautakoski@gmail.com>
Subject: [PATCH] staging: rt2860: fixed coding-style issues in pci_main_dev.c
Date: Tue,  9 Mar 2010 21:51:24 +0100
Message-Id: <1268167884-1424-1-git-send-email-henrik.hautakoski@gmail.com>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <n>
References: <n>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed a bunch of coding-style issues generated from checkpatch.pl

Signed-off-by: Henrik Hautakoski <henrik.hautakoski@gmail.com>
---
 drivers/staging/rt2860/pci_main_dev.c |   37 +++++++++++++++++---------------
 1 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/rt2860/pci_main_dev.c b/drivers/staging/rt2860/pci_main_dev.c
index 6af4304..13369a9 100644
--- a/drivers/staging/rt2860/pci_main_dev.c
+++ b/drivers/staging/rt2860/pci_main_dev.c
@@ -106,13 +106,13 @@ MODULE_VERSION(STA_DRIVER_VERSION);
 /* Our PCI driver structure */
 /* */
 static struct pci_driver rt2860_driver = {
-name:	"rt2860",
-id_table:rt2860_pci_tbl,
-probe:	rt2860_probe,
-remove:__devexit_p(rt2860_remove_one),
+name: "rt2860",
+id_table : rt2860_pci_tbl,
+probe : rt2860_probe,
+remove : __devexit_p(rt2860_remove_one),
 #ifdef CONFIG_PM
-suspend:rt2860_suspend,
-resume:rt2860_resume,
+suspend : rt2860_suspend,
+resume : rt2860_resume,
 #endif
 };
 
@@ -210,9 +210,9 @@ static int rt2860_resume(struct pci_dev *pci_dev)
 
 	DBGPRINT(RT_DEBUG_TRACE, ("===> rt2860_resume()\n"));
 
-	if (net_dev == NULL) {
+	if (net_dev == NULL)
 		DBGPRINT(RT_DEBUG_ERROR, ("net_dev == NULL!\n"));
-	} else
+	else
 		GET_PAD_FROM_NET_DEV(pAd, net_dev);
 
 	if (pAd != NULL) {
@@ -280,7 +280,9 @@ static int __devinit rt2860_probe(IN struct pci_dev *pci_dev,
 
 /*PCIDevInit============================================== */
 	/* wake up and enable device */
-	if ((rv = pci_enable_device(pci_dev)) != 0) {
+	rv = pci_enable_device(pci_dev);
+
+	if (rv != 0) {
 		DBGPRINT(RT_DEBUG_ERROR,
 			 ("Enable PCI device failed, errno=%d!\n", rv));
 		return rv;
@@ -288,7 +290,9 @@ static int __devinit rt2860_probe(IN struct pci_dev *pci_dev,
 
 	print_name = (char *)pci_name(pci_dev);
 
-	if ((rv = pci_request_regions(pci_dev, print_name)) != 0) {
+	rv = pci_request_regions(pci_dev, print_name);
+
+	if (rv != 0) {
 		DBGPRINT(RT_DEBUG_ERROR,
 			 ("Request PCI resource failed, errno=%d!\n", rv));
 		goto err_out;
@@ -489,9 +493,8 @@ static void RTMPInitPCIeDevice(struct pci_dev *pci_dev, struct rt_rtmp_adapter *
 
 		/* Support advanced power save after 2892/2790. */
 		/* MAC version at offset 0x1000 is 0x2872XXXX/0x2870XXXX(PCIe, USB, SDIO). */
-		if ((MacCsr0 & 0xffff0000) != 0x28600000) {
+		if ((MacCsr0 & 0xffff0000) != 0x28600000)
 			OPSTATUS_SET_FLAG(pAd, fOP_STATUS_PCIE_DEVICE);
-		}
 	}
 }
 
@@ -899,9 +902,9 @@ void RTMPPCIeLinkCtrlValueRestore(struct rt_rtmp_adapter *pAd, u8 Level)
 		if ((Configuration != 0) && (Configuration != 0xFFFF)) {
 			Configuration &= 0xfefc;
 			/* If call from interface down, restore to orginial setting. */
-			if (Level == RESTORE_CLOSE) {
+			if (Level == RESTORE_CLOSE)
 				Configuration |= pAd->HostLnkCtrlConfiguration;
-			} else
+			else
 				Configuration |= 0x0;
 			PCI_REG_WIRTE_WORD(pObj->parent_pci_dev,
 					   pAd->HostLnkCtrlOffset,
@@ -1099,13 +1102,13 @@ void RTMPrt3xSetPCIePowerLinkCtrl(struct rt_rtmp_adapter *pAd)
 		/* Find PCI-to-PCI Bridge Express Capability Offset */
 		pos = pci_find_capability(pObj->parent_pci_dev, PCI_CAP_ID_EXP);
 
-		if (pos != 0) {
+		if (pos != 0)
 			pAd->HostLnkCtrlOffset = pos + PCI_EXP_LNKCTL;
-		}
+
 		/* If configurared to turn on L1. */
 		HostConfiguration = 0;
 		if (pAd->StaCfg.PSControl.field.rt30xxForceASPMTest == 1) {
-			DBGPRINT(RT_DEBUG_TRACE, ("Enter,PSM : Force ASPM \n"));
+			DBGPRINT(RT_DEBUG_TRACE, ("Enter,PSM : Force ASPM\n"));
 
 			/* Skip non-exist deice right away */
 			if ((pAd->HostLnkCtrlOffset != 0)) {
-- 
1.6.4.4


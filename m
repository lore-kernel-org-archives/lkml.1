Return-Path: <linux-kernel-owner+w=401wt.eu-S1757951AbZF1OPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951AbZF1OPu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 10:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756978AbZF1ONm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 10:13:42 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:47267 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756971AbZF1ONj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 10:13:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=nDuQn0eFyiPPTnCbSEcOZroBHTF5k/7G1LRpX6lF0h60JAqfp0u3zhE8WIm0hxB7hV
         LeVogHH9wbwGkIQVMp8b+YWC+NeSnOEaNk2IeJRuZP13eQaGgvKq9reNOc22M2YPN96U
         TgOaOEZaxtkdBDRhWJwAGoplOUdzCL7QkWmxY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 28 Jun 2009 16:20:04 +0200
Message-Id: <20090628142004.8761.31645.sendpatchset@localhost.localdomain>
In-Reply-To: <20090628141844.8761.8943.sendpatchset@localhost.localdomain>
References: <20090628141844.8761.8943.sendpatchset@localhost.localdomain>
Subject: [PATCH 13/18] Staging: rtl8187se: cleanup r8180_pm.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rtl8187se: cleanup r8180_pm.c

* remove unused rtl8180_{save_state,enable_wake}()
* remove commented out code
* beautify code

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rtl8187se/r8180_pm.c |   32 ++++++++------------------------
 drivers/staging/rtl8187se/r8180_pm.h |    2 --
 2 files changed, 8 insertions(+), 26 deletions(-)

Index: b/drivers/staging/rtl8187se/r8180_pm.c
===================================================================
--- a/drivers/staging/rtl8187se/r8180_pm.c
+++ b/drivers/staging/rtl8187se/r8180_pm.c
@@ -15,16 +15,9 @@
 #include "r8180_pm.h"
 #include "r8180.h"
 
-int rtl8180_save_state (struct pci_dev *dev, u32 state)
-{
-        printk(KERN_NOTICE "r8180 save state call (state %u).\n", state);
-	return(-EAGAIN);
-}
-
-int rtl8180_suspend (struct pci_dev *pdev, pm_message_t state)
+int rtl8180_suspend(struct pci_dev *pdev, pm_message_t state)
 {
 	struct net_device *dev = pci_get_drvdata(pdev);
-//	struct r8180_priv *priv = ieee80211_priv(dev);
 
 	if (!netif_running(dev))
 		goto out_pci_suspend;
@@ -37,27 +30,28 @@ int rtl8180_suspend (struct pci_dev *pde
 out_pci_suspend:
 	pci_save_state(pdev);
 	pci_disable_device(pdev);
-	pci_set_power_state(pdev,pci_choose_state(pdev,state));
+	pci_set_power_state(pdev, pci_choose_state(pdev, state));
 	return 0;
 }
 
-int rtl8180_resume (struct pci_dev *pdev)
+int rtl8180_resume(struct pci_dev *pdev)
 {
 	struct net_device *dev = pci_get_drvdata(pdev);
-//	struct r8180_priv *priv = ieee80211_priv(dev);
 	int err;
 	u32 val;
 
 	pci_set_power_state(pdev, PCI_D0);
 
 	err = pci_enable_device(pdev);
-	if(err) {
+	if (err) {
 		printk(KERN_ERR "%s: pci_enable_device failed on resume\n",
 				dev->name);
 
 		return err;
 	}
+
 	pci_restore_state(pdev);
+
 	/*
 	 * Suspend/Resume resets the PCI configuration space, so we have to
 	 * re-disable the RETRY_TIMEOUT register (0x41) to keep PCI Tx retries
@@ -68,23 +62,13 @@ int rtl8180_resume (struct pci_dev *pdev
 	if ((val & 0x0000ff00) != 0)
 		pci_write_config_dword(pdev, 0x40, val & 0xffff00ff);
 
-	if(!netif_running(dev))
+	if (!netif_running(dev))
 		goto out;
 
 	if (dev->netdev_ops->ndo_open)
 		dev->netdev_ops->ndo_open(dev);
+
 	netif_device_attach(dev);
 out:
 	return 0;
 }
-
-
-int rtl8180_enable_wake (struct pci_dev *dev, u32 state, int enable)
-{
-        printk(KERN_NOTICE "r8180 enable wake call (state %u, enable %d).\n",
-	       state, enable);
-	return(-EAGAIN);
-}
-
-
-
Index: b/drivers/staging/rtl8187se/r8180_pm.h
===================================================================
--- a/drivers/staging/rtl8187se/r8180_pm.h
+++ b/drivers/staging/rtl8187se/r8180_pm.h
@@ -17,10 +17,8 @@
 #include <linux/types.h>
 #include <linux/pci.h>
 
-int rtl8180_save_state (struct pci_dev *dev, u32 state);
 int rtl8180_suspend (struct pci_dev *pdev, pm_message_t state);
 int rtl8180_resume (struct pci_dev *pdev);
-int rtl8180_enable_wake (struct pci_dev *dev, u32 state, int enable);
 
 #endif //R8180_PM_H
 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754906AbYL3Wxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906AbYL3Wxt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 17:53:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753517AbYL3Wuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 17:50:32 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57684 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540AbYL3WuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 17:50:16 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [RFC][PATCH 4/10] PCI PM: Move pci_has_legacy_pm_support
Date: Tue, 30 Dec 2008 23:40:06 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Pavel Machek <pavel@suse.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Linux PCI <linux-pci@vger.kernel.org>
References: <200812190049.34343.rjw@sisk.pl> <200812281607.28007.rjw@sisk.pl> <200812302333.45560.rjw@sisk.pl>
In-Reply-To: <200812302333.45560.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812302340.07249.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Move pci_has_legacy_pm_support() closer to the functions that
call it.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci-driver.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

Index: linux-2.6/drivers/pci/pci-driver.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-driver.c
+++ linux-2.6/drivers/pci/pci-driver.c
@@ -300,14 +300,6 @@ static void pci_device_shutdown(struct d
 
 #ifdef CONFIG_PM_SLEEP
 
-static bool pci_has_legacy_pm_support(struct pci_dev *pci_dev)
-{
-	struct pci_driver *drv = pci_dev->driver;
-
-	return drv && (drv->suspend || drv->suspend_late || drv->resume
-		|| drv->resume_early);
-}
-
 /*
  * Default "suspend" method for devices that have no driver provided suspend,
  * or not even a driver at all (first part).
@@ -444,6 +436,14 @@ static void pci_pm_default_suspend(struc
 		pci_prepare_to_sleep(pci_dev);
 }
 
+static bool pci_has_legacy_pm_support(struct pci_dev *pci_dev)
+{
+	struct pci_driver *drv = pci_dev->driver;
+
+	return drv && (drv->suspend || drv->suspend_late || drv->resume
+		|| drv->resume_early);
+}
+
 /* New power management framework */
 
 static int pci_pm_prepare(struct device *dev)


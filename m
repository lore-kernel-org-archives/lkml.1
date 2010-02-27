Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030832Ab0B0Ues (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 15:34:48 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55622 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030770Ab0B0Uer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 15:34:47 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] PCI / PM / Runtime: Make runtime PM of PCI devices inactive by default
Date: Sat, 27 Feb 2010 21:37:37 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-git-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002272137.37349.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make the run-time power management of PCI devices be inactive by
default by calling pm_runtime_forbid() for each PCI device during its
initialization.  This setting may be overriden by the user space with
the help of the /sys/devices/.../power/control interface.

That's necessary to avoid breakage on systems where ACPI-based
wake-up is known to fail for some devices.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -1540,8 +1540,10 @@ void pci_pm_init(struct pci_dev *dev)
 	int pm;
 	u16 pmc;
 
+	pm_runtime_forbid(&dev->dev);
 	device_enable_async_suspend(&dev->dev);
 	dev->wakeup_prepared = false;
+
 	dev->pm_cap = 0;
 
 	/* find PCI PM capability in list */

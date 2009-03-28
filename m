Return-Path: <linux-kernel-owner+w=401wt.eu-S1760746AbZC1V0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760746AbZC1V0l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 17:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760703AbZC1V0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 17:26:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59792 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760696AbZC1V0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 17:26:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] PCI PM: Make pci_prepare_to_sleep() disable wake-up if needed
Date: Sat, 28 Mar 2009 22:26:15 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rjw; KDE/4.2.1; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903282226.15511.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

If the device is not supposed to wake up the system, ie. when
device_may_wakeup(&dev->dev) returns 'false', pci_prepare_to_sleep()
should pass 'false' to pci_enable_wake() so that it calls the
platform to disable the wake-up capability of the device.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -1268,7 +1268,7 @@ int pci_prepare_to_sleep(struct pci_dev 
 	if (target_state == PCI_POWER_ERROR)
 		return -EIO;
 
-	pci_enable_wake(dev, target_state, true);
+	pci_enable_wake(dev, target_state, device_may_wakeup(&dev->dev));
 
 	error = pci_set_power_state(dev, target_state);
 

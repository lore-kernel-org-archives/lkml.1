Return-Path: <linux-kernel-owner+w=401wt.eu-S1757627AbZBCAm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627AbZBCAm0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 19:42:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758348AbZBCAmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 19:42:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36131 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754119AbZBCAmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 19:42:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] PCI PM: Read power state from device after trying to change it on resume
Date: Tue, 3 Feb 2009 01:41:27 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902030141.28410.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

pci_restore_standard_config() unconditionally changes current_state
to PCI_D0 after attempting to change the device's power state, but
it should rather read the actual current power state from the
device.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -1418,7 +1418,7 @@ int pci_restore_standard_config(struct p
 		break;
 	}
 
-	dev->current_state = PCI_D0;
+	pci_update_current_state(dev, PCI_D0);
 
  Restore:
 	return pci_restore_state(dev);


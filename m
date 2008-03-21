Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388AbYCUE2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbYCUE2y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 00:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbYCUE2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 00:28:42 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39666 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbYCUE2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 00:28:40 -0400
Message-ID: <47E3390A.7030308@jp.fujitsu.com>
Date: Fri, 21 Mar 2008 13:26:50 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>, Greg KH <gregkh@suse.de>
CC: Gary Hade <garyhade@us.ibm.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Matthew Wilcox <matthew@wil.cx>, warthog19@eaglescrag.net,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
Subject: [PATCH 15/16] PCI slot: Trivial cleanups for slot.c (Not for mainline!)
References: <20080318210539.GA30421@ldl.fc.hp.com> <47E33472.1000602@jp.fujitsu.com>
In-Reply-To: <47E33472.1000602@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some trivial cleanups for drivers/pci/slot.c.

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

---
 drivers/pci/slot.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

Index: linux-2.6.25-rc6/drivers/pci/slot.c
===================================================================
--- linux-2.6.25-rc6.orig/drivers/pci/slot.c
+++ linux-2.6.25-rc6/drivers/pci/slot.c
@@ -132,19 +132,16 @@ EXPORT_SYMBOL_GPL(pci_destroy_slot);
 
 static int pci_slot_init(void)
 {
-	int result = 0;
 	struct kset *pci_bus_kset;
 
 	pci_bus_kset = bus_get_kset(&pci_bus_type);
-
 	pci_slots_kset = kset_create_and_add("slots", NULL,
 						&pci_bus_kset->kobj);
 	if (!pci_slots_kset) {
-		result = -ENOMEM;
-		printk(KERN_ERR "PCI: Slot initialization failure (%d)\n",
-			result);
+		printk(KERN_ERR "PCI: Slot initialization failure\n");
+		return -ENOMEM;
 	}
-	return result;
+	return 0;
 }
 
 subsys_initcall(pci_slot_init);



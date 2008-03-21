Return-Path: <linux-kernel-owner+w=401wt.eu-S1753992AbYCUE1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbYCUE1D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 00:27:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbYCUE0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 00:26:51 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45492 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbYCUE0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 00:26:50 -0400
Message-ID: <47E33833.9000408@jp.fujitsu.com>
Date: Fri, 21 Mar 2008 13:23:15 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>, Greg KH <gregkh@suse.de>
CC: Gary Hade <garyhade@us.ibm.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Matthew Wilcox <matthew@wil.cx>, warthog19@eaglescrag.net,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
Subject: [PATCH 13/16] PCI slot: Fix return value of pci_create_slot() (Not
 for mainline!)
References: <20080318210539.GA30421@ldl.fc.hp.com> <47E33472.1000602@jp.fujitsu.com>
In-Reply-To: <47E33472.1000602@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can use the error code from kobject_init_and_add() as it is.

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

---
 drivers/pci/slot.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6.25-rc6/drivers/pci/slot.c
===================================================================
--- linux-2.6.25-rc6.orig/drivers/pci/slot.c
+++ linux-2.6.25-rc6/drivers/pci/slot.c
@@ -99,7 +99,6 @@ struct pci_slot *pci_create_slot(struct 
 				   "%s", name);
 	if (err) {
 		printk(KERN_ERR "Unable to register kobject %s\n", name);
-		err = -EINVAL;
 		goto err;
 	}
 



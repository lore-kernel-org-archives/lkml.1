Return-Path: <linux-kernel-owner+w=401wt.eu-S1753438AbYCUEPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbYCUEPa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 00:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170AbYCUEPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 00:15:17 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44945 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbYCUEPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 00:15:15 -0400
Message-ID: <47E334E2.6060306@jp.fujitsu.com>
Date: Fri, 21 Mar 2008 13:09:06 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>, Greg KH <gregkh@suse.de>
CC: Gary Hade <garyhade@us.ibm.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Matthew Wilcox <matthew@wil.cx>, warthog19@eaglescrag.net,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
Subject: [PATCH  1/16][BUG] Export kobject_rename for pci_hotplug_core (Not
 for mainline!)
References: <20080318210539.GA30421@ldl.fc.hp.com> <47E33472.1000602@jp.fujitsu.com>
In-Reply-To: <47E33472.1000602@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export kobject_rename() to fix the following link error. This happens
when pci_hotplug_core driver is compiled as a kernel module.

ERROR: "kobject_rename" [drivers/pci/hotplug/pci_hotplug.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2
make: *** Waiting for unfinished jobs....

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

---
 lib/kobject.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.25-rc6/lib/kobject.c
===================================================================
--- linux-2.6.25-rc6.orig/lib/kobject.c
+++ linux-2.6.25-rc6/lib/kobject.c
@@ -456,6 +456,7 @@ out:
 
 	return error;
 }
+EXPORT_SYMBOL_GPL(kobject_rename);
 
 /**
  * kobject_move - move object to another parent



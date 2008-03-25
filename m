Return-Path: <linux-kernel-owner+w=401wt.eu-S1758523AbYCYRNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758523AbYCYRNA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 13:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753555AbYCYRMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 13:12:49 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:20350 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbYCYRMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 13:12:48 -0400
Date: Tue, 25 Mar 2008 11:12:46 -0600
From: Alex Chiang <achiang@hp.com>
To: gregkh@suse.de, Gary Hade <garyhade@us.ibm.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Matthew Wilcox <matthew@wil.cx>, warthog19@eaglescrag.net,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
Subject: [PATCH 2/4] Export kobject_rename for pci_hotplug_core
Message-ID: <20080325171246.GC3489@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>, gregkh@suse.de,
	Gary Hade <garyhade@us.ibm.com>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
	Matthew Wilcox <matthew@wil.cx>, warthog19@eaglescrag.net,
	rick.jones2@hp.com, linux-kernel@vger.kernel.org,
	linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
References: <20080325170951.GA3489@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080325170951.GA3489@ldl.fc.hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
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
Acked-by: Alex Chiang <achiang@hp.com>
---
 lib/kobject.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index 0d03252..e2a9f65 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -456,6 +456,7 @@ out:
 
 	return error;
 }
+EXPORT_SYMBOL_GPL(kobject_rename);
 
 /**
  * kobject_move - move object to another parent
-- 
1.5.3.1.g1e61


Return-Path: <linux-kernel-owner+w=401wt.eu-S1761725AbXEOTh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761725AbXEOTh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 15:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761746AbXEOTgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 15:36:52 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45130 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761738AbXEOTgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 15:36:51 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] rpadlpar breakage - fallout of struct subsystem removal
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, linuxppc-dev@ozlabz.org
Message-Id: <E1Ho2pG-0003U8-BH@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Tue, 15 May 2007 20:36:50 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/pci/hotplug/rpadlpar_sysfs.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/hotplug/rpadlpar_sysfs.c b/drivers/pci/hotplug/rpadlpar_sysfs.c
index 6c5be3f..df07606 100644
--- a/drivers/pci/hotplug/rpadlpar_sysfs.c
+++ b/drivers/pci/hotplug/rpadlpar_sysfs.c
@@ -129,8 +129,9 @@ struct kobj_type ktype_dlpar_io = {
 };
 
 struct kset dlpar_io_kset = {
-	.subsys = &pci_hotplug_slots_subsys,
-	.kobj = {.name = DLPAR_KOBJ_NAME, .ktype=&ktype_dlpar_io,},
+	.kobj = {.name = DLPAR_KOBJ_NAME,
+		 .ktype = &ktype_dlpar_io,
+		 .parent = &pci_hotplug_slots_subsys.kobj},
 	.ktype = &ktype_dlpar_io,
 };
 
-- 
1.5.0-rc2.GIT



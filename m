Return-Path: <linux-kernel-owner+w=401wt.eu-S1756568AbXEJNx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568AbXEJNx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 09:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759126AbXEJNxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 09:53:51 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3990 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948AbXEJNxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 09:53:50 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: gregkh@suse.de
Cc: paulus@samba.org, Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: [PATCH] update sysfs kset initialisation in PPC64 DLPAR IO driver
References: <464322F3.3010808@shadowen.org>
InReply-To: <464322F3.3010808@shadowen.org>
Message-ID: <2c705c055fcd12202673ee8a3056153b@pinky>
Date: Thu, 10 May 2007 15:00:50 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Move the rpadlpar device from "struct subsystem" to "struct kset"
following the changes in sysfs.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---

	Ok, this patch seems to sort out the compile problem
	here and indeed boots and runs kernbench.  Perhaps
	you could confirm this is sufficient.


diff --git a/drivers/pci/hotplug/rpadlpar_sysfs.c b/drivers/pci/hotplug/rpadlpar_sysfs.c
index 6c5be3f..ed4de59 100644
--- a/drivers/pci/hotplug/rpadlpar_sysfs.c
+++ b/drivers/pci/hotplug/rpadlpar_sysfs.c
@@ -129,13 +129,13 @@ struct kobj_type ktype_dlpar_io = {
 };
 
 struct kset dlpar_io_kset = {
-	.subsys = &pci_hotplug_slots_subsys,
 	.kobj = {.name = DLPAR_KOBJ_NAME, .ktype=&ktype_dlpar_io,},
 	.ktype = &ktype_dlpar_io,
 };
 
 int dlpar_sysfs_init(void)
 {
+	kobj_set_kset_s(&dlpar_io_kset, pci_hotplug_slots_subsys);
 	if (kset_register(&dlpar_io_kset)) {
 		printk(KERN_ERR "rpadlpar_io: cannot register kset for %s\n",
 				dlpar_io_kset.kobj.name);

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754591Ab0AELsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab0AELsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 06:48:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754498Ab0AELsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 06:48:11 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36333 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754252Ab0AELsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 06:48:06 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201001051247.104464547@firstfloor.org>
In-Reply-To: <201001051247.104464547@firstfloor.org>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: [PATCH] [8/12] SYSFS: Add sysdev_create/remove_files
Message-Id: <20100105114805.8AA08B17C2@basil.firstfloor.org>
Date: Tue,  5 Jan 2010 12:48:05 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Allow to create/remove arrays of sysdev attributes

Just wrappers around sysfs_create/move_files

Will be used later to clean up some drivers.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/linux/sysdev.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

Index: linux-2.6.33-rc2-ak/include/linux/sysdev.h
===================================================================
--- linux-2.6.33-rc2-ak.orig/include/linux/sysdev.h
+++ linux-2.6.33-rc2-ak/include/linux/sysdev.h
@@ -123,6 +123,19 @@ struct sysdev_attribute {
 extern int sysdev_create_file(struct sys_device *, struct sysdev_attribute *);
 extern void sysdev_remove_file(struct sys_device *, struct sysdev_attribute *);
 
+/* Create/remove NULL terminated attribute list */
+static inline int
+sysdev_create_files(struct sys_device *d, struct sysdev_attribute **a)
+{
+	return sysfs_create_files(&d->kobj, (const struct attribute **)a);
+}
+
+static inline void
+sysdev_remove_files(struct sys_device *d, struct sysdev_attribute **a)
+{
+	return sysfs_remove_files(&d->kobj, (const struct attribute **)a);
+}
+
 struct sysdev_ext_attribute {
 	struct sysdev_attribute attr;
 	void *var;

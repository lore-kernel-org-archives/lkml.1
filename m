Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199Ab0CBX6l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:58:41 -0500
Received: from kroah.org ([198.145.64.141]:38516 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754155Ab0CBX3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:16 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 12/62] sysdev: Add sysdev_create/remove_files
Date: Tue,  2 Mar 2010 15:28:11 -0800
Message-Id: <1267572541-410-12-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230933.GA32287@kroah.com>
References: <20100302230933.GA32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>

Allow to create/remove arrays of sysdev attributes

Just wrappers around sysfs_create/move_files

Will be used later to clean up some drivers.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/sysdev.h |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/include/linux/sysdev.h b/include/linux/sysdev.h
index b6244f9..1154c29 100644
--- a/include/linux/sysdev.h
+++ b/include/linux/sysdev.h
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
-- 
1.7.0.1


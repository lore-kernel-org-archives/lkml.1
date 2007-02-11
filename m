Return-Path: <linux-kernel-owner+w=401wt.eu-S1753126AbXBKGvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126AbXBKGvz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 01:51:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbXBKGvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 01:51:55 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:58843 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbXBKGvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 01:51:54 -0500
Date: Sat, 10 Feb 2007 22:47:24 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: teheo@suse.de, akpm <akpm@osdl.org>
Subject: [PATCH] devres: kernel-doc and DocBook
Message-Id: <20070210224724.f048875c.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Make devres.c ready for adding to DocBook.
Fix a few comment typos in drivers/pci/pci.c.
Add devres.c to DocBook.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/DocBook/kernel-api.tmpl |    4 ++++
 drivers/base/devres.c                 |   32 ++++++++++++++++----------------
 drivers/pci/pci.c                     |    2 +-
 3 files changed, 21 insertions(+), 17 deletions(-)

--- linux-2.6.20-git6.orig/drivers/base/devres.c
+++ linux-2.6.20-git6/drivers/base/devres.c
@@ -101,19 +101,6 @@ static void add_dr(struct device *dev, s
 	list_add_tail(&node->entry, &dev->devres_head);
 }
 
-/**
- * devres_alloc - Allocate device resource data
- * @release: Release function devres will be associated with
- * @size: Allocation size
- * @gfp: Allocation flags
- *
- * allocate devres of @size bytes.  The allocated area is zeroed, then
- * associated with @release.  The returned pointer can be passed to
- * other devres_*() functions.
- *
- * RETURNS:
- * Pointer to allocated devres on success, NULL on failure.
- */
 #ifdef CONFIG_DEBUG_DEVRES
 void * __devres_alloc(dr_release_t release, size_t size, gfp_t gfp,
 		      const char *name)
@@ -128,6 +115,19 @@ void * __devres_alloc(dr_release_t relea
 }
 EXPORT_SYMBOL_GPL(__devres_alloc);
 #else
+/**
+ * devres_alloc - Allocate device resource data
+ * @release: Release function devres will be associated with
+ * @size: Allocation size
+ * @gfp: Allocation flags
+ *
+ * Allocate devres of @size bytes.  The allocated area is zeroed, then
+ * associated with @release.  The returned pointer can be passed to
+ * other devres_*() functions.
+ *
+ * RETURNS:
+ * Pointer to allocated devres on success, NULL on failure.
+ */
 void * devres_alloc(dr_release_t release, size_t size, gfp_t gfp)
 {
 	struct devres *dr;
@@ -416,7 +416,7 @@ static int release_nodes(struct device *
 }
 
 /**
- * devres_release_all - Release all resources
+ * devres_release_all - Release all managed resources
  * @dev: Device to release resources for
  *
  * Release all resources associated with @dev.  This function is
@@ -600,7 +600,7 @@ static int devm_kzalloc_match(struct dev
 }
 
 /**
- * devm_kzalloc - Managed kzalloc
+ * devm_kzalloc - Resource-managed kzalloc
  * @dev: Device to allocate memory for
  * @size: Allocation size
  * @gfp: Allocation gfp flags
@@ -628,7 +628,7 @@ void * devm_kzalloc(struct device *dev, 
 EXPORT_SYMBOL_GPL(devm_kzalloc);
 
 /**
- * devm_kfree - Managed kfree
+ * devm_kfree - Resource-managed kfree
  * @dev: Device this memory belongs to
  * @p: Memory to free
  *
--- linux-2.6.20-git6.orig/Documentation/DocBook/kernel-api.tmpl
+++ linux-2.6.20-git6/Documentation/DocBook/kernel-api.tmpl
@@ -84,6 +84,10 @@ X!Iinclude/linux/kobject.h
 !Ekernel/rcupdate.c
      </sect1>
 
+     <sect1><title>Device Resource Management</title>
+!Edrivers/base/devres.c
+     </sect1>
+
   </chapter>
 
   <chapter id="adt">
--- linux-2.6.20-git6.orig/drivers/pci/pci.c
+++ linux-2.6.20-git6/drivers/pci/pci.c
@@ -1344,7 +1344,7 @@ static void pcim_iomap_release(struct de
  * detach.
  *
  * This function might sleep when the table is first allocated but can
- * be safely called without context and guaranteed to succed once
+ * be safely called without context and is guaranteed to succeed once
  * allocated.
  */
 void __iomem * const * pcim_iomap_table(struct pci_dev *pdev)

Return-Path: <linux-kernel-owner+w=401wt.eu-S967011AbYD1WjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967011AbYD1WjO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 18:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965274AbYD1WgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 18:36:24 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:12284 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965134AbYD1WgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 18:36:22 -0400
Message-Id: <20080428223617.243108378@ldl.fc.hp.com>
References: <20080428223347.233593713@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Mon, 28 Apr 2008 16:33:51 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, Rene Herman <rene.herman@gmail.com>
Cc: linux-kernel@vger.kernel.org
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Adam M Belay <abelay@mit.edu>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 04/55] PNP: make pnp_add_id() internal to PNP core
Content-Disposition: inline; filename=pnp-make-pnp_add_id-internal-to-core
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pnp_add_id() doesn't need to be exposed outside the PNP core, so
move the declaration to an internal header file.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-By: Rene Herman <rene.herman@gmail.com>

Index: work10/include/linux/pnp.h
===================================================================
--- work10.orig/include/linux/pnp.h	2008-04-28 15:57:04.000000000 -0600
+++ work10/include/linux/pnp.h	2008-04-28 16:09:09.000000000 -0600
@@ -403,7 +403,6 @@
 /* protocol helpers */
 int pnp_is_active(struct pnp_dev *dev);
 int compare_pnp_id(struct pnp_id *pos, const char *id);
-int pnp_add_id(struct pnp_id *id, struct pnp_dev *dev);
 int pnp_register_driver(struct pnp_driver *drv);
 void pnp_unregister_driver(struct pnp_driver *drv);
 
@@ -450,7 +449,6 @@
 /* protocol helpers */
 static inline int pnp_is_active(struct pnp_dev *dev) { return 0; }
 static inline int compare_pnp_id(struct pnp_id *pos, const char *id) { return -ENODEV; }
-static inline int pnp_add_id(struct pnp_id *id, struct pnp_dev *dev) { return -ENODEV; }
 static inline int pnp_register_driver(struct pnp_driver *drv) { return -ENODEV; }
 static inline void pnp_unregister_driver(struct pnp_driver *drv) { }
 
Index: work10/drivers/pnp/base.h
===================================================================
--- work10.orig/drivers/pnp/base.h	2008-04-28 15:57:04.000000000 -0600
+++ work10/drivers/pnp/base.h	2008-04-28 16:09:09.000000000 -0600
@@ -1,5 +1,6 @@
 extern spinlock_t pnp_lock;
 void *pnp_alloc(long size);
+int pnp_add_id(struct pnp_id *id, struct pnp_dev *dev);
 int pnp_interface_attach_device(struct pnp_dev *dev);
 void pnp_fixup_device(struct pnp_dev *dev);
 void pnp_free_option(struct pnp_option *option);
Index: work10/drivers/pnp/pnpacpi/core.c
===================================================================
--- work10.orig/drivers/pnp/pnpacpi/core.c	2008-04-28 16:09:08.000000000 -0600
+++ work10/drivers/pnp/pnpacpi/core.c	2008-04-28 16:09:09.000000000 -0600
@@ -25,6 +25,7 @@
 #include <acpi/acpi_bus.h>
 #include <acpi/actypes.h>
 
+#include "../base.h"
 #include "pnpacpi.h"
 
 static int num = 0;
Index: work10/drivers/pnp/pnpbios/core.c
===================================================================
--- work10.orig/drivers/pnp/pnpbios/core.c	2008-04-28 15:57:04.000000000 -0600
+++ work10/drivers/pnp/pnpbios/core.c	2008-04-28 16:09:09.000000000 -0600
@@ -69,6 +69,7 @@
 #include <asm/system.h>
 #include <asm/byteorder.h>
 
+#include "../base.h"
 #include "pnpbios.h"
 
 /*

-- 

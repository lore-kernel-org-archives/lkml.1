Return-Path: <linux-kernel-owner+w=401wt.eu-S1759167AbYDAPUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759167AbYDAPUR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 11:20:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403AbYDAPR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 11:17:59 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:5348 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758804AbYDAPRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 11:17:49 -0400
Message-Id: <20080401151736.204623555@ldl.fc.hp.com>
References: <20080401151634.730901933@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Tue, 01 Apr 2008 09:16:37 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 03/37] PNP: make pnp_add_id() internal to PNP core
Content-Disposition: inline; filename=pnp-make-pnp_add_id-internal-to-core
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pnp_add_id() doesn't need to be exposed outside the PNP core, so
move the declaration to an internal header file.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work7/include/linux/pnp.h
===================================================================
--- work7.orig/include/linux/pnp.h	2008-03-21 13:31:06.000000000 -0600
+++ work7/include/linux/pnp.h	2008-03-21 13:31:08.000000000 -0600
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
 
Index: work7/drivers/pnp/base.h
===================================================================
--- work7.orig/drivers/pnp/base.h	2008-03-21 13:31:06.000000000 -0600
+++ work7/drivers/pnp/base.h	2008-03-21 13:31:39.000000000 -0600
@@ -1,5 +1,6 @@
 extern spinlock_t pnp_lock;
 void *pnp_alloc(long size);
+int pnp_add_id(struct pnp_id *id, struct pnp_dev *dev);
 int pnp_interface_attach_device(struct pnp_dev *dev);
 void pnp_fixup_device(struct pnp_dev *dev);
 void pnp_free_option(struct pnp_option *option);
Index: work7/drivers/pnp/pnpacpi/core.c
===================================================================
--- work7.orig/drivers/pnp/pnpacpi/core.c	2008-03-21 13:31:06.000000000 -0600
+++ work7/drivers/pnp/pnpacpi/core.c	2008-03-21 13:31:08.000000000 -0600
@@ -25,6 +25,7 @@
 #include <acpi/acpi_bus.h>
 #include <acpi/actypes.h>
 
+#include "../base.h"
 #include "pnpacpi.h"
 
 static int num = 0;
Index: work7/drivers/pnp/pnpbios/core.c
===================================================================
--- work7.orig/drivers/pnp/pnpbios/core.c	2008-03-21 13:31:06.000000000 -0600
+++ work7/drivers/pnp/pnpbios/core.c	2008-03-21 13:31:08.000000000 -0600
@@ -69,6 +69,7 @@
 #include <asm/system.h>
 #include <asm/byteorder.h>
 
+#include "../base.h"
 #include "pnpbios.h"
 
 /*

-- 

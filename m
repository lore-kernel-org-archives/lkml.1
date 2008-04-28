Return-Path: <linux-kernel-owner+w=401wt.eu-S967178AbYD1WnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967178AbYD1WnM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 18:43:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966519AbYD1Wgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 18:36:38 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:30399 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965570AbYD1Wg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 18:36:29 -0400
Message-Id: <20080428223618.074306413@ldl.fc.hp.com>
References: <20080428223347.233593713@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Mon, 28 Apr 2008 16:33:55 -0600
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
Subject: [patch 08/55] PNP: make pnp_add_card_id() internal to PNP core
Content-Disposition: inline; filename=pnp-make-pnp_add_card_id-internal-to-core
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pnp_add_card_id() doesn't need to be exposed outside the PNP core, so
move the declaration to an internal header file.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-By: Rene Herman <rene.herman@gmail.com>

Index: work10/drivers/pnp/base.h
===================================================================
--- work10.orig/drivers/pnp/base.h	2008-04-28 16:09:12.000000000 -0600
+++ work10/drivers/pnp/base.h	2008-04-28 16:09:12.000000000 -0600
@@ -4,6 +4,7 @@
 void pnp_eisa_id_to_string(u32 id, char *str);
 struct pnp_dev *pnp_alloc_dev(struct pnp_protocol *, int id, char *pnpid);
 struct pnp_id *pnp_add_id(struct pnp_dev *dev, char *id);
+int pnp_add_card_id(struct pnp_id *id, struct pnp_card *card);
 int pnp_interface_attach_device(struct pnp_dev *dev);
 void pnp_fixup_device(struct pnp_dev *dev);
 void pnp_free_option(struct pnp_option *option);
Index: work10/include/linux/pnp.h
===================================================================
--- work10.orig/include/linux/pnp.h	2008-04-28 16:09:09.000000000 -0600
+++ work10/include/linux/pnp.h	2008-04-28 16:09:12.000000000 -0600
@@ -371,7 +371,6 @@
 void pnp_remove_card(struct pnp_card *card);
 int pnp_add_card_device(struct pnp_card *card, struct pnp_dev *dev);
 void pnp_remove_card_device(struct pnp_dev *dev);
-int pnp_add_card_id(struct pnp_id *id, struct pnp_card *card);
 struct pnp_dev *pnp_request_card_device(struct pnp_card_link *clink,
 					const char *id, struct pnp_dev *from);
 void pnp_release_card_device(struct pnp_dev *dev);
@@ -423,7 +422,6 @@
 static inline void pnp_remove_card(struct pnp_card *card) { }
 static inline int pnp_add_card_device(struct pnp_card *card, struct pnp_dev *dev) { return -ENODEV; }
 static inline void pnp_remove_card_device(struct pnp_dev *dev) { }
-static inline int pnp_add_card_id(struct pnp_id *id, struct pnp_card *card) { return -ENODEV; }
 static inline struct pnp_dev *pnp_request_card_device(struct pnp_card_link *clink, const char *id, struct pnp_dev *from) { return NULL; }
 static inline void pnp_release_card_device(struct pnp_dev *dev) { }
 static inline int pnp_register_card_driver(struct pnp_card_driver *drv) { return -ENODEV; }

-- 

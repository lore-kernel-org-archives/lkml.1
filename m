Return-Path: <linux-kernel-owner+w=401wt.eu-S933378AbYDYTDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933378AbYDYTDg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 15:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765269AbYDYSld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 14:41:33 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:19392 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764933AbYDYSkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 14:40:41 -0400
Message-Id: <20080425183935.158406930@ldl.fc.hp.com>
References: <20080425183807.366134771@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 25 Apr 2008 12:38:59 -0600
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
Subject: [patch 52/54] PNP: make interfaces private to the PNP core
Content-Disposition: inline; filename=pnp-make-interfaces-private
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The interfaces for registering protocols, devices, cards,
and resource options should only be used inside the PNP core.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-By: Rene Herman <rene.herman@gmail.com>

---
 drivers/pnp/base.h  |   24 +++++++++++++++++++++++-
 include/linux/pnp.h |   34 ----------------------------------
 2 files changed, 23 insertions(+), 35 deletions(-)

Index: work10/include/linux/pnp.h
===================================================================
--- work10.orig/include/linux/pnp.h	2008-04-25 11:15:08.000000000 -0600
+++ work10/include/linux/pnp.h	2008-04-25 11:15:16.000000000 -0600
@@ -417,19 +417,12 @@
 #if defined(CONFIG_PNP)
 
 /* device management */
-int pnp_register_protocol(struct pnp_protocol *protocol);
-void pnp_unregister_protocol(struct pnp_protocol *protocol);
-int pnp_add_device(struct pnp_dev *dev);
 int pnp_device_attach(struct pnp_dev *pnp_dev);
 void pnp_device_detach(struct pnp_dev *pnp_dev);
 extern struct list_head pnp_global;
 extern int pnp_platform_devices;
 
 /* multidevice card support */
-int pnp_add_card(struct pnp_card *card);
-void pnp_remove_card(struct pnp_card *card);
-int pnp_add_card_device(struct pnp_card *card, struct pnp_dev *dev);
-void pnp_remove_card_device(struct pnp_dev *dev);
 struct pnp_dev *pnp_request_card_device(struct pnp_card_link *clink,
 					const char *id, struct pnp_dev *from);
 void pnp_release_card_device(struct pnp_dev *dev);
@@ -438,20 +431,7 @@
 extern struct list_head pnp_cards;
 
 /* resource management */
-struct pnp_option *pnp_register_independent_option(struct pnp_dev *dev);
-struct pnp_option *pnp_register_dependent_option(struct pnp_dev *dev,
-						 int priority);
-int pnp_register_irq_resource(struct pnp_dev *dev, struct pnp_option *option,
-			      struct pnp_irq *data);
-int pnp_register_dma_resource(struct pnp_dev *dev, struct pnp_option *option,
-			      struct pnp_dma *data);
-int pnp_register_port_resource(struct pnp_dev *dev, struct pnp_option *option,
-			       struct pnp_port *data);
-int pnp_register_mem_resource(struct pnp_dev *dev, struct pnp_option *option,
-			      struct pnp_mem *data);
-void pnp_init_resources(struct pnp_dev *dev);
 int pnp_auto_config_dev(struct pnp_dev *dev);
-int pnp_validate_config(struct pnp_dev *dev);
 int pnp_start_dev(struct pnp_dev *dev);
 int pnp_stop_dev(struct pnp_dev *dev);
 int pnp_activate_dev(struct pnp_dev *dev);
@@ -466,35 +446,19 @@
 #else
 
 /* device management */
-static inline int pnp_register_protocol(struct pnp_protocol *protocol) { return -ENODEV; }
-static inline void pnp_unregister_protocol(struct pnp_protocol *protocol) { }
-static inline int pnp_init_device(struct pnp_dev *dev) { return -ENODEV; }
-static inline int pnp_add_device(struct pnp_dev *dev) { return -ENODEV; }
 static inline int pnp_device_attach(struct pnp_dev *pnp_dev) { return -ENODEV; }
 static inline void pnp_device_detach(struct pnp_dev *pnp_dev) { }
 
 #define pnp_platform_devices 0
 
 /* multidevice card support */
-static inline int pnp_add_card(struct pnp_card *card) { return -ENODEV; }
-static inline void pnp_remove_card(struct pnp_card *card) { }
-static inline int pnp_add_card_device(struct pnp_card *card, struct pnp_dev *dev) { return -ENODEV; }
-static inline void pnp_remove_card_device(struct pnp_dev *dev) { }
 static inline struct pnp_dev *pnp_request_card_device(struct pnp_card_link *clink, const char *id, struct pnp_dev *from) { return NULL; }
 static inline void pnp_release_card_device(struct pnp_dev *dev) { }
 static inline int pnp_register_card_driver(struct pnp_card_driver *drv) { return -ENODEV; }
 static inline void pnp_unregister_card_driver(struct pnp_card_driver *drv) { }
 
 /* resource management */
-static inline struct pnp_option *pnp_register_independent_option(struct pnp_dev *dev) { return NULL; }
-static inline struct pnp_option *pnp_register_dependent_option(struct pnp_dev *dev, int priority) { return NULL; }
-static inline int pnp_register_irq_resource(struct pnp_dev *dev, struct pnp_option *option, struct pnp_irq *data) { return -ENODEV; }
-static inline int pnp_register_dma_resource(struct pnp_dev *dev, struct pnp_option *option, struct pnp_dma *data) { return -ENODEV; }
-static inline int pnp_register_port_resource(struct pnp_dev *dev, struct pnp_option *option, struct pnp_port *data) { return -ENODEV; }
-static inline int pnp_register_mem_resource(struct pnp_dev *dev, struct pnp_option *option, struct pnp_mem *data) { return -ENODEV; }
-static inline void pnp_init_resources(struct pnp_dev *dev) { }
 static inline int pnp_auto_config_dev(struct pnp_dev *dev) { return -ENODEV; }
-static inline int pnp_validate_config(struct pnp_dev *dev) { return -ENODEV; }
 static inline int pnp_start_dev(struct pnp_dev *dev) { return -ENODEV; }
 static inline int pnp_stop_dev(struct pnp_dev *dev) { return -ENODEV; }
 static inline int pnp_activate_dev(struct pnp_dev *dev) { return -ENODEV; }
Index: work10/drivers/pnp/base.h
===================================================================
--- work10.orig/drivers/pnp/base.h	2008-04-25 11:15:14.000000000 -0600
+++ work10/drivers/pnp/base.h	2008-04-25 11:15:16.000000000 -0600
@@ -1,12 +1,37 @@
 extern spinlock_t pnp_lock;
 void *pnp_alloc(long size);
+
+int pnp_register_protocol(struct pnp_protocol *protocol);
+void pnp_unregister_protocol(struct pnp_protocol *protocol);
+
 #define PNP_EISA_ID_MASK 0x7fffffff
 void pnp_eisa_id_to_string(u32 id, char *str);
 struct pnp_dev *pnp_alloc_dev(struct pnp_protocol *, int id, char *pnpid);
 struct pnp_card *pnp_alloc_card(struct pnp_protocol *, int id, char *pnpid);
+
+int pnp_add_device(struct pnp_dev *dev);
 struct pnp_id *pnp_add_id(struct pnp_dev *dev, char *id);
-struct pnp_id *pnp_add_card_id(struct pnp_card *card, char *id);
 int pnp_interface_attach_device(struct pnp_dev *dev);
+
+int pnp_add_card(struct pnp_card *card);
+struct pnp_id *pnp_add_card_id(struct pnp_card *card, char *id);
+void pnp_remove_card(struct pnp_card *card);
+int pnp_add_card_device(struct pnp_card *card, struct pnp_dev *dev);
+void pnp_remove_card_device(struct pnp_dev *dev);
+
+struct pnp_option *pnp_register_independent_option(struct pnp_dev *dev);
+struct pnp_option *pnp_register_dependent_option(struct pnp_dev *dev,
+						 int priority);
+int pnp_register_irq_resource(struct pnp_dev *dev, struct pnp_option *option,
+			      struct pnp_irq *data);
+int pnp_register_dma_resource(struct pnp_dev *dev, struct pnp_option *option,
+			      struct pnp_dma *data);
+int pnp_register_port_resource(struct pnp_dev *dev, struct pnp_option *option,
+			       struct pnp_port *data);
+int pnp_register_mem_resource(struct pnp_dev *dev, struct pnp_option *option,
+			      struct pnp_mem *data);
+void pnp_init_resources(struct pnp_dev *dev);
+
 void pnp_fixup_device(struct pnp_dev *dev);
 void pnp_free_option(struct pnp_option *option);
 int __pnp_add_device(struct pnp_dev *dev);

-- 

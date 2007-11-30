Return-Path: <linux-kernel-owner+w=401wt.eu-S934984AbXK3RE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934984AbXK3RE5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 12:04:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758148AbXK3REm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 12:04:42 -0500
Received: from ns2.suse.de ([195.135.220.15]:57170 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754674AbXK3REl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 12:04:41 -0500
Subject: [PATCH] Declare PNP option parsing functions as __init
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Rene Herman <rene.herman@keyaccess.nl>,
       akpm <akpm@linux-foundation.org>, "Li, Shaohua" <shaohua.li@intel.com>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Fri, 30 Nov 2007 18:04:37 +0100
Message-Id: <1196442277.23251.318.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If I have not overseen something, it should be rather obvious that those
can all be declared __init...
---------------

Declare PNP option parsing functions as __init

There are three kind of parse functions provided by PNP acpi/bios:
 - get current resources
 - set resources
 - get possible resources
The first two may be needed later at runtime.
The possible resource settings should never change dynamically.
And even if this would make any sense (I doubt it), the current implementation
only parses possible resource settings at early init time:
  -> declare all the option parsing __init

Signed-off-by: Thomas Renninger <trenn@suse.de>

---
 drivers/pnp/pnpacpi/rsparser.c |   44 ++++++++++++++++++++---------------------
 drivers/pnp/pnpbios/core.c     |    2 -
 drivers/pnp/pnpbios/rsparser.c |   32 ++++++++++++++---------------
 3 files changed, 39 insertions(+), 39 deletions(-)

Index: linux-2.6.24-rc3/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- linux-2.6.24-rc3.orig/drivers/pnp/pnpacpi/rsparser.c
+++ linux-2.6.24-rc3/drivers/pnp/pnpacpi/rsparser.c
@@ -384,8 +384,8 @@ acpi_status pnpacpi_parse_allocated_reso
 				   pnpacpi_allocated_resource, res);
 }
 
-static void pnpacpi_parse_dma_option(struct pnp_option *option,
-				     struct acpi_resource_dma *p)
+static __init void pnpacpi_parse_dma_option(struct pnp_option *option,
+					    struct acpi_resource_dma *p)
 {
 	int i;
 	struct pnp_dma *dma;
@@ -404,8 +404,8 @@ static void pnpacpi_parse_dma_option(str
 	pnp_register_dma_resource(option, dma);
 }
 
-static void pnpacpi_parse_irq_option(struct pnp_option *option,
-				     struct acpi_resource_irq *p)
+static __init void pnpacpi_parse_irq_option(struct pnp_option *option,
+					    struct acpi_resource_irq *p)
 {
 	int i;
 	struct pnp_irq *irq;
@@ -424,8 +424,8 @@ static void pnpacpi_parse_irq_option(str
 	pnp_register_irq_resource(option, irq);
 }
 
-static void pnpacpi_parse_ext_irq_option(struct pnp_option *option,
-					 struct acpi_resource_extended_irq *p)
+static __init void pnpacpi_parse_ext_irq_option(struct pnp_option *option,
+						struct acpi_resource_extended_irq *p)
 {
 	int i;
 	struct pnp_irq *irq;
@@ -444,8 +444,8 @@ static void pnpacpi_parse_ext_irq_option
 	pnp_register_irq_resource(option, irq);
 }
 
-static void pnpacpi_parse_port_option(struct pnp_option *option,
-				      struct acpi_resource_io *io)
+static __init void pnpacpi_parse_port_option(struct pnp_option *option,
+					     struct acpi_resource_io *io)
 {
 	struct pnp_port *port;
 
@@ -463,8 +463,8 @@ static void pnpacpi_parse_port_option(st
 	pnp_register_port_resource(option, port);
 }
 
-static void pnpacpi_parse_fixed_port_option(struct pnp_option *option,
-					    struct acpi_resource_fixed_io *io)
+static __init void pnpacpi_parse_fixed_port_option(struct pnp_option *option,
+						   struct acpi_resource_fixed_io *io)
 {
 	struct pnp_port *port;
 
@@ -480,8 +480,8 @@ static void pnpacpi_parse_fixed_port_opt
 	pnp_register_port_resource(option, port);
 }
 
-static void pnpacpi_parse_mem24_option(struct pnp_option *option,
-				       struct acpi_resource_memory24 *p)
+static __init void pnpacpi_parse_mem24_option(struct pnp_option *option,
+					      struct acpi_resource_memory24 *p)
 {
 	struct pnp_mem *mem;
 
@@ -501,8 +501,8 @@ static void pnpacpi_parse_mem24_option(s
 	pnp_register_mem_resource(option, mem);
 }
 
-static void pnpacpi_parse_mem32_option(struct pnp_option *option,
-				       struct acpi_resource_memory32 *p)
+static __init void pnpacpi_parse_mem32_option(struct pnp_option *option,
+					      struct acpi_resource_memory32 *p)
 {
 	struct pnp_mem *mem;
 
@@ -522,8 +522,8 @@ static void pnpacpi_parse_mem32_option(s
 	pnp_register_mem_resource(option, mem);
 }
 
-static void pnpacpi_parse_fixed_mem32_option(struct pnp_option *option,
-					 struct acpi_resource_fixed_memory32 *p)
+static __init void pnpacpi_parse_fixed_mem32_option(struct pnp_option *option,
+						    struct acpi_resource_fixed_memory32 *p)
 {
 	struct pnp_mem *mem;
 
@@ -542,8 +542,8 @@ static void pnpacpi_parse_fixed_mem32_op
 	pnp_register_mem_resource(option, mem);
 }
 
-static void pnpacpi_parse_address_option(struct pnp_option *option,
-					 struct acpi_resource *r)
+static __init void pnpacpi_parse_address_option(struct pnp_option *option,
+						struct acpi_resource *r)
 {
 	struct acpi_resource_address64 addr, *p = &addr;
 	acpi_status status;
@@ -589,8 +589,8 @@ struct acpipnp_parse_option_s {
 	struct pnp_dev *dev;
 };
 
-static acpi_status pnpacpi_option_resource(struct acpi_resource *res,
-					   void *data)
+static __init acpi_status pnpacpi_option_resource(struct acpi_resource *res,
+						  void *data)
 {
 	int priority = 0;
 	struct acpipnp_parse_option_s *parse_data = data;
@@ -689,8 +689,8 @@ static acpi_status pnpacpi_option_resour
 	return AE_OK;
 }
 
-acpi_status pnpacpi_parse_resource_option_data(acpi_handle handle,
-					       struct pnp_dev * dev)
+acpi_status __init pnpacpi_parse_resource_option_data(acpi_handle handle,
+						      struct pnp_dev * dev)
 {
 	acpi_status status;
 	struct acpipnp_parse_option_s parse_data;
Index: linux-2.6.24-rc3/drivers/pnp/pnpbios/rsparser.c
===================================================================
--- linux-2.6.24-rc3.orig/drivers/pnp/pnpbios/rsparser.c
+++ linux-2.6.24-rc3/drivers/pnp/pnpbios/rsparser.c
@@ -262,8 +262,8 @@ len_err:
  * Resource Configuration Options
  */
 
-static void pnpbios_parse_mem_option(unsigned char *p, int size,
-				     struct pnp_option *option)
+static __init void pnpbios_parse_mem_option(unsigned char *p, int size,
+					    struct pnp_option *option)
 {
 	struct pnp_mem *mem;
 
@@ -278,8 +278,8 @@ static void pnpbios_parse_mem_option(uns
 	pnp_register_mem_resource(option, mem);
 }
 
-static void pnpbios_parse_mem32_option(unsigned char *p, int size,
-				       struct pnp_option *option)
+static __init void pnpbios_parse_mem32_option(unsigned char *p, int size,
+					      struct pnp_option *option)
 {
 	struct pnp_mem *mem;
 
@@ -294,8 +294,8 @@ static void pnpbios_parse_mem32_option(u
 	pnp_register_mem_resource(option, mem);
 }
 
-static void pnpbios_parse_fixed_mem32_option(unsigned char *p, int size,
-					     struct pnp_option *option)
+static __init void pnpbios_parse_fixed_mem32_option(unsigned char *p, int size,
+						    struct pnp_option *option)
 {
 	struct pnp_mem *mem;
 
@@ -309,7 +309,7 @@ static void pnpbios_parse_fixed_mem32_op
 	pnp_register_mem_resource(option, mem);
 }
 
-static void pnpbios_parse_irq_option(unsigned char *p, int size,
+static __init void pnpbios_parse_irq_option(unsigned char *p, int size,
 				     struct pnp_option *option)
 {
 	struct pnp_irq *irq;
@@ -327,7 +327,7 @@ static void pnpbios_parse_irq_option(uns
 	pnp_register_irq_resource(option, irq);
 }
 
-static void pnpbios_parse_dma_option(unsigned char *p, int size,
+static __init void pnpbios_parse_dma_option(unsigned char *p, int size,
 				     struct pnp_option *option)
 {
 	struct pnp_dma *dma;
@@ -340,8 +340,8 @@ static void pnpbios_parse_dma_option(uns
 	pnp_register_dma_resource(option, dma);
 }
 
-static void pnpbios_parse_port_option(unsigned char *p, int size,
-				      struct pnp_option *option)
+static __init void pnpbios_parse_port_option(unsigned char *p, int size,
+					     struct pnp_option *option)
 {
 	struct pnp_port *port;
 
@@ -356,8 +356,8 @@ static void pnpbios_parse_port_option(un
 	pnp_register_port_resource(option, port);
 }
 
-static void pnpbios_parse_fixed_port_option(unsigned char *p, int size,
-					    struct pnp_option *option)
+static __init void pnpbios_parse_fixed_port_option(unsigned char *p, int size,
+						   struct pnp_option *option)
 {
 	struct pnp_port *port;
 
@@ -371,9 +371,9 @@ static void pnpbios_parse_fixed_port_opt
 	pnp_register_port_resource(option, port);
 }
 
-static unsigned char *pnpbios_parse_resource_option_data(unsigned char *p,
-							 unsigned char *end,
-							 struct pnp_dev *dev)
+static __init unsigned char *pnpbios_parse_resource_option_data(unsigned char *p,
+								unsigned char *end,
+								struct pnp_dev *dev)
 {
 	unsigned int len, tag;
 	int priority = 0;
@@ -781,7 +781,7 @@ len_err:
  * Core Parsing Functions
  */
 
-int pnpbios_parse_data_stream(struct pnp_dev *dev, struct pnp_bios_node *node)
+int __init pnpbios_parse_data_stream(struct pnp_dev *dev, struct pnp_bios_node *node)
 {
 	unsigned char *p = (char *)node->data;
 	unsigned char *end = (char *)(node->data + node->size);
Index: linux-2.6.24-rc3/drivers/pnp/pnpbios/core.c
===================================================================
--- linux-2.6.24-rc3.orig/drivers/pnp/pnpbios/core.c
+++ linux-2.6.24-rc3/drivers/pnp/pnpbios/core.c
@@ -313,7 +313,7 @@ struct pnp_protocol pnpbios_protocol = {
 	.disable = pnpbios_disable_resources,
 };
 
-static int insert_device(struct pnp_bios_node *node)
+static int __init insert_device(struct pnp_bios_node *node)
 {
 	struct list_head *pos;
 	struct pnp_dev *dev;



Return-Path: <linux-kernel-owner+w=401wt.eu-S1757591AbYHSW4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591AbYHSW4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 18:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755230AbYHSWxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 18:53:55 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:10210 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525AbYHSWxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 18:53:52 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: [PATCH 7/8] PNP: convert to using pnp_dbg()
To: Andi Kleen <andi@firstfloor.org>
Cc: Len Brown <lenb@kernel.org>, Adam M Belay <abelay@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Renninger <trenn@suse.de>, Dave Jones <davej@redhat.com>,
       Ben Collins <bcollins@ubuntu.com>, Dann Frazier <dannf@debian.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 19 Aug 2008 16:53:47 -0600
Message-ID: <20080819225346.28206.70559.stgit@tigger.helgaas>
In-Reply-To: <20080819225310.28206.1011.stgit@tigger.helgaas>
References: <20080819225310.28206.1011.stgit@tigger.helgaas>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


pnp_dbg() is equivalent to dev_dbg() except that we can turn it
on at boot-time with the "pnp.debug" kernel parameter, so we don't
have to build a new kernel image.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 drivers/pnp/core.c             |    2 +-
 drivers/pnp/isapnp/core.c      |   12 ++++++------
 drivers/pnp/manager.c          |   34 +++++++++++++++++-----------------
 drivers/pnp/pnpacpi/core.c     |    4 ++--
 drivers/pnp/pnpacpi/rsparser.c |   28 ++++++++++++++--------------
 drivers/pnp/pnpbios/core.c     |    4 ++--
 drivers/pnp/pnpbios/rsparser.c |   18 +++++++++---------
 drivers/pnp/quirks.c           |    2 +-
 drivers/pnp/resource.c         |   12 ++++++------
 drivers/pnp/support.c          |   10 +++++-----
 10 files changed, 63 insertions(+), 63 deletions(-)


diff --git a/drivers/pnp/core.c b/drivers/pnp/core.c
index 61291b5..5215615 100644
--- a/drivers/pnp/core.c
+++ b/drivers/pnp/core.c
@@ -200,7 +200,7 @@ int pnp_add_device(struct pnp_dev *dev)
 	for (id = dev->id; id; id = id->next)
 		len += scnprintf(buf + len, sizeof(buf) - len, " %s", id->id);
 
-	dev_dbg(&dev->dev, "%s device, IDs%s (%s)\n",
+	pnp_dbg(&dev->dev, "%s device, IDs%s (%s)\n",
 		dev->protocol->name, buf, dev->active ? "active" : "disabled");
 	return 0;
 }
diff --git a/drivers/pnp/isapnp/core.c b/drivers/pnp/isapnp/core.c
index 101a835..bd213ff 100644
--- a/drivers/pnp/isapnp/core.c
+++ b/drivers/pnp/isapnp/core.c
@@ -901,7 +901,7 @@ static int isapnp_get_resources(struct pnp_dev *dev)
 {
 	int i, ret;
 
-	dev_dbg(&dev->dev, "get resources\n");
+	pnp_dbg(&dev->dev, "get resources\n");
 	pnp_init_resources(dev);
 	isapnp_cfg_begin(dev->card->number, dev->number);
 	dev->active = isapnp_read_byte(ISAPNP_CFG_ACTIVATE);
@@ -939,13 +939,13 @@ static int isapnp_set_resources(struct pnp_dev *dev)
 	struct resource *res;
 	int tmp;
 
-	dev_dbg(&dev->dev, "set resources\n");
+	pnp_dbg(&dev->dev, "set resources\n");
 	isapnp_cfg_begin(dev->card->number, dev->number);
 	dev->active = 1;
 	for (tmp = 0; tmp < ISAPNP_MAX_PORT; tmp++) {
 		res = pnp_get_resource(dev, IORESOURCE_IO, tmp);
 		if (pnp_resource_enabled(res)) {
-			dev_dbg(&dev->dev, "  set io  %d to %#llx\n",
+			pnp_dbg(&dev->dev, "  set io  %d to %#llx\n",
 				tmp, (unsigned long long) res->start);
 			isapnp_write_word(ISAPNP_CFG_PORT + (tmp << 1),
 					  res->start);
@@ -957,14 +957,14 @@ static int isapnp_set_resources(struct pnp_dev *dev)
 			int irq = res->start;
 			if (irq == 2)
 				irq = 9;
-			dev_dbg(&dev->dev, "  set irq %d to %d\n", tmp, irq);
+			pnp_dbg(&dev->dev, "  set irq %d to %d\n", tmp, irq);
 			isapnp_write_byte(ISAPNP_CFG_IRQ + (tmp << 1), irq);
 		}
 	}
 	for (tmp = 0; tmp < ISAPNP_MAX_DMA; tmp++) {
 		res = pnp_get_resource(dev, IORESOURCE_DMA, tmp);
 		if (pnp_resource_enabled(res)) {
-			dev_dbg(&dev->dev, "  set dma %d to %lld\n",
+			pnp_dbg(&dev->dev, "  set dma %d to %lld\n",
 				tmp, (unsigned long long) res->start);
 			isapnp_write_byte(ISAPNP_CFG_DMA + tmp, res->start);
 		}
@@ -972,7 +972,7 @@ static int isapnp_set_resources(struct pnp_dev *dev)
 	for (tmp = 0; tmp < ISAPNP_MAX_MEM; tmp++) {
 		res = pnp_get_resource(dev, IORESOURCE_MEM, tmp);
 		if (pnp_resource_enabled(res)) {
-			dev_dbg(&dev->dev, "  set mem %d to %#llx\n",
+			pnp_dbg(&dev->dev, "  set mem %d to %#llx\n",
 				tmp, (unsigned long long) res->start);
 			isapnp_write_word(ISAPNP_CFG_MEM + (tmp << 3),
 					  (res->start >> 8) & 0xffff);
diff --git a/drivers/pnp/manager.c b/drivers/pnp/manager.c
index b526eaa..00fd357 100644
--- a/drivers/pnp/manager.c
+++ b/drivers/pnp/manager.c
@@ -25,7 +25,7 @@ static int pnp_assign_port(struct pnp_dev *dev, struct pnp_port *rule, int idx)
 
 	res = pnp_get_resource(dev, IORESOURCE_IO, idx);
 	if (res) {
-		dev_dbg(&dev->dev, "  io %d already set to %#llx-%#llx "
+		pnp_dbg(&dev->dev, "  io %d already set to %#llx-%#llx "
 			"flags %#lx\n", idx, (unsigned long long) res->start,
 			(unsigned long long) res->end, res->flags);
 		return 0;
@@ -38,7 +38,7 @@ static int pnp_assign_port(struct pnp_dev *dev, struct pnp_port *rule, int idx)
 
 	if (!rule->size) {
 		res->flags |= IORESOURCE_DISABLED;
-		dev_dbg(&dev->dev, "  io %d disabled\n", idx);
+		pnp_dbg(&dev->dev, "  io %d disabled\n", idx);
 		goto __add;
 	}
 
@@ -49,7 +49,7 @@ static int pnp_assign_port(struct pnp_dev *dev, struct pnp_port *rule, int idx)
 		res->start += rule->align;
 		res->end = res->start + rule->size - 1;
 		if (res->start > rule->max || !rule->align) {
-			dev_dbg(&dev->dev, "  couldn't assign io %d "
+			pnp_dbg(&dev->dev, "  couldn't assign io %d "
 				"(min %#llx max %#llx)\n", idx,
 				(unsigned long long) rule->min,
 				(unsigned long long) rule->max);
@@ -68,7 +68,7 @@ static int pnp_assign_mem(struct pnp_dev *dev, struct pnp_mem *rule, int idx)
 
 	res = pnp_get_resource(dev, IORESOURCE_MEM, idx);
 	if (res) {
-		dev_dbg(&dev->dev, "  mem %d already set to %#llx-%#llx "
+		pnp_dbg(&dev->dev, "  mem %d already set to %#llx-%#llx "
 			"flags %#lx\n", idx, (unsigned long long) res->start,
 			(unsigned long long) res->end, res->flags);
 		return 0;
@@ -90,7 +90,7 @@ static int pnp_assign_mem(struct pnp_dev *dev, struct pnp_mem *rule, int idx)
 
 	if (!rule->size) {
 		res->flags |= IORESOURCE_DISABLED;
-		dev_dbg(&dev->dev, "  mem %d disabled\n", idx);
+		pnp_dbg(&dev->dev, "  mem %d disabled\n", idx);
 		goto __add;
 	}
 
@@ -101,7 +101,7 @@ static int pnp_assign_mem(struct pnp_dev *dev, struct pnp_mem *rule, int idx)
 		res->start += rule->align;
 		res->end = res->start + rule->size - 1;
 		if (res->start > rule->max || !rule->align) {
-			dev_dbg(&dev->dev, "  couldn't assign mem %d "
+			pnp_dbg(&dev->dev, "  couldn't assign mem %d "
 				"(min %#llx max %#llx)\n", idx,
 				(unsigned long long) rule->min,
 				(unsigned long long) rule->max);
@@ -126,7 +126,7 @@ static int pnp_assign_irq(struct pnp_dev *dev, struct pnp_irq *rule, int idx)
 
 	res = pnp_get_resource(dev, IORESOURCE_IRQ, idx);
 	if (res) {
-		dev_dbg(&dev->dev, "  irq %d already set to %d flags %#lx\n",
+		pnp_dbg(&dev->dev, "  irq %d already set to %d flags %#lx\n",
 			idx, (int) res->start, res->flags);
 		return 0;
 	}
@@ -138,7 +138,7 @@ static int pnp_assign_irq(struct pnp_dev *dev, struct pnp_irq *rule, int idx)
 
 	if (bitmap_empty(rule->map.bits, PNP_IRQ_NR)) {
 		res->flags |= IORESOURCE_DISABLED;
-		dev_dbg(&dev->dev, "  irq %d disabled\n", idx);
+		pnp_dbg(&dev->dev, "  irq %d disabled\n", idx);
 		goto __add;
 	}
 
@@ -160,11 +160,11 @@ static int pnp_assign_irq(struct pnp_dev *dev, struct pnp_irq *rule, int idx)
 		res->start = -1;
 		res->end = -1;
 		res->flags |= IORESOURCE_DISABLED;
-		dev_dbg(&dev->dev, "  irq %d disabled (optional)\n", idx);
+		pnp_dbg(&dev->dev, "  irq %d disabled (optional)\n", idx);
 		goto __add;
 	}
 
-	dev_dbg(&dev->dev, "  couldn't assign irq %d\n", idx);
+	pnp_dbg(&dev->dev, "  couldn't assign irq %d\n", idx);
 	return -EBUSY;
 
 __add:
@@ -184,7 +184,7 @@ static int pnp_assign_dma(struct pnp_dev *dev, struct pnp_dma *rule, int idx)
 
 	res = pnp_get_resource(dev, IORESOURCE_DMA, idx);
 	if (res) {
-		dev_dbg(&dev->dev, "  dma %d already set to %d flags %#lx\n",
+		pnp_dbg(&dev->dev, "  dma %d already set to %d flags %#lx\n",
 			idx, (int) res->start, res->flags);
 		return 0;
 	}
@@ -205,7 +205,7 @@ static int pnp_assign_dma(struct pnp_dev *dev, struct pnp_dma *rule, int idx)
 	res->start = res->end = MAX_DMA_CHANNELS;
 #endif
 	res->flags |= IORESOURCE_DISABLED;
-	dev_dbg(&dev->dev, "  disable dma %d\n", idx);
+	pnp_dbg(&dev->dev, "  disable dma %d\n", idx);
 
 __add:
 	pnp_add_dma_resource(dev, res->start, res->flags);
@@ -238,7 +238,7 @@ static int pnp_assign_resources(struct pnp_dev *dev, int set)
 	int nport = 0, nmem = 0, nirq = 0, ndma = 0;
 	int ret = 0;
 
-	dev_dbg(&dev->dev, "pnp_assign_resources, try dependent set %d\n", set);
+	pnp_dbg(&dev->dev, "pnp_assign_resources, try dependent set %d\n", set);
 	mutex_lock(&pnp_res_mutex);
 	pnp_clean_resource_table(dev);
 
@@ -270,7 +270,7 @@ static int pnp_assign_resources(struct pnp_dev *dev, int set)
 
 	mutex_unlock(&pnp_res_mutex);
 	if (ret < 0) {
-		dev_dbg(&dev->dev, "pnp_assign_resources failed (%d)\n", ret);
+		pnp_dbg(&dev->dev, "pnp_assign_resources failed (%d)\n", ret);
 		pnp_clean_resource_table(dev);
 	} else
 		dbg_pnp_show_resources(dev, "pnp_assign_resources succeeded");
@@ -286,7 +286,7 @@ int pnp_auto_config_dev(struct pnp_dev *dev)
 	int i, ret;
 
 	if (!pnp_can_configure(dev)) {
-		dev_dbg(&dev->dev, "configuration not supported\n");
+		pnp_dbg(&dev->dev, "configuration not supported\n");
 		return -ENODEV;
 	}
 
@@ -313,7 +313,7 @@ int pnp_auto_config_dev(struct pnp_dev *dev)
 int pnp_start_dev(struct pnp_dev *dev)
 {
 	if (!pnp_can_write(dev)) {
-		dev_dbg(&dev->dev, "activation not supported\n");
+		pnp_dbg(&dev->dev, "activation not supported\n");
 		return -EINVAL;
 	}
 
@@ -336,7 +336,7 @@ int pnp_start_dev(struct pnp_dev *dev)
 int pnp_stop_dev(struct pnp_dev *dev)
 {
 	if (!pnp_can_disable(dev)) {
-		dev_dbg(&dev->dev, "disabling not supported\n");
+		pnp_dbg(&dev->dev, "disabling not supported\n");
 		return -EINVAL;
 	}
 	if (dev->protocol->disable(dev) < 0) {
diff --git a/drivers/pnp/pnpacpi/core.c b/drivers/pnp/pnpacpi/core.c
index 67c651b..b57d9d5 100644
--- a/drivers/pnp/pnpacpi/core.c
+++ b/drivers/pnp/pnpacpi/core.c
@@ -75,7 +75,7 @@ static int __init ispnpidacpi(char *id)
 
 static int pnpacpi_get_resources(struct pnp_dev *dev)
 {
-	dev_dbg(&dev->dev, "get resources\n");
+	pnp_dbg(&dev->dev, "get resources\n");
 	return pnpacpi_parse_allocated_resource(dev);
 }
 
@@ -86,7 +86,7 @@ static int pnpacpi_set_resources(struct pnp_dev *dev)
 	int ret;
 	acpi_status status;
 
-	dev_dbg(&dev->dev, "set resources\n");
+	pnp_dbg(&dev->dev, "set resources\n");
 	ret = pnpacpi_build_resource_template(dev, &buffer);
 	if (ret)
 		return ret;
diff --git a/drivers/pnp/pnpacpi/rsparser.c b/drivers/pnp/pnpacpi/rsparser.c
index 10a0d97..85baf16 100644
--- a/drivers/pnp/pnpacpi/rsparser.c
+++ b/drivers/pnp/pnpacpi/rsparser.c
@@ -452,7 +452,7 @@ int pnpacpi_parse_allocated_resource(struct pnp_dev *dev)
 	acpi_handle handle = dev->data;
 	acpi_status status;
 
-	dev_dbg(&dev->dev, "parse allocated resources\n");
+	pnp_dbg(&dev->dev, "parse allocated resources\n");
 
 	pnp_init_resources(dev);
 
@@ -738,7 +738,7 @@ int __init pnpacpi_parse_resource_option_data(struct pnp_dev *dev)
 	acpi_status status;
 	struct acpipnp_parse_option_s parse_data;
 
-	dev_dbg(&dev->dev, "parse resource options\n");
+	pnp_dbg(&dev->dev, "parse resource options\n");
 
 	parse_data.dev = dev;
 	parse_data.option_flags = 0;
@@ -846,7 +846,7 @@ static void pnpacpi_encode_irq(struct pnp_dev *dev,
 
 	if (!pnp_resource_enabled(p)) {
 		irq->interrupt_count = 0;
-		dev_dbg(&dev->dev, "  encode irq (%s)\n",
+		pnp_dbg(&dev->dev, "  encode irq (%s)\n",
 			p ? "disabled" : "missing");
 		return;
 	}
@@ -858,7 +858,7 @@ static void pnpacpi_encode_irq(struct pnp_dev *dev,
 	irq->interrupt_count = 1;
 	irq->interrupts[0] = p->start;
 
-	dev_dbg(&dev->dev, "  encode irq %d %s %s %s (%d-byte descriptor)\n",
+	pnp_dbg(&dev->dev, "  encode irq %d %s %s %s (%d-byte descriptor)\n",
 		(int) p->start,
 		triggering == ACPI_LEVEL_SENSITIVE ? "level" : "edge",
 		polarity == ACPI_ACTIVE_LOW ? "low" : "high",
@@ -875,7 +875,7 @@ static void pnpacpi_encode_ext_irq(struct pnp_dev *dev,
 
 	if (!pnp_resource_enabled(p)) {
 		extended_irq->interrupt_count = 0;
-		dev_dbg(&dev->dev, "  encode extended irq (%s)\n",
+		pnp_dbg(&dev->dev, "  encode extended irq (%s)\n",
 			p ? "disabled" : "missing");
 		return;
 	}
@@ -888,7 +888,7 @@ static void pnpacpi_encode_ext_irq(struct pnp_dev *dev,
 	extended_irq->interrupt_count = 1;
 	extended_irq->interrupts[0] = p->start;
 
-	dev_dbg(&dev->dev, "  encode irq %d %s %s %s\n", (int) p->start,
+	pnp_dbg(&dev->dev, "  encode irq %d %s %s %s\n", (int) p->start,
 		triggering == ACPI_LEVEL_SENSITIVE ? "level" : "edge",
 		polarity == ACPI_ACTIVE_LOW ? "low" : "high",
 		extended_irq->sharable == ACPI_SHARED ? "shared" : "exclusive");
@@ -902,7 +902,7 @@ static void pnpacpi_encode_dma(struct pnp_dev *dev,
 
 	if (!pnp_resource_enabled(p)) {
 		dma->channel_count = 0;
-		dev_dbg(&dev->dev, "  encode dma (%s)\n",
+		pnp_dbg(&dev->dev, "  encode dma (%s)\n",
 			p ? "disabled" : "missing");
 		return;
 	}
@@ -937,7 +937,7 @@ static void pnpacpi_encode_dma(struct pnp_dev *dev,
 	dma->channel_count = 1;
 	dma->channels[0] = p->start;
 
-	dev_dbg(&dev->dev, "  encode dma %d "
+	pnp_dbg(&dev->dev, "  encode dma %d "
 		"type %#x transfer %#x master %d\n",
 		(int) p->start, dma->type, dma->transfer, dma->bus_master);
 }
@@ -961,7 +961,7 @@ static void pnpacpi_encode_io(struct pnp_dev *dev,
 		io->address_length = 0;
 	}
 
-	dev_dbg(&dev->dev, "  encode io %#x-%#x decode %#x\n", io->minimum,
+	pnp_dbg(&dev->dev, "  encode io %#x-%#x decode %#x\n", io->minimum,
 		io->minimum + io->address_length - 1, io->io_decode);
 }
 
@@ -979,7 +979,7 @@ static void pnpacpi_encode_fixed_io(struct pnp_dev *dev,
 		fixed_io->address_length = 0;
 	}
 
-	dev_dbg(&dev->dev, "  encode fixed_io %#x-%#x\n", fixed_io->address,
+	pnp_dbg(&dev->dev, "  encode fixed_io %#x-%#x\n", fixed_io->address,
 		fixed_io->address + fixed_io->address_length - 1);
 }
 
@@ -1002,7 +1002,7 @@ static void pnpacpi_encode_mem24(struct pnp_dev *dev,
 		memory24->address_length = 0;
 	}
 
-	dev_dbg(&dev->dev, "  encode mem24 %#x-%#x write_protect %#x\n",
+	pnp_dbg(&dev->dev, "  encode mem24 %#x-%#x write_protect %#x\n",
 		memory24->minimum,
 		memory24->minimum + memory24->address_length - 1,
 		memory24->write_protect);
@@ -1026,7 +1026,7 @@ static void pnpacpi_encode_mem32(struct pnp_dev *dev,
 		memory32->alignment = 0;
 	}
 
-	dev_dbg(&dev->dev, "  encode mem32 %#x-%#x write_protect %#x\n",
+	pnp_dbg(&dev->dev, "  encode mem32 %#x-%#x write_protect %#x\n",
 		memory32->minimum,
 		memory32->minimum + memory32->address_length - 1,
 		memory32->write_protect);
@@ -1049,7 +1049,7 @@ static void pnpacpi_encode_fixed_mem32(struct pnp_dev *dev,
 		fixed_memory32->address_length = 0;
 	}
 
-	dev_dbg(&dev->dev, "  encode fixed_mem32 %#x-%#x write_protect %#x\n",
+	pnp_dbg(&dev->dev, "  encode fixed_mem32 %#x-%#x write_protect %#x\n",
 		fixed_memory32->address,
 		fixed_memory32->address + fixed_memory32->address_length - 1,
 		fixed_memory32->write_protect);
@@ -1063,7 +1063,7 @@ int pnpacpi_encode_resources(struct pnp_dev *dev, struct acpi_buffer *buffer)
 	struct acpi_resource *resource = buffer->pointer;
 	int port = 0, irq = 0, dma = 0, mem = 0;
 
-	dev_dbg(&dev->dev, "encode %d resources\n", res_cnt);
+	pnp_dbg(&dev->dev, "encode %d resources\n", res_cnt);
 	while (i < res_cnt) {
 		switch (resource->type) {
 		case ACPI_RESOURCE_TYPE_IRQ:
diff --git a/drivers/pnp/pnpbios/core.c b/drivers/pnp/pnpbios/core.c
index 19a4be1..2f79eb2 100644
--- a/drivers/pnp/pnpbios/core.c
+++ b/drivers/pnp/pnpbios/core.c
@@ -211,7 +211,7 @@ static int pnpbios_get_resources(struct pnp_dev *dev)
 	if (!pnpbios_is_dynamic(dev))
 		return -EPERM;
 
-	dev_dbg(&dev->dev, "get resources\n");
+	pnp_dbg(&dev->dev, "get resources\n");
 	node = kzalloc(node_info.max_node_size, GFP_KERNEL);
 	if (!node)
 		return -1;
@@ -234,7 +234,7 @@ static int pnpbios_set_resources(struct pnp_dev *dev)
 	if (!pnpbios_is_dynamic(dev))
 		return -EPERM;
 
-	dev_dbg(&dev->dev, "set resources\n");
+	pnp_dbg(&dev->dev, "set resources\n");
 	node = kzalloc(node_info.max_node_size, GFP_KERNEL);
 	if (!node)
 		return -1;
diff --git a/drivers/pnp/pnpbios/rsparser.c b/drivers/pnp/pnpbios/rsparser.c
index ca56767..87b4f49 100644
--- a/drivers/pnp/pnpbios/rsparser.c
+++ b/drivers/pnp/pnpbios/rsparser.c
@@ -87,7 +87,7 @@ static unsigned char *pnpbios_parse_allocated_resource_data(struct pnp_dev *dev,
 	if (!p)
 		return NULL;
 
-	dev_dbg(&dev->dev, "parse allocated resources\n");
+	pnp_dbg(&dev->dev, "parse allocated resources\n");
 
 	pnp_init_resources(dev);
 
@@ -324,7 +324,7 @@ pnpbios_parse_resource_option_data(unsigned char *p, unsigned char *end,
 	if (!p)
 		return NULL;
 
-	dev_dbg(&dev->dev, "parse resource options\n");
+	pnp_dbg(&dev->dev, "parse resource options\n");
 	option_flags = 0;
 	while ((char *)p < (char *)end) {
 
@@ -519,7 +519,7 @@ static void pnpbios_encode_mem(struct pnp_dev *dev, unsigned char *p,
 	p[10] = (len >> 8) & 0xff;
 	p[11] = ((len >> 8) >> 8) & 0xff;
 
-	dev_dbg(&dev->dev, "  encode mem %#lx-%#lx\n", base, base + len - 1);
+	pnp_dbg(&dev->dev, "  encode mem %#lx-%#lx\n", base, base + len - 1);
 }
 
 static void pnpbios_encode_mem32(struct pnp_dev *dev, unsigned char *p,
@@ -549,7 +549,7 @@ static void pnpbios_encode_mem32(struct pnp_dev *dev, unsigned char *p,
 	p[18] = (len >> 16) & 0xff;
 	p[19] = (len >> 24) & 0xff;
 
-	dev_dbg(&dev->dev, "  encode mem32 %#lx-%#lx\n", base, base + len - 1);
+	pnp_dbg(&dev->dev, "  encode mem32 %#lx-%#lx\n", base, base + len - 1);
 }
 
 static void pnpbios_encode_fixed_mem32(struct pnp_dev *dev, unsigned char *p,
@@ -575,7 +575,7 @@ static void pnpbios_encode_fixed_mem32(struct pnp_dev *dev, unsigned char *p,
 	p[10] = (len >> 16) & 0xff;
 	p[11] = (len >> 24) & 0xff;
 
-	dev_dbg(&dev->dev, "  encode fixed_mem32 %#lx-%#lx\n", base,
+	pnp_dbg(&dev->dev, "  encode fixed_mem32 %#lx-%#lx\n", base,
 		base + len - 1);
 }
 
@@ -592,7 +592,7 @@ static void pnpbios_encode_irq(struct pnp_dev *dev, unsigned char *p,
 	p[1] = map & 0xff;
 	p[2] = (map >> 8) & 0xff;
 
-	dev_dbg(&dev->dev, "  encode irq mask %#lx\n", map);
+	pnp_dbg(&dev->dev, "  encode irq mask %#lx\n", map);
 }
 
 static void pnpbios_encode_dma(struct pnp_dev *dev, unsigned char *p,
@@ -607,7 +607,7 @@ static void pnpbios_encode_dma(struct pnp_dev *dev, unsigned char *p,
 
 	p[1] = map & 0xff;
 
-	dev_dbg(&dev->dev, "  encode dma mask %#lx\n", map);
+	pnp_dbg(&dev->dev, "  encode dma mask %#lx\n", map);
 }
 
 static void pnpbios_encode_port(struct pnp_dev *dev, unsigned char *p,
@@ -630,7 +630,7 @@ static void pnpbios_encode_port(struct pnp_dev *dev, unsigned char *p,
 	p[5] = (base >> 8) & 0xff;
 	p[7] = len & 0xff;
 
-	dev_dbg(&dev->dev, "  encode io %#lx-%#lx\n", base, base + len - 1);
+	pnp_dbg(&dev->dev, "  encode io %#lx-%#lx\n", base, base + len - 1);
 }
 
 static void pnpbios_encode_fixed_port(struct pnp_dev *dev, unsigned char *p,
@@ -651,7 +651,7 @@ static void pnpbios_encode_fixed_port(struct pnp_dev *dev, unsigned char *p,
 	p[2] = (base >> 8) & 0xff;
 	p[3] = len & 0xff;
 
-	dev_dbg(&dev->dev, "  encode fixed_io %#lx-%#lx\n", base,
+	pnp_dbg(&dev->dev, "  encode fixed_io %#lx-%#lx\n", base,
 		base + len - 1);
 }
 
diff --git a/drivers/pnp/quirks.c b/drivers/pnp/quirks.c
index 414bb09..3d2e560 100644
--- a/drivers/pnp/quirks.c
+++ b/drivers/pnp/quirks.c
@@ -337,7 +337,7 @@ void pnp_fixup_device(struct pnp_dev *dev)
 	for (f = pnp_fixups; *f->id; f++) {
 		if (!compare_pnp_id(dev->id, f->id))
 			continue;
-		dev_dbg(&dev->dev, "%s: calling %pF\n", f->id,
+		pnp_dbg(&dev->dev, "%s: calling %pF\n", f->id,
 			f->quirk_function);
 		f->quirk_function(dev);
 	}
diff --git a/drivers/pnp/resource.c b/drivers/pnp/resource.c
index e0206da..5ef463d 100644
--- a/drivers/pnp/resource.c
+++ b/drivers/pnp/resource.c
@@ -294,7 +294,7 @@ static int pci_dev_uses_irq(struct pnp_dev *pnp, struct pci_dev *pci,
 	u8 progif;
 
 	if (pci->irq == irq) {
-		dev_dbg(&pnp->dev, "  device %s using irq %d\n",
+		pnp_dbg(&pnp->dev, "  device %s using irq %d\n",
 			pci_name(pci), irq);
 		return 1;
 	}
@@ -316,7 +316,7 @@ static int pci_dev_uses_irq(struct pnp_dev *pnp, struct pci_dev *pci,
 		if ((progif & 0x5) != 0x5)
 			if (pci_get_legacy_ide_irq(pci, 0) == irq ||
 			    pci_get_legacy_ide_irq(pci, 1) == irq) {
-				dev_dbg(&pnp->dev, "  legacy IDE device %s "
+				pnp_dbg(&pnp->dev, "  legacy IDE device %s "
 					"using irq %d\n", pci_name(pci), irq);
 				return 1;
 			}
@@ -517,7 +517,7 @@ struct pnp_resource *pnp_add_irq_resource(struct pnp_dev *dev, int irq,
 	res->start = irq;
 	res->end = irq;
 
-	dev_dbg(&dev->dev, "  add irq %d flags %#x\n", irq, flags);
+	pnp_dbg(&dev->dev, "  add irq %d flags %#x\n", irq, flags);
 	return pnp_res;
 }
 
@@ -538,7 +538,7 @@ struct pnp_resource *pnp_add_dma_resource(struct pnp_dev *dev, int dma,
 	res->start = dma;
 	res->end = dma;
 
-	dev_dbg(&dev->dev, "  add dma %d flags %#x\n", dma, flags);
+	pnp_dbg(&dev->dev, "  add dma %d flags %#x\n", dma, flags);
 	return pnp_res;
 }
 
@@ -562,7 +562,7 @@ struct pnp_resource *pnp_add_io_resource(struct pnp_dev *dev,
 	res->start = start;
 	res->end = end;
 
-	dev_dbg(&dev->dev, "  add io  %#llx-%#llx flags %#x\n",
+	pnp_dbg(&dev->dev, "  add io  %#llx-%#llx flags %#x\n",
 		(unsigned long long) start, (unsigned long long) end, flags);
 	return pnp_res;
 }
@@ -587,7 +587,7 @@ struct pnp_resource *pnp_add_mem_resource(struct pnp_dev *dev,
 	res->start = start;
 	res->end = end;
 
-	dev_dbg(&dev->dev, "  add mem %#llx-%#llx flags %#x\n",
+	pnp_dbg(&dev->dev, "  add mem %#llx-%#llx flags %#x\n",
 		(unsigned long long) start, (unsigned long long) end, flags);
 	return pnp_res;
 }
diff --git a/drivers/pnp/support.c b/drivers/pnp/support.c
index 7149186..63087d5 100644
--- a/drivers/pnp/support.c
+++ b/drivers/pnp/support.c
@@ -81,11 +81,11 @@ void dbg_pnp_show_resources(struct pnp_dev *dev, char *desc)
 	struct resource *res;
 
 	if (list_empty(&dev->resources)) {
-		dev_dbg(&dev->dev, "%s: no current resources\n", desc);
+		pnp_dbg(&dev->dev, "%s: no current resources\n", desc);
 		return;
 	}
 
-	dev_dbg(&dev->dev, "%s: current resources:\n", desc);
+	pnp_dbg(&dev->dev, "%s: current resources:\n", desc);
 	list_for_each_entry(pnp_res, &dev->resources, list) {
 		res = &pnp_res->res;
 		len = 0;
@@ -94,7 +94,7 @@ void dbg_pnp_show_resources(struct pnp_dev *dev, char *desc)
 				 pnp_resource_type_name(res));
 
 		if (res->flags & IORESOURCE_DISABLED) {
-			dev_dbg(&dev->dev, "%sdisabled\n", buf);
+			pnp_dbg(&dev->dev, "%sdisabled\n", buf);
 			continue;
 		}
 
@@ -115,7 +115,7 @@ void dbg_pnp_show_resources(struct pnp_dev *dev, char *desc)
 					 res->flags);
 			break;
 		}
-		dev_dbg(&dev->dev, "%s\n", buf);
+		pnp_dbg(&dev->dev, "%s\n", buf);
 	}
 }
 
@@ -205,5 +205,5 @@ void dbg_pnp_show_option(struct pnp_dev *dev, struct pnp_option *option)
 				 "flags %#x", dma->map, dma->flags);
 		break;
 	}
-	dev_dbg(&dev->dev, "%s\n", buf);
+	pnp_dbg(&dev->dev, "%s\n", buf);
 }


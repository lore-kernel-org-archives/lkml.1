Return-Path: <linux-kernel-owner+w=401wt.eu-S1761699AbZCaP0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761699AbZCaP0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 11:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762234AbZCaPXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 11:23:46 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:28568 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762332AbZCaPXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 11:23:44 -0400
Subject: [PATCH 07/15] PCI Hotplug: cpqphp: clean up cpqphp_ctrl.c
To: jbarnes@virtuousgeek.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 31 Mar 2009 09:23:41 -0600
Message-ID: <20090331152341.26622.15893.stgit@bob.kio>
In-Reply-To: <20090331150158.26622.45423.stgit@bob.kio>
References: <20090331150158.26622.45423.stgit@bob.kio>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Style and whitespace cleanups, no functional change.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/hotplug/cpqphp_ctrl.c |  170 +++++++++++++++++--------------------
 1 files changed, 79 insertions(+), 91 deletions(-)

diff --git a/drivers/pci/hotplug/cpqphp_ctrl.c b/drivers/pci/hotplug/cpqphp_ctrl.c
index b02b8dd..2fa47af 100644
--- a/drivers/pci/hotplug/cpqphp_ctrl.c
+++ b/drivers/pci/hotplug/cpqphp_ctrl.c
@@ -132,9 +132,8 @@ static struct slot *cpqhp_find_slot(struct controller *ctrl, u8 device)
 {
 	struct slot *slot = ctrl->slot;
 
-	while (slot && (slot->device != device)) {
+	while (slot && (slot->device != device))
 		slot = slot->next;
-	}
 
 	return slot;
 }
@@ -549,10 +548,10 @@ static struct pci_resource *get_io_resource(struct pci_resource **head, u32 size
 	if (!(*head))
 		return NULL;
 
-	if ( cpqhp_resource_sort_and_combine(head) )
+	if (cpqhp_resource_sort_and_combine(head))
 		return NULL;
 
-	if ( sort_by_size(head) )
+	if (sort_by_size(head))
 		return NULL;
 
 	for (node = *head; node; node = node->next) {
@@ -974,12 +973,8 @@ struct pci_func *cpqhp_slot_create(u8 busnumber)
 	struct pci_func *next;
 
 	new_slot = kzalloc(sizeof(*new_slot), GFP_KERNEL);
-	if (new_slot == NULL) {
-		/* I'm not dead yet!
-		 * You will be.
-		 */
+	if (new_slot == NULL)
 		return new_slot;
-	}
 
 	new_slot->next = NULL;
 	new_slot->configured = 1;
@@ -1010,10 +1005,8 @@ static int slot_remove(struct pci_func * old_slot)
 		return 1;
 
 	next = cpqhp_slot_list[old_slot->bus];
-
-	if (next == NULL) {
+	if (next == NULL)
 		return 1;
-	}
 
 	if (next == old_slot) {
 		cpqhp_slot_list[old_slot->bus] = old_slot->next;
@@ -1022,9 +1015,8 @@ static int slot_remove(struct pci_func * old_slot)
 		return 0;
 	}
 
-	while ((next->next != old_slot) && (next->next != NULL)) {
+	while ((next->next != old_slot) && (next->next != NULL))
 		next = next->next;
-	}
 
 	if (next->next == old_slot) {
 		next->next = old_slot->next;
@@ -1054,9 +1046,8 @@ static int bridge_slot_remove(struct pci_func *bridge)
 	for (tempBus = secondaryBus; tempBus <= subordinateBus; tempBus++) {
 		next = cpqhp_slot_list[tempBus];
 
-		while (!slot_remove(next)) {
+		while (!slot_remove(next))
 			next = cpqhp_slot_list[tempBus];
-		}
 	}
 
 	next = cpqhp_slot_list[bridge->bus];
@@ -1286,17 +1277,17 @@ static u32 board_replaced(struct pci_func *func, struct controller *ctrl)
 
 	hp_slot = func->device - ctrl->slot_device_offset;
 
-	if (readl(ctrl->hpc_reg + INT_INPUT_CLEAR) & (0x01L << hp_slot)) {
-		/*
-		 * The switch is open.
-		 */
+	/*
+	 * The switch is open.
+	 */
+	if (readl(ctrl->hpc_reg + INT_INPUT_CLEAR) & (0x01L << hp_slot))
 		rc = INTERLOCK_OPEN;
-	} else if (is_slot_enabled (ctrl, hp_slot)) {
-		/*
-		 * The board is already on
-		 */
+	/*
+	 * The board is already on
+	 */
+	else if (is_slot_enabled (ctrl, hp_slot))
 		rc = CARD_FUNCTIONING;
-	} else {
+	else {
 		mutex_lock(&ctrl->crit_sect);
 
 		/* turn on board without attaching to the bus */
@@ -1542,7 +1533,7 @@ static u32 board_added(struct pci_func *func, struct controller *ctrl)
 	}
 
 	/* All F's is an empty slot or an invalid board */
-	if (temp_register != 0xFFFFFFFF) {	  /* Check for a board in the slot */
+	if (temp_register != 0xFFFFFFFF) {
 		res_lists.io_head = ctrl->io_head;
 		res_lists.mem_head = ctrl->mem_head;
 		res_lists.p_mem_head = ctrl->p_mem_head;
@@ -1591,9 +1582,8 @@ static u32 board_added(struct pci_func *func, struct controller *ctrl)
 		index = 0;
 		do {
 			new_slot = cpqhp_slot_find(ctrl->bus, func->device, index++);
-			if (new_slot && !new_slot->pci_dev) {
+			if (new_slot && !new_slot->pci_dev)
 				cpqhp_configure_device(ctrl, new_slot);
-			}
 		} while (new_slot);
 
 		mutex_lock(&ctrl->crit_sect);
@@ -2134,9 +2124,8 @@ int cpqhp_process_SS(struct controller *ctrl, struct pci_func *func)
 
 				/* If the VGA Enable bit is set, remove isn't
 				 * supported */
-				if (BCR & PCI_BRIDGE_CTL_VGA) {
+				if (BCR & PCI_BRIDGE_CTL_VGA)
 					rc = REMOVE_NOT_SUPPORTED;
-				}
 			}
 		}
 
@@ -2204,67 +2193,67 @@ int cpqhp_hardware_test(struct controller *ctrl, int test_num)
 	num_of_slots = readb(ctrl->hpc_reg + SLOT_MASK) & 0x0f;
 
 	switch (test_num) {
-		case 1:
-			/* Do stuff here! */
-
-			/* Do that funky LED thing */
-			/* so we can restore them later */
-			save_LED = readl(ctrl->hpc_reg + LED_CONTROL);
-			work_LED = 0x01010101;
-			switch_leds(ctrl, num_of_slots, &work_LED, 0);
-			switch_leds(ctrl, num_of_slots, &work_LED, 1);
-			switch_leds(ctrl, num_of_slots, &work_LED, 0);
-			switch_leds(ctrl, num_of_slots, &work_LED, 1);
-
-			work_LED = 0x01010000;
-			writel(work_LED, ctrl->hpc_reg + LED_CONTROL);
-			switch_leds(ctrl, num_of_slots, &work_LED, 0);
-			switch_leds(ctrl, num_of_slots, &work_LED, 1);
-			work_LED = 0x00000101;
-			writel(work_LED, ctrl->hpc_reg + LED_CONTROL);
-			switch_leds(ctrl, num_of_slots, &work_LED, 0);
-			switch_leds(ctrl, num_of_slots, &work_LED, 1);
-
-			work_LED = 0x01010000;
-			writel(work_LED, ctrl->hpc_reg + LED_CONTROL);
-			for (loop = 0; loop < num_of_slots; loop++) {
-				set_SOGO(ctrl);
+	case 1:
+		/* Do stuff here! */
+
+		/* Do that funky LED thing */
+		/* so we can restore them later */
+		save_LED = readl(ctrl->hpc_reg + LED_CONTROL);
+		work_LED = 0x01010101;
+		switch_leds(ctrl, num_of_slots, &work_LED, 0);
+		switch_leds(ctrl, num_of_slots, &work_LED, 1);
+		switch_leds(ctrl, num_of_slots, &work_LED, 0);
+		switch_leds(ctrl, num_of_slots, &work_LED, 1);
+
+		work_LED = 0x01010000;
+		writel(work_LED, ctrl->hpc_reg + LED_CONTROL);
+		switch_leds(ctrl, num_of_slots, &work_LED, 0);
+		switch_leds(ctrl, num_of_slots, &work_LED, 1);
+		work_LED = 0x00000101;
+		writel(work_LED, ctrl->hpc_reg + LED_CONTROL);
+		switch_leds(ctrl, num_of_slots, &work_LED, 0);
+		switch_leds(ctrl, num_of_slots, &work_LED, 1);
+
+		work_LED = 0x01010000;
+		writel(work_LED, ctrl->hpc_reg + LED_CONTROL);
+		for (loop = 0; loop < num_of_slots; loop++) {
+			set_SOGO(ctrl);
 
-				/* Wait for SOGO interrupt */
-				wait_for_ctrl_irq (ctrl);
+			/* Wait for SOGO interrupt */
+			wait_for_ctrl_irq (ctrl);
 
-				/* Get ready for next iteration */
-				long_delay((3*HZ)/10);
-				work_LED = work_LED >> 16;
-				writel(work_LED, ctrl->hpc_reg + LED_CONTROL);
+			/* Get ready for next iteration */
+			long_delay((3*HZ)/10);
+			work_LED = work_LED >> 16;
+			writel(work_LED, ctrl->hpc_reg + LED_CONTROL);
 
-				set_SOGO(ctrl);
+			set_SOGO(ctrl);
 
-				/* Wait for SOGO interrupt */
-				wait_for_ctrl_irq (ctrl);
+			/* Wait for SOGO interrupt */
+			wait_for_ctrl_irq (ctrl);
 
-				/* Get ready for next iteration */
-				long_delay((3*HZ)/10);
-				work_LED = work_LED << 16;
-				writel(work_LED, ctrl->hpc_reg + LED_CONTROL);
-				work_LED = work_LED << 1;
-				writel(work_LED, ctrl->hpc_reg + LED_CONTROL);
-			}
+			/* Get ready for next iteration */
+			long_delay((3*HZ)/10);
+			work_LED = work_LED << 16;
+			writel(work_LED, ctrl->hpc_reg + LED_CONTROL);
+			work_LED = work_LED << 1;
+			writel(work_LED, ctrl->hpc_reg + LED_CONTROL);
+		}
 
-			/* put it back the way it was */
-			writel(save_LED, ctrl->hpc_reg + LED_CONTROL);
+		/* put it back the way it was */
+		writel(save_LED, ctrl->hpc_reg + LED_CONTROL);
 
-			set_SOGO(ctrl);
+		set_SOGO(ctrl);
 
-			/* Wait for SOBS to be unset */
-			wait_for_ctrl_irq (ctrl);
-			break;
-		case 2:
-			/* Do other stuff here! */
-			break;
-		case 3:
-			/* and more... */
-			break;
+		/* Wait for SOBS to be unset */
+		wait_for_ctrl_irq (ctrl);
+		break;
+	case 2:
+		/* Do other stuff here! */
+		break;
+	case 3:
+		/* and more... */
+		break;
 	}
 	return 0;
 }
@@ -2333,9 +2322,9 @@ static u32 configure_new_device(struct controller * ctrl, struct pci_func * func
 		while ((function < max_functions) && (!stop_it)) {
 			pci_bus_read_config_dword (ctrl->pci_bus, PCI_DEVFN(func->device, function), 0x00, &ID);
 
-			if (ID == 0xFFFFFFFF) {	  /* There's nothing there. */
+			if (ID == 0xFFFFFFFF) {
 				function++;
-			} else {  /* There's something there */
+			} else {
 				/* Setup slot structure. */
 				new_slot = cpqhp_slot_create(func->bus);
 
@@ -2360,8 +2349,8 @@ static u32 configure_new_device(struct controller * ctrl, struct pci_func * func
 
 
 /*
-  Configuration logic that involves the hotplug data structures and
-  their bookkeeping
+ * Configuration logic that involves the hotplug data structures and
+ * their bookkeeping
  */
 
 
@@ -2414,7 +2403,7 @@ static int configure_new_function(struct controller *ctrl, struct pci_func *func
 	if (rc)
 		return rc;
 
-	if ((temp_byte & 0x7F) == PCI_HEADER_TYPE_BRIDGE) { /* PCI-PCI Bridge */
+	if ((temp_byte & 0x7F) == PCI_HEADER_TYPE_BRIDGE) {
 		/* set Primary bus */
 		dbg("set Primary bus = %d\n", func->bus);
 		rc = pci_bus_write_config_byte(pci_bus, devfn, PCI_PRIMARY_BUS, func->bus);
@@ -2956,11 +2945,10 @@ static int configure_new_function(struct controller *ctrl, struct pci_func *func
 				/* Program IRQ based on card type */
 				rc = pci_bus_read_config_byte (pci_bus, devfn, 0x0B, &class_code);
 
-				if (class_code == PCI_BASE_CLASS_STORAGE) {
+				if (class_code == PCI_BASE_CLASS_STORAGE)
 					IRQ = cpqhp_disk_irq;
-				} else {
+				else
 					IRQ = cpqhp_nic_irq;
-				}
 			}
 
 			/* IRQ Line */


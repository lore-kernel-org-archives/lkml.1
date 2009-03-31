Return-Path: <linux-kernel-owner+w=401wt.eu-S1762416AbZCaPYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762416AbZCaPYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 11:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761961AbZCaPXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 11:23:23 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:14886 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762187AbZCaPXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 11:23:18 -0400
Subject: [PATCH 02/15] PCI Hotplug: cpqphp: fix comment style
To: jbarnes@virtuousgeek.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 31 Mar 2009 09:23:16 -0600
Message-ID: <20090331152316.26622.2468.stgit@bob.kio>
In-Reply-To: <20090331150158.26622.45423.stgit@bob.kio>
References: <20090331150158.26622.45423.stgit@bob.kio>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix up comments from C++ to C-style, wrapping if necessary, etc.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/hotplug/cpqphp.h       |   22 +--
 drivers/pci/hotplug/cpqphp_core.c  |  157 ++++++++++--------
 drivers/pci/hotplug/cpqphp_ctrl.c  |  131 +++++++++------
 drivers/pci/hotplug/cpqphp_nvram.c |   79 +++++----
 drivers/pci/hotplug/cpqphp_pci.c   |  313 ++++++++++++++++++++----------------
 5 files changed, 387 insertions(+), 315 deletions(-)

diff --git a/drivers/pci/hotplug/cpqphp.h b/drivers/pci/hotplug/cpqphp.h
index b627dfd..e15d657 100644
--- a/drivers/pci/hotplug/cpqphp.h
+++ b/drivers/pci/hotplug/cpqphp.h
@@ -190,7 +190,9 @@ struct hrt {
 	u32 reserved2;
 } __attribute__ ((packed));
 
-/* offsets to the hotplug resource table registers based on the above structure layout */
+/* offsets to the hotplug resource table registers based on the above
+ * structure layout
+ */
 enum hrt_offsets {
 	SIG0 =			offsetof(struct hrt, sig0),
 	SIG1 =			offsetof(struct hrt, sig1),
@@ -217,7 +219,9 @@ struct slot_rt {
 	u16 pre_mem_length;
 } __attribute__ ((packed));
 
-/* offsets to the hotplug slot resource table registers based on the above structure layout */
+/* offsets to the hotplug slot resource table registers based on the above
+ * structure layout
+ */
 enum slot_rt_offsets {
 	DEV_FUNC =		offsetof(struct slot_rt, dev_func),
 	PRIMARY_BUS =		offsetof(struct slot_rt, primary_bus),
@@ -286,8 +290,8 @@ struct event_info {
 struct controller {
 	struct controller *next;
 	u32 ctrl_int_comp;
-	struct mutex crit_sect;		/* critical section mutex */
-	void __iomem *hpc_reg;		/* cookie for our pci controller location */
+	struct mutex crit_sect;	/* critical section mutex */
+	void __iomem *hpc_reg;	/* cookie for our pci controller location */
 	struct pci_resource *mem_head;
 	struct pci_resource *p_mem_head;
 	struct pci_resource *io_head;
@@ -299,7 +303,7 @@ struct controller {
 	u8 next_event;
 	u8 interrupt;
 	u8 cfgspc_irq;
-	u8 bus;				/* bus number for the pci hotplug controller */
+	u8 bus;			/* bus number for the pci hotplug controller */
 	u8 rev;
 	u8 slot_device_offset;
 	u8 first_slot;
@@ -458,7 +462,6 @@ static inline char *slot_name(struct slot *slot)
  * return_resource
  *
  * Puts node back in the resource list pointed to by head
- *
  */
 static inline void return_resource(struct pci_resource **head, struct pci_resource *node)
 {
@@ -575,13 +578,12 @@ static inline u8 read_slot_enable(struct controller *ctrl)
 }
 
 
-/*
+/**
  * get_controller_speed - find the current frequency/mode of controller.
  *
  * @ctrl: controller to get frequency/mode for.
  *
  * Returns controller speed.
- *
  */
 static inline u8 get_controller_speed(struct controller *ctrl)
 {
@@ -607,14 +609,13 @@ static inline u8 get_controller_speed(struct controller *ctrl)
 }
 
 
-/*
+/**
  * get_adapter_speed - find the max supported frequency/mode of adapter.
  *
  * @ctrl: hotplug controller.
  * @hp_slot: hotplug slot where adapter is installed.
  *
  * Returns adapter speed.
- *
  */
 static inline u8 get_adapter_speed(struct controller *ctrl, u8 hp_slot)
 {
@@ -719,4 +720,3 @@ static inline int wait_for_ctrl_irq(struct controller *ctrl)
 }
 
 #endif
-
diff --git a/drivers/pci/hotplug/cpqphp_core.c b/drivers/pci/hotplug/cpqphp_core.c
index 55eae4c..91dc958 100644
--- a/drivers/pci/hotplug/cpqphp_core.c
+++ b/drivers/pci/hotplug/cpqphp_core.c
@@ -26,7 +26,6 @@
  *
  * Jan 12, 2003 -	Added 66/100/133MHz PCI-X support,
  *			Torben Mathiasen <torben.mathiasen@hp.com>
- *
  */
 
 #include <linux/module.h>
@@ -171,7 +170,7 @@ static int init_SERR(struct controller * ctrl)
 	tempdword = ctrl->first_slot;
 
 	number_of_slots = readb(ctrl->hpc_reg + SLOT_MASK) & 0x0F;
-	// Loop through slots
+	/* Loop through slots */
 	while (number_of_slots) {
 		physical_slot = tempdword;
 		writeb(0, ctrl->hpc_reg + SLOT_SERR);
@@ -200,7 +199,7 @@ static int pci_print_IRQ_route (void)
 
 	len = (routing_table->size - sizeof(struct irq_routing_table)) /
 			sizeof(struct irq_info);
-	// Make sure I got at least one entry
+	/* Make sure I got at least one entry */
 	if (len == 0) {
 		kfree(routing_table);
 		return -1;
@@ -244,7 +243,7 @@ static void __iomem *get_subsequent_smbios_entry(void __iomem *smbios_start,
 	if (!smbios_table || !curr)
 		return(NULL);
 
-	// set p_max to the end of the table
+	/* set p_max to the end of the table */
 	p_max = smbios_start + readw(smbios_table + ST_LENGTH);
 
 	p_temp = curr;
@@ -253,7 +252,8 @@ static void __iomem *get_subsequent_smbios_entry(void __iomem *smbios_start,
 	while ((p_temp < p_max) && !bail) {
 		/* Look for the double NULL terminator
 		 * The first condition is the previous byte
-		 * and the second is the curr */
+		 * and the second is the curr
+		 */
 		if (!previous_byte && !(readb(p_temp))) {
 			bail = 1;
 		}
@@ -387,8 +387,9 @@ static int ctrl_slot_setup(struct controller *ctrl,
 		slot->task_event.expires = jiffies + 5 * HZ;
 		slot->task_event.function = cpqhp_pushbutton_thread;
 
-		//FIXME: these capabilities aren't used but if they are
-		//       they need to be correctly implemented
+		/*FIXME: these capabilities aren't used but if they are
+		 *	 they need to be correctly implemented
+		 */
 		slot->capabilities |= PCISLOT_REPLACE_SUPPORTED;
 		slot->capabilities |= PCISLOT_INTERLOCK_SUPPORTED;
 
@@ -402,14 +403,14 @@ static int ctrl_slot_setup(struct controller *ctrl,
 		ctrl_slot =
 			slot_device - (readb(ctrl->hpc_reg + SLOT_MASK) >> 4);
 
-		// Check presence
+		/* Check presence */
 		slot->capabilities |=
 			((((~tempdword) >> 23) |
 			 ((~tempdword) >> 15)) >> ctrl_slot) & 0x02;
-		// Check the switch state
+		/* Check the switch state */
 		slot->capabilities |=
 			((~tempdword & 0xFF) >> ctrl_slot) & 0x01;
-		// Check the slot enable
+		/* Check the slot enable */
 		slot->capabilities |=
 			((read_slot_enable(ctrl) << 2) >> ctrl_slot) & 0x04;
 
@@ -476,11 +477,11 @@ static int ctrl_slot_cleanup (struct controller * ctrl)
 
 	cpqhp_remove_debugfs_files(ctrl);
 
-	//Free IRQ associated with hot plug device
+	/* Free IRQ associated with hot plug device */
 	free_irq(ctrl->interrupt, ctrl);
-	//Unmap the memory
+	/* Unmap the memory */
 	iounmap(ctrl->hpc_reg);
-	//Finally reclaim PCI mem
+	/* Finally reclaim PCI mem */
 	release_mem_region(pci_resource_start(ctrl->pci_dev, 0),
 			   pci_resource_len(ctrl->pci_dev, 0));
 
@@ -488,20 +489,17 @@ static int ctrl_slot_cleanup (struct controller * ctrl)
 }
 
 
-//============================================================================
-// function:	get_slot_mapping
-//
-// Description: Attempts to determine a logical slot mapping for a PCI
-//		device.  Won't work for more than one PCI-PCI bridge
-//		in a slot.
-//
-// Input:	u8 bus_num - bus number of PCI device
-//		u8 dev_num - device number of PCI device
-//		u8 *slot - Pointer to u8 where slot number will
-//			be returned
-//
-// Output:	SUCCESS or FAILURE
-//=============================================================================
+/**
+ * get_slot_mapping - determine logical slot mapping for PCI device
+ *
+ * Won't work for more than one PCI-PCI bridge in a slot.
+ *
+ * @bus_num - bus number of PCI device
+ * @dev_num - device number of PCI device
+ * @slot - Pointer to u8 where slot number will	be returned
+ *
+ * Output:	SUCCESS or FAILURE
+ */
 static int
 get_slot_mapping(struct pci_bus *bus, u8 bus_num, u8 dev_num, u8 *slot)
 {
@@ -522,7 +520,7 @@ get_slot_mapping(struct pci_bus *bus, u8 bus_num, u8 dev_num, u8 *slot)
 
 	len = (PCIIRQRoutingInfoLength->size -
 	       sizeof(struct irq_routing_table)) / sizeof(struct irq_info);
-	// Make sure I got at least one entry
+	/* Make sure I got at least one entry */
 	if (len == 0) {
 		kfree(PCIIRQRoutingInfoLength);
 		return -1;
@@ -539,13 +537,14 @@ get_slot_mapping(struct pci_bus *bus, u8 bus_num, u8 dev_num, u8 *slot)
 			return 0;
 		} else {
 			/* Did not get a match on the target PCI device. Check
-			 * if the current IRQ table entry is a PCI-to-PCI bridge
-			 * device.  If so, and it's secondary bus matches the
-			 * bus number for the target device, I need to save the
-			 * bridge's slot number.  If I can not find an entry for
-			 * the target device, I will have to assume it's on the
-			 * other side of the bridge, and assign it the bridge's
-			 * slot. */
+			 * if the current IRQ table entry is a PCI-to-PCI
+			 * bridge device.  If so, and it's secondary bus
+			 * matches the bus number for the target device, I need
+			 * to save the bridge's slot number.  If I can not find
+			 * an entry for the target device, I will have to
+			 * assume it's on the other side of the bridge, and
+			 * assign it the bridge's slot.
+			 */
 			bus->number = tbus;
 			pci_bus_read_config_dword(bus, PCI_DEVFN(tdevice, 0),
 						PCI_CLASS_REVISION, &work);
@@ -563,17 +562,18 @@ get_slot_mapping(struct pci_bus *bus, u8 bus_num, u8 dev_num, u8 *slot)
 
 	}
 
-	// If we got here, we didn't find an entry in the IRQ mapping table
-	// for the target PCI device.  If we did determine that the target
-	// device is on the other side of a PCI-to-PCI bridge, return the
-	// slot number for the bridge.
+	/* If we got here, we didn't find an entry in the IRQ mapping table for
+	 * the target PCI device.  If we did determine that the target device
+	 * is on the other side of a PCI-to-PCI bridge, return the slot number
+	 * for the bridge.
+	 */
 	if (bridgeSlot != 0xFF) {
 		*slot = bridgeSlot;
 		kfree(PCIIRQRoutingInfoLength);
 		return 0;
 	}
 	kfree(PCIIRQRoutingInfoLength);
-	// Couldn't find an entry in the routing table for this PCI device
+	/* Couldn't find an entry in the routing table for this PCI device */
 	return -1;
 }
 
@@ -595,7 +595,7 @@ cpqhp_set_attention_status(struct controller *ctrl, struct pci_func *func,
 
 	hp_slot = func->device - ctrl->slot_device_offset;
 
-	// Wait for exclusive access to hardware
+	/* Wait for exclusive access to hardware */
 	mutex_lock(&ctrl->crit_sect);
 
 	if (status == 1) {
@@ -603,17 +603,17 @@ cpqhp_set_attention_status(struct controller *ctrl, struct pci_func *func,
 	} else if (status == 0) {
 		amber_LED_off (ctrl, hp_slot);
 	} else {
-		// Done with exclusive hardware access
+		/* Done with exclusive hardware access */
 		mutex_unlock(&ctrl->crit_sect);
 		return(1);
 	}
 
 	set_SOGO(ctrl);
 
-	// Wait for SOBS to be unset
+	/* Wait for SOBS to be unset */
 	wait_for_ctrl_irq (ctrl);
 
-	// Done with exclusive hardware access
+	/* Done with exclusive hardware access */
 	mutex_unlock(&ctrl->crit_sect);
 
 	return(0);
@@ -815,7 +815,9 @@ static int cpqhpc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		return err;
 	}
 
-	// Need to read VID early b/c it's used to differentiate CPQ and INTC discovery
+	/* Need to read VID early b/c it's used to differentiate CPQ and INTC
+	 * discovery
+	 */
 	rc = pci_read_config_word(pdev, PCI_VENDOR_ID, &vendor_id);
 	if (rc || ((vendor_id != PCI_VENDOR_ID_COMPAQ) && (vendor_id != PCI_VENDOR_ID_INTEL))) {
 		err(msg_HPC_non_compaq_or_intel);
@@ -837,7 +839,9 @@ static int cpqhpc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * Also Intel HPC's may have RID=0.
 	 */
 	if ((pdev->revision > 2) || (vendor_id == PCI_VENDOR_ID_INTEL)) {
-		// TODO: This code can be made to support non-Compaq or Intel subsystem IDs
+		/* TODO: This code can be made to support non-Compaq or Intel
+		 * subsystem IDs
+		 */
 		rc = pci_read_config_word(pdev, PCI_SUBSYSTEM_VENDOR_ID, &subsystem_vid);
 		if (rc) {
 			err("%s : pci_read_config_word failed\n", __func__);
@@ -865,7 +869,9 @@ static int cpqhpc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 		info("Hot Plug Subsystem Device ID: %x\n", subsystem_deviceid);
 
-		/* Set Vendor ID, so it can be accessed later from other functions */
+		/* Set Vendor ID, so it can be accessed later from other
+		 * functions
+		 */
 		ctrl->vendor_id = vendor_id;
 
 		switch (subsystem_vid) {
@@ -992,23 +998,23 @@ static int cpqhpc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 				/* PHP Status (0=De-feature PHP, 1=Normal operation) */
 				if (subsystem_deviceid & 0x0008) {
-					ctrl->defeature_PHP = 1;	// PHP supported
+					ctrl->defeature_PHP = 1;	/* PHP supported */
 				} else {
-					ctrl->defeature_PHP = 0;	// PHP not supported
+					ctrl->defeature_PHP = 0;	/* PHP not supported */
 				}
 
 				/* Alternate Base Address Register Interface (0=not supported, 1=supported) */
 				if (subsystem_deviceid & 0x0010) {
-					ctrl->alternate_base_address = 1;	// supported
+					ctrl->alternate_base_address = 1;	/* supported */
 				} else {
-					ctrl->alternate_base_address = 0;	// not supported
+					ctrl->alternate_base_address = 0;	/* not supported */
 				}
 
 				/* PCI Config Space Index (0=not supported, 1=supported) */
 				if (subsystem_deviceid & 0x0020) {
-					ctrl->pci_config_space = 1;		// supported
+					ctrl->pci_config_space = 1;		/* supported */
 				} else {
-					ctrl->pci_config_space = 0;		// not supported
+					ctrl->pci_config_space = 0;		/* not supported */
 				}
 
 				/* PCI-X support */
@@ -1042,7 +1048,7 @@ static int cpqhpc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		return -ENODEV;
 	}
 
-	// Tell the user that we found one.
+	/* Tell the user that we found one. */
 	info("Initializing the PCI hot plug controller residing on PCI bus %d\n",
 					pdev->bus->number);
 
@@ -1120,7 +1126,7 @@ static int cpqhpc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 *
 	 ********************************************************/
 
-	// find the physical slot number of the first hot plug slot
+	/* find the physical slot number of the first hot plug slot */
 
 	/* Get slot won't work for devices behind bridges, but
 	 * in this case it will always be called for the "base"
@@ -1137,7 +1143,7 @@ static int cpqhpc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_iounmap;
 	}
 
-	// Store PCI Config Space for all devices on this bus
+	/* Store PCI Config Space for all devices on this bus */
 	rc = cpqhp_save_config(ctrl, ctrl->bus, readb(ctrl->hpc_reg + SLOT_MASK));
 	if (rc) {
 		err("%s: unable to save PCI configuration data, error %d\n",
@@ -1148,7 +1154,7 @@ static int cpqhpc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/*
 	 * Get IO, memory, and IRQ resources for new devices
 	 */
-	// The next line is required for cpqhp_find_available_resources
+	/* The next line is required for cpqhp_find_available_resources */
 	ctrl->interrupt = pdev->irq;
 	if (ctrl->interrupt < 0x10) {
 		cpqhp_legacy_mode = 1;
@@ -1196,12 +1202,14 @@ static int cpqhpc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_iounmap;
 	}
 
-	/* Enable Shift Out interrupt and clear it, also enable SERR on power fault */
+	/* Enable Shift Out interrupt and clear it, also enable SERR on power
+	 * fault
+	 */
 	temp_word = readw(ctrl->hpc_reg + MISC);
 	temp_word |= 0x4006;
 	writew(temp_word, ctrl->hpc_reg + MISC);
 
-	// Changed 05/05/97 to clear all interrupts at start
+	/* Changed 05/05/97 to clear all interrupts at start */
 	writel(0xFFFFFFFFL, ctrl->hpc_reg + INT_INPUT_CLEAR);
 
 	ctrl->ctrl_int_comp = readl(ctrl->hpc_reg + INT_INPUT_CLEAR);
@@ -1216,13 +1224,14 @@ static int cpqhpc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		cpqhp_ctrl_list = ctrl;
 	}
 
-	// turn off empty slots here unless command line option "ON" set
-	// Wait for exclusive access to hardware
+	/* turn off empty slots here unless command line option "ON" set
+	 * Wait for exclusive access to hardware
+	 */
 	mutex_lock(&ctrl->crit_sect);
 
 	num_of_slots = readb(ctrl->hpc_reg + SLOT_MASK) & 0x0F;
 
-	// find first device number for the ctrl
+	/* find first device number for the ctrl */
 	device = readb(ctrl->hpc_reg + SLOT_MASK) >> 4;
 
 	while (num_of_slots) {
@@ -1234,7 +1243,7 @@ static int cpqhpc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		hp_slot = func->device - ctrl->slot_device_offset;
 		dbg("hp_slot: %d\n", hp_slot);
 
-		// We have to save the presence info for these slots
+		/* We have to save the presence info for these slots */
 		temp_word = ctrl->ctrl_int_comp >> 16;
 		func->presence_save = (temp_word >> hp_slot) & 0x01;
 		func->presence_save |= (temp_word >> (hp_slot + 7)) & 0x02;
@@ -1258,7 +1267,7 @@ static int cpqhpc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	if (!power_mode) {
 		set_SOGO(ctrl);
-		// Wait for SOBS to be unset
+		/* Wait for SOBS to be unset */
 		wait_for_ctrl_irq(ctrl);
 	}
 
@@ -1269,7 +1278,7 @@ static int cpqhpc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_free_irq;
 	}
 
-	// Done with exclusive hardware access
+	/* Done with exclusive hardware access */
 	mutex_unlock(&ctrl->crit_sect);
 
 	cpqhp_create_debugfs_files(ctrl);
@@ -1316,11 +1325,11 @@ static int one_time_init(void)
 		cpqhp_slot_list[loop] = NULL;
 	}
 
-	// FIXME: We also need to hook the NMI handler eventually.
-	// this also needs to be worked with Christoph
-	// register_NMI_handler();
-
-	// Map rom address
+	/* FIXME: We also need to hook the NMI handler eventually.
+	 * this also needs to be worked with Christoph
+	 * register_NMI_handler();
+	 */
+	/* Map rom address */
 	cpqhp_rom_start = ioremap(ROM_PHY_ADDR, ROM_PHY_LEN);
 	if (!cpqhp_rom_start) {
 		err ("Could not ioremap memory region for ROM\n");
@@ -1328,7 +1337,9 @@ static int one_time_init(void)
 		goto error;
 	}
 
-	/* Now, map the int15 entry point if we are on compaq specific hardware */
+	/* Now, map the int15 entry point if we are on compaq specific
+	 * hardware
+	 */
 	compaq_nvram_init(cpqhp_rom_start);
 
 	/* Map smbios table entry point structure */
@@ -1462,11 +1473,11 @@ static void __exit unload_cpqphpd(void)
 		}
 	}
 
-	// Stop the notification mechanism
+	/* Stop the notification mechanism */
 	if (initialized)
 		cpqhp_event_stop_thread();
 
-	//unmap the rom address
+	/* unmap the rom address */
 	if (cpqhp_rom_start)
 		iounmap(cpqhp_rom_start);
 	if (smbios_start)
diff --git a/drivers/pci/hotplug/cpqphp_ctrl.c b/drivers/pci/hotplug/cpqphp_ctrl.c
index ec3a765..b02b8dd 100644
--- a/drivers/pci/hotplug/cpqphp_ctrl.c
+++ b/drivers/pci/hotplug/cpqphp_ctrl.c
@@ -81,14 +81,15 @@ static u8 handle_switch_change(u8 change, struct controller * ctrl)
 
 	for (hp_slot = 0; hp_slot < 6; hp_slot++) {
 		if (change & (0x1L << hp_slot)) {
-			/**********************************
+			/*
 			 * this one changed.
-			 **********************************/
+			 */
 			func = cpqhp_slot_find(ctrl->bus,
 				(hp_slot + ctrl->slot_device_offset), 0);
 
 			/* this is the structure that tells the worker thread
-			 *what to do */
+			 * what to do
+			 */
 			taskInfo = &(ctrl->event_queue[ctrl->next_event]);
 			ctrl->next_event = (ctrl->next_event + 1) % 10;
 			taskInfo->hp_slot = hp_slot;
@@ -100,17 +101,17 @@ static u8 handle_switch_change(u8 change, struct controller * ctrl)
 			func->presence_save |= (temp_word >> (hp_slot + 7)) & 0x02;
 
 			if (ctrl->ctrl_int_comp & (0x1L << hp_slot)) {
-				/**********************************
+				/*
 				 * Switch opened
-				 **********************************/
+				 */
 
 				func->switch_save = 0;
 
 				taskInfo->event_type = INT_SWITCH_OPEN;
 			} else {
-				/**********************************
+				/*
 				 * Switch closed
-				 **********************************/
+				 */
 
 				func->switch_save = 0x10;
 
@@ -152,17 +153,17 @@ static u8 handle_presence_change(u16 change, struct controller * ctrl)
 	if (!change)
 		return 0;
 
-	/**********************************
+	/*
 	 * Presence Change
-	 **********************************/
+	 */
 	dbg("cpqsbd:  Presence/Notify input change.\n");
 	dbg("         Changed bits are 0x%4.4x\n", change );
 
 	for (hp_slot = 0; hp_slot < 6; hp_slot++) {
 		if (change & (0x0101 << hp_slot)) {
-			/**********************************
+			/*
 			 * this one changed.
-			 **********************************/
+			 */
 			func = cpqhp_slot_find(ctrl->bus,
 				(hp_slot + ctrl->slot_device_offset), 0);
 
@@ -177,22 +178,23 @@ static u8 handle_presence_change(u16 change, struct controller * ctrl)
 				return 0;
 
 			/* If the switch closed, must be a button
-			 * If not in button mode, nevermind */
+			 * If not in button mode, nevermind
+			 */
 			if (func->switch_save && (ctrl->push_button == 1)) {
 				temp_word = ctrl->ctrl_int_comp >> 16;
 				temp_byte = (temp_word >> hp_slot) & 0x01;
 				temp_byte |= (temp_word >> (hp_slot + 7)) & 0x02;
 
 				if (temp_byte != func->presence_save) {
-					/**************************************
+					/*
 					 * button Pressed (doesn't do anything)
-					 **************************************/
+					 */
 					dbg("hp_slot %d button pressed\n", hp_slot);
 					taskInfo->event_type = INT_BUTTON_PRESS;
 				} else {
-					/**********************************
+					/*
 					 * button Released - TAKE ACTION!!!!
-					 **********************************/
+					 */
 					dbg("hp_slot %d button released\n", hp_slot);
 					taskInfo->event_type = INT_BUTTON_RELEASE;
 
@@ -210,7 +212,8 @@ static u8 handle_presence_change(u16 change, struct controller * ctrl)
 				}
 			} else {
 				/* Switch is open, assume a presence change
-				 * Save the presence state */
+				 * Save the presence state
+				 */
 				temp_word = ctrl->ctrl_int_comp >> 16;
 				func->presence_save = (temp_word >> hp_slot) & 0x01;
 				func->presence_save |= (temp_word >> (hp_slot + 7)) & 0x02;
@@ -241,17 +244,17 @@ static u8 handle_power_fault(u8 change, struct controller * ctrl)
 	if (!change)
 		return 0;
 
-	/**********************************
+	/*
 	 * power fault
-	 **********************************/
+	 */
 
 	info("power fault interrupt\n");
 
 	for (hp_slot = 0; hp_slot < 6; hp_slot++) {
 		if (change & (0x01 << hp_slot)) {
-			/**********************************
+			/*
 			 * this one changed.
-			 **********************************/
+			 */
 			func = cpqhp_slot_find(ctrl->bus,
 				(hp_slot + ctrl->slot_device_offset), 0);
 
@@ -262,16 +265,16 @@ static u8 handle_power_fault(u8 change, struct controller * ctrl)
 			rc++;
 
 			if (ctrl->ctrl_int_comp & (0x00000100 << hp_slot)) {
-				/**********************************
+				/*
 				 * power fault Cleared
-				 **********************************/
+				 */
 				func->status = 0x00;
 
 				taskInfo->event_type = INT_POWER_FAULT_CLEAR;
 			} else {
-				/**********************************
+				/*
 				 * power fault
-				 **********************************/
+				 */
 				taskInfo->event_type = INT_POWER_FAULT;
 
 				if (ctrl->rev < 4) {
@@ -432,13 +435,15 @@ static struct pci_resource *do_pre_bridge_resource_split(struct pci_resource **h
 
 
 	/* If we got here, there the bridge requires some of the resource, but
-	 * we may be able to split some off of the front */
+	 * we may be able to split some off of the front
+	 */
 
 	node = *head;
 
 	if (node->length & (alignment -1)) {
 		/* this one isn't an aligned length, so we'll make a new entry
-		 * and split it up. */
+		 * and split it up.
+		 */
 		split_node = kmalloc(sizeof(*split_node), GFP_KERNEL);
 
 		if (!split_node)
@@ -556,7 +561,8 @@ static struct pci_resource *get_io_resource(struct pci_resource **head, u32 size
 
 		if (node->base & (size - 1)) {
 			/* this one isn't base aligned properly
-			 * so we'll make a new entry and split it up */
+			 * so we'll make a new entry and split it up
+			 */
 			temp_dword = (node->base | (size-1)) + 1;
 
 			/* Short circuit if adjusted size is too small */
@@ -581,7 +587,8 @@ static struct pci_resource *get_io_resource(struct pci_resource **head, u32 size
 		/* Don't need to check if too small since we already did */
 		if (node->length > size) {
 			/* this one is longer than we need
-			 * so we'll make a new entry and split it up */
+			 * so we'll make a new entry and split it up
+			 */
 			split_node = kmalloc(sizeof(*split_node), GFP_KERNEL);
 
 			if (!split_node)
@@ -601,7 +608,8 @@ static struct pci_resource *get_io_resource(struct pci_resource **head, u32 size
 			continue;
 
 		/* If we got here, then it is the right size
-		 * Now take it out of the list and break */
+		 * Now take it out of the list and break
+		 */
 		if (*head == node) {
 			*head = node->next;
 		} else {
@@ -643,13 +651,15 @@ static struct pci_resource *get_max_resource(struct pci_resource **head, u32 siz
 
 	for (max = *head; max; max = max->next) {
 		/* If not big enough we could probably just bail,
-		 * instead we'll continue to the next. */
+		 * instead we'll continue to the next.
+		 */
 		if (max->length < size)
 			continue;
 
 		if (max->base & (size - 1)) {
 			/* this one isn't base aligned properly
-			 * so we'll make a new entry and split it up */
+			 * so we'll make a new entry and split it up
+			 */
 			temp_dword = (max->base | (size-1)) + 1;
 
 			/* Short circuit if adjusted size is too small */
@@ -672,7 +682,8 @@ static struct pci_resource *get_max_resource(struct pci_resource **head, u32 siz
 
 		if ((max->base + max->length) & (size - 1)) {
 			/* this one isn't end aligned properly at the top
-			 * so we'll make a new entry and split it up */
+			 * so we'll make a new entry and split it up
+			 */
 			split_node = kmalloc(sizeof(*split_node), GFP_KERNEL);
 
 			if (!split_node)
@@ -744,7 +755,8 @@ static struct pci_resource *get_resource(struct pci_resource **head, u32 size)
 		if (node->base & (size - 1)) {
 			dbg("%s: not aligned\n", __func__);
 			/* this one isn't base aligned properly
-			 * so we'll make a new entry and split it up */
+			 * so we'll make a new entry and split it up
+			 */
 			temp_dword = (node->base | (size-1)) + 1;
 
 			/* Short circuit if adjusted size is too small */
@@ -769,7 +781,8 @@ static struct pci_resource *get_resource(struct pci_resource **head, u32 size)
 		if (node->length > size) {
 			dbg("%s: too big\n", __func__);
 			/* this one is longer than we need
-			 * so we'll make a new entry and split it up */
+			 * so we'll make a new entry and split it up
+			 */
 			split_node = kmalloc(sizeof(*split_node), GFP_KERNEL);
 
 			if (!split_node)
@@ -888,17 +901,17 @@ irqreturn_t cpqhp_ctrl_intr(int IRQ, void *data)
 
 
 	misc = readw(ctrl->hpc_reg + MISC);
-	/***************************************
+	/*
 	 * Check to see if it was our interrupt
-	 ***************************************/
+	 */
 	if (!(misc & 0x000C)) {
 		return IRQ_NONE;
 	}
 
 	if (misc & 0x0004) {
-		/**********************************
+		/*
 		 * Serial Output interrupt Pending
-		 **********************************/
+		 */
 
 		/* Clear the interrupt */
 		misc |= 0x0004;
@@ -963,7 +976,8 @@ struct pci_func *cpqhp_slot_create(u8 busnumber)
 	new_slot = kzalloc(sizeof(*new_slot), GFP_KERNEL);
 	if (new_slot == NULL) {
 		/* I'm not dead yet!
-		 * You will be. */
+		 * You will be.
+		 */
 		return new_slot;
 	}
 
@@ -1135,7 +1149,8 @@ static u8 set_controller_speed(struct controller *ctrl, u8 adapter_speed, u8 hp_
 		return 0;
 
 	/* We don't allow freq/mode changes if we find another adapter running
-	 * in another slot on this controller */
+	 * in another slot on this controller
+	 */
 	for(slot = ctrl->slot; slot; slot = slot->next) {
 		if (slot->device == (hp_slot + ctrl->slot_device_offset))
 			continue;
@@ -1145,7 +1160,8 @@ static u8 set_controller_speed(struct controller *ctrl, u8 adapter_speed, u8 hp_
 			continue;
 		/* If another adapter is running on the same segment but at a
 		 * lower speed/mode, we allow the new adapter to function at
-		 * this rate if supported */
+		 * this rate if supported
+		 */
 		if (ctrl->speed < adapter_speed)
 			return 0;
 
@@ -1153,7 +1169,8 @@ static u8 set_controller_speed(struct controller *ctrl, u8 adapter_speed, u8 hp_
 	}
 
 	/* If the controller doesn't support freq/mode changes and the
-	 * controller is running at a higher mode, we bail */
+	 * controller is running at a higher mode, we bail
+	 */
 	if ((ctrl->speed > adapter_speed) && (!ctrl->pcix_speed_capability))
 		return 1;
 
@@ -1162,7 +1179,8 @@ static u8 set_controller_speed(struct controller *ctrl, u8 adapter_speed, u8 hp_
 		return 0;
 
 	/* We try to set the max speed supported by both the adapter and
-	 * controller */
+	 * controller
+	 */
 	if (ctrl->speed_capability < adapter_speed) {
 		if (ctrl->speed == ctrl->speed_capability)
 			return 0;
@@ -1244,7 +1262,7 @@ static u8 set_controller_speed(struct controller *ctrl, u8 adapter_speed, u8 hp_
 }
 
 /* the following routines constitute the bulk of the
-   hotplug controller logic
+ * hotplug controller logic
  */
 
 
@@ -1269,14 +1287,14 @@ static u32 board_replaced(struct pci_func *func, struct controller *ctrl)
 	hp_slot = func->device - ctrl->slot_device_offset;
 
 	if (readl(ctrl->hpc_reg + INT_INPUT_CLEAR) & (0x01L << hp_slot)) {
-		/**********************************
+		/*
 		 * The switch is open.
-		 **********************************/
+		 */
 		rc = INTERLOCK_OPEN;
 	} else if (is_slot_enabled (ctrl, hp_slot)) {
-		/**********************************
+		/*
 		 * The board is already on
-		 **********************************/
+		 */
 		rc = CARD_FUNCTIONING;
 	} else {
 		mutex_lock(&ctrl->crit_sect);
@@ -1352,7 +1370,8 @@ static u32 board_replaced(struct pci_func *func, struct controller *ctrl)
 			 * Get slot won't work for devices behind
 			 * bridges, but in this case it will always be
 			 * called for the "base" bus/dev/func of an
-			 * adapter. */
+			 * adapter.
+			 */
 
 			mutex_lock(&ctrl->crit_sect);
 
@@ -1377,7 +1396,8 @@ static u32 board_replaced(struct pci_func *func, struct controller *ctrl)
 
 			 * Get slot won't work for devices behind bridges, but
 			 * in this case it will always be called for the "base"
-			 * bus/dev/func of an adapter. */
+			 * bus/dev/func of an adapter.
+			 */
 
 			mutex_lock(&ctrl->crit_sect);
 
@@ -1434,7 +1454,8 @@ static u32 board_added(struct pci_func *func, struct controller *ctrl)
 	wait_for_ctrl_irq (ctrl);
 
 	/* Change bits in slot power register to force another shift out
-	 * NOTE: this is to work around the timer bug */
+	 * NOTE: this is to work around the timer bug
+	 */
 	temp_byte = readb(ctrl->hpc_reg + SLOT_POWER);
 	writeb(0x00, ctrl->hpc_reg + SLOT_POWER);
 	writeb(temp_byte, ctrl->hpc_reg + SLOT_POWER);
@@ -2484,7 +2505,8 @@ static int configure_new_function(struct controller *ctrl, struct pci_func *func
 		temp_resources.irqs = &irqs;
 
 		/* Make copies of the nodes we are going to pass down so that
-		 * if there is a problem,we can just use these to free resources */
+		 * if there is a problem,we can just use these to free resources
+		 */
 		hold_bus_node = kmalloc(sizeof(*hold_bus_node), GFP_KERNEL);
 		hold_IO_node = kmalloc(sizeof(*hold_IO_node), GFP_KERNEL);
 		hold_mem_node = kmalloc(sizeof(*hold_mem_node), GFP_KERNEL);
@@ -2556,7 +2578,8 @@ static int configure_new_function(struct controller *ctrl, struct pci_func *func
 		temp_word = (p_mem_node->base + p_mem_node->length - 1) >> 16;
 		rc = pci_bus_write_config_word (pci_bus, devfn, PCI_PREF_MEMORY_LIMIT, temp_word);
 
-		/* Adjust this to compensate for extra adjustment in first loop */
+		/* Adjust this to compensate for extra adjustment in first loop
+		 */
 		irqs.barber_pole--;
 
 		rc = 0;
diff --git a/drivers/pci/hotplug/cpqphp_nvram.c b/drivers/pci/hotplug/cpqphp_nvram.c
index 76e110f..76ba8a1 100644
--- a/drivers/pci/hotplug/cpqphp_nvram.c
+++ b/drivers/pci/hotplug/cpqphp_nvram.c
@@ -94,12 +94,13 @@ static u8 evbuffer[1024];
 
 static void __iomem *compaq_int15_entry_point;
 
-static spinlock_t int15_lock;		/* lock for ordering int15_bios_call() */
+/* lock for ordering int15_bios_call() */
+static spinlock_t int15_lock;
 
 
 /* This is a series of function that deals with
-   setting & getting the hotplug resource table in some environment variable.
-*/
+ * setting & getting the hotplug resource table in some environment variable.
+ */
 
 /*
  * We really shouldn't be doing this unless there is a _very_ good reason to!!!
@@ -210,14 +211,16 @@ static int load_HRT (void __iomem *rom_start)
 
 	available = 1024;
 
-	// Now load the EV
+	/* Now load the EV */
 	temp_dword = available;
 
 	rc = access_EV(READ_EV, "CQTHPS", evbuffer, &temp_dword);
 
 	evbuffer_length = temp_dword;
 
-	// We're maintaining the resource lists so write FF to invalidate old info
+	/* We're maintaining the resource lists so write FF to invalidate old
+	 * info
+	 */
 	temp_dword = 1;
 
 	rc = access_EV(WRITE_EV, "CQTHPS", &temp_byte, &temp_dword);
@@ -264,12 +267,12 @@ static u32 store_HRT (void __iomem *rom_start)
 
 	ctrl = cpqhp_ctrl_list;
 
-	// The revision of this structure
+	/* The revision of this structure */
 	rc = add_byte( &pFill, 1 + ctrl->push_flag, &usedbytes, &available);
 	if (rc)
 		return(rc);
 
-	// The number of controllers
+	/* The number of controllers */
 	rc = add_byte( &pFill, 1, &usedbytes, &available);
 	if (rc)
 		return(rc);
@@ -279,27 +282,27 @@ static u32 store_HRT (void __iomem *rom_start)
 
 		numCtrl++;
 
-		// The bus number
+		/* The bus number */
 		rc = add_byte( &pFill, ctrl->bus, &usedbytes, &available);
 		if (rc)
 			return(rc);
 
-		// The device Number
+		/* The device Number */
 		rc = add_byte( &pFill, PCI_SLOT(ctrl->pci_dev->devfn), &usedbytes, &available);
 		if (rc)
 			return(rc);
 
-		// The function Number
+		/* The function Number */
 		rc = add_byte( &pFill, PCI_FUNC(ctrl->pci_dev->devfn), &usedbytes, &available);
 		if (rc)
 			return(rc);
 
-		// Skip the number of available entries
+		/* Skip the number of available entries */
 		rc = add_dword( &pFill, 0, &usedbytes, &available);
 		if (rc)
 			return(rc);
 
-		// Figure out memory Available
+		/* Figure out memory Available */
 
 		resNode = ctrl->mem_head;
 
@@ -308,12 +311,12 @@ static u32 store_HRT (void __iomem *rom_start)
 		while (resNode) {
 			loop ++;
 
-			// base
+			/* base */
 			rc = add_dword( &pFill, resNode->base, &usedbytes, &available);
 			if (rc)
 				return(rc);
 
-			// length
+			/* length */
 			rc = add_dword( &pFill, resNode->length, &usedbytes, &available);
 			if (rc)
 				return(rc);
@@ -321,10 +324,10 @@ static u32 store_HRT (void __iomem *rom_start)
 			resNode = resNode->next;
 		}
 
-		// Fill in the number of entries
+		/* Fill in the number of entries */
 		p_ev_ctrl->mem_avail = loop;
 
-		// Figure out prefetchable memory Available
+		/* Figure out prefetchable memory Available */
 
 		resNode = ctrl->p_mem_head;
 
@@ -333,12 +336,12 @@ static u32 store_HRT (void __iomem *rom_start)
 		while (resNode) {
 			loop ++;
 
-			// base
+			/* base */
 			rc = add_dword( &pFill, resNode->base, &usedbytes, &available);
 			if (rc)
 				return(rc);
 
-			// length
+			/* length */
 			rc = add_dword( &pFill, resNode->length, &usedbytes, &available);
 			if (rc)
 				return(rc);
@@ -346,10 +349,10 @@ static u32 store_HRT (void __iomem *rom_start)
 			resNode = resNode->next;
 		}
 
-		// Fill in the number of entries
+		/* Fill in the number of entries */
 		p_ev_ctrl->p_mem_avail = loop;
 
-		// Figure out IO Available
+		/* Figure out IO Available */
 
 		resNode = ctrl->io_head;
 
@@ -358,12 +361,12 @@ static u32 store_HRT (void __iomem *rom_start)
 		while (resNode) {
 			loop ++;
 
-			// base
+			/* base */
 			rc = add_dword( &pFill, resNode->base, &usedbytes, &available);
 			if (rc)
 				return(rc);
 
-			// length
+			/* length */
 			rc = add_dword( &pFill, resNode->length, &usedbytes, &available);
 			if (rc)
 				return(rc);
@@ -371,10 +374,10 @@ static u32 store_HRT (void __iomem *rom_start)
 			resNode = resNode->next;
 		}
 
-		// Fill in the number of entries
+		/* Fill in the number of entries */
 		p_ev_ctrl->io_avail = loop;
 
-		// Figure out bus Available
+		/* Figure out bus Available */
 
 		resNode = ctrl->bus_head;
 
@@ -383,12 +386,12 @@ static u32 store_HRT (void __iomem *rom_start)
 		while (resNode) {
 			loop ++;
 
-			// base
+			/* base */
 			rc = add_dword( &pFill, resNode->base, &usedbytes, &available);
 			if (rc)
 				return(rc);
 
-			// length
+			/* length */
 			rc = add_dword( &pFill, resNode->length, &usedbytes, &available);
 			if (rc)
 				return(rc);
@@ -396,7 +399,7 @@ static u32 store_HRT (void __iomem *rom_start)
 			resNode = resNode->next;
 		}
 
-		// Fill in the number of entries
+		/* Fill in the number of entries */
 		p_ev_ctrl->bus_avail = loop;
 
 		ctrl = ctrl->next;
@@ -404,7 +407,7 @@ static u32 store_HRT (void __iomem *rom_start)
 
 	p_EV_header->num_of_ctrl = numCtrl;
 
-	// Now store the EV
+	/* Now store the EV */
 
 	temp_dword = usedbytes;
 
@@ -449,20 +452,21 @@ int compaq_nvram_load (void __iomem *rom_start, struct controller *ctrl)
 	struct ev_hrt_header *p_EV_header;
 
 	if (!evbuffer_init) {
-		// Read the resource list information in from NVRAM
+		/* Read the resource list information in from NVRAM */
 		if (load_HRT(rom_start))
 			memset (evbuffer, 0, 1024);
 
 		evbuffer_init = 1;
 	}
 
-	// If we saved information in NVRAM, use it now
+	/* If we saved information in NVRAM, use it now */
 	p_EV_header = (struct ev_hrt_header *) evbuffer;
 
-	// The following code is for systems where version 1.0 of this
-	// driver has been loaded, but doesn't support the hardware.
-	// In that case, the driver would incorrectly store something
-	// in NVRAM.
+	/* The following code is for systems where version 1.0 of this
+	 * driver has been loaded, but doesn't support the hardware.
+	 * In that case, the driver would incorrectly store something
+	 * in NVRAM.
+	 */
 	if ((p_EV_header->Version == 2) ||
 	    ((p_EV_header->Version == 1) && !ctrl->push_flag)) {
 		p_byte = &(p_EV_header->next);
@@ -491,7 +495,7 @@ int compaq_nvram_load (void __iomem *rom_start, struct controller *ctrl)
 			if (p_byte > ((u8*)p_EV_header + evbuffer_length))
 				return 2;
 
-			// Skip forward to the next entry
+			/* Skip forward to the next entry */
 			p_byte += (nummem + numpmem + numio + numbus) * 8;
 
 			if (p_byte > ((u8*)p_EV_header + evbuffer_length))
@@ -629,8 +633,9 @@ int compaq_nvram_load (void __iomem *rom_start, struct controller *ctrl)
 			ctrl->bus_head = bus_node;
 		}
 
-		// If all of the following fail, we don't have any resources for
-		// hot plug add
+		/* If all of the following fail, we don't have any resources for
+		 * hot plug add
+		 */
 		rc = 1;
 		rc &= cpqhp_resource_sort_and_combine(&(ctrl->mem_head));
 		rc &= cpqhp_resource_sort_and_combine(&(ctrl->p_mem_head));
diff --git a/drivers/pci/hotplug/cpqphp_pci.c b/drivers/pci/hotplug/cpqphp_pci.c
index 573a270..2e96bae 100644
--- a/drivers/pci/hotplug/cpqphp_pci.c
+++ b/drivers/pci/hotplug/cpqphp_pci.c
@@ -178,17 +178,17 @@ int cpqhp_set_irq (u8 bus_num, u8 dev_num, u8 int_pin, u8 irq_num)
 		if (!rc)
 			return !rc;
 
-		// set the Edge Level Control Register (ELCR)
+		/* set the Edge Level Control Register (ELCR) */
 		temp_word = inb(0x4d0);
 		temp_word |= inb(0x4d1) << 8;
 
 		temp_word |= 0x01 << irq_num;
 
-		// This should only be for x86 as it sets the Edge Level Control Register
-		outb((u8) (temp_word & 0xFF), 0x4d0);
-		outb((u8) ((temp_word & 0xFF00) >> 8), 0x4d1);
-		rc = 0;
-	}
+		/* This should only be for x86 as it sets the Edge Level
+		 * Control Register
+		 */
+		outb((u8) (temp_word & 0xFF), 0x4d0); outb((u8) ((temp_word &
+		0xFF00) >> 8), 0x4d1); rc = 0; }
 
 	return rc;
 }
@@ -213,11 +213,11 @@ static int PCI_ScanBusForNonBridge(struct controller *ctrl, u8 bus_num, u8 * dev
 	ctrl->pci_bus->number = bus_num;
 
 	for (tdevice = 0; tdevice < 0xFF; tdevice++) {
-		//Scan for access first
+		/* Scan for access first */
 		if (PCI_RefinedAccessConfig(ctrl->pci_bus, tdevice, 0x08, &work) == -1)
 			continue;
 		dbg("Looking for nonbridge bus_num %d dev_num %d\n", bus_num, tdevice);
-		//Yep we got one. Not a bridge ?
+		/* Yep we got one. Not a bridge ? */
 		if ((work >> 8) != PCI_TO_PCI_BRIDGE_CLASS) {
 			*dev_num = tdevice;
 			dbg("found it !\n");
@@ -225,11 +225,11 @@ static int PCI_ScanBusForNonBridge(struct controller *ctrl, u8 bus_num, u8 * dev
 		}
 	}
 	for (tdevice = 0; tdevice < 0xFF; tdevice++) {
-		//Scan for access first
+		/* Scan for access first */
 		if (PCI_RefinedAccessConfig(ctrl->pci_bus, tdevice, 0x08, &work) == -1)
 			continue;
 		dbg("Looking for bridge bus_num %d dev_num %d\n", bus_num, tdevice);
-		//Yep we got one. bridge ?
+		/* Yep we got one. bridge ? */
 		if ((work >> 8) == PCI_TO_PCI_BRIDGE_CLASS) {
 			pci_bus_read_config_byte (ctrl->pci_bus, PCI_DEVFN(tdevice, 0), PCI_SECONDARY_BUS, &tbus);
 			dbg("Recurse on bus_num %d tdevice %d\n", tbus, tdevice);
@@ -257,7 +257,7 @@ static int PCI_GetBusDevHelper(struct controller *ctrl, u8 *bus_num, u8 *dev_num
 
 	len = (PCIIRQRoutingInfoLength->size -
 	       sizeof(struct irq_routing_table)) / sizeof(struct irq_info);
-	// Make sure I got at least one entry
+	/* Make sure I got at least one entry */
 	if (len == 0) {
 		kfree(PCIIRQRoutingInfoLength );
 		return -1;
@@ -304,11 +304,14 @@ static int PCI_GetBusDevHelper(struct controller *ctrl, u8 *bus_num, u8 *dev_num
 
 int cpqhp_get_bus_dev (struct controller *ctrl, u8 * bus_num, u8 * dev_num, u8 slot)
 {
-	return PCI_GetBusDevHelper(ctrl, bus_num, dev_num, slot, 0);	//plain (bridges allowed)
+	/* plain (bridges allowed) */
+	return PCI_GetBusDevHelper(ctrl, bus_num, dev_num, slot, 0);
 }
 
 
-/* More PCI configuration routines; this time centered around hotplug controller */
+/* More PCI configuration routines; this time centered around hotplug
+ * controller
+ */
 
 
 /*
@@ -339,12 +342,12 @@ int cpqhp_save_config(struct controller *ctrl, int busnumber, int is_hot_plug)
 	int stop_it;
 	int index;
 
-	//              Decide which slots are supported
+	/* Decide which slots are supported */
 
 	if (is_hot_plug) {
-		//*********************************
-		// is_hot_plug is the slot mask
-		//*********************************
+		/*
+		 * is_hot_plug is the slot mask
+		 */
 		FirstSupported = is_hot_plug >> 4;
 		LastSupported = FirstSupported + (is_hot_plug & 0x0F) - 1;
 	} else {
@@ -352,13 +355,13 @@ int cpqhp_save_config(struct controller *ctrl, int busnumber, int is_hot_plug)
 		LastSupported = 0x1F;
 	}
 
-	//     Save PCI configuration space for all devices in supported slots
+	/* Save PCI configuration space for all devices in supported slots */
 	ctrl->pci_bus->number = busnumber;
 	for (device = FirstSupported; device <= LastSupported; device++) {
 		ID = 0xFFFFFFFF;
 		rc = pci_bus_read_config_dword (ctrl->pci_bus, PCI_DEVFN(device, 0), PCI_VENDOR_ID, &ID);
 
-		if (ID != 0xFFFFFFFF) {	  //  device in slot
+		if (ID != 0xFFFFFFFF) {	  /* device in slot */
 			rc = pci_bus_read_config_byte (ctrl->pci_bus, PCI_DEVFN(device, 0), 0x0B, &class_code);
 			if (rc)
 				return rc;
@@ -367,7 +370,7 @@ int cpqhp_save_config(struct controller *ctrl, int busnumber, int is_hot_plug)
 			if (rc)
 				return rc;
 
-			// If multi-function device, set max_functions to 8
+			/* If multi-function device, set max_functions to 8 */
 			if (header_type & 0x80)
 				max_functions = 8;
 			else
@@ -377,18 +380,19 @@ int cpqhp_save_config(struct controller *ctrl, int busnumber, int is_hot_plug)
 
 			do {
 				DevError = 0;
-
-				if ((header_type & 0x7F) == PCI_HEADER_TYPE_BRIDGE) {   // P-P Bridge
-					//  Recurse the subordinate bus
-					//  get the subordinate bus number
+				if ((header_type & 0x7F) == PCI_HEADER_TYPE_BRIDGE) {
+					/* Recurse the subordinate bus
+					 * get the subordinate bus number
+					 */
 					rc = pci_bus_read_config_byte (ctrl->pci_bus, PCI_DEVFN(device, function), PCI_SECONDARY_BUS, &secondary_bus);
 					if (rc) {
 						return rc;
 					} else {
 						sub_bus = (int) secondary_bus;
 
-						// Save secondary bus cfg spc
-						// with this recursive call.
+						/* Save secondary bus cfg spc
+						 * with this recursive call.
+						 */
 						rc = cpqhp_save_config(ctrl, sub_bus, 0);
 						if (rc)
 							return rc;
@@ -403,7 +407,7 @@ int cpqhp_save_config(struct controller *ctrl, int busnumber, int is_hot_plug)
 					new_slot = cpqhp_slot_find(busnumber, device, index++);
 
 				if (!new_slot) {
-					// Setup slot structure.
+					/* Setup slot structure. */
 					new_slot = cpqhp_slot_create(busnumber);
 
 					if (new_slot == NULL)
@@ -415,7 +419,7 @@ int cpqhp_save_config(struct controller *ctrl, int busnumber, int is_hot_plug)
 				new_slot->function = (u8) function;
 				new_slot->is_a_board = 1;
 				new_slot->switch_save = 0x10;
-				// In case of unsupported board
+				/* In case of unsupported board */
 				new_slot->status = DevError;
 				new_slot->pci_dev = pci_find_slot(new_slot->bus, (new_slot->device << 3) | new_slot->function);
 
@@ -429,14 +433,15 @@ int cpqhp_save_config(struct controller *ctrl, int busnumber, int is_hot_plug)
 
 				stop_it = 0;
 
-				//  this loop skips to the next present function
-				//  reading in Class Code and Header type.
+				/* this loop skips to the next present function
+				 * reading in Class Code and Header type.
+				 */
 
 				while ((function < max_functions)&&(!stop_it)) {
 					rc = pci_bus_read_config_dword (ctrl->pci_bus, PCI_DEVFN(device, function), PCI_VENDOR_ID, &ID);
-					if (ID == 0xFFFFFFFF) {	 // nothing there.
+					if (ID == 0xFFFFFFFF) {	 /* nothing there. */
 						function++;
-					} else {  // Something there
+					} else {  /* Something there */
 						rc = pci_bus_read_config_byte (ctrl->pci_bus, PCI_DEVFN(device, function), 0x0B, &class_code);
 						if (rc)
 							return rc;
@@ -450,9 +455,9 @@ int cpqhp_save_config(struct controller *ctrl, int busnumber, int is_hot_plug)
 				}
 
 			} while (function < max_functions);
-		}		// End of IF (device in slot?)
+		}		/* End of IF (device in slot?) */
 		else if (is_hot_plug) {
-			// Setup slot structure with entry for empty slot
+			/* Setup slot structure with entry for empty slot */
 			new_slot = cpqhp_slot_create(busnumber);
 
 			if (new_slot == NULL) {
@@ -466,7 +471,7 @@ int cpqhp_save_config(struct controller *ctrl, int busnumber, int is_hot_plug)
 			new_slot->presence_save = 0;
 			new_slot->switch_save = 0;
 		}
-	}			// End of FOR loop
+	}			/* End of FOR loop */
 
 	return(0);
 }
@@ -498,11 +503,11 @@ int cpqhp_save_slot_config (struct controller *ctrl, struct pci_func * new_slot)
 	ctrl->pci_bus->number = new_slot->bus;
 	pci_bus_read_config_dword (ctrl->pci_bus, PCI_DEVFN(new_slot->device, 0), PCI_VENDOR_ID, &ID);
 
-	if (ID != 0xFFFFFFFF) {	  //  device in slot
+	if (ID != 0xFFFFFFFF) {	  /*  device in slot */
 		pci_bus_read_config_byte (ctrl->pci_bus, PCI_DEVFN(new_slot->device, 0), 0x0B, &class_code);
 		pci_bus_read_config_byte (ctrl->pci_bus, PCI_DEVFN(new_slot->device, 0), PCI_HEADER_TYPE, &header_type);
 
-		if (header_type & 0x80)	// Multi-function device
+		if (header_type & 0x80)	/* Multi-function device */
 			max_functions = 8;
 		else
 			max_functions = 1;
@@ -510,19 +515,21 @@ int cpqhp_save_slot_config (struct controller *ctrl, struct pci_func * new_slot)
 		function = 0;
 
 		do {
-			if ((header_type & 0x7F) == PCI_HEADER_TYPE_BRIDGE) {	  // PCI-PCI Bridge
-				//  Recurse the subordinate bus
+			if ((header_type & 0x7F) == PCI_HEADER_TYPE_BRIDGE) {
+				/*  Recurse the subordinate bus */
 				pci_bus_read_config_byte (ctrl->pci_bus, PCI_DEVFN(new_slot->device, function), PCI_SECONDARY_BUS, &secondary_bus);
 
 				sub_bus = (int) secondary_bus;
 
-				// Save the config headers for the secondary bus.
+				/* Save the config headers for the secondary
+				 * bus.
+				 */
 				rc = cpqhp_save_config(ctrl, sub_bus, 0);
 				if (rc)
 					return(rc);
 				ctrl->pci_bus->number = new_slot->bus;
 
-			}	// End of IF
+			}	/* End of IF */
 
 			new_slot->status = 0;
 
@@ -534,15 +541,15 @@ int cpqhp_save_slot_config (struct controller *ctrl, struct pci_func * new_slot)
 
 			stop_it = 0;
 
-			//  this loop skips to the next present function
-			//  reading in the Class Code and the Header type.
-
+			/* this loop skips to the next present function
+			 * reading in the Class Code and the Header type.
+			 */
 			while ((function < max_functions) && (!stop_it)) {
 				pci_bus_read_config_dword (ctrl->pci_bus, PCI_DEVFN(new_slot->device, function), PCI_VENDOR_ID, &ID);
 
-				if (ID == 0xFFFFFFFF) {	 // nothing there.
+				if (ID == 0xFFFFFFFF) {	 /* nothing there. */
 					function++;
-				} else {  // Something there
+				} else {  /* Something there */
 					pci_bus_read_config_byte (ctrl->pci_bus, PCI_DEVFN(new_slot->device, function), 0x0B, &class_code);
 
 					pci_bus_read_config_byte (ctrl->pci_bus, PCI_DEVFN(new_slot->device, function), PCI_HEADER_TYPE, &header_type);
@@ -552,7 +559,7 @@ int cpqhp_save_slot_config (struct controller *ctrl, struct pci_func * new_slot)
 			}
 
 		} while (function < max_functions);
-	}			// End of IF (device in slot?)
+	}			/* End of IF (device in slot?) */
 	else {
 		return 2;
 	}
@@ -590,11 +597,10 @@ int cpqhp_save_base_addr_length(struct controller *ctrl, struct pci_func * func)
 		pci_bus->number = func->bus;
 		devfn = PCI_DEVFN(func->device, func->function);
 
-		// Check for Bridge
+		/* Check for Bridge */
 		pci_bus_read_config_byte (pci_bus, devfn, PCI_HEADER_TYPE, &header_type);
 
 		if ((header_type & 0x7F) == PCI_HEADER_TYPE_BRIDGE) {
-			// PCI-PCI Bridge
 			pci_bus_read_config_byte (pci_bus, devfn, PCI_SECONDARY_BUS, &secondary_bus);
 
 			sub_bus = (int) secondary_bus;
@@ -610,23 +616,27 @@ int cpqhp_save_base_addr_length(struct controller *ctrl, struct pci_func * func)
 			}
 			pci_bus->number = func->bus;
 
-			//FIXME: this loop is duplicated in the non-bridge case.  The two could be rolled together
-			// Figure out IO and memory base lengths
+			/* FIXME: this loop is duplicated in the non-bridge
+			 * case.  The two could be rolled together Figure out
+			 * IO and memory base lengths
+			 */
 			for (cloop = 0x10; cloop <= 0x14; cloop += 4) {
 				temp_register = 0xFFFFFFFF;
 				pci_bus_write_config_dword (pci_bus, devfn, cloop, temp_register);
 				pci_bus_read_config_dword (pci_bus, devfn, cloop, &base);
-
-				if (base) {  // If this register is implemented
+				/* If this register is implemented */
+				if (base) {
 					if (base & 0x01L) {
-						// IO base
-						// set base = amount of IO space requested
+						/* IO base
+						 * set base = amount of IO space
+						 * requested
+						 */
 						base = base & 0xFFFFFFFE;
 						base = (~base) + 1;
 
 						type = 1;
 					} else {
-						// memory base
+						/* memory base */
 						base = base & 0xFFFFFFF0;
 						base = (~base) + 1;
 
@@ -637,32 +647,36 @@ int cpqhp_save_base_addr_length(struct controller *ctrl, struct pci_func * func)
 					type = 0;
 				}
 
-				// Save information in slot structure
+				/* Save information in slot structure */
 				func->base_length[(cloop - 0x10) >> 2] =
 				base;
 				func->base_type[(cloop - 0x10) >> 2] = type;
 
-			}	// End of base register loop
-
+			}	/* End of base register loop */
 
-		} else if ((header_type & 0x7F) == 0x00) {	  // PCI-PCI Bridge
-			// Figure out IO and memory base lengths
+		} else if ((header_type & 0x7F) == 0x00) {
+			/* Figure out IO and memory base lengths */
 			for (cloop = 0x10; cloop <= 0x24; cloop += 4) {
 				temp_register = 0xFFFFFFFF;
 				pci_bus_write_config_dword (pci_bus, devfn, cloop, temp_register);
 				pci_bus_read_config_dword (pci_bus, devfn, cloop, &base);
 
-				if (base) {  // If this register is implemented
+				/* If this register is implemented */
+				if (base) {
 					if (base & 0x01L) {
-						// IO base
-						// base = amount of IO space requested
+						/* IO base
+						 * base = amount of IO space
+						 * requested
+						 */
 						base = base & 0xFFFFFFFE;
 						base = (~base) + 1;
 
 						type = 1;
 					} else {
-						// memory base
-						// base = amount of memory space requested
+						/* memory base
+						 * base = amount of memory
+						 * space requested
+						 */
 						base = base & 0xFFFFFFF0;
 						base = (~base) + 1;
 
@@ -673,16 +687,16 @@ int cpqhp_save_base_addr_length(struct controller *ctrl, struct pci_func * func)
 					type = 0;
 				}
 
-				// Save information in slot structure
+				/* Save information in slot structure */
 				func->base_length[(cloop - 0x10) >> 2] = base;
 				func->base_type[(cloop - 0x10) >> 2] = type;
 
-			}	// End of base register loop
+			}	/* End of base register loop */
 
-		} else {	  // Some other unknown header type
+		} else {	  /* Some other unknown header type */
 		}
 
-		// find the next device in this slot
+		/* find the next device in this slot */
 		func = cpqhp_slot_find(func->bus, func->device, index++);
 	}
 
@@ -728,18 +742,18 @@ int cpqhp_save_used_resources (struct controller *ctrl, struct pci_func * func)
 		pci_bus->number = func->bus;
 		devfn = PCI_DEVFN(func->device, func->function);
 
-		// Save the command register
+		/* Save the command register */
 		pci_bus_read_config_word(pci_bus, devfn, PCI_COMMAND, &save_command);
 
-		// disable card
+		/* disable card */
 		command = 0x00;
 		pci_bus_write_config_word(pci_bus, devfn, PCI_COMMAND, command);
 
-		// Check for Bridge
+		/* Check for Bridge */
 		pci_bus_read_config_byte(pci_bus, devfn, PCI_HEADER_TYPE, &header_type);
 
-		if ((header_type & 0x7F) == PCI_HEADER_TYPE_BRIDGE) {	  // PCI-PCI Bridge
-			// Clear Bridge Control Register
+		if ((header_type & 0x7F) == PCI_HEADER_TYPE_BRIDGE) {
+			/* Clear Bridge Control Register */
 			command = 0x00;
 			pci_bus_write_config_word(pci_bus, devfn, PCI_BRIDGE_CONTROL, command);
 			pci_bus_read_config_byte(pci_bus, devfn, PCI_SECONDARY_BUS, &secondary_bus);
@@ -755,7 +769,7 @@ int cpqhp_save_used_resources (struct controller *ctrl, struct pci_func * func)
 			bus_node->next = func->bus_head;
 			func->bus_head = bus_node;
 
-			// Save IO base and Limit registers
+			/* Save IO base and Limit registers */
 			pci_bus_read_config_byte(pci_bus, devfn, PCI_IO_BASE, &b_base);
 			pci_bus_read_config_byte(pci_bus, devfn, PCI_IO_LIMIT, &b_length);
 
@@ -771,7 +785,7 @@ int cpqhp_save_used_resources (struct controller *ctrl, struct pci_func * func)
 				func->io_head = io_node;
 			}
 
-			// Save memory base and Limit registers
+			/* Save memory base and Limit registers */
 			pci_bus_read_config_word(pci_bus, devfn, PCI_MEMORY_BASE, &w_base);
 			pci_bus_read_config_word(pci_bus, devfn, PCI_MEMORY_LIMIT, &w_length);
 
@@ -787,7 +801,7 @@ int cpqhp_save_used_resources (struct controller *ctrl, struct pci_func * func)
 				func->mem_head = mem_node;
 			}
 
-			// Save prefetchable memory base and Limit registers
+			/* Save prefetchable memory base and Limit registers */
 			pci_bus_read_config_word(pci_bus, devfn, PCI_PREF_MEMORY_BASE, &w_base);
 			pci_bus_read_config_word(pci_bus, devfn, PCI_PREF_MEMORY_LIMIT, &w_length);
 
@@ -802,7 +816,7 @@ int cpqhp_save_used_resources (struct controller *ctrl, struct pci_func * func)
 				p_mem_node->next = func->p_mem_head;
 				func->p_mem_head = p_mem_node;
 			}
-			// Figure out IO and memory base lengths
+			/* Figure out IO and memory base lengths */
 			for (cloop = 0x10; cloop <= 0x14; cloop += 4) {
 				pci_bus_read_config_dword (pci_bus, devfn, cloop, &save_base);
 
@@ -812,11 +826,14 @@ int cpqhp_save_used_resources (struct controller *ctrl, struct pci_func * func)
 
 				temp_register = base;
 
-				if (base) {  // If this register is implemented
+				/* If this register is implemented */
+				if (base) {
 					if (((base & 0x03L) == 0x01)
 					    && (save_command & 0x01)) {
-						// IO base
-						// set temp_register = amount of IO space requested
+						/* IO base
+						 * set temp_register = amount
+						 * of IO space requested
+						 */
 						temp_register = base & 0xFFFFFFFE;
 						temp_register = (~temp_register) + 1;
 
@@ -834,7 +851,7 @@ int cpqhp_save_used_resources (struct controller *ctrl, struct pci_func * func)
 					} else
 						if (((base & 0x0BL) == 0x08)
 						    && (save_command & 0x02)) {
-						// prefetchable memory base
+						/* prefetchable memory base */
 						temp_register = base & 0xFFFFFFF0;
 						temp_register = (~temp_register) + 1;
 
@@ -851,7 +868,7 @@ int cpqhp_save_used_resources (struct controller *ctrl, struct pci_func * func)
 					} else
 						if (((base & 0x0BL) == 0x00)
 						    && (save_command & 0x02)) {
-						// prefetchable memory base
+						/* prefetchable memory base */
 						temp_register = base & 0xFFFFFFF0;
 						temp_register = (~temp_register) + 1;
 
@@ -868,9 +885,10 @@ int cpqhp_save_used_resources (struct controller *ctrl, struct pci_func * func)
 					} else
 						return(1);
 				}
-			}	// End of base register loop
-		} else if ((header_type & 0x7F) == 0x00) {	  // Standard header
-			// Figure out IO and memory base lengths
+			}	/* End of base register loop */
+		/* Standard header */
+		} else if ((header_type & 0x7F) == 0x00) {
+			/* Figure out IO and memory base lengths */
 			for (cloop = 0x10; cloop <= 0x24; cloop += 4) {
 				pci_bus_read_config_dword(pci_bus, devfn, cloop, &save_base);
 
@@ -880,11 +898,14 @@ int cpqhp_save_used_resources (struct controller *ctrl, struct pci_func * func)
 
 				temp_register = base;
 
-				if (base) {	  // If this register is implemented
+				/* If this register is implemented */
+				if (base) {
 					if (((base & 0x03L) == 0x01)
 					    && (save_command & 0x01)) {
-						// IO base
-						// set temp_register = amount of IO space requested
+						/* IO base
+						 * set temp_register = amount
+						 * of IO space requested
+						 */
 						temp_register = base & 0xFFFFFFFE;
 						temp_register = (~temp_register) + 1;
 
@@ -901,7 +922,7 @@ int cpqhp_save_used_resources (struct controller *ctrl, struct pci_func * func)
 					} else
 						if (((base & 0x0BL) == 0x08)
 						    && (save_command & 0x02)) {
-						// prefetchable memory base
+						/* prefetchable memory base */
 						temp_register = base & 0xFFFFFFF0;
 						temp_register = (~temp_register) + 1;
 
@@ -918,7 +939,7 @@ int cpqhp_save_used_resources (struct controller *ctrl, struct pci_func * func)
 					} else
 						if (((base & 0x0BL) == 0x00)
 						    && (save_command & 0x02)) {
-						// prefetchable memory base
+						/* prefetchable memory base */
 						temp_register = base & 0xFFFFFFF0;
 						temp_register = (~temp_register) + 1;
 
@@ -935,11 +956,12 @@ int cpqhp_save_used_resources (struct controller *ctrl, struct pci_func * func)
 					} else
 						return(1);
 				}
-			}	// End of base register loop
-		} else {	  // Some other unknown header type
+			}	/* End of base register loop */
+		/* Some other unknown header type */
+		} else {
 		}
 
-		// find the next device in this slot
+		/* find the next device in this slot */
 		func = cpqhp_slot_find(func->bus, func->device, index++);
 	}
 
@@ -975,16 +997,17 @@ int cpqhp_configure_board(struct controller *ctrl, struct pci_func * func)
 		pci_bus->number = func->bus;
 		devfn = PCI_DEVFN(func->device, func->function);
 
-		// Start at the top of config space so that the control
-		// registers are programmed last
+		/* Start at the top of config space so that the control
+		 * registers are programmed last
+		 */
 		for (cloop = 0x3C; cloop > 0; cloop -= 4) {
 			pci_bus_write_config_dword (pci_bus, devfn, cloop, func->config_space[cloop >> 2]);
 		}
 
 		pci_bus_read_config_byte (pci_bus, devfn, PCI_HEADER_TYPE, &header_type);
 
-		// If this is a bridge device, restore subordinate devices
-		if ((header_type & 0x7F) == PCI_HEADER_TYPE_BRIDGE) {	  // PCI-PCI Bridge
+		/* If this is a bridge device, restore subordinate devices */
+		if ((header_type & 0x7F) == PCI_HEADER_TYPE_BRIDGE) {
 			pci_bus_read_config_byte (pci_bus, devfn, PCI_SECONDARY_BUS, &secondary_bus);
 
 			sub_bus = (int) secondary_bus;
@@ -1000,8 +1023,9 @@ int cpqhp_configure_board(struct controller *ctrl, struct pci_func * func)
 			}
 		} else {
 
-			// Check all the base Address Registers to make sure
-			// they are the same.  If not, the board is different.
+			/* Check all the base Address Registers to make sure
+			 * they are the same.  If not, the board is different.
+			 */
 
 			for (cloop = 16; cloop < 40; cloop += 4) {
 				pci_bus_read_config_dword (pci_bus, devfn, cloop, &temp);
@@ -1058,27 +1082,28 @@ int cpqhp_valid_replace(struct controller *ctrl, struct pci_func * func)
 
 		pci_bus_read_config_dword (pci_bus, devfn, PCI_VENDOR_ID, &temp_register);
 
-		// No adapter present
+		/* No adapter present */
 		if (temp_register == 0xFFFFFFFF)
 			return(NO_ADAPTER_PRESENT);
 
 		if (temp_register != func->config_space[0])
 			return(ADAPTER_NOT_SAME);
 
-		// Check for same revision number and class code
+		/* Check for same revision number and class code */
 		pci_bus_read_config_dword (pci_bus, devfn, PCI_CLASS_REVISION, &temp_register);
 
-		// Adapter not the same
+		/* Adapter not the same */
 		if (temp_register != func->config_space[0x08 >> 2])
 			return(ADAPTER_NOT_SAME);
 
-		// Check for Bridge
+		/* Check for Bridge */
 		pci_bus_read_config_byte (pci_bus, devfn, PCI_HEADER_TYPE, &header_type);
 
-		if ((header_type & 0x7F) == PCI_HEADER_TYPE_BRIDGE) {	  // PCI-PCI Bridge
-			// In order to continue checking, we must program the
-			// bus registers in the bridge to respond to accesses
-			// for it's subordinate bus(es)
+		if ((header_type & 0x7F) == PCI_HEADER_TYPE_BRIDGE) {
+			/* In order to continue checking, we must program the
+			 * bus registers in the bridge to respond to accesses
+			 * for its subordinate bus(es)
+			 */
 
 			temp_register = func->config_space[0x18 >> 2];
 			pci_bus_write_config_dword (pci_bus, devfn, PCI_PRIMARY_BUS, temp_register);
@@ -1096,35 +1121,39 @@ int cpqhp_valid_replace(struct controller *ctrl, struct pci_func * func)
 			}
 
 		}
-		// Check to see if it is a standard config header
+		/* Check to see if it is a standard config header */
 		else if ((header_type & 0x7F) == PCI_HEADER_TYPE_NORMAL) {
-			// Check subsystem vendor and ID
+			/* Check subsystem vendor and ID */
 			pci_bus_read_config_dword (pci_bus, devfn, PCI_SUBSYSTEM_VENDOR_ID, &temp_register);
 
 			if (temp_register != func->config_space[0x2C >> 2]) {
-				// If it's a SMART-2 and the register isn't filled
-				// in, ignore the difference because
-				// they just have an old rev of the firmware
-
+				/* If it's a SMART-2 and the register isn't
+				 * filled in, ignore the difference because
+				 * they just have an old rev of the firmware
+				 */
 				if (!((func->config_space[0] == 0xAE100E11)
 				      && (temp_register == 0x00L)))
 					return(ADAPTER_NOT_SAME);
 			}
-			// Figure out IO and memory base lengths
+			/* Figure out IO and memory base lengths */
 			for (cloop = 0x10; cloop <= 0x24; cloop += 4) {
 				temp_register = 0xFFFFFFFF;
 				pci_bus_write_config_dword (pci_bus, devfn, cloop, temp_register);
 				pci_bus_read_config_dword (pci_bus, devfn, cloop, &base);
-				if (base) {	  // If this register is implemented
+
+				/* If this register is implemented */
+				if (base) {
 					if (base & 0x01L) {
-						// IO base
-						// set base = amount of IO space requested
+						/* IO base
+						 * set base = amount of IO
+						 * space requested
+						 */
 						base = base & 0xFFFFFFFE;
 						base = (~base) + 1;
 
 						type = 1;
 					} else {
-						// memory base
+						/* memory base */
 						base = base & 0xFFFFFFF0;
 						base = (~base) + 1;
 
@@ -1135,23 +1164,24 @@ int cpqhp_valid_replace(struct controller *ctrl, struct pci_func * func)
 					type = 0;
 				}
 
-				// Check information in slot structure
+				/* Check information in slot structure */
 				if (func->base_length[(cloop - 0x10) >> 2] != base)
 					return(ADAPTER_NOT_SAME);
 
 				if (func->base_type[(cloop - 0x10) >> 2] != type)
 					return(ADAPTER_NOT_SAME);
 
-			}	// End of base register loop
+			}	/* End of base register loop */
 
-		}		// End of (type 0 config space) else
+		}		/* End of (type 0 config space) else */
 		else {
-			// this is not a type 0 or 1 config space header so
-			// we don't know how to do it
+			/* this is not a type 0 or 1 config space header so
+			 * we don't know how to do it
+			 */
 			return(DEVICE_TYPE_NOT_SUPPORTED);
 		}
 
-		// Get the next function
+		/* Get the next function */
 		func = cpqhp_slot_find(func->bus, func->device, index++);
 	}
 
@@ -1190,7 +1220,7 @@ int cpqhp_find_available_resources(struct controller *ctrl, void __iomem *rom_st
 	if (rom_resource_table == NULL) {
 		return -ENODEV;
 	}
-	// Sum all resources and setup resource maps
+	/* Sum all resources and setup resource maps */
 	unused_IRQ = readl(rom_resource_table + UNUSED_IRQ);
 	dbg("unused_IRQ = %x\n", unused_IRQ);
 
@@ -1262,13 +1292,13 @@ int cpqhp_find_available_resources(struct controller *ctrl, void __iomem *rom_st
 		    dev_func, io_base, io_length, mem_base, mem_length, pre_mem_base, pre_mem_length,
 		    primary_bus, secondary_bus, max_bus);
 
-		// If this entry isn't for our controller's bus, ignore it
+		/* If this entry isn't for our controller's bus, ignore it */
 		if (primary_bus != ctrl->bus) {
 			i--;
 			one_slot += sizeof (struct slot_rt);
 			continue;
 		}
-		// find out if this entry is for an occupied slot
+		/* find out if this entry is for an occupied slot */
 		ctrl->pci_bus->number = primary_bus;
 		pci_bus_read_config_dword (ctrl->pci_bus, dev_func, PCI_VENDOR_ID, &temp_dword);
 		dbg("temp_D_word = %x\n", temp_dword);
@@ -1282,13 +1312,13 @@ int cpqhp_find_available_resources(struct controller *ctrl, void __iomem *rom_st
 				func = cpqhp_slot_find(primary_bus, dev_func >> 3, index++);
 			}
 
-			// If we can't find a match, skip this table entry
+			/* If we can't find a match, skip this table entry */
 			if (!func) {
 				i--;
 				one_slot += sizeof (struct slot_rt);
 				continue;
 			}
-			// this may not work and shouldn't be used
+			/* this may not work and shouldn't be used */
 			if (secondary_bus != primary_bus)
 				bridged_slot = 1;
 			else
@@ -1301,7 +1331,7 @@ int cpqhp_find_available_resources(struct controller *ctrl, void __iomem *rom_st
 		}
 
 
-		// If we've got a valid IO base, use it
+		/* If we've got a valid IO base, use it */
 
 		temp_dword = io_base + io_length;
 
@@ -1325,7 +1355,7 @@ int cpqhp_find_available_resources(struct controller *ctrl, void __iomem *rom_st
 			}
 		}
 
-		// If we've got a valid memory base, use it
+		/* If we've got a valid memory base, use it */
 		temp_dword = mem_base + mem_length;
 		if ((mem_base) && (temp_dword < 0x10000)) {
 			mem_node = kmalloc(sizeof(*mem_node), GFP_KERNEL);
@@ -1348,8 +1378,9 @@ int cpqhp_find_available_resources(struct controller *ctrl, void __iomem *rom_st
 			}
 		}
 
-		// If we've got a valid prefetchable memory base, and
-		// the base + length isn't greater than 0xFFFF
+		/* If we've got a valid prefetchable memory base, and
+		 * the base + length isn't greater than 0xFFFF
+		 */
 		temp_dword = pre_mem_base + pre_mem_length;
 		if ((pre_mem_base) && (temp_dword < 0x10000)) {
 			p_mem_node = kmalloc(sizeof(*p_mem_node), GFP_KERNEL);
@@ -1372,9 +1403,10 @@ int cpqhp_find_available_resources(struct controller *ctrl, void __iomem *rom_st
 			}
 		}
 
-		// If we've got a valid bus number, use it
-		// The second condition is to ignore bus numbers on
-		// populated slots that don't have PCI-PCI bridges
+		/* If we've got a valid bus number, use it
+		 * The second condition is to ignore bus numbers on
+		 * populated slots that don't have PCI-PCI bridges
+		 */
 		if (secondary_bus && (secondary_bus != primary_bus)) {
 			bus_node = kmalloc(sizeof(*bus_node), GFP_KERNEL);
 			if (!bus_node)
@@ -1398,8 +1430,9 @@ int cpqhp_find_available_resources(struct controller *ctrl, void __iomem *rom_st
 		one_slot += sizeof (struct slot_rt);
 	}
 
-	// If all of the following fail, we don't have any resources for
-	// hot plug add
+	/* If all of the following fail, we don't have any resources for
+	 * hot plug add
+	 */
 	rc = 1;
 	rc &= cpqhp_resource_sort_and_combine(&(ctrl->mem_head));
 	rc &= cpqhp_resource_sort_and_combine(&(ctrl->p_mem_head));


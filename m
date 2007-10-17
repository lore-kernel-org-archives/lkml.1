Return-Path: <linux-kernel-owner+w=401wt.eu-S935755AbXJQByW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935755AbXJQByW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 21:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761543AbXJQByM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 21:54:12 -0400
Received: from rtr.ca ([76.10.145.34]:3425 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758017AbXJQByK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 21:54:10 -0400
Message-ID: <47156B40.4060006@rtr.ca>
Date: Tue, 16 Oct 2007 21:54:08 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>, pcihpd-discuss@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 1/4] Fix PCIe hotplug for non-ACPI ExpressCard slots (version
 2)
References: <4714C0A6.1030204@rtr.ca> <4714D700.7060008@rtr.ca> <20071016084634.8a0d695a.kristen.c.accardi@intel.com> <47150565.5090102@rtr.ca> <20071016114328.a96e8bcb.kristen.c.accardi@intel.com> <47150982.6050102@rtr.ca> <471509FE.7080505@rtr.ca> <47151191.40406@rtr.ca> <20071016130757.ed2f2ce4.kristen.c.accardi@intel.com> <4715217D.2000803@rtr.ca> <20071016214143.GC21815@kroah.com> <471533AF.60100@rtr.ca> <47156B14.2080608@rtr.ca>
In-Reply-To: <47156B14.2080608@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Whitespace and other cosmetic fixes so that checkpatch.pl
is happy with the remainder of patches in this series.

Signed-off-by: Mark Lord <mlord@pobox.com>
---
--- old/drivers/pci/hotplug/pciehp_core.c	2007-10-12 12:43:44.000000000 -0400
+++ linux/drivers/pci/hotplug/pciehp_core.c	2007-10-16 21:14:03.000000000 -0400
@@ -470,9 +470,11 @@
 
 	t_slot = pciehp_find_slot(ctrl, ctrl->slot_device_offset);
 
-	t_slot->hpc_ops->get_adapter_status(t_slot, &value); /* Check if slot is occupied */
+	/* Check if slot is occupied */
+	t_slot->hpc_ops->get_adapter_status(t_slot, &value);
 	if ((POWER_CTRL(ctrl->ctrlcap)) && !value) {
-		rc = t_slot->hpc_ops->power_off_slot(t_slot); /* Power off slot if not occupied*/
+		/* Power off slot if not occupied*/
+		rc = t_slot->hpc_ops->power_off_slot(t_slot);
 		if (rc)
 			goto err_out_free_ctrl_slot;
 	}
--- old/drivers/pci/hotplug/pciehp_ctrl.c	2007-10-16 21:12:54.000000000 -0400
+++ linux/drivers/pci/hotplug/pciehp_ctrl.c	2007-10-16 21:08:18.000000000 -0400
@@ -520,7 +520,7 @@
 	case INT_PRESENCE_OFF:
 		if (!HP_SUPR_RM(ctrl->ctrlcap))
 			break;
-		dbg("Surprise Removal\n");
+		dbg("Surprise Event\n");
 		update_slot_info(p_slot);
 		handle_surprise_event(p_slot);
 		break;
--- old/drivers/pci/hotplug/pciehp_hpc.c	2007-10-16 21:12:54.000000000 -0400
+++ linux/drivers/pci/hotplug/pciehp_hpc.c	2007-10-16 21:13:32.000000000 -0400
@@ -160,10 +160,10 @@
 /* Link Width Encoding */
 #define LNK_X1		0x01
 #define LNK_X2		0x02
-#define LNK_X4		0x04	
+#define LNK_X4		0x04
 #define LNK_X8		0x08
 #define LNK_X12		0x0C
-#define LNK_X16		0x10	
+#define LNK_X16		0x10
 #define LNK_X32		0x20
 
 /*Field definitions of Link Status Register */
@@ -289,7 +289,7 @@
 	u16 slot_ctrl;
 	unsigned long flags;
 
-	DBG_ENTER_ROUTINE 
+	DBG_ENTER_ROUTINE
 
 	mutex_lock(&ctrl->ctrl_lock);
 
@@ -299,7 +299,7 @@
 		goto out;
 	}
 
-	if ((slot_status & CMD_COMPLETED) == CMD_COMPLETED ) { 
+	if ((slot_status & CMD_COMPLETED) == CMD_COMPLETED) {
 		/* After 1 sec and CMD_COMPLETED still not set, just
 		   proceed forward to issue the next command according
 		   to spec.  Just print out the error message */
@@ -332,7 +332,7 @@
 		retval = pcie_wait_cmd(ctrl);
  out:
 	mutex_unlock(&ctrl->ctrl_lock);
-	DBG_LEAVE_ROUTINE 
+	DBG_LEAVE_ROUTINE
 	return retval;
 }
 
@@ -341,7 +341,7 @@
 	u16 lnk_status;
 	int retval = 0;
 
-	DBG_ENTER_ROUTINE 
+	DBG_ENTER_ROUTINE
 
 	retval = pciehp_readw(ctrl, LNKSTATUS, &lnk_status);
 	if (retval) {
@@ -350,14 +350,14 @@
 	}
 
 	dbg("%s: lnk_status = %x\n", __FUNCTION__, lnk_status);
-	if ( (lnk_status & LNK_TRN) || (lnk_status & LNK_TRN_ERR) || 
+	if ((lnk_status & LNK_TRN) || (lnk_status & LNK_TRN_ERR) ||
 		!(lnk_status & NEG_LINK_WD)) {
 		err("%s : Link Training Error occurs \n", __FUNCTION__);
 		retval = -1;
 		return retval;
 	}
 
-	DBG_LEAVE_ROUTINE 
+	DBG_LEAVE_ROUTINE
 	return retval;
 }
 
@@ -368,8 +368,8 @@
 	u16 slot_ctrl;
 	u8 atten_led_state;
 	int retval = 0;
-	
-	DBG_ENTER_ROUTINE 
+
+	DBG_ENTER_ROUTINE
 
 	retval = pciehp_readw(ctrl, SLOTCTRL, &slot_ctrl);
 	if (retval) {
@@ -400,7 +400,7 @@
 		break;
 	}
 
-	DBG_LEAVE_ROUTINE 
+	DBG_LEAVE_ROUTINE
 	return 0;
 }
 
@@ -410,8 +410,8 @@
 	u16 slot_ctrl;
 	u8 pwr_state;
 	int	retval = 0;
-	
-	DBG_ENTER_ROUTINE 
+
+	DBG_ENTER_ROUTINE
 
 	retval = pciehp_readw(ctrl, SLOTCTRL, &slot_ctrl);
 	if (retval) {
@@ -428,14 +428,14 @@
 		*status = 1;
 		break;
 	case 1:
-		*status = 0;	
+		*status = 0;
 		break;
 	default:
 		*status = 0xFF;
 		break;
 	}
 
-	DBG_LEAVE_ROUTINE 
+	DBG_LEAVE_ROUTINE
 	return retval;
 }
 
@@ -446,7 +446,7 @@
 	u16 slot_status;
 	int retval = 0;
 
-	DBG_ENTER_ROUTINE 
+	DBG_ENTER_ROUTINE
 
 	retval = pciehp_readw(ctrl, SLOTSTATUS, &slot_status);
 	if (retval) {
@@ -454,9 +454,9 @@
 		return retval;
 	}
 
-	*status = (((slot_status & MRL_STATE) >> 5) == 0) ? 0 : 1;  
+	*status = (((slot_status & MRL_STATE) >> 5) == 0) ? 0 : 1;
 
-	DBG_LEAVE_ROUTINE 
+	DBG_LEAVE_ROUTINE
 	return 0;
 }
 
@@ -467,7 +467,7 @@
 	u8 card_state;
 	int retval = 0;
 
-	DBG_ENTER_ROUTINE 
+	DBG_ENTER_ROUTINE
 
 	retval = pciehp_readw(ctrl, SLOTSTATUS, &slot_status);
 	if (retval) {
@@ -477,7 +477,7 @@
 	card_state = (u8)((slot_status & PRSN_STATE) >> 6);
 	*status = (card_state == 1) ? 1 : 0;
 
-	DBG_LEAVE_ROUTINE 
+	DBG_LEAVE_ROUTINE
 	return 0;
 }
 
@@ -488,7 +488,7 @@
 	u8 pwr_fault;
 	int retval = 0;
 
-	DBG_ENTER_ROUTINE 
+	DBG_ENTER_ROUTINE
 
 	retval = pciehp_readw(ctrl, SLOTSTATUS, &slot_status);
 	if (retval) {
@@ -496,7 +496,7 @@
 		return retval;
 	}
 	pwr_fault = (u8)((slot_status & PWR_FAULT_DETECTED) >> 1);
-	
+
 	DBG_LEAVE_ROUTINE
 	return pwr_fault;
 }
@@ -572,7 +572,7 @@
 	rc = pcie_write_cmd(slot, slot_cmd, cmd_mask);
 	dbg("%s: SLOTCTRL %x write cmd %x\n",
 	    __FUNCTION__, ctrl->cap_base + SLOTCTRL, slot_cmd);
-	
+
 	DBG_LEAVE_ROUTINE
 	return rc;
 }
@@ -583,7 +583,7 @@
 	struct controller *ctrl = slot->ctrl;
 	u16 slot_cmd;
 	u16 cmd_mask;
-       	
+
 	DBG_ENTER_ROUTINE
 
 	slot_cmd = 0x0100;
@@ -629,7 +629,7 @@
 	struct controller *ctrl = slot->ctrl;
 	u16 slot_cmd;
 	u16 cmd_mask;
-	
+
 	DBG_ENTER_ROUTINE
 
 	slot_cmd = 0x0200;
@@ -649,7 +649,7 @@
 
 static void hpc_release_ctlr(struct controller *ctrl)
 {
-	DBG_ENTER_ROUTINE 
+	DBG_ENTER_ROUTINE
 
 	if (pciehp_poll_mode)
 		del_timer(&ctrl->poll_timer);
@@ -674,7 +674,7 @@
 	u16 slot_status;
 	int retval = 0;
 
-	DBG_ENTER_ROUTINE 
+	DBG_ENTER_ROUTINE
 
 	dbg("%s: slot->hp_slot %x\n", __FUNCTION__, slot->hp_slot);
 
@@ -731,7 +731,7 @@
 	u16 cmd_mask;
 	int retval = 0;
 
-	DBG_ENTER_ROUTINE 
+	DBG_ENTER_ROUTINE
 
 	dbg("%s: slot->hp_slot %x\n", __FUNCTION__, slot->hp_slot);
 
@@ -825,7 +825,7 @@
 		}
 		dbg("%s: pciehp_readw(SLOTSTATUS) with value %x\n",
 		    __FUNCTION__, slot_status);
-		
+
 		/* Clear command complete interrupt caused by this write */
 		temp_word = 0x1f;
 		rc = pciehp_writew(ctrl, SLOTSTATUS, temp_word);
@@ -835,10 +835,10 @@
 			return IRQ_NONE;
 		}
 	}
-	
+
 	if (intr_loc & CMD_COMPLETED) {
-		/* 
-		 * Command Complete Interrupt Pending 
+		/*
+		 * Command Complete Interrupt Pending
 		 */
 		ctrl->cmd_busy = 0;
 		wake_up_interruptible(&ctrl->queue);
@@ -892,7 +892,7 @@
 			    __FUNCTION__);
 			return IRQ_NONE;
 		}
-		
+
 		/* Clear command complete interrupt caused by this write */
 		temp_word = 0x1F;
 		rc = pciehp_writew(ctrl, SLOTSTATUS, temp_word);
@@ -904,7 +904,7 @@
 		dbg("%s: pciehp_writew(SLOTSTATUS) with value %x\n",
 		    __FUNCTION__, temp_word);
 	}
-	
+
 	return IRQ_HANDLED;
 }
 
@@ -915,7 +915,7 @@
 	u32	lnk_cap;
 	int retval = 0;
 
-	DBG_ENTER_ROUTINE 
+	DBG_ENTER_ROUTINE
 
 	retval = pciehp_readl(ctrl, LNKCAP, &lnk_cap);
 	if (retval) {
@@ -934,7 +934,7 @@
 
 	*value = lnk_speed;
 	dbg("Max link speed = %d\n", lnk_speed);
-	DBG_LEAVE_ROUTINE 
+	DBG_LEAVE_ROUTINE
 	return retval;
 }
 
@@ -945,7 +945,7 @@
 	u32	lnk_cap;
 	int retval = 0;
 
-	DBG_ENTER_ROUTINE 
+	DBG_ENTER_ROUTINE
 
 	retval = pciehp_readl(ctrl, LNKCAP, &lnk_cap);
 	if (retval) {
@@ -985,7 +985,7 @@
 
 	*value = lnk_wdth;
 	dbg("Max link width = %d\n", lnk_wdth);
-	DBG_LEAVE_ROUTINE 
+	DBG_LEAVE_ROUTINE
 	return retval;
 }
 
@@ -996,7 +996,7 @@
 	int retval = 0;
 	u16 lnk_status;
 
-	DBG_ENTER_ROUTINE 
+	DBG_ENTER_ROUTINE
 
 	retval = pciehp_readw(ctrl, LNKSTATUS, &lnk_status);
 	if (retval) {
@@ -1015,7 +1015,7 @@
 
 	*value = lnk_speed;
 	dbg("Current link speed = %d\n", lnk_speed);
-	DBG_LEAVE_ROUTINE 
+	DBG_LEAVE_ROUTINE
 	return retval;
 }
 
@@ -1026,14 +1026,14 @@
 	int retval = 0;
 	u16 lnk_status;
 
-	DBG_ENTER_ROUTINE 
+	DBG_ENTER_ROUTINE
 
 	retval = pciehp_readw(ctrl, LNKSTATUS, &lnk_status);
 	if (retval) {
 		err("%s: Cannot read LNKSTATUS register\n", __FUNCTION__);
 		return retval;
 	}
-	
+
 	switch ((lnk_status & 0x03F0) >> 4){
 	case 0:
 		lnk_wdth = PCIE_LNK_WIDTH_RESRV;
@@ -1066,7 +1066,7 @@
 
 	*value = lnk_wdth;
 	dbg("Current link width = %d\n", lnk_wdth);
-	DBG_LEAVE_ROUTINE 
+	DBG_LEAVE_ROUTINE
 	return retval;
 }
 
@@ -1085,12 +1085,12 @@
 	.get_cur_bus_speed		= hpc_get_cur_lnk_speed,
 	.get_max_lnk_width		= hpc_get_max_lnk_width,
 	.get_cur_lnk_width		= hpc_get_cur_lnk_width,
-	
+
 	.query_power_fault		= hpc_query_power_fault,
 	.green_led_on			= hpc_set_green_led_on,
 	.green_led_off			= hpc_set_green_led_off,
 	.green_led_blink		= hpc_set_green_led_blink,
-	
+
 	.release_ctlr			= hpc_release_ctlr,
 	.check_lnk_status		= hpc_check_lnk_status,
 };
@@ -1163,9 +1163,7 @@
 }
 #endif
 
-
-
-int pcie_init(struct controller * ctrl, struct pcie_device *dev)
+int pcie_init(struct controller *ctrl, struct pcie_device *dev)
 {
 	int rc;
 	u16 temp_word;
@@ -1177,7 +1175,7 @@
 	struct pci_dev *pdev;
 
 	DBG_ENTER_ROUTINE
-	
+
 	pdev = dev->port;
 	ctrl->pci_dev = pdev;	/* save pci_dev in context */
 
@@ -1201,9 +1199,11 @@
 	dbg("%s: CAPREG offset %x cap_reg %x\n",
 	    __FUNCTION__, ctrl->cap_base + CAPREG, cap_reg);
 
-	if (((cap_reg & SLOT_IMPL) == 0) || (((cap_reg & DEV_PORT_TYPE) != 0x0040)
+	if (((cap_reg & SLOT_IMPL) == 0)
+		|| (((cap_reg & DEV_PORT_TYPE) != 0x0040)
 		&& ((cap_reg & DEV_PORT_TYPE) != 0x0060))) {
-		dbg("%s : This is not a root port or the port is not connected to a slot\n", __FUNCTION__);
+		dbg("%s : This is not a root port"
+		" or the port is not connected to a slot\n", __FUNCTION__);
 		goto abort_free_ctlr;
 	}
 
@@ -1242,7 +1242,8 @@
 			    (unsigned long long)pci_resource_start(pdev, rc),
 			    (unsigned long long)pci_resource_len(pdev, rc));
 
-	info("HPC vendor_id %x device_id %x ss_vid %x ss_did %x\n", pdev->vendor, pdev->device, 
+	info("HPC vendor_id %x device_id %x ss_vid %x"
+		" ss_did %x\n", pdev->vendor, pdev->device,
 		pdev->subsystem_vendor, pdev->subsystem_device);
 
 	mutex_init(&ctrl->crit_sect);
@@ -1267,7 +1268,7 @@
 
 	dbg("%s: SLOTCTRL %x value read %x\n",
 	    __FUNCTION__, ctrl->cap_base + SLOTCTRL, temp_word);
-	temp_word = (temp_word & ~HP_INTR_ENABLE & ~CMD_CMPL_INTR_ENABLE) | 0x00;
+	temp_word = (temp_word & ~HP_INTR_ENABLE & ~CMD_CMPL_INTR_ENABLE)|0x00;
 
 	rc = pciehp_writew(ctrl, SLOTCTRL, temp_word);
 	if (rc) {
@@ -1330,14 +1331,14 @@
 
 	if (ATTN_BUTTN(slot_cap))
 		intr_enable = intr_enable | ATTN_BUTTN_ENABLE;
-	
+
 	if (POWER_CTRL(slot_cap))
 		intr_enable = intr_enable | PWR_FAULT_DETECT_ENABLE;
-	
+
 	if (MRL_SENS(slot_cap))
 		intr_enable = intr_enable | MRL_DETECT_ENABLE;
 
-	temp_word = (temp_word & ~intr_enable) | intr_enable; 
+	temp_word = (temp_word & ~intr_enable) | intr_enable;
 
 	if (pciehp_poll_mode) {
 		temp_word = (temp_word & ~HP_INTR_ENABLE) | 0x0;
@@ -1345,7 +1346,7 @@
 		temp_word = (temp_word & ~HP_INTR_ENABLE) | HP_INTR_ENABLE;
 	}
 
-	/* Unmask Hot-plug Interrupt Enable for the interrupt notification mechanism case */
+	/* Unmask Hotplug Intr Enable for intr notification mechanism case */
 	rc = pciehp_writew(ctrl, SLOTCTRL, temp_word);
 	if (rc) {
 		err("%s: Cannot write to SLOTCTRL register\n", __FUNCTION__);
@@ -1356,14 +1357,14 @@
 		err("%s: Cannot read SLOTSTATUS register\n", __FUNCTION__);
 		goto abort_disable_intr;
 	}
-	
+
 	temp_word =  0x1F; /* Clear all events */
 	rc = pciehp_writew(ctrl, SLOTSTATUS, temp_word);
 	if (rc) {
 		err("%s: Cannot write to SLOTSTATUS register\n", __FUNCTION__);
 		goto abort_disable_intr;
 	}
-	
+
 	if (pciehp_force) {
 		dbg("Bypassing BIOS check for pciehp use on %s\n",
 				pci_name(ctrl->pci_dev));

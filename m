Return-Path: <linux-kernel-owner+w=401wt.eu-S1762694AbZCaPZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762694AbZCaPZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 11:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762263AbZCaPXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 11:23:34 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:42738 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762252AbZCaPXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 11:23:33 -0400
Subject: [PATCH 05/15] PCI Hotplug: cpqphp: eliminate stray braces
To: jbarnes@virtuousgeek.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 31 Mar 2009 09:23:31 -0600
Message-ID: <20090331152331.26622.37460.stgit@bob.kio>
In-Reply-To: <20090331150158.26622.45423.stgit@bob.kio>
References: <20090331150158.26622.45423.stgit@bob.kio>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up style and eliminate superfluous braces and parens.

No functional change.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/hotplug/cpqphp_core.c |   55 +++++++++++++++----------------------
 1 files changed, 22 insertions(+), 33 deletions(-)

diff --git a/drivers/pci/hotplug/cpqphp_core.c b/drivers/pci/hotplug/cpqphp_core.c
index f05ea7a..195c8c9 100644
--- a/drivers/pci/hotplug/cpqphp_core.c
+++ b/drivers/pci/hotplug/cpqphp_core.c
@@ -154,7 +154,6 @@ static int init_SERR(struct controller * ctrl)
 	return 0;
 }
 
-
 /* nice debugging output */
 static int pci_print_IRQ_route (void)
 {
@@ -214,7 +213,7 @@ static void __iomem *get_subsequent_smbios_entry(void __iomem *smbios_start,
 	void __iomem *p_max;
 
 	if (!smbios_table || !curr)
-		return(NULL);
+		return NULL;
 
 	/* set p_max to the end of the table */
 	p_max = smbios_start + readw(smbios_table + ST_LENGTH);
@@ -227,19 +226,17 @@ static void __iomem *get_subsequent_smbios_entry(void __iomem *smbios_start,
 		 * The first condition is the previous byte
 		 * and the second is the curr
 		 */
-		if (!previous_byte && !(readb(p_temp))) {
+		if (!previous_byte && !(readb(p_temp)))
 			bail = 1;
-		}
 
 		previous_byte = readb(p_temp);
 		p_temp++;
 	}
 
-	if (p_temp < p_max) {
+	if (p_temp < p_max)
 		return p_temp;
-	} else {
+	else
 		return NULL;
-	}
 }
 
 
@@ -265,21 +262,18 @@ static void __iomem *get_SMBIOS_entry(void __iomem *smbios_start,
 	if (!smbios_table)
 		return NULL;
 
-	if (!previous) {
+	if (!previous)
 		previous = smbios_start;
-	} else {
+	else
 		previous = get_subsequent_smbios_entry(smbios_start,
 					smbios_table, previous);
-	}
 
-	while (previous) {
-		if (readb(previous + SMBIOS_GENERIC_TYPE) != type) {
+	while (previous)
+		if (readb(previous + SMBIOS_GENERIC_TYPE) != type)
 			previous = get_subsequent_smbios_entry(smbios_start,
 						smbios_table, previous);
-		} else {
+		else
 			break;
-		}
-	}
 
 	return previous;
 }
@@ -319,7 +313,7 @@ static int ctrl_slot_cleanup (struct controller * ctrl)
 	release_mem_region(pci_resource_start(ctrl->pci_dev, 0),
 			   pci_resource_len(ctrl->pci_dev, 0));
 
-	return(0);
+	return 0;
 }
 
 
@@ -388,9 +382,8 @@ get_slot_mapping(struct pci_bus *bus, u8 bus_num, u8 dev_num, u8 *slot)
 							PCI_DEVFN(tdevice, 0),
 							PCI_PRIMARY_BUS, &work);
 				// See if bridge's secondary bus matches target bus.
-				if (((work >> 8) & 0x000000FF) == (long) bus_num) {
+				if (((work >> 8) & 0x000000FF) == (long) bus_num)
 					bridgeSlot = tslot;
-				}
 			}
 		}
 
@@ -425,21 +418,21 @@ cpqhp_set_attention_status(struct controller *ctrl, struct pci_func *func,
 	u8 hp_slot;
 
 	if (func == NULL)
-		return(1);
+		return 1;
 
 	hp_slot = func->device - ctrl->slot_device_offset;
 
 	/* Wait for exclusive access to hardware */
 	mutex_lock(&ctrl->crit_sect);
 
-	if (status == 1) {
+	if (status == 1)
 		amber_LED_on (ctrl, hp_slot);
-	} else if (status == 0) {
+	else if (status == 0)
 		amber_LED_off (ctrl, hp_slot);
-	} else {
+	else {
 		/* Done with exclusive hardware access */
 		mutex_unlock(&ctrl->crit_sect);
-		return(1);
+		return 1;
 	}
 
 	set_SOGO(ctrl);
@@ -450,7 +443,7 @@ cpqhp_set_attention_status(struct controller *ctrl, struct pci_func *func,
 	/* Done with exclusive hardware access */
 	mutex_unlock(&ctrl->crit_sect);
 
-	return(0);
+	return 0;
 }
 
 
@@ -678,8 +671,7 @@ static int ctrl_slot_setup(struct controller *ctrl,
 			goto error_slot;
 		hotplug_slot = slot->hotplug_slot;
 
-		hotplug_slot->info =
-				kzalloc(sizeof(*(hotplug_slot->info)),
+		hotplug_slot->info = kzalloc(sizeof(*(hotplug_slot->info)),
 							GFP_KERNEL);
 		if (!hotplug_slot->info)
 			goto error_hpslot;
@@ -801,9 +793,8 @@ static int one_time_init(void)
 		goto error;
 
 	dbg("Initialize slot lists\n");
-	for (loop = 0; loop < 256; loop++) {
+	for (loop = 0; loop < 256; loop++)
 		cpqhp_slot_list[loop] = NULL;
-	}
 
 	/* FIXME: We also need to hook the NMI handler eventually.
 	 * this also needs to be worked with Christoph
@@ -1306,18 +1297,16 @@ static int cpqhpc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		func->presence_save = (temp_word >> hp_slot) & 0x01;
 		func->presence_save |= (temp_word >> (hp_slot + 7)) & 0x02;
 
-		if (ctrl->ctrl_int_comp & (0x1L << hp_slot)) {
+		if (ctrl->ctrl_int_comp & (0x1L << hp_slot))
 			func->switch_save = 0;
-		} else {
+		else
 			func->switch_save = 0x10;
-		}
 
-		if (!power_mode) {
+		if (!power_mode)
 			if (!func->is_a_board) {
 				green_LED_off(ctrl, hp_slot);
 				slot_disable(ctrl, hp_slot);
 			}
-		}
 
 		device++;
 		num_of_slots--;


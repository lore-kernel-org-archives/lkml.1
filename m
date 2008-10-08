Return-Path: <linux-kernel-owner+w=401wt.eu-S1755274AbYJHGjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbYJHGjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 02:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbYJHGix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 02:38:53 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43789 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461AbYJHGiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 02:38:51 -0400
Message-ID: <48EC5502.1020707@jp.fujitsu.com>
Date: Wed, 08 Oct 2008 15:36:50 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>
CC: jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com, matthew@wil.cx,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [03/03] Sample patch for [PATCH v4 14/15]
References: <20081003230125.9989.31145.stgit@bob.kio> <48EC53D3.9020203@jp.fujitsu.com>
In-Reply-To: <48EC53D3.9020203@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed because previous two patches make your [PATCH v4
14/15] can not be applied.

---

 drivers/pci/hotplug/pci_hotplug_core.c |    6 +++---
 include/linux/pci_hotplug.h            |    3 ---
 2 files changed, 3 insertions(+), 6 deletions(-)

Index: hotplug/drivers/pci/hotplug/pci_hotplug_core.c
===================================================================
--- hotplug.orig/drivers/pci/hotplug/pci_hotplug_core.c
+++ hotplug/drivers/pci/hotplug/pci_hotplug_core.c
@@ -533,7 +533,7 @@ static struct hotplug_slot *get_slot_fro
 
 	list_for_each (tmp, &pci_hotplug_slot_list) {
 		slot = list_entry (tmp, struct hotplug_slot, slot_list);
-		if (strcmp(slot->name, name) == 0)
+		if (strcmp(hotplug_slot_name(slot), name) == 0)
 			return slot;
 	}
 	return NULL;
@@ -623,7 +623,7 @@ int pci_hp_deregister(struct hotplug_slo
 		return -ENODEV;
 
 	mutex_lock(&pci_hp_mutex);
-	temp = get_slot_from_name(hotplug->name);
+	temp = get_slot_from_name(hotplug_slot_name(hotplug));
 	if (temp != hotplug) {
 		mutex_unlock(&pci_hp_mutex);
 		return -ENODEV;
@@ -633,7 +633,7 @@ int pci_hp_deregister(struct hotplug_slo
 
 	slot = hotplug->pci_slot;
 	fs_remove_slot(slot);
-	dbg("Removed slot %s from the list\n", hotplug->name);
+	dbg("Removed slot %s from the list\n", hotplug_slot_name(hotplug));
 
 	hotplug->release(hotplug);
 	slot->hotplug = NULL;
Index: hotplug/include/linux/pci_hotplug.h
===================================================================
--- hotplug.orig/include/linux/pci_hotplug.h
+++ hotplug/include/linux/pci_hotplug.h
@@ -142,8 +142,6 @@ struct hotplug_slot_info {
 
 /**
  * struct hotplug_slot - used to register a physical slot with the hotplug pci core
- * @name: the name of the slot being registered.  This string must
- * be unique amoung slots registered on this system.
  * @ops: pointer to the &struct hotplug_slot_ops to be used for this slot
  * @info: pointer to the &struct hotplug_slot_info for the initial values for
  * this slot.
@@ -153,7 +151,6 @@ struct hotplug_slot_info {
  * needs.
  */
 struct hotplug_slot {
-	char				*name;
 	struct hotplug_slot_ops		*ops;
 	struct hotplug_slot_info	*info;
 	void (*release) (struct hotplug_slot *slot);



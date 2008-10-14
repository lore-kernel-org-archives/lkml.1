Return-Path: <linux-kernel-owner+w=401wt.eu-S1758959AbYJNH1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758959AbYJNH1f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 03:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757807AbYJNHZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 03:25:36 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:31146 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757779AbYJNHZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 03:25:34 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v6-resend 06/17] PCI, PCI Hotplug: introduce slot_name helpers
To: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com, matthew@wil.cx,
       kaneshige.kenji@jp.fujitsu.com, Alex Chiang <achiang@hp.com>
Date: Tue, 14 Oct 2008 01:25:32 -0600
Message-ID: <20081014072532.24319.69966.stgit@bob.kio>
In-Reply-To: <20081014072311.24319.27334.stgit@bob.kio>
References: <20081014072311.24319.27334.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for cleaning up the various hotplug drivers
such that they don't have to manage their own 'name' parameters
anymore, we provide the following convenience functions:

	pci_slot_name()
	hotplug_slot_name()

These helpers will be used by individual hotplug drivers.

Cc: jbarnes@virtuousgeek.org
Cc: kristen.c.accardi@intel.com
Cc: matthew@wil.cx
Cc: kaneshige.kenji@jp.fujitsu.com
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/slot.c          |    2 +-
 include/linux/pci.h         |    5 +++++
 include/linux/pci_hotplug.h |    5 +++++
 3 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/slot.c b/drivers/pci/slot.c
index b6ee352..4dd1c3e 100644
--- a/drivers/pci/slot.c
+++ b/drivers/pci/slot.c
@@ -121,7 +121,7 @@ static int rename_slot(struct pci_slot *slot, const char *name)
 	int result = 0;
 	char *slot_name;
 
-	if (strcmp(kobject_name(&slot->kobj), name) == 0)
+	if (strcmp(pci_slot_name(slot), name) == 0)
 		return result;
 
 	slot_name = make_slot_name(name);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 7150898..29e58ee 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -64,6 +64,11 @@ struct pci_slot {
 	struct kobject kobj;
 };
 
+static inline const char *pci_slot_name(const struct pci_slot *slot)
+{
+	return kobject_name(&slot->kobj);
+}
+
 /* File state for mmap()s on /proc/bus/pci/X/Y */
 enum pci_mmap_state {
 	pci_mmap_io,
diff --git a/include/linux/pci_hotplug.h b/include/linux/pci_hotplug.h
index 5efba66..a3a3245 100644
--- a/include/linux/pci_hotplug.h
+++ b/include/linux/pci_hotplug.h
@@ -165,6 +165,11 @@ struct hotplug_slot {
 };
 #define to_hotplug_slot(n) container_of(n, struct hotplug_slot, kobj)
 
+static inline const char *hotplug_slot_name(const struct hotplug_slot *slot)
+{
+	return pci_slot_name(slot->pci_slot);
+}
+
 extern int pci_hp_register(struct hotplug_slot *, struct pci_bus *, int nr,
 			   const char *name);
 extern int pci_hp_deregister(struct hotplug_slot *slot);


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756336AbYIIKB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336AbYIIKB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 06:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbYIIKAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 06:00:19 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:19978 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbYIIKAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 06:00:18 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v2 03/13] PCI, PCI Hotplug: introduce slot_name helpers
To: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com, matthew@wil.cx,
       kaneshige.kenji@jp.fujitsu.com, Alex Chiang <achiang@hp.com>
Date: Tue, 09 Sep 2008 04:00:17 -0600
Message-ID: <20080909100017.29542.2802.stgit@bob.kio>
In-Reply-To: <20080909091813.29542.85613.stgit@bob.kio>
References: <20080909091813.29542.85613.stgit@bob.kio>
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

 include/linux/pci.h         |    5 +++++
 include/linux/pci_hotplug.h |    5 +++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index fd6efbc..bd259c3 100644
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
index 303834b..7184bee 100644
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
 extern int pci_hp_register(struct hotplug_slot *,
 			   struct pci_bus *,
 			   int nr,


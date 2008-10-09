Return-Path: <linux-kernel-owner+w=401wt.eu-S1757673AbYJIEsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757673AbYJIEsI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 00:48:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757849AbYJIEq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 00:46:57 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:43120 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758502AbYJIEq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 00:46:56 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v5 05/16] PCI, PCI Hotplug: introduce slot_name helpers
To: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com, matthew@wil.cx,
       kaneshige.kenji@jp.fujitsu.com, Alex Chiang <achiang@hp.com>
Date: Wed, 08 Oct 2008 22:46:54 -0600
Message-ID: <20081009044654.8678.27619.stgit@bob.kio>
In-Reply-To: <20081009043140.8678.44164.stgit@bob.kio>
References: <20081009043140.8678.44164.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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
index aa49fb9..4e07c3f 100644
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


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756933AbYLCUDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933AbYLCUDI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:03:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbYLCTw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:52:29 -0500
Received: from kroah.org ([198.145.64.141]:59862 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754936AbYLCTw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:52:27 -0500
Date: Wed, 3 Dec 2008 11:50:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, kristen.c.accardi@intel.com, matthew@wil.cx,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Alex Chiang <achiang@hp.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [patch 032/104] PCI, PCI Hotplug: introduce slot_name helpers
Message-ID: <20081203195052.GG8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="pci-pci-hotplug-introduce-slot_name-helpers.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alex Chiang <achiang@hp.com>

commit 0ad772ec464d3fcf9d210836b97e654f393606c4 upstream

In preparation for cleaning up the various hotplug drivers
such that they don't have to manage their own 'name' parameters
anymore, we provide the following convenience functions:

	pci_slot_name()
	hotplug_slot_name()

These helpers will be used by individual hotplug drivers.

Cc: kristen.c.accardi@intel.com
Cc: matthew@wil.cx
Acked-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/slot.c          |    2 +-
 include/linux/pci.h         |    5 +++++
 include/linux/pci_hotplug.h |    5 +++++
 3 files changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/pci/slot.c
+++ b/drivers/pci/slot.c
@@ -116,7 +116,7 @@ static int rename_slot(struct pci_slot *
 	int result = 0;
 	char *slot_name;
 
-	if (strcmp(kobject_name(&slot->kobj), name) == 0)
+	if (strcmp(pci_slot_name(slot), name) == 0)
 		return result;
 
 	slot_name = make_slot_name(name);
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


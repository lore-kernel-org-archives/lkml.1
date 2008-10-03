Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbYJCXVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbYJCXVT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 19:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbYJCXSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 19:18:25 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:7583 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552AbYJCXSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 19:18:24 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v4 11/15] PCI: rpaphp: kmalloc/kfree slot->name directly
To: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Alex Chiang <achiang@hp.com>
Date: Fri, 03 Oct 2008 17:18:23 -0600
Message-ID: <20081003231823.9989.50968.stgit@bob.kio>
In-Reply-To: <20081003230125.9989.31145.stgit@bob.kio>
References: <20081003230125.9989.31145.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rpaphp tends to use slot->name directly everywhere, and doesn't
ever need slot->hotplug_slot->name.

struct hotplug_slot->name is going away, so convert rpaphp directly
manipulate its own slot->name everywhere, and don't bother touching
slot->hotplug_slot->name.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/hotplug/rpaphp_slot.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/hotplug/rpaphp_slot.c b/drivers/pci/hotplug/rpaphp_slot.c
index 736d3b4..7297e85 100644
--- a/drivers/pci/hotplug/rpaphp_slot.c
+++ b/drivers/pci/hotplug/rpaphp_slot.c
@@ -43,7 +43,7 @@ static void rpaphp_release_slot(struct hotplug_slot *hotplug_slot)
 void dealloc_slot_struct(struct slot *slot)
 {
 	kfree(slot->hotplug_slot->info);
-	kfree(slot->hotplug_slot->name);
+	kfree(slot->name);
 	kfree(slot->hotplug_slot);
 	kfree(slot);
 }
@@ -63,10 +63,9 @@ struct slot *alloc_slot_struct(struct device_node *dn,
 					   GFP_KERNEL);
 	if (!slot->hotplug_slot->info)
 		goto error_hpslot;
-	slot->hotplug_slot->name = kmalloc(strlen(drc_name) + 1, GFP_KERNEL);
-	if (!slot->hotplug_slot->name)
+	slot->name = kmalloc(strlen(drc_name) + 1, GFP_KERNEL);
+	if (!slot->name)
 		goto error_info;	
-	slot->name = slot->hotplug_slot->name;
 	strcpy(slot->name, drc_name);
 	slot->dn = dn;
 	slot->index = drc_index;


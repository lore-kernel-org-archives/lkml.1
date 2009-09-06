Return-Path: <linux-kernel-owner+w=401wt.eu-S1758031AbZIFQuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031AbZIFQuK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 12:50:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754898AbZIFQuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 12:50:09 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48863 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbZIFQuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 12:50:08 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 6 Sep 2009 18:49:48 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 3/6] firewire: core: header file cleanup
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, PaX Team <pageexec@freemail.hu>
In-Reply-To: <tkrat.85bb80d9295444c1@s5r6.in-berlin.de>
Message-ID: <tkrat.b2cb1d347fa2f9b2@s5r6.in-berlin.de>
References: <tkrat.85bb80d9295444c1@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fw_card_get, fw_card_put, fw_card_release are currently not exported for
use outside the firewire-core.  Move their definitions/ declarations
from the subsystem header file to the core header file.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core.h  |   14 ++++++++++++++
 include/linux/firewire.h |   14 --------------
 2 files changed, 14 insertions(+), 14 deletions(-)

Index: linux-2.6.31-rc9/drivers/firewire/core.h
===================================================================
--- linux-2.6.31-rc9.orig/drivers/firewire/core.h
+++ linux-2.6.31-rc9/drivers/firewire/core.h
@@ -96,6 +96,20 @@ int fw_core_initiate_bus_reset(struct fw
 int fw_compute_block_crc(u32 *block, gfp_t flags);
 void fw_schedule_bm_work(struct fw_card *card, unsigned long delay);
 
+static inline struct fw_card *fw_card_get(struct fw_card *card)
+{
+	kref_get(&card->kref);
+
+	return card;
+}
+
+void fw_card_release(struct kref *kref);
+
+static inline void fw_card_put(struct fw_card *card)
+{
+	kref_put(&card->kref, fw_card_release);
+}
+
 
 /* -cdev */
 
Index: linux-2.6.31-rc9/include/linux/firewire.h
===================================================================
--- linux-2.6.31-rc9.orig/include/linux/firewire.h
+++ linux-2.6.31-rc9/include/linux/firewire.h
@@ -134,20 +134,6 @@ struct fw_card {
 	u32 topology_map[(CSR_TOPOLOGY_MAP_END - CSR_TOPOLOGY_MAP) / 4];
 };
 
-static inline struct fw_card *fw_card_get(struct fw_card *card)
-{
-	kref_get(&card->kref);
-
-	return card;
-}
-
-void fw_card_release(struct kref *kref);
-
-static inline void fw_card_put(struct fw_card *card)
-{
-	kref_put(&card->kref, fw_card_release);
-}
-
 struct fw_attribute_group {
 	struct attribute_group *groups[2];
 	struct attribute_group group;

-- 
Stefan Richter
-=====-==--= =--= --==-
http://arcgraph.de/sr/


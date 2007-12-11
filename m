Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbXLKEef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbXLKEef (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 23:34:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbXLKEdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 23:33:16 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:39783 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850AbXLKEdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 23:33:14 -0500
Date: Tue, 11 Dec 2007 05:33:04 +0100 (MET)
From: Richard Knutsson <ricknu-0@student.ltu.se>
To: linux-pcmcia@lists.infradead.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       Richard Knutsson <ricknu-0@student.ltu.se>
Message-Id: <20071211043438.28518.66675.sendpatchset@thinktank.campus.ltu.se>
In-Reply-To: <20071211043412.28518.40867.sendpatchset@thinktank.campus.ltu.se>
References: <20071211043412.28518.40867.sendpatchset@thinktank.campus.ltu.se>
Subject: [PATCH 6/6] pcmcia/pcnet_cs: Fix 'shadow variable' warning
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing:
  CHECK   drivers/net/pcmcia/pcnet_cs.c
drivers/net/pcmcia/pcnet_cs.c:523:15: warning: symbol 'hw_info' shadows an earlier one
drivers/net/pcmcia/pcnet_cs.c:148:18: originally declared here

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---


diff --git a/drivers/net/pcmcia/pcnet_cs.c b/drivers/net/pcmcia/pcnet_cs.c
index db6a97d..5779344 100644
--- a/drivers/net/pcmcia/pcnet_cs.c
+++ b/drivers/net/pcmcia/pcnet_cs.c
@@ -520,7 +520,7 @@ static int pcnet_config(struct pcmcia_device *link)
     int i, last_ret, last_fn, start_pg, stop_pg, cm_offset;
     int has_shmem = 0;
     u_short buf[64];
-    hw_info_t *hw_info;
+    hw_info_t *local_hw_info;
     DECLARE_MAC_BUF(mac);
 
     DEBUG(0, "pcnet_config(0x%p)\n", link);
@@ -589,23 +589,23 @@ static int pcnet_config(struct pcmcia_device *link)
 	dev->if_port = 0;
     }
 
-    hw_info = get_hwinfo(link);
-    if (hw_info == NULL)
-	hw_info = get_prom(link);
-    if (hw_info == NULL)
-	hw_info = get_dl10019(link);
-    if (hw_info == NULL)
-	hw_info = get_ax88190(link);
-    if (hw_info == NULL)
-	hw_info = get_hwired(link);
-
-    if (hw_info == NULL) {
+    local_hw_info = get_hwinfo(link);
+    if (local_hw_info == NULL)
+	local_hw_info = get_prom(link);
+    if (local_hw_info == NULL)
+	local_hw_info = get_dl10019(link);
+    if (local_hw_info == NULL)
+	local_hw_info = get_ax88190(link);
+    if (local_hw_info == NULL)
+	local_hw_info = get_hwired(link);
+
+    if (local_hw_info == NULL) {
 	printk(KERN_NOTICE "pcnet_cs: unable to read hardware net"
 	       " address for io base %#3lx\n", dev->base_addr);
 	goto failed;
     }
 
-    info->flags = hw_info->flags;
+    info->flags = local_hw_info->flags;
     /* Check for user overrides */
     info->flags |= (delay_output) ? DELAY_OUTPUT : 0;
     if ((link->manf_id == MANFID_SOCKET) &&

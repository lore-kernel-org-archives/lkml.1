Return-Path: <linux-kernel-owner+w=401wt.eu-S1752622AbYJUOIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbYJUOIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 10:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751034AbYJUOIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 10:08:38 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:41014 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbYJUOIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 10:08:37 -0400
From: Jens Osterkamp <jens@linux.vnet.ibm.com>
To: Doug Thompson <dougthompson@xmission.com>
Subject: [PATCH] edac/cell: enable polling mode
Date: Tue, 21 Oct 2008 16:07:22 +0200
User-Agent: KMail/1.9.10
Cc: bluesmoke-devel@lists.sourceforge.net, benh@kernel.crashing.org,
       cbe-oss-dev@ozlabs.org, arnd@arndb.de, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200810211607.22600.jens@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

The edac driver on cell turned out to be not enabled because of a missing op_state.
This patch introduces it. Verified to work on top of Bens next branch.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Jens Osterkamp <jens@linux.vnet.ibm.com>

---

Ben, can you please confirm this is the patch you wanted to send upstream ?

Index: linux-2.6/drivers/edac/cell_edac.c
===================================================================
--- linux-2.6.orig/drivers/edac/cell_edac.c
+++ linux-2.6/drivers/edac/cell_edac.c
@@ -9,6 +9,7 @@
  */
 #undef DEBUG
 
+#include <linux/edac.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
@@ -164,6 +165,8 @@ static int __devinit cell_edac_probe(str
 	if (regs == NULL)
 		return -ENODEV;
 
+	edac_op_state = EDAC_OPSTATE_POLL;
+
 	/* Get channel population */
 	reg = in_be64(&regs->mic_mnt_cfg);
 	dev_dbg(&pdev->dev, "MIC_MNT_CFG = 0x%016lx\n", reg);
---

Gruß,

Jens

IBM Deutschland Entwicklung GmbH
Vorsitzender des Aufsichtsrats: Martin Jetter
Geschäftsführung: Erich Baier 
Sitz der Gesellschaft: Böblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

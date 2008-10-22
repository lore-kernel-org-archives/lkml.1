Return-Path: <linux-kernel-owner+w=401wt.eu-S1752167AbYJVBeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167AbYJVBeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 21:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbYJVBeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 21:34:06 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:31186 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751217AbYJVBeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 21:34:05 -0400
Date: Tue, 21 Oct 2008 19:34:03 -0600
From: dougthompson@xmission.com
To: jens@linux.vnet.ibm.com, dougthompson@xmission.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 1/1] edac: fix enabling of polling cell module
Message-ID: <48fe830b.nYXseMIua5Kc2bjK%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

The edac driver on cell turned out to be not enabled because of a missing op_state.
This patch introduces it. Verified to work on top of Bens next branch.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Jens Osterkamp <jens@linux.vnet.ibm.com>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>

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


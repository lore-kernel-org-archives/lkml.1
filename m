Return-Path: <linux-kernel-owner+w=401wt.eu-S1756851AbXFKXJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851AbXFKXJ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 19:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754328AbXFKXIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 19:08:09 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:13352 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753834AbXFKXIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 19:08:05 -0400
Date: Mon, 11 Jun 2007 17:11:23 -0600
From: dougthompson@xmission.com
To: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH 4/5] driver edac mod edac_opt_state_to_string function
Message-ID: <466dd69b.89uG8Kpz3SmXXfSx%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.1 6/15/06
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:   Douglas Thompson <dougthompson@xmission.com>

Refactored the function edac_op_state_toString() to be edac_op_state_to_string()
for consistent style, and its callers

Signed-off-by:  Douglas Thompson <dougthompson@xmission.com>
---
 edac_core.h   |    2 +-
 edac_device.c |    2 +-
 edac_module.c |    4 ++--
 edac_pci.c    |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6.22-rc4-mm2/drivers/edac/edac_core.h
===================================================================
--- linux-2.6.22-rc4-mm2.orig/drivers/edac/edac_core.h
+++ linux-2.6.22-rc4-mm2/drivers/edac/edac_core.h
@@ -845,6 +845,6 @@ extern void edac_pci_remove_sysfs(struct
 /*
  * edac misc APIs
  */
-extern char *edac_op_state_toString(int op_state);
+extern char *edac_op_state_to_string(int op_state);
 
 #endif				/* _EDAC_CORE_H_ */
Index: linux-2.6.22-rc4-mm2/drivers/edac/edac_module.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/drivers/edac/edac_module.c
+++ linux-2.6.22-rc4-mm2/drivers/edac/edac_module.c
@@ -35,9 +35,9 @@ static struct sysdev_class edac_class = 
 static int edac_class_valid;
 
 /*
- * edac_op_state_toString()
+ * edac_op_state_to_string()
  */
-char *edac_op_state_toString(int opstate)
+char *edac_op_state_to_string(int opstate)
 {
 	if (opstate == OP_RUNNING_POLL)
 		return "POLLED";
Index: linux-2.6.22-rc4-mm2/drivers/edac/edac_pci.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/drivers/edac/edac_pci.c
+++ linux-2.6.22-rc4-mm2/drivers/edac/edac_pci.c
@@ -321,7 +321,7 @@ int edac_pci_add_device(struct edac_pci_
 			" DEV '%s' (%s)\n",
 			pci->mod_name,
 			pci->ctl_name,
-			dev_name(pci), edac_op_state_toString(pci->op_state));
+			dev_name(pci), edac_op_state_to_string(pci->op_state));
 
 	edac_unlock_pci_list();
 	return 0;
Index: linux-2.6.22-rc4-mm2/drivers/edac/edac_device.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/drivers/edac/edac_device.c
+++ linux-2.6.22-rc4-mm2/drivers/edac/edac_device.c
@@ -461,7 +461,7 @@ int edac_device_add_device(struct edac_d
 				edac_dev->mod_name,
 				edac_dev->ctl_name,
 				dev_name(edac_dev),
-				edac_op_state_toString(edac_dev->op_state));
+				edac_op_state_to_string(edac_dev->op_state));
 
 	up(&device_ctls_mutex);
 	return 0;

Return-Path: <linux-kernel-owner+w=401wt.eu-S1765606AbXGQX4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765606AbXGQX4Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 19:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757233AbXGQXzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 19:55:55 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:11565 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1762980AbXGQXzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 19:55:53 -0400
Date: Tue, 17 Jul 2007 18:02:34 -0600
From: dougthompson@xmission.com
To: dougthompson@xmission.com, greg@kroah.com, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 1/6] drivers edac code tidying on export-gpl
Message-ID: <469d589a.IvAiQ1QfL5IpY+pE%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.1 6/15/06
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Doug Thompson <dougthompson@xmission.com>

Change EXPORT_SYMBOLs to EXPORT_SYMBOLS_GPL
Tidy changes: blank lines, inline removal, add comment

Signed-off-by:	Doug Thompson <dougthompson@xmission.com>
---

Index: linux-2.6.22-rc6-mm1/drivers/edac/edac_stub.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/drivers/edac/edac_stub.c
+++ linux-2.6.22-rc6-mm1/drivers/edac/edac_stub.c
@@ -15,30 +15,32 @@
 #include <asm/edac.h>
 
 int edac_op_state = EDAC_OPSTATE_INVAL;
-EXPORT_SYMBOL(edac_op_state);
+EXPORT_SYMBOL_GPL(edac_op_state);
 
 atomic_t edac_handlers = ATOMIC_INIT(0);
-EXPORT_SYMBOL(edac_handlers);
+EXPORT_SYMBOL_GPL(edac_handlers);
 
 int edac_err_assert = 0;
-EXPORT_SYMBOL(edac_err_assert);
+EXPORT_SYMBOL_GPL(edac_err_assert);
 
-inline int edac_handler_set(void)
+/*
+ * called to determine if there is an EDAC driver interested in
+ * knowing an event (such as NMI) occurred
+ */
+int edac_handler_set(void)
 {
 	if (edac_op_state == EDAC_OPSTATE_POLL)
 		return 0;
 
 	return atomic_read(&edac_handlers);
 }
-
-EXPORT_SYMBOL(edac_handler_set);
+EXPORT_SYMBOL_GPL(edac_handler_set);
 
 /*
  * handler for NMI type of interrupts to assert error
  */
-inline void edac_atomic_assert_error(void)
+void edac_atomic_assert_error(void)
 {
 	edac_err_assert++;
 }
-
-EXPORT_SYMBOL(edac_atomic_assert_error);
+EXPORT_SYMBOL_GPL(edac_atomic_assert_error);
Index: linux-2.6.22-rc6-mm1/drivers/edac/edac_module.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/drivers/edac/edac_module.c
+++ linux-2.6.22-rc6-mm1/drivers/edac/edac_module.c
@@ -1,12 +1,13 @@
 /*
  * edac_module.c
  *
- * (C) 2007 www.douglaskthompson.com
+ * (C) 2007 www.softwarebitmaker.com
+ *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
  * warranty of any kind, whether express or implied.
  *
- * Author: Doug Thompson <norsk5@xmission.com>
+ * Author: Doug Thompson <dougthompson@xmission.com>
  *
  */
 #include <linux/edac.h>
@@ -14,7 +15,7 @@
 #include "edac_core.h"
 #include "edac_module.h"
 
-#define EDAC_MC_VERSION "Ver: 2.0.5 " __DATE__
+#define EDAC_VERSION "Ver: 2.1.0 " __DATE__
 
 #ifdef CONFIG_EDAC_DEBUG
 /* Values of 0 to 4 will generate output */
@@ -141,7 +142,7 @@ static int __init edac_init(void)
 {
 	int err = 0;
 
-	edac_printk(KERN_INFO, EDAC_MC, EDAC_MC_VERSION "\n");
+	edac_printk(KERN_INFO, EDAC_MC, EDAC_VERSION "\n");
 
 	/*
 	 * Harvest and clear any boot/initialization PCI parity errors

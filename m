Return-Path: <linux-kernel-owner+w=401wt.eu-S1758105AbYHEGre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105AbYHEGre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 02:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbYHEGrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 02:47:20 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:46561 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbYHEGrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 02:47:19 -0400
Date: Tue, 5 Aug 2008 00:26:35 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808050626.m756QZe1003752@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc1-git5 1/26] mdb: add include file references
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Centralized external definitions into include files and corrected 
the file to conform to Linux coding practices.  fixed word wrap
problems with patches.

Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/arch/x86/kernel/reboot.c	2008-08-04 15:53:24.000000000 -0600
+++ b/arch/x86/kernel/reboot.c	2008-08-04 15:59:15.000000000 -0600
@@ -21,6 +21,10 @@
 # include <asm/iommu.h>
 #endif
 
+#ifdef CONFIG_MDB
+#include <linux/mdb.h>
+#endif
+
 /*
  * Power off function, if any
  */
@@ -432,7 +436,15 @@
 	/* O.K Now that I'm on the appropriate processor,
 	 * stop all of the others.
 	 */
+#ifdef CONFIG_MDB
+        // do not stop the other processors if the debugger is active
+        {
+           if (!atomic_read(&inmdb))
+	      smp_send_stop();
+        }
+#else
 	smp_send_stop();
+#endif // CONFIG_MDB
 #endif
 
 	lapic_shutdown();

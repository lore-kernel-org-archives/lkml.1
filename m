Return-Path: <linux-kernel-owner+w=401wt.eu-S1753867AbZIRPBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbZIRPBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 11:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456AbZIRPBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 11:01:17 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:49091 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361AbZIRPBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 11:01:17 -0400
Message-ID: <4AB3A0B6.5010602@austin.ibm.com>
Date: Fri, 18 Sep 2009 10:01:10 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linuxppc-dev@ozlabs.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 2/5 v2] move of_drconf_cell definition to prom.h
References: <4AB39FB3.1020608@austin.ibm.com>
In-Reply-To: <4AB39FB3.1020608@austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the definition of the of_drconf_cell struct from numa.c to prom.h.  This
is needed so that we can parse the ibm,dynamic-memory device-tree property
when DLPAR adding and removing memory.

Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>
---

Index: powerpc/arch/powerpc/include/asm/prom.h
===================================================================
--- powerpc.orig/arch/powerpc/include/asm/prom.h	2009-09-15 14:52:14.000000000 -0500
+++ powerpc/arch/powerpc/include/asm/prom.h	2009-09-15 14:53:26.000000000 -0500
@@ -349,6 +349,18 @@
  */
 extern void __iomem *of_iomap(struct device_node *device, int index);
 
+struct of_drconf_cell {
+	u64	base_addr;
+	u32	drc_index;
+	u32	reserved;
+	u32	aa_index;
+	u32	flags;
+};
+
+#define DRCONF_MEM_ASSIGNED	0x00000008
+#define DRCONF_MEM_AI_INVALID	0x00000040
+#define DRCONF_MEM_RESERVED	0x00000080
+
 /*
  * NB:  This is here while we transition from using asm/prom.h
  * to linux/of.h
Index: powerpc/arch/powerpc/mm/numa.c
===================================================================
--- powerpc.orig/arch/powerpc/mm/numa.c	2009-09-15 14:52:14.000000000 -0500
+++ powerpc/arch/powerpc/mm/numa.c	2009-09-15 14:53:26.000000000 -0500
@@ -296,18 +296,6 @@
 	return result;
 }
 
-struct of_drconf_cell {
-	u64	base_addr;
-	u32	drc_index;
-	u32	reserved;
-	u32	aa_index;
-	u32	flags;
-};
-
-#define DRCONF_MEM_ASSIGNED	0x00000008
-#define DRCONF_MEM_AI_INVALID	0x00000040
-#define DRCONF_MEM_RESERVED	0x00000080
-
 /*
  * Read the next lmb list entry from the ibm,dynamic-memory property
  * and return the information in the provided of_drconf_cell structure.

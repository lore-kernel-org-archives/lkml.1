Return-Path: <linux-kernel-owner+w=401wt.eu-S1756825AbZIKVM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825AbZIKVM3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 17:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756838AbZIKVM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 17:12:28 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:33943 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756831AbZIKVM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 17:12:27 -0400
Message-ID: <4AAABD37.2050205@austin.ibm.com>
Date: Fri, 11 Sep 2009 16:12:23 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linuxppc-dev@ozlabs.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] move of_drconf_cell definition to prom.h
References: <4AAABC55.4070207@austin.ibm.com>
In-Reply-To: <4AAABC55.4070207@austin.ibm.com>
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
--- powerpc.orig/arch/powerpc/include/asm/prom.h	2009-09-11 12:43:39.000000000 -0500
+++ powerpc/arch/powerpc/include/asm/prom.h	2009-09-11 12:52:11.000000000 -0500
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
--- powerpc.orig/arch/powerpc/mm/numa.c	2009-09-11 12:43:39.000000000 -0500
+++ powerpc/arch/powerpc/mm/numa.c	2009-09-11 12:52:11.000000000 -0500
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

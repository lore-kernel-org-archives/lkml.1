Return-Path: <linux-kernel-owner+w=401wt.eu-S933362AbZKXPKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933362AbZKXPKn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 10:10:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933344AbZKXPKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 10:10:06 -0500
Received: from relay2.sgi.com ([192.48.179.30]:45516 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933251AbZKXPHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 10:07:50 -0500
Message-Id: <20091124150756.858937000@sgi.com>
User-Agent: quilt/0.47-1
Date: Tue, 24 Nov 2009 09:06:18 -0600
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 21/29] GRU - Add symbolic names for GRU error code
References: <20091124150557.082648000@sgi.com>
Content-Disposition: inline; filename=uv_gru_error_return_names
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Use symbol names instead of numbers for error return values
for the vtop functions.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/grufault.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

Index: linux/drivers/misc/sgi-gru/grufault.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufault.c	2009-11-20 09:32:35.000000000 -0600
+++ linux/drivers/misc/sgi-gru/grufault.c	2009-11-20 09:32:36.000000000 -0600
@@ -40,6 +40,12 @@
 #include "gru_instructions.h"
 #include <asm/uv/uv_hub.h>
 
+/* Return codes for vtop functions */
+#define VTOP_SUCCESS               0
+#define VTOP_INVALID               -1
+#define VTOP_RETRY                 -2
+
+
 /*
  * Test if a physical address is a valid GRU GSEG address
  */
@@ -280,12 +285,12 @@ static int gru_vtop(struct gru_thread_st
 	paddr = paddr & ~((1UL << ps) - 1);
 	*gpa = uv_soc_phys_ram_to_gpa(paddr);
 	*pageshift = ps;
-	return 0;
+	return VTOP_SUCCESS;
 
 inval:
-	return -1;
+	return VTOP_INVALID;
 upm:
-	return -2;
+	return VTOP_RETRY;
 }
 
 
@@ -412,9 +417,9 @@ static int gru_try_dropin(struct gru_thr
 		goto failactive;
 
 	ret = gru_vtop(gts, vaddr, write, atomic, &gpa, &pageshift);
-	if (ret == -1)
+	if (ret == VTOP_INVALID)
 		goto failinval;
-	if (ret == -2)
+	if (ret == VTOP_RETRY)
 		goto failupm;
 
 	if (!(gts->ts_sizeavail & GRU_SIZEAVAIL(pageshift))) {


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753876AbZKPOTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbZKPOTt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 09:19:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753361AbZKPOTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 09:19:46 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:46565
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753335AbZKPOQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 09:16:24 -0500
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KT7GZ4-02-PZ3-02
X-M-MSG: 
From: Borislav Petkov <borislav.petkov@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <x86@kernel.org>, <norsk5@yahoo.com>
Subject: [PATCH 16/21] edac: add memory types strings for debugging
Date: Mon, 16 Nov 2009 15:16:43 +0100
Message-ID: <1258381008-18783-17-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1258381008-18783-1-git-send-email-borislav.petkov@amd.com>
References: <1258381008-18783-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 16 Nov 2009 14:16:13.0204 (UTC) FILETIME=[5A3E5540:01CA66C7]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using deeply-nested conditionals for dumping the DIMM type in
debug mode, add a strings array of the supported DIMM types.

This is useful in cases where an edac driver supports multiple DRAM
types and is only defined in debug builds.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |    5 +----
 drivers/edac/edac_core.h  |    1 +
 drivers/edac/edac_mc.c    |   24 ++++++++++++++++++++++++
 3 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index c403af2..708d065 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1024,10 +1024,7 @@ static enum mem_type amd64_determine_memory_type(struct amd64_pvt *pvt)
 		type = (pvt->dclr0 & BIT(18)) ? MEM_DDR : MEM_RDDR;
 	}
 
-	debugf1("  Memory type is: %s\n",
-		(type == MEM_DDR2) ? "MEM_DDR2" :
-		(type == MEM_RDDR2) ? "MEM_RDDR2" :
-		(type == MEM_DDR) ? "MEM_DDR" : "MEM_RDDR");
+	debugf1("  Memory type is: %s\n", edac_mem_types[type]);
 
 	return type;
 }
diff --git a/drivers/edac/edac_core.h b/drivers/edac/edac_core.h
index 12f355c..001b2e7 100644
--- a/drivers/edac/edac_core.h
+++ b/drivers/edac/edac_core.h
@@ -74,6 +74,7 @@
 
 #ifdef CONFIG_EDAC_DEBUG
 extern int edac_debug_level;
+extern const char *edac_mem_types[];
 
 #ifndef CONFIG_EDAC_DEBUG_VERBOSE
 #define edac_debug_printk(level, fmt, arg...)                           \
diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index b629c41..3630308 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -76,6 +76,30 @@ static void edac_mc_dump_mci(struct mem_ctl_info *mci)
 	debugf3("\tpvt_info = %p\n\n", mci->pvt_info);
 }
 
+/*
+ * keep those in sync with the enum mem_type
+ */
+const char *edac_mem_types[] = {
+	"Empty csrow",
+	"Reserved csrow type",
+	"Unknown csrow type",
+	"Fast page mode RAM",
+	"Extended data out RAM",
+	"Burst Extended data out RAM",
+	"Single data rate SDRAM",
+	"Registered single data rate SDRAM",
+	"Double data rate SDRAM",
+	"Registered Double data rate SDRAM",
+	"Rambus DRAM",
+	"Unbuffered DDR2 RAM",
+	"Fully buffered DDR2",
+	"Registered DDR2 RAM",
+	"Rambus XDR",
+	"Unbuffered DDR3 RAM",
+	"Registered DDR3 RAM",
+};
+EXPORT_SYMBOL_GPL(edac_mem_types);
+
 #endif				/* CONFIG_EDAC_DEBUG */
 
 /* 'ptr' points to a possibly unaligned item X such that sizeof(X) is 'size'.
-- 
1.6.4.3



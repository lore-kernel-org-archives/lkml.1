Return-Path: <linux-kernel-owner+w=401wt.eu-S1760176AbYGBVVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760176AbYGBVVH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 17:21:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757854AbYGBVSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 17:18:33 -0400
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:50661 "EHLO
	WA2EHSNDR002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753969AbYGBVSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 17:18:31 -0400
X-BigFish: VPS30(z1857rz1fa4Lzz10d3izzz32i87il43j)
X-FB-OUTBOUND-SPAM: yes
X-SpamScore: 30
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K3EDU3-01-1X4-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 07/11] x86/pci: mp_bus_to_node merge: moving code in amd_bus.c
Date: Wed, 2 Jul 2008 22:50:25 +0200
Message-ID: <1215031829-29124-8-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1215031829-29124-1-git-send-email-robert.richter@amd.com>
References: <1215031829-29124-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 02 Jul 2008 21:17:56.0146 (UTC) FILETIME=[189A6120:01C8DC89]
MIME-Version: 1.0
Content-Type: text/plain
Reply-To: <rrichter@elbe.amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/pci/amd_bus.c |   42 +++++++++++++++++++++---------------------
 1 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index 15f505d..aa3a190 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -14,27 +14,6 @@
  * also get peer root bus resource for io,mmio
  */
 
-
-/*
- * sub bus (transparent) will use entres from 3 to store extra from root,
- * so need to make sure have enought slot there, increase PCI_BUS_NUM_RESOURCES?
- */
-#define RES_NUM 16
-struct pci_root_info {
-	char name[12];
-	unsigned int res_num;
-	struct resource res[RES_NUM];
-	int bus_min;
-	int bus_max;
-	int node;
-	int link;
-};
-
-/* 4 at this time, it may become to 32 */
-#define PCI_ROOT_NR 4
-static int pci_root_num;
-static struct pci_root_info pci_root_info[PCI_ROOT_NR];
-
 #ifdef CONFIG_NUMA
 
 #define BUS_NR 256
@@ -65,8 +44,29 @@ int get_mp_bus_to_node(int busnum)
 
 	return node;
 }
+
 #endif
 
+/*
+ * sub bus (transparent) will use entres from 3 to store extra from root,
+ * so need to make sure have enought slot there, increase PCI_BUS_NUM_RESOURCES?
+ */
+#define RES_NUM 16
+struct pci_root_info {
+	char name[12];
+	unsigned int res_num;
+	struct resource res[RES_NUM];
+	int bus_min;
+	int bus_max;
+	int node;
+	int link;
+};
+
+/* 4 at this time, it may become to 32 */
+#define PCI_ROOT_NR 4
+static int pci_root_num;
+static struct pci_root_info pci_root_info[PCI_ROOT_NR];
+
 void set_pci_bus_resources_arch_default(struct pci_bus *b)
 {
 	int i;
-- 
1.5.5.4


